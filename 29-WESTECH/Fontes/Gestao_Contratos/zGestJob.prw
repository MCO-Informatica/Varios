#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"


//����������������������������������������������������������������������������// 
//                        Low Intensity colors 
//����������������������������������������������������������������������������// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//����������������������������������������������������������������������������// 
//                      High Intensity Colors 
//����������������������������������������������������������������������������// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera arquivo de Gestao de Contratos                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico 		                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
user function zGestJob()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database

local cQCZZM := ""
local cQCZZN := ""
local cQCZZN2 := ""
local cForZZN	:= "ALLTRIM(QUERYZZN->ZZN_ITEMCT) == _cItemConta"

private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := CTD->CTD_ITEM
private _nPComiss 	:= CTD->CTD_XPCOM
private _nXSISFV 	:= CTD->CTD_XSISFV

private _xCTCT 		:= CTD->CTD_XCTCT
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)
private cArqTrb5 := CriaTrab(NIL,.F.)
private cArqTrb6 := CriaTrab(NIL,.F.)
private cArqTrb7 := CriaTrab(NIL,.F.)
private cArqTrb8 := CriaTrab(NIL,.F.)
private cArqTrb9 := CriaTrab(NIL,.F.)
private cArqTrb10 := CriaTrab(NIL,.F.)
private cArqTrb11 := CriaTrab(NIL,.F.)
private cArqTrb12 := CriaTrab(NIL,.F.)
private cArqTrb13 := CriaTrab(NIL,.F.)
private cArqTrb14 := CriaTrab(NIL,.F.)
private cArqTrb15 := CriaTrab(NIL,.F.)

private oGet6
private nGet6	:= SZC->ZC_UNITR

private oGet4
private nGet4	:= SZC->ZC_QUANTR

private oGet7
private nGet7	:= SZC->ZC_TOTALR

private oTree
private aNodes
Private _aGrpSint:= {}

private nTotRegZZM := 0
private nTotRegZZN := 0

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	_cItemConta 	:= CTD->CTD_ITEM

	pergunte(cPerg,.F.)

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	cQCZZN2 := " SELECT DISTINCT ZZN_PL FROM ZZN010 WHERE ZZN_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
	TCQuery cQCZZN2 New Alias "TZZNG2"
	TZZNG2->(DbGoTop())
	cPlan := TZZNG2->ZZN_PL

	//MsgInfo (cPlan)

	//**********************************************************//
	//cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "

		if cPlan = "P1"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P2"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC2 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P3"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC3 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P4"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC4 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P5" 
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC5 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P6"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC6 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P7"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC7 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		elseif cPlan = "P8"
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMC8 = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		eLSE
			cQCZZM := " SELECT * FROM ZZM010 WHERE ZZM_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		endif

	TCQuery cQCZZM New Alias "TZZMG"
	Count To nTotRegZZM
    TZZMG->(DbGoTop())

	IF nTotRegZZM > 0
		MSAguarde({||VendSLC()},"Processando Vendido ")
		//msginfo( "VendSLC")
	else
		MSAguarde({||VEND02()},"Processando Vendido ")
		//msginfo( "Venda Antigo")
	ENDIF
	TZZMG->(dbclosearea())
	
	//**********************************************************//
	cQCZZN := " SELECT * FROM ZZN010 WHERE ZZN_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*'"
	TCQuery cQCZZN New Alias "TZZNG"
	Count To nTotRegZZN
    TZZNG->(DbGoTop())

	IF nTotRegZZN > 0
		MSAguarde({||PlanSLC()},"Processando Planejamento de Contrato...... ")
	else
		if alltrim(substr(_cItemConta,1,2)) == "PR" .OR. alltrim(substr(_cItemConta,1,2)) == "AT" .OR. alltrim(substr(_cItemConta,1,2)) == "CM" .OR. ;
					alltrim(substr(_cItemConta,1,2)) == "EN" .OR. alltrim(substr(_cItemConta,1,2)) == "GR" .OR. _xCTCT == "N3" 
			MSAguarde({||PLANEJ03()},"Processando Planejamento de Contrato...... ")
		//	MSAguarde({||VEND01()},"Processando Vendido (PR/AT/EN/GR)")
		else
			MSAguarde({||PLANEJ02()},"Processando Planejamento de Contrato... ")	
		endif
	ENDIF
	TZZNG->(dbclosearea())
	//**********************************************************//

	MSAguarde({||PFIN01REAL()},"Processando Ordem de Compra")

	MSAguarde({||D101REAL()},"Processando Documento de Entrada")

	MSAguarde({||DE01REAL()},"Processando Rateio Documento de Entrada")

	MSAguarde({||FIN01REAL()},"Processando Financeiro")

	MSAguarde({||CV401REAL()},"Processando Financeiro Rateio")
	
	MSAguarde({||HR01REAL()},"Processando Apontamento de Horas")

	MSAguarde({||CUDIV01REAL()},"Processando Custos Diversos ")

	MSAguarde({||CT401REAL()},"Processando Custo Contabil")

	MSAguarde({||CT401EST()},"Processando Estoque Contabil")
	
	MSAguarde({||CT401REC()},"Processando Receita Contabil")
	
	MSAguarde({||zFaturSD2()},"Processando Faturamneto Realizado")
	
	MSAguarde({||zFaturSZQ()},"Processando Faturamneto Planejado")
	
	MSAguarde({||zRecSE5()},"Processando Recebimento Realizado")
	
	MSAguarde({||zRecSE1()},"Processando Recebimento Planejado")
	
	MSAguarde({||zPagSE2()},"Processando Contas a Pagar Planejado")
	
	MSAguarde({||zDetCom()},"Processando Comissoes")
	
	MSAguarde({||zSolSC1()},"Processando Solicitacoes de Compra")
	
	MSAguarde({||zPEDSC7()},"Processando Pedido de Compra")
	
	MSAguarde({||zOrdPrSC2()},"Processando Ordem de Producao")
	
	MSAguarde({||zOrdPrSD3()},"Processando Detalhamento Ordem de Producao")
	
	MSAguarde({||GC01SINT()},"Gerando arquivo sintetico.") // *** Funcao de gravacao do arquivo sintetico ***
	
	MontaTela()

	TRB1->(dbclosearea())
	TRB11->(dbclosearea())
	TRB2->(dbclosearea())
	TRB4->(dbclosearea())
	TRB5->(dbclosearea())
	TRB6->(dbclosearea())
	TRB7->(dbclosearea())
	TRB8->(dbclosearea())
	TRB9->(dbclosearea())
	TRB10->(dbclosearea())
	TRB12->(dbclosearea())
	TRB13->(dbclosearea())
	TRB14->(dbclosearea())
	TRB15->(dbclosearea())
	TZZNG2->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido slc																				              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function VendSLC()
	local _cQuery := ""
	Local _cFilZZM := xFilial("ZZM")
	local cPlan := ""
	local cFor := ""
	local cForZZN	:= "ALLTRIM(QUERYZZN->ZZN_ITEMCT) == _cItemConta"
	local cPlan		:= ""
	local cICta		:= ""
	ZZM->(dbsetorder(2))


	ChkFile("ZZN",.F.,"QUERYZZN")
	IndRegua("QUERYZZN",CriaTrab(NIL,.F.),"ZZN_FILIAL+ZZN_ITEMCT",,cForZZN,"Selecionando Registros...")
	ProcRegua(QUERYZZN->(reccount()))
	cPlan := QUERYZZN->ZZN_PL

	//msginfo( "teste 3")

	ChkFile("ZZM",.F.,"QUERY")
	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
	
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7' " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")
		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")
		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")
		elseif cPlan = "P5" 

			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) $ '1/3/5/6/7'" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif
	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()

		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "101"
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "102"
			TRB1->IDUSA		:= "102"
			TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)== "103"
			TRB1->IDUSA		:= "103"
			TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)== "104"
			TRB1->IDUSA		:= "104"
			TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "105"
			TRB1->IDUSA		:= "105"
			TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "106"
			TRB1->IDUSA		:= "106"
			TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "107"
			TRB1->IDUSA		:= "107"
			TRB1->DESCUSA	:= "INSTRUMENTACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "108"
			TRB1->IDUSA		:= "108"
			TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "109"
			TRB1->IDUSA		:= "109"
			TRB1->DESCUSA	:= "FRETE INTERNO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "301"
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "501"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "601"
			TRB1->IDUSA		:= "601"
			TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "701"
			TRB1->IDUSA		:= "701"
			TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
		endif

		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		
		if LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "1" .AND. QUERY->ZZM_TOTAL > 0
			
				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1
					TRB1->VALOR		:= QUERY->ZZM_TOTP1
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2
					TRB1->VALOR		:= QUERY->ZZM_TOTP2
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3
					TRB1->VALOR		:= QUERY->ZZM_TOTP3
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4
					TRB1->VALOR		:= QUERY->ZZM_TOTP4
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5
					TRB1->VALOR		:= QUERY->ZZM_TOTP5
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6
					TRB1->VALOR		:= QUERY->ZZM_TOTP6
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7
					TRB1->VALOR		:= QUERY->ZZM_TOTP7
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8
					TRB1->VALOR		:= QUERY->ZZM_TOTP8
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT
					TRB1->VALOR		:= QUERY->ZZM_TOTAL
					TRB1->VALOR2	:= QUERY->ZZM_TOTAL
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif

				//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT
			//TRB1->VALOR		:= QUERY->ZZM_TOTAL
			//TRB1->VALOR2	:= QUERY->ZZM_TOTAL


		ELSEIF LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "2" .AND. QUERY->ZZM_TOTLB > 0
			//TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
			//TRB1->VALOR		:= QUERY->ZZM_TOTLB
			//TRB1->VALOR2	:= QUERY->ZZM_TOTLB

				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1L
					TRB1->VALOR		:= QUERY->ZZM_TOTP1L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2L
					TRB1->VALOR		:= QUERY->ZZM_TOTP2L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3L
					TRB1->VALOR		:= QUERY->ZZM_TOTP3L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4L
					TRB1->VALOR		:= QUERY->ZZM_TOTP4L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5L
					TRB1->VALOR		:= QUERY->ZZM_TOTP5L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6L
					TRB1->VALOR		:= QUERY->ZZM_TOTP6L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7L
					TRB1->VALOR		:= QUERY->ZZM_TOTP7L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8L
					TRB1->VALOR		:= QUERY->ZZM_TOTP8L
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8L
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
					TRB1->VALOR		:= QUERY->ZZM_TOTLB
					TRB1->VALOR2	:= QUERY->ZZM_TOTLB
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif
				//TRB1->QUANTIDADE:= QUERY->ZZM_QTDLB
			//TRB1->VALOR		:= QUERY->ZZM_TOTLB
			//TRB1->VALOR2	:= QUERY->ZZM_TOTLB

		ELSEIF LEN(QUERY->ZZM_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),5,1) = "3" .AND. QUERY->ZZM_TOTEF > 0
			//TRB1->QUANTIDADE:= QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTEF
			//TRB1->VALOR2	:= QUERY->ZZM_TOTEF
				if cPlan = "P1"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP1E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP1E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP2E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP2E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP2E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC1
				elseif cPlan = "P3"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP3E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP3E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP3E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P4"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP4E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP4E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP4E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP5E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP5E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP5E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP6E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP6E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP6E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP7E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP7E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP7E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP8E
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTP8E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP8E
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDEF
					TRB2->VVUNITEF	:= QUERY->ZZM_TOTEF
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB1->ITEMCONTA	:= QUERY->ZZM_TOTEF
				endif
				//TRB1->QUANTIDADE:= QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTEF
			//TRB1->VALOR2	:= QUERY->ZZM_TOTEF
		ENDIF

		
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo
	//*********** GRUPOS 200

	//cFor := "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0"
	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC2
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")

		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC3
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")

		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC4
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")

		elseif cPlan = "P5" 
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZM_GRUPO,1,1) = '2' .AND. QUERY->ZZM_TOTGR > 0" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif
	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()

		if alltrim(QUERY->ZZM_GRUPO) = "200"
			QUERY->(dbskip())
			loop
		endif
		
		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		endif
		
		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		if  QUERY->ZZM_TOTGR > 0 .AND. QUERY->ZZM_GRUPO <> "200"
			
			if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1 + QUERY->ZZM_QTDP1L + QUERY->ZZM_QTDP1E
					TRB1->VALOR		:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2 + QUERY->ZZM_QTDP2L + QUERY->ZZM_QTDP2E
					TRB1->VALOR		:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3 + QUERY->ZZM_QTDP3L + QUERY->ZZM_QTDP3E
					TRB1->VALOR		:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4 + QUERY->ZZM_QTDP4L + QUERY->ZZM_QTDP4E
					TRB1->VALOR		:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5 + QUERY->ZZM_QTDP5L + QUERY->ZZM_QTDP5E
					TRB1->VALOR		:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6 + QUERY->ZZM_QTDP6L + QUERY->ZZM_QTDP6E
					TRB1->VALOR		:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7 + QUERY->ZZM_QTDP7L + QUERY->ZZM_QTDP7E
					TRB1->VALOR		:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8 + QUERY->ZZM_QTDP8L + QUERY->ZZM_QTDP8E
					TRB1->VALOR		:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
					TRB1->VALOR		:= QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif

				//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
			//TRB1->VALOR		:= QUERY->ZZM_TOTGR
			//TRB1->VALOR2	:= QUERY->ZZM_TOTGR
		ENDIF

		//TRB1->ITEMCONTA		:= QUERY->ZZM_ITEMCT
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	//*********** GRUPOS 801/900/901/902/903/904/905/906/908
	//cFor := "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') .AND. QUERY->ZZM_TOTGR > 0 "

	//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")
			
		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC2
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")

		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC3
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")

		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC4
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")

		elseif cPlan = "P5" 
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') " //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif

	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())
	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZM_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()
		
		if SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3) == "801"
			TRB1->IDUSA		:= "801"
			TRB1->DESCUSA	:= "CONTINGENCIAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "900"
			TRB1->IDUSA		:= "900"
			TRB1->DESCUSA	:= "OUTROS ITENS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "901"
			TRB1->IDUSA		:= "901"
			TRB1->DESCUSA	:= "TRIBUTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "902"
			TRB1->IDUSA		:= "902"
			TRB1->DESCUSA	:= "OBRIGACOES / CARTA DE CREDITO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "903"
			TRB1->IDUSA		:= "903"
			TRB1->DESCUSA	:= "TAXAS DE PATENTE / LICENCA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "904"
			TRB1->IDUSA		:= "904"
			TRB1->DESCUSA	:= "STANDBY LETTER OF CREDIT / BOUNDS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "905"
			TRB1->IDUSA		:= "905"
			TRB1->DESCUSA	:= "FRETE PRE-PAGO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  == "906"
			TRB1->IDUSA		:= "906"
			TRB1->DESCUSA	:= "OUTROS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZM_GRUPO),1,3)  = "908"
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		endif
		
		TRB1->ORIGEM 		:= "VD"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZM_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZM_ITEM

		if  QUERY->ZZM_TOTGR > 0 .AND. alltrim(QUERY->ZZM_GRUPO) $ ('801/900/901/902/903/904/905/906/908') 
				//msginfo("teste 1")
				if cPlan = "P1"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP1 + QUERY->ZZM_QTDP1L + QUERY->ZZM_QTDP1E
					TRB1->VALOR		:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
					//msginfo("teste 2")
				elseif cPlan = "P2"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP2 + QUERY->ZZM_QTDP2L + QUERY->ZZM_QTDP2E
					TRB1->VALOR		:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC2
				elseif cPlan = "P3"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP3 + QUERY->ZZM_QTDP3L + QUERY->ZZM_QTDP3E
					TRB1->VALOR		:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC3
				elseif cPlan = "P4"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP4 + QUERY->ZZM_QTDP4L + QUERY->ZZM_QTDP4E
					TRB1->VALOR		:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC4
				elseif cPlan = "P5"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP5 + QUERY->ZZM_QTDP5L + QUERY->ZZM_QTDP5E
					TRB1->VALOR		:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC5
				elseif cPlan = "P6"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP6 + QUERY->ZZM_QTDP6L + QUERY->ZZM_QTDP6E
					TRB1->VALOR		:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC6
				elseif cPlan = "P7"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP7 + QUERY->ZZM_QTDP7L + QUERY->ZZM_QTDP7E
					TRB1->VALOR		:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC7
				elseif cPlan = "P8"
					TRB1->QUANTIDADE:= QUERY->ZZM_QTDP8 + QUERY->ZZM_QTDP8L + QUERY->ZZM_QTDP8E
					TRB1->VALOR		:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->VALOR2	:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMC8
				else
					TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
					TRB1->VALOR		:= QUERY->ZZM_TOTAL + QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF 
					TRB1->VALOR2	:= QUERY->ZZM_TOTAL + QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF
					TRB1->ITEMCONTA	:= QUERY->ZZM_ITEMCT
				endif
		endif
		//TRB1->QUANTIDADE:= QUERY->ZZM_QUANT + QUERY->ZZM_QTDLB + QUERY->ZZM_QTDEF
		//TRB1->VALOR		:= QUERY->ZZM_TOTGR
		//TRB1->VALOR2	:= QUERY->ZZM_TOTGR

		//TRB1->ITEMCONTA		:= QUERY->ZZM_ITEMCT
		TRB1->CAMPO			:= "VLRVD"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	QUERY->(dbclosearea())
	QUERYZZN->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa planejado slc																				              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function PlanSLC()
	local _cQuery := ""
	Local _cFilZZN := xFilial("ZZN")
	local cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. QUERY->ZZN_GS = 'S' .AND. QUERY->ZZN_TOTGR > 0 .AND. substr(alltrim(QUERY->ZZN_GRUPO),1,3) $ ('101/102/103/104/105/106/107/108/109/301/501/601/701')" //
	ZZN->(dbsetorder(2))

	ChkFile("ZZN",.F.,"QUERY")
	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()

		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "101"
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "102"
			TRB1->IDUSA		:= "102"
			TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)== "103"
			TRB1->IDUSA		:= "103"
			TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)== "104"
			TRB1->IDUSA		:= "104"
			TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "105"
			TRB1->IDUSA		:= "105"
			TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "106"
			TRB1->IDUSA		:= "106"
			TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "107"
			TRB1->IDUSA		:= "107"
			TRB1->DESCUSA	:= "INSTRUMENTACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "108"
			TRB1->IDUSA		:= "108"
			TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "109"
			TRB1->IDUSA		:= "109"
			TRB1->DESCUSA	:= "FRETE INTERNO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "301"
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "501"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "601"
			TRB1->IDUSA		:= "601"
			TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "701"
			TRB1->IDUSA		:= "701"
			TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
		endif

		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		if LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "1" .AND. QUERY->ZZN_TOTAL > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QUANT
			TRB1->VALOR		:= QUERY->ZZN_TOTAL
			TRB1->VALOR2	:= QUERY->ZZN_TOTAL
		ELSEIF LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "2" .AND. QUERY->ZZN_TOTLB > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QTDLB
			TRB1->VALOR		:= QUERY->ZZN_TOTLB
			TRB1->VALOR2	:= QUERY->ZZN_TOTLB
		ELSEIF LEN(QUERY->ZZN_GRUPO) > 3 .AND. SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),5,1) = "3" .AND. QUERY->ZZN_TOTEF > 0
			TRB1->QUANTIDADE:= QUERY->ZZN_QTDEF
			TRB1->VALOR		:= QUERY->ZZN_TOTEF
			TRB1->VALOR2	:= QUERY->ZZN_TOTEF
		ENDIF

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo
	//*********** GRUPOS 200
	cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. SUBSTR(QUERY->ZZN_GRUPO,1,1) = '2' .AND. QUERY->ZZN_TOTGR > 0"

	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()

		if alltrim(QUERY->ZZN_GRUPO) = "200"
			QUERY->(dbskip())
			loop
		endif
		
		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "201"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "202"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "204"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "205"
			TRB1->IDUSA		:= "205"
			TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "206"
			TRB1->IDUSA		:= "206"
			TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "207"
			TRB1->IDUSA		:= "207"
			TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "210"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "211"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "212"
			TRB1->IDUSA		:= "212"
			TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "213"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "217"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "218"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "220"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "221"
			TRB1->IDUSA		:= "221"
			TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "222"
			TRB1->IDUSA		:= "222"
			TRB1->DESCUSA	:= "PROGRAMACAO PLC"
		endif
		
		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		if  QUERY->ZZN_TOTGR > 0 .AND. QUERY->ZZN_GRUPO <> "200"
			TRB1->QUANTIDADE:= QUERY->ZZN_QUANT + QUERY->ZZN_QTDLB + QUERY->ZZN_QTDEF
			TRB1->VALOR		:= QUERY->ZZN_TOTGR
			TRB1->VALOR2	:= QUERY->ZZN_TOTGR
		ENDIF

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	//*********** GRUPOS 801/900/901/902/903/904/905/906/908
	cFor := "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta .AND. alltrim(QUERY->ZZN_GRUPO) $ ('801/900/901/902/903/904/905/906/908')  "

	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_ITEMCT",,cFor,"Selecionando Registros...")

	ProcRegua(QUERY->(reccount()))

	QUERY->(dbgotop())

	while QUERY->(!eof())

		RecLock("TRB1",.T.)

		IncProc("Processando registro: "+alltrim(QUERY->ZZN_GRUPO))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()
		
		if SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3) == "801"
			TRB1->IDUSA		:= "801"
			TRB1->DESCUSA	:= "CONTINGENCIAS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "900"
			TRB1->IDUSA		:= "900"
			TRB1->DESCUSA	:= "OUTROS ITENS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "901"
			TRB1->IDUSA		:= "901"
			TRB1->DESCUSA	:= "TRIBUTOS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "902"
			TRB1->IDUSA		:= "902"
			TRB1->DESCUSA	:= "OBRIGACOES / CARTA DE CREDITO"
		Elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "903"
			TRB1->IDUSA		:= "903"
			TRB1->DESCUSA	:= "TAXAS DE PATENTE / LICENCA"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "904"
			TRB1->IDUSA		:= "904"
			TRB1->DESCUSA	:= "STANDBY LETTER OF CREDIT / BOUNDS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "905"
			TRB1->IDUSA		:= "905"
			TRB1->DESCUSA	:= "FRETE PRE-PAGO"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "906"
			TRB1->IDUSA		:= "906"
			TRB1->DESCUSA	:= "OUTROS"
		elseif SUBSTR(ALLTRIM(QUERY->ZZN_GRUPO),1,3)  == "908"
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		endif
		
		TRB1->ORIGEM 		:= "PL"
		TRB1->NUMERO 		:= ALLTRIM(QUERY->ZZN_GRUPO)
		TRB1->HISTORICO 	:=  QUERY->ZZN_ITEM

		TRB1->QUANTIDADE:= QUERY->ZZN_QUANT + QUERY->ZZN_QTDLB + QUERY->ZZN_QTDEF
		TRB1->VALOR		:= QUERY->ZZN_TOTGR
		TRB1->VALOR2	:= QUERY->ZZN_TOTGR

		TRB1->ITEMCONTA		:= QUERY->ZZN_ITEMCT
		TRB1->CAMPO			:= "VLRPLN"

		MsUnlock()

		QUERY->(dbskip())

	enddo

	QUERY->(dbclosearea())
	
	

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido 01 Percas					              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function VEND01()

local _cQuery := ""
Local _cFilSZG := xFilial("SZG")
local cFor := "ALLTRIM(QUERY->ZG_ITEMIC) == _cItemConta"
SZG->(dbsetorder(3))

ChkFile("SZG",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZG_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZG_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		IncProc("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
		ProcessMessage()

		TRB1->TIPO		:= "N2"
		TRB1->NUMERO	:= QUERY->ZG_IDVDSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		

		if empty(QUERY->ZG_GRUSA)
			if alltrim(QUERY->ZG_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
			elseif alltrim(QUERY->ZG_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
			elseif alltrim(QUERY->ZG_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
			elseif alltrim(QUERY->ZG_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
			elseif alltrim(QUERY->ZG_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
			elseif alltrim(QUERY->ZG_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
			elseif alltrim(QUERY->ZG_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
			elseif alltrim(QUERY->ZG_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZG_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
			elseif alltrim(QUERY->ZG_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
			elseif alltrim(QUERY->ZG_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
			elseif alltrim(QUERY->ZG_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
			endif
		endif

		TRB1->PRODUTO		:= ""
		TRB1->QUANTIDADE	:= QUERY->ZG_QUANT
		TRB1->UNIDADE		:= QUERY->ZG_UM
		TRB1->HISTORICO		:= QUERY->ZG_DESCRI
		TRB1->VALOR			:= QUERY->ZG_TOTAL

		TRB1->ORIGEM		:= "VD"
		TRB1->ITEMCONTA 	:= QUERY->ZG_ITEMIC
		TRB1->CAMPO		 	:= "VLRVD"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Vendido 01 Equipamento / Sistema	              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function VEND02()

local _cQuery := ""
Local _cFilSZP := xFilial("SZP")
Local cIDSZF := ""
Local cIDSZG := ""
Local cIDSZP := ""

Local nQTDSZF := 0
Local nQTDSZG := 0 
Local nQTDSZP := 0

Local nQTSZG := 0

Local cDescSZP := ""
Local cDescSZG := ""
local cFor := "ALLTRIM(QUERY->ZP_ITEMIC) == _cItemConta"

Local aInd:={}
Local cCondicao
Local bFiltraBrw

dbSelectArea("SZF")
SZF->( dbSetOrder(1)) 
SZF->(dbgotop())

dbSelectArea("SZG")
SZG->( dbSetOrder(1))
SZG->(dbgotop())
 
SZP->(dbsetorder(3))

ChkFile("SZP",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZP_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZP_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZP_IDVDSUB))
		ProcessMessage()

		TRB1->TIPO		:= "N3"
		TRB1->NUMERO	:= QUERY->ZP_IDVDSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZP_GRUSA))
			if alltrim(QUERY->ZP_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZP_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZP_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZP_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZP_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZP_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZP_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZP_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZP_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZP_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZP_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZP_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZP_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZP_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZP_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZP_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZP_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZP_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZP_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZP_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZP_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif
		
		cIDSZP := alltrim(QUERY->ZP_IDVDSUB)
		cDescSZP := alltrim(QUERY->ZP_DESCRI)
		
		dbSelectArea("SZG")
		SZG->( dbSetOrder(1))
		SZG->(dbgotop())
		
		//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
		cCondicao:= "ALLTRIM(SZG->ZG_ITEMIC) == _cItemConta  "
		bFiltraBrw := {|| FilBrowse("SZG",@aInd,@cCondicao) }
		Eval(bFiltraBrw)
		
		While SZG->(!eof())	
		
			if cIDSZP == alltrim(SZG->ZG_IDVDSUB)
				nQTSZG := SZG->ZG_QUANT //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
			
				cDescSZG := ALLTRIM(SZG->ZG_DESCRI) + " <-> " + cDescSZP  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
				TRB1->UNIDADE		:= QUERY->ZP_UM
				exit
			endif
			SZG->(dbskip())
		
		enddo
		TRB1->HISTORICO		:= cDescSZG 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZG
		TRB1->VALOR			:= (QUERY->ZP_TOTAL * nQTSZG)

		TRB1->PRODUTO		:= ""
		//TRB1->QUANTIDADE	:= QUERY->ZP_QUANT
		//TRB1->UNIDADE		:= QUERY->ZP_UM
		//TRB1->HISTORICO		:= QUERY->ZP_DESCRI
		//TRB1->VALOR			:= (QUERY->ZP_TOTAL*nQTDSZG) //*nQTDSZF

		TRB1->ORIGEM		:= "VD"
		TRB1->ITEMCONTA 	:= QUERY->ZP_ITEMIC
		TRB1->CAMPO		 	:= "VLRVD"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZF->(dbclosearea())
SZG->(dbclosearea())
SZP->(dbclosearea())
return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ01()

local _cQuery := ""
Local _cFilSZD := xFilial("SZD")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0

local cFor := "ALLTRIM(QUERY->ZD_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 

SZD->(dbsetorder(2))

ChkFile("SZD",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZD_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZD_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZD_IDPLSUB))
		ProcessMessage()

		TRB1->TIPO		:= "N2"
		TRB1->NUMERO	:= QUERY->ZD_IDPLSUB
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"

		if alltrim(QUERY->ZD_GRUPO) == "MPR"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(QUERY->ZD_GRUPO) == "FAB"
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(QUERY->ZD_GRUPO) == "COM"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(QUERY->ZD_GRUPO) == "SRV"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(QUERY->ZG_GRUPO) == "ESL"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif alltrim(QUERY->ZD_GRUPO) == "EBR"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
		elseif alltrim(QUERY->ZD_GRUPO) == "CTR"
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
		elseif alltrim(QUERY->ZD_GRUPO) == "IDL"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
		/*elseif alltrim(QUERY->ZD_GRUPO) == "FIN"
			TRB1->ID		:= "FIN"
			TRB1->DESCRICAO	:= "FINANCEIRO"*/
		elseif alltrim(QUERY->ZD_GRUPO) == "CMS"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif alltrim(QUERY->ZD_GRUPO) == "RDV"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		elseif alltrim(QUERY->ZD_GRUPO) == "FRT"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		elseif alltrim(QUERY->ZD_GRUPO) == "CDV"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
		endif
		
		cIDSZP := QUERY->ZP_IDVDSUB
		while SZG->(!eof()) //.AND. SZG->ZG_IDVDSUB <> ALLTRIM(cIDSZP) .AND. SZG->ZG_ITEMIC <> alltrim(_cItemConta)
			
			if ALLTRIM(SZG->ZG_IDVDSUB) == ALLTRIM(cIDSZP) .AND. ALLTRIM(SZG->ZG_ITEMIC) == alltrim(_cItemConta)
				nQTDSZG := SZG->ZG_QUANT
				cIDSZG := SZG->ZG_IDVEND
				
				while SZF->(!eof()) //.AND. SZF->ZF_IDVEND <> ALLTRIM(cIDSZG) .AND. SZF->ZF_ITEMIC <> alltrim(_cItemConta)
					
					if ALLTRIM(SZF->ZF_IDVEND) == ALLTRIM(cIDSZG) .AND. ALLTRIM(SZF->ZF_ITEMIC) == alltrim(_cItemConta)
						nQTDSZF := SZF->ZF_QUANT
					endif
					SZF->(dbSkip())
				enddo
				
			endif
			SZG->(dbSkip())
		enddo

		TRB1->PRODUTO		:= ""
		TRB1->QUANTIDADE	:= QUERY->ZD_QUANTR
		TRB1->UNIDADE		:= QUERY->ZD_UMR
		TRB1->HISTORICO		:= QUERY->ZD_DESCRI
		TRB1->VALOR			:= QUERY->ZD_TOTALR

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZD_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ02()

local _cQuery := ""
Local _cFilSZO := xFilial("SZU")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw
 
 Local aInd2:={}
 Local cCondicao2
 Local bFiltraBrw2
 
 Local aInd3:={}
 Local cCondicao3
 Local bFiltraBrw3
 
 local cFor := "ALLTRIM(QUERY->ZU_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(2))
SZU->(dbgotop())

ChkFile("SZU",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZU_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZU_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZU_IDPLSB2))
		ProcessMessage()

		TRB1->TIPO		:= "N4"
		//TRB1->NUMERO	:= QUERY->ZO_IDPLSB2
		TRB1->NUMERO	:= QUERY->ZU_IDPLSB2
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZU_GRUSA))
			if alltrim(QUERY->ZU_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZU_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZU_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZU_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZU_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZU_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZU_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZU_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZU_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZU_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZU_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZU_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZU_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZU_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZU_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZU_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZU_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZU_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZU_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZU_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZU_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZU_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif
				
		cIDSZU 		:= alltrim(QUERY->ZU_IDPLSB2)
		cDescSZU	:= alltrim(QUERY->ZU_DESCRI)
		
		dbSelectArea("SZO")
		SZO->( dbSetOrder(3))
		SZO->(dbgotop())
		
		cCondicao2:= "ALLTRIM(SZO->ZO_ITEMIC) == _cItemConta  "
		bFiltraBrw2 := {|| FilBrowse("SZO",@aInd2,@cCondicao2) }
		Eval(bFiltraBrw2)
		
		While SZO->(!eof())	
			if cIDSZU == alltrim(SZO->ZO_IDPLSB2)
				nQTSZO 		:= SZO->ZO_QUANTR
				cIDSZO		:= alltrim(SZO->ZO_IDPLSUB)
				cDescSZO 	:= "(" + cValtoChar(nQTSZO) + ") " + ALLTRIM(SZO->ZO_DESCRI)  + " <-> " + cDescSZU
				exit 
			endif
			SZO->(dbskip())
		enddo
		
		//*********************
		
		cCondicao3:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
		bFiltraBrw3 := {|| FilBrowse("SZD",@aInd3,@cCondicao3) }
		Eval(bFiltraBrw3)
		
		//msginfo (cValtoChar(nQTSZO) + " " + cIDSZO )
		dbSelectArea("SZD")
		SZD->( dbSetOrder(1))
		SZD->(dbgotop())
		While SZD->(!eof())
			if cIDSZO == alltrim(SZD->ZD_IDPLSUB)
				nQTSZD 		:= SZD->ZD_QUANTR
				cDescSZD 	:= "(" + cValtoChar(nQTSZD) + ") " + ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //+ " <-> " + cDescSZU
				exit
			endif
			SZD->(dbskip())
		enddo
		
		TRB1->HISTORICO		:= cDescSZD 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZD
		TRB1->VALOR			:= (QUERY->ZU_TOTALR * nQTSZO) * nQTSZD

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZU_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Plajemento							              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PLANEJ03()

local _cQuery := ""
Local _cFilSZO := xFilial("SZO")

Local cIDSZC := ""
Local cIDSZD := ""
Local cIDSZO := ""
Local cIDSZU := ""

Local nQTDSZC := 0
Local nQTDSZD := 0
Local nQTDSZO := 0
Local nQTDSZU := 0

Local nQTSZD := 0
Local nQTSZO := 0
Local nQTSZU := 0

Local cDescSZO := ""
Local cDescSZD := ""
//Local cDescSZO := ""
Local cDescSZU := ""

Local aInd:={}
 Local cCondicao
 Local bFiltraBrw

 local cFor := "ALLTRIM(QUERY->ZO_ITEMIC) == _cItemConta"

dbSelectArea("SZC")
SZC->( dbSetOrder(1)) 
SZC->(dbgotop())

dbSelectArea("SZD")
SZD->( dbSetOrder(1))
SZD->(dbgotop())
 
dbSelectArea("SZO")
SZO->(dbsetorder(3))
SZO->(dbgotop())

dbSelectArea("SZU")
SZU->(dbsetorder(1))
SZU->(dbgotop())



ChkFile("SZO",.F.,"QUERY")
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZO_ITEMIC",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if ALLTRIM(QUERY->ZO_ITEMIC) == alltrim(_cItemConta)

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZO_IDPLSB2))
		ProcessMessage()

		TRB1->TIPO		:= "N3"
		TRB1->NUMERO	:= QUERY->ZO_IDPLSB2
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		if empty(alltrim(QUERY->ZO_GRUSA))
			if alltrim(QUERY->ZO_GRUPO) == "MPR"
				TRB1->ID		:= "MPR"
				TRB1->DESCRICAO	:= "MATERIA PRIMA"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "FAB"
				TRB1->ID		:= "FAB"
				TRB1->DESCRICAO	:= "FABRICACAO"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "COM"
				TRB1->ID		:= "COM"
				TRB1->DESCRICAO	:= "COMERCIAIS"
				TRB1->IDUSA		:= "101"
				TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUPO) == "SRV"
				TRB1->ID		:= "SRV"
				TRB1->DESCRICAO	:= "SERVICOS"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "ESL"
				TRB1->ID		:= "ESL"
				TRB1->DESCRICAO	:= "ENGENHARIA SLC"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUPO) == "EBR"
				TRB1->ID		:= "EBR"
				TRB1->DESCRICAO	:= "ENGENHARIA BR"
				TRB1->IDUSA		:= "201"
				TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUPO) == "LAB"
				TRB1->ID		:= "LAB"
				TRB1->DESCRICAO	:= "LABORATORIO"
				TRB1->IDUSA		:= "213"
				TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZO_GRUPO) == "CTR"
				TRB1->ID		:= "CTR"
				TRB1->DESCRICAO	:= "CONTRATOS"
				TRB1->IDUSA		:= "210"
				TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "IDL"
				TRB1->ID		:= "IDL"
				TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
				TRB1->IDUSA		:= "217"
				TRB1->DESCUSA	:= "INSPECAO"
			/*elseif alltrim(QUERY->ZU_GRUPO) == "FIN"
				TRB1->ID		:= "FIN"
				TRB1->DESCRICAO	:= "FINANCEIRO"*/
			elseif alltrim(QUERY->ZO_GRUPO) == "CMS"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO	:= "COMISSAO"
				TRB1->IDUSA		:= "501"
				TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUPO) == "RDV"
				TRB1->ID		:= "RDV"
				TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
				TRB1->IDUSA		:= "701"
				TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZO_GRUPO) == "FRT"
				TRB1->ID		:= "FRT"
				TRB1->DESCRICAO	:= "FRETE"
				TRB1->IDUSA		:= "301"
				TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZO_GRUPO) == "CDV"
				TRB1->ID		:= "CDV"
				TRB1->DESCRICAO	:= "CUSTO DIVERSOS"
				TRB1->IDUSA		:= "108"
				TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			endif
		else
			if alltrim(QUERY->ZO_GRUSA) == "101"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
			elseif alltrim(QUERY->ZO_GRUSA) == "102"
					TRB1->IDUSA		:= "101"
					TRB1->DESCUSA	:= "TINTAS / REVESTIMENTOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "103"
					TRB1->IDUSA		:= "103"
					TRB1->DESCUSA	:= "BARREIRAS E DEFLETORES"
			elseif alltrim(QUERY->ZO_GRUSA) == "104"
					TRB1->IDUSA		:= "104"
					TRB1->DESCUSA	:= "UNIDADE(S) DE ACIONAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "105"
					TRB1->IDUSA		:= "105"
					TRB1->DESCUSA	:= "PARAFUSOS E ELELEMENTOS DE FIXACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "106"
					TRB1->IDUSA		:= "106"
					TRB1->DESCUSA	:= "CONTROLES ELETRICOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "107"
					TRB1->IDUSA		:= "107"
					TRB1->DESCUSA	:= "INSTRUMENTACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "108"
					TRB1->IDUSA		:= "108"
					TRB1->DESCUSA	:= "OUTRAS AQUISICOES"
			elseif alltrim(QUERY->ZO_GRUSA) == "109"
					TRB1->IDUSA		:= "109"
					TRB1->DESCUSA	:= "FRETE INTERNO"
			elseif alltrim(QUERY->ZO_GRUSA) == "201"
					TRB1->IDUSA		:= "201"
					TRB1->DESCUSA	:= "SUBMITTALS"
			elseif alltrim(QUERY->ZO_GRUSA) == "202"
					TRB1->IDUSA		:= "202"
					TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "204"
					TRB1->IDUSA		:= "204"
					TRB1->DESCUSA	:= "DETALHAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "205"
					TRB1->IDUSA		:= "205"
					TRB1->DESCUSA	:= "VERIFICAO / APROVACAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "206"
					TRB1->IDUSA		:= "206"
					TRB1->DESCUSA	:= "ENGENHARIA DE ACIONAMENTO"
			elseif alltrim(QUERY->ZO_GRUSA) == "207"
					TRB1->IDUSA		:= "207"
					TRB1->DESCUSA	:= "ENGENHARIA ELETRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "210"
					TRB1->IDUSA		:= "210"
					TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "211"
					TRB1->IDUSA		:= "211"
					TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "212"
					TRB1->IDUSA		:= "212"
					TRB1->DESCUSA	:= "MONTAGEM ELETRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "213"
					TRB1->IDUSA		:= "213"
					TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
			elseif alltrim(QUERY->ZO_GRUSA) == "217"
					TRB1->IDUSA		:= "217"
					TRB1->DESCUSA	:= "INSPECAO"
			elseif alltrim(QUERY->ZO_GRUSA) == "218"
					TRB1->IDUSA		:= "218"
					TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
			elseif alltrim(QUERY->ZO_GRUSA) == "220"
					TRB1->IDUSA		:= "220"
					TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
			elseif alltrim(QUERY->ZO_GRUSA) == "221"
					TRB1->IDUSA		:= "221"
					TRB1->DESCUSA	:= "TESTES / MODIFICACOES ELETRICAS"
			elseif alltrim(QUERY->ZO_GRUSA) == "222"
					TRB1->IDUSA		:= "222"
					TRB1->DESCUSA	:= "PROGRAMACAO PLC"
			elseif alltrim(QUERY->ZO_GRUSA) == "301"
					TRB1->IDUSA		:= "301"
					TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			elseif alltrim(QUERY->ZO_GRUSA) == "501"
					TRB1->IDUSA		:= "501"
					TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
			elseif alltrim(QUERY->ZO_GRUSA) == "601"
					TRB1->IDUSA		:= "601"
					TRB1->DESCUSA	:= "DESPESAS DE INSPECAO DE FABRICA"
			elseif alltrim(QUERY->ZO_GRUSA) == "701"
					TRB1->IDUSA		:= "701"
					TRB1->DESCUSA	:= "DESPESAS DE SERVICO DE CAMPO / SUPERVISAO"		
			endif
			
		endif

		cIDSZO := alltrim(QUERY->ZO_IDPLSUB)
		cDescSZO := alltrim(QUERY->ZO_DESCRI)
		
		dbSelectArea("SZD")
		SZD->( dbSetOrder(1))
		SZD->(dbgotop())
		
		//msginfo (cValtoChar(nQTDSZD) + " " + cIDSZO )
		
		cCondicao:= "ALLTRIM(SZD->ZD_ITEMIC) == _cItemConta  "
		bFiltraBrw := {|| FilBrowse("SZD",@aInd,@cCondicao) }
		Eval(bFiltraBrw)
		
		While SZD->(!eof())	
		
			if cIDSZO == alltrim(SZD->ZD_IDPLSUB)
				nQTSZD := SZD->ZD_QUANTR //Posicione("SZD",1,xFilial("SZD")+cIDSZO,"ZD_QUANTR") 
			
				cDescSZD := ALLTRIM(SZD->ZD_DESCRI)  + " <-> " + cDescSZO  //alltrim(Posicione("SZD",1,xFilial("SZD") + cIDSZO,"ZD_DESCRI")) 
				TRB1->UNIDADE		:= QUERY->ZO_UMR
				
				exit
			endif
			SZD->(dbskip())
		
		enddo
		
		TRB1->HISTORICO		:= cDescSZD 
		TRB1->PRODUTO		:= ""
		
		TRB1->QUANTIDADE	:= nQTSZD
		TRB1->VALOR			:= (QUERY->ZO_TOTALR * nQTSZD) 

		TRB1->ORIGEM		:= "PL"
		TRB1->ITEMCONTA 	:= QUERY->ZO_ITEMIC
		TRB1->CAMPO		 	:= "VLRPLN"

		MsUnlock()
		
	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Ordens de compra   			                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PFIN01REAL()

local _cQuery := ""
Local _cFilSC7 := xFilial("SC7")
Local dData
Local nValor := 0
local dDataM2
local cGrProd	:= ""
local cGrUSA	:= ""
local cFor := "ALLTRIM(QUERY->C7_ITEMCTA) == _cItemConta"

SC7->(dbsetorder(23)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SC7",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_EMISSAO",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"

	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************
while QUERY->(!eof())

	if QUERY->C7_ITEMCTA == _cItemConta .and. alltrim(QUERY->C7_ENCER) == ""

		RecLock("TRB1",.T.)
		IncProc("Processando registro: "+alltrim(QUERY->C7_NUM))
		//MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->C7_EMISSAO
		TRB1->DATAENT	:= QUERY->C7_DATPRF
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->C7_NUM
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		

		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->C7_FORNECE) == "000022"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
			
		elseif ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"

		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(QUERY->C7_PRODUTO) $ ("22220018/2219005")							
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
		endif
		
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_GRUPO")	
			
			
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MP" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "AI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "EM" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "GE" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "GG" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MC" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "ME" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003") 
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "OI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PA" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PI" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PP" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "PV" ;
										.AND. !SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "SL" ;
										.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22" .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. !ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003/22220018/2219005");
									.AND. ALLTRIM(QUERY->C7_FORNECE) <> "000022"
									
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) $ ("SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC") ;
									.AND. SUBSTR(ALLTRIM(QUERY->C7_PRODUTO),1,2) == "22"  .AND. ALLTRIM(QUERY->C7_PRODUTO) $ ("22220018/2219005")
									
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->C7_PRODUTO,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->C7_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif ALLTRIM(QUERY->C7_PRODUTO) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"

		endif

		TRB1->PRODUTO	:= QUERY->C7_PRODUTO
		if QUERY->C7_QUJE > 0
			TRB1->QUANTIDADE:= QUERY->C7_QUANT-QUERY->C7_QUJE
		else
			TRB1->QUANTIDADE:= QUERY->C7_QUANT
		endif
		TRB1->UNIDADE	:= QUERY->C7_UM
		TRB1->HISTORICO	:= QUERY->C7_DESCRI
	

		if QUERY->C7_MOEDA = 2
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA2
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA2
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
				
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

		elseif QUERY->C7_MOEDA = 3
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA3
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA3
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF

		elseif QUERY->C7_MOEDA = 4
			dData := QUERY->C7_EMISSAO
			//msginfo ( dData )
			while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERY2->(!eof())
					
					nValor := QUERY2->M2_MOEDA4
				
					if dData == QUERY2->TMP_DATA .AND. nValor > 0
						nValor := QUERY2->M2_MOEDA4
						Exit
					else
						QUERY2->(dbSkip())
					endif

				enddo
				if dData == QUERY2->TMP_DATA .AND. nValor > 0
					exit
				ENDIF
				dData--
			enddo
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI * nValor)
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL * nValor)
			ELSE
				TRB1->VALOR		:= QUERY->C7_XTOTSI * nValor
				TRB1->VALOR2	:= QUERY->C7_TOTAL * nValor
			ENDIF
		else
			IF QUERY->C7_QUJE > 0
				TRB1->VALOR		:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_XTOTSI) 
				TRB1->VALOR2	:= ((QUERY->C7_QUANT-QUERY->C7_QUJE)/QUERY->C7_QUANT) * (QUERY->C7_TOTAL) 
			ELSE
				
				TRB1->VALOR		:= QUERY->C7_XTOTSI 
				TRB1->VALOR2	:= QUERY->C7_TOTAL 
			ENDIF
		endif

		TRB1->CODFORN	:= QUERY->C7_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->C7_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "OC"
		TRB1->ITEMCONTA := QUERY->C7_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())
QUERY2->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Documentos de Entrada		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function D101REAL()

local _cQuery := ""
Local _cFilSD1 := xFilial("SD1")

_cQuery := "SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO' , D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, D1_BASEICM,D1_GRUPO, D1_CUSTO, D1_FORNECE, D1_VALIPI,D1_VALICM,D1_VALIMP5,D1_VALIMP6,D1_DESPESA  FROM SD1010  WHERE  D_E_L_E_T_ <> '*' AND D1_ITEMCTA = '" + _cItemConta + "' ORDER BY D1_EMISSAO"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
SD1->(dbsetorder(13)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SD1",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"D1_EMISSAO",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
while QUERY->(!eof())

	if QUERY->D1_ITEMCTA == _cItemConta;
		.AND. ! alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2901/1901/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') .AND. QUERY->D1_RATEIO == '2';
		.AND. QUERY->D1_RATEIO == '2'
		
		//.OR. QUERY->D1_ITEMCTA == _cItemConta .AND. ! alltrim(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') .AND. QUERY->D1_RATEIO == '2';
		//.AND. !alltrim(QUERY->D1_CF) $ ('1201/1554/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2902/2903/2906/2911/2912/2913/2916/2920/2921/2924/2925/2949')

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->D1_DOC))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_EMISSAO
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->D1_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "101"
		TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
				
		if ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00')
			TRB1->IDUSA		:= "908"
			TRB1->DESCUSA	:= "COMISSAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003");
				.OR.;
				!ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003/22220018/2219005") ;
				.AND. ALLTRIM(QUERY->D1_FORNECE) <> "000022"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("22220018/2219005")	
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->D1_FORNECE) == "000022"
			TRB1->IDUSA		:= "501"
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"			
		elseif ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301"
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
			
		elseif EMPTY(ALLTRIM(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO"))) 
			TRB1->IDUSA		:= "101"
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
				
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
				
		endif
		
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_GRUPO")	
		
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MP" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "AI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "EM" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "GE" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "GG" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "ME" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "OI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PA" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PI" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PP" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "PV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SL" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00') ;
							.AND. !SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003");
				.OR.;
				!ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003/22220018/2219005") ;
				.AND. ALLTRIM(QUERY->D1_FORNECE) <> "000022"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" .AND. !ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00');
				.AND. SUBSTR(ALLTRIM(QUERY->D1_COD),1,2) == "22"  .AND. !ALLTRIM(QUERY->D1_COD) $ ("22220018/2219005")	
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_TIPO")) == "MO" ;
									.AND. ALLTRIM(QUERY->D1_FORNECE) == "000022"
			TRB1->ID		:= "ESL"
			TRB1->DESCRICAO	:= "ENGENHARIA SLC"
		elseif ALLTRIM(QUERY->D1_XNATURE) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif ALLTRIM(QUERY->D1_COD) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif
		
		TRB1->PRODUTO	:= QUERY->D1_COD
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+QUERY->D1_COD,"B1_DESC"))
		TRB1->QUANTIDADE:= QUERY->D1_QUANT
		TRB1->UNIDADE 	:= QUERY->D1_UM
		TRB1->VALOR		:= QUERY->D1_CUSTO

		if SUBSTR(ALLTRIM(QUERY->D1_CF),1,1) = "3"
			TRB1->VALOR2	:= QUERY->D1_TOTAL + QUERY->D1_VALIPI + QUERY->D1_VALICM + QUERY->D1_VALIMP5 + QUERY->D1_VALIMP6 + QUERY->D1_DESPESA //QUERY->D1_BASEICM
		ELSE
			TRB1->VALOR2	:= QUERY->D1_TOTAL
		END
		
		TRB1->CODFORN	:= QUERY->D1_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->D1_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= QUERY->D1_CF
		TRB1->NATUREZA	:= QUERY->D1_XNATURE
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->D1_XNATURE,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DE"
		TRB1->ITEMCONTA := QUERY->D1_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Documentos de Entrada		                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function DE01REAL()

local _cQuery := ""
Local _cFilSDE := xFilial("SDE")
Local cProdD1 	:= ""
Local cDoc		:= ""
Local cSerie	:= ""
Local cFornece	:= ""
Local cLoja		:= ""
Local cItemNF	:= ""
local cFor := "ALLTRIM(QUERY->DE_ITEMCTA) == _cItemConta"
/*
_cQuery := "SELECT DE_ITEMCTA, DE_DOC, DE_FORNECE, DE_CUSTO1, DE_ITEMNF FROM SDE010  WHERE  D_E_L_E_T_ <> '*' AND DE_ITEMCTA = '" + _cItemConta + "' "


	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
*/

SD1->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("SDE",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"QUERY->DE_DOC",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))
QUERY->(dbgotop())

cDoc		:= QUERY->DE_DOC
//cSerie		:= QUERY->DE_SERIE
cFornece	:= QUERY->DE_FORNECE
//cLoja		:= QUERY->DE_LOJA
cItemNF		:= QUERY->DE_ITEMNF

while QUERY->(!eof())

	if QUERY->DE_ITEMCTA == _cItemConta;
		.AND. ! alltrim(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")) $ ('1201/1554/1901/1902/1903/1906/1911/1912/1913/1915/1916/1920/1921/1922/1924/1925/1949/2201/2554/2901/2902/2903/2906/2911/2912/2913/2915/2916/2920/2921/2924/2925/2949') 
		
		cDoc		:= QUERY->DE_DOC
		cSerie		:= QUERY->DE_SERIE
		cFornece	:= QUERY->DE_FORNECE
		cLoja		:= QUERY->DE_LOJA
		cItemNF		:= QUERY->DE_ITEMNF
	
		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->DE_DOC))
		ProcessMessage()

		cProdD1 		:= ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_COD"))
		
		TRB1->DATAMOV	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_EMISSAO")
		TRB1->TIPO		:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))
		TRB1->NUMERO	:= QUERY->DE_DOC
		TRB1->ID		:= "MPR"
		TRB1->DESCRICAO	:= "MATERIA PRIMA"
		TRB1->IDUSA		:= "101"
		TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"
		TRB1->IDUSA		:= alltrim(POSICIONE("SBM",1,XFILIAL("SBM")+alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")),"BM_XIDUSA")) 
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SBM",1,XFILIAL("SBM")+alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")),"BM_XIDUSA")),"ZZL_DESC"))
		TRB1->GRPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")
		
		if alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. ALLTRIM(cProdD1) $ ("22220018/2219005")
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
			TRB1->IDUSA		:= "101" 
			TRB1->DESCUSA	:= "FABRICACAO / MATERIA PRIMA"	
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
			TRB1->IDUSA		:= "501" 
			TRB1->DESCUSA	:= "SERVICOS EXTERNOS"	
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->IDUSA		:= "908" 
			TRB1->DESCUSA	:= "COMISSAO"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->IDUSA		:= "301" 
			TRB1->DESCUSA	:= "FRETE, EMBALAGEM, AFINS"
		else
			cGrProd			:= POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_GRUPO")
			TRB1->IDUSA		:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
				
			cGrUSA			:= POSICIONE("SBM",1,XFILIAL("SBM")+cGrProd,"BM_XIDUSA")
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrUSA,"ZZL_DESC"))
		endif
		
		if ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
			
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "AI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "EM" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GE" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "GG" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MC" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "ME" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "MO" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "OI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PA" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PI" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "PP" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO"))== "PV" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SL" ;
								.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
								.AND. !SUBSTR(ALLTRIM(cProdD1),1,2) $ "22"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. ALLTRIM(cProdD1) $ ("22220018/2219005");
				
			TRB1->ID		:= "FAB"
			TRB1->DESCRICAO	:= "FABRICACAO"
		elseif alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_TIPO")) == "SV/MP/SL/PV/PP/PI/PA/OI/MO/ME/MC/GG/AI/EM/GE/GC" ;
				.AND. !ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00') ;
				.AND. SUBSTR(ALLTRIM(cProdD1),1,2) == "22"  .AND. !ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003/22220018/2219005")
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"	
		elseif ALLTRIM(POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")) $ ('6.21.00/6.22.00')
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		elseif ALLTRIM(cProdD1) $ ("224001/224004/224002/2212004/224003")
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		else
			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		TRB1->PRODUTO	:= cProdD1
		TRB1->HISTORICO	:= alltrim(POSICIONE("SB1",1,XFILIAL("SB1")+cProdD1,"B1_DESC"))
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->DE_CUSTO1
		TRB1->VALOR2	:= QUERY->DE_CUSTO1
		TRB1->CODFORN	:= QUERY->DE_FORNECE
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->DE_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_CF")
		
		TRB1->NATUREZA	:= POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE")
		
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+POSICIONE("SD1",24,XFILIAL("SD1")+cDoc+cFornece+cItemNF,"D1_XNATURE"),"ED_DESCRIC"))
		TRB1->ORIGEM	:= "DR"
		TRB1->ITEMCONTA := QUERY->DE_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa FINANCEIRO					                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function FIN01REAL()

local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")
Local nXIPI := 0
Local nXII := 0
Local nXCOFINS := 0
Local nXPIS := 0
Local nXICMS := 0
Local nXSISCO := 0
Local nXSDA := 0
Local nXTERM := 0
Local nXTRANSP := 0
Local nXFRETE := 0
Local nXFUMIG := 0
Local nXARMAZ := 0
Local nXAFRMM := 0
Local nXCAPA := 0
Local nXCOMIS := 0
Local nXISS := 0
Local nXIRRF := 0
Local nCustoFin := 0


_cQuery := "SELECT CAST(E2_BAIXA AS DATE) TMP_BAIXA, E2_TIPO, E2_NUM, E2_NATUREZ, E2_HIST, E2_VLCRUZ, E2_FORNECE, E2_NATUREZ, E2_XXIC, E2_RATEIO, E2_SALDO, E2_BAIXA, "
_cQuery += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
_cQuery += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF "
_cQuery += " FROM SE2010  WHERE  D_E_L_E_T_ <> '*' AND E2_XXIC = '" + _cItemConta + "' ORDER BY E2_BAIXA "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" .AND. QUERY->E2_SALDO = 0
		QUERY->(dbsKip())
		loop
	ENDIF
	
	if QUERY->E2_XXIC == _cItemConta .AND. !ALLTRIM(QUERY->E2_TIPO) $ ("NF/PR/TX/ISS/INS/INV") .AND. ALLTRIM(QUERY->E2_RATEIO) == "N" //.AND. !EMPTY(QUERY->E2_BAIXA)

		IF  !EMPTY(QUERY->E2_BAIXA) .AND. QUERY->E2_TIPO = "PA" //= "" -> CONSIDERA PA
			QUERY->(dbsKip())
			loop
		ENDIF

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_BAIXA
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->NUMERO	:= QUERY->E2_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		
		TRB1->IDUSA		:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA")),"ZZL_DESC"))
		
		//TRB1->GRPROD	:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		
		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		endif

		if ALLTRIM(QUERY->E2_TIPO) $ ("RDV") .OR. ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->E2_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		
				
		if QUERY->E2_XCTIPI = "2"
			nXIPI := QUERY->E2_XIPI
		else
			nXIPI := 0
		endif
		
		if QUERY->E2_XCTII = "2"
			nXII := QUERY->E2_XII
		else
			nXII := 0
		endif
		
		if QUERY->E2_XCTCOF = "2"
			nXCOFINS := QUERY->E2_XCOFINS
		else
			nXCOFINS := 0
		endif
		
		if QUERY->E2_XCTPIS = "2"
			nXPIS := QUERY->E2_XPIS
		else
			nXPIS := 0
		endif
		
		if QUERY->E2_XCTICMS = "2"
			nXICMS := QUERY->E2_XICMS
		else
			nXICMS := 0
		endif
		
		if QUERY->E2_XCTSISC = "2"
			nXSISCO := QUERY->E2_XSISCO
		else
			nXSISCO := 0
		endif
		
		if QUERY->E2_XCTSDA = "2"
			nXSDA := QUERY->E2_XSDA
		else
			nXSDA := 0
		endif
		
		if QUERY->E2_XCTTEM = "2"
			nXTERM := QUERY->E2_XTERM
		else
			nXTERM := 0
		endif
		
		if QUERY->E2_XCTTRAN = "2"
			nXTRANSP := QUERY->E2_XTRANSP
		else
			nXTRANSP := 0
		endif
		
		if QUERY->E2_XCTFRET = "2"
			nXFRETE := QUERY->E2_XFRETE
		else
			nXFRETE := 0
		endif
		
		if QUERY->E2_XCTFUM = "2"
			nXFUMIG := QUERY->E2_XFUMIG
		else
			nXFUMIG := 0
		endif
		
		if QUERY->E2_XCTARM = "2"
			nXARMAZ := QUERY->E2_XARMAZ
		else
			nXARMAZ := 0
		endif
		
		if QUERY->E2_XCTAFRM = "2"
			nXAFRMM := QUERY->E2_XAFRMM
		else
			nXAFRMM := 0
		endif
		
		if QUERY->E2_XCTCAPA = "2"
			nXCAPA := QUERY->E2_XCAPA
		else
			nXCAPA := 0
		endif
		
		if QUERY->E2_XCTCOM = "2"
			nXCOMIS := QUERY->E2_XCOMIS
		else
			nXCOMIS := 0
		endif
		
		if QUERY->E2_XCTISS = "2"
			nXISS := QUERY->E2_XISS
		else
			nXISS := 0
		endif
		
		if QUERY->E2_XCTIRRF = "2"
			nXIRRF := QUERY->E2_XIRRF
		else
			nXIRRF := 0
		endif
		
		nCustoFin := QUERY->E2_VLCRUZ - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		if QUERY->E2_TIPO = "PA"
			TRB1->VALOR		:= QUERY->E2_SALDO
			TRB1->VALOR2	:= QUERY->E2_SALDO
		ELSE
			TRB1->VALOR		:= nCustoFin
			TRB1->VALOR2	:= nCustoFin
		endiF
		TRB1->CODFORN	:= QUERY->E2_FORNECE
	
		TRB1->FORNECEDOR:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->E2_FORNECE,"A2_NOME"))
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FN"
		TRB1->ITEMCONTA := QUERY->E2_XXIC
		TRB1->CAMPO		:= "VLREMP"

		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa FINANCEIRO RATEIO			                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CV401REAL()

local _cQuery := ""
local cQuery := ""
Local _cFilCV4 := xFilial("CV4")
Local nXIPI := 0
Local nXII := 0
Local nXCOFINS := 0
Local nXPIS := 0
Local nXICMS := 0
Local nXSISCO := 0
Local nXSDA := 0
Local nXTERM := 0
Local nXTRANSP := 0
Local nXFRETE := 0
Local nXFUMIG := 0
Local nXARMAZ := 0
Local nXAFRMM := 0
Local nXCAPA := 0
Local nXCOMIS := 0
Local nXISS := 0
Local nXIRRF := 0
Local nCustoFin := 0
Local nPropVlr := 0


cQuery := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
cQuery += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
cQuery += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA, " 
cQuery += " E2_TIPO,E2_XIPI,E2_XII,E2_XCOFINS,E2_XPIS,E2_XICMS,E2_XSISCO,E2_XSDA,E2_XTERM,E2_XTRANSP,E2_XFRETE,E2_XFUMIG,E2_XARMAZ,E2_XAFRMM,E2_XCAPA,E2_XCOMIS,E2_XISS,E2_XIRRF, "
cQuery += " E2_XCTII,E2_XCTIPI,E2_XCTCOF,E2_XCTPIS,E2_XCTICMS,E2_XCTSISC,E2_XCTSDA,E2_XCTTEM,E2_XCTTRAN,E2_XCTFRET,E2_XCTFUM,E2_XCTARM,E2_XCTAFRM,E2_XCTCAPA,E2_XCTCOM,E2_XCTISS,E2_XCTIRRF " 
cQuery += "		FROM CV4010 "
cQuery += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
cQuery += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' "
cQuery += "				ORDER BY E2_XXIC "

	IF Select("cQuery") <> 0
		DbSelectArea("cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CV4->(dbsetorder(2)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CV4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CV4_DTSEQ",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))
*/
QUERY->(dbgotop())

while QUERY->(!eof())

	IF ALLTRIM(QUERY->E2_TIPO) = "PA" .AND. QUERY->E2_BAIXA <> "" 
		QUERY->(dbsKip())
		loop
	ENDIF

	if QUERY->CV4_ITEMD == _cItemConta

		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->CV4_SEQUEN))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->TMP_DTSEQ
		TRB1->NUMERO	:= QUERY->CV4_SEQUEN
		TRB1->TIPO		:= QUERY->E2_TIPO
		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		
		TRB1->IDUSA		:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))
		TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA")),"ZZL_DESC"))
		
		//TRB1->GRPROD	:= alltrim(POSICIONE("SED",1,XFILIAL("SED")+ALLTRIM(QUERY->E2_NATUREZ),"ED_XIDUSA"))

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.00.00/2.20.00/2.24.00/2.25.00/2.25.02/3.00.00/3.11.01/3.11.02/3.12.01/3.12.02/3.13.01/3.13.02/3.14.01/" + ;
   										"3.16.01/3.16.02/3.17.01/3.17.02/3.18.00/3.19.00/3.20.00/3.21.00/3.22.00/3.23.00/3.23.01/3.23.02/3.30.00/" + ;
   										"3.14.02/3.31.00/3.32.00/3.33.00/3.34.00/3.41.00/3.42.00/3.50.00/3.51.00/3.53.00/3.55.00/3.56.01/3.56.02/" + ;
   										"3.60.00/3.61.00/3.62.00/3.63.00/3.71.00/3.76.00/3.80.00/3.81.00/3.82.00/3.83.00/3.84.00/3.86.00/3.87.00/" + ;
   										"4.00.00/4.40.00/4.41.00/4.42.00/4.43.00/4.44.00/4.45.00/4.47.00/4.48.00/4.50.00/4.52.00/4.53.00/4.54.00/" + ;
   										"4.55.00/4.56.00/4.57.01/4.57.02/4.58.00/4.59.00/5.00.00/5.60.00/5.61.00/5.62.00/5.63.00/5.80.00/5.82.00/" + ;
   										"6.00.00/6.10.00/6.11.00/6.12.00/6.13.00/6.14.00/6.15.00/6.16.00/6.17.00/6.18.00/6.19.00/6.20.00/7.00.00/" + ;
   										"9.00.00/9.10.00/9.11.00/9.12.00/9.13.00/9.14.00/9.15.00/9.16.00/9.17.00/9.18.00/9.20.00/9.21.00/9.22.00/" + ;
   										"9.23.00/9.24.00/9.25.00/9.26.00/9.30.00/9.31.00/9.32.00/9.33.00/9.34.00/9.35.00/9.36.00/9.40.00/9.41.00/" + ;
   										"9.42.00/9.43.00/9.50.00/9.51.00/9.52.00/9.53.00/9.54.00/9.55.00/APLICACAO/CARTAO/CHEQUE/COFINS/CONVENIO/" + ;
   										"CREDITO/CSLL/DEV./TROCA/DINHEIRO/FINAN/ICMS/INSS/IRF/ISS/NCC/OUTROS/PIS/RECEBIMENT/RESG.APLIC/SANGRIA/TEF/" + ;
   										"TROCO/VALE/"
   			TRB1->ID		:= "CDV"
			TRB1->DESCRICAO	:= "CUSTOS DIVERSOS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
			TRB1->ID		:= "CMS"
			TRB1->DESCRICAO	:= "COMISSAO"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.15.01/3.15.02/7.10.00/7.20.00/7.30.00/7.40.00/7.50.00/7.60.00/7.70.00/7.80.00/7.90.00"
			TRB1->ID		:= "COM"
			TRB1->DESCRICAO	:= "COMERCIAIS"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "8.24.00"
			TRB1->ID		:= "FRT"
			TRB1->DESCRICAO	:= "FRETE"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "2.10.00/2.11.00/2.12.00/2.13.00/2.14.00/2.15.00/2.16.00/2.17.00/2.18.00/2.19.00/2.21.00/2.22.00/2.23.00/2.25.01/3.10.00/3.57.00"
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA PRIMA"
		endif

		if  ALLTRIM(QUERY->E2_NATUREZ) $ "3.70.00/3.72.00/3.73.00/3.74.01/3.74.02/3.75.00/3.77.00/3.85.00/4.51.00/5.64.00/5.70.00" + ;
																			"5.71.00/5.72.00/5.73.00/5.74.00/5.75.00/5.76.00/5.77.00/5.78.00/5.79.00/5.81.00/5.83.00/5.84.00"
			TRB1->ID		:= "RDV"
			TRB1->DESCRICAO	:= "RELATORIO DE VIAGEM"
		endif

		if ALLTRIM(QUERY->E2_NATUREZ) $ "3.40.00/8.00.00/8.10.00/8.10.01/8.11.00/8.12.00/8.12.01/8.13.00/8.14.00/8.15.00/8.15.01/8.15.02/8.16.00/8.17.00/8.17.01/8.18.00/" + ;
										"8.19.00/8.19.01/8.19.02/8.20.00/8.20.01/8.20.02/8.20.03/8.21.00/8.21.01/8.21.02/8.22.00/8.23.00/8.23.01/8.23.02/8.23.03/8.23.04/" + ;
										"8.23.05/8.23.06/8.23.07/8.25.00/8.26.00/8.27.00/8.28.00/8.28.01/8.29.00/8.30.00/8.31.00"
			TRB1->ID		:= "SRV"
			TRB1->DESCRICAO	:= "SERVICOS"
		endif

		if QUERY->E2_XCTIPI = "2"
			nXIPI := QUERY->E2_XIPI * (QUERY->CV4_PERCEN/100)
		else
			nXIPI := 0
		endif
		
		if QUERY->E2_XCTII = "2"
			nXII := QUERY->E2_XII * (QUERY->CV4_PERCEN/100)
		else
			nXII := 0
		endif
		
		if QUERY->E2_XCTCOF = "2"
			nXCOFINS := QUERY->E2_XCOFINS * (QUERY->CV4_PERCEN/100)
		else
			nXCOFINS := 0
		endif
		
		if QUERY->E2_XCTPIS = "2"
			nXPIS := QUERY->E2_XPIS * (QUERY->CV4_PERCEN/100)
		else
			nXPIS := 0
		endif
		
		if QUERY->E2_XCTICMS = "2"
			nXICMS := QUERY->E2_XICMS * (QUERY->CV4_PERCEN/100)
		else
			nXICMS := 0
		endif
		
		if QUERY->E2_XCTSISC = "2"
			nXSISCO := QUERY->E2_XSISCO * (QUERY->CV4_PERCEN/100)
		else
			nXSISCO := 0
		endif
		
		if QUERY->E2_XCTSDA = "2"
			nXSDA := QUERY->E2_XSDA * (QUERY->CV4_PERCEN/100)
		else
			nXSDA := 0
		endif
		
		if QUERY->E2_XCTTEM = "2"
			nXTERM := QUERY->E2_XTERM * (QUERY->CV4_PERCEN/100)
		else
			nXTERM := 0
		endif
		
		if QUERY->E2_XCTTRAN = "2"
			nXTRANSP := QUERY->E2_XTRANSP * (QUERY->CV4_PERCEN/100)
		else
			nXTRANSP := 0
		endif
		
		if QUERY->E2_XCTFRET = "2"
			nXFRETE := QUERY->E2_XFRETE * (QUERY->CV4_PERCEN/100)
		else
			nXFRETE := 0
		endif
		
		if QUERY->E2_XCTFUM = "2"
			nXFUMIG := QUERY->E2_XFUMIG * (QUERY->CV4_PERCEN/100)
		else
			nXFUMIG := 0
		endif
		
		if QUERY->E2_XCTARM = "2"
			nXARMAZ := QUERY->E2_XARMAZ * (QUERY->CV4_PERCEN/100)
		else
			nXARMAZ := 0
		endif
		
		if QUERY->E2_XCTAFRM = "2"
			nXAFRMM := QUERY->E2_XAFRMM * (QUERY->CV4_PERCEN/100)
		else
			nXAFRMM := 0
		endif
		
		if QUERY->E2_XCTCAPA = "2"
			nXCAPA := QUERY->E2_XCAPA * (QUERY->CV4_PERCEN/100)
		else
			nXCAPA := 0
		endif
		
		if QUERY->E2_XCTCOM = "2"
			nXCOMIS := QUERY->E2_XCOMIS * (QUERY->CV4_PERCEN/100)
		else
			nXCOMIS := 0
		endif
		
		if QUERY->E2_XCTISS = "2"
			nXISS := QUERY->E2_XISS * (QUERY->CV4_PERCEN/100)
		else
			nXISS := 0
		endif
		
		if QUERY->E2_XCTIRRF = "2"
			nXIRRF := QUERY->E2_XIRRF * (QUERY->CV4_PERCEN/100)
		else
			nXIRRF := 0
		endif

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->CV4_HIST
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE 	:= ""
		TRB1->VALOR		:= QUERY->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		TRB1->VALOR2	:= QUERY->CV4_VALOR - nXIPI - nXII - nXCOFINS - nXPIS - nXICMS - nXSISCO - nXSDA - nXTERM - nXTRANSP - nXFRETE - nXFUMIG - nXARMAZ - nXAFRMM - nXCAPA - nXCOMIS - nXISS - nXIRRF
		TRB1->CODFORN	:= QUERY->E2_FORNECE
		TRB1->FORNECEDOR:= QUERY->E2_NOMFOR
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= QUERY->E2_NATUREZ
		TRB1->DNATUREZA := alltrim(POSICIONE("SED",1,XFILIAL("SED")+QUERY->E2_NATUREZ,"ED_DESCRIC"))
		TRB1->ORIGEM	:= "FR"
		TRB1->ITEMCONTA := QUERY->CV4_ITEMD
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa HORAS DE CONTRATO				                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


static function HR01REAL()

local _cQuery := ""
Local _cFilSZ4 := xFilial("SZ4")
Local nTarefa
local cFor := "ALLTRIM(QUERY->Z4_ITEMCTA) == _cItemConta"

//SZ4->(dbsetorder(9)) 

ChkFile("SZ4",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"Z4_FILIAL+Z4_ITEMCTA",,cFor,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
//SC7->(dbgotop())
//QUERY->(dbseek( ALLTRIM(MV_PAR01),.T.))

while QUERY->(!eof())

	if QUERY->Z4_ITEMCTA == _cItemConta

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->Z4_COLAB))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->Z4_DATA
		TRB1->TIPO		:= QUERY->Z4_TAREFA
		TRB1->NUMERO	:= ""

		TRB1->ID		:= "CTR"
		TRB1->DESCRICAO	:= "CONTRATOS"
		TRB1->IDUSA		:= "210"
		TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"

		if ALLTRIM(QUERY->Z4_TAREFA) == "CE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "210"
			TRB1->DESCUSA	:= "GERENCIAMENTO DE PROJETOS"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EE"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "LB"
			TRB1->ID		:= "LAB"
			TRB1->DESCRICAO	:= "LABORATORIO"
			TRB1->IDUSA		:= "213"
			TRB1->DESCUSA	:= "OUTRA MONTAGEM / TESTE"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "PB"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "202"
			TRB1->DESCUSA	:= "PROJETO / LAYOUT / CALCULOS"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DT"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "204"
			TRB1->DESCUSA	:= "DETALHAMENTO"
			
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DC"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "220"
			TRB1->DESCUSA	:= "OUTRO, O&M, COPIA, EMBARQUE"
	
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "OP"
			TRB1->ID		:= "EBR"
			TRB1->DESCRICAO	:= "ENGENHARIA BR"
			TRB1->IDUSA		:= "201"
			TRB1->DESCUSA	:= "SUBMITTALS"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DI"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->IDUSA		:= "217"
			TRB1->DESCUSA	:= "INSPECAO"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "SC"
			TRB1->ID		:= "IDL"
			TRB1->DESCRICAO	:= "INSPECAO / DILIGENCIAMENTO"
			TRB1->IDUSA		:= "218"
			TRB1->DESCUSA	:= "SERVICO / TESTE DE CAMPO"
		
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CR"
			TRB1->ID		:= "CTR"
			TRB1->DESCRICAO	:= "CONTRATOS"
			TRB1->IDUSA		:= "211"
			TRB1->DESCUSA	:= "COMPRAS / EXPEDICAO"
			
		endif

		if ALLTRIM(QUERY->Z4_TAREFA) == "VD"
			nTarefa := ":Vendas"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "OP"
			nTarefa := ":Operacoes"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "LB"
			nTarefa := ":Laboratorio"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EX"
			nTarefa := ":Expedicao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DT"
			nTarefa := ":Detalhamento"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "AD"
			nTarefa := ":Administracao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CP"
			nTarefa := ":Coordenacao de Contrato"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CR"
			nTarefa := ":Compras"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DC"
			nTarefa := ":Outros Documentos"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "CE"
			nTarefa := ":Coordenacao de Engenharia"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "EE"
			nTarefa := ":Estudo de Engenharia"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "PB"
			nTarefa := ":Projeto Basico"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "DI"
			nTarefa := ":Diligenciamento / Inspecao"
		elseif ALLTRIM(QUERY->Z4_TAREFA) == "SC"
			nTarefa := ":Servico de Campo"
		elseif EMPTY(ALLTRIM(QUERY->Z4_TAREFA))
			nTarefa := "ST:Sem Tarfa"
		else
			nTarefa := "ST:Sem Tarfa"
		endif

		TRB1->PRODUTO	:= QUERY->Z4_IDAPTHR
		TRB1->HISTORICO	:= ALLTRIM(QUERY->Z4_TAREFA) + nTarefa + " - " + QUERY->Z4_COLAB
		TRB1->QUANTIDADE:= QUERY->Z4_QTDHRS
		TRB1->UNIDADE	:= "HR"
		TRB1->VALOR		:= QUERY->Z4_TOTVLR
		TRB1->VALOR2	:= QUERY->Z4_TOTVLR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "HR"
		TRB1->ITEMCONTA := QUERY->Z4_ITEMCTA
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa CUSTOS DIVERSOS 2				                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CUDIV01REAL()

local _cQuery := ""
Local _cFilZZA := xFilial("ZZA")
Local nTarefa
local cFor := "ALLTRIM(QUERY->ZZA_ITEMIC) == _cItemConta"
/*
_cQuery := "SELECT * FROM ZZA010  WHERE  D_E_L_E_T_ <> '*' AND ZZA_ITEMIC = '" + _cItemConta + "' ORDER BY ZZA_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())
*/

ZZA->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("ZZA",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZA_DATA",,cFor,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

while QUERY->(!eof())

	if QUERY->ZZA_ITEMIC == _cItemConta

		//if alltrim(QUERY->E5_TIPODOC) <> "CH"
		RecLock("TRB1",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZZA_NUM))
		ProcessMessage()
		
		TRB1->DATAMOV	:= QUERY->ZZA_DATA
		TRB1->TIPO		:= QUERY->ZZA_TIPO
		TRB1->NUMERO	:= QUERY->ZZA_NUM

		TRB1->ID		:= "CDV"
		TRB1->DESCRICAO	:= "CUSTOS DIVERSOS 2"
		
		TRB1->IDUSA		:= "108"
		TRB1->DESCUSA	:= "OUTRAS AQUISICOES"

		TRB1->PRODUTO	:= ""
		TRB1->HISTORICO	:= QUERY->ZZA_DESCR
		TRB1->QUANTIDADE:= 0
		TRB1->UNIDADE	:= ""
		TRB1->VALOR		:= QUERY->ZZA_VALOR
		TRB1->VALOR2	:= QUERY->ZZA_VALOR
		TRB1->CODFORN	:= ""
		TRB1->FORNECEDOR:= ""
		TRB1->CFOP		:= ""
		TRB1->NATUREZA	:= ""
		TRB1->DNATUREZA := ""
		TRB1->ORIGEM	:= "CD"
		TRB1->ITEMCONTA := QUERY->ZZA_ITEMIC
		TRB1->CAMPO		:= "VLREMP"
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401REAL()

Local nSaldoAnt := 0
local _cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")
Local cFor

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT   FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "' ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CQ5->(dbsetorder(7))

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))
*/
QUERY->(dbgotop())
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))

	while QUERY->(!eof()) 
		if QUERY->CQ5_ITEM <> _cItemConta 
			QUERY->(dbskip())
		else
		if  QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),1) == "5" ;
			.OR.;
			 QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. ALLTRIM(QUERY->CQ5_CONTA) == "621020001"
	
			RecLock("TRB1",.T.)
			
			MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			ProcessMessage()
			
			TRB1->DATAMOV	:= QUERY->TMP_DTCQ5
			TRB1->ORIGEM	:= "CC"
			TRB1->CONTA	:= QUERY->CQ5_CONTA
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO:= "MATERIA-PRIMA"
			
			cGrProd			:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
			TRB1->IDUSA		:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
		
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrProd,"ZZL_DESC"))
	
			if alltrim(QUERY->CQ5_CONTA) == "621020001"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO:= "COMISSAO"
			endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010004/511020004/511030004/511040004/512010004/512020004/512030004/513010004/513020004/" + ;
	  					"514010004/514020004/514030004/515010001/515010002/518010004/518020004/518030004/518040004/" + ;
	  					"518050004/518060004/518070004/518080004/518090004/516010002/516020002/518100002/518110002"
	  			TRB1->ID		:= "CDV"
				TRB1->DESCRICAO:= "CUSTO DIVERSOS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010002/511020002/511030002/511040002/512010002/512020002/512030002/513010002/513020002/514010002/" + ;
						"514020002/514030002/518010002/518020002/518030002/518040002/518050002/518060002/518070002/518080002/518090002"
	  			TRB1->ID		:= "EBR"
				TRB1->DESCRICAO:= "ENGENHARIA BR"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010003/511020003/511030003/511040003/512010003/512020003/512030003/513010003/513020003/514010003"  + ;
						"514020003/514030003/518010003/518020003/518030003/518040003/518050003/518060003/518070003/518080003/518090003"
	  			TRB1->ID		:= "FRT"
				TRB1->DESCRICAO:= "FRETE"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010006/511010007/511020006/511020007/511030006/511030007/511040006/511040007/512010006/512010007/" +  ;
						"512020006/512020007/512030006/512030007/513010006/513010007/513020006/513020007/514010006/514010007/" +  ;
						"514020006/514020007/514030006/514030007/518010006/518010007/518020006/518020007/518030006/518030007/" +  ;
						"518040006/518040007/518050006/518050007/518060006/518060007/518070006/518070007/518080006/518080007/" +  ;
						"518090006/518090007"
	  			TRB1->ID		:= "IDL"
				TRB1->DESCRICAO:= "INSPECAO / DILIGENCIAMENTO"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010001/511020001/511030001/511040001/512010001/512020001/512030001/514010001/514020001/518010001" + ;
						"518020001/518030001/518040001/518050001/518060001/518070001/513010001"
	  			TRB1->ID		:= "MPR"
				TRB1->DESCRICAO:= "MATERIA PRIMA"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010008/511020008/511030008/511040008/512010008/512020008/512030008/513010008/513020008/514010008/" + ;
						"514020008/514030008/518010008/518020008/518030008/518040008/518050008/518060008/518070008/518080008/518090008"
	  			TRB1->ID		:= "RDV"
				TRB1->DESCRICAO:= "RELATORIO DE VIAGEM"
	  		endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"511010005/511020005/511030005/511040005/512010005/512020005/512030005/513010005/513020005/514010005/" + ;
						"514020005/514030005/518010005/518020005/518030005/518040005/518050005/518060005/518070005/518080005/518090005"
	  			TRB1->ID		:= "SRV"
				TRB1->DESCRICAO:= "SERVICOS"
	  		endif
	
			TRB1->HISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB1->VDEBITO	:= QUERY->CQ5_DEBITO
			TRB1->VCREDITO := QUERY->CQ5_CREDIT
	
			TRB1->VSALDO	:= nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			TRB1->ITEMCONTA:= QUERY->CQ5_ITEM
			TRB1->CAMPO		:= "VLRCTB"
	
			MsUnlock()

		endif
	
		QUERY->(dbskip())
		
		endif
	
	enddo

//endif

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401EST()

Local nSaldoAnt := 0
local _cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT  FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "'  ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
//CQ5->(dbsetorder(7)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")

ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))



	while QUERY->(!eof())
	
	if QUERY->CQ5_ITEM <> _cItemConta 
		QUERY->(dbskip())
	else
		if QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),3) == "113" ;
			.OR.;
			 QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. ALLTRIM(QUERY->CQ5_CONTA) == "113060008"
	
	
			RecLock("TRB1",.T.)
			
			MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			ProcessMessage()
			
			TRB1->DATAMOV	:= QUERY->TMP_DTCQ5
			TRB1->ORIGEM	:= "CE"
			TRB1->CONTA		:= QUERY->CQ5_CONTA
			TRB1->ID		:= "MPR"
			TRB1->DESCRICAO	:= "MATERIA-PRIMA"
	
			cGrProd			:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
			TRB1->IDUSA		:= POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_XIDUSA")
		
			TRB1->DESCUSA	:= alltrim(POSICIONE("ZZL",1,XFILIAL("ZZL")+cGrProd,"ZZL_DESC"))
	
			if alltrim(QUERY->CQ5_CONTA) == "113060008"
				TRB1->ID		:= "CMS"
				TRB1->DESCRICAO:= "COMISSAO"
			endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"113070002/113080024/113080025/113080026/113060007"
	  			TRB1->ID		:= "CDV"
				TRB1->DESCRICAO:= "CUSTO DIVERSOS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"113010002/113030017/113030018/113040016/113080021"
	  			TRB1->ID		:= "COM"
				TRB1->DESCRICAO:= "COMERCIAIS"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113060001/113060006"
	  			TRB1->ID		:= "EBR"
				TRB1->DESCRICAO:= "ENGENHAR�IA BR"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
						"113060002"
	  			TRB1->ID		:= "FRT"
				TRB1->DESCRICAO:= "FRETE"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113020002/113050002/113080022"
	  			TRB1->ID		:= "MPR"
				TRB1->DESCRICAO:= "MATERIA PRIMA"
	  		endif
	
	  		if alltrim(QUERY->CQ5_CONTA) $ ;
	  					"113060004/113060005"
	  			TRB1->ID		:= "RDV"
				TRB1->DESCRICAO:= "RELATORIO DE VIAGEM"
	  		endif
	
			if alltrim(QUERY->CQ5_CONTA) $ ;
						"113060003/113080023"
	  			TRB1->ID		:= "SRV"
				TRB1->DESCRICAO:= "SERVICOS"
	  		endif
	
			TRB1->HISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB1->VDEBITO	:= QUERY->CQ5_DEBITO
			TRB1->VCREDITO := QUERY->CQ5_CREDIT
	
			TRB1->VSALDO	:= nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_DEBITO - QUERY->CQ5_CREDIT)
	
			TRB1->ITEMCONTA:= QUERY->CQ5_ITEM
			TRB1->CAMPO		:= "VLRCTBE"
	
			MsUnlock()
	
	
		endif
	
		QUERY->(dbskip())
	endif
	enddo
//endif
 

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Processa Custo Contabil				                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function CT401REC()

Local nSaldoAnt := 0
local cQuery := ""
Local _cFilCQ5 := xFilial("CQ5")

//_cItemConta 	:= ALLTRIM(MV_PAR01)

//msginfo ( _cItemConta )

//local _cNatureza

_cQuery := "SELECT CQ5_FILIAL, CQ5_ITEM, CQ5_MOEDA, CQ5_LP, CQ5_CONTA, CAST(CQ5_DATA AS DATE) AS TMP_DTCQ5, CQ5_DEBITO, CQ5_CREDIT  FROM CQ5010  WHERE  D_E_L_E_T_ <> '*' AND CQ5_ITEM = '" + _cItemConta + "' ORDER BY CQ5_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

/*
CQ5->(dbsetorder(7)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA

ChkFile("CQ5",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"CQ5_DATA",,,"Selecionando Registros...")


ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())
*/
//if CQ5->(msseek(ALLTRIM(_cFilial+_cItemConta)))

	while QUERY->(!eof()) 
	
	if QUERY->CQ5_ITEM <> _cItemConta
		QUERY->(dbskip())
	else
	
		if QUERY->CQ5_FILIAL == "01" .AND. QUERY->CQ5_ITEM == _cItemConta .AND. ALLTRIM(QUERY->CQ5_MOEDA) == "01" .AND. ALLTRIM(QUERY->CQ5_LP) <> "Z" .AND. LEFT(ALLTRIM(QUERY->CQ5_CONTA),1) == "4"
	
			RecLock("TRB4",.T.)
			
			MsProcTxt("Processando registro: "+alltrim(QUERY->CQ5_CONTA))
			ProcessMessage()
			
			TRB4->RDATAMOV	:= QUERY->TMP_DTCQ5
			TRB4->RORIGEM	:= "CB"
			TRB4->RCONTA	:= QUERY->CQ5_CONTA
			TRB4->RID		:= "REC"
			TRB4->RDESCRICAO:= "RECEITA CONTABIL"
			TRB4->RHISTORICO:= alltrim(POSICIONE("CT1",1,XFILIAL("CT1")+QUERY->CQ5_CONTA,"CT1_DESC01"))
			TRB4->RVDEBITO	:= QUERY->CQ5_DEBITO
			TRB4->RVCREDITO := QUERY->CQ5_CREDIT
	
			TRB4->RVSALDO	:= nSaldoAnt + (QUERY->CQ5_CREDIT - QUERY->CQ5_DEBITO  )
	
			nSaldoAnt :=  nSaldoAnt + (QUERY->CQ5_CREDIT - QUERY->CQ5_DEBITO )
	
			TRB4->RITEMCONTA:= QUERY->CQ5_ITEM
			TRB4->RCAMPO		:= "RECCTB"
	
			MsUnlock()
	
	
		endif
	
		QUERY->(dbskip())
	endif
	enddo

//endif

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera o Arquivo Sintetico                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function GC01SINT()
local _nPos 	:= 0
local _cQuery 	:= ""
local _nSaldo 	:= 0

Local nMPRVal 	:= 0
Local nMPRTot	:= 0

Local nMPRValC 	:= 0
Local nMPRTotC	:= 0

Local nMPRValE 	:= 0
Local nMPRTotE	:= 0

Local nMPRValP 	:= 0
Local nMPRTotP	:= 0

Local nMPRValV 	:= 0
Local nMPRTotV	:= 0

Local nFABVal 	:= 0
Local nFABTot	:= 0

Local nFABValC 	:= 0
Local nFABTotC	:= 0

Local nFABValE 	:= 0
Local nFABTotE	:= 0

Local nFABValV 	:= 0
Local nFABTotV	:= 0

Local nFABValP 	:= 0
Local nFABTotP	:= 0

Local nCOMVal 	:= 0
Local nCOMTot	:= 0

Local nCOMValC 	:= 0
Local nCOMTotC	:= 0

Local nCOMValE 	:= 0
Local nCOMTotE	:= 0

Local nCOMValP 	:= 0
Local nCOMTotP	:= 0

Local nCOMValV 	:= 0
Local nCOMTotV	:= 0

Local nEBRVal 	:= 0
Local nEBRTot	:= 0

Local nEBRValC 	:= 0
Local nEBRTotC	:= 0

Local nEBRValE 	:= 0
Local nEBRTotE	:= 0

Local nEBRValP 	:= 0
Local nEBRTotP	:= 0

Local nEBRValV 	:= 0
Local nEBRTotV	:= 0

Local nESLVal 	:= 0
Local nESLTot	:= 0

Local nESLValC 	:= 0
Local nESLTotC	:= 0

Local nESLValE 	:= 0
Local nESLTotE	:= 0

Local nESLValP 	:= 0
Local nESLTotP	:= 0

Local nESLValV 	:= 0
Local nESLTotV	:= 0

Local nCTRVal 	:= 0
Local nCTRTot	:= 0

Local nCTRValC 	:= 0
Local nCTRTotC	:= 0

Local nCTRValE 	:= 0
Local nCTRTotE	:= 0

Local nCTRValP 	:= 0
Local nCTRTotP	:= 0

Local nCTRValV 	:= 0
Local nCTRTotV	:= 0

Local nIDLVal 	:= 0
Local nIDLTot	:= 0

Local nIDLValC 	:= 0
Local nIDLTotC	:= 0

Local nIDLValE 	:= 0
Local nIDLTotE	:= 0

Local nIDLValP 	:= 0
Local nIDLTotP	:= 0

Local nIDLValV 	:= 0
Local nIDLTotV	:= 0

Local nLABVal 	:= 0
Local nLABTot	:= 0

Local nLABValC 	:= 0
Local nLABTotC	:= 0

Local nLABValE 	:= 0
Local nLABTotE	:= 0

Local nLABValP 	:= 0
Local nLABTotP	:= 0

Local nLABValV 	:= 0
Local nLABTotV	:= 0

Local nFINVal 	:= 0
Local nFINTot	:= 0

Local nFINValC 	:= 0
Local nFINTotC	:= 0

Local nFINValE 	:= 0
Local nFINTotE	:= 0

Local nFINValP 	:= 0
Local nFINTotP	:= 0

Local nFINValV 	:= 0
Local nFINTotV	:= 0

Local nCMSVal 	:= 0
Local nCMSTot	:= 0

Local nCMSValE 	:= 0
Local nCMSTotE	:= 0

Local nCMSValC 	:= 0
Local nCMSTotC	:= 0

Local nCMSValP 	:= 0
Local nCMSTotP	:= 0

Local nCMSValV 	:= 0
Local nCMSTotV	:= 0

Local nRDVVal 	:= 0
Local nRDVTot	:= 0

Local nRDVValC 	:= 0
Local nRDVTotC	:= 0

Local nRDVValE 	:= 0
Local nRDVTotE	:= 0

Local nRDVValP 	:= 0
Local nRDVTotP	:= 0

Local nRDVValV 	:= 0
Local nRDVTotV	:= 0

Local nFRTVal 	:= 0
Local nFRTTot	:= 0

Local nFRTValC 	:= 0
Local nFRTTotC	:= 0

Local nFRTValE 	:= 0
Local nFRTTotE	:= 0

Local nFRTValP 	:= 0
Local nFRTTotP	:= 0

Local nFRTValV 	:= 0
Local nFRTTotV	:= 0

Local nCDVVal 	:= 0
Local nCDVTot	:= 0

Local nCDVValC 	:= 0
Local nCDVTotC	:= 0

Local nCDVValE 	:= 0
Local nCDVTotE	:= 0

Local nCDVValP	:= 0
Local nCDVTotP	:= 0

Local nCDVValV	:= 0
Local nCDVTotV	:= 0

Local nSRVVal 	:= 0
Local nSRVTot	:= 0

Local nSRVValC 	:= 0
Local nSRVTotC	:= 0

Local nSRVValE 	:= 0
Local nSRVTotE	:= 0

Local nSRVValP 	:= 0
Local nSRVTotP 	:= 0

Local nSRVValV 	:= 0
Local nSRVTotV 	:= 0

Local nCPRVal	:= 0
Local nCPRTot	:= 0
Local nCTOVal	:= 0
Local nCTOTot	:= 0
Local nCTOTotC	:= 0
Local nCPRTotC	:= 0

Local nCTOTotE	:= 0
Local nCPRTotE	:= 0

Local nCTOTotP	:= 0
Local nCPRTotP	:= 0

Local nCTOTotV	:= 0
Local nCPRTotV	:= 0

Local nCPRTotR	:= 0

Local nCPRVal2	:= 0
Local nCPRTot2	:= 0
Local nCTOVal2	:= 0
Local nCTOTot2	:= 0
Local nCTOTotC2	:= 0
Local nCPRTotC2	:= 0

Local nCTOTotE2	:= 0
Local nCPRTotE2	:= 0

Local nCTOTotP2	:= 0
Local nCPRTotP2	:= 0

Local nCTOTotV2	:= 0
Local nCPRTotV2	:= 0

Local nCPRTotR2	:= 0

Local nXSISFV	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFV")
Local nXSISFR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XSISFR")


Local nXVDSIR	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSIR")
Local nXVDSI	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XVDSI")
Local nXCUSTO	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSTO")
Local nOUTCUS1	:= 0
Local nOUTCUS2	:= 0

Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Local oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Local oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Local oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Local oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Local oGray		:= LoadBitmap( GetResources(), "BR_CINZA")
//Variaveis Vendido
Local  nGT101 := 0, nGT102 := 0, nGT103 := 0, nGT104 := 0, nGT105 := 0, nGT106 := 0, nGT107 := 0, nGT108 := 0, nGT109 := 0, nGT199 := 0
Local  nGT201 := 0, nGT202 := 0, nGT204 := 0, nGT205 := 0, nGT206 := 0, nGT207 := 0, nGT209 := 0
Local  nGT210 := 0, nGT211 := 0, nGT212 := 0, nGT213 := 0, nGT217 := 0, nGT218 := 0, nGT220 := 0, nGT221 := 0, nGT222 := 0, nGT299 := 0
Local  nGT301 := 0, nGT501 := 0, nGT601 := 0, nGT701 := 0
//Variaveis planejado
Local  nGP101 := 0, nGP102 := 0, nGP103 := 0, nGP104 := 0, nGP105 := 0, nGP106 := 0, nGP107 := 0, nGP108 := 0, nGP109 := 0, nGP199 := 0
Local  nGP201 := 0, nGP202 := 0, nGP204 := 0, nGP205 := 0, nGP206 := 0, nGP207 := 0, nGP209 := 0
Local  nGP210 := 0, nGP211 := 0, nGP212 := 0, nGP213 := 0, nGP217 := 0, nGP218 := 0, nGP220 := 0, nGP221 := 0, nGP222 := 0, nGP299 := 0
Local  nGP301 := 0, nGP501 := 0, nGP601 := 0, nGP701 := 0
//Variaveis empenhado
Local  nGE101 := 0, nGE102 := 0, nGE103 := 0, nGE104 := 0, nGE105 := 0, nGE106 := 0, nGE107 := 0, nGE108 := 0, nGE109 := 0, nGE199 := 0
Local  nGE201 := 0, nGE202 := 0, nGE204 := 0, nGE205 := 0, nGE206 := 0, nGE207 := 0, nGE209 := 0
Local  nGE210 := 0, nGE211 := 0, nGE212 := 0, nGE213 := 0, nGE217 := 0, nGE218 := 0, nGE220 := 0, nGE221 := 0, nGE222 := 0, nGE299 := 0
Local  nGE301 := 0, nGE501 := 0, nGE601 := 0, nGE701 := 0
Local  nGE801 := 0, nGE802 := 0, nGE803 := 0, nGE804 := 0, nGE805 := 0, nGE806 := 0
Local  nGE901 := 0, nGE902 := 0, nGE903 := 0, nGE904 := 0, nGE905 := 0, nGE906 := 0, nGE908 := 0
//Variaveis contabil estoque
Local  nGCE101 := 0, nGCE102 := 0, nGCE103 := 0, nGCE104 := 0, nGCE105 := 0, nGCE106 := 0, nGCE107 := 0, nGCE108 := 0, nGCE109 := 0, nGCE199 := 0
Local  nGCE201 := 0, nGCE202 := 0, nGCE204 := 0, nGCE205 := 0, nGCE206 := 0, nGCE207 := 0, nGCE209 := 0
Local  nGCE210 := 0, nGCE211 := 0, nGCE212 := 0, nGCE213 := 0, nGCE217 := 0, nGCE218 := 0, nGCE220 := 0, nGCE221 := 0, nGCE222 := 0, nGCE299 := 0
Local  nGCE301 := 0, nGCE501 := 0, nGCE601 := 0, nGCE701 := 0
//Variaveis contabil reconhecido
Local  nGCR101 := 0, nGCR102 := 0, nGCR103 := 0, nGCR104 := 0, nGCR105 := 0, nGCR106 := 0, nGCR107 := 0, nGCR108 := 0, nGCR109 := 0, nGCR199 := 0
Local  nGCR201 := 0, nGCR202 := 0, nGCR204 := 0, nGCR205 := 0, nGCR206 := 0, nGCR207 := 0, nGCR209 := 0
Local  nGCR210 := 0, nGCR211 := 0, nGCR212 := 0, nGCR213 := 0, nGCR217 := 0, nGCR218 := 0, nGCR220 := 0, nGCR221 := 0, nGCR222 := 0, nGCR299 := 0
Local  nGCR301 := 0, nGCR501 := 0, nGCR601 := 0, nGCR701 := 0

private _cOrdem := "000001"

//_cItemConta 	:= ALLTRIM(MV_PAR01)

	RecLock("TRB2",.T.)
		
		TRB2->DESCUSA	:= "RESUMO MATERIAIS"
		TRB2->IDUSA		:= "100"
		TRB2->ORDEM		:= _cOrdem

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	//*********************** MATERIA PRIMA ********************************
	RecLock("TRB2",.T.)
		
		TRB2->DESCUSA	:= "Fabricacao / Materia Prima"
		TRB2->IDUSA		:= "101"
		TRB2->ORDEM		:= _cOrdem

		
		 // VENDIDO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "101" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT101		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT101
		TRB2->PERVD		:= (nGT101 / nXVDSI )*100
		
		 // PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "101" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP101		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP101
		TRB2->PERPLN	:= (nGP101 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "101" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE101		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE101
		TRB2->PEREMP	:= (nGE101 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "101" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR101		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR101
		TRB2->PERCTB := (nGCR101 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "101" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE101		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE101
		TRB2->PERCTBE	:= (nGCE101 / nXVDSIR )*100
		
	
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Tintas / Revestimento"
		TRB2->IDUSA		:= "102"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "102" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT102		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT102
		TRB2->PERVD		:= (nGT102 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "102" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP102		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP102
		TRB2->PERPLN	:= (nGP102 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "102" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE102		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE102
		TRB2->PEREMP	:= (nGE102 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "102" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR102		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR102
		TRB2->PERCTB := (nGCR102 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "102" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE102		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE102
		TRB2->PERCTBE	:= (nGCE102 / nXVDSIR )*100
		
		

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Barreiras e Defletores"
		TRB2->IDUSA		:= "103"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "103" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT103		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT103
		TRB2->PERVD		:= (nGT103 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "103" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP103		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP103
		TRB2->PERPLN	:= (nGP103 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "103" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE103		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE103
		TRB2->PEREMP	:= (nGE103 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "103" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR103		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR103
		TRB2->PERCTB := (nGCR103 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "103" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE103		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE103
		TRB2->PERCTBE	:= (nGCE103 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Unidade(s) de Acionamento"
		TRB2->IDUSA		:= "104"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "104" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT104		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT104
		TRB2->PERVD		:= (nGT104 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "104" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP104		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP104
		TRB2->PERPLN	:= (nGP104 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "104" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE104		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE104
		TRB2->PEREMP	:= (nGE104 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "104" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR104		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR104
		TRB2->PERCTB := (nGCR104 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "104" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE104		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE104
		TRB2->PERCTBE	:= (nGCE104 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Parafusos e Elementos de Fixacao"
		TRB2->IDUSA		:= "105"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "105" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT105		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT105
		TRB2->PERVD		:= (nGT105 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "105" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP105		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP105
		TRB2->PERPLN	:= (nGP105 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "105" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE105		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE105
		TRB2->PEREMP	:= (nGE105 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "105" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR105		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR105
		TRB2->PERCTB := (nGCR105 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "105" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE105		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE105
		TRB2->PERCTBE	:= (nGCE105 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Controles Eletricos"
		TRB2->IDUSA		:= "106"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "106" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT106		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT106
		TRB2->PERVD		:= (nGT106 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "106" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP106		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP106
		TRB2->PERPLN	:= (nGP106 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "106" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE106		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE106
		TRB2->PEREMP	:= (nGE106 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "106" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR106		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR106
		TRB2->PERCTB := (nGCR106 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "106" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE106		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE106
		TRB2->PERCTBE	:= (nGCE106 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Instrumentacao"
		TRB2->IDUSA		:= "107"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "107" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT107		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT107
		TRB2->PERVD		:= (nGT107 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "107" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP107		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP107
		TRB2->PERPLN	:= (nGP107 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "107" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE107		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE107
		TRB2->PEREMP	:= (nGE107 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "107" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR107		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR107
		TRB2->PERCTB := (nGCR107 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "107" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE107		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE107
		TRB2->PERCTBE	:= (nGCE107 / nXVDSIR )*100
		
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
		
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Outras Aquisicoes"
		TRB2->IDUSA		:= "108"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "108" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT108		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT108
		TRB2->PERVD		:= (nGT108 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "108" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP108		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP108
		TRB2->PERPLN	:= (nGP108 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "108" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE108		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE108
		TRB2->PEREMP	:= (nGE108 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "108" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR108		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR108
		TRB2->PERCTB := (nGCR108 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "108" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE108		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE108
		TRB2->PERCTBE	:= (nGCE108 / nXVDSIR )*100
		
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Frete Interno"
		TRB2->IDUSA		:= "109"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "109" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT109		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT109
		TRB2->PERVD		:= (nGT109 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "109" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP109		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP109
		TRB2->PERPLN	:= (nGP109 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "109" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE109		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE109
		TRB2->PEREMP	:= (nGE109 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "109" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR109		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR109
		TRB2->PERCTB := (nGCR109 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "109" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE109		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE109
		TRB2->PERCTBE	:= (nGCE109 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)


	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "TOTAL DE MATERIAIS"
		TRB2->IDUSA		:= "199"
		TRB2->ORDEM		:= _cOrdem
		
		nGT199		:= nGT101+nGT102+nGT103+nGT104+nGT105+nGT106+nGT107+nGT108+nGT109
		nGP199		:= nGP101+nGP102+nGP103+nGP104+nGP105+nGP106+nGP107+nGP108+nGP109
		nGE199		:= nGE101+nGE102+nGE103+nGE104+nGE105+nGE106+nGE107+nGE108+nGE109
	
		TRB2->VLRVD 	:= nGT199
		TRB2->PERVD		:= (nGT199 / nXVDSI )*100
		
		TRB2->VLRPLN 	:= nGP199
		TRB2->PERPLN	:= (nGP199 / nXVDSIR )*100
		
		TRB2->VLREMP 	:= nGE199
		TRB2->PEREMP	:= (nGE199 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Submittals"
		TRB2->IDUSA		:= "201"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "201" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT201		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT201
		TRB2->PERVD		:= (nGT201 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "201" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP201		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP201
		TRB2->PERPLN	:= (nGP201 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "201" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE201		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE201
		TRB2->PEREMP	:= (nGE201 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "201" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR201		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR201
		TRB2->PERCTB := (nGCR201 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "201" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE201		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nGCE201
		TRB2->PERCTBE	:= (nGCE201 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Projeto / Layout / Calculos"
		TRB2->IDUSA		:= "202"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "202" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT202		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT202
		TRB2->PERVD		:= (nGT202 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "202" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP202		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP202
		TRB2->PERPLN	:= (nGP202 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "202" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE202		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE202
		TRB2->PEREMP	:= (nGE202 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "202" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR202		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR202
		TRB2->PERCTB := (nGCR202 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "202" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE202		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE202
		TRB2->PERCTBE	:= (nGCE202 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Detalhamento"
		TRB2->IDUSA		:= "204"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "204" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT204		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT204
		TRB2->PERVD		:= (nGT204 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "204" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP204		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP204
		TRB2->PERPLN	:= (nGP204 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "204" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE204		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE204
		TRB2->PEREMP	:= (nGE204 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "204" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR204		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR204
		TRB2->PERCTB := (nGCR204 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "204" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE204		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE204
		TRB2->PERCTBE	:= (nGCE204 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Verificacao / Aprovacao"
		TRB2->IDUSA		:= "205"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "205" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT205		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT205
		TRB2->PERVD		:= (nGT205 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "205" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP205		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP205
		TRB2->PERPLN	:= (nGP205 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "205" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE205		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE205
		TRB2->PEREMP	:= (nGE205 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "205" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR205		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR205
		TRB2->PERCTB := (nGCR205 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "205" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE205		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE205
		TRB2->PERCTBE	:= (nGCE205 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Engenharia de Acionamento"
		TRB2->IDUSA		:= "206"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "206" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT206		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT206
		TRB2->PERVD		:= (nGT206 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "206" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP206		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP206
		TRB2->PERPLN	:= (nGP206 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "206" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE206		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE206
		TRB2->PEREMP	:= (nGE206 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "206" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR206		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR206
		TRB2->PERCTB := (nGCR206 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "206" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE206		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE206
		TRB2->PERCTBE	:= (nGCE206 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Engenharia Eletrica"
		TRB2->IDUSA		:= "207"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "207" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT207		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT207
		TRB2->PERVD		:= (nGT207 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "207" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP207		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP207
		TRB2->PERPLN	:= (nGP207 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "207" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE207		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE207
		TRB2->PEREMP	:= (nGE207 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "207" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR207		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR207
		TRB2->PERCTB := (nGCR207 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "207" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE207		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE207
		TRB2->PERCTBE	:= (nGCE207 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "ENGENHARIA SUBTOTAL"
		TRB2->IDUSA		:= "209"
		TRB2->ORDEM		:= _cOrdem
	
		nGT209		:= nGT201+nGT202+nGT204+nGT205+nGT206+nGT207
		nGP209		:= nGP201+nGP202+nGP204+nGP205+nGP206+nGP207
		nGE209		:= nGE201+nGE202+nGE204+nGE205+nGE206+nGE207

		TRB2->VLRVD 	:= nGT209
		TRB2->PERVD		:= (nGT209 / nXVDSI )*100
		
		TRB2->VLRPLN 	:= nGP209
		TRB2->PERPLN	:= (nGP209 / nXVDSIR )*100
		
		TRB2->VLREMP 	:= nGE209
		TRB2->PEREMP	:= (nGE209 / nXVDSIR )*100
		

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Gerenciamento de Projetos"
		TRB2->IDUSA		:= "210"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "210" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT210		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT210
		TRB2->PERVD		:= (nGT210 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "210" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP210		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP210
		TRB2->PERPLN	:= (nGP210 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "210" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE210		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE210
		TRB2->PEREMP	:= (nGE210 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "210" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR210		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR210
		TRB2->PERCTB := (nGCR210 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "210" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE210		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE210
		TRB2->PERCTBE	:= (nGCE210 / nXVDSIR )*100
		

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Compras / Expedicao"
		TRB2->IDUSA		:= "211"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "211" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT211		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT211
		TRB2->PERVD		:= (nGT211 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "211" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP211		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP211
		TRB2->PERPLN	:= (nGP211 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "211" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE211		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE211
		TRB2->PEREMP	:= (nGE211 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "211" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR211		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR211
		TRB2->PERCTB := (nGCR211 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "211" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE211		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE211
		TRB2->PERCTBE	:= (nGCE211 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Montagem Eletrica"
		TRB2->IDUSA		:= "212"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "212" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT212		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT212
		TRB2->PERVD		:= (nGT212 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "212" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP212		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP212
		TRB2->PERPLN	:= (nGP212 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "212" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE212		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE212
		TRB2->PEREMP	:= (nGE212 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "212" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR212		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR212
		TRB2->PERCTB := (nGCR212 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "212" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE212		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE212
		TRB2->PERCTBE	:= (nGCE212 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Outra Montagem / Teste"
		TRB2->IDUSA		:= "213"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "213" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT213		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT213
		TRB2->PERVD		:= (nGT213 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "213" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP213		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP213
		TRB2->PERPLN	:= (nGP213 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "213" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE213		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE213
		TRB2->PEREMP	:= (nGE213 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "213" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR213		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR213
		TRB2->PERCTB := (nGCR213 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "213" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE213		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE213
		TRB2->PERCTBE	:= (nGCE213 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Inspecao"
		TRB2->IDUSA		:= "217"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "217" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT217		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT217
		TRB2->PERVD		:= (nGT217 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "217" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP217		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP217
		TRB2->PERPLN	:= (nGP217 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "217" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE217		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE217
		TRB2->PEREMP	:= (nGE217 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "217" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR217		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR217
		TRB2->PERCTB := (nGCR217 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "217" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE217		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE217
		TRB2->PERCTBE	:= (nGCE217 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Servico / Teste de Campo"
		TRB2->IDUSA		:= "218"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "218" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT218		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT218
		TRB2->PERVD		:= (nGT218 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "218" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP218		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP218
		TRB2->PERPLN	:= (nGP218 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "218" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE218		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE218
		TRB2->PEREMP	:= (nGE218 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "218" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR218		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR218
		TRB2->PERCTB := (nGCR218 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "218" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE218		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE218
		TRB2->PERCTBE	:= (nGCE218 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Outro, O&M, Copia, Embarque"
		TRB2->IDUSA		:= "220"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "220" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT220		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT220
		TRB2->PERVD		:= (nGT220 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "220" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP220		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP220
		TRB2->PERPLN	:= (nGP220 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "220" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE220		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE220
		TRB2->PEREMP	:= (nGE220 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "220" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR220		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR220
		TRB2->PERCTB := (nGCR220 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "220" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE220		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE220
		TRB2->PERCTBE	:= (nGCE220 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Testes / Modificacoes Eletricas"
		TRB2->IDUSA		:= "221"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "221" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT221		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT221
		TRB2->PERVD		:= (nGT221 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "221" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP221		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP221
		TRB2->PERPLN	:= (nGP221 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "221" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE221		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE221
		TRB2->PEREMP	:= (nGE221 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "221" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR221		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR221
		TRB2->PERCTB := (nGCR221 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "221" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE221		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE221
		TRB2->PERCTBE	:= (nGCE221 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Programacao PLC"
		TRB2->IDUSA		:= "222"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "222" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT222		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT222
		TRB2->PERVD		:= (nGT222 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "222" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP222		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP222
		TRB2->PERPLN	:= (nGP222 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "222" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE222		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE222
		TRB2->PEREMP	:= (nGE222 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "222" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR222		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR222
		TRB2->PERCTB := (nGCR222 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "222" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE222		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE222
		TRB2->PERCTBE	:= (nGCE222 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "TOTAL MAO-DE-OBRA"
		TRB2->IDUSA		:= "299"
		TRB2->ORDEM		:= _cOrdem
		
		nGT299		:= nGT201+nGT202+nGT204+nGT205+nGT206+nGT207+nGT210+nGT211+nGT212+nGT213+nGT217+nGT218+nGT220+nGT221+nGT222
		nGP299		:= nGP201+nGP202+nGP204+nGP205+nGP206+nGP207+nGP210+nGP211+nGP212+nGP213+nGP217+nGP218+nGP220+nGP221+nGP222
		nGE299		:= nGE201+nGE202+nGE204+nGE205+nGE206+nGE207+nGE210+nGE211+nGE212+nGE213+nGE217+nGE218+nGE220+nGE221+nGE222
		
		TRB2->VLRVD 	:= nGT299
		TRB2->PERVD		:= (nGT299 / nXVDSI )*100
		
		TRB2->VLRPLN 	:= nGP299
		TRB2->PERPLN	:= (nGP299 / nXVDSIR )*100
		
		TRB2->VLREMP 	:= nGE299
		TRB2->PEREMP	:= (nGE299 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Frete, Embalagem, Afins"
		TRB2->IDUSA		:= "301"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "301" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT301		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT301
		TRB2->PERVD		:= (nGT301 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "301" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP301		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP301
		TRB2->PERPLN	:= (nGP301 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "301" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE301		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE301
		TRB2->PEREMP	:= (nGE301 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "301" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR301		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR301
		TRB2->PERCTB := (nGCR301 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "301" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE301		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE301
		TRB2->PERCTBE	:= (nGCE301 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Servicos Externos"
		TRB2->IDUSA		:= "501"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "501" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT501		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT501
		TRB2->PERVD		:= (nGT501 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "501" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP501		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP501
		TRB2->PERPLN	:= (nGP501 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "501" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE501		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE501
		TRB2->PEREMP	:= (nGE501 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "501" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR501		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR501
		TRB2->PERCTB := (nGCR501 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "501" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE501		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE501
		TRB2->PERCTBE	:= (nGCE501 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Despesas de Inspecao de Fabrica"
		TRB2->IDUSA		:= "601"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "601" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT601		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT601
		TRB2->PERVD		:= (nGT601 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "601" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP601		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP601
		TRB2->PERPLN	:= (nGP601 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "601" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE601		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE601
		TRB2->PEREMP	:= (nGE601 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "601" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR601		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR601
		TRB2->PERCTB := (nGCR601 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "601" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE601		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE601
		TRB2->PERCTBE	:= (nGCE601 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	/*********************************************/
	
	RecLock("TRB2",.T.)
		
		// VENDIDO
		TRB2->DESCUSA	:= "Despesas de Servico de Campo / Supervisao"
		TRB2->IDUSA		:= "701"
		TRB2->ORDEM		:= _cOrdem
		
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "701" .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
				nGT701		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRVD 	:= nGT701
		TRB2->PERVD		:= (nGT701 / nXVDSI )*100
		
		// PLANEJADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "701" .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
				nGP701		+= TRB1->VALOR
			endif
			TRB1->(dbskip())
		EndDo
		TRB2->VLRPLN 	:= nGP701
		TRB2->PERPLN	:= (nGP701 / nXVDSIR )*100
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "701" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE701		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE701
		TRB2->PEREMP	:= (nGE701 / nXVDSIR )*100
		
		// CONTABIL CUSTO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "701" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nGCR701		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTB := nGCR701
		TRB2->PERCTB := (nGCR701 / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "701" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nGCE701		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		
		TRB2->VLRCTBE 	:= nGCE701
		TRB2->PERCTBE	:= (nGCE701 / nXVDSIR )*100

	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	

	//*********************** CUSTO DE PRODUCAO******************************
	RecLock("TRB2",.T.)
		TRB2->DESCUSA		:= "CUSTO PRODUCAO"
		TRB2->IDUSA		:= "000"
		TRB2->ID		:= "XX1"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		else
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD" 
					nCPRValV		:= TRB1->VALOR
					nCPRTotV		+= nCPRValV
				endif
				TRB1->(dbskip())
			EndDo
		endif

		TRB2->VLRVD		 := nCPRTotV  // nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		TRB2->PERVD 	:= (nCPRTotV   / nXVDSIR )*100 //((nCPRTotV + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100

		// PLNAJEDO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if !TRB1->IDUSA $ ("801/900/901/902/903/904/905/906/908")  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ELSE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCPRValP		:= TRB1->VALOR
					nCPRTotP		+= nCPRValP
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		TRB2->VLRPLN := nCPRTotP //+ (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100))
		TRB2->PERPLN := (nCPRTotP  / nXVDSIR )*100  // ((nCPRTotP + (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)))  / nXVDSIR )*100 

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if !TRB1->IDUSA $ ("801/802/803/804/805/806/908") .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" // TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP" .OR. 
				nCPRVal		:= TRB1->VALOR  //SC7->C7_XTOTSI
				nCPRTot		+= nCPRVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLREMP := nCPRTot
		TRB2->PEREMP	:= (nCPRTot / nXVDSIR )*100

		//  CUSTO CONTABIL
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nCPRTotC	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		//  CUSTO CONTABIL ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID <> "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nCPRTotE	+= (TRB1->VDEBITO - TRB1->VCREDITO)
			endif
			TRB1->(dbskip())
		EndDo

		// RECEITA CONTABIL
		TRB4->(dbgotop())
		While TRB4->( ! EOF() )
			if TRB4->RID == "REC"
				nCPRTotR	+= (TRB4->RVCREDITO - TRB4->RVDEBITO )
			endif
			TRB4->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLRCTB := nCPRTotC
		TRB2->PERCTB	:= (nCPRTotC / nCPRTotR )*100

		TRB2->VLRCTBE := nCPRTotE
		TRB2->PERCTBE	:= (nCPRTotE / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
		MsUnlock()

		//*********************** MARGEM BRUTA ********************************
		RecLock("TRB2",.T.)
		TRB2->DESCUSA		:= "MARGEM BRUTA"
		TRB2->IDUSA		:= "000"
		TRB2->ID		:= "MKB"
		TRB2->DESCRICAO	:= ""
		TRB2->ORDEM		:= _cOrdem

		TRB2->VLRVD	:= nXVDSI - nCPRTotV 
		TRB2->PERVD	:= ((nXVDSI - nCPRTotV) / nXVDSI )*100

		TRB2->VLRPLN	:= nXVDSIR - nCPRTotP 
		TRB2->PERPLN	:= ((nXVDSIR - nCPRTotP) / nXVDSIR )*100

		TRB2->VLREMP	:= nXVDSIR - nCPRTot
		TRB2->PEREMP	:= ((nXVDSIR - nCPRTot) / nXVDSIR )*100

		TRB2->VLRCTB	:= nCPRTotR - nCPRTotC
		TRB2->PERCTB	:= ((nCPRTotR - nCPRTotC) / nCPRTotR ) *100
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)

	//*********************** CONTINGENCIAS ********************************
	RecLock("TRB2",.T.)
	
		TRB2->ID		:= "CTG"
		TRB2->IDUSA		:= "801"
		TRB2->DESCUSA	:= "Contingencias"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "801"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ELSE
			TRB2->VLRVD 	:= nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)
		ENDIF
		TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "801"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ELSE
			TRB2->VLRPLN 	:= nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)
		ENDIF
		TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")
		
		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "801" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE801		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE801
		TRB2->PEREMP	:= (nGE801 / nXVDSIR )*100
		//****************************************
	MsUnlock()
	_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
	_cOrdem := soma1(_cOrdem)
	
	//*********************** CALCULO GRUPO 801/901/902/903/904/905/906/908 NOVO SISTEMA ********************************
	// 901 OUTROS CUSTOS NOVOS
	IF nTotRegZZM > 0 .OR. nTotRegZZN > 0
		RecLock("TRB2",.T.)

		TRB2->ID		:= "TRI"
		TRB2->IDUSA		:= "901"
		TRB2->DESCUSA	:= "Tributos"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "901"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "901"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "901" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE901		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE901
		TRB2->PEREMP	:= (nGE901 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		// 902
		RecLock("TRB2",.T.)

		TRB2->ID		:= "OBR"
		TRB2->IDUSA		:= "902"
		TRB2->DESCUSA	:= "Obrigacoes / Carta de Credito"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "902"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "902"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "902" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE902		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE902
		TRB2->PEREMP	:= (nGE902 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		// 903
		RecLock("TRB2",.T.)

		TRB2->ID		:= "TAX"
		TRB2->IDUSA		:= "903"
		TRB2->DESCUSA	:= "Taxas de Patente / Licenca"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "903"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "903"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "903" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE903		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE903
		TRB2->PEREMP	:= (nGE903 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
		
		// 904
		RecLock("TRB2",.T.)

		TRB2->ID		:= "STA"
		TRB2->IDUSA		:= "904"
		TRB2->DESCUSA	:= "Standby / Letter of Credit / Bounds"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "904"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "904"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "904" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE904		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE904
		TRB2->PEREMP	:= (nGE904 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		// 905
		RecLock("TRB2",.T.)

		TRB2->ID		:= "FRE"
		TRB2->IDUSA		:= "905"
		TRB2->DESCUSA	:= "Frete pre-pago"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "905"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "905"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "905" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE905		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE905
		TRB2->PEREMP	:= (nGE905 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		// 906
		RecLock("TRB2",.T.)

		TRB2->ID		:= "OUT"
		TRB2->IDUSA		:= "906"
		TRB2->DESCUSA	:= "Outros"
		TRB2->ORDEM		:= _cOrdem

		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "906"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "906"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "906" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE906		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE906
		TRB2->PEREMP	:= (nGE906 / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		

		//*********************** COGS ********************************
		/*
		nOUTCUS3 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) 
		*/
		RecLock("TRB2",.T.)
			TRB2->ID		:= "XX1"
			TRB2->IDUSA		:= "000"
			TRB2->DESCUSA	:= "COGS"
			TRB2->ORDEM		:= _cOrdem
			
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV2		+= nCTOValV2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := nCTOTotV2
			TRB2->PERVD	:= (nCTOTotV2 / nXVDSI )*100
			
			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP2		+= nCTOValP2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRPLN := (nCTOTotP2 )
			TRB2->PERPLN	:= ((nCTOTotP2) / nXVDSIR )*100
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTot2		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot2
			TRB2->PEREMP	:= (nCTOTot2 / nXVDSIR )*100
			
			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotC2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo
			
			// CUSTO CONTABIL ESTOQUE	
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE" .AND. ALLTRIM(TRB1->ID) <> "CMS" .AND. !TRB1->IDUSA $ ('901/908')
					nCTOTotE2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC2
			TRB2->PERCTB	:= (nCTOTotC2 / nCPRTotR2 )*100

			TRB2->VLRCTBE := nCTOTotE2
			TRB2->PERCTBE	:= (nCTOTotE2 / nXVDSIR )*100

		
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			
		MsUnlock()
	

		// 908
		RecLock("TRB2",.T.)

		TRB2->ID		:= "CMS"
		TRB2->IDUSA		:= "908"
		TRB2->DESCUSA	:= "Comissao"
		TRB2->ORDEM		:= _cOrdem

		// -------------------------------
		// VENDIDO
		IF nTotRegZZM > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "908"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRVD"
					TRB2->VLRVD		:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// PLANEJADO
		IF nTotRegZZN > 0
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA = "908"  .AND. ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					TRB2->VLRPLN	:= TRB1->VALOR
				endif
				TRB1->(dbskip())
			EndDo
		ENDIF

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->IDUSA == "908" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nGE908		+= TRB1->VALOR
			endif
			TRB1->(dbskip()) 
		EndDo
		TRB2->VLREMP 	:= nGE908
		TRB2->PEREMP	:= (nGE908 / nXVDSIR )*100

		// CONTABIL
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nCMSTotC += (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		TRB2->VLRCTB 	:= nCMSTotC
		TRB2->PERCTB	:= (nCMSTotC / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
				nCMSTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip())
		EndDo

		TRB2->VLRCTBE 	:= nCMSTotE
		TRB2->PERCTBE	:= (nCMSTotE / nXVDSIR )*100

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		//*********************** CUSTO TOTAL ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA		:= "CUSTO TOTAL"
			TRB2->ID		:= "XX2"
			TRB2->IDUSA		:= "999"
			TRB2->ORDEM		:= _cOrdem

								
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := nCTOTotV
			TRB2->PERVD	:= ((nCTOTotV) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN" .AND. !TRB1->IDUSA $ ("199/209/299/799/200/299/900/901/999") 
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			TRB2->VLRPLN := nCTOTotP
			TRB2->PERPLN	:= (nCTOTotP / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB2->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot
			TRB2->PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC
			TRB2->PERCTB	:= (nCTOTotC / nCPRTotR )*100

			TRB2->VLRCTBE := nCTOTotE
			TRB2->PERCTBE	:= (nCTOTotE / nXVDSIR )*100

			MsUnlock()
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			MsUnlock()
		MsUnlock()

		//*********************** MARGEM CONTRIBUICAO ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA	:= "MARGEM CONTRIB."
			TRB2->ID		:= "MKC"
			TRB2->IDUSA		:= "000"
			TRB2->ORDEM		:= _cOrdem

			TRB2->VLRVD		:= nXVDSI - (nCTOTotV )
			TRB2->PERVD		:= ((nXVDSI - (nCTOTotV )) / nXVDSI )*100

			TRB2->VLRPLN	:= nXVDSIR - (nCTOTotP )
			TRB2->PERPLN	:= ((nXVDSIR - (nCTOTotP )) / nXVDSIR )*100

			TRB2->VLREMP	:= nXVDSIR - nCTOTot
			TRB2->PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			TRB2->VLRCTB	:= nCPRTotR - nCTOTotC
			TRB2->PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		
	ELSE
	//*********************** FIANCAS ********************************
	// OUTROS CUSTOS ANTIGOS
		RecLock("TRB2",.T.)
			
			TRB2->ID		:= "FIA"
			TRB2->IDUSA		:= "802"
			TRB2->DESCUSA	:= "Fiancas"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO
			TRB2->VLRVD 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)
			TRB2->PERVD	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")

			// PLANEJADO
			TRB2->VLRPLN 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA == "802" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
					nGE802		+= TRB1->VALOR
				endif
				TRB1->(dbskip()) 
			EndDo
			TRB2->VLREMP 	:= nGE802
			TRB2->PEREMP	:= (nGE802 / nXVDSIR )*100
			
			//****************************************
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		//*********************** CUSTO FINANCEIRO ********************************
		RecLock("TRB2",.T.)
			TRB2->ID		:= "CFI"
			TRB2->IDUSA		:= "803"
			TRB2->DESCUSA	:= "Custo Financeiro"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO
			TRB2->VLRVD 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)
			TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")

			// PLANEJADO
			TRB2->VLRPLN 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA == "803" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
					nGE803		+= TRB1->VALOR
				endif
				TRB1->(dbskip()) 
			EndDo
			TRB2->VLREMP 	:= nGE803
			TRB2->PEREMP	:= (nGE803 / nXVDSIR )*100
			//****************************************

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		//*********************** GARANTIA ********************************
		RecLock("TRB2",.T.)
			TRB2->ID		:= "GAR"
			TRB2->IDUSA		:= "804"
			TRB2->DESCUSA	:= "Garantia"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO
			TRB2->VLRVD 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)
			TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")

			// PLANEJADO
			TRB2->VLRPLN 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA == "804" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
					nGE804		+= TRB1->VALOR
				endif
				TRB1->(dbskip()) 
			EndDo
			TRB2->VLREMP 	:= nGE804
			TRB2->PEREMP	:= (nGE804 / nXVDSIR )*100
			//****************************************
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		//*********************** PERDA IMPOSTOS ********************************
		RecLock("TRB2",.T.)
			TRB2->ID		:= "PIM"
			TRB2->IDUSA		:= "805"
			TRB2->DESCUSA	:= "Perda Impostos"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO�
			TRB2->VLRVD 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)
			TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")

			// PLANEJADO�
			TRB2->VLRPLN 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA == "805" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
					nGE805		+= TRB1->VALOR
				endif
				TRB1->(dbskip()) 
			EndDo
			TRB2->VLREMP 	:= nGE805
			TRB2->PEREMP	:= (nGE805 / nXVDSIR )*100
			//****************************************
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
		
		//*********************** ROYALTY ********************************
		RecLock("TRB2",.T.)
			TRB2->ID		:= "ROY"
			TRB2->IDUSA		:= "806"
			TRB2->DESCUSA	:= "Royalty"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO
			TRB2->VLRVD 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)
			TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")

			// PLANEJADO
			TRB2->VLRPLN 	:= nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->IDUSA == "806" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
					nGE806		+= TRB1->VALOR
				endif
				TRB1->(dbskip()) 
			EndDo
			TRB2->VLREMP 	:= nGE806
			TRB2->PEREMP	:= (nGE806 / nXVDSIR )*100
			//****************************************

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		//*********************** COGS ********************************
		
		nOUTCUS3 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) 
		
		RecLock("TRB2",.T.)
			TRB2->ID		:= "XX1"
			TRB2->IDUSA		:= "000"
			TRB2->DESCUSA	:= "COGS"
			TRB2->ORDEM		:= _cOrdem
			
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD"
					nCTOValV2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV2		+= nCTOValV2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := (nCTOTotV2 + nOUTCUS3)
			TRB2->PERVD	:= ((nCTOTotV2+nOUTCUS3) / nXVDSI )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCTOValP2		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP2		+= nCTOValP2
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRPLN := (nCTOTotP2 + nOUTCUS3)
			TRB2->PERPLN	:= ((nCTOTotP2+nOUTCUS3) / nXVDSIR )*100
			
			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTot2		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot2
			TRB2->PEREMP	:= (nCTOTot2 / nXVDSIR )*100
			
			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTotC2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo
				
			// CUSTO CONTABIL ESTOQUE	
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE" .AND. ALLTRIM(TRB1->ID) <> "CMS"
					nCTOTotE2		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC2
			TRB2->PERCTB	:= (nCTOTotC2 / nCPRTotR2 )*100

			TRB2->VLRCTBE := nCTOTotE2
			TRB2->PERCTBE	:= (nCTOTotE2 / nXVDSIR )*100

		
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			
		MsUnlock()
		
		//*********************** COMISSAO ********************************

		RecLock("TRB2",.T.)
			
			TRB2->ID		:= "CMS"
			TRB2->IDUSA		:= "908"
			TRB2->DESCUSA	:= "Comissao"
			TRB2->ORDEM		:= _cOrdem

			// VENDIDO
			TRB2->VLRVD 	:= nXSISFV * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100)
			TRB2->PERVD		:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")

		// PLANEJADO
			TRB2->VLRPLN 	:= nXSISFR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100)
			TRB2->PERPLN	:= POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")

		// EMPENHADO
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLREMP"
				nCMSVal		:= TRB1->VALOR //SC7->C7_XTOTSI
				nCMSTot		+= nCMSVal
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo

		TRB2->VLREMP 	:= nCMSTot
		TRB2->PEREMP	:= (nCMSTot / nXVDSIR )*100
		//****************************************

		// CONTABIL
		TRB1->(dbgotop())
		While TRB1->( ! EOF() )
			if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTB"
				nCMSTotC += (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
			endif
			TRB1->(dbskip()) //SC7->(dbskip())
		EndDo
		TRB2->VLRCTB 	:= nCMSTotC
		TRB2->PERCTB	:= (nCMSTotC / nXVDSIR )*100

		// CONTABIL CUSTO ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if TRB1->ID == "CMS" .AND. ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCMSTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO) //SC7->C7_XTOTSI
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTBE 	:= nCMSTotE
			TRB2->PERCTBE	:= (nCMSTotE / nXVDSIR )*100
		//****************************************

		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)
	
		//*********************** CUSTO TOTAL ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA		:= "CUSTO TOTAL"
			TRB2->ID		:= "XX2"
			TRB2->IDUSA		:= "999"
			TRB2->ORDEM		:= _cOrdem

			nOUTCUS1 := (nXCUSTO * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCONT")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XFIANC")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XCUSFI")/100)) + (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPROVG")/100)) + ;
					(nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPERDI")/100)) +  (nXVDSI * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XROYAL")/100)) + ;
					(nXVDSIR * (POSICIONE("CTD",1,XFILIAL("CTD")+ _cItemConta,"CTD_XPCOM")/100))
					
			// VENDIDO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRVD"
					nCTOValV		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotV		+= nCTOValV
				endif
				TRB1->(dbskip()) //SC7->(dbskip())
			EndDo

			TRB2->VLRVD := (nCTOTotV + nOUTCUS1)
			TRB2->PERVD	:= ((nCTOTotV+nOUTCUS1) / nXVDSIR )*100

			// PLANEJADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if ALLTRIM(TRB1->CAMPO) == "VLRPLN"
					nCTOValP		:= TRB1->VALOR  //SC7->C7_XTOTSI
					nCTOTotP		+= nCTOValP
				endif
				TRB1->(dbskip()) //SC7->(dbskip())

			EndDo

			TRB2->VLRPLN := (nCTOTotP + nOUTCUS1)
			TRB2->PERPLN	:= ((nCTOTotP+nOUTCUS1) / nXVDSIR )*100

			// EMPENHADO
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLREMP" .AND. ALLTRIM(TRB2->ID) <> "CMS"
					nCTOTot		+= TRB1->VALOR
				endif

				TRB1->(dbskip())
			EndDo
			TRB2->VLREMP 	:= nCTOTot
			TRB2->PEREMP	:= (nCTOTot / nXVDSIR )*100

			// CUSTO CONTABIL
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTB"
					nCTOTotC		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			// CUSTO CONTABIL ESTOQUE
			TRB1->(dbgotop())
			While TRB1->( ! EOF() )
				if  ALLTRIM(TRB1->CAMPO) == "VLRCTBE"
					nCTOTotE		+= (TRB1->VDEBITO - TRB1->VCREDITO)
				endif
				TRB1->(dbskip())
			EndDo

			TRB2->VLRCTB := nCTOTotC
			TRB2->PERCTB	:= (nCTOTotC / nCPRTotR )*100

			TRB2->VLRCTBE := nCTOTotE
			TRB2->PERCTBE	:= (nCTOTotE / nXVDSIR )*100

			MsUnlock()
			_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
			_cOrdem := soma1(_cOrdem)
			MsUnlock()
		MsUnlock()

		//*********************** MARGEM CONTRIBUICAO ********************************
		RecLock("TRB2",.T.)
			TRB2->DESCUSA	:= "MARGEM CONTRIB."
			TRB2->ID		:= "MKC"
			TRB2->IDUSA		:= "000"
			TRB2->ORDEM		:= _cOrdem

			TRB2->VLRVD		:= nXVDSI - (nCTOTotV + nOUTCUS1)
			TRB2->PERVD		:= ((nXVDSI - (nCTOTotV + nOUTCUS1)) / nXVDSI )*100

			TRB2->VLRPLN	:= nXVDSIR - (nCTOTotP + nOUTCUS1)
			TRB2->PERPLN	:= ((nXVDSIR - (nCTOTotP + nOUTCUS1)) / nXVDSIR )*100

			TRB2->VLREMP	:= nXVDSIR - nCTOTot
			TRB2->PEREMP	:= ((nXVDSIR - nCTOTot) / nXVDSIR )*100

			TRB2->VLRCTB	:= nCPRTotR - nCTOTotC
			TRB2->PERCTB	:= ((nCPRTotR - nCTOTotC) / nCPRTotR )*100
		MsUnlock()
		_nRecSaldo 	:= TRB2->(recno()) // Guarda o recno da linha de saldo
		_cOrdem := soma1(_cOrdem)

		dbSelectArea("CTD")
		CTD->( dbSetOrder(1) )
		
		If CTD->( dbSeek(xFilial("CTD")+_cItemConta) )
			RecLock("CTD",.F.)
				CTD->CTD_XACPR  := nCPRTot
				CTD->CTD_XACTO  := nCTOTot
				CTD->CTD_XCUPRR := nCPRTotP
				CTD->CTD_XCUTOR := nCTOTotP + nOUTCUS1
				CTD->CTD_XCOGSR := nCTOTotP2 + nOUTCUS3
				CTD->CTD_XCOGSV := nCTOTotV2 + nOUTCUS3

			MsUnLock()
		endif
	
	ENDIF
// Gravacao de uma linha para movimentos sem natureza ou grupo de naturezas


return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa FATURAMENTO REALIZADO    		                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


static function zFaturSD2()

local _cQuery := ""
Local _cFilSD2 := xFilial("SD2")

local cFor 		:= "ALLTRIM(QUERY->D2_ITEMCC) = _cItemConta"
local cFor2 	:= "ALLTRIM(QUERY2->E1_XXIC)  = _cItemConta .AND. ALLTRIM(QUERY2->E1_TIPO) == 'INV'"
local cFor3 	:= "ALLTRIM(QUERY3->D1_ITEMCTA)  = _cItemConta .AND. ALLTRIM(QUERY3->D1_CF) $ '1201/2201/5201'"
local nTotFat 	:= 0
local nTotFat2 	:= 0

SD2->(dbsetorder(1)) 
ChkFile("SD2",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"D2_EMISSAO",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))
QUERY->(dbgotop())

/****************************/
SE1->(dbsetorder(1))
ChkFile("SE1",.F.,"QUERY2") 

/****************************/
SD1->(dbsetorder(1)) 
ChkFile("SD1",.F.,"QUERY3") 

/************DOC SAIDA*****************/

while QUERY->(!eof())

		if QUERY->D2_CF >= '5101' .AND. QUERY->D2_CF <= '5125'   ;
				 .OR. QUERY->D2_CF >= '5551' .AND. QUERY->D2_CF <= '5551'   ;
				 .OR. QUERY->D2_CF >= '5922' .AND. QUERY->D2_CF <= '5922'   ;
				 .OR. QUERY->D2_CF >= '5933' .AND. QUERY->D2_CF <= '5933'   ; 
				 .OR. QUERY->D2_CF >= '6101' .AND. QUERY->D2_CF <= '6106'   ; 
				 .OR. QUERY->D2_CF >= '6109' .AND. QUERY->D2_CF <= '6120'   ; 
				 .OR. QUERY->D2_CF >= '6122' .AND. QUERY->D2_CF <= '6125'   ; 
				 .OR. QUERY->D2_CF >= '6551' .AND. QUERY->D2_CF <= '6551'   ; 
				 .OR. QUERY->D2_CF >= '6933' .AND. QUERY->D2_CF <= '6933'   ; 
				 .OR. QUERY->D2_CF >= '7101' .AND. QUERY->D2_CF <= '7933'    ; 
				 .OR. QUERY->D2_CF = '7949' .AND. SUBSTRING(QUERY->D2_ITEMCC,1,2) = 'AT'  ; 
				 .OR. QUERY->D2_CF = '7949' .AND. SUBSTRING(QUERY->D2_ITEMCC,1,2) = 'CM'  ; 
				 .OR. QUERY->D2_CF = '7949' .AND. SUBSTRING(QUERY->D2_ITEMCC,1,2) = 'EN'

		RecLock("TRB5",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->D2_DOC))
		ProcessMessage()
		
		TRB5->FRTIPO	:= "NF SAIDA"
		TRB5->FRDTMOV	:= QUERY->D2_EMISSAO
		TRB5->FRTPMOV	:= "NF"
		TRB5->FRCFOP	:= QUERY->D2_CF
		TRB5->FRDOCTO	:= QUERY->D2_SERIE + " " + QUERY->D2_DOC
		TRB5->FRVLRDC	:= QUERY->D2_VALBRUT
		TRB5->FRVLRSI	:= (QUERY->D2_VALBRUT-QUERY->D2_VALIPI)-QUERY->D2_VALICM-QUERY->D2_VALISS-QUERY->D2_VALIMP6-QUERY->D2_VALIMP5
		TRB5->FRICTA	:= QUERY->D2_ITEMCC
		TRB5->FRDTMOV2	:= QUERY->D2_EMISSAO
		
		nTotFat 	+= QUERY->D2_VALBRUT
		nTotFat2	+= (QUERY->D2_VALBRUT-QUERY->D2_VALIPI)-QUERY->D2_VALICM-QUERY->D2_VALISS-QUERY->D2_VALIMP6-QUERY->D2_VALIMP5
		MsUnlock()

	endif

	QUERY->(dbskip())

enddo

/****************INVOICE**************************/

IndRegua("QUERY2",CriaTrab(NIL,.F.),"E1_VENCREA",,cFor2,"Selecionando Registros...")

ProcRegua(QUERY2->(reccount()))

QUERY2->(dbgotop())

while QUERY2->(!eof())

		
		RecLock("TRB5",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY2->E1_NUM))
		ProcessMessage()
		
		TRB5->FRTIPO	:= "INVOICE"
		TRB5->FRDTMOV	:= QUERY2->E1_VENCREA
		TRB5->FRTPMOV	:= QUERY2->E1_TIPO
		TRB5->FRCFOP	:= ""
		TRB5->FRDOCTO	:= QUERY2->E1_NUM
		TRB5->FRVLRDC	:= QUERY2->E1_VLCRUZ
		TRB5->FRVLRSI	:= QUERY2->E1_VLCRUZ
		TRB5->FRICTA	:= QUERY2->E1_XXIC
		TRB5->FRDTMOV2	:= QUERY2->E1_VENCREA

		nTotFat 	+= QUERY2->E1_VLCRUZ
		nTotFat2	+= QUERY2->E1_VLCRUZ
		MsUnlock()

	QUERY2->(dbskip())

enddo

/****************NF DEVOLUCAO**************************/

IndRegua("QUERY3",CriaTrab(NIL,.F.),"D1_EMISSAO",,cFor3,"Selecionando Registros...")

ProcRegua(QUERY3->(reccount()))

QUERY3->(dbgotop())

while QUERY3->(!eof())

		
		RecLock("TRB5",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY3->D1_DOC))
		ProcessMessage()
		
		TRB5->FRTIPO	:= "NF DEVOLUCAO"
		TRB5->FRDTMOV	:= QUERY3->D1_EMISSAO
		TRB5->FRTPMOV	:= "NF"
		TRB5->FRDOCTO	:= QUERY3->D1_SERIE + " " + QUERY3->D1_DOC
		TRB5->FRVLRDC	:= -QUERY3->D1_TOTAL
		TRB5->FRVLRSI	:= -QUERY3->D1_TOTAL
		TRB5->FRICTA	:= QUERY3->D1_ITEMCTA
		TRB5->FRDTMOV2	:= QUERY3->D1_EMISSAO
		
		nTotFat 	+= -QUERY3->D1_TOTAL
		nTotFat2	+= -QUERY3->D1_TOTAL
		MsUnlock()

	QUERY3->(dbskip())

enddo

/******************************************/

RecLock("TRB5",.T.)
	TRB5->FRTIPO	:= "TOTAL"
	TRB5->FRDTMOV2	:=  ctod("31/12/2099")
	TRB5->FRVLRDC	:= nTotFat
	TRB5->FRVLRSI	:= nTotFat2
MsUnlock()


QUERY->(dbclosearea())
QUERY2->(dbclosearea())
QUERY3->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa FATURAMENTO Planejado       		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zFaturSZQ()

local _cQuery := ""
Local _cFilSZQ := xFilial("SZQ")

local cFor 		:= "ALLTRIM(QUERY->ZQ_ITEMIC) = _cItemConta"

local nTotFat1 	:= 0
local nTotFat2 	:= 0

SZQ->(dbsetorder(1)) 
ChkFile("SZQ",.F.,"QUERY") // Alias dos movimentos bancarios
IndRegua("QUERY",CriaTrab(NIL,.F.),"ZQ_DATA",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

/************DOC SAIDA*****************/

while QUERY->(!eof())

		RecLock("TRB6",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->ZQ_DESCRI))
		ProcessMessage()
		
		TRB6->FPITEM	:= QUERY->ZQ_ITEM
		TRB6->FPDTMOV	:= QUERY->ZQ_DATA
		TRB6->FPHIST	:= QUERY->ZQ_DESCRI
		TRB6->FPVLRCI	:= QUERY->ZQ_FATREV
		TRB6->FPVLRSI	:= QUERY->ZQ_FATRVSI
		TRB6->FPICTA	:= QUERY->ZQ_ITEMIC
		TRB6->FPDTMOV2	:= QUERY->ZQ_DATA
		TRB6->FATFIN	:= QUERY->ZQ_FATFIN

		nTotFat1 +=  QUERY->ZQ_FATREV
		nTotFat2 +=  QUERY->ZQ_FATRVSI
		
		MsUnlock()

	QUERY->(dbskip())

enddo

RecLock("TRB6",.T.)
	TRB6->FPITEM	:= "TOTAL"
	TRB6->FPDTMOV2	:= ctod("31/12/2099")
	
	TRB6->FPVLRCI	:= nTotFat1
	TRB6->FPVLRSI	:= nTotFat2
MsUnlock()

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa recebimento realizado       		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zRecSE5()

local _cQuery := ""
Local _cFilSE5 := xFilial("SE5")

local cFor 		:= "ALLTRIM(QUERY->E5_XXIC) = _cItemConta .AND. QUERY->E5_RECPAG $ 'R/P' .AND. QUERY->E5_TIPODOC $ 'RA/VL/ES' .AND. QUERY->E5_BANCO <> '' .AND. QUERY->E5_BANCO <> 'CX1' .AND. QUERY->E5_CLIENTE <> ''  "
local cFor2		:= "ALLTRIM(QUERY2->E5_XXIC) = _cItemConta .AND. QUERY2->E5_RECPAG $ 'R' .AND. QUERY2->E5_TIPODOC $ 'CP' .AND. QUERY2->E5_BANCO <> 'CX1' .AND. QUERY2->E5_CLIENTE <> ''  "
local nTotREC1 	:= 0

 cQuery := "SELECT DISTINCT E1_XXIC AS 'TMP_CONTRATO', E5_NUMERO AS 'TMP_NTITULO', CAST(E5_DATA AS DATE) AS 'TMP_DATA', E5_VALOR AS 'TMP_VALOR',  E5_BENEF AS 'TMP_EMPRESA', "
 cQuery += "	E5_HISTOR AS 'TMP_HISTORICO', E5_DOCUMEN AS 'TMP_DOCUMENTO', E5_TIPO AS 'TMP_TIPO', E5_BANCO AS 'TMP_BANCO', E5_AGENCIA AS 'TMP_AGENCIA', A6_NOME AS 'TMP_NOME', E5_CONTA AS 'TMP_CONTA' FROM SE5010 "
 cQuery += "	LEFT JOIN SE1010 ON SE1010.E1_NUM = SE5010.E5_NUMERO AND E1_CLIENTE = E5_CLIFOR  "
 cQuery += "	LEFT JOIN SA6010 ON SA6010.A6_COD = E5_BANCO AND A6_AGENCIA = E5_AGENCIA "
 cQuery += "	WHERE SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
 cQuery += " E1_XXIC		  >= '" + _cItemConta + "' AND  "
 cQuery += " E1_XXIC    	  <= '" + _cItemConta + "' AND  "
 cQuery += "E5_RECPAG = 'R' AND E1_BAIXA = '' AND E5_TIPODOC IN ('RA') "
  cQuery += " OR "
 cQuery += " SE5010.D_E_L_E_T_ <> '*' AND SE1010.D_E_L_E_T_ <> '*' AND SA6010.D_E_L_E_T_ <> '*' AND "
 cQuery += " E1_XXIC		  >= '" + _cItemConta + "' AND  "
 cQuery += " E1_XXIC    	  <= '" + _cItemConta + "' AND  "
 cQuery += "E5_RECPAG = 'R' AND E1_BAIXA <> '' AND E5_TIPODOC IN ('VL') ORDER BY 3, 1 "

	IF Select("cQuery") <> 0
		DbSelectArea("cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())

QUERY->(dbgotop())

/************MOVIMENTO BANCARIO*****************/

while QUERY->(!eof())

		RecLock("TRB7",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->TMP_NTITULO))
		ProcessMessage()
		
		TRB7->RRTIPO	:= "Recebimento(" + QUERY->TMP_TIPO + ")"
		TRB7->RRDTMOV	:= QUERY->TMP_DATA
		TRB7->RRDOCTO	:= QUERY->TMP_NTITULO
		TRB7->RRVLRDC	:= QUERY->TMP_VALOR
		TRB7->RRBENEF	:= QUERY->TMP_EMPRESA
		TRB7->RRHIST	:= QUERY->TMP_HISTORICO
		TRB7->RRICTA	:= QUERY->TMP_CONTRATO
		TRB7->RRDTMOV2	:= QUERY->TMP_DATA
				
		nTotREC1 +=  QUERY->TMP_VALOR
				
		MsUnlock()

	QUERY->(dbskip())

enddo

RecLock("TRB7",.T.)
	TRB7->RRTIPO	:= "TOTAL"
	TRB7->RRDTMOV2	:=  ctod("31/12/2099")
	
	TRB7->RRVLRDC	:= nTotREC1
	
MsUnlock()

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa recebimento planejado       		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zRecSE1()

local _cQuery := ""
Local _cFilSE1 := xFilial("SE1")

local cFor 		:= "ALLTRIM(QUERY->E1_XXIC) = _cItemConta .AND. ALLTRIM(QUERY->E1_TIPO) = 'PR'   "

local nTotREC1 	:= 0
local nTotREC2 	:= 0

SE1->(dbsetorder(1)) 
ChkFile("SE1",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"E1_VENCREA",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())


/************MOVIMENTO BANCARIO*****************/

while QUERY->(!eof())

		RecLock("TRB8",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E1_NUM))
		ProcessMessage()
		
		TRB8->RPTIPO	:= "Recebimento"
		TRB8->RPDTMOV	:= QUERY->E1_VENCREA
		TRB8->RPDOCTO	:= QUERY->E1_NUM
		TRB8->RPTPDOC	:= QUERY->E1_TIPO

		TRB8->RPVLRDC	:= QUERY->E1_VLCRUZ
		TRB8->RPVLRDC2	:= QUERY->E1_VALOR
		TRB8->RPMOEDA	:= QUERY->E1_MOEDA
		TRB8->RPTXMOE	:= QUERY->E1_TXMOEDA

		TRB8->RPBENEF	:= QUERY->E1_NOMCLI
		TRB8->RPHIST	:= QUERY->E1_HIST
		TRB8->RPICTA	:= QUERY->E1_XXIC
		TRB8->RPDTMOV2	:= QUERY->E1_VENCREA
		
		TRB8->RPCLIENT	:= QUERY->E1_CLIENTE
		TRB8->RPNCLIEN	:= QUERY->E1_NOMCLI
		TRB8->RPLOJA	:= QUERY->E1_LOJA
		TRB8->RPPREF	:= QUERY->E1_PREFIXO
		TRB8->RPPARCEL	:= QUERY->E1_PARCELA
					
		nTotREC1 +=  QUERY->E1_VLCRUZ
		nTotREC2 +=  QUERY->E1_VALOR
				
		MsUnlock()

	QUERY->(dbskip())

enddo

RecLock("TRB8",.T.)
	TRB8->RPTIPO	:= "TOTAL"
	TRB8->RPDTMOV2	:= ctod("31/12/2099")
	
	TRB8->RPVLRDC	:= nTotREC1
	TRB8->RPVLRDC2	:= nTotREC2
	
MsUnlock()

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa PAGAMENTO planejado       		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zPagSE2()

local _cQuery := ""
Local _cFilSE2 := xFilial("SE2")

local cFor 		:= "ALLTRIM(QUERY->E2_XXIC) = _cItemConta .AND. ALLTRIM(QUERY->E2_TIPO) = 'PR'   "

local nTotPAG1 	:= 0
local nTotPAG2 	:= 0

SE2->(dbsetorder(1)) 
ChkFile("SE2",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"E2_VENCREA",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

/************MOVIMENTO BANCARIO*****************/

while QUERY->(!eof())

		RecLock("TRB9",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->E2_NUM))
		ProcessMessage()
		
		TRB9->PPTIPO	:= "Provisao"
		TRB9->PPDTMOV	:= QUERY->E2_VENCREA
		TRB9->PPDOCTO	:= QUERY->E2_NUM
		TRB9->PPTPDOC	:= QUERY->E2_TIPO

		TRB9->PPVLRDC	:= QUERY->E2_VLCRUZ
		TRB9->PPVLRDC2	:= QUERY->E2_VALOR
		TRB9->PPMOEDA	:= QUERY->E2_MOEDA
		TRB9->PPTXMOE	:= QUERY->E2_TXMOEDA

		TRB9->PPBENEF	:= QUERY->E2_NOMFOR
		TRB9->PPHIST	:= QUERY->E2_HIST
		TRB9->PPICTA	:= QUERY->E2_XXIC
		TRB9->PPDTMOV2	:= QUERY->E2_VENCREA
		
		TRB9->PPFORNE	:= QUERY->E2_FORNECE
		TRB9->PPNFORN	:= QUERY->E2_NOMFOR
		TRB9->PPLOJA	:= QUERY->E2_LOJA
		TRB9->PPPREF	:= QUERY->E2_PREFIXO
		TRB9->PPNTIT	:= QUERY->E2_NUM
		TRB9->PPPARCEL	:= QUERY->E2_PARCELA
				
		nTotPAG1 +=  QUERY->E2_VLCRUZ
		nTotPAG2 +=  QUERY->E2_VALOR
				
		MsUnlock()

	QUERY->(dbskip())

enddo

RecLock("TRB9",.T.)
	TRB9->PPTIPO	:= "TOTAL"
	TRB9->PPDTMOV2	:= ctod("31/12/2099")
	
	TRB9->PPVLRDC	:= nTotPAG1
	TRB9->PPVLRDC2	:= nTotPAG2
	
MsUnlock()

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa PAGAMENTO planejado       		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zDetCom()

	local _cQuery 	:= ""
	local _cQuery2 	:= ""
	Local _cFilSD1 	:= xFilial("SD1")
	Local _cFilCV4 	:= xFilial("CV4")
	Local nTotCom 	:= 0
	Local cXRepr1 	:= ""
	Local cXRepr2 	:= ""
	Local cXRepr3 	:= ""
	Local cXRepr4 	:= ""
	
		
	cXRepr1 := alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR1"))
	if ! Empty(cXRepr1)
		
		RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= "PREVISTO FORNEC."
		TRB10->PCOMISS	:= Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR1") 
		TRB10->VCOMISS	:= (_nXSISFV * (_nPComiss/100)) *  (Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR1")/100) 
		TRB10->FORNECE	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR1")) + " " + alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNRED1"))

		MsUnlock()
	
	endif
	
	cXRepr2 := alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR2"))
	if ! Empty(cXRepr2)
		
		RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= ""
		TRB10->PCOMISS	:= Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR2") 
		TRB10->VCOMISS	:= (_nXSISFV * (_nPComiss/100)) *  (Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR2")/100) 
		TRB10->FORNECE	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR2")) + " " + alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNRED2"))

		MsUnlock()
	
	endif
	
	cXRepr3 := alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR3"))
	if ! Empty(cXRepr3)
		
		RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= ""
		TRB10->PCOMISS	:= Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR3") 
		TRB10->VCOMISS	:= (_nXSISFV * (_nPComiss/100)) *  (Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR3")/100) 
		TRB10->FORNECE	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR3")) + " " + alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNRED3"))

		MsUnlock()
	
	endif
	
	cXRepr4 := alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR4"))
	if ! Empty(cXRepr4)
		
		RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= ""
		TRB10->PCOMISS	:= Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR4")
		TRB10->VCOMISS	:= (_nXSISFV * (_nPComiss/100)) *  (Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCOR4")/100) 
		TRB10->FORNECE	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XREPR4")) + " " + alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNRED4"))

		MsUnlock()
	
	endif
	
	RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= "PREVISTO TOTAL"
		TRB10->PCOMISS	:= _nPComiss 
		TRB10->VCOMISS	:= _nXSISFV * (_nPComiss/100)

	MsUnlock()
	
	RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= ""
		TRB10->PCOMISS	:= 0 
		TRB10->VCOMISS	:= 0

	MsUnlock()
	/******************* Comissoes SD1 *************************************/
	_cQuery := " SELECT D1_ITEMCTA, cast(D1_EMISSAO AS DATE) AS 'TMP_EMISSAO', cast(E2_VENCREA AS DATE) AS 'TMP_VENCREA' , cast(E2_BAIXA AS DATE) AS 'TMP_BAIXA', "
	_cQuery += "  D1_DOC, D1_CF, D1_XNATURE, D1_RATEIO, D1_COD, D1_QUANT, D1_UM, D1_TOTAL, E2_NOMFOR, "
	_cQuery += " D1_BASEICM, D1_CUSTO, D1_FORNECE "  
	_cQuery += " FROM SD1010 "
	_cQuery += " INNER JOIN SE2010 ON D1_DOC = E2_NUM AND D1_FORNECE = E2_FORNECE AND D1_LOJA = E2_LOJA "  
	_cQuery += " WHERE  SD1010.D_E_L_E_T_ <> '*' AND  SE2010.D_E_L_E_T_ <> '*' AND D1_XNATURE = '6.21.00' AND E2_BAIXA <> '' AND D1_RATEIO = 2 AND D1_ITEMCTA = '" + _cItemConta + "' OR " 
	_cQuery += " 		SD1010.D_E_L_E_T_ <> '*' AND SE2010.D_E_L_E_T_ <> '*' AND D1_XNATURE = '6.22.00' AND E2_BAIXA <> '' AND D1_RATEIO = 2 AND D1_ITEMCTA = '" + _cItemConta + "' " 
	_cQuery += " 		ORDER BY E2_BAIXA "

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY"

	dbSelectArea("QUERY")
	QUERY->(dbGoTop())


	while QUERY->(!eof())

			RecLock("TRB10",.T.)
			
			MsProcTxt("Processando registro: "+alltrim(QUERY->D1_DOC))
			ProcessMessage()
			
			TRB10->ORIGEM	:= "REALIZADO"
			TRB10->DTPGTO	:= QUERY->TMP_BAIXA
			TRB10->VCOMPG	:= QUERY->D1_CUSTO
			TRB10->PCOMPG	:= (QUERY->D1_CUSTO / (_nXSISFV * (_nPComiss/100)))*100 //(TRB2->VALOR / nXVALCOM)*100
			TRB10->FORNECE	:= ALLTRIM(QUERY->D1_FORNECE) + " " + ALLTRIM(QUERY->E2_NOMFOR)
			TRB10->ITEMCTA	:= QUERY->D1_ITEMCTA
			
			nTotCom 		+= QUERY->D1_CUSTO
			
			MsUnlock()
	
		//endif
	
		QUERY->(dbskip())
	
	enddo
	/****************** Comissoes Rateiro ***************/
	cQuery2 := "	SELECT DISTINCT E2_FORNECE, E2_NOMFOR, E2_LOJA, E2_RATEIO,E2_XXIC, E2_NUM, E2_VENCREA, E2_VENCTO, E2_VLCRUZ, E2_NATUREZ,  " 
	cQuery2 += "	CAST(CV4_DTSEQ AS DATE) AS 'TMP_DTSEQ', CV4_PERCEN,CV4_VALOR,CV4_ITEMD, CV4_HIST, CV4_SEQUEN,"
	cQuery2 += "		CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN AS 'TMP_ARQRAT',E2_ARQRAT, E2_TIPO, E2_BAIXA "  
	cQuery2 += "		FROM CV4010 "
	cQuery2 += "		INNER JOIN SE2010 ON SE2010.E2_ARQRAT = CV4_FILIAL+CV4_DTSEQ+CV4_SEQUEN "
	cQuery2 += "		WHERE E2_RATEIO = 'S' AND SE2010.D_E_L_E_T_ <> '*' AND CV4010.D_E_L_E_T_ <> '*' AND CV4_ITEMD = '" + _cItemConta + "'"
	cQuery2 += "				ORDER BY E2_XXIC "
	
		IF Select("cQuery2") <> 0
			DbSelectArea("cQuery2")
			DbCloseArea()
		ENDIF
	
		//crio o novo alias
		TCQUERY cQuery2 NEW ALIAS "QUERY2"
	
		dbSelectArea("QUERY2")
		QUERY2->(dbGoTop())
	
	
	QUERY2->(dbgotop())
	

	while QUERY2->(!eof())
			IF ALLTRIM(QUERY2->E2_TIPO) = "PA" .AND. QUERY2->E2_BAIXA <> "" 
				QUERY2->(dbsKip())
				loop
			ENDIF
			
			if ! ALLTRIM(QUERY2->E2_NATUREZ) $ "6.21.00/6.22.00/COMISSOES"
				QUERY2->(dbsKip())
				loop
			endif

			RecLock("TRB10",.T.)
			
			MsProcTxt("Processando registro: "+alltrim(QUERY2->CV4_SEQUEN))
			ProcessMessage()
			
			TRB10->ORIGEM	:= "REALIZADO"
			TRB10->DTPGTO	:= QUERY2->TMP_DTSEQ
			TRB10->VCOMPG	:= QUERY2->CV4_VALOR
			TRB10->PCOMPG	:= (QUERY2->CV4_VALOR / (_nXSISFV * (_nPComiss/100)))*100 //(TRB2->VALOR / nXVALCOM)*100
			TRB10->FORNECE	:= ALLTRIM(QUERY2->E2_FORNECE) + " " + ALLTRIM(QUERY2->E2_NOMFOR)
			TRB10->ITEMCTA	:= QUERY2->CV4_ITEMD
			
			nTotCom 		+= QUERY2->CV4_VALOR
			
			MsUnlock()
	
		//endif
	
		QUERY2->(dbskip())
	
	enddo

	/****************************************************/
	RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= "TOTAL PAGO"
		TRB10->VCOMPG	:= nTotCom

	MsUnlock()
	
	RecLock("TRB10",.T.)

		TRB10->ORIGEM	:= "SALDO A PAGAR"
		TRB10->VCOMPG	:= ( _nXSISFV * (_nPComiss/100)) - nTotCom

	MsUnlock()
	
	QUERY->(dbclosearea())
	QUERY2->(dbclosearea())
	
return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa solitacoes de compra        		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zSolSC1()

local _cQuery := ""
Local _cFilSC1 := xFilial("SC1")

local cFor 		:= "ALLTRIM(QUERY->C1_ITEMCTA) = _cItemConta "

SC1->(dbsetorder(1)) 
ChkFile("SC1",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"C1_NUM",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())


/************SOLICITACOES DE COMPRA *****************/

while QUERY->(!eof())

		RecLock("TRB12",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->C1_NUM))
		ProcessMessage()
		
		if QUERY->C1_QUANT = QUERY->C1_QUJE
			TRB12->STATUS	:= "Encerrada"
		elseif QUERY->C1_QUJE = 0
			TRB12->STATUS	:= "Aberta"
		elseif QUERY->C1_QUJE < QUERY->C1_QUANT .AND. QUERY->C1_QUJE > 0
			TRB12->STATUS	:= "Parcial"
		
		endif
		
		TRB12->NSOLICIT	:= QUERY->C1_NUM
		TRB12->ITEMSC	:= QUERY->C1_ITEM
		TRB12->CODPROD	:= QUERY->C1_PRODUTO
		TRB12->DESCRI	:= QUERY->C1_DESCRI
		TRB12->UM		:= QUERY->C1_UM
		TRB12->QUANTSOC	:= QUERY->C1_QUANT
		TRB12->QUANTENT	:= QUERY->C1_QUJE
		TRB12->EMISSAO	:= QUERY->C1_EMISSAO
		TRB12->ENTREGA	:= QUERY->C1_DATPRF
		TRB12->NPEDIDO	:= QUERY->C1_PEDIDO
		TRB12->NOMSOLIC	:= QUERY->C1_SOLICIT
		TRB12->ORDPROD	:= QUERY->C1_OP
		TRB12->ITEMCTA	:= QUERY->C1_ITEMCTA
									
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa pedido de compra        		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zPEDSC7()

local _cQuery := ""
Local _cFilSC7 := xFilial("SC7")

local cFor 		:= "ALLTRIM(QUERY->C7_ITEMCTA) = _cItemConta "

SC7->(dbsetorder(1)) 
ChkFile("SC7",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"C7_NUM",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

/************SOLICITACOES DE COMPRA *****************/

while QUERY->(!eof())

		RecLock("TRB13",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->C7_NUM))
		ProcessMessage()
		
		if QUERY->C7_ENCER = "E"
			TRB13->PSTATUS	:= "Encerrado"
		elseif QUERY->C7_QUANT = QUERY->C7_QUJE
			TRB13->PSTATUS	:= "Encerrado"
		elseif QUERY->C7_QUJE = 0
			TRB13->PSTATUS	:= "Aberto"
		elseif QUERY->C7_QUJE < QUERY->C7_QUANT .AND. QUERY->C7_QUJE > 0
			TRB13->PSTATUS	:= "Parcial"
		
		endif
		
		TRB13->PNPEDIDO	:= QUERY->C7_NUM
		TRB13->PITEMPC	:= QUERY->C7_ITEM
		TRB13->PCODPROD	:= QUERY->C7_PRODUTO
		TRB13->PDESCRI	:= QUERY->C7_DESCRI
		TRB13->PUM		:= QUERY->C7_UM
		TRB13->PQTDPC	:= QUERY->C7_QUANT
		TRB13->PQTDENTR	:= QUERY->C7_QUJE
		TRB13->PUNIT	:= QUERY->C7_PRECO
		TRB13->PTOTAL	:= QUERY->C7_TOTAL
		TRB13->PTOTALSI	:= QUERY->C7_XTOTSI
		TRB13->PEMISSAO	:= QUERY->C7_EMISSAO
		TRB13->PENTREGA	:= QUERY->C7_DATPRF
		TRB13->PNSOLIC	:= QUERY->C7_NUMSC
		TRB13->PFORNECE	:= QUERY->C7_FORNECE
		TRB13->PDFORNECE:= alltrim(POSICIONE("SA2",1,XFILIAL("SA2")+QUERY->C7_FORNECE,"A2_NOME"))
		TRB13->PITEMCTA	:= QUERY->C7_ITEMCTA
									
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa ORDENS DE PRODUCAO	        		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zOrdPrSC2()

local _cQuery := ""
Local _cFilSC2 := xFilial("SC2")
local cOrdPrd	:= ""
local cFor 		:= "ALLTRIM(QUERY->C2_ITEMCTA) = _cItemConta "

SC2->(dbsetorder(1)) 
ChkFile("SC2",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"C2_NUM",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())


/************ ORDENS DE PRODUCAO*****************/

while QUERY->(!eof())

		RecLock("TRB14",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->C2_NUM))
		ProcessMessage()
		
		TRB14->OITEMCTA	:= QUERY->C2_ITEMCTA
		TRB14->ORDPRD	:= alltrim(QUERY->C2_NUM)+alltrim(QUERY->C2_ITEM)+alltrim(QUERY->C2_SEQUEN)
		cOrdPrd 		:= alltrim(QUERY->C2_NUM)+alltrim(QUERY->C2_ITEM)+alltrim(QUERY->C2_SEQUEN)
		TRB14->OPRODUT	:= QUERY->C2_PRODUTO
		TRB14->ODESCRI	:= Posicione("SB1",1,xFilial("SB1") + QUERY->C2_PRODUTO,"B1_DESC")
		TRB14->OLOCAL	:= QUERY->C2_LOCAL
		TRB14->OQUANT	:= QUERY->C2_QUANT
		TRB14->OSALDO	:= Posicione("SB2",1,xFilial("SB2") + QUERY->C2_PRODUTO,"B2_QATU")
		TRB14->OUM		:= QUERY->C2_UM
		TRB14->ODATPRI	:= QUERY->C2_DATPRI
		TRB14->OENTREG	:= QUERY->C2_DATPRF
		TRB14->OEMISSA	:= QUERY->C2_EMISSAO
									
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PFIN01REAL�Autor  Reginaldo Valerio						   ���
�������������������������������������������������������������������������͹��
���Desc.     � Processa DETALHAMENTO ORDENS DE PRODUCAO	        		              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zOrdPrSD3()

local _cQuery := ""
Local _cFilSD3 := xFilial("SD3")
local cOrdPrd	:= ""
local cFor 		:= "ALLTRIM(QUERY->D3_ITEMCTA) = _cItemConta .AND. QUERY->D3_CF == 'RE1'"

SD3->(dbsetorder(1)) 
ChkFile("SD3",.F.,"QUERY") // Alias dos movimentos bancarios

IndRegua("QUERY",CriaTrab(NIL,.F.),"D3_OP",,cFor,"Selecionando Registros...")
ProcRegua(QUERY->(reccount()))

QUERY->(dbgotop())

/************ ORDENS DE PRODUCAO*****************/

while QUERY->(!eof())

		RecLock("TRB15",.T.)
		
		MsProcTxt("Processando registro: "+alltrim(QUERY->D3_OP))
		ProcessMessage()
		
		TRB15->DITEMCTA	:= QUERY->D3_ITEMCTA
		TRB15->DPRODUT1	:= Posicione("SC2",1,xFilial("SC2") + QUERY->D3_OP,"C2_PRODUTO")
		TRB15->DDESCRI1	:= Posicione("SB1",1,xFilial("SB1") + Posicione("SC2",1,xFilial("SC2") + QUERY->D3_OP,"C2_PRODUTO"),"B1_DESC")
		TRB15->DQUANT1	:= Posicione("SC2",1,xFilial("SC2") + QUERY->D3_OP,"C2_QUANT")
		TRB15->DUM1		:= Posicione("SC2",1,xFilial("SC2") + QUERY->D3_OP,"C2_UM")
		TRB15->DORDPRD	:= QUERY->D3_OP
		TRB15->DPRODUT	:= QUERY->D3_COD
		TRB15->DDESCRI	:= Posicione("SB1",1,xFilial("SB1") + QUERY->D3_COD,"B1_DESC")
		TRB15->DLOCAL	:= QUERY->D3_LOCAL
		TRB15->DQUANT	:= QUERY->D3_QUANT
		TRB15->DUM		:= QUERY->D3_UM
		TRB15->DEMISSA	:= QUERY->D3_EMISSAO
		TRB15->DTIPO	:= QUERY->D3_TIPO
		TRB15->DNSOLIC	:= Posicione("SC1",13,xFilial("SC1") + QUERY->D3_OP+QUERY->D3_COD,"C1_NUM")
		TRB15->DQTDENT	:= Posicione("SC1",13,xFilial("SC1") + QUERY->D3_OP+QUERY->D3_COD,"C1_QUJE")
											
		MsUnlock()

	QUERY->(dbskip())

enddo

QUERY->(dbclosearea())

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Monta a tela de visualizacao do Fluxo Sintetico            ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function MontaTela()
//Local oGet1
Local oGet1 := Space(13)
Local nposi

Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Local oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Local oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Local oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Local oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Local oGray		:= LoadBitmap( GetResources(), "BR_CINZA")

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbFATR
Private _oGetDbFATP
Private _oGetDbRERR
Private _oGetDbPLRP
Private _oGetDbPLPP
Private _oGetDbCOM
Private _oGetDbSOC
Private _oGetDbPED
Private _oGetDbORDP
Private _oDlgSint
Private oFolder1

cCadastro :=  "Gestao de Contratos - Sintetico - " + _cItemConta

DEFINE MSDIALOG _oDlgSint ;
TITLE "Gestao de Contratos - Sintetico - " + _cItemConta ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

 @ aPosObj[1,1]+78,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-115 OF _oDlgSint ;
	  	ITEMS "Custos", "Faturamento","Recebimento","Comissoes / Provisoes Contas a Pagar","Solicitacao de Compra","Pedidos de Compra","Ordem de Producao" COLORS 0, 16777215 PIXEL
	  	
zCabecGC()
zTelaCustos()
zTelaFR()
zTelaFP()
zTelaRR()
zTPLARE()
zTPLAPG()
zTelaCM()
zTPSOLIC()
zTPDCOM()
zTORDPD()

aadd(aButton , { "BMPTABLE" , { || zExpExcGC01()}, "Export. Custos Excel " } ) 
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || VendidoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Vendido " } )
aadd(aButton , { "BMPTABLE" , { || zEstruPLN()}, "Planejamento (Estrutura) " } )
aadd(aButton , { "BMPTABLE" , { || PlanejadoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Planejamento (Itens Nivel 3) " } )
aadd(aButton , { "BMPTABLE" , { || AnaliticoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Realizado Analitico" } )
aadd(aButton , { "BMPTABLE" , { || ContabilFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Custo Contabil " } )
aadd(aButton , { "BMPTABLE" , { || EstContabil("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Estoque Contabil " } )
aadd(aButton , { "BMPTABLE" , { || ContabilReceita("TRB4","",aHeader), TRB4->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Receita Contabil " } )
//aadd(aButton , { "BMPTABLE" , { || PlanejadoFull("TRB1","",aHeader), TRB1->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Planejamento " } )
//aadd(aButton , { "BMPTABLE" , { || zfAltTRBX()}, "Tela X" } )


aadd(aButton , { "BMPTABLE" , { || PRNGCRes()}, "Imprimir " } )
//aadd(aButton , { "BMPTABLE" , { || GCemail()}, "Enviar Email " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return

/********************* Cabe�alho formul�rio principal ******************/
static function zCabecGC()

	oGroup1:= TGroup():New(0029,0015,0053,0730,'',_oDlgSint,,,.T.)
	oGroup2:= TGroup():New(0054,0015,0080,0345,'Venda',_oDlgSint,,,.T.)
	oGroup3:= TGroup():New(0054,0350,0080,0730,'Venda Revisado',_oDlgSint,,,.T.)
	
	oGroup4:= TGroup():New(0081,0015,0110,0345,'Custo Vendido',_oDlgSint,,,.T.)
	oGroup5:= TGroup():New(0081,0350,0110,0730,'Custo Revisado',_oDlgSint,,,.T.)
	
	@ 0030,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
	@ 0038,0020 MSGET  _cItemConta  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0030,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
	@ 0038,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0030,0200 Say  "Cod.Cliente: " 	 COLORS 0, 16777215 PIXEL
	@ 0038,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0030,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
	@ 0038,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0030,0480 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
	@ 0038,0480 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0030,0540 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
	@ 0038,0540 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0040 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
	@ 0066,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0100 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
	@ 0066,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0160 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
	@ 0066,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0220 Say  "c/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
	@ 0066,0220 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0280 Say  "s/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
	@ 0066,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0400 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
	@ 0066,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0460 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
	@ 0066,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0520 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
	@ 0066,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0580 Say  "c/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
	@ 0066,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0058,0640 Say  "s/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
	@ 0066,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
		
	@ 0087,0040 Say  "Producao " 	COLORS 0, 16777215 PIXEL
	@ 0095,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTO"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0100 Say  "COGS Vendido " 	COLORS 0, 16777215 PIXEL
	@ 0095,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
	@ 0095,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOT"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0220 Say  "Data Cambio " 	COLORS 0, 16777215 PIXEL
	@ 0095,0220 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XDTCB")) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0280 Say  "Vlr. Cambio " 	COLORS 0, 16777215 PIXEL
	@ 0095,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCAMB"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	
	@ 0087,0400 Say  "Producao " 	COLORS 0, 16777215 PIXEL
	@ 0095,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0460 Say  "COGS REV. " 	COLORS 0, 16777215 PIXEL
	@ 0095,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0520 Say  "Total" 	COLORS 0, 16777215 PIXEL
	@ 0095,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
	
	@ 0087,0580 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
	@ 0095,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVBAD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

return

/******************* Tela Faturamento Realizado ************************/

static function zTelaFR()

	// Monta aHeader do TRB5
	
	aadd(aHeader, {" Origem"	,"FRTIPO",		"",15,0,"","","C","TRB5","R"})
	aadd(aHeader, {"Data Mov."	,"FRDTMOV",		"",08,0,"","","D","TRB5","R"})
	aadd(aHeader, {"Tipo"		,"FRTPMOV",		"",03,0,"","","C","TRB5","R"})
	aadd(aHeader, {"CFOP"		,"FRCFOP",		"",10,0,"","","C","TRB5","R"})
	aadd(aHeader, {"Docto.",	"FRDOCTO",		"",15,0,"","","C","TRB5","R"})
	aadd(aHeader, {"Valor c/ Trib.",		"FRVLRDC",		"@E 999,999,999.99",15,2,"","","N","TRB5","R"})
	aadd(aHeader, {"Valor s/ Trib.",		"FRVLRSI",		"@E 999,999,999.99",15,2,"","","N","TRB5","R"})
	//aadd(aHeader, {"Contrato",	"FRICTA",		"",13,0,"","","C","TRB5","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+5 BUTTON 'Exportar Excel' Size 60, 10 action(zExpFatRR()) OF oFolder1:aDialogs[2] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+70 Say "REALIZADO "  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL PIXEL 
	
	_oGetDbFATR := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4]/2, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB5",,,,oFolder1:aDialogs[2])


	// COR DA FONTE
	_oGetDbFATR:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCorFR(1)}
	// COR DA LINHA
	_oGetDbFATR:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCorFR(2)} //Cor da Linha
	
return

Static Function SFMudaCorFR(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB5->FRTIPO) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor

/**************** Exportacao Excel TRB6 Faturamento realizado ********************/

Static Function zExpFatRR()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'expfatrr.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB6 ****************/  

	    cTabela 	:= "Faturamento Realizado " + _cItemConta
	    cPasta		:= "Faturamento Realizado " + _cItemConta 
	   
	    cDatMov		:= "Data Mov."			// 1
	    cTipo		:= "Tipo"				// 2
	    cCFOP		:= "CFOP"				// 3
	    cDocto		:= "Docto"				// 4
	    cValor		:= "Valor"				// 5
	        
	    
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
        aAdd(aColunas, cDatMov)		// 1										
        aAdd(aColunas, cTipo)		// 2			
        aAdd(aColunas, cCFOP)		// 3
        aAdd(aColunas, cDocto)		// 4	
        aAdd(aColunas, cValor)		// 5
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cDatMov,1,2)	// 1 data movimento						
        oFWMsExcel:AddColumn(cTabela,cPasta, cTipo,1,2)		// 2 tipo
        oFWMsExcel:AddColumn(cTabela,cPasta, cCFOP,1,2)		// 3 cfop
        oFWMsExcel:AddColumn(cTabela,cPasta, cDocto,1,2)	// 4 documento
        oFWMsExcel:AddColumn(cTabela,cPasta, cValor,1,2)	// 5 Valor
                  
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB5->(dbgotop())
	                            
        While  !(TRB5->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB5->FRDTMOV
        	aLinhaAux[2] := TRB5->FRTPMOV
        	aLinhaAux[3] := TRB5->FRCFOP
        	aLinhaAux[4] := TRB5->FRDOCTO
        	aLinhaAux[5] := TRB5->FRVLRDC
        	        	
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB5->(DbSkip())

        EndDo

        TRB5->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Faturamento Planejado ************************/

static function zTelaFP()

	// Monta aHeader do TRB6
	aadd(aHeader, {"Item"		,"FPITEM"	,""					,10,0,"","","C","TRB6","R"})
	aadd(aHeader, {"Data Mov."	,"FPDTMOV"	,""					,08,0,"","","D","TRB6","R"})
	aadd(aHeader, {"Historico"	,"FPHIST"	,""					,40,0,"","","C","TRB6","R"})
	aadd(aHeader, {"Vlr.c/Trib.","FPVLRCI"	,"@E 999,999,999.99",15,2,"","","N","TRB6","R"})
	aadd(aHeader, {"Vlr.s/Trib.","FPVLRSI"	,"@E 999,999,999.99",15,2,"","","N","TRB6","R"})
	aadd(aHeader, {"Contrato"	,"FPICTA"	,""					,13,0,"","","C","TRB6","R"})
	aadd(aHeader, {"Reg.Finan."	,"FATFIN"	,""					,13,0,"","","C","TRB6","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+5 BUTTON 'Exportar Excel' Size 60, 10 action(zExpFatPL()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+70 BUTTON 'Incluir' Size 60, 10 action(zInsFatPL()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+135 BUTTON 'Excluir' Size 60, 10 action(zExcTRB6()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+200 BUTTON 'Replicar Fat. p/ Prov.Recebimento' Size 100, 10 action(zReplFat()) OF oFolder1:aDialogs[2] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+315 Say "PLANEJADO "  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	
	_oGetDbFATP := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2]+(aPosObj[1,4]/2),(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB6",,,,oFolder1:aDialogs[2])

	_oGetDbFATP:oBrowse:BlDblClick := {|| zEditTRB6() }
	// COR DA FONTE
	_oGetDbFATP:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMCorFP(1)}
	// COR DA LINHA
	_oGetDbFATP:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMCorFP(2)} //Cor da Linha
	
return

Static Function zReplFat()

	local _cQuery := ""
	Local _cFilSZQ := xFilial("SZQ")
	local cFor 		:= "ALLTRIM(QUERY->ZQ_ITEMIC) = _cItemConta"
	local cFor2		:= "ALLTRIM(QUERYSE1->E1_XXIC) = _cItemConta"
	local dData
	local cDescri 	:= ""
	local nValor 	:= ""
	local cItemIC 	:= ""
	local cRecNom
	local cFilEmp	
	local cNature
	local nMoeda
	local cNumero
	local cTipo 	:= ""
	local cCliente 	:= ""
	local cNomCli 	:= ""
	local cPais 	:= ""
	local cCliente 	:= ""
	local cNomCli 	:= ""
	Local cItemZQ	:= ""
	Local cFatFin	:= ""
	Local nTotSE1	:= 0
	Local nXVDSIR	:= Posicione("CTD",1,xFilial("CTD") + _cItemConta, "CTD_XVDSIR")	


	SE1->(dbsetorder(1)) 
	ChkFile("SE1",.F.,"QUERYSE1") // Alias dos movimentos bancarios
	IndRegua("QUERYSE1",CriaTrab(NIL,.F.),"E1_XXIC",,cFor2,"Selecionando Registros...")
	ProcRegua(QUERYSE1->(reccount()))
	QUERYSE1->(dbgotop())

	SZQ->(dbsetorder(1)) 
	ChkFile("SZQ",.F.,"QUERY") // Alias dos movimentos bancarios
	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZQ_DATA",,cFor,"Selecionando Registros...")
	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())

	while QUERYSE1->(!eof())

		nTotSE1 += QUERYSE1->E1_VLCRUZ
		QUERYSE1->(dbskip())
	
	enddo

	/************DOC SAIDA*****************/

	while QUERY->(!eof())

			cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM SE1010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM SE1010) "
 			TCQuery cQuery2 New Alias "TSE1F"

			cRecNom 	:= TSE1F->RECNO+1
			cFilEmp 	:= Posicione("SA1",1,xFilial("SA1") + Posicione("CTD",1,xFilial("CTD") + _cItemConta, "CTD_XCLIEN"), "A1_LOJA")
			cNumero 	:= alltrim(SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(TSE1F->RECNO+1,4))
			cTipo 		:= "PR"
			cItemIC		:= _cItemConta
			
			cPais		:= Posicione("SA1",1,xFilial("SA1") + Posicione("CTD",1,xFilial("CTD") + _cItemConta, "CTD_XCLIEN"), "A1_PAIS")   
			if cPais = "105"
				cNature := "1.01.00"
			else
				cNature := "1.02.00"
			endif
			
			dData		:= QUERY->ZQ_DATA
			cDescri		:= QUERY->ZQ_DESCRI
			nValor		:= QUERY->ZQ_FATREV
			nMoeda		:= 1

			cCliente 	:= Posicione("CTD",1,xFilial("CTD") + _cItemConta, "CTD_XCLIEN")
			cNomCli		:= Posicione("CTD",1,xFilial("CTD") + _cItemConta, "CTD_XNREDU")
			cItemZQ		:= QUERY->ZQ_ITEM
			cFatFin		:= alltrim(QUERY->ZQ_FATFIN)	
	
			//TRB6->FPVLRSI	:= QUERY->ZQ_FATRVSI

			DbSelectArea("SE1")
			SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
			SE1->(DbGoTop())
			
			If SE1->(DbSeek(xFilial("SE1")+cFatFin+cCliente+dtos(dData) ))
	
		       	msginfo("Registro " + cFatFin + " com " + dtoc(dData) +  " ja foi recliplado para financerio." )

			elseIF (nTotSE1+nValor) > nXVDSIR

				msginfo("Provisao " + cItemZQ + " n�o pode ser replicada porque supera total provisionado no financeiro.")
			else 
			
				SE1->( DBAppend( .F. ) )
					//SE2->E2_VENCTO 	:= dVencto
					R_E_C_N_O_			:= cRecNom
					SE1->E1_FILIAL		:= cFilEmp
					SE1->E1_NUM			:= cNumero
					SE1->E1_TIPO		:= cTipo
					SE1->E1_XXIC		:= cItemIC
					SE1->E1_NATUREZ		:= cNature
					SE1->E1_VENCREA 	:= dData
					SE1->E1_EMISSAO 	:= dData
					SE1->E1_VENCTO 		:= dData
					SE1->E1_HIST		:= cDescri
					SE1->E1_VLCRUZ	:= nValor
					SE1->E1_VALOR	:= nValor 
					SE1->E1_SALDO	:= nValor 
					SE1->E1_MOEDA	:= 1
					SE1->E1_TXMOEDA	:= 0 
					SE1->E1_BAIXA		:= STOD("")
					SE1->E1_CLIENTE		:= cCliente
					SE1->E1_NOMCLI		:= Posicione("SA1",1,xFilial("SA1") + cCliente, "A1_NREDUZ")
					SE1->E1_LOJA		:= Posicione("SA1",1,xFilial("SA1") + cCliente, "A1_LOJA")	
				SE1->( DBCommit() )

				DbSelectArea("SZQ")
				SZQ->(DbSetOrder(4)) //B1_FILIAL + B1_COD
				SZQ->(DbGoTop())

				If SZQ->(DbSeek(cItemZQ+cItemIC+dtos(dData)))
				
					Reclock("SZQ",.F.)
					SZQ->ZQ_FATFIN 	:= cNumero
					MsUnlock()
				
				EndIf
			ENDIF

		QUERY->(dbskip())
		TSE1F->(DbCloseArea())

	enddo

  	QUERY->(DbCloseArea())
	QUERYSE1->(DbCloseArea())

	DbSelectArea("TRB8")
	TRB8->(dbgotop())
	zap
	MSAguarde({||zRecSE1()},"Processando Recebimento Planejado")
	TRB8->(DBGoBottom())
	TRB8->(dbgotop())
	GetdRefresh()

	DbSelectArea("TRB6")
	TRB6->(dbgotop())
	zap
	MSAguarde({||zFaturSZQ()},"Processando Faturamneto Planejado")
	TRB6->(DBGoBottom())
	TRB6->(dbgotop())
	GetdRefresh()


  	

return

Static Function SFMCorFP(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB6->FPITEM) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor


/********************Edi��o Faturamento Planejado **********************************/
Static Function zEditTRB6()
    Local aArea       := GetArea()
    Local aAreaSZQ    := SZQ->(GetArea())
    Local nOpcao1      := 0
    Local cItemZQ	  := alltrim(TRB6->FPITEM)
    Local cItemIC	  := alltrim(TRB6->FPICTA)
    local cData		  := dtos(TRB6->FPDTMOV)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Faturamento Planejado"
    
	DbSelectArea("SZQ")
	SZQ->(DbSetOrder(4)) //B1_FILIAL + B1_COD
	SZQ->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If SZQ->(DbSeek(cItemZQ+cItemIC+cData))
	    	
	        nOpcao1 := zfAltTRB6()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	     
	        EndIf
	       
	EndIf
	
    RestArea(aAreaSZQ)
    RestArea(aArea)
Return

/*****************Edi��o Faturamento Planejado******************/

static Function zfAltTRB6()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= alltrim(SZQ->ZQ_ITEM)
Local oGet2
Local cGet2 	:= alltrim(SZQ->ZQ_ITEMIC)
Local oGet3
Local cGet3		:= SZQ->ZQ_DATA
Local oGet4	
Local cGet4		:= SZQ->ZQ_DESCRI
Local oGet5	
Local cGet5		:= SZQ->ZQ_FATREV

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5

Local nXVDCIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDCIR")
Local nXVDSIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDSIR")

Local nTotReg := 0
local cFiltra 	:= ""
Local _nOpc := 0

Static _oDlg

/*
	cQuery := " SELECT * FROM SZF010 WHERE ZF_NPROP = '" + cGet1 + "' AND D_E_L_E_T_ <> '*' AND ZF_UNIT > 0 AND ZF_TOTAL > 0 AND ZF_TOTVSI > 0 AND ZF_TOTVCI > 0 "
    TCQuery cQuery New Alias "TSZF"
        
    Count To nTotReg
    TSZF->(DbGoTop()) 

/*************************************/
  DEFINE MSDIALOG _oDlg TITLE "Edicao Faturamento Planejado" FROM 000, 000  TO 0200, 760 COLORS 0, 16777215 PIXEL
 
  //DEFINE MSDIALOG _oDlgAnalit TITLE "xx" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
  
  oGroup1:= TGroup():New(0005,0005,0035,0380,'',_oDlg,,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0380,'',_oDlg,,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Item" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Contrato" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2   When .F. SIZE 052, 010 	COLORS 0, 16777215 PIXEL
    
    @ 042, 010 SAY oSay3 PROMPT "Data" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 051, 010 MSGET oGet3 VAR cGet3 When .T. SIZE  048, 010 COLORS 0, 16777215 PIXEL
		
	@ 042, 073 SAY oSay4 PROMPT "Descricao" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 070 MSGET oGet4 VAR cGet4 When .T. SIZE 215, 010  COLORS 0, 16777215 PIXEL
	    
	@ 042, 303 SAY oSay5 PROMPT "Vlr.c/Tributos" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 301 MSGET oGet5 VAR cGet5 PICTURE PesqPict("SZQ","ZQ_FATREV") When .T. SIZE 60, 010  COLORS 0, 16777215 PIXEL
    	
    @ 080, 120 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 010  PIXEL
    @ 080, 200 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 010  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
   	
  	If _nOpc = 1
  	
  		Reclock("SZQ",.F.)
	 
	  		SZQ->ZQ_DATA	 	:= cGet3
	  		SZQ->ZQ_DESCRI		:= cGet4 
	  		SZQ->ZQ_FATREV		:= cGet5
	  		SZQ->ZQ_FATRVSI		:= cGet5 - ( (nXVDCIR - nXVDSIR) * ( cGet5 / nXVDCIR )  )
	  	 		
	  	MsUnlock()
  	
	  	DbSelectArea("TRB6")
		TRB6->(dbgotop())
		zap
		MSAguarde({||zFaturSZQ()},"Processando Faturamneto Planejado")
		TRB6->(DBGoBottom())
		TRB6->(dbgotop())
	  	GetdRefresh()
    endif
  /*
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea()) 
*/
Return _nOpc

/*****************Inserir Faturamento Planejado******************/
static Function zInsFatPL()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= 0
Local oGet2
Local cGet2 	:= _cItemConta
Local oGet3
Local cGet3		:= dDatabase
Local oGet4	
Local cGet4		:= "FATURAMENTO " + _cItemConta
Local oGet5	
Local cGet5		:= 0
Local cGet6		:= 0

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5

Local nXVDCIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDCIR")
Local nXVDSIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDSIR")

Local _nOpc := 0

Local nTotReg := 0
local cFiltra 	:= ""

Static _oDlg


	cQuery := " SELECT * FROM SZQ010 WHERE ZQ_ITEMIC = '" + _cItemConta + "'"
    TCQuery cQuery New Alias "TSZQ"
        
    Count To nTotReg
    TSZQ->(DbGoTop()) 

    cGet1 := strzero(nTotReg+1,3)
/*************************************/
  DEFINE MSDIALOG _oDlg TITLE "Inserir Faturamento Planejado" FROM 000, 000  TO 0200, 760 COLORS 0, 16777215 PIXEL
 
  //DEFINE MSDIALOG _oDlgAnalit TITLE "xx" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
  
  oGroup1:= TGroup():New(0005,0005,0035,0380,'',_oDlg,,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0380,'',_oDlg,,,.T.)
       
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Item" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Contrato" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2   When .F. SIZE 052, 010 	COLORS 0, 16777215 PIXEL
    
    @ 042, 010 SAY oSay3 PROMPT "Data" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 051, 010 MSGET oGet3 VAR cGet3  PICTURE PesqPict("SZQ","ZQ_DATA") When .T. SIZE  048, 010 COLORS 0, 16777215 PIXEL
		
	@ 042, 073 SAY oSay4 PROMPT "Descricao" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 070 MSGET oGet4 VAR cGet4  PICTURE PesqPict("SZQ","ZQ_DESCRI") When .T. SIZE 215, 010  COLORS 0, 16777215 PIXEL
	    
	@ 042, 303 SAY oSay5 PROMPT "Vlr.c/Tributos" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 301 MSGET oGet5 VAR cGet5 PICTURE PesqPict("SZQ","ZQ_FATREV") When .T. SIZE 60, 010  COLORS 0, 16777215 PIXEL
    	
    @ 080, 120 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 010  PIXEL
    @ 080, 200 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 010  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
  	cGet6 := (cGet5 - ( (nXVDCIR - nXVDSIR) * ( cGet5 / nXVDCIR ))  )
  	
  	If _nOpc = 1
  	
  		//c_Qry := " INSERT INTO SZQ010 ( ZQ_ITEM, ZQ_ITEMIC, ZQ_DATA, ZQ_DESCRI, ZQ_FATREV, ZQ_FATRVSI,R_E_C_N_O_ ) "  + ; 
  		// 		" VALUES ( '" + cGet1 + "' , '" + cGet2 + "', '" + dtos(cGet3) + "', '" + cGet4 + "', '" + cGet5 + "', '" + cGet6 + "', (SELECT MAX(R_E_C_N_O_)+1 From SZQ010 )"		
  		//TcSqlExec( c_Qry )
  		
  		DbSelectArea("SZQ")
  		SZQ->( DBAppend( .F. ) )
  		SZQ->ZQ_ITEM	 	:= cGet1
  		SZQ->ZQ_ITEMIC	 	:= cGet2
  		SZQ->ZQ_DATA	 	:= cGet3
	  	SZQ->ZQ_DESCRI		:= cGet4 
	  	SZQ->ZQ_FATREV		:= cGet5
	  	SZQ->ZQ_FATRVSI		:= cGet5 - ( (nXVDCIR - nXVDSIR) * ( cGet5 / nXVDCIR )  )
  		SZQ->( DBCommit() )
  	/*
	  	Reclock("SZQ",.T.)
	 
	  		SZQ->ZQ_DATA	 	:= cGet3
	  		SZQ->ZQ_DESCRI		:= cGet4 
	  		SZQ->ZQ_FATREV		:= cGet5
	  		SZQ->ZQ_FATRVSI		:= cGet5 - ( (nXVDCIR - nXVDSIR) * ( cGet5 / nXVDCIR )  )
	  	 		
	  	MsUnlock()
	  	*/
	  	DbSelectArea("TRB6")
		TRB6->(dbgotop())
		zap
		MSAguarde({||zFaturSZQ()},"Processando Faturamneto Planejado")
		TRB6->(DBGoBottom())
		TRB6->(dbgotop())
	  	GetdRefresh()
    endif


TSZQ->(DbCloseArea()) 

Return _nOpc

/********************Excluir Faturamento Planejado **********************************/
Static Function zExcTRB6()
    Local aArea       := GetArea()
    Local aAreaSZQ    := SZQ->(GetArea())
    Local nOpcao1      := 0
    Local cItemZQ	  := alltrim(TRB6->FPITEM)
    Local cItemIC	  := alltrim(TRB6->FPICTA)
    local cData		  := dtos(TRB6->FPDTMOV)
   
    Private cCadastro 
 
   	cCadastro := "Alteracao Faturamento Planejado"
    
    if Empty(cItemZQ) .OR. Empty(cItemIC) .OR. Empty(cData) 
    	alert("Selecione registro para excluir.")
    else
      
		DbSelectArea("SZQ")
		SZQ->(DbSetOrder(4)) //B1_FILIAL + B1_COD
		SZQ->(DbGoTop())
		     
		 //Se conseguir posicionar no produto
		 If SZQ->(DbSeek(cItemZQ+cItemIC+cData))
		    	
		        nOpcao1 := zExcFatPL()
		        If nOpcao1 == 1
		            MsgInfo("Rotina confirmada", "Atencao")
		     
		        EndIf
		       
		EndIf
	
	endif
    RestArea(aAreaSZQ)
    RestArea(aArea)
Return

/*****************Excluir Faturamento Planejado******************/

static Function zExcFatPL()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= alltrim(SZQ->ZQ_ITEM)
Local oGet2
Local cGet2 	:= alltrim(SZQ->ZQ_ITEMIC)
Local oGet3
Local cGet3		:= SZQ->ZQ_DATA
Local oGet4	
Local cGet4		:= SZQ->ZQ_DESCRI
Local oGet5	
Local cGet5		:= SZQ->ZQ_FATREV

Local cItemZQ	  := alltrim(TRB6->FPITEM)
Local cItemIC	  := alltrim(TRB6->FPICTA)
local cData		  := dtos(TRB6->FPDTMOV)

Local nValor := 0
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5

Local nXVDCIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDCIR")
Local nXVDSIR := Posicione("CTD",1,xFilial("CTD") + cGet2,"CTD_XVDSIR")

Local nTotReg := 0
local cFiltra 	:= ""

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Excluir Faturamento Planejado" FROM 000, 000  TO 0200, 760 COLORS 0, 16777215 PIXEL
 
  //DEFINE MSDIALOG _oDlgAnalit TITLE "xx" From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL
  
  oGroup1:= TGroup():New(0005,0005,0035,0380,'',_oDlg,,,.T.)
  oGroup2:= TGroup():New(0040,0005,0070,0380,'',_oDlg,,,.T.)
        
    // ITEM CONTA
    @ 007, 010 SAY oSay1 PROMPT "Item" 	SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 007, 063 SAY oSay2 PROMPT "Contrato" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2   When .F. SIZE 052, 010 	COLORS 0, 16777215 PIXEL
    
    @ 042, 010 SAY oSay3 PROMPT "Data" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 051, 010 MSGET oGet3 VAR cGet3  PICTURE PesqPict("SZQ","ZQ_DATA") When .F. SIZE  048, 010 COLORS 0, 16777215 PIXEL
		
	@ 042, 073 SAY oSay4 PROMPT "Descricao" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 070 MSGET oGet4 VAR cGet4  PICTURE PesqPict("SZQ","ZQ_DESCRI") When .F. SIZE 215, 010  COLORS 0, 16777215 PIXEL
	    
	@ 042, 303 SAY oSay5 PROMPT "Vlr.c/Tributos" SIZE 032, 007 COLORS 0, 16777215 PIXEL
	@ 051, 301 MSGET oGet5 VAR cGet5 PICTURE PesqPict("SZQ","ZQ_FATREV") When .F. SIZE 60, 010  COLORS 0, 16777215 PIXEL
    	
    @ 080, 120 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 070, 010  PIXEL
    @ 080, 200 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 070, 010  PIXEL
  
  ACTIVATE MSDIALOG _oDlg CENTERED
  
  	cGet6 := (cGet5 - ( (nXVDCIR - nXVDSIR) * ( cGet5 / nXVDCIR ))  )
  	
  	If _nOpc = 1
 
  		DbSelectArea("SZQ")
  		Reclock("SZQ",.F.)
	  		If SZQ->(DbSeek(cGet1+cGet2+cData)) // SZQ->(DbSeek(cItemZQ+cItemIC+cData))
	  			SZQ->(DbDelete())
	  	 	endif	
  	 	MsUnlock()
  
	  	DbSelectArea("TRB6")
		TRB6->(dbgotop())
		zap
		MSAguarde({||zFaturSZQ()},"Processando Faturamneto Planejado")
		TRB6->(DBGoBottom())
		TRB6->(dbgotop())
	  	GetdRefresh()
    endif

Return _nOpc

/**************** Exportacao Excel TRB6 Faturamento planejado ********************/

Static Function zExpFatPL()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'expfatpl.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB6 ****************/  

	    cTabela 	:= "Faturamento Planejado " + _cItemConta
	    cPasta		:= "Faturamento Planejado " + _cItemConta 
	    
	    cItem		:= "Item"				// 1
	    cDatMov		:= "Data Mov."			// 2
	    cHist		:= "Historico"			// 3
	    cValorCI	:= "Vlr.c/Trib."		// 4
	    cValorSI	:= "Vlr.s/Trib."		// 5
	    
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cItem)		// 1
        aAdd(aColunas, cDatMov)		// 2										
        aAdd(aColunas, cHist)		// 3			
        aAdd(aColunas, cValorCI)		// 4
        aAdd(aColunas, cValorSI)		// 5	
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cItem,1,2)		// 1 item						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDatMov,1,2)	// 2 data movimento
        oFWMsExcel:AddColumn(cTabela,cPasta, cHist,1,2)		// 3 historico
        oFWMsExcel:AddColumn(cTabela,cPasta, cValorCI,1,2)	// 4 valor com tributos
        oFWMsExcel:AddColumn(cTabela,cPasta, cValorSI,1,2)	// 5 valor sem tributos
     
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB6->(dbgotop())
	                            
        While  !(TRB6->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB6->FPITEM
        	aLinhaAux[2] := TRB6->FPDTMOV
        	aLinhaAux[3] := TRB6->FPHIST
        	aLinhaAux[4] := TRB6->FPVLRCI
        	aLinhaAux[5] := TRB6->FPVLRSI
        	        	
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB6->(DbSkip())

        EndDo

        TRB6->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Recebimento realizado ************************/

static function zTelaRR()
	
	// Monta aHeader do TRB7
	aadd(aHeader, {" Tipo",		"RRTIPO",		"",22,0,"","","C","TRB7","R"})
	aadd(aHeader, {"Data Mov.",	"RRDTMOV",		"",08,0,"","","D","TRB7","R"})
	aadd(aHeader, {"Docto.",	"RRDOCTO",		"",15,0,"","","C","TRB7","R"})
	aadd(aHeader, {"Valor",		"RRVLRDC",		"@E 999,999,999.99",15,2,"","","N","TRB7","R"})
	aadd(aHeader, {"Descricao",	"RRBENEF",		"",20,0,"","","C","TRB7","R"})
	aadd(aHeader, {"Historico",	"RRHIST",		"",20,0,"","","C","TRB7","R"})
	aadd(aHeader, {"Contrato",	"RRICTA",		"",13,0,"","","C","TRB7","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+5 BUTTON 'Exportar Excel' Size 60, 10 action(zExpRecRR()) OF oFolder1:aDialogs[3] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+70 Say "REALIZADO "  COLORS 0, 16777215 OF oFolder1:aDialogs[3] PIXEL PIXEL 
	
	_oGetDbRERR := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4]/2, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB7",,,,oFolder1:aDialogs[3])
	
	// COR DA FONTE
	_oGetDbRERR:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMCorRR(1)}
	// COR DA LINHA
	_oGetDbRERR:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMCorRR(2)} //Cor da Linha
return

Static Function SFMCorRR(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB7->RRTIPO) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor

/**************** Exportacao Excel TRB8 recebimento planejado ********************/

Static Function zExpRecRR()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'exprecrr.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB10 ****************/  

	    cTabela 	:= "Recebimento Realizado " + _cItemConta
	    cPasta		:= "Recebimento Realizado " + _cItemConta 
	    
	    cDatMov		:= "Data Mov."			// 1
	    cDocto		:= "Docto"				// 2
	    cValor		:= "Valor"				// 3
	    cDescri		:= "Descricao"			// 4
	    cHist		:= "Historico"			// 5
	    
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cDatMov)		// 1
        aAdd(aColunas, cDocto)		// 2										
        aAdd(aColunas, cValor)		// 3			
        aAdd(aColunas, cDescri)		// 4
        aAdd(aColunas, cHist)		// 5	
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cDatMov,1,2)		// 1 data movimentacao						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDocto,1,2)		// 2 docto
        oFWMsExcel:AddColumn(cTabela,cPasta, cValor,1,2)		// 3 valor
        oFWMsExcel:AddColumn(cTabela,cPasta, cDescri,1,2)		// 4 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cHist,1,2)			// 5 historico
               
     
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB7->(dbgotop())
	                            
        While  !(TRB7->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB7->RRDTMOV
        	aLinhaAux[2] := TRB7->RRDOCTO
        	aLinhaAux[3] := TRB7->RRVLRDC
        	aLinhaAux[4] := TRB7->RRBENEF
        	aLinhaAux[5] := TRB7->RRHIST
        	        	
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB7->(DbSkip())

        EndDo

        TRB7->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Rebebimento Planejado ************************/

static function zTPLARE()

	// Monta aHeader do TRB8
	aadd(aHeader, {" Origem"	,"RPTIPO"	,""					,10,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Data Mov."	,"RPDTMOV"	,""					,08,0,"","","D","TRB8","R"})
	aadd(aHeader, {"Docto."		,"RPDOCTO"	,""					,09,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Tipo."		,"RPTPDOC"	,""					,02,0,"","","C","TRB8","R"})

	aadd(aHeader, {"Valor R$"	,"RPVLRDC"		,"@E 999,999,999.99"	,15,2,"","","N","TRB8","R"})
	aadd(aHeader, {"Moeda "		,"RPMOEDA"		,"@E 99"				,02,0,"","","N","TRB8","R"})
	aadd(aHeader, {"Valor "		,"RPVLRDC2"		,"@E 999,999,999.99"	,15,2,"","","N","TRB8","R"})
	aadd(aHeader, {"Taxa Moeda"	,"RPTXMOE"		,"@E 999,999,999.9999"	,15,4,"","","N","TRB8","R"})

	//aadd(aHeader, {"Valor"		,"RPVLRDC"	,"@E 999,999,999.99",15,2,"","","N","TRB8","R"})
	aadd(aHeader, {"Descricao"	,"RPBENEF"	,""					,20,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Historico"	,"RPHIST"	,""					,20,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Contrato"	,"RPICTA"	,""					,13,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Cliente"	,"RPCLIENT"	,""					,10,0,"","","C","TRB8","R"})
	aadd(aHeader, {"Loja"		,"RPLOJA"	,""					,02,0,"","","C","TRB8","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+5 BUTTON 'Exportar Excel' Size 60, 10 action(zExptRecPL()) OF oFolder1:aDialogs[3] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+70 BUTTON 'Incluir' Size 60, 10 action(zIncRegSE1()) OF oFolder1:aDialogs[3] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+135 BUTTON 'Excluir' Size 60, 10 action(zExclSE1()) OF oFolder1:aDialogs[3] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+210 Say "PLANEJADO "  COLORS 0, 16777215 OF oFolder1:aDialogs[3] PIXEL
	
	_oGetDbPLRP := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2]+(aPosObj[1,4]/2),(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB8",,,,oFolder1:aDialogs[3])

	_oGetDbPLRP:oBrowse:BlDblClick := {|| zEdtSE1() }
	
	// COR DA FONTE
	_oGetDbPLRP:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMCorRP(1)}
	// COR DA LINHA
	_oGetDbPLRP:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMCorRP(2)} //Cor da Linha
return

Static Function SFMCorRP(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB8->RPTIPO) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor

/******************* Edi��o Recebimento Planejado ************************/

Static Function zEdtSE1()
    Local aArea       := GetArea()
    Local aAreaE1     := SE1->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := TRB8->RPDOCTO
    Local cClifor	  := TRB8->RPCLIENT
    Local cLoja		  := TRB8->RPLOJA
    Local cParcela	  := TRB8->RPPARCEL
    Local dData		  := DTOS(TRB8->RPDTMOV)
    Local cConsSE1	  := cClifor+cTitulo+cParcela

    Private cCadastro 
    	
		cCadastro := "Alteracao Contas a Receber"

	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	    SE1->(DbGoTop())
	    
		If SE1->(DbSeek(xFilial("SE1")+TRB8->RPDOCTO+TRB8->RPCLIENT+dData+TRB8->RPLOJA ))
		
			nOpcao := zAltSE1()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        elseif nOpcao == 2
	           nOpcao := zAltSE1()   
	        EndIf
	    endif

    RestArea(aAreaE1)
    RestArea(aArea)
Return

/******************* Edi��o Recebimento Planejado ************************/

static function zAltSE1()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE1->E1_NUM
Local oGet2
Local cGet2 	:= Posicione("SA1",1,xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_NREDUZ")
Local oGet3
Local oFornece 	:= SE1->E1_CLIENTE
Local oGet7 
Local oGet8 	:= SE1->E1_LOJA
Local dVencto 	:= SE1->E1_VENCREA
//Local oGet4
Local oGet5		:=  SE1->E1_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE1->E1_NATUREZ), "ED_XGRUPO")
//Local nValor 	:= SE1->E1_VALOR
Local oGet9
Local cGet9 	:= SE1->E1_HIST
Local oGet10
Local cGet10	:= SE1->E1_TIPO
Local oGet11
Local cGet11 	:= SE1->E1_XXIC
Local oGet12
Local cGet12 	:= SE1->E1_NATUREZ

Local dEmissa	:= SE1->E1_EMISSAO
Local oGet13
Local dVenct 	:= SE1->E1_VENCTO
Local oGet14

Local oGet4
Local nValor 	:= SE1->E1_VALOR

Local oGet15
Local nValorRE 	:= SE1->E1_VLCRUZ

Local oGet16
Local nMoeda 	:= SE1->E1_MOEDA

Local oGet17
Local nTXMoeda 	:= SE1->E1_TXMOEDA

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7

Local _nOpc := 0
Static _oDlg

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************

DEFINE MSDIALOG _oDlg TITLE "Edicao Titulo Contas a Receber" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL
  
  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)

  //DEFINE MSDIALOG _oDlg TITLE "Edicao Titulo Contas a Receber" FROM 000, 000  TO 300, 498 COLORS 0, 16777215 PIXEL

  	//oGroup1:= TGroup():New(0005,0005,0125,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 042, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 Picture "@!" Pixel F3 "SED" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA1" SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Cliente" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
	/**************/  
   	@ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE  PICTURE PesqPict("SE1","E1_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda  PICTURE PesqPict("SE1","E1_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor  PICTURE PesqPict("SE1","E1_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda  PICTURE PesqPict("SE1","E1_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
    
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9  SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if empty(oFornece) 
		msgstop("Informe codigo do Fornecedor.")
		_nOpc := 2
	endif
	
	if empty(cGet12) 
		msgstop("Informe Natureza.")
		_nOpc := 2
	endif
	
	if nValor = 0 .AND. nValorRE = 0
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif
	
	if empty(cGet9) 
		msgstop("Informe Historico.")
		_nOpc := 2
	endif

  If _nOpc = 1
  	Reclock("SE1",.F.)
  	//SE2->E2_VENCTO 	:= dVencto
  	//SE1->E1_VENCREA := DataValida(dVencto,.T.) //Proximo dia �til
  	SE1->E1_VENCREA 	:= DataValida(dVencto,.T.) //Proximo dia �til
  	SE1->E1_EMISSAO 	:= DataValida(dEmissa,.T.) //Proximo dia �til
  	SE1->E1_VENCTO 		:= DataValida(dVenct,.T.) //Proximo dia �til
  	//************************************
	if nValor = 0 .OR. nValor > 0 .AND. nValorRE > 0 
		
		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  

		else
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE 
				SE1->E1_SALDO	:= nValorRE 
				SE1->E1_MOEDA	:= 1
				SE1->E1_TXMOEDA	:= 0  
			
		endif

	endif

	if nValorRE = 0

		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		else
				SE1->E1_VLCRUZ	:= nValor
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor 
				SE1->E1_MOEDA	:= 1
				SE1->E1_TXMOEDA	:= 0  	
		endif

	endif  
  	SE1->E1_HIST	:= cGet9
  	SE1->E1_NATUREZ	:= cGet12
  	if alltrim(oGet5) = "PR"
  		SE1->E1_CLIENTE	:= alltrim(oFornece)
  		SE1->E1_NOMCLI	:= Posicione("SA1",1,xFilial("SA1") + oFornece, "A1_NREDUZ")
  		SE1->E1_LOJA	:= Posicione("SA1",1,xFilial("SA1") + oFornece, "A1_LOJA")
  	endif	
  	MsUnlock()
  
	DbSelectArea("TRB8")
	TRB8->(dbgotop())
	zap
	MSAguarde({||zRecSE1()},"Processando Recebimento Planejado")
	TRB8->(DBGoBottom())
	TRB8->(dbgotop())
	GetdRefresh()
  Endif

  QUERY2->(DbCloseArea())

Return _nOpc

/******************* Inclusao pagamento Planejado ************************/

static function zIncRegSE1()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= space(9)
Local oGet2
Local cGet2 	:= space(13)
Local oGet3
Local oFornece 	:= space(10)
Local oGet7 	:= space(10)
Local oGet8 	:=  space(1)
Local dVencto 	:= dDatabase
//Local oGet4
Local oGet5		:=  "PR"
Local oGet6		:=  ""
//Local nValor 	:= 0
Local oGet9
Local cGet9 	:= space(40)
Local oGet10
Local cGet10	:= "PR"
Local oGet11
Local cGet11 	:= _cItemConta
Local oGet12
Local cGet12 	:= space(10)

Local dEmissa	:= dDatabase
Local oGet13
Local dVenct 	:= dDatabase
Local oGet14

Local oGet4
Local nValor 	:= 0

Local oGet15
Local nValorRE 	:= 0

Local oGet16
Local nMoeda 	:= 1

Local oGet17
Local nTXMoeda 	:= 0

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7
Local nTotReg := 0

Local _nOpc := 0

Static _oDlg

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************


	cQuery := " SELECT * FROM SE1010 WHERE E1_XXIC = '" + _cItemConta + "' AND E1_TIPO = 'PR' "
    TCQuery cQuery New Alias "TSE1"
        
    Count To nTotReg
    TSE1->(DbGoTop()) 
    nTotReg := nTotReg+1
    
    cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM SE1010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM SE1010) "
    TCQuery cQuery2 New Alias "TSE1B"
    
   
    DbSelectArea("SE1")
	SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	SE1->(DbGoTop())
	//SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),9,2)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(TSE1B->RECNO+1,2)
	cGet1 := SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(TSE1B->RECNO+1,4)
	 
	/*    
	do while SE1->(DbSeek(xFilial("SE1")+cGet1 ))
		 nTotReg := nTotReg+1
	enddo
    */

  DEFINE MSDIALOG _oDlg TITLE "Inclusao Titulo Contas a Receber" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL
  
  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)

  //DEFINE MSDIALOG _oDlg TITLE "Inclusao Titulo Contas a Receber" FROM 000, 000  TO 300, 498 COLORS 0, 16777215 PIXEL

  	//oGroup1:= TGroup():New(0005,0005,0125,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .T. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 042, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 Picture "@!" Pixel F3 "SED" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 010 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA1" SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Cliente" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
	/**************/  
   	@ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE  PICTURE PesqPict("SE1","E1_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda  PICTURE PesqPict("SE1","E1_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor  PICTURE PesqPict("SE1","E1_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda  PICTURE PesqPict("SE1","E1_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
    
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9  SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if empty(oFornece) 
		msgstop("Informe codigo do Fornecedor.")
		_nOpc := 2
	endif
	
	if empty(cGet12) 
		msgstop("Informe Natureza.")
		_nOpc := 2
	endif
	
	if nValor = 0 .AND. nValorRE = 0
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif
	
	if empty(cGet9) 
		msgstop("Informe Historico.")
		_nOpc := 2
	endif

  If _nOpc = 1
  	SE1->( DBAppend( .F. ) )
  	//SE2->E2_VENCTO 	:= dVencto
  	R_E_C_N_O_			:= TSE1B->RECNO+1
  	SE1->E1_FILIAL		:= "01"
  	SE1->E1_NUM			:= SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(TSE1B->RECNO+1,4)
  	SE1->E1_TIPO		:= "PR"
  	SE1->E1_XXIC		:= _cItemConta
  	SE1->E1_NATUREZ		:= cGet12
  	SE1->E1_VENCREA 	:= DataValida(dVencto,.T.) //Proximo dia �til
  	SE1->E1_EMISSAO 	:= DataValida(dEmissa,.T.) //Proximo dia �til
  	SE1->E1_VENCTO 		:= DataValida(dVenct,.T.) //Proximo dia �til
  	
	//************************************
	if nValor = 0 .OR. nValor > 0 .AND. nValorRE > 0 
		
		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE * nTXMoeda
				SE1->E1_SALDO	:= nValorRE * nTXMoeda
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  

		else
				SE1->E1_VLCRUZ	:= nValorRE
				SE1->E1_VALOR	:= nValorRE 
				SE1->E1_SALDO	:= nValorRE 
				SE1->E1_MOEDA	:= 1
				SE1->E1_TXMOEDA	:= 0  
			
		endif

	endif

	if nValorRE = 0

		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE1->E1_VLCRUZ	:= nValor / nTXMoeda
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor
				SE1->E1_MOEDA	:= nMoeda
				SE1->E1_TXMOEDA	:= nTXMoeda  
		else
				SE1->E1_VLCRUZ	:= nValor
				SE1->E1_VALOR	:= nValor 
				SE1->E1_SALDO	:= nValor 
				SE1->E1_MOEDA	:= 1
				SE1->E1_TXMOEDA	:= 0  	
		endif

	endif  
	  
  	SE1->E1_HIST		:= cGet9
  	SE1->E1_NATUREZ		:= cGet12
  	SE1->E1_MOEDA		:= 1
  	SE1->E1_BAIXA		:= STOD("")
  	//SE2->E2_DATAAGE		:= DataValida(dVencto,.T.) //Proximo dia �til
  	if alltrim(oGet5) = "PR"
  		SE1->E1_CLIENTE	:= oFornece
  		SE1->E1_NOMCLI	:= Posicione("SA1",1,xFilial("SA1") + oFornece, "A1_NREDUZ")
  		SE1->E1_LOJA	:= Posicione("SA1",1,xFilial("SA1") + oFornece, "A1_LOJA")
  	endif	
  	SE1->( DBCommit() )
  
	DbSelectArea("TRB8")
	TRB8->(dbgotop())
	zap
	MSAguarde({||zRecSE1()},"Processando Recebimento Planejado")
	TRB8->(DBGoBottom())
	TRB8->(dbgotop())
	GetdRefresh()
  Endif

  TSE1->(DbCloseArea())
  TSE1B->(DbCloseArea())
  QUERY2->(DbCloseArea())

Return _nOpc

/******************* Exclusao recebimento Planejado ************************/

Static Function zExclSE1()
    Local aArea       := GetArea()
    Local aAreaE1     := SE1->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := TRB8->RPDOCTO
    Local cClifor	  := TRB8->RPCLIENT
    Local cLoja		  := TRB8->RPLOJA
    Local cParcela	  := TRB8->RPPARCEL
    Local dData		  := DTOS(TRB8->RPDTMOV)
    Local cConsSE1	  := cClifor+cTitulo+cParcela

    Private cCadastro 
    	
		cCadastro := "Exclusao Contas a Receber"

	    DbSelectArea("SE1")
	    SE1->(DbSetOrder(30)) //B1_FILIAL + B1_COD
	    SE1->(DbGoTop())
	    
		If SE1->(DbSeek(xFilial("SE1")+TRB8->RPDOCTO+TRB8->RPCLIENT+dData+TRB8->RPLOJA ))
			nOpcao := zExcRegSE1()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        EndIf
	    endif

    RestArea(aAreaE1)
    RestArea(aArea)
Return

/******************* Exclusao recebimento Planejado ************************/

static function zExcRegSE1()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE1->E1_NUM
Local oGet2
Local cGet2 	:= Posicione("SA1",1,xFilial("SA1") + SE1->E1_CLIENTE + SE1->E1_LOJA, "A1_NREDUZ")
Local oGet3
Local oFornece 	:= SE1->E1_CLIENTE
Local oGet7 
Local oGet8 	:= SE1->E1_LOJA
Local dVencto 	:= SE1->E1_VENCREA
//Local oGet4
Local oGet5		:=  SE1->E1_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE1->E1_NATUREZ), "ED_XGRUPO")
//Local nValor 	:= SE1->E1_VALOR
Local oGet9
Local cGet9 	:= SE1->E1_HIST
Local oGet10
Local cGet10	:= SE1->E1_TIPO
Local oGet11
Local cGet11 	:= SE1->E1_XXIC
Local oGet12
Local cGet12 	:= SE1->E1_NATUREZ

Local dEmissa	:= SE1->E1_EMISSAO
Local oGet13
Local dVenct 	:= SE1->E1_VENCTO
Local oGet14

Local oGet4
Local nValor 	:= SE1->E1_VALOR

Local oGet15
Local nValorRE 	:= SE1->E1_VLCRUZ

Local oGet16
Local nMoeda 	:= SE1->E1_MOEDA

Local oGet17
Local nTXMoeda 	:= SE1->E1_TXMOEDA

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7

Local _nOpc := 0
Static _oDlg

 DEFINE MSDIALOG _oDlg TITLE "Exclusao Titulo Contas a Receber" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL
  
  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)
  
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 042, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fonercedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
      /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
   	@ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE When .F. PICTURE PesqPict("SE1","E1_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda When .F. PICTURE PesqPict("SE1","E1_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor When .F.  PICTURE PesqPict("SE1","E1_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE1","E1_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
    
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL
  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE1",.F.)
  		DbSelectArea("SE1")
  		Reclock("SE1",.F.)
  		if SE1->(DbSeek(xFilial("SE1")+cGet1+oFornece+dtos(dVencto)+oGet8) )
  			SE1->(DbDelete())
  	 	endif	
  	 MsUnlock()
  
	DbSelectArea("TRB8")
	TRB8->(dbgotop())
	zap
	MSAguarde({||zRecSE1()},"Processando Recebimento Planejado")
	TRB8->(DBGoBottom())
	TRB8->(dbgotop())
	GetdRefresh()
  Endif
Return _nOpc

/**************** Exportacao Excel TRB8 recebimento planejado ********************/

Static Function zExptRecPL()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'exprecpl.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB10 ****************/  

	    cTabela 	:= "Planejamento Recebimento " + _cItemConta
	    cPasta		:= "Planejamento Recebimento " + _cItemConta 
	    
	    cDatMov		:= "Data Mov."			// 1
	    cDocto		:= "Docto"				// 2
	    cTipo		:= "Tipo"				// 3
		cValorRE	:= "Valor R$"			// 4
		cMoeda		:= "Moeda"				// 5
		cValor		:= "Valor"				// 6
		cTXMoeda	:= "Taxa Moeda"			// 7
	    cDescri		:= "Descricao"			// 8
	    cHist		:= "Historico"			// 9
	    
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cDatMov)		// 1
        aAdd(aColunas, cDocto)		// 2			
        aAdd(aColunas, cTipo)		// 3
		aAdd(aColunas, cValorRE)	// 4
		aAdd(aColunas, cMoeda)		// 5
		aAdd(aColunas, cValor)		// 6
		aAdd(aColunas, cTXMoeda)	// 7			
        aAdd(aColunas, cDescri)		// 8
        aAdd(aColunas, cHist)		// 9	
             
        oFWMsExcel:AddColumn(cTabela,cPasta, cDatMov,1,2)		// 1 data movimentacao						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDocto,1,2)		// 2 docto
        oFWMsExcel:AddColumn(cTabela,cPasta, cTipo,1,2)			// 3 tipo
		oFWMsExcel:AddColumn(cTabela,cPasta, cValorRE,1,2)		// 4 Valor Real
		oFWMsExcel:AddColumn(cTabela,cPasta, cMoeda,1,2)		// 5 moeda
		oFWMsExcel:AddColumn(cTabela,cPasta, cValor,1,2)		// 6 valor
		oFWMsExcel:AddColumn(cTabela,cPasta, cTXMoeda,1,2)		// 7 tipo
        oFWMsExcel:AddColumn(cTabela,cPasta, cDescri,1,2)		// 8 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cHist,1,2)			// 9 historico
               
     
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB8->(dbgotop())
	                            
        While  !(TRB8->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB8->RPDTMOV
        	aLinhaAux[2] := TRB8->RPDOCTO
        	aLinhaAux[3] := TRB8->RPTPDOC
			aLinhaAux[5] := TRB8->RPVLRDC2
			aLinhaAux[4] := TRB8->RPMOEDA
			aLinhaAux[6] := TRB8->RPVLRDC
        	aLinhaAux[7] := TRB8->RPTXMOE
        	aLinhaAux[8] := TRB8->RPBENEF
        	aLinhaAux[9] := TRB8->RPHIST
        	        	
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB8->(DbSkip())

        EndDo

        TRB8->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Recebimento realizado ************************/

static function zTelaCM()
	
	// Monta aHeader do TRB10
	aadd(aHeader, {" Origem"		,"ORIGEM"		,""					,20,0,"","","C","TRB10","R"})
	aadd(aHeader, {"% Comissao"		,"PCOMISS"		,"@E 999,999,999.99",15,2,"","","N","TRB10","R"})
	aadd(aHeader, {"Comissao"		,"VCOMISS"		,"@E 999,999,999.99",15,2,"","","N","TRB10","R"})
	aadd(aHeader, {"Data Pagamento"	,"DTPGTO"		,""					,08,0,"","","D","TRB10","R"})
	aadd(aHeader, {"Comissao Paga"	,"VCOMPG"		,"@E 999,999,999.99",15,2,"","","N","TRB10","R"})
	aadd(aHeader, {"% Pago"			,"PCOMPG"		,"@E 999,999,999.99",15,2,"","","N","TRB10","R"})
	aadd(aHeader, {"Fornecedor"		,"FORNECE"		,""					,40,0,"","","C","TRB10","R"})
	//aadd(aHeader, {"Contrato"		,"ITEMCTA"		,""					,13,0,"","","C","TRB10","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2] BUTTON 'Exportar Excel' Size 60, 10 action(zExptCom()) OF oFolder1:aDialogs[4] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+70 Say "COMISS�ES"  COLORS 0, 16777215 OF oFolder1:aDialogs[4] PIXEL PIXEL 
	
	_oGetDbCOM := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4]/2, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB10",,,,oFolder1:aDialogs[4])
	
// COR DA FONTE
	_oGetDbCOM:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMCorCM(1)}
	// COR DA LINHA
	_oGetDbCOM:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMCorCM(2)} //Cor da Linha
return

Static Function SFMCorCM(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB10->ORIGEM) ==  "PREVISTO TOTAL"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB10->ORIGEM) ==  "TOTAL PAGO"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB10->ORIGEM) ==  "SALDO A PAGAR"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor

/**************** Exportacao Excel TRB10 Comiss�es ********************/

Static Function zExptCom()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'expcom.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""

	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB10 ****************/  

	    cTabela 	:= "Comissoes " + _cItemConta
	    cPasta		:= "Comissoes " + _cItemConta 
	    
	    cOrigem		:= "Origem"				// 1
	    cPComiss	:= "% Comissao"			// 2
	    cComiss		:= "Comissao"			// 3
	    cDatPag		:= "Data Pagamento"		// 4
	    cComPag		:= "Comissao Paga"		// 5
	    cPPago		:= "% Pago"				// 6
	    cFornece	:= "Fornecedor"			// 7

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cOrigem)		// 1
        aAdd(aColunas, cPComiss)	// 2			
        aAdd(aColunas, cComiss)		// 3							
        aAdd(aColunas, cDatPag)		// 4			
        aAdd(aColunas, cComPag)		// 5
        aAdd(aColunas, cPPago)		// 6	
        aAdd(aColunas, cFornece)	// 7
     
        oFWMsExcel:AddColumn(cTabela,cPasta, cOrigem,1,2)		// 1 origem						
        oFWMsExcel:AddColumn(cTabela,cPasta, cPComiss,1,2)		// 2 % comiss�o	
        oFWMsExcel:AddColumn(cTabela,cPasta, cComiss,1,2)		// 3 comissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cDatPag,1,2)		// 4 data pagamento
        oFWMsExcel:AddColumn(cTabela,cPasta, cComPag,1,2)		// 5 comissao paga
        oFWMsExcel:AddColumn(cTabela,cPasta, cPPago,1,2)		// 6 % pago
        oFWMsExcel:AddColumn(cTabela,cPasta, cFornece,1,2)		// 7 fornecedor
       
     
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB10->(dbgotop())
	                            
        While  !(TRB10->(EoF()))
                      
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB10->ORIGEM
        	aLinhaAux[2] := TRB10->PCOMISS
        	aLinhaAux[3] := TRB10->VCOMISS
        	aLinhaAux[4] := TRB10->DTPGTO
        	aLinhaAux[5] := TRB10->VCOMPG
        	aLinhaAux[6] := TRB10->PCOMPG
        	aLinhaAux[7] := TRB10->FORNECE
        
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB10->(DbSkip())

        EndDo

        TRB10->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela pagamento Planejado ************************/
static function zTPLAPG()

	// Monta aHeader do TRB8
	aadd(aHeader, {" Origem"	,"PPTIPO"		,"",10,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Data Mov."	,"PPDTMOV"		,"",08,0,"","","D","TRB9","R"})
	aadd(aHeader, {"Docto."		,"PPDOCTO"		,"",15,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Tipo."		,"PPTPDOC"		,"",03,0,"","","C","TRB9","R"})

	aadd(aHeader, {"Valor R$"	,"PPVLRDC"		,"@E 999,999,999.99",15,2,"","","N","TRB9","R"})
	aadd(aHeader, {"Vlr.2a.Moeda ","PPVLRDC2"		,"@E 999,999,999.99",15,2,"","","N","TRB9","R"})
	aadd(aHeader, {"Moeda "		,"PPMOEDA"		,"@E 99",02,0,"","","N","TRB9","R"})
	aadd(aHeader, {"Taxa Moeda"	,"PPTXMOE"		,"@E 999,999,999.9999",15,4,"","","N","TRB9","R"})

	aadd(aHeader, {"Descricao"	,"PPBENEF"		,"",20,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Historico"	,"PPHIST"		,"",20,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Contrato"	,"PPICTA"		,"",13,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Loja"		,"PPLOJA"		,"",02,0,"","","C","TRB9","R"})
	aadd(aHeader, {"Fornecedor"	,"PPFORNE"		,"",10,0,"","","C","TRB9","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+5 BUTTON 'Exportar Excel' Size 60, 10 action(zExptPgto()) OF oFolder1:aDialogs[4] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+70 BUTTON 'Incluir' Size 60, 10 action(zIncRegSE2()) OF oFolder1:aDialogs[4] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+135 BUTTON 'Excluir' Size 60, 10 action(zExclSE2()) OF oFolder1:aDialogs[4] Pixel
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+(aPosObj[1,4]/2)+210 Say "PROVISOES - CONTAS A PAGAR "  COLORS 0, 16777215 OF oFolder1:aDialogs[4] PIXEL
	
	_oGetDbPLPP := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2]+(aPosObj[1,4]/2),(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB9",,,,oFolder1:aDialogs[4])
	
	_oGetDbPLPP:oBrowse:BlDblClick := {|| zEditSE2()}
	
	// COR DA FONTE
	_oGetDbPLPP:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMCorPP(1)}
	// COR DA LINHA
	_oGetDbPLPP:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMCorPP(2)} //Cor da Linha
return

Static Function SFMCorPP(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  //if ALLTRIM(TRB2->GRUPO) ==  "0.00.11"; _cCor := CLR_LIGHTGRAY; endif
   endif
   
   if nIOpcao == 2 // Cor da Fonte
   	 
   	  if ALLTRIM(TRB9->PPTIPO) ==  "TOTAL"; _cCor := CLR_HGREEN ; endif
      
    endif
Return _cCor

/******************* Edi��o pagamento Planejado ************************/

Static Function zEditSE2()
    Local aArea       := GetArea()
    Local aAreaE2     := SE2->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB9->PPNTIT)
    Local cClifor	  := alltrim(TRB9->PPFORNE)
    Local cLoja		  := alltrim(TRB9->PPLOJA)
    Local cParcela	  := alltrim(TRB9->PPPARCEL)
    Local dData		  := DTOS(TRB9->PPDTMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela

    Private cCadastro 

		cCadastro := "Alteracao Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB9->PPNTIT+TRB9->PPFORNE+dData+TRB9->PPLOJA) )
			nOpcao := zAltRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        elseif nOpcao == 2
	           nOpcao := zAltRegSE2()   
	        EndIf
	    endif

    RestArea(aAreaE2)
    RestArea(aArea)
Return

/******************* Edi��o pagamento Planejado ************************/

static function zAltRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE2->E2_NUM
Local oGet2
Local cGet2 	:= Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local oFornece 	:= SE2->E2_FORNECE
Local oGet7 
Local oGet8 	:= SE2->E2_LOJA
Local dVencto 	:= SE2->E2_VENCREA

Local oGet5		:=  SE2->E2_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE2->E2_NATUREZ), "ED_XGRUPO")

Local oGet4
Local nValor 	:= SE2->E2_VALOR

Local oGet15
Local nValorRE 	:= SE2->E2_VLCRUZ

Local oGet16
Local nMoeda 	:= SE2->E2_MOEDA

Local oGet17
Local nTXMoeda 	:= SE2->E2_TXMOEDA

Local oGet9
Local cGet9 	:= SE2->E2_HIST
Local oGet10
Local cGet10	:= SE2->E2_TIPO
Local oGet11
Local cGet11 	:= SE2->E2_XXIC
Local oGet12
Local cGet12 	:= SE2->E2_NATUREZ

Local dEmissa	:= SE2->E2_EMISSAO
Local oGet13
Local dVenct 	:= SE2->E2_VENCTO
Local oGet14

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7
local _cQuery 		:= ""
Local dData 		:= DDatabase
Local dData2		:= DDatabase
Local QUERY 		:= ""
Local QUERY2 		:= ""
Local QUERY3 		:= ""
Local nVlrMoeda		:= 1

Local _nOpc := 0
Static _oDlg

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************

  DEFINE MSDIALOG _oDlg TITLE "Edicao Titulo Contas a Pagar" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL
  
  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 Picture "@!" Pixel F3 "SED" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA2" SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
	
    @ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE PICTURE PesqPict("SE2","E2_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda PICTURE PesqPict("SE2","E2_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Vlr.2a.Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor  PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE2","E2_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
     

    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .T. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if empty(oFornece) 
		msgstop("Informe codigo do Fornecedor.")
		_nOpc := 2
	endif
	
	if empty(cGet12) 
		msgstop("Informe Natureza.")
		_nOpc := 2
	endif

	if nValor = 0 .AND. nValorRE = 0 .AND. EMPTY(nMoeda)
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif

	if empty(cGet9) 
		msgstop("Informe Historico.")
		_nOpc := 2
	endif

	if dVencto < dVenct
		msgstop("Vencimento real nao pode menor que Vencimento.")
		_nOpc := 2
	endif

	
  If _nOpc = 1
  	Reclock("SE2",.F.)
  	//SE2->E2_VENCTO 	:= dVencto
  	SE2->E2_VENCREA 	:= DataValida(dVencto,.T.) //Proximo dia �til
  	SE2->E2_EMISSAO 	:= DataValida(dEmissa,.T.) //Proximo dia �til
  	SE2->E2_VENCTO 		:= DataValida(dVenct,.T.) //Proximo dia �til

	//************************************
	if nValor = 0 .OR. nValor > 0 .AND. nValorRE > 0 
		
		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE 
				SE2->E2_SALDO	:= nValorRE 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

	if nValorRE = 0

		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValor
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

  	SE2->E2_HIST	:= cGet9
  	SE2->E2_NATUREZ	:= cGet12
  	if alltrim(oGet5) = "PR"
  		SE2->E2_FORNECE	:= alltrim(oFornece)
  		SE2->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_NREDUZ")
  		SE2->E2_LOJA	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_LOJA")
  	endif	
  	MsUnlock()
  
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap
	MSAguarde({||zPagSE2()},"Processando Contas a Pagar Planejado")
	TRB9->(DBGoBottom())
	TRB9->(dbgotop())
	GetdRefresh()
  Endif

	QUERY2->(DbCloseArea())

  
Return _nOpc

/******************* Inclusao pagamento Planejado ************************/

static function zIncRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= space(9)
Local oGet2
Local cGet2 	:= ""
Local oGet3
Local oFornece 	:= space(10)
Local oGet7 	:= space(10)
Local oGet8 	:=  space(1)
Local dEmissa	:= dDatabase
Local oGet13
Local dVenct 	:= dDatabase
Local oGet14

Local dVencto 	:= dDatabase
Local oGet4
Local oGet5		:=  "PR"
Local oGet6		:=  ""
Local nValor 	:= 0

Local oGet15
Local nValorRE 	:= 0

Local oGet16
Local nMoeda 	:= 0

Local oGet17
Local nTXMoeda 	:= 0

Local oGet9
Local cGet9 	:= space(40)
Local oGet10
Local cGet10	:= "PR"
Local oGet11
Local cGet11 	:= _cItemConta
Local oGet12
Local cGet12 	:= space(10)

LOCAL cContador := 1
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7
Local nTotReg := 0
Local _nOpc := 0
Static _oDlg

//******************************
	dbSelectArea("SM2")
	//SM2->( dbSetOrder(1) )

	_cQuery := "SELECT CAST(M2_DATA AS DATE) AS 'TMP_DATA', M2_MOEDA1, M2_MOEDA2, M2_MOEDA3, M2_MOEDA4 FROM SM2010  WHERE  D_E_L_E_T_ <> '*' ORDER BY M2_DATA"

	IF Select("_cQuery") <> 0
		DbSelectArea("_cQuery")
		DbCloseArea()
	ENDIF

	//crio o novo alias
	TCQUERY _cQuery NEW ALIAS "QUERY2"
	
	dbSelectArea("QUERY2")
	QUERY2->(dbGoTop())

//*************************

	cQuery := " SELECT * FROM SE2010 WHERE E2_XXIC = '" + _cItemConta + "' AND E2_TIPO = 'PR' AND D_E_L_E_T_ <> '*' "
    TCQuery cQuery New Alias "TSE2"
        
    Count To nTotReg
    TSE2->(DbGoTop()) 
    
    nTotReg := nTotReg+1
    
    cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM SE2010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_)  FROM SE2010) "
    TCQuery cQuery2 New Alias "TSE2B"

	

    cGet1 := strzero(TSE2B->RECNO+cContador,7) + "P" //SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),9,2)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(nTotReg,2)
	//SE2->(dbSeek(xFilial("SE2")+cGet1))
	dbSelectArea("SE2")
	SE2->( dbGoTop() )
	SE2->(dbSetOrder(20) ) 
	While SE2->(dbSeek(xFilial("SE2")+cGet1,.T.))
		if SE2->(dbSeek(xFilial("SE2")+cGet1,.T.))
			//msginfo("1: " + cGet1)
			cContador++
			cGet1 := strzero(TSE2B->RECNO+cContador,7) + "P"
			//msginfo("2: " + cGet1)
		Endif
	EndDo
		

	DEFINE MSDIALOG _oDlg TITLE "Inclusao Titulo Contas a Pagar" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL

  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .T. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 Picture "@!" Pixel F3 "SED" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 010 MSGET oGet7 VAR oFornece Picture "@!" Pixel F3 "SA2" SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
    @ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE PICTURE PesqPict("SE2","E2_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda PICTURE PesqPict("SE2","E2_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Vlr.2a.Moeda " SIZE 025, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor  PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE2","E2_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
     

    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .T. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if empty(oFornece) 
		msgstop("Informe codigo do Fornecedor.")
		_nOpc := 2
	endif
	
	if empty(cGet12) 
		msgstop("Informe Natureza.")
		_nOpc := 2
	endif
	
	if nValor = 0 .AND. nValorRE = 0 .AND. empty(nMoeda)
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif

	if dVencto < dVenct
		msgstop("Vencimento real nao pode menor que Vencimento.")
		_nOpc := 2
	endif

	if dVencto < dDatabase
		msgstop("Vencimento real nao pode menor que Data Atual.")
		_nOpc := 2
	endif

	if nValor = 0 .AND. nValorRE = 0 
		msgstop("Informe valor do titulo.")
		_nOpc := 2
	endif
	
	if empty(cGet9) 
		msgstop("Informe Historico.")
		_nOpc := 2
	endif

  If _nOpc = 1

	
  
  	Reclock("SE2",.F.)

  	SE2->( DBAppend( .F. ) )
  	
  	R_E_C_N_O_			:= TSE2B->RECNO+1
  	//SE2->E2_VENCTO 	:= dVencto
  	SE2->E2_FILIAL		:= "01"
  	SE2->E2_NUM			:= cGet1 //SUBSTR(alltrim(_cItemConta),1,1)+SUBSTR(alltrim(_cItemConta),9,2)+SUBSTR(alltrim(_cItemConta),3,1)+SUBSTR(alltrim(_cItemConta),5,3)+strzero(nTotReg,2)
  	SE2->E2_TIPO		:= "PR"
  	SE2->E2_XXIC		:= _cItemConta
  	SE2->E2_NATUREZ		:= cGet12
  	SE2->E2_VENCREA 	:= DataValida(dVencto,.T.) //Proximo dia �til
  	SE2->E2_EMISSAO 	:= DataValida(dEmissa,.T.) //Proximo dia �til
  	SE2->E2_VENCTO 		:= DataValida(dVenct,.T.) //Proximo dia �til

  	//************************************
	if nValor = 0 
		
		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
					IncProc("Processando registro: "+alltrim(dData))
					//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
					ProcessMessage()
					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
					IncProc("Processando registro: "+alltrim(dData))
					//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
					ProcessMessage()
					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
					IncProc("Processando registro: "+alltrim(dData))
					//MsProcTxt("Processando registro: "+alltrim(QUERY->ZG_IDVDSUB))
					ProcessMessage()
					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE / nTXMoeda
				SE2->E2_SALDO	:= nValorRE / nTXMoeda
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValorRE
				SE2->E2_VALOR	:= nValorRE 
				SE2->E2_SALDO	:= nValorRE 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

	if nValorRE = 0

		if nMoeda = 2
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
					IncProc("Processando registro: "+alltrim(dData))
					//MsProcTxt("Processando registro: "+alltrim(QdData))
					ProcessMessage()
					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA2
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA2
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 3
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0
					IncProc("Processando registro: "+alltrim(dData))
					//MsProcTxt("Processando registro: "+alltrim(QdData))
					ProcessMessage()
					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA3
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA3
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  
		elseif nMoeda = 4
				dData := DataValida(dVencto,.T.)
				//msginfo ( dData )
				while QUERY2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

					while  QUERY2->(!eof())
						
						nTXMoeda := QUERY2->M2_MOEDA4
					
						if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
							nTXMoeda := QUERY2->M2_MOEDA4
							Exit
						else
							QUERY2->(dbSkip())
						endif

					enddo
					if dtoc(dData) == dtoc(QUERY2->TMP_DATA) .AND. nTXMoeda > 0
						exit
					else
						QUERY2->(dbGoTop())
					ENDIF
					dData--
					//msginfo(dtoc(dData) + " " + dtoc(QUERY2->TMP_DATA))
				enddo
				
				SE2->E2_VLCRUZ	:= nValor * nTXMoeda
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor
				SE2->E2_MOEDA	:= nMoeda
				SE2->E2_TXMOEDA	:= nTXMoeda  

		else
				SE2->E2_VLCRUZ	:= nValor
				SE2->E2_VALOR	:= nValor 
				SE2->E2_SALDO	:= nValor 
				SE2->E2_MOEDA	:= 1
				SE2->E2_TXMOEDA	:= 0  
			
		endif

	endif

  	SE2->E2_HIST		:= cGet9
  	SE2->E2_NATUREZ		:= cGet12
   	SE2->E2_BAIXA		:= STOD("")
  	SE2->E2_DATAAGE		:= DataValida(dVencto,.T.) //Proximo dia �til
  	if alltrim(oGet5) = "PR"
  		SE2->E2_FORNECE	:= oFornece
  		SE2->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_NREDUZ")
  		SE2->E2_LOJA	:= Posicione("SA2",1,xFilial("SA2") + oFornece, "A2_LOJA")
  	endif	
  	SE2->( DBCommit() )
  	MsUnlock()
  
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap
	MSAguarde({||zPagSE2()},"Processando Contas a Pagar Planejado")
	TRB9->(DBGoBottom())
	TRB9->(dbgotop())
	GetdRefresh()
  Endif
  
  TSE2->(DbCloseArea())
  TSE2B->(DbCloseArea())
  QUERY2->(DbCloseArea())
  
Return _nOpc

/******************* Exclusao pagamento Planejado ************************/


Static Function zExclSE2()
    Local aArea       := GetArea()
    Local aAreaE2     := SE2->(GetArea())
    Local nOpcao      := 0
    Local cTitulo	  := alltrim(TRB9->PPNTIT)
    Local cClifor	  := alltrim(TRB9->PPFORNE)
    Local cLoja		  := alltrim(TRB9->PPLOJA)
    Local cParcela	  := alltrim(TRB9->PPPARCEL)
    Local dData		  := DTOS(TRB9->PPDTMOV)
    Local cConsSE2	  := cClifor+cTitulo+cParcela

   
    Private cCadastro 

		cCadastro := "Alteracao Contas a Pagar"

	    DbSelectArea("SE2")
	    SE2->(DbSetOrder(20)) //B1_FILIAL + B1_COD
	    	
		//if SE2->(DbSeek(xFilial("SE2")+cTitulo+cClifor) )
		if SE2->(DbSeek(xFilial("SE2")+TRB9->PPNTIT+TRB9->PPFORNE+dData+TRB9->PPLOJA) )
			nOpcao := zExcRegSE2()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")	
	        EndIf
	    endif

    RestArea(aAreaE2)
    RestArea(aArea)
Return

/******************* Exclusao pagamento Planejado ************************/

static function zExcRegSE2()

Local oButton1
Local oButton2
Local oGet1
Local cGet1 	:= SE2->E2_NUM
Local oGet2
Local cGet2 	:= Posicione("SA2",1,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA, "A2_NREDUZ")
Local oGet3
Local oFornece 	:= SE2->E2_FORNECE
Local oGet7 
Local oGet8 	:= SE2->E2_LOJA
Local dVencto 	:= SE2->E2_VENCREA
//Local oGet4
Local oGet5		:=  SE2->E2_TIPO
Local oGet6		:=  Posicione("SED",1,xFilial("SED") + ALLTRIM(SE2->E2_NATUREZ), "ED_XGRUPO")
//Local nValor 	:= SE2->E2_VALOR
Local oGet9
Local cGet9 	:= SE2->E2_HIST
Local oGet10
Local cGet10	:= SE2->E2_TIPO
Local oGet11
Local cGet11 	:= SE2->E2_XXIC
Local oGet12
Local cGet12 	:= SE2->E2_NATUREZ

Local oGet4
Local nValor 	:= SE2->E2_VALOR

Local oGet15
Local nValorRE 	:= SE2->E2_VLCRUZ

Local oGet16
Local nMoeda 	:= SE2->E2_MOEDA

Local oGet17
Local nTXMoeda 	:= SE2->E2_TXMOEDA

Local dEmissa	:= SE2->E2_EMISSAO
Local oGet13
Local dVenct 	:= SE2->E2_VENCTO
Local oGet14

Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay7

Local _nOpc := 0
Static _oDlg

	DEFINE MSDIALOG _oDlg TITLE "Exclusao Titulo Contas a Pagar" FROM 000, 000  TO 350, 498 COLORS 0, 16777215 PIXEL

  	oGroup1:= TGroup():New(0005,0005,0145,0245,'',_oDlg,,,.T.)

 /// DEFINE MSDIALOG _oDlg TITLE "Exclusao Titulo Contas a Pagar" FROM 000, 000  TO 300, 498 COLORS 0, 16777215 PIXEL

  //	oGroup1:= TGroup():New(0005,0005,0125,0245,'',_oDlg,,,.T.)
 
    @ 013, 010 SAY oSay1 PROMPT "Titulo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay10 PROMPT "Tipo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oGet10 VAR cGet10 When .F. SIZE 032, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 102 SAY oSay11 PROMPT "Contrato" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 102 MSGET oGet11 VAR cGet11 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 172 SAY oSay11 PROMPT "Natureza" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 172 MSGET oGet12 VAR cGet12 When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
 	@ 037, 010 SAY oSay7 PROMPT "Codigo" SIZE 032, 007  COLORS 0, 16777215 PIXEL
	@ 046, 010 MSGET oGet7 VAR oFornece When .F. SIZE 048, 010  COLORS 0, 16777215 PIXEL
	   
    @ 037, 063 SAY oSay2 PROMPT "Fornecedor" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 046, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 180, 010  COLORS 0, 16777215 PIXEL
    
     /**************/
    @ 063, 010 SAY oSay13 PROMPT "Emissao" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 010 MSGET oGet13 VAR dEmissa When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 060 SAY oSay14 PROMPT "Vencimento" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 060 MSGET oGet14 VAR dVenct When .F. SIZE 044, 010  COLORS 0, 16777215 PIXEL
    
    @ 063, 110 SAY oSay3 PROMPT "Vencto Real" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 072, 110 MSGET oGet3 VAR dVencto When .F.SIZE 044, 010  COLORS 0, 16777215 PIXEL
    /**************/  
     /**************/  
    @ 087, 010 SAY oSay4 PROMPT "Valor R$" SIZE 038, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 010 MSGET oGet15 VAR nValorRE When .F. PICTURE PesqPict("SE2","E2_VLCRUZ") SIZE 060, 010  COLORS 0, 16777215 PIXEL

	@ 087, 080 SAY oSay4 PROMPT "Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 080 MSGET oGet16 VAR nMoeda When .F. PICTURE PesqPict("SE2","E2_MOEDA") Pixel F3 "SM2" SIZE 020, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 110 SAY oSay4 PROMPT "Valor" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 110 MSGET oGet4 VAR nValor When .F. PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010  COLORS 0, 16777215 PIXEL  

	@ 087, 180 SAY oSay4 PROMPT "Taxa Moeda" SIZE 018, 007 COLORS 0, 16777215 PIXEL
  	@ 098, 180 MSGET oGet17 VAR nTXMoeda When .F. PICTURE PesqPict("SE2","E2_TXMOEDA") SIZE 060, 010  COLORS 0, 16777215 PIXEL  
     
    @ 111, 010 SAY oSay9 PROMPT "Historico" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 122, 010 MSGET oGet9 VAR cGet9 When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
    
    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 152, 079 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 039, 010  PIXEL
    @ 152, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1
  	Reclock("SE2",.F.)
  		DbSelectArea("SE2")
  		Reclock("SE2",.F.)
  		if SE2->(DbSeek(xFilial("SE2")+cGet1+oFornece+dtos(dVencto)+oGet8) )
  			SE2->(DbDelete())
  	 	endif	
  	 MsUnlock()
  
	DbSelectArea("TRB9")
	TRB9->(dbgotop())
	zap
	MSAguarde({||zPagSE2()},"Processando Contas a Pagar Planejado")
	TRB9->(DBGoBottom())
	TRB9->(dbgotop())
	GetdRefresh()
  Endif
Return _nOpc

/**************** Exportacao Excel TRB9 provisoes pagamento ********************/

Static Function zExptPgto()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'exppgto.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB10 ****************/  

	    cTabela 	:= "Provisoes Pagamento " + _cItemConta
	    cPasta		:= "Provisoes Pagamento " + _cItemConta 
	    
	    cDTMov		:= "Data Movimento"	 	// 1
	    cDocto		:= "Docto"				// 2
	    cTipo		:= "Tipo"				// 3

		cValorRE	:= "Valor R$"			// 4
		cMoeda		:= "Moeda"				// 5
		cValor		:= "Valor"				// 6
		cTXMoeda	:= "Taxa Moeda"			// 7

	    cDescr		:= "Descricao"			// 8
	    cHist		:= "Historico"			// 9
	    

    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cDTMov)		// 1
        aAdd(aColunas, cDocto)		// 2			
        aAdd(aColunas, cTipo)		// 3	

		aAdd(aColunas, cValorRE)	// 4
		aAdd(aColunas, cMoeda)		// 5
		aAdd(aColunas, cValor)		// 6
		aAdd(aColunas, cTXMoeda)	// 7

        aAdd(aColunas, cDescr)		// 8
        aAdd(aColunas, cHist)		// 9	
        
        oFWMsExcel:AddColumn(cTabela,cPasta, cDTMov,1,2)		// 1 data movimento						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDocto,1,2)		// 2 docto
        oFWMsExcel:AddColumn(cTabela,cPasta, cTipo,1,2)			// 3 tipo

		oFWMsExcel:AddColumn(cTabela,cPasta, cValorRE,1,2)		// 4 tipo
		oFWMsExcel:AddColumn(cTabela,cPasta, cMoeda,1,2)		// 5 moeda
		oFWMsExcel:AddColumn(cTabela,cPasta, cValor,1,2)		// 6 valor
		oFWMsExcel:AddColumn(cTabela,cPasta, cTXMoeda,1,2)		// 7 TXMoeda
      
        oFWMsExcel:AddColumn(cTabela,cPasta, cDescr,1,2)		// 8 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cHist,1,2)			// 9 historico

    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB9->(dbgotop())
	                            
        While  !(TRB9->(EoF()))
                        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB9->PPDTMOV
        	aLinhaAux[2] := TRB9->PPDOCTO
        	aLinhaAux[3] := TRB9->PPTPDOC

			aLinhaAux[4] := TRB9->PPVLRDC
			aLinhaAux[5] := TRB9->PPMOEDA
        	aLinhaAux[6] := TRB9->PPVLRDC2
			aLinhaAux[7] := TRB9->PPTXMOE

        	aLinhaAux[8] := TRB9->PPBENEF
        	aLinhaAux[9] := TRB9->PPHIST
        	        	
        	oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
        		/*
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	        	*/
        	
            TRB9->(DbSkip())

        EndDo

        TRB9->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Solicita��es de Compra ************************/

static function zTPSOLIC()

	// Monta aHeader do TRB12
	aadd(aHeader, {"Status"			,"STATUS"		,""					,10,0,"","","C","TRB12","R"})
	aadd(aHeader, {"No.Solic."		,"NSOLICIT"		,""					,06,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Item"			,"ITEMSC"		,""					,06,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Produto"		,"CODPROD"		,""					,30,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Descricao"		,"DESCRI"		,""					,40,0,"","","C","TRB12","R"})
	aadd(aHeader, {"UM"				,"UM"			,""					,02,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Qtd.Solicitada"	,"QUANTSOC"		,"@E 999,999,999.99",15,2,"","","N","TRB12","R"})
	aadd(aHeader, {"Qtd.Entregue"	,"QUANTENT"		,"@E 999,999,999.99",15,2,"","","N","TRB12","R"})
	aadd(aHeader, {"Emissao"		,"EMISSAO"		,""					,08,0,"","","D","TRB12","R"})
	aadd(aHeader, {"Entrega"		,"ENTREGA"		,""					,08,0,"","","D","TRB12","R"})
	aadd(aHeader, {"No.Ped.Compra"	,"NPEDIDO"		,""					,06,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Solicitante"	,"NOMSOLIC"		,""					,20,0,"","","C","TRB12","R"})
	aadd(aHeader, {"Ordem de Producao","ORDPROD"	,""					,20,0,"","","C","TRB12","R"})
	//aadd(aHeader, {"Contrato"		,"ITEMCTA"		,""					,13,0,"","","C","TRB12","R"})
	
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+5 Say "SOLICITA��ES"  COLORS 0, 16777215 OF oFolder1:aDialogs[5] PIXEL PIXEL 
	@ aPosObj[1,1]-30 , aPosObj[1,2] BUTTON 'Exportar Excel'         Size 60, 10 action(zExpSocit()) OF oFolder1:aDialogs[5] Pixel
	
	_oGetDbSOC := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB12",,,,oFolder1:aDialogs[5])
	
return

/**************** Exportacao Excel TRB12 Solicitacao de Compra ********************/

Static Function zExpSocit()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'SolCom.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    
    /*************** TRB12 ****************/  

	    cTabela 	:= "Solicitacao de Compra " + _cItemConta
	    cPasta		:= "Solicitacao de Compra " + _cItemConta 
	    
	    cStatus		:= "Status"			// 1
	    cNSolic		:= "No.Solicitacao"	// 2
	    cItemSC		:= "Item"			// 3
	    cCodProd	:= "Produto"		// 4
	    cDescri		:= "Descricao"		// 5
	    cUM			:= "UM"				// 6
	    cQtdSC		:= "Qtd.Soicitada"	// 7
	    cQtdEntr	:= "Qtd.Entregue"	// 8
	    cEmissao	:= "Emissao"		// 9
	    cEntrega	:= "Entrega"		// 10
	    cNPedido	:= "No.Pedido"		// 11
	    cSolicit	:= "Solicitante"	// 12
	    cOrdPrd		:= "Ordem de Producao" //13
	    cItemCTA	:= "Contrato"		// 14
	  	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cStatus)			// 1
        aAdd(aColunas, cNSolic)			// 2				
        aAdd(aColunas, cItemSC)			// 3							
        aAdd(aColunas, cCodProd)		// 4				
        aAdd(aColunas, cDescri)			// 5
        aAdd(aColunas, cUM)				// 6	
        aAdd(aColunas, cQtdSC)			// 7
        aAdd(aColunas, cQtdEntr)		// 8
        aAdd(aColunas, cEmissao)		// 9
        aAdd(aColunas, cEntrega)		// 10
        aAdd(aColunas, cNPedido)		// 11
        aAdd(aColunas, cSolicit)		// 12
        aAdd(aColunas, cOrdPrd)			// 13
        aAdd(aColunas, cItemCTA)		// 14
       
        oFWMsExcel:AddColumn(cTabela,cPasta, cStatus,1,2)					// 1 status						
        oFWMsExcel:AddColumn(cTabela,cPasta, cNSolic,1,2)					// 2 no. solicitacao			
        oFWMsExcel:AddColumn(cTabela,cPasta, cItemSC,1,2)					// 3 item		
        oFWMsExcel:AddColumn(cTabela,cPasta, cCodProd,1,2)					// 4 produto
        oFWMsExcel:AddColumn(cTabela,cPasta, cDescri,1,2)					// 5 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cUM,1,2)						// 6 um
        oFWMsExcel:AddColumn(cTabela,cPasta, cQtdSC,1,2)					// 7 qtd. solicitada
        oFWMsExcel:AddColumn(cTabela,cPasta, cQtdEntr,1,2)					// 8 qtd. entregue
        oFWMsExcel:AddColumn(cTabela,cPasta, cEmissao,1,2)					// 9 emissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cEntrega,1,2)					// 10 entrega
        oFWMsExcel:AddColumn(cTabela,cPasta, cNPedido,1,2)					// 11 no. pedido	
        oFWMsExcel:AddColumn(cTabela,cPasta, cSolicit,1,2)					// 12 solicitante
        oFWMsExcel:AddColumn(cTabela,cPasta, cOrdPrd,1,2)					// 13 no. orderm de producao	
        oFWMsExcel:AddColumn(cTabela,cPasta, cItemCTA,1,2)					// 14 contrato
        
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB12->(dbgotop())
	                            
        While  !(TRB12->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB12->STATUS
        	aLinhaAux[2] := TRB12->NSOLICIT
        	aLinhaAux[3] := TRB12->ITEMSC
        	aLinhaAux[4] := TRB12->CODPROD
        	aLinhaAux[5] := TRB12->DESCRI
        	aLinhaAux[6] := TRB12->UM
        	aLinhaAux[7] := TRB12->QUANTSOC
        	aLinhaAux[8] := TRB12->QUANTENT
        	aLinhaAux[9] := TRB12->EMISSAO
        	aLinhaAux[10] := TRB12->ENTREGA
        	aLinhaAux[11] := TRB12->NPEDIDO
        	aLinhaAux[12] := TRB12->NOMSOLIC
        	aLinhaAux[13] := TRB12->ORDPROD
        	aLinhaAux[14] := TRB12->ITEMCTA
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	 
        	
            TRB12->(DbSkip())

        EndDo

        TRB12->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return


/******************* Tela Pedidos de Compra ************************/

static function zTPDCOM()

	// Monta aHeader do TRB12
	aadd(aHeader, {"Status"			,"PSTATUS"		,""					,10,0,"","","C","TRB13","R"})
	aadd(aHeader, {"No.Ped.Compra"	,"PNPEDIDO"		,""					,06,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Item"			,"PITEMPC"		,""					,06,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Produto"		,"PCODPROD"		,""					,30,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Descricao"		,"PDESCRI"		,""					,40,0,"","","C","TRB13","R"})
	aadd(aHeader, {"UM"				,"PUM"			,""					,02,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Qtd.Pedido"		,"PQTDPC"		,"@E 999,999,999.99",15,2,"","","N","TRB13","R"})
	aadd(aHeader, {"Qtd.Entregue"	,"PQTDENTR"		,"@E 999,999,999.99",15,2,"","","N","TRB13","R"})
	aadd(aHeader, {"Unitario"		,"PUNIT"		,"@E 999,999,999.99",15,2,"","","N","TRB13","R"})
	aadd(aHeader, {"Total"			,"PTOTAL"		,"@E 999,999,999.99",15,2,"","","N","TRB13","R"})
	aadd(aHeader, {"Total s/Tributos","PTOTALSI"	,"@E 999,999,999.99",15,2,"","","N","TRB13","R"})
	aadd(aHeader, {"Emissao"		,"PEMISSAO"		,""					,08,0,"","","D","TRB13","R"})
	aadd(aHeader, {"Entrega"		,"PENTREGA"		,""					,08,0,"","","D","TRB13","R"})
	aadd(aHeader, {"No.Solic."		,"PNSOLIC"		,""					,06,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Fonecedor"		,"PFORNECE"		,""					,10,0,"","","C","TRB13","R"})
	aadd(aHeader, {"Nome Fornec."	,"PDFORNECE"	,""					,30,0,"","","C","TRB13","R"})
	//aadd(aHeader, {"Contrato"		,"ITEMCTA"		,""					,13,0,"","","C","TRB12","R"})
	
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+5 Say "PEDIDO DE COMPRA"  COLORS 0, 16777215 OF oFolder1:aDialogs[6] PIXEL PIXEL 
	
	@ aPosObj[1,1]-30 , aPosObj[1,2] BUTTON 'Exportar Excel'         Size 60, 10 action(zExpPedC()) OF oFolder1:aDialogs[6] Pixel
	
	_oGetDbPED := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB13",,,,oFolder1:aDialogs[6])
	
	_oGetDbPED:oBrowse:BlDblClick := {|| z2ERSC7() }


return

Static Function z2ERSC7()
    Local aArea       := GetArea()
    Local aAreaC7     := SC7->(GetArea())
    Local nOpcao      := 0
    Local cNumero	  := alltrim(TRB13->PNPEDIDO)
    Local cStatus	  := TRB13->PSTATUS
	Local cProduto    := TRB13->PCODPROD
	Local cItem		  := TRB13->PITEMPC	
   
    Private cCadastro 

	IF cStatus <> "Encerrado"  

		cCadastro := "Alteracao Ordem de Compra"
		
		DbSelectArea("SC7")
		SC7->(DbSetOrder(4)) //B1_FILIAL + B1_COD
				
		//Se conseguir posicionar no produto
		If SC7->(DbSeek(xFilial('SC7')+cProduto+cNumero+cItem))
				
			nOpcao := fARgSC7()
			If nOpcao == 1
				MsgInfo("Rotina confirmada", "Atencao")
			EndIf
			
		EndIf
	else
		MsgInfo("N�o � poss�vel alterar registro. Pedido encerrado.", "Atencao")
	endif
   
    RestArea(aAreaC7)
    RestArea(aArea)
Return

static Function fARgSC7()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SC7->C7_NUM
Local oGet2
//Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, "A2_NREDUZ")
Local oGet3
Local dVencto := SC7->C7_DATPRF
Local oGet4
Local oGet5	
Local oGet6	
Local cProduto := SC7->C7_PRODUTO
Local cGet2 := SC7->C7_DESCRI

Local cItem := SC7->C7_ITEM
Local nQuant := TRB13->PQTDPC
Local nValor := TRB13->PUNIT
Local nValor2 := TRB13->PTOTAL
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Alterar Data de Entrega Ordem de Compra" FROM 000, 000  TO 200, 590 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 278, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 268, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Numero OC" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Produto" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Data Entrega" SIZE 050, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    
	@ 038, 063 SAY oSay4 PROMPT "Quantidade " SIZE 030, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 038, 133 SAY oSay4 PROMPT "Vlr.s/Tributos " SIZE 050, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 038, 203 SAY oSay4 PROMPT "Vlr.c/Tributos" SIZE 050, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
    
	@ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 200, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL

	@ 049, 061 MSGET oGet2 VAR  Transform(nQuant,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
   	@ 049, 131 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 049, 201 MSGET oGet2 VAR  Transform(nValor2,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL

    @ 073, 089 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 137 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1

	Reclock("TRB13",.F.)
	  		TRB13->PENTREGA	:=  DataValida(dVencto,.T.)
	MsUnlock()
  	
  	DbSelectArea("SC7")
	SC7->(DbSetOrder(4)) //B1_FILIAL + B1_COD
	
  	If SC7->(DbSeek(xFilial('SC7')+cProduto+cGet1+cItem))
  			Reclock("SC7",.F.)
		  	SC7->C7_DATPRF := DataValida(dVencto,.T.) //Proximo dia �til
		  	MsUnlock()	
	EndIf
  	
  Endif

Return _nOpc

/**************** Exportacao Excel TRB13 Pedidos de Compra ********************/

Static Function zExpPedC()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'PedCom.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    
    /*************** TRB13 ****************/  

	    cTabela 	:= "Pedido de Compra " + _cItemConta
	    cPasta		:= "Pedido de Compra " + _cItemConta 
	    
	    cPStatus	:= "Status"			// 1
	    cPNPedido	:= "No.Pedido"		// 2
	    cPItemPC	:= "Item"			// 3
	    cPCodProd	:= "Produto"		// 4
	    cPDescri	:= "Descricao"		// 5
	    cPUM		:= "UM"				// 6
	    cPQtdPC		:= "Qtd.Pedido"		// 7
	    cPQtdEntr	:= "Qtd.Entregue"	// 8
	    cPEmissao	:= "Emissao"		// 9
	    cPEntrega	:= "Entrega"		// 10
	    cPNSolic	:= "No.Solicitacao"	// 11
	    cPItemCTA	:= "Contrato"		// 12
	  	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cPStatus)			// 1
        aAdd(aColunas, cPNPedido)			// 2				
        aAdd(aColunas, cPItemPC)			// 3							
        aAdd(aColunas, cPCodProd)			// 4				
        aAdd(aColunas, cPDescri)			// 5
        aAdd(aColunas, cPUM)				// 6	
        aAdd(aColunas, cPQtdPC)				// 7
        aAdd(aColunas, cPQtdEntr)			// 8
        aAdd(aColunas, cPEmissao)			// 9
        aAdd(aColunas, cPEntrega)			// 10
        aAdd(aColunas, cPNSolic)			// 11
        aAdd(aColunas, cPItemCTA)			// 12
       
        oFWMsExcel:AddColumn(cTabela,cPasta, cPStatus,1,2)					// 1 status						
        oFWMsExcel:AddColumn(cTabela,cPasta, cPNPedido,1,2)					// 2 no. pedido			
        oFWMsExcel:AddColumn(cTabela,cPasta, cPItemPC,1,2)					// 3 item		
        oFWMsExcel:AddColumn(cTabela,cPasta, cPCodProd,1,2)					// 4 produto
        oFWMsExcel:AddColumn(cTabela,cPasta, cPDescri,1,2)					// 5 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cPUM,1,2)						// 6 um
        oFWMsExcel:AddColumn(cTabela,cPasta, cPQtdPC,1,2)					// 7 qtd. pedido
        oFWMsExcel:AddColumn(cTabela,cPasta, cPQtdEntr,1,2)					// 8 qtd. entregue
        oFWMsExcel:AddColumn(cTabela,cPasta, cPEmissao,1,2)					// 9 emissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cPEntrega,1,2)					// 10 entrega
        oFWMsExcel:AddColumn(cTabela,cPasta, cPNSolic,1,2)					// 11 no. solicitacao	
        oFWMsExcel:AddColumn(cTabela,cPasta, cPItemCTA,1,2)					// 12 contrato
        
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB13->(dbgotop())
	                            
        While  !(TRB13->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB13->PSTATUS
        	aLinhaAux[2] := TRB13->PNPEDIDO
        	aLinhaAux[3] := TRB13->PITEMPC
        	aLinhaAux[4] := TRB13->PCODPROD
        	aLinhaAux[5] := TRB13->PDESCRI
        	aLinhaAux[6] := TRB13->PUM
        	aLinhaAux[7] := TRB13->PQTDPC
        	aLinhaAux[8] := TRB13->PQTDENTR
        	aLinhaAux[9] := TRB13->PEMISSAO
        	aLinhaAux[10] := TRB13->PENTREGA
        	aLinhaAux[11] := TRB13->PNSOLIC
        	aLinhaAux[12] := TRB13->PITEMCTA
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#F0FFF0")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	 
        	
            TRB13->(DbSkip())

        EndDo

        TRB13->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/******************* Tela Orderm de Produ��o ************************/

static function zTORDPD()

	// Monta aHeader do TRB14
	
	aadd(aHeader, {"Ordem de Producao","ORDPRD"		,""					,11,0,"","","C","TRB14","R"})
	aadd(aHeader, {"Produto"		,"OPRODUT"		,""					,30,0,"","","C","TRB14","R"})
	aadd(aHeader, {"Descricao"		,"ODESCRI"		,""					,80,0,"","","C","TRB14","R"})
	aadd(aHeader, {"Armazem"		,"OLOCAL"		,""					,02,0,"","","C","TRB14","R"})
	aadd(aHeader, {"Quantidade"		,"OQUANT"		,"@E 999,999,999.999999",16,6,"","","N","TRB14","R"})
	aadd(aHeader, {"Saldo Disponivel","OSALDO"		,"@E 999,999,999.999999",16,6,"","","N","TRB14","R"})
	aadd(aHeader, {"Unidade"		,"OUM"			,""					,02,0,"","","C","TRB14","R"})
	aadd(aHeader, {"Previsao Ini."	,"ODATPRI"		,""					,08,0,"","","D","TRB14","R"})
	aadd(aHeader, {"Entrega"		,"OENTREG"		,""					,08,0,"","","D","TRB14","R"})
	aadd(aHeader, {"Emissao"		,"OEMISSA"		,""					,08,0,"","","D","TRB14","R"})
	aadd(aHeader, {"Contrato"		,"OITEMCTA"		,""					,13,0,"","","C","TRB14","R"})
	
	_oGetDbORDP := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3]-140),aPosObj[1,4], 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB14",,,,oFolder1:aDialogs[7])
	
	@ aPosObj[1,1]-30 , aPosObj[1,2] BUTTON 'Exportar Excel'         Size 60, 10 action(zExpOrdPr()) OF oFolder1:aDialogs[7] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+70 BUTTON 'Detalhes Geral'      Size 100, 10 action(zDetOPG()) of oFolder1:aDialogs[7] Pixel 
	
	//_oGetDbORDP:oBrowse:BlDblClick := 	{|| zDetOrdPr(aheader[_oGetDbORDP:oBrowse:ColPos(),2],aheader[_oGetDbORDP:oBrowse:ColPos(),1])  , _oGetDbORDP:ForceRefresh(), _oDlgSint:Refresh()  }
	_oGetDbORDP:oBrowse:BlDblClick := {|| zDetOrdPr()}
return

/**************** Exportacao Excel TRB14 Ordem de Produ��o ********************/

Static Function zExpOrdPr()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'ExpOrdPr.xml'
    
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}
        
    Local nX1		:= 1 
    
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
   
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#0000CD")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#E0FFFF")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    
    /*************** TRB13 ****************/  

	    cTabela 	:= "Ordem de Producao " + _cItemConta
	    cPasta		:= "Ordem de Producao " + _cItemConta 
	    
	    cORDPRD		:= "Ordem de Producao"			// 1
	    cOPRODUT	:= "Produto"					// 2
	    cODESCRI	:= "Descricao"					// 3
	    cOLOCAL		:= "Armazem"					// 4
	    cOQUANT		:= "Quantidade"					// 5
	    cOSALDO		:= "Saldo Disponivel"			// 6
	    cOUM		:= "Unidade"					// 7
	    cODATPRI	:= "Previsao Ini."				// 8
	    cOENTREG	:= "Entrega"					// 9
	    cOEMISSA	:= "Emissao"					// 10
	    //cOItemCTA	:= "Contrato"					// 11
	  	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cORDPRD)			// 1
        aAdd(aColunas, cOPRODUT)		// 2				
        aAdd(aColunas, cODESCRI)		// 3							
        aAdd(aColunas, cOLOCAL)			// 4				
        aAdd(aColunas, cOQUANT)			// 5
        aAdd(aColunas, cOSALDO)			// 6	
        aAdd(aColunas, cOUM)			// 7
        aAdd(aColunas, cODATPRI)		// 8
        aAdd(aColunas, cOENTREG)		// 9
        aAdd(aColunas, cOEMISSA)		// 10
        //aAdd(aColunas, cOItemCTA)		// 11
       
        oFWMsExcel:AddColumn(cTabela,cPasta, cORDPRD,1,2)					// 1 ordem de produ��o						
        oFWMsExcel:AddColumn(cTabela,cPasta, cOPRODUT,1,2)					// 2 produto			
        oFWMsExcel:AddColumn(cTabela,cPasta, cODESCRI,1,2)					// 3 descricao	
        oFWMsExcel:AddColumn(cTabela,cPasta, cOLOCAL,1,2)					// 4 local
        oFWMsExcel:AddColumn(cTabela,cPasta, cOQUANT,1,2)					// 5 quant
        oFWMsExcel:AddColumn(cTabela,cPasta, cOSALDO,1,2)					// 6 saldo
        oFWMsExcel:AddColumn(cTabela,cPasta, cOUM,1,2)						// 7 unidade
        oFWMsExcel:AddColumn(cTabela,cPasta, cODATPRI,1,2)					// 8 previsao inicial
        oFWMsExcel:AddColumn(cTabela,cPasta, cOENTREG,1,2)					// 9 previsao entrega
        oFWMsExcel:AddColumn(cTabela,cPasta, cOEMISSA,1,2)					// 10 data emissao
        //oFWMsExcel:AddColumn(cTabela,cPasta, cOItemCTA,1,2)					// 11 contrato	
       
        
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB14->(dbgotop())
	                            
        While  !(TRB14->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB14->ORDPRD
        	aLinhaAux[2] := TRB14->OPRODUT
        	aLinhaAux[3] := TRB14->ODESCRI
        	aLinhaAux[4] := TRB14->OLOCAL
        	aLinhaAux[5] := TRB14->OQUANT
        	aLinhaAux[6] := TRB14->OSALDO
        	aLinhaAux[7] := TRB14->OUM
        	aLinhaAux[8] := TRB14->ODATPRI
        	aLinhaAux[9] := TRB14->OENTREG
        	aLinhaAux[10] := TRB14->OEMISSA
        	//aLinhaAux[11] := TRB14->OITEMCTA
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#E0FFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	 
        	
            TRB14->(DbSkip())

        EndDo

        TRB14->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/********************* Detalhes Ordem de Produ��o ****************/

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zDetOrdPr()
local cFiltra 	:= ""
private aRotina := {{"Pesquisar" ,"AxPesqui" ,0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Detalhamento Ordem de Producao " +  alltrim(TRB14->OPRODUT) + " - " +  alltrim(TRB14->ODESCRI)

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra :=  "alltrim(DORDPRD) = '"  + alltrim(TRB14->ORDPRD) + "'"
//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
TRB15->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB15
aadd(aHeader, {"Ordem de Producao"		,"DORDPRD"	,""						,11,0,"","","C","TRB15","R"})
//aadd(aHeader, {"Produto"				,"DPRODUT1"	,""						,15,0,"","","C","TRB15","R"})
//aadd(aHeader, {"Descri��o"			,"DDESCRI1"	,""						,40,0,"","","C","TRB15","R"})
aadd(aHeader, {"Componente"				,"DPRODUT"	,""						,30,0,"","","C","TRB15","R"})
aadd(aHeader, {"Descricao"				,"DDESCRI"	,""						,80,0,"","","C","TRB15","R"})
aadd(aHeader, {"Armazem"				,"DLOCAL"	,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"Quantidade"				,"DQUANT"	,"@E 999,999,999.999999",16,2,"","","N","TRB15","R"})
aadd(aHeader, {"Quant.Entregue"			,"DQTDENT"	,"@E 999,999,999.999999",16,2,"","","N","TRB15","R"})
aadd(aHeader, {"Unidade"				,"DUM"		,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"Emissao"				,"DEMISSA"	,""						,08,0,"","","D","TRB15","R"})
aadd(aHeader, {"Tipo"					,"DTIPO"	,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"No.Solicitacao"			,"DNSOLIC"	,""						,06,0,"","","C","TRB15","R"})
aadd(aHeader, {"Contrato"				,"DITEMCTA"	,""						,13,0,"","","C","TRB15","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Detalhamento Ordem de Producao " + _cItemConta + " - " + alltrim(TRB14->OPRODUT) + " - " +  alltrim(TRB14->ODESCRI) From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB15")


@ aPosObj[2,1]+5 , aPosObj[2,2]+5 BUTTON 'Exportar Excel'         Size 60, 10 action(zExpDOrPr()) of _oDlgAnalit Pixel 

//aadd(aButton , { "BMPTABLE" , { || zExpExcGC2()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

//TRB15->(dbclearfil())

return

/**************** Exportacao Excel TRB15 Detalhes Ordem de Produ��o ********************/

Static Function zExpDOrPr()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'ExpDOrPr.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}   
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#0000CD")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#E0FFFF")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB15 ****************/  

	    cTabela 	:= "Detalhes Ordem de Producao " + _cItemConta
	    cPasta		:= "Detalhes Ordem de Producao " + _cItemConta 
	    
	    cDORDPRD	:= "Ordem de Producao"			// 1
	    cDPRODUT	:= "Produto"					// 2
	    cDDESCRI	:= "Descricao"					// 3
	    cDLOCAL		:= "Armazem"					// 4
	    cDQUANT		:= "Quantidade"					// 5
	    cDQTDENT	:= "Quant.Entregue"				// 6
	    cDUM		:= "Unidade"					// 7
	    cDEMISSA	:= "Emissao"					// 8
	    cDTIPO		:= "Tipo"						// 9
	    cDNSOLIC	:= "No.Solicitacao"				// 10
	     //cOItemCTA	:= "Contrato"					// 11
	  	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cDORDPRD)		// 1
        aAdd(aColunas, cDPRODUT)		// 2				
        aAdd(aColunas, cDDESCRI)		// 3							
        aAdd(aColunas, cDLOCAL)			// 4				
        aAdd(aColunas, cDQUANT)			// 5
        aAdd(aColunas, cDQTDENT)		// 6	
        aAdd(aColunas, cDUM)			// 7
        aAdd(aColunas, cDEMISSA)		// 8
        aAdd(aColunas, cDTIPO)			// 9
        aAdd(aColunas, cDNSOLIC)		// 10
        //aAdd(aColunas, cOItemCTA)		// 11
       
        oFWMsExcel:AddColumn(cTabela,cPasta, cDORDPRD,1,2)					// 1 ordem de produ��o						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDPRODUT,1,2)					// 2 produto			
        oFWMsExcel:AddColumn(cTabela,cPasta, cDDESCRI,1,2)					// 3 descricao	
        oFWMsExcel:AddColumn(cTabela,cPasta, cDLOCAL,1,2)					// 4 local
        oFWMsExcel:AddColumn(cTabela,cPasta, cDQUANT,1,2)					// 5 quant
        oFWMsExcel:AddColumn(cTabela,cPasta, cDQTDENT,1,2)					// 6 quant entregue
        oFWMsExcel:AddColumn(cTabela,cPasta, cDUM,1,2)						// 7 unidade
        oFWMsExcel:AddColumn(cTabela,cPasta, cDEMISSA,1,2)					// 8 previsao inicial
        oFWMsExcel:AddColumn(cTabela,cPasta, cDTIPO,1,2)					// 9 previsao entrega
        oFWMsExcel:AddColumn(cTabela,cPasta, cDNSOLIC,1,2)					// 10 data emissao
        //oFWMsExcel:AddColumn(cTabela,cPasta, cOItemCTA,1,2)					// 11 contrato	
          
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB15->(dbgotop())
	                            
        While  !(TRB15->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB15->DORDPRD
        	aLinhaAux[2] := TRB15->DPRODUT
        	aLinhaAux[3] := TRB15->DDESCRI
        	aLinhaAux[4] := TRB15->DLOCAL
        	aLinhaAux[5] := TRB15->DQUANT
        	aLinhaAux[6] := TRB15->DQTDENT
        	aLinhaAux[7] := TRB15->DUM
        	aLinhaAux[8] := TRB15->DEMISSA
        	aLinhaAux[9] := TRB15->DTIPO
        	aLinhaAux[10] := TRB15->DNSOLIC
        	//aLinhaAux[11] := TRB14->OITEMCTA
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#E0FFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	 
            TRB15->(DbSkip())

        EndDo

        TRB15->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return

/********************* Detalhes Geral Ordem de Produ��o ****************/
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function zDetOPG()
local cFiltra 	:= ""
private aRotina := {{"Pesquisar" ,"AxPesqui" ,0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Detalhamento Geral Ordem de Producao " + _cItemConta

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra :=  "alltrim(DITEMCTA) = '"  + alltrim(_cItemConta) + "'"
//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
TRB15->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB15
aadd(aHeader, {"Ordem de Producao"		,"DORDPRD"	,""						,11,0,"","","C","TRB15","R"})
aadd(aHeader, {"Produto"				,"DPRODUT1"	,""						,20,0,"","","C","TRB15","R"})
aadd(aHeader, {"Descricao"				,"DDESCRI1"	,""						,60,0,"","","C","TRB15","R"})
aadd(aHeader, {"Quantidade"				,"DQUANT1"	,"@E 999,999,999.999999",16,2,"","","N","TRB15","R"})
aadd(aHeader, {"Unidade"				,"DUM1"		,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"Componente"				,"DPRODUT"	,""						,30,0,"","","C","TRB15","R"})
aadd(aHeader, {"Descricao"				,"DDESCRI"	,""						,80,0,"","","C","TRB15","R"})
aadd(aHeader, {"Armazem"				,"DLOCAL"	,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"Quantidade"				,"DQUANT"	,"@E 999,999,999.999999",16,2,"","","N","TRB15","R"})
aadd(aHeader, {"Quant.Entregue"			,"DQTDENT"	,"@E 999,999,999.999999",16,2,"","","N","TRB15","R"})
aadd(aHeader, {"Unidade"				,"DUM"		,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"Emissao"				,"DEMISSA"	,""						,08,0,"","","D","TRB15","R"})
aadd(aHeader, {"Tipo"					,"DTIPO"	,""						,02,0,"","","C","TRB15","R"})
aadd(aHeader, {"No.Solicitacao"			,"DNSOLIC"	,""						,06,0,"","","C","TRB15","R"})
aadd(aHeader, {"Contrato"				,"DITEMCTA"	,""						,13,0,"","","C","TRB15","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Detalhamento Geral Ordem de Producao " + _cItemConta  From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB15")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 BUTTON 'Exportar Excel'         Size 60, 10 action(zExpDOPG()) of _oDlgAnalit Pixel 

//aadd(aButton , { "BMPTABLE" , { || zExpExcGC2()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

//TRB15->(dbclearfil())

return

/**************** Exportacao Excel TRB15 Detalhes Ordem de Produ��o ********************/

Static Function zExpDOPG()
    Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'ExpDOrPr.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local aColsMa	:= {}   
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMsExcelEx():New()
    Local nCL		:= 1
    Local cTabela	:= "" 
    Local cPasta	:= ""
	Local nAux
 
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#0000CD")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#E0FFFF")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
     
    /*************** TRB15 ****************/  

	    cTabela 	:= "Detalhes Ordem de Producao " + _cItemConta
	    cPasta		:= "Detalhes Ordem de Producao " + _cItemConta 
	    
	    cDORDPRD	:= "Ordem de Producao"			// 1
	    cDPRODUT1	:= "Produto"					// 2
	    cDDESCRI1	:= "Descricao"					// 3
	    cDQUANT1	:= "Quantidade"				// 4
	    cDUM1		:= "Unidade"					// 5
	    cDPRODUT	:= "Componente"					// 6
	    cDDESCRI	:= "Descricao"					// 7
	    cDLOCAL		:= "Armazem"					// 8
	    cDQUANT		:= "Quantidade"					// 9
	    cDQTDENT	:= "Quant.Entregue"				// 10
	    cDUM		:= "Unidade"					// 11
	    cDEMISSA	:= "Emissao"					// 12
	    cDTIPO		:= "Tipo"						// 13
	    cDNSOLIC	:= "No.Solicitacao"				// 14
	    cDItemCTA	:= "Contrato"					// 15
	  	
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet(cTabela) //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
    oFWMsExcel:AddTable(cTabela,cPasta)
         
    	aAdd(aColunas, cDORDPRD)		// 1
    	aAdd(aColunas, cDPRODUT1)		// 2				
        aAdd(aColunas, cDDESCRI1)		// 3
        aAdd(aColunas, cDQUANT1)		// 4
        aAdd(aColunas, cDUM1)			// 5
        aAdd(aColunas, cDPRODUT)		// 6				
        aAdd(aColunas, cDDESCRI)		// 7							
        aAdd(aColunas, cDLOCAL)			// 8				
        aAdd(aColunas, cDQUANT)			// 9
        aAdd(aColunas, cDQTDENT)		// 10	
        aAdd(aColunas, cDUM)			// 11
        aAdd(aColunas, cDEMISSA)		// 12
        aAdd(aColunas, cDTIPO)			// 13
        aAdd(aColunas, cDNSOLIC)		// 14
        aAdd(aColunas, cDItemCTA)		// 15
       
        oFWMsExcel:AddColumn(cTabela,cPasta, cDORDPRD,1,2)					// 1 ordem de produ��o	
        oFWMsExcel:AddColumn(cTabela,cPasta, cDPRODUT1,1,2)					// 2 produto			
        oFWMsExcel:AddColumn(cTabela,cPasta, cDDESCRI1,1,2)					// 3 descricao
        oFWMsExcel:AddColumn(cTabela,cPasta, cDQUANT1,1,2)					// 5 quant
        oFWMsExcel:AddColumn(cTabela,cPasta, cDUM1,1,2)						// 7 unidade						
        oFWMsExcel:AddColumn(cTabela,cPasta, cDPRODUT,1,2)					// 2 produto			
        oFWMsExcel:AddColumn(cTabela,cPasta, cDDESCRI,1,2)					// 3 descricao	
        oFWMsExcel:AddColumn(cTabela,cPasta, cDLOCAL,1,2)					// 4 local
        oFWMsExcel:AddColumn(cTabela,cPasta, cDQUANT,1,2)					// 5 quant
        oFWMsExcel:AddColumn(cTabela,cPasta, cDQTDENT,1,2)					// 6 quant entregue
        oFWMsExcel:AddColumn(cTabela,cPasta, cDUM,1,2)						// 7 unidade
        oFWMsExcel:AddColumn(cTabela,cPasta, cDEMISSA,1,2)					// 8 previsao inicial
        oFWMsExcel:AddColumn(cTabela,cPasta, cDTIPO,1,2)					// 9 previsao entrega
        oFWMsExcel:AddColumn(cTabela,cPasta, cDNSOLIC,1,2)					// 10 data emissao
        oFWMsExcel:AddColumn(cTabela,cPasta, cDItemCTA,1,2)					// 11 contrato	
          
    For nAux := 1 To Len(aColunas)
         aAdd(aColsMa,  nX1 )
         nX1++
    Next
        
        TRB15->(dbgotop())
	                            
        While  !(TRB15->(EoF()))
                
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB15->DORDPRD
        	aLinhaAux[2] := TRB15->DPRODUT1
        	aLinhaAux[3] := TRB15->DDESCRI1
        	aLinhaAux[4] := TRB15->DQUANT1
        	aLinhaAux[5] := TRB15->DUM1
        	aLinhaAux[6] := TRB15->DPRODUT
        	aLinhaAux[7] := TRB15->DDESCRI
        	aLinhaAux[8] := TRB15->DLOCAL
        	aLinhaAux[9] := TRB15->DQUANT
        	aLinhaAux[10] := TRB15->DQTDENT
        	aLinhaAux[11] := TRB15->DUM
        	aLinhaAux[12] := TRB15->DEMISSA
        	aLinhaAux[13] := TRB15->DTIPO
        	aLinhaAux[14] := TRB15->DNSOLIC
        	aLinhaAux[15] := TRB15->DITEMCTA
    
	        	if nCL	== 1
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#E0FFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 2
	        	elseif nCL	== 2
	            	oFWMsExcel:SetCelBold(.F.)	
	            	oFWMsExcel:SetCelBgColor("#FFFFFF")
	        		oFWMsExcel:AddRow(cTabela,cPasta, aLinhaAux,aColsMa)
	        		nCL		:= 1
	        	endif
	 
            TRB15->(DbSkip())

        EndDo

        TRB15->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

    RestArea(aArea)

Return



/******************* Tela CUSTOS ************************/

static function zTelaCustos()

	// Monta aHeader do TRB2
	//aadd(aHeader, {"OK","OK","",01,0,"","","C","TRB2","R","","",".F.","V"})
	aadd(aHeader, {" ID"				,"IDUSA"		,""					,03,0,"","","C","TRB2","R"})
	aadd(aHeader, {" Descricao"			,"DESCUSA"		,""					,40,0,"","","C","TRB2","R"})
	//aadd(aHeader, {" Grupo"				,"GRUPO"		,""					,20,0,"","","C","TRB2","R"})
	//aadd(aHeader, {"Descricao"			,"DESCRICAO"	,""					,30,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Vlr. Vendido"		,"VLRVD"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"% Vendido"			,"PERVD"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Vlr. Planejado"		,"VLRPLN"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"% Planejado"		,"PERPLN"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Vlr. Realizado"		,"VLREMP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"% Realizado"		,"PEREMP"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	//aadd(aHeader, {"Saldo","VLRSLD","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	//aadd(aHeader, {"% Saldo","PERSLD","@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Contabilizado"		,"VLRCTB"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"% Contabilizado"	,"PERCTB"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Contabil Estoque"	,"VLRCTBE"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"% Contabil Estoque"	,"PERCTBE"		,"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	//aadd(aHeader, {"ID"					,"ID"			,""					,5,0,"","","C","TRB2","R"})
	
	_oGetDbSint := MsGetDb():New(aPosObj[1,1]-30,aPosObj[1,2],aPosObj[1,3]-140,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2",,,,oFolder1:aDialogs[1])

	_oGetDbSint::oBrowse:BlDblClick := 	{|| ShowAnalit(aheader[_oGetDbSint:oBrowse:ColPos(),2],aheader[_oGetDbSint:oBrowse:ColPos(),1])  , _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()  }
	
	// COR DA FONTE
	_oGetDbSint:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
	// COR DA LINHA
	_oGetDbSint:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha

return

Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  
   	  //if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	    	 
    endif
   
   if nIOpcao == 2 // Cor da Fonte
   	  //if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	  if ALLTRIM(TRB2->DESCUSA) ==  "CUSTO PRODUCAO"; _cCor := CLR_YELLOW ; endif
	  if ALLTRIM(TRB2->DESCUSA) ==  "CUSTO TOTAL (COGS)"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB2->DESCUSA) ==  "CUSTO TOTAL"; _cCor := CLR_YELLOW ; endif
   	  if ALLTRIM(TRB2->DESCUSA) ==  "MARGEM BRUTA"; _cCor := CLR_HGREEN  ; endif
   	  if ALLTRIM(TRB2->DESCUSA) ==  "MARGEM CONTRIB."; _cCor := CLR_HGREEN ; endif
   	  
   	  if ALLTRIM(TRB2->DESCUSA) ==  "COGS"; _cCor := CLR_HCYAN ; endif
   	  
   	  if ALLTRIM(TRB2->IDUSA) ==  "100"; _cCor := CLR_HCYAN ; endif
   	  if ALLTRIM(TRB2->IDUSA) ==  "199"; _cCor := CLR_HCYAN ; endif
   	  if ALLTRIM(TRB2->IDUSA) ==  "209"; _cCor := CLR_HCYAN ; endif
   	  if ALLTRIM(TRB2->IDUSA) ==  "299"; _cCor := CLR_HCYAN ; endif
          //if ALLTRIM(TRB2->GRUPO) ==  "9.ZZ.18"; _cCor := CLR_HGREEN ; endif
	 	  
    endif
Return _cCor
/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function ShowAnalit(_cCampo)
local cFiltra 	:= ""


private aRotina := {{"Pesquisar" ,"AxPesqui" ,0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Analitico - " + _cItemConta

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
if ALLTRIM(_cCampo) == "PEREMP" .or. ALLTRIM(_cCampo) == "PERVD" .OR. ALLTRIM(_cCampo) == "PERPLN" .OR. ALLTRIM(_cCampo) == "VLRSLD" .OR. ALLTRIM(_cCampo) == "PERSLD" .OR.;
	ALLTRIM(_cCampo) == "PERCTB" .OR. ALLTRIM(_cCampo) == "PERCTBE" .OR. ALLTRIM(_cCampo) == "IDUSA"
	return
endif

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra :=  " ALLTRIM(CAMPO) == '" + alltrim(_cCampo) + "' .and. TRB1->IDUSA == '"  + alltrim(TRB2->IDUSA) + "' .and. TRB1->ITEMCONTA == '" + _cItemConta + "' "
//cFiltra :=  "TRB1->ID == '"  + alltrim(TRB2->ID) + "' .and. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB1
aadd(aHeader, {"ID"				,"IDUSA"	,"",03,0,"","","C","TRB1","R"})

aadd(aHeader, {"Grupo Prod."	,"GRPROD"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data"			,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Data Entrega"	,"DATAENT"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Origem"			,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})

If alltrim(_cCampo) == "VLREMP" .OR. alltrim(_cCampo) == "VLRPLN" .OR. alltrim(_cCampo) == "VLRVD"
	aadd(aHeader, {"Tipo"			,"TIPO"	,"",03,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Numero"			,"NUMERO"	,"",15,0,"","","C","TRB1","R"})
endif

If alltrim(_cCampo) == "VLRCTB" .or. alltrim(_cCampo) == "VLRCTBE"
	aadd(aHeader, {"Conta"		,"CONTA"		,"",15,0,"","","C","TRB1","R"})
Endif

If alltrim(_cCampo) == "VLREMP" .OR. alltrim(_cCampo) == "VLRPLN" .OR. alltrim(_cCampo) == "VLRVD"
	aadd(aHeader, {"Produto"		,"Produto"	,"",30,0,"","","C","TRB1","R"})
Endif

aadd(aHeader, {"Historico"		,"HISTORICO","",100,0,"","","C","TRB1","R"})

If alltrim(_cCampo) == "VLRCTB" .or. alltrim(_cCampo) == "VLRCTBE"
	aadd(aHeader, {"Vlr.Debito"	,"VDEBITO"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Credito","VCREDITO"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Saldo"	,"VSALDO"		,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
Endif

If alltrim(_cCampo) == "VLREMP" .OR. alltrim(_cCampo) == "VLRPLN" .OR. alltrim(_cCampo) == "VLRVD"
	aadd(aHeader, {"Quantidade"		,"QUANTIDADE","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Unid."			,"UNIDADE","",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Vlr.s/Tributos"	,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.c/Tributos"	,"VALOR2","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Cod.Forn."		,"CODFORN","",15,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Fornecedor"		,"FORNECEDOR","",60,0,"","","C","TRB1","R"})
	aadd(aHeader, {"CFOP"			,"CFOP","",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Natureza"		,"NATUREZA","",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Descricao Natureza"	,"DNATUREZA","",60,0,"","","C","TRB1","R"})
endif

aadd(aHeader, {"Item Conta"		,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao"		,"DESCUSA"	,"",40,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"				,"ID"		,"",03,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Descri��o ID"	,"DESCRICAO","",40,0,"","","C","TRB1","R"})
aadd(aHeader, {"Campo"			,"CAMPO"		,"",10,0,"","","C","TRB1","R"})

//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Analitico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL


aadd(aButton , { "BMPTABLE" , { || zExpExcGC2()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCdet()}, "Imprimir " } )

_oGetDbAnalit:oBrowse:BlDblClick := {|| zERegSC7() }


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

Static Function zERegSC7()
    Local aArea       := GetArea()
    Local aAreaC7     := SC7->(GetArea())
    Local nOpcao      := 0
    Local cNumero	  := alltrim(TRB1->NUMERO)
    Local cOrigem	  := TRB1->ORIGEM
	Local cProduto  := TRB1->PRODUTO
   
    Private cCadastro 

	IF cOrigem = "OC"  

		cCadastro := "Alteracao Ordem de Compra"
		
		DbSelectArea("SC7")
		SC7->(DbSetOrder(4)) //B1_FILIAL + B1_COD
				
		//Se conseguir posicionar no produto
		If SC7->(DbSeek(xFilial('SC7')+cProduto+cNumero))
				
			nOpcao := fARegSC7()
			If nOpcao == 1
				MsgInfo("Rotina confirmada", "Atencao")
			EndIf
			
		EndIf
	else
		MsgInfo("N�o � poss�vel alterar registro.", "Atencao")
	endif
   
    RestArea(aAreaC7)
    RestArea(aArea)
Return

static Function fARegSC7()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SC7->C7_NUM
Local oGet2
//Local cGet2 := Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA, "A2_NREDUZ")
Local oGet3
Local dVencto := SC7->C7_DATPRF
Local oGet4
Local oGet5	
Local oGet6	
Local cProduto := SC7->C7_PRODUTO
Local cGet2 := SC7->C7_DESCRI

Local cItem := SC7->C7_ITEM
Local nQuant := TRB1->QUANTIDADE
Local nValor := TRB1->VALOR
Local nValor2 := TRB1->VALOR2
Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4

Local _nOpc := 0
Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Alterar Data de Entrega Ordem de Compra" FROM 000, 000  TO 200, 590 COLORS 0, 16777215 PIXEL

    @ 006, 008 MSPANEL oPanel1 PROMPT "" SIZE 278, 088 OF _oDlg COLORS 0, 16777215 RAISED
    @ 000, 002 MSPANEL oPanel2 SIZE 268, 086 OF oPanel1 COLORS 0, 16777215 LOWERED
    @ 007, 006 SAY oSay1 PROMPT "Numero OC" SIZE 020, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 007, 063 SAY oSay2 PROMPT "Produto" SIZE 032, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 038, 006 SAY oSay3 PROMPT "Data Entrega" SIZE 050, 007 OF oPanel2 COLORS 0, 16777215 PIXEL
    
	@ 038, 063 SAY oSay4 PROMPT "Quantidade " SIZE 030, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 038, 133 SAY oSay4 PROMPT "Vlr.s/Tributos " SIZE 050, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 038, 203 SAY oSay4 PROMPT "Vlr.c/Tributos" SIZE 050, 030 OF oPanel2 COLORS 0, 16777215 PIXEL
    
	@ 016, 004 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 016, 061 MSGET oGet2 VAR cGet2 When .F. SIZE 200, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 049, 004 MSGET oGet3 VAR dVencto SIZE 044, 010 OF oPanel2 COLORS 0, 16777215 PIXEL

	@ 049, 061 MSGET oGet2 VAR  Transform(nQuant,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
   	@ 049, 131 MSGET oGet2 VAR  Transform(nValor,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
	@ 049, 201 MSGET oGet2 VAR  Transform(nValor2,"@E 99,999,999.99") When .F. SIZE 60, 010 OF oPanel2 COLORS 0, 16777215 PIXEL

    @ 073, 089 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL
    @ 073, 137 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 OF oPanel2 PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

  If _nOpc = 1

	Reclock("TRB1",.F.)
	  		TRB1->DATAENT	:=  DataValida(dVencto,.T.)
	MsUnlock()
  	
  	DbSelectArea("SC7")
	SC7->(DbSetOrder(4)) //B1_FILIAL + B1_COD
	
  	If SC7->(DbSeek(xFilial('SC7')+cProduto+cGet1+cItem))
  			Reclock("SC7",.F.)
		  	SC7->C7_DATPRF := DataValida(dVencto,.T.) //Proximo dia �til
		  	MsUnlock()	
	EndIf
  	
  Endif

Return _nOpc


Static Function zExpExcGC01()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC1.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMSExcelEx():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
	Local nAux
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#000080")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FFFAF0")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta)
        
        aAdd(aColunas, "ID" )								// 1 Grupo
        aAdd(aColunas, "Descricao")								// 2 Descri��o
        aAdd(aColunas, "Vlr.Vendido")							// 3 Vlr.Vendido
        aAdd(aColunas, "% Vendido")								// 4 % Vendido
        aAdd(aColunas, "Vlr.Planejado")							// 5 Vlr.Planejado
        aAdd(aColunas, "% Planejado")							// 6 % Planejado
        aAdd(aColunas, "Vlr.Realizado")							// 7 Vlr.Empenhado
        aAdd(aColunas, "% Realizado")							// 8 Vlr.Empenhado
        aAdd(aColunas, "Contabilizado")							// 9 Contabilizado
        aAdd(aColunas, "% Contabilizado")						// 10 % Contabilizado
        aAdd(aColunas, "Contabil Estoque")						// 11 Cont�bil Estoque
        aAdd(aColunas, "% Contabil Estoque")					// 12 % Cont�bil Estoque
      
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "ID" + SPACE(10),1,2)						// 1 Grupo
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Descricao" + SPACE(20),1,2)					// 2 Descri��o
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Vlr.Vendido" + SPACE(5),1,2)					// 3 Vlr.Vendido
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "% Vendido" + SPACE(5),1,2)						// 4 % Vendido
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Vlr.Planejado" + SPACE(5),1,2)					// 5 Vlr.Planejado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "% Planejado" + SPACE(5),1,2)					// 6 % Planejado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Vlr.Realizado" + SPACE(5),1,2)					// 7 Vlr.Empenhado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "% Realizado" + SPACE(5),1,2)					// 8 % Empenhado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Contabilizado" + SPACE(5),1,2)					// 9 Contabilizado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "% Contabilizado" + SPACE(5),1,2)				// 10 % Contabilizado
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "Contabil Estoque" + SPACE(5),1,2)				// 11 Cont�bil Estoque
        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, "% Contabil Estoque" + SPACE(5),1,2)			// 12 % Cont�bil Estoque
        
        For nAux := 1 To Len(aColunas)
            aAdd(aColsMa,  nX1 )
            nX1++
        Next

		TRB2->(dbgotop())

        While  !(TRB2->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->IDUSA
        	aLinhaAux[2] := TRB2->DESCUSA
        	aLinhaAux[3] := TRB2->VLRVD
        	aLinhaAux[4] := TRB2->PERVD
        	aLinhaAux[5] := TRB2->VLRPLN
        	aLinhaAux[6] := TRB2->PERPLN
        	aLinhaAux[7] := TRB2->VLREMP
        	aLinhaAux[8] := TRB2->PEREMP
        	aLinhaAux[9] := TRB2->VLRCTB
        	aLinhaAux[10] := TRB2->PERCTB
        	aLinhaAux[11] := TRB2->VLRCTBE
        	aLinhaAux[12] := TRB2->VLRCTBE
        	       	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        	
        	if alltrim(aLinhaAux[1]) $ "100/199/209/299/000/999" 
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#4169E1")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, aLinhaAux,aColsMa)
                    	
            elseif alltrim(aLinhaAux[1]) $ "101/103/105/107/109/201/204/206/210/212/217/220/222/301/601/801/803/805/908" 
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, aLinhaAux,aColsMa) 
            	
            elseif alltrim(aLinhaAux[1]) $ "102/104/106/108/202/206/211/213/218/221/501/701/802/804/806" 
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFAF0")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Sintetico - "  + _cItemConta, aLinhaAux,aColsMa)	
        
            //else	
        		//oFWMsExcel:AddRow("Gest�o de Contratos","Gest�o de Contratos - Sint�tico - "  + _cItemConta, aLinhaAux,aColsMa)
            endif
            TRB2->(DbSkip())

        EndDo

        TRB2->(dbgotop())
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

Return

Static Function zExpExcGC2()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC2.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta)
        
        If alltrim(TRB1->CAMPO) == "VLREMP" .OR. alltrim(TRB1->CAMPO) == "VLRPLN" .OR. alltrim(TRB1->CAMPO) == "VLRVD"
        
	        aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Tipo")	 							// 3 Tipo
		    aAdd(aColunas, "Numero")							// 4 Numero
		    aAdd(aColunas, "Produto")							// 5 Produto
		    aAdd(aColunas, "Historico")							// 6 Historico
		    aAdd(aColunas, "Quantidade")						// 7 Quantidade
		    aAdd(aColunas, "Unid.")								// 8 Unid.
		    aAdd(aColunas, "Vlr.s/Tributos")					// 9 Vlr.s/Tributos
		    aAdd(aColunas, "Vlr.c/Tributos")					// 10 Vlr.c/Tributos
		    aAdd(aColunas, "Cod.Forn.")							// 11 Cod.Forn.
		    aAdd(aColunas, "Fornecedor")						// 12 Fornecedor
		    aAdd(aColunas, "CFOP")								// 13 CFOP
		    aAdd(aColunas, "Natureza")							// 14 Natureza
		    aAdd(aColunas, "Descricao Natureza")				// 15 Descricao Natureza
		    //aAdd(aColunas, "Item Conta")						// 16 Item Conta
		    aAdd(aColunas, "Id")								// 17 Id
		    aAdd(aColunas, "Descricao Id")						// 18 Descricao Id
		    //aAdd(aColunas, "Campo")								// 19 Campo
		    	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Tipo" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Numero" + SPACE(5),1,2)	 
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Produto" + SPACE(5),1,2)   
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Historico" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Quantidade" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Unid." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Vlr.s/Tributos" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Vlr.c/Tributos" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Cod.Forn." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Fornecedor" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "CFOP" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Natureza" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Descricao Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Campo" + SPACE(10),1,2)
		                     

	        While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[2] := TRB1->ORIGEM
	        	aLinhaAux[3] := TRB1->TIPO
		        aLinhaAux[4] := TRB1->NUMERO
		        aLinhaAux[5] := TRB1->PRODUTO
			    aLinhaAux[6] := TRB1->HISTORICO
			    aLinhaAux[7] := TRB1->QUANTIDADE
			    aLinhaAux[8] := TRB1->UNIDADE
			    aLinhaAux[9] := TRB1->VALOR
			    aLinhaAux[10] := TRB1->VALOR2
			    aLinhaAux[11] := TRB1->CODFORN
			    aLinhaAux[12] := TRB1->FORNECEDOR
			    aLinhaAux[13] := TRB1->CFOP
			    aLinhaAux[14] := TRB1->NATUREZA
			    aLinhaAux[15] := TRB1->DNATUREZA
			    //aLinhaAux[16] := TRB1->ITEMCONTA
			    aLinhaAux[16] := TRB1->IDUSA
			    aLinhaAux[17] := TRB1->DESCUSA
			    //aLinhaAux[19] := TRB1->CAMPO
						    
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, aLinhaAux)
	        	
	            TRB1->(DbSkip())
	
	        EndDo

        endif
        
        If alltrim(TRB1->CAMPO) == "VLRCTB" .or. alltrim(TRB1->CAMPO) == "VLRCTBE"
        
        	aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Conta")								// 3 Conta
	        aAdd(aColunas, "Historico")							// 4 Historico
	        aAdd(aColunas, "Vlr.Debito")						// 5 Vlr.Debito
	        aAdd(aColunas, "Vlr.Credito")						// 6 Vlr.Credito
	        aAdd(aColunas, "Vlr.Saldo")							// 7 Vlr.Saldo
	        //aAdd(aColunas, "Item Conta")						// 8 Item Conta
		    aAdd(aColunas, "Id")								// 9 Id
		    aAdd(aColunas, "Descricao Id")						// 10 Descricao Id
		    //aAdd(aColunas, "Campo")								// 11 Campo
	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Data",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Origem",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Conta",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Historico",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Vlr.Debito",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Vlr.Credito",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Vlr.Saldo",1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Item Conta",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Id",1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Descricao Id",1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, "Campo",1,2)
		    
		     While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[2] := TRB1->ORIGEM
	        	aLinhaAux[3] := TRB1->CONTA
	        	aLinhaAux[4] := TRB1->HISTORICO
	        	aLinhaAux[5] := TRB1->VDEBITO
	        	aLinhaAux[6] := TRB1->VCREDITO
	        	aLinhaAux[7] := TRB1->VSALDO
	        	//aLinhaAux[8] := TRB1->ITEMCONTA
			    aLinhaAux[8] := TRB1->IDSUSA
			    aLinhaAux[9] := TRB1->DESCUSA
			    //aLinhaAux[11] := TRB1->CAMPO
	        
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Analitico - " + _cItemConta, aLinhaAux)
	        
	            TRB1->(DbSkip())
	
	        EndDo
        endif
        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return

/*
�����������������������������������������������������������������������������
��������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function AnaliticoFull(_cCampo)
local cFiltra 	:= ""

private aRotina := {{"Pesquisar" ,"AxPesqui" ,0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo2   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo2, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Realizado Analitico - " + _cItemConta

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada


// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLREMP' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB1
aadd(aHeader, {"ID"				,"IDUSA"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data"			,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Origem"			,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Numero"			,"NUMERO"	,"",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"			,"TIPO"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Produto"		,"Produto"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Historico"		,"HISTORICO","",140,0,"","","C","TRB1","R"})
aadd(aHeader, {"Quantidade"		,"QUANTIDADE","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Unid."			,"UNIDADE","",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.s/Tributos"	,"VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.c/Tributos"	,"VALOR2","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Cod.Forn."		,"CODFORN","",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Fornecedor"		,"FORNECEDOR","",60,0,"","","C","TRB1","R"})
aadd(aHeader, {"CFOP"			,"CFOP","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Natureza"		,"NATUREZA","",13,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao Natureza"	,"DNATUREZA","",60,0,"","","C","TRB1","R"})
aadd(aHeader, {"Item Conta"		,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"				,"ID"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao"		,"DESCUSA"	,"",40,0,"","","C","TRB1","R"})
//aadd(aHeader, {"Descri��o ID"	,"DESCRICAO","",40,0,"","","C","TRB1","R"})
aadd(aHeader, {"Campo"			,"CAMPO"		,"",10,0,"","","C","TRB1","R"})


//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Realizado Analitico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada  / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , { || zExpExcGC3()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || zGCRel01()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())
return

Static Function zExpExcGC3()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC3.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta)
        
	        aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Tipo")	 							// 3 Tipo
		    aAdd(aColunas, "Numero")							// 4 Numero
		    aAdd(aColunas, "Produto")							// 5 Produto
		    aAdd(aColunas, "Historico")							// 6 Historico
		    aAdd(aColunas, "Quantidade")						// 7 Quantidade
		    aAdd(aColunas, "Unid.")								// 8 Unid.
		    aAdd(aColunas, "Vlr.s/Tributos")					// 9 Vlr.s/Tributos
		    aAdd(aColunas, "Vlr.c/Tributos")					// 10 Vlr.c/Tributos
		    aAdd(aColunas, "Cod.Forn.")							// 11 Cod.Forn.
		    aAdd(aColunas, "Fornecedor")						// 12 Fornecedor
		    aAdd(aColunas, "CFOP")								// 13 CFOP
		    aAdd(aColunas, "Natureza")							// 14 Natureza
		    aAdd(aColunas, "Descricao Natureza")				// 15 Descricao Natureza
		    //aAdd(aColunas, "Item Conta")						// 16 Item Conta
		    aAdd(aColunas, "Id")								// 17 Id
		    aAdd(aColunas, "Descricao Id")						// 18 Descricao Id
		    //aAdd(aColunas, "Campo")								// 19 Campo
		    	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Tipo" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Numero" + SPACE(5),1,2)	 
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Produto" + SPACE(5),1,2)   
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Historico" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Quantidade" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Unid." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Vlr.s/Tributos" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Vlr.c/Tributos" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Cod.Forn." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Fornecedor" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "CFOP" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Natureza" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Descricao Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, "Campo" + SPACE(10),1,2)
		                     
	        While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[2] := TRB1->ORIGEM
	        	aLinhaAux[3] := TRB1->TIPO
		        aLinhaAux[4] := TRB1->NUMERO
		        aLinhaAux[5] := TRB1->PRODUTO
			    aLinhaAux[6] := TRB1->HISTORICO
			    aLinhaAux[7] := TRB1->QUANTIDADE
			    aLinhaAux[8] := TRB1->UNIDADE
			    aLinhaAux[9] := TRB1->VALOR
			    aLinhaAux[10] := TRB1->VALOR2
			    aLinhaAux[11] := TRB1->CODFORN
			    aLinhaAux[12] := TRB1->FORNECEDOR
			    aLinhaAux[13] := TRB1->CFOP
			    aLinhaAux[14] := TRB1->NATUREZA
			    aLinhaAux[15] := TRB1->DNATUREZA
			    //aLinhaAux[16] := TRB1->ITEMCONTA
			    aLinhaAux[16] := TRB1->IDUSA
			    aLinhaAux[17] := TRB1->DESCUSA
			    //aLinhaAux[19] := TRB1->CAMPO
						    
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Realizado Analitico - " + _cItemConta, aLinhaAux)
	        	
	            TRB1->(DbSkip())
	
	        EndDo

        TRB1->(dbgotop())
   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ShowAnalit�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function VendidoFull()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo2   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo2, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Vendido Analitico - " + _cItemConta 

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada


// Monta filtro no TRB6 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLRVD' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB6
aadd(aHeader, {"ID"			,"IDUSA"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPO"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Numero"		,"NUMERO"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Produto"	,"Produto"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Historico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Quantidade"	,"QUANT"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Unid."		,"UNIDADE"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.s/Tributos","VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"			,"ID"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao ID","DESCUSA","",40,0,"","","C","TRB1","R"})


DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Vendido Analitico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , { || zExpExcGC4()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCvd()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())
return


Static Function zExpExcGC4()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC4.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta)
        
	        //aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Tipo")	 							// 3 Tipo
		    aAdd(aColunas, "Numero")							// 4 Numero
		    //aAdd(aColunas, "Produto")							// 5 Produto
		    aAdd(aColunas, "Historico")							// 6 Historico
		    aAdd(aColunas, "Quantidade")						// 7 Quantidade
		    aAdd(aColunas, "Unid.")								// 8 Unid.
		    aAdd(aColunas, "Vlr.s/Tributos")					// 9 Vlr.s/Tributos
		    //aAdd(aColunas, "Vlr.c/Tributos")					// 10 Vlr.c/Tributos
		    //aAdd(aColunas, "Cod.Forn.")							// 11 Cod.Forn.
		    //aAdd(aColunas, "Fornecedor")						// 12 Fornecedor
		    //aAdd(aColunas, "CFOP")								// 13 CFOP
		    //aAdd(aColunas, "Natureza")							// 14 Natureza
		    //aAdd(aColunas, "Descricao Natureza")				// 15 Descricao Natureza
		    //aAdd(aColunas, "Item Conta")						// 16 Item Conta
		    aAdd(aColunas, "Id")								// 17 Id
		    aAdd(aColunas, "Descricao Id")						// 18 Descricao Id
		    //aAdd(aColunas, "Campo")								// 19 Campo
		    	        
	        //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Tipo" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Numero" + SPACE(5),1,2)	 
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Produto" + SPACE(5),1,2)   
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Historico" + SPACE(20),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Quantidade" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Unid." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Vlr.s/Tributos" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Vlr.c/Tributos" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Cod.Forn." + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Fornecedor" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "CFOP" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Descricao Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, "Campo" + SPACE(10),1,2)
		                     
	        While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	//aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[1] := TRB1->ORIGEM
	        	aLinhaAux[2] := TRB1->TIPO
		        aLinhaAux[3] := TRB1->NUMERO
		        //aLinhaAux[5] := TRB1->PRODUTO
			    aLinhaAux[4] := TRB1->HISTORICO
			    aLinhaAux[5] := TRB1->QUANTIDADE
			    aLinhaAux[6] := TRB1->UNIDADE
			    aLinhaAux[7] := TRB1->VALOR
			    //aLinhaAux[10] := TRB1->VALOR2
			    //aLinhaAux[11] := TRB1->CODFORN
			    //aLinhaAux[12] := TRB1->FORNECEDOR
			    //aLinhaAux[13] := TRB1->CFOP
			    //aLinhaAux[14] := TRB1->NATUREZA
			    //aLinhaAux[15] := TRB1->DNATUREZA
			    //aLinhaAux[16] := TRB1->ITEMCONTA
			    aLinhaAux[8] := TRB1->IDUSA
			    aLinhaAux[9] := TRB1->DESCUSA
			    //aLinhaAux[19] := TRB1->CAMPO
						    
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Vendido Analitico - " + _cItemConta, aLinhaAux)
	        	
	            TRB1->(DbSkip())
	
	        EndDo

        TRB1->(dbgotop())
   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ShowAnalit�Autor  �Marcos Zanetti GZ   � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function PlanejadoFull()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo2   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo2, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Planejamento Analitico - " + _cItemConta

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada


// Monta filtro no TRB6 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLRPLN' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB6
aadd(aHeader, {"ID"			,"IDUSA"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Tipo"		,"TIPO"	,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Numero"		,"NUMERO"	,"",20,0,"","","C","TRB1","R"})
aadd(aHeader, {"Produto"	,"Produto"	,"",30,0,"","","C","TRB1","R"})
aadd(aHeader, {"Historico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Quantidade"	,"QUANT","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Unid."		,"UNIDADE","",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.s/Tributos","VALOR"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"			,"IDUSA"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao ID","DESCUSA","",40,0,"","","C","TRB1","R"})


DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Planejamento Analitico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

aadd(aButton , { "BMPTABLE" , { || zExpExcGC5()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCpl()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())
return

Static Function zExpExcGC5()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC5.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta)
        
	        //aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Tipo")	 							// 3 Tipo
		    aAdd(aColunas, "Numero")							// 4 Numero
		    //aAdd(aColunas, "Produto")							// 5 Produto
		    aAdd(aColunas, "Historico")							// 6 Historico
		    aAdd(aColunas, "Quantidade")						// 7 Quantidade
		    aAdd(aColunas, "Unid.")								// 8 Unid.
		    aAdd(aColunas, "Vlr.s/Tributos")					// 9 Vlr.s/Tributos
		    //aAdd(aColunas, "Vlr.c/Tributos")					// 10 Vlr.c/Tributos
		    //aAdd(aColunas, "Cod.Forn.")							// 11 Cod.Forn.
		    //aAdd(aColunas, "Fornecedor")						// 12 Fornecedor
		    //aAdd(aColunas, "CFOP")								// 13 CFOP
		    //aAdd(aColunas, "Natureza")							// 14 Natureza
		    //aAdd(aColunas, "Descricao Natureza")				// 15 Descricao Natureza
		    //aAdd(aColunas, "Item Conta")						// 16 Item Conta
		    aAdd(aColunas, "Id")								// 17 Id
		    aAdd(aColunas, "Descricao Id")						// 18 Descricao Id
		    //aAdd(aColunas, "Campo")								// 19 Campo
		    	        
	        //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Tipo" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Numero" + SPACE(5),1,2)	 
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Produto" + SPACE(5),1,2)   
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Historico" + SPACE(20),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Quantidade" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Unid." + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Vlr.s/Tributos" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Vlr.c/Tributos" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Cod.Forn." + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Fornecedor" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "CFOP" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Descricao Natureza" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, "Campo" + SPACE(10),1,2)
		                     
	        While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	//aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[1] := TRB1->ORIGEM
	        	aLinhaAux[2] := TRB1->TIPO
		        aLinhaAux[3] := TRB1->NUMERO
		        //aLinhaAux[5] := TRB1->PRODUTO
			    aLinhaAux[4] := TRB1->HISTORICO
			    aLinhaAux[5] := TRB1->QUANTIDADE
			    aLinhaAux[6] := TRB1->UNIDADE
			    aLinhaAux[7] := TRB1->VALOR
			    //aLinhaAux[10] := TRB1->VALOR2
			    //aLinhaAux[11] := TRB1->CODFORN
			    //aLinhaAux[12] := TRB1->FORNECEDOR
			    //aLinhaAux[13] := TRB1->CFOP
			    //aLinhaAux[14] := TRB1->NATUREZA
			    //aLinhaAux[15] := TRB1->DNATUREZA
			    //aLinhaAux[16] := TRB1->ITEMCONTA
			    aLinhaAux[8] := TRB1->IDUSA
			    aLinhaAux[9] := TRB1->DESCUSA
			    //aLinhaAux[19] := TRB1->CAMPO
						    
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Planejamento Analitico - " + _cItemConta, aLinhaAux)
	        	
	            TRB1->(DbSkip())
	
	        EndDo

        TRB1->(dbgotop())
   
     
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function ContabilFull()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro := "Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->ID) .and. !empty(TRB2->ID))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLRCTB' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB3
//monta arquivo analitico TRB3
aadd(aHeader, {"ID"			,"IDUSA"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Conta"		,"CONTA"	,"",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Historico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.Debito"	,"VDEBITO"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.Credito","VCREDITO","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.Saldo"	,"VSALDO"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"			,"ID"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao ID","DESCUSA","",40,0,"","","C","TRB1","R"})

//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula��o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula��o" } )
aadd(aButton , { "BMPTABLE" , { || zExpExcGC6()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || zGCRel02()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

Static Function zExpExcGC6()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC6.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta)
        
           	aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Conta")								// 3 Conta
	        aAdd(aColunas, "Historico")							// 4 Historico
	        aAdd(aColunas, "Vlr.Debito")						// 5 Vlr.Debito
	        aAdd(aColunas, "Vlr.Credito")						// 6 Vlr.Credito
	        aAdd(aColunas, "Vlr.Saldo")							// 7 Vlr.Saldo
	        //aAdd(aColunas, "Item Conta")						// 8 Item Conta
		    aAdd(aColunas, "Id")								// 9 Id
		    aAdd(aColunas, "Descricao Id")						// 10 Descricao Id
		    //aAdd(aColunas, "Campo")								// 11 Campo
	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Historico" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Vlr.Debito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Vlr.Credito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Vlr.Saldo" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, "Campo" + SPACE(5),1,2)
		    
		     While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[2] := TRB1->ORIGEM
	        	aLinhaAux[3] := TRB1->CONTA
	        	aLinhaAux[4] := TRB1->HISTORICO
	        	aLinhaAux[5] := TRB1->VDEBITO
	        	aLinhaAux[6] := TRB1->VCREDITO
	        	aLinhaAux[7] := TRB1->VSALDO
	        	//aLinhaAux[8] := TRB1->ITEMCONTA
			    aLinhaAux[8] := TRB1->IDUSA
			    aLinhaAux[9] := TRB1->DESCUSA
			    //aLinhaAux[11] := TRB1->CAMPO
	        
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Custo Contabil Analitico - " + _cItemConta, aLinhaAux)
	        
	            TRB1->(DbSkip())
	
	        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function EstContabil()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Estoque - " + _cItemConta
// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->ID) .and. !empty(TRB2->ID))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := " ALLTRIM(CAMPO) == 'VLRCTBE' .AND. TRB1->ITEMCONTA == '" + _cItemConta + "' "
TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB3
//monta arquivo analitico TRB3
aadd(aHeader, {"ID"			,"IDUSA"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Data"		,"DATAMOV"	,"",08,0,"","","D","TRB1","R"})
aadd(aHeader, {"Origem"		,"ORIGEM"	,"",02,0,"","","C","TRB1","R"})
aadd(aHeader, {"Conta"		,"CONTA"	,"",15,0,"","","C","TRB1","R"})
aadd(aHeader, {"Historico"	,"HISTORICO","",100,0,"","","C","TRB1","R"})
aadd(aHeader, {"Vlr.Debito"	,"VDEBITO"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.Credito","VCREDITO","@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Vlr.Saldo"	,"VSALDO"	,"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
aadd(aHeader, {"Item Conta"	,"ITEMCONTA","",13,0,"","","C","TRB1","R"})
//aadd(aHeader, {"ID"			,"ID"		,"",03,0,"","","C","TRB1","R"})
aadd(aHeader, {"Descricao ID","DESCUSA","",40,0,"","","C","TRB1","R"})


//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Estoque - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB1")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula��o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula��o" } )
aadd(aButton , { "BMPTABLE" , { || zExpExcGC7()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB1",cFiltra,aHeader), TRB1->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCctbe()}, "Imprimir " } )


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB1->(dbclearfil())

return

Static Function zExpExcGC7()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC7.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta)
        
           	aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Conta")								// 3 Conta
	        aAdd(aColunas, "Historico")							// 4 Historico
	        aAdd(aColunas, "Vlr.Debito")						// 5 Vlr.Debito
	        aAdd(aColunas, "Vlr.Credito")						// 6 Vlr.Credito
	        aAdd(aColunas, "Vlr.Saldo")							// 7 Vlr.Saldo
	        //aAdd(aColunas, "Item Conta")						// 8 Item Conta
		    aAdd(aColunas, "Id")								// 9 Id
		    aAdd(aColunas, "Descricao Id")						// 10 Descricao Id
		    //aAdd(aColunas, "Campo")								// 11 Campo
	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Historico" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Vlr.Debito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Vlr.Credito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Vlr.Saldo" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Id" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, "Campo" + SPACE(5),1,2)
		    
		     While  !(TRB1->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB1->DATAMOV
	        	aLinhaAux[2] := TRB1->ORIGEM
	        	aLinhaAux[3] := TRB1->CONTA
	        	aLinhaAux[4] := TRB1->HISTORICO
	        	aLinhaAux[5] := TRB1->VDEBITO
	        	aLinhaAux[6] := TRB1->VCREDITO
	        	aLinhaAux[7] := TRB1->VSALDO
	        	//aLinhaAux[8] := TRB1->ITEMCONTA
			    aLinhaAux[8] := TRB1->IDUSA
			    aLinhaAux[9] := TRB1->DESCUSA
			    //aLinhaAux[11] := TRB1->CAMPO
	        
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Estoque - " + _cItemConta, aLinhaAux)
	        
	            TRB1->(DbSkip())
	
	        EndDo

        TRB1->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

static function ContabilReceita()
local cFiltra 	:= ""

private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton	:= {}

cCadastro :=  "Gestao de Contratos - Receita - " + _cItemConta

// Se nao estiver posicionado em nenhuma celula com valor ou na linha de saldo, nao faz nada
/*
if TRB2->(Recno()) == _nRecSaldo .or. aScan(_aCpos,_cCampo) == 0 .or. (empty(TRB2->ID) .and. !empty(TRB2->ID))
	return
endif
*/

// Monta filtro no TRB1 para mostrar apenas os movimentos grupo e dia/periodo selecionado
cFiltra := "TRB4->RITEMCONTA == '" + _cItemConta + "' "
TRB4->(dbsetfilter({|| &(cFiltra)} , cFiltra))

// Monta aHeader do TRB3
//monta arquivo analitico TRB3

aadd(aHeader, {"Data"		,"RDATAMOV"	,"",08,0,"","","D","TRB4","R"})
aadd(aHeader, {"Origem"		,"RORIGEM"	,"",02,0,"","","C","TRB4","R"})
aadd(aHeader, {"Conta"		,"RCONTA"	,"",15,0,"","","C","TRB4","R"})
aadd(aHeader, {"Historico"	,"RHISTORICO","",100,0,"","","C","TRB4","R"})
aadd(aHeader, {"Vlr.Debito"	,"RVDEBITO"	,"@E 999,999,999.99",15,2,"","","N","TRB4","R"})
aadd(aHeader, {"Vlr.Credito","RVCREDITO","@E 999,999,999.99",15,2,"","","N","TRB4","R"})
aadd(aHeader, {"Vlr.Saldo"	,"RVSALDO"	,"@E 999,999,999.99",15,2,"","","N","TRB4","R"})
aadd(aHeader, {"Item Conta"	,"RITEMCONTA","",13,0,"","","C","TRB4","R"})
aadd(aHeader, {"ID"			,"RID"		,"",03,0,"","","C","TRB4","R"})
aadd(aHeader, {"Descricao ID","RDESCRICAO","",40,0,"","","C","TRB4","R"})

//aadd(aHeader, {"Simulado"	,"SIMULADO"	,"",01,0,"","","C","TRB2","R"})

DEFINE MSDIALOG _oDlgAnalit TITLE "Gestao de Contratos - Receita - " + _cItemConta From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

_oGetDbAnalit := MsGetDb():New(aPosObj[1,1],aPosObj[1,2],aPosObj[1,3],aPosObj[1,4], 2, ;
"AllwaysTrue()", "AllwaysTrue()",,,,,,"AllwaysTrue()","TRB4")

@ aPosObj[2,1]+5 , aPosObj[2,2]+5 Say "LEGENDA: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque "  COLORS 0, 16777215 PIXEL

//aadd(aButton , { "SIMULACAO", 	{ || (GerSimul(_cCampo,_cPeriodo),TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Simula��o" } )
//aadd(aButton , { "EXCLUIR", 	{ || (DelSimul(_cCampo,_cPeriodo),,TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))) }, "Excluir Simula��o" } )
aadd(aButton , { "BMPTABLE" , { || zExpExcGC8()}, "Gerar Plan. Excel " } )
//aadd(aButton , { "BMPTABLE" , 	{ || GeraExcel("TRB4",cFiltra,aHeader), TRB4->(dbgotop()), _oGetDbAnalit:ForceRefresh(), _oDlgAnalit:Refresh()}, "Gera Planilha Excel" } )
aadd(aButton , { "BMPTABLE" , { || PRNGCctbr()}, "Imprimir " } )


ACTIVATE MSDIALOG _oDlgAnalit ON INIT EnchoiceBar(_oDlgAnalit,{|| _oDlgAnalit:End()}, {||_oDlgAnalit:End()},, aButton)

TRB4->(dbclearfil())

return

Static Function zExpExcGC8()

Local aArea     := GetArea()
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExpExcGC8.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    Local oFWMsExcel := FWMSExcel():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
    
    //Primeira_coluna,Ultima_coluna,Largura,AjusteNumero,customWidth
	
   
    //Alterando atributos 
    oFWMsExcel:SetFontSize(10)                 //Tamanho Geral da Fonte               	//Largura
    oFWMsExcel:SetTitleSizeFont(10)
    oFWMsExcel:SetFont("Arial")                //Fonte utilizada
    oFWMsExcel:SetBgGeneralColor("#006400")    //Cor de Fundo Geral
    oFWMsExcel:SetTitleBold(.T.) 
    oFWMsExcel:SetTitleFrColor("#FFFF00")      //Cor da Fonte do t�tulo - Azul Clar
    oFWMsExcel:SetLineFrColor("#000000")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineFrColor("#000000")      //Cor da Fonte da segunda linha - Branco
    oFWMsExcel:SetLineBgColor("#FFFFFF")       //Cor da Fonte da primeira linha - Cinza Claro
    oFWMsExcel:Set2LineBgColor("#FAFAD2")      //Cor da Fonte da segunda linha - Branco
   
    //Aba 01 - Teste
    oFWMsExcel:AddworkSheet("Gestao de Contratos") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta)
        
           	aAdd(aColunas, "Data")								// 1 Data
	        aAdd(aColunas, "Origem")							// 2 Origem
	        aAdd(aColunas, "Conta")								// 3 Conta
	        aAdd(aColunas, "Historico")							// 4 Historico
	        aAdd(aColunas, "Vlr.Debito")						// 5 Vlr.Debito
	        aAdd(aColunas, "Vlr.Credito")						// 6 Vlr.Credito
	        aAdd(aColunas, "Vlr.Saldo")							// 7 Vlr.Saldo
	        //aAdd(aColunas, "Item Conta")						// 8 Item Conta
		    //aAdd(aColunas, "Id")								// 9 Id
		    //aAdd(aColunas, "Descricao Id")						// 10 Descricao Id
		    //aAdd(aColunas, "Campo")								// 11 Campo
	        
	        oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Data" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Origem" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Conta" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Historico" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Vlr.Debito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Vlr.Credito" + SPACE(5),1,2)
		    oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Vlr.Saldo" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Item Conta" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Descricao Id" + SPACE(5),1,2)
		    //oFWMsExcel:AddColumn("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, "Campo" + SPACE(5),1,2)
		    
		     While  !(TRB4->(EoF()))
	        
	        	aLinhaAux := Array(Len(aColunas))
	        	aLinhaAux[1] := TRB4->RDATAMOV
	        	aLinhaAux[2] := TRB4->RORIGEM
	        	aLinhaAux[3] := TRB4->RCONTA
	        	aLinhaAux[4] := TRB4->RHISTORICO
	        	aLinhaAux[5] := TRB4->RVDEBITO
	        	aLinhaAux[6] := TRB4->RVCREDITO
	        	aLinhaAux[7] := TRB4->RVSALDO
	        	//aLinhaAux[8] := TRB4->RITEMCONTA
			    //aLinhaAux[9] := TRB4->RID
			    //aLinhaAux[10] := TRB4->RDESCRICAO
			    //aLinhaAux[11] := TRB4->RCAMPO
	        
	        	oFWMsExcel:AddRow("Gestao de Contratos","Gestao de Contratos - Receita - " + _cItemConta, aLinhaAux)
	        
	            TRB4->(DbSkip())
	
	        EndDo

        TRB4->(dbgotop())
   
    //Ativando o arquivo e gerando o xml
    oFWMsExcel:Activate()
    oFWMsExcel:GetXMLFile(cArquivo)
         
    //Abrindo o excel e abrindo o arquivo xml
    oExcel := MsExcel():New()             //Abre uma nova conex�o com Excel
    oExcel:WorkBooks:Open(cArquivo)     //Abre uma planilha
    oExcel:SetVisible(.T.)                 //Visualiza a planilha
    oExcel:Destroy()                        //Encerra o processo do gerenciador de tarefas

return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera Arquivo em Excel e abre                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function GeraExcel(_cAlias,_cFiltro,aHeader)

MsAguarde({||GeraCSV(_cAlias,_cFiltro,aHeader)},"Aguarde","Gerando Planilha",.F.)

/*
_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	copy to &(_cArq) VIA "DBFCDXADS" for &(_cFiltro)
else
	copy to &(_cArq) VIA "DBFCDXADS"
endif

MsAguarde({||AbreDoc( _cArq ) },"Aguarde","Abrindo Arquivo",.F.)
*/

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Gera Arquivo em Excel e abre                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function geraCSV(_cAlias,_cFiltro,aHeader) //aFluxo,nBancos,nCaixas,nAtrReceber,nAtrPagar)

local cDirDocs  := MsDocPath()
Local cArquivo 	:= CriaTrab(,.F.)
Local cPath		:= AllTrim(GetTempPath())
Local oExcelApp
Local nHandle
Local cCrLf 	:= Chr(13) + Chr(10)
Local nX
Local _ni

local _cArq		:= ""

_cFiltro := iif(_cFiltro==NIL, "",_cFiltro)

if !empty(_cFiltro)
	(_cAlias)->(dbsetfilter({|| &(_cFiltro)} , _cFiltro))
endif

nHandle := MsfCreate(cDirDocs+"\"+cArquivo+".CSV",0)

If nHandle > 0

	// Grava o cabecalho do arquivo
	aEval(aHeader, {|e, nX| fWrite(nHandle, e[1] + If(nX < Len(aHeader), ";", "") ) } )
	fWrite(nHandle, cCrLf ) // Pula linha

	(_cAlias)->(dbgotop())
	while (_cAlias)->(!eof())

		for _ni := 1 to len(aHeader)

			_uValor := ""

			if aHeader[_ni,8] == "D" // Trata campos data
				_uValor := dtoc(&(_cAlias + "->" + aHeader[_ni,2]))
			elseif aHeader[_ni,8] == "N" // Trata campos numericos
				_uValor := transform(&(_cAlias + "->" + aHeader[_ni,2]),aHeader[_ni,3])
			elseif aHeader[_ni,8] == "C" // Trata campos caracter
				_uValor := &(_cAlias + "->" + aHeader[_ni,2])
			endif

			if _ni <> len(aHeader)
				fWrite(nHandle, _uValor + ";" )
			endif

		next _ni

		fWrite(nHandle, cCrLf )

		(_cAlias)->(dbskip())

	enddo

	fClose(nHandle)
	CpyS2T( cDirDocs+"\"+cArquivo+".CSV" , cPath, .T. )

	If ! ApOleClient( 'MsExcel' )
		MsgAlert( 'MsExcel nao instalado')
		Return
	EndIf

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open( cPath+cArquivo+".CSV" ) // Abre uma planilha
	oExcelApp:SetVisible(.T.)
Else
	MsgAlert("Falha na criacao do arquivo")
Endif

(_cAlias)->(dbclearfil())

Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Abre os arquivos necessarios                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AbreArq()
local aStru 	:= {}

local _cCpoAtu
local _ni

if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Nao foi possivel abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuario.")
	return(.F.)
endif

// monta arquivo analitico TRB1

aAdd(aStru,{"DATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"DATAENT"	,"D",08,0}) // Data de entrega
aAdd(aStru,{"ORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"TIPO"		,"C",03,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"GRPROD"	,"C",03,0})
aAdd(aStru,{"CONTA"		,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"VDEBITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VCREDITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VSALDO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"NUMERO"	,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"PRODUTO"	,"C",30,0}) // Historico
aAdd(aStru,{"HISTORICO"	,"C",120,0}) // Historico
aAdd(aStru,{"QUANTIDADE","N",15,2}) // Data de movimentacao
aAdd(aStru,{"UNIDADE","C",02,0}) // Data de movimentacao
aAdd(aStru,{"VALOR"		,"N",15,2}) // Valor do movimento
aAdd(aStru,{"VALOR2"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"ITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CODFORN"	,"C",15,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"FORNECEDOR","C",60,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"CFOP"		,"C",13,0})
aAdd(aStru,{"NATUREZA"	,"C",13,0})
aAdd(aStru,{"DNATUREZA"	,"C",40,0})
aAdd(aStru,{"ID"		,"C",03,0}) // Historico
aAdd(aStru,{"DESCRICAO"	,"C",20,0}) // Historico
aAdd(aStru,{"IDUSA"		,"C",03,0}) // Historico
aAdd(aStru,{"DESCUSA"	,"C",50,0}) // Historico
aAdd(aStru,{"CAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"SIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao



dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.T.,.F.)
dbUseArea(.T.,,cArqTrb1,"TRB11",.T.,.F.)



//monta arquivo analitico TRB4
aAdd(aStru,{"RDATAMOV"	,"D",08,0}) // Data de movimentacao
aAdd(aStru,{"RORIGEM"	,"C",02,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"RCONTA"	,"C",15,0}) // Data de movimentacao
aAdd(aStru,{"RHISTORICO"	,"C",80,0}) // Historico
aAdd(aStru,{"RVDEBITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RVCREDITO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RVSALDO"	,"N",15,2}) // Valor do movimento
aAdd(aStru,{"RITEMCONTA"	,"C",13,0}) // Origem do lancamento (MB - movimento bancario, PC - pedido de compra, CR - Contas a receber e CP - Contas a pagar)
aAdd(aStru,{"RID"		,"C",03,0}) // Historico
aAdd(aStru,{"RDESCRICAO"	,"C",20,0}) // Historico
aAdd(aStru,{"RCAMPO"		,"C",10,0}) // Campo de gravacao (periodo) no arquivo sintetico
aAdd(aStru,{"RSIMULADO"	,"C",01,0}) // Indica se o registro foi gerado por uma simulacao

dbcreate(cArqTrb4,aStru)
dbUseArea(.T.,,cArqTrb4,"TRB4",.T.,.F.)

//***************************************************************
aStru := {}
//aAdd(aStru,{"OK"		,"C",01,0}) // Descricao da Natureza
aAdd(aStru,{"GRUPO"		,"C",20,0}) // Descricao da Natureza
aAdd(aStru,{"DESCRICAO"	,"C",30,0}) // Descricao da Natureza
aAdd(aStru,{"VLRVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERVD"		,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERPLN"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PEREMP"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERSLD"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTB"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"VLRCTBE"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"PERCTBE"	,"N",15,2}) // Valor total dos movimentos
aAdd(aStru,{"ID"		,"C",5,0}) // Codigo da Natureza
aAdd(aStru,{"IDUSA"		,"C",3,0}) // Codigo da Natureza
aAdd(aStru,{"DESCUSA"	,"C",50,0}) // Descricao da Natureza
aAdd(aStru,{"ORDEM"		,"C",10,0}) // Ordem de apresentacao

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)

aadd(_aCpos , "DESCRICAO")
aadd(_aCpos , "VLRVD")
aadd(_aCpos , "PERVD")
aadd(_aCpos , "VLRPLN")
aadd(_aCpos , "PERPLN")
aadd(_aCpos , "VLREMP")
aadd(_aCpos , "PEREMP")
aadd(_aCpos , "VLRSLD")
aadd(_aCpos , "PERSLD")
aadd(_aCpos , "VLRCTB")
aadd(_aCpos , "PERCTB")
aadd(_aCpos , "VLRCTBE")
aadd(_aCpos , "PERCTBE")

_nCampos := len(_aCpos)

index on ORDEM to &(cArqTrb2+"2")
index on ORDEM to &(cArqTrb2+"1")
index on ORDEM to &(cArqTrb4+"1")

set index to &(cArqTrb2+"1")
set index to &(cArqTrb4+"1")

/******** CAMPOS FATURAMENTO REALIZADO ***************/
aStru := {}

aAdd(aStru,{"FRTIPO"	,"C",15,0}) // Tipo de faturamento
aAdd(aStru,{"FRDTMOV"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"FRTPMOV"	,"C",03,0}) // data movimenta��o
aAdd(aStru,{"FRCFOP"	,"C",10,0}) // data movimenta��o
aAdd(aStru,{"FRDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"FRVLRDC"	,"N",15,2}) // valor documento
aAdd(aStru,{"FRVLRSI"	,"N",15,2}) // valor documento
aAdd(aStru,{"FRICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"FRDTMOV2"	,"D",08,0}) // data movimenta��o

dbcreate(cArqTrb5,aStru)
dbUseArea(.T.,,cArqTrb5,"TRB5",.F.,.F.)
index on FRDTMOV2 to &(cArqTrb5+"1")
set index to &(cArqTrb5+"1")

/******** CAMPOS FATURAMENTO PLANEJADO ***************/
aStru := {}
aAdd(aStru,{"FPITEM"	,"C",10,0}) // data movimenta��o
aAdd(aStru,{"FPDTMOV"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"FPHIST"	,"C",40,0}) // data movimenta��o
aAdd(aStru,{"FPDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"FPVLRCI"	,"N",15,2}) // valor documento
aAdd(aStru,{"FPVLRSI"	,"N",15,2}) // valor documento
aAdd(aStru,{"FPICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"FPDTMOV2"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"FATFIN"	,"C",10,0}) // data movimenta��o

dbcreate(cArqTrb6,aStru)
dbUseArea(.T.,,cArqTrb6,"TRB6",.F.,.F.)
index on FPDTMOV2 to &(cArqTrb6+"1")
set index to &(cArqTrb6+"1")

/******** CAMPOS RECEBIMENTO REALIZADO ***************/
aStru := {}
aAdd(aStru,{"RRTIPO"	,"C",22,0}) // Tipo de faturamento
aAdd(aStru,{"RRDTMOV"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"RRDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"RRVLRDC"	,"N",15,2}) // valor documento
aAdd(aStru,{"RRBENEF"	,"C",40,0}) // Descricao
aAdd(aStru,{"RRHIST"	,"C",40,0}) // Descricao
aAdd(aStru,{"RRICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"RRDTMOV2"	,"D",08,0}) // data movimenta��o

dbcreate(cArqTrb7,aStru)
dbUseArea(.T.,,cArqTrb7,"TRB7",.F.,.F.)
index on RRDTMOV2 to &(cArqTrb7+"1")
set index to &(cArqTrb7+"1")

/******** CAMPOS RECEBIMENTO PLANEJADO ***************/
aStru := {}
aAdd(aStru,{"RPTIPO"	,"C",15,0}) // Tipo de faturamento
aAdd(aStru,{"RPDTMOV"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"RPDOCTO"	,"C",09,0}) // numero documento
aAdd(aStru,{"RPTPDOC"	,"C",15,0}) // numero documento

aAdd(aStru,{"RPVLRDC"	,"N",15,2}) // valor documento R$
aAdd(aStru,{"RPVLRDC2"	,"N",15,2}) // valor documento
aAdd(aStru,{"RPMOEDA"	,"N",02,0}) // moeda
aAdd(aStru,{"RPTXMOE"	,"N",15,4}) // taxa moeda

//aAdd(aStru,{"RPVLRDC"	,"N",15,2}) // valor documento R$
aAdd(aStru,{"RPBENEF"	,"C",40,0}) // Descricao
aAdd(aStru,{"RPHIST"	,"C",80,0}) // Descricao
aAdd(aStru,{"RPICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"RPCLIENT"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"RPNCLIEN"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"RPLOJA"	,"C",02,0}) // Loja
aAdd(aStru,{"RPPREF"	,"C",03,0}) // Prefixo
aAdd(aStru,{"RPNTIT"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"RPPARCEL"	,"C",01,0}) // Parcela
aAdd(aStru,{"RPDTMOV2"	,"D",08,0}) // data movimenta��o

dbcreate(cArqTrb8,aStru)
dbUseArea(.T.,,cArqTrb8,"TRB8",.F.,.F.)
index on RPDTMOV2 to &(cArqTrb8+"1")
set index to &(cArqTrb8+"1")

/******** CAMPOS PAGAMENTO PLANEJADO ***************/
aStru := {}
aAdd(aStru,{"PPTIPO"	,"C",15,0}) // Tipo de faturamento
aAdd(aStru,{"PPDTMOV"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"PPDOCTO"	,"C",15,0}) // numero documento
aAdd(aStru,{"PPTPDOC"	,"C",15,0}) // numero documento
aAdd(aStru,{"PPVLRDC"	,"N",15,2}) // valor documento R$
aAdd(aStru,{"PPVLRDC2"	,"N",15,2}) // valor documento
aAdd(aStru,{"PPMOEDA"	,"N",02,0}) // moeda
aAdd(aStru,{"PPTXMOE"	,"N",15,4}) // taxa moeda
aAdd(aStru,{"PPBENEF"	,"C",40,0}) // Descricao
aAdd(aStru,{"PPHIST"	,"C",80,0}) // Descricao
aAdd(aStru,{"PPICTA"	,"C",13,0}) // contrato
aAdd(aStru,{"PPFORNE"	,"C",10,0}) // Codigo Cliente / Fornecedor
aAdd(aStru,{"PPNFORN"	,"C",20,0}) // Nome Cliente / Fornecedor
aAdd(aStru,{"PPLOJA"	,"C",02,0}) // Loja
aAdd(aStru,{"PPPREF"	,"C",03,0}) // Prefixo
aAdd(aStru,{"PPNTIT"	,"C",09,0}) // Numero de Titulo
aAdd(aStru,{"PPPARCEL"	,"C",01,0}) // Parcela
aAdd(aStru,{"PPDTMOV2"	,"D",08,0}) // data movimenta��o

dbcreate(cArqTrb9,aStru)
dbUseArea(.T.,,cArqTrb9,"TRB9",.F.,.F.)
index on PPDTMOV2 to &(cArqTrb9+"1")
set index to &(cArqTrb9+"1")

/******** CAMPOS COMISSOES ***************/
aStru := {}
aAdd(aStru,{"ORIGEM"	,"C",15,0}) // origem
aAdd(aStru,{"PCOMISS"	,"N",15,2}) // % comissao
aAdd(aStru,{"VCOMISS"	,"N",15,2}) // valor comissao
aAdd(aStru,{"FORNECE"	,"C",40,0}) // fornecedor
aAdd(aStru,{"DTPGTO"	,"D",08,0}) // data movimenta��o
aAdd(aStru,{"VCOMPG"	,"N",15,2}) // valor comissao
aAdd(aStru,{"PCOMPG"	,"N",15,2}) // % comissao
aAdd(aStru,{"ITEMCTA"	,"C",13,0}) // item conta
aAdd(aStru,{"CONTADOR"	,"N",15,0}) // valor comissao


dbcreate(cArqTrb10,aStru)
dbUseArea(.T.,,cArqTrb10,"TRB10",.F.,.F.)
index on CONTADOR to &(cArqTrb10+"1")
set index to &(cArqTrb10+"1")

/******** CAMPOS SOLICITACAO DE COMPRA ***************/
aStru := {}
aAdd(aStru,{"STATUS"	,"C",10,0}) // status
aAdd(aStru,{"NSOLICIT"	,"C",06,0}) // numero da solicitacao
aAdd(aStru,{"ITEMSC"	,"C",06,0}) // ITEM da solicitacao
aAdd(aStru,{"CODPROD"	,"C",30,0}) // codigo do produto
aAdd(aStru,{"DESCRI"	,"C",80,0}) // descricao do produto
aAdd(aStru,{"UM"		,"C",02,0}) // unidade
aAdd(aStru,{"QUANTSOC"	,"N",15,2}) // quantidade solicitada
aAdd(aStru,{"QUANTENT"	,"N",15,2}) // quantidade entregue
aAdd(aStru,{"EMISSAO"	,"D",08,0}) // data emissao
aAdd(aStru,{"ENTREGA"	,"D",08,0}) // data entrega
aAdd(aStru,{"NPEDIDO"	,"C",06,0}) // numero do pedido de compra
aAdd(aStru,{"NOMSOLIC"	,"C",20,0}) // nome solicitante
aAdd(aStru,{"ORDPROD"	,"C",30,0}) // ordem de producao
aAdd(aStru,{"ITEMCTA"	,"C",13,0}) // data movimenta��o

dbcreate(cArqTrb12,aStru)
dbUseArea(.T.,,cArqTrb12,"TRB12",.F.,.F.)
index on NSOLICIT to &(cArqTrb12+"1")
set index to &(cArqTrb12+"1")

/******** CAMPOS PEDIDOS DE COMPRA ***************/
aStru := {}
aAdd(aStru,{"PSTATUS"	,"C",10,0}) // status
aAdd(aStru,{"PNPEDIDO"	,"C",06,0}) // numero do pedido de compra
aAdd(aStru,{"PITEMPC"	,"C",06,0}) // ITEM da solicitacao
aAdd(aStru,{"PCODPROD"	,"C",30,0}) // codigo do produto
aAdd(aStru,{"PDESCRI"	,"C",80,0}) // descricao do produto
aAdd(aStru,{"PUM"		,"C",02,0}) // unidade
aAdd(aStru,{"PQTDPC"	,"N",15,2}) // quantidade solicitada
aAdd(aStru,{"PUNIT"		,"N",15,2}) // valor unitario
aAdd(aStru,{"PTOTAL"	,"N",15,2}) // total item
aAdd(aStru,{"PTOTALSI"	,"N",15,2}) // total s/ tributos item
aAdd(aStru,{"PQTDENTR"	,"N",15,2}) // quantidade entregue
aAdd(aStru,{"PEMISSAO"	,"D",08,0}) // data emissao
aAdd(aStru,{"PENTREGA"	,"D",08,0}) // data entrega
aAdd(aStru,{"PNSOLIC"	,"C",06,0}) // numero da solicitacao
aAdd(aStru,{"PFORNECE"	,"C",10,0}) // codigo fornecedor
aAdd(aStru,{"PDFORNECE"	,"C",30,0}) // nome fornecedor
aAdd(aStru,{"PITEMCTA"	,"C",13,0}) // data movimenta��o

dbcreate(cArqTrb13,aStru)
dbUseArea(.T.,,cArqTrb13,"TRB13",.F.,.F.)
index on PNPEDIDO to &(cArqTrb13+"1")
set index to &(cArqTrb13+"1")

/******** CAMPOS ORDEM DE PRODUCAO ***************/
aStru := {}
aAdd(aStru,{"OITEMCTA"	,"C",13,0}) // item conta
aAdd(aStru,{"ORDPRD"	,"C",11,0}) // numero ordem de producao
aAdd(aStru,{"OPRODUT"	,"C",30,0}) // codigo produto
aAdd(aStru,{"ODESCRI"	,"C",80,0}) // descricao produto
aAdd(aStru,{"OLOCAL"	,"C",02,0}) // armazem
aAdd(aStru,{"OQUANT"	,"N",16,6}) // quantidade
aAdd(aStru,{"OSALDO"	,"N",16,6}) // saldo d3
aAdd(aStru,{"OUM"		,"C",02,2}) // unidade
aAdd(aStru,{"ODATPRI"	,"D",08,0}) // privisao inicial
aAdd(aStru,{"OENTREG"	,"D",08,0}) // entrega
aAdd(aStru,{"OEMISSA"	,"D",08,0}) // emissao

dbcreate(cArqTrb14,aStru)
dbUseArea(.T.,,cArqTrb14,"TRB14",.F.,.F.)
index on ORDPRD to &(cArqTrb14+"1")
set index to &(cArqTrb14+"1")

/******** CAMPOS DETALHES ORDEM DE PRODUCAO ***************/
aStru := {}
aAdd(aStru,{"DORDPRD"	,"C",11,0}) // numero ordem de producao
aAdd(aStru,{"DPRODUT1"	,"C",30,0}) // codigo produto
aAdd(aStru,{"DDESCRI1"	,"C",80,0}) // descricao produto
aAdd(aStru,{"DQUANT1"	,"N",16,6}) // quantidade
aAdd(aStru,{"DUM1"		,"C",02,2}) // unidade
aAdd(aStru,{"DPRODUT"	,"C",30,0}) // codigo produto
aAdd(aStru,{"DDESCRI"	,"C",80,0}) // descricao produto
aAdd(aStru,{"DLOCAL"	,"C",02,0}) // armazem
aAdd(aStru,{"DQUANT"	,"N",16,6}) // quantidade
aAdd(aStru,{"DUM"		,"C",02,2}) // unidade
aAdd(aStru,{"DEMISSA"	,"D",08,0}) // emissao
aAdd(aStru,{"DTIPO"		,"C",02,0}) // grupo de produtos
aAdd(aStru,{"DNSOLIC"	,"C",06,0}) // numero da solicitacao
aAdd(aStru,{"DITEMCTA"	,"C",13,0}) // item conta
aAdd(aStru,{"DQTDENT"	,"N",16,6}) // quantidade

dbcreate(cArqTrb15,aStru)
dbUseArea(.T.,,cArqTrb15,"TRB15",.F.,.F.)
index on DORDPRD to &(cArqTrb15+"1")
set index to &(cArqTrb15+"1")


return(.T.)


static function VldParam()

/*
if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos par�metros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de in�cio do processamento deve ser menor ou igual a data de refer�ncia.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de refer�ncia.")
	return(.F.)
endif
*/
return(.T.)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ABREDOC   �Autor  �Marcos Zanetti G&Z  � Data �  01/11/04   ���
�������������������������������������������������������������������������͹��
���Desc.     � Abre o XLS com os dados do fluxo de caixa                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
static function AbreDoc( _cFile )
LOCAL cDrive     := ""
LOCAL cDir       := ""

cTempPath := "C:\"
cPathTerm := cTempPath + _cFile

ferase(cTempPath + _cFile)

If CpyS2T( "\SIGAADV\"+_cFile, cTempPath, .T. )
	SplitPath(cPathTerm, @cDrive, @cDir )
	cDir := Alltrim(cDrive) + Alltrim(cDir)
	nRet := ShellExecute( "Open" , cPathTerm ,"", cDir , 3 )
else
	MsgStop("Ocorreram problemas na copia do arquivo.")
endif

return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Resumo Custos de Contrato		                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCRes()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCRes"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|MontaRel2(),"Imprimindo Resumo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function MontaRel2()

Local nD, nP , nC, _cObs, nPosicao, nLinAtu, nLinMax, lchk01, oBrush, oBrush2,  lEmpCab, lEmpRoda,  lCrtPag
Local aDados  := {}
Private cOperUnit, cClient, cNRedu, cIDPM, CNomPM
Private cFileLogo
Private _cObsItem := ""
Private nCont  := 0
Private nCont1 := 1
Private Cont   := 1
Private Cont1  := 15
Private oPrint,oFont7,oFont7n,oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont16,oFont16n,oFont20,oFont24,oFont9b

//Par�metros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont7  := TFont():New("Calibri",8,7 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont7n := TFont():New("Calibri",8,7 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont8  := TFont():New("Calibri",8,8 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n := TFont():New("Calibri",8,8 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9  := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9b := TFont():New("Calibri",8,9 ,.T.,.F.,5,.T.,5,.T.,.F.)
oFont9n := TFont():New("Calibri",8,9 ,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10 := TFont():New("Calibri",8,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11 := TFont():New("Calibri",8,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12 := TFont():New("Calibri",8,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13 := TFont():New("Calibri",8,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14 := TFont():New("Calibri",8,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n:= TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20 := TFont():New("Calibri",8,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24 := TFont():New("Calibri",8,24,.T.,.T.,5,.T.,5,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';

oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

oPrint:= TMSPrinter():New("RESGC")
//oPrint:SetPortrait() // ou SetLandscape()
oPrint:SetLandScape()
oPrint:SetPaperSize(9)

/*//=========
oPrint := TmsPrinter():New()

oPrint:SetPortrait() ( Para Retrato) ou
oPrint:SetLandScape() ( Para Paisagem )

oPrint:SetPaperSize(1)     ( 1 - Carta ) ou
oPrint:SetPaperSize(9)     ( 9 - A4 )
//========*/


oPrint:Setup() // para configurar impressora

cFileLogo := "lgrl" + cEmpAnt + ".bmp"
DbSelectArea("TRB2"); DbSetOrder(1)
DbGoTop()

nPosicao := 440
_cObs := "1 - A mercadoria sera aceita somente se, na sua Nota Fiscal constar o numero do nosso Pedido de Compra."

Do While !TRB2->(Eof())
	
	
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))
	
	//DbGoTop()

	
	lchk01	:= .T.
	nCont	:= 0
	
	For nC := 1 to Len(aDados)
		
		If Cont > Cont1
			nCont1 := nCont1 + 1
			Cont := 1

		Endif
		Cont := Cont + 1

	Next

	lEmpCab := lEmpRoda := .t.
	// Controla Qtd de Numero de Linhas Por pedido de compras Maximo de 15 linhas nos itens de um pedido
	nLinMax	:= 2000
	nLinAtu	:= 440
	lCrtPag	:= .T.

	//For nP := 1 to len(aDados)

	If  nLinAtu > nLinMax
			nCont := nCont + 1
			//oPrint:Say  (0260,1900,Transform(StrZero(ncont,3),""),oFont10)
			//oPrint:Say  (0260,1970,"de",oFont10)
			//oPrint:Say  (0260,2020,Transform(StrZero(ncont1,3),""),oFont10)

			oPrint:EndPage() // Finaliza a p�gina
			lEmpCab := .t.
			lCrtPag	:= .F.
			nLinAtu := 440
			nPosicao := 440

		Endif
		//================== Numer de paginas ==========================
		If lEmpCab
			EmpCab()
			lEmpCab := .f.
			nPos := 415

			If lCrtPag
				nCont := nCont + 1
			Endif
		Endif
		//===============================================================
		_nTamStr	:= 85
		_lChkTam	:= .T.
		_nTamDesc	:= 85

		//**********
	
		If nLinAtu <= nLinMax
		
			//nLinAtu := nLinAtu + 50

			//oPrint:Say  (0940+nPos,0410,Posicione("SB1",1,xFilial("SB1") + aDados[nP,7],"B1_DESC"),oFont8) // Desc.Produto
			if TRB2->IDUSA $ "199/209/299/000/999"
				oPrint:Say  (nPosicao,0070,TRB2->IDUSA,oFont8n) //GRUPO
				oPrint:Say  (nPosicao,0240,TRB2->DESCUSA,oFont8n) //DESCRICAO
				
				oPrint:Say  (nPosicao,1100, Alltrim(Transform(TRB2->VLRVD,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR VENDA
				oPrint:Say  (nPosicao,1250, Alltrim(Transform(TRB2->PERVD,"@E 999,999,999.99")),oFont8n,20,,,1) //PERCENT VENDA
				
				oPrint:Say  (nPosicao,1500, Alltrim(Transform(TRB2->VLRPLN,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR PLANEJADO
				oPrint:Say  (nPosicao,1650, Alltrim(Transform(TRB2->PERPLN,"@E 999,999,999.99")),oFont8n,20,,,1) //PERCENT PLANEJADO
				
				oPrint:Say  (nPosicao,1900, Alltrim(Transform(TRB2->VLREMP,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR EMPENHADO
				oPrint:Say  (nPosicao,2050, Alltrim(Transform(TRB2->PEREMP,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR EMPENHADO
				
				oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR SALDO
				oPrint:Say  (nPosicao,2450, Alltrim(Transform(TRB2->PERSLD,"@E 999,999,999.99")),oFont8n,20,,,1) //PERCENT SALDO
				
				oPrint:Say  (nPosicao,2700, Alltrim(Transform(TRB2->VLRCTB,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR CONTABIL CUSTO
				oPrint:Say  (nPosicao,2850, Alltrim(Transform(TRB2->PERCTB,"@E 999,999,999.99")),oFont8n,20,,,1) //PERCENT CONTABIL CUSTO
				
				oPrint:Say  (nPosicao,3100, Alltrim(Transform(TRB2->VLRCTBE,"@E 999,999,999.99")),oFont8n,20,,,1) //VALOR CUSTO ESTOQUE
				oPrint:Say  (nPosicao,3250, Alltrim(Transform(TRB2->PERCTBE,"@E 999,999,999.99")),oFont8n,20,,,1) //PERCENT CUSTO ESTOQUE
			else
				oPrint:Say  (nPosicao,0070,TRB2->IDUSA,oFont8) //GRUPO
				oPrint:Say  (nPosicao,0240,TRB2->DESCUSA,oFont8) //DESCRICAO
				
				oPrint:Say  (nPosicao,1100, Alltrim(Transform(TRB2->VLRVD,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR VENDA
				oPrint:Say  (nPosicao,1250, Alltrim(Transform(TRB2->PERVD,"@E 999,999,999.99")),oFont8,20,,,1) //PERCENT VENDA
				
				oPrint:Say  (nPosicao,1500, Alltrim(Transform(TRB2->VLRPLN,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR PLANEJADO
				oPrint:Say  (nPosicao,1650, Alltrim(Transform(TRB2->PERPLN,"@E 999,999,999.99")),oFont8,20,,,1) //PERCENT PLANEJADO
				
				oPrint:Say  (nPosicao,1900, Alltrim(Transform(TRB2->VLREMP,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR EMPENHADO
				oPrint:Say  (nPosicao,2050, Alltrim(Transform(TRB2->PEREMP,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR EMPENHADO
				
				oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR SALDO
				oPrint:Say  (nPosicao,2450, Alltrim(Transform(TRB2->PERSLD,"@E 999,999,999.99")),oFont8,20,,,1) //PERCENT SALDO
				
				oPrint:Say  (nPosicao,2700, Alltrim(Transform(TRB2->VLRCTB,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR CONTABIL CUSTO
				oPrint:Say  (nPosicao,2850, Alltrim(Transform(TRB2->PERCTB,"@E 999,999,999.99")),oFont8,20,,,1) //PERCENT CONTABIL CUSTO
				
				oPrint:Say  (nPosicao,3100, Alltrim(Transform(TRB2->VLRCTBE,"@E 999,999,999.99")),oFont8,20,,,1) //VALOR CUSTO ESTOQUE
				oPrint:Say  (nPosicao,3250, Alltrim(Transform(TRB2->PERCTBE,"@E 999,999,999.99")),oFont8,20,,,1) //PERCENT CUSTO ESTOQUE
			endif
			nPosicao  += 43
			nLinAtu := nLinAtu + 1

		EndIf

		DbSkip()
	//Next

	nCont := nCont + 1 //==============
	nCont1 := nCont1 + 1 //==============


Enddo


oPrint:EndPage() // Finaliza a p�gina

oPrint:Preview()  // Visualiza antes de imprimir

DbGoTop()

Return nil
//********************
Static Function EMPCAB()


		//... Impressao do cabecalho
		oPrint:StartPage()   // Inicia uma nova p�gina

		// Cabecalho
		//oPrint:FillRect({0050,0050,0190,0740},oBrush2)

		oPrint:Box	(0050,0050,0340,3300) //Box Cabe�a

		oPrint:Box	(0050,0050,0190,0740) // logo
		oPrint:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrint:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrint:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrint:Say  (0070,1200,"GESTAO DE CONTRATO - CUSTOS -  " + _cItemConta ,oFont20)
		
		
		oPrint:Box	(0050,2900,0190,3300) // Data Emissao
		oPrint:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrint:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrint:Box	(0050,0050,0260,3300) // Detalhes
		
		oPrint:Box	(0190,0050,0260,1190) // Detalhes
		oPrint:Say  (0200,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrint:Box	(0190,1190,0260,2190) // Detalhes
		oPrint:Say  (0200,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrint:Box	(0190,2190,0260,3300) // Detalhes
		oPrint:Say  (0200,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrint:Box	(0260,0050,0340,0640) // Detalhes
		oPrint:Say  (0270,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont9n)
		
		oPrint:Box	(0260,0640,0340,1240) // Detalhes
		oPrint:Say  (0270,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont9n)
		
		oPrint:Box	(0260,1240,0340,1740) // Detalhes
		oPrint:Say  (0270,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont9n)
		
		oPrint:Box	(0260,1740,0340,2240) // Detalhes
		oPrint:Say  (0270,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont9n)
		
		oPrint:Box	(0260,2240,0340,2740) // Detalhes
		oPrint:Say  (0270,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont9n)
		
		oPrint:Box	(0260,2740,0340,3300) // Detalhes	
		oPrint:Say  (0270,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont9n)

		// Cabecalho Itens do Pedido

		oPrint:Box	(0340,0050,0430,3300) // cabecalhos itens pedido
			
		oPrint:Box	(0340,0050,2350,0190) // cabecalho Item
		oPrint:Say  (0370,0080,"ID USA",oFont9n)
		
		oPrint:Box	(0340,0190,2350,0810) // cabecalho Item
		oPrint:Say  (0370,0450,"Descricao",oFont9n)
		
		oPrint:Box	(0340,0810,0430,1260) // cabecalhos itens pedido
		oPrint:Box	(0380,0810,2350,1110) // cabecalho Item
		oPrint:Box	(0380,0810,2350,1260) // cabecalho Item
		
		oPrint:Say  (0342,0980,"Vendido",oFont9n)
		oPrint:Say  (0390,0900,"Valor",oFont9n)
		oPrint:Say  (0390,1200,"%",oFont9n)
		
		oPrint:Box	(0340,1260,0430,1660) // cabecalhos itens pedido
		oPrint:Box	(0380,1260,2350,1510) // cabecalho Item
		oPrint:Box	(0380,1260,2350,1660) // cabecalho Item
		
		oPrint:Say  (0342,1430,"Planejado",oFont9n)
		oPrint:Say  (0390,1340,"Valor",oFont9n)
		oPrint:Say  (0390,1620,"%",oFont9n)
		
		oPrint:Box	(0340,1660,0430,2060) // cabecalhos itens pedido
		oPrint:Box	(0380,1660,2350,1910) // cabecalho Item
		oPrint:Box	(0380,1660,2350,2060) // cabecalho Item
		
		oPrint:Say  (0342,1820,"Realizado",oFont9n)
		oPrint:Say  (0390,1740,"Valor",oFont9n)
		oPrint:Say  (0390,2010,"%",oFont9n)
		
		oPrint:Box	(0340,2060,0430,2460) // cabecalhos itens pedido
		oPrint:Box	(0380,2060,2350,2310) // cabecalho Item
		oPrint:Box	(0380,2060,2350,2460) // cabecalho Item
		
		oPrint:Say  (0342,2240,"Saldo",oFont9n)
		oPrint:Say  (0390,2130,"Valor",oFont9n)
		oPrint:Say  (0390,2410,"%",oFont9n)
		
		oPrint:Box	(0340,2460,0430,2860) // cabecalhos itens pedido
		oPrint:Box	(0380,2460,2350,2710) // cabecalho Item
		oPrint:Box	(0380,2460,2350,2860) // cabecalho Item
		
		oPrint:Say  (0342,2610,"Custo Contabil",oFont9n)
		oPrint:Say  (0390,2530,"Valor",oFont9n)
		oPrint:Say  (0390,2810,"%",oFont9n)
		
		oPrint:Box	(0340,2860,0430,3300) // cabecalhos itens pedido
		oPrint:Box	(0380,2860,2350,3110) // cabecalho Item
		oPrint:Box	(0380,2860,2350,3300) // cabecalho Item
		
		oPrint:Say  (0342,2960,"Estoque",oFont9n)
		oPrint:Say  (0390,3000,"Valor",oFont9n)
		oPrint:Say  (0390,3210,"%",oFont9n)
				
		oPrint:Box	(0860,0050,0904,3300) // cabecalhos itens pedido
		
		oPrint:Box	(1161,0050,1205,3300) // cabecalhos itens pedido
		
		oPrint:Box	(1597,0050,1640,3300) // cabecalhos itens pedido
		
		oPrint:Box	(1803,0050,1900,3300) // cabecalhos itens pedido
				
		oPrint:Box	(2149,0050,2193,3300) // cabecalhos itens pedido
		oPrint:Box	(2245,0050,2350,3300) // cabecalhos itens pedido
		
//oPrint:EndPage() // Finaliza a p�gina

Return


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Empenhado Full              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCEmp()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCEmp"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|zGCRel01(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function zGCRel01()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel01"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC01()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC01()

PrnGCC01()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC01()

	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO Realizado -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Numero",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1470,"Qtd.",oFont7n)
		
		//oPrn:Box	(0400,1560,0500,1640) // Detalhes
		oPrn:Say  (0430,1540,"Unid..",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.s/Trib.",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.c/Trib.",oFont7n)
		
		//oPrn:Box	(0400,2010,0500,2140) // Detalhes
		oPrn:Say  (0430,2150,"Codigo",oFont7n)
		
		//oPrn:Box	(0400,2140,0500,2790) // Detalhes
		oPrn:Say  (0430,2290,"Fornecedor",oFont7n)
		
		//oPrn:Box	(0400,2790,0500,2890) // Detalhes
		oPrn:Say  (0430,2800,"Codigo",oFont7n)
		
		oPrn:Say  (0430,2900,"Natureza",oFont7n)
	
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->NUMERO			,oFont7) //numero
		//oPrn:Say  (nLinha,0450,TRB1->TIPO			,oFont7) //tipo
		oPrn:Say  (nLinha,0500,TRB1->PRODUTO		,oFont7) //codigo produto
		
		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->QUANTIDADE		,"@E 999,999.9999")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1540,TRB1->UNIDADE		,oFont7) //codigo produto
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VALOR		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VALOR2		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2150,TRB1->CODFORN		,oFont7) //codigo fornecedor	
		//oPrn:Say  (nLinha,2150,TRB1->FORNECEDOR		,oFont7) //codigo fornecedor	
		oPrn:Say  (nLinha,2800,TRB1->NATUREZA		,oFont7) //codigo fornecedor
		oPrn:Say  (nLinha,2900,TRB1->DNATUREZA		,oFont7) //codigo fornecedor
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
		//oPrn:Say	(nLinha,0750,(cTxtLinha),oFont7)
	
		//oPrn:Say  (nLinha,0750,TRB1->HISTORICO		,oFont7) //codigo produto
			
		
		//oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont9,20,,,1) //VALOR SALDO	
		
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo

		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina

oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO Realizado -  " + _cItemConta ,oFont20)
		
		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
		
Return ( Nil )

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Contabilizado Full          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCctb()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCctb"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|zGCRel02(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function zGCRel02()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel02"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC02()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC02()

PrnGCC02()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC02()

	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO CONTABIL -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Conta",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		//oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1420,"Vlr.Debito",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.Credito",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.Saldo",oFont7n)
		
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->CONTA			,oFont7) //numero

		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->VDEBITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VCREDITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VSALDO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               //oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo

oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec2()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO CONTABIL -  " + _cItemConta ,oFont20)
	
Return ( Nil )

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Contabilizado Estoque       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCctbe()

Local nn

Private aPerg :={}
Private cPerg := "PrintGCctbe"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa

Processa({|lEnd|zGCRel03(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil

//********************************************************************************************
Static Function zGCRel03()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel03"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC03()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC03()

PrnGCC03()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC03()
	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CONTABIL ESTOQUE -  " + _cItemConta ,oFont20)
				
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Conta",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		//oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1420,"Vlr.Debito",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.Credito",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.Saldo",oFont7n)
		
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->CONTA			,oFont7) //numero

		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->VDEBITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VCREDITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VSALDO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               //oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
	
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo


oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec3()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO CONTABIL -  " + _cItemConta ,oFont20)
	
Return ( Nil )

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Empenhado Full              ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCdet()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCdet"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa

If alltrim(CAMPO) == "VLREMP" .OR. alltrim(CAMPO) == "VLRPLN" .OR. alltrim(CAMPO) == "VLRVD"
	Processa({|lEnd|zGCRel04(),"Imprimindo Custos de Contrato","AGUARDE.."})
else
	Processa({|lEnd|zGCRel05(),"Imprimindo Custos de Contrato","AGUARDE.."})	
	
endif

Return Nil


//********************************************************************************************


Static Function zGCRel04()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel04"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC01()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC04()

PrnGCC04()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC04()
	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO Realizado -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Numero",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1470,"Qtd.",oFont7n)
		
		//oPrn:Box	(0400,1560,0500,1640) // Detalhes
		oPrn:Say  (0430,1540,"Unid..",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.s/Trib.",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.c/Trib.",oFont7n)
		
		//oPrn:Box	(0400,2010,0500,2140) // Detalhes
		oPrn:Say  (0430,2150,"Codigo",oFont7n)
		
		//oPrn:Box	(0400,2140,0500,2790) // Detalhes
		oPrn:Say  (0430,2290,"Fornecedor",oFont7n)
		
		//oPrn:Box	(0400,2790,0500,2890) // Detalhes
		oPrn:Say  (0430,2800,"Codigo",oFont7n)
		
		oPrn:Say  (0430,2900,"Natureza",oFont7n)
	
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->NUMERO			,oFont7) //numero
		//oPrn:Say  (nLinha,0450,TRB1->TIPO			,oFont7) //tipo
		oPrn:Say  (nLinha,0500,TRB1->PRODUTO		,oFont7) //codigo produto
		
		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->QUANTIDADE		,"@E 999,999.9999")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1540,TRB1->UNIDADE		,oFont7) //codigo produto
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VALOR		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VALOR2		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2150,TRB1->CODFORN		,oFont7) //codigo fornecedor	
		//oPrn:Say  (nLinha,2150,TRB1->FORNECEDOR		,oFont7) //codigo fornecedor	
		oPrn:Say  (nLinha,2800,TRB1->NATUREZA		,oFont7) //codigo fornecedor
		oPrn:Say  (nLinha,2900,TRB1->DNATUREZA		,oFont7) //codigo fornecedor
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
		//oPrn:Say	(nLinha,0750,(cTxtLinha),oFont7)
	
		//oPrn:Say  (nLinha,0750,TRB1->HISTORICO		,oFont7) //codigo produto
			
		
		//oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont9,20,,,1) //VALOR SALDO	
		
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo

		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina

oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec4()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO Realizado -  " + _cItemConta ,oFont20)
		
		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
		
Return ( Nil )

//********************************************

Static Function zGCRel05()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel05"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';

oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)

oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC05()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC05()

PrnGCC05()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC05()
	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pzgina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CONTABIL ESTOQUE -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Conta",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		//oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1420,"Vlr.Debito",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.Credito",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.Saldo",oFont7n)
		
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->CONTA			,oFont7) //numero

		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->VDEBITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VCREDITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VSALDO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               //oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
	
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo


oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec5()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO CONTABIL -  " + _cItemConta ,oFont20)
	
Return ( Nil )


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Contabilizado Full Receita  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCctbr()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCctbr"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|zGCRel06(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function zGCRel06()

Local oDlg       := NIL
Local cString	  := "TRB4"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel02"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Receita de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC06()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC06()

PrnGCC06()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC06()

	
	Local nXi
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB4->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - RECEITA CONTABIL -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Conta",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		//oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1420,"Vlr.Debito",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.Credito",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.Saldo",oFont7n)
		
		oPrn:Say  (nLinha,0070,DTOC(TRB4->RDATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB4->RORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB4->RCONTA			,oFont7) //numero

		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB4->RVDEBITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB4->RVCREDITO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB4->RVSALDO		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		
		For nXi := 1 To MLCount(TRB4->RHISTORICO,40)
	     If ! Empty(MLCount(TRB4->RHISTORICO,40))
		          If ! Empty(MemoLine(TRB4->RHISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB4->RHISTORICO,40,nXi)),oFont7)
		               //oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
	
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB4->(dbSkip())
	
		EndDo


oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec6()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - RECEITA CONTABIL -  " + _cItemConta ,oFont20)
	
Return ( Nil )


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - Vendido   Full              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCvd()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCvd"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|zGCRel07(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function zGCRel07()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel07"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC07()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC07()

PrnGCC07()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC07()

	Local nXi
	
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO VENDIDO -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Numero",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1470,"Qtd.",oFont7n)
		
		//oPrn:Box	(0400,1560,0500,1640) // Detalhes
		oPrn:Say  (0430,1540,"Unid..",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.s/Trib.",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.c/Trib.",oFont7n)
		
		//oPrn:Box	(0400,2010,0500,2140) // Detalhes
		oPrn:Say  (0430,2150,"Codigo",oFont7n)
		
		//oPrn:Box	(0400,2140,0500,2790) // Detalhes
		oPrn:Say  (0430,2290,"Fornecedor",oFont7n)
		
		//oPrn:Box	(0400,2790,0500,2890) // Detalhes
		oPrn:Say  (0430,2800,"Codigo",oFont7n)
		
		oPrn:Say  (0430,2900,"Natureza",oFont7n)
	
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->NUMERO			,oFont7) //numero
		//oPrn:Say  (nLinha,0450,TRB1->TIPO			,oFont7) //tipo
		oPrn:Say  (nLinha,0500,TRB1->PRODUTO		,oFont7) //codigo produto
		
		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->QUANTIDADE		,"@E 999,999.9999")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1540,TRB1->UNIDADE		,oFont7) //codigo produto
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VALOR		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VALOR2		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2150,TRB1->CODFORN		,oFont7) //codigo fornecedor	
		//oPrn:Say  (nLinha,2150,TRB1->FORNECEDOR		,oFont7) //codigo fornecedor	
		oPrn:Say  (nLinha,2800,TRB1->NATUREZA		,oFont7) //codigo fornecedor
		oPrn:Say  (nLinha,2900,TRB1->DNATUREZA		,oFont7) //codigo fornecedor
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
		//oPrn:Say	(nLinha,0750,(cTxtLinha),oFont7)
	
		//oPrn:Say  (nLinha,0750,TRB1->HISTORICO		,oFont7) //codigo produto
			
		
		//oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont9,20,,,1) //VALOR SALDO	
		
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo

		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina

oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec7()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO VENDIDO -  " + _cItemConta ,oFont20)
		
		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
		
Return ( Nil )


/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������͹��
���Desc.     � Impressao Custos de Contrato - PLANEJADO   Full            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PRNGCpl()


Local nn

Private aPerg :={}
Private cPerg := "PrintGCpl"
Private OPrint
Private aDados
Private nTotal := 0
Private cObserv    := ""
Private nItem   := 0
Private cCCusto
Private cConta
Private cMapa


Processa({|lEnd|zGCRel08(),"Imprimindo Custos de Contrato","AGUARDE.."})

Return Nil


//********************************************************************************************


Static Function zGCRel08()

Local oDlg       := NIL
Local cString	  := "TRB1"

Private titulo  	:= ""
Private nLastKey 	:= 0
Private cPerg	  	:= "zGCRel08"
Private nomeProg 	:= FunName()

Private cTitulo  := "Impressao do Relatorio de Custos de Contratos"
Private oPrn     := NIL
Private nLin     := 1650 // Linha de inicio da impressao das clausulas contratuais
Private oFont6,oFont6n, oFont7, oFont8,oFont8n,oFont9,oFont9n,oFont10,oFont10n,oFont11o,oFont14,oFont16,oFont12,oFont11,oFont12n,oFont16n,oFont14n,oFont20
Private cFileLogo,oBrush,oBrush2


DEFINE FONT oFont1 NAME "Calibri" SIZE 0,20 BOLD   Of oPrn
DEFINE FONT oFont2 NAME "Calibri" SIZE 0,14 BOLD   Of oPrn
DEFINE FONT oFont3 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont4 NAME "Calibri" SIZE 0,14 ITALIC Of oPrn
DEFINE FONT oFont5 NAME "Calibri" SIZE 0,14        Of oPrn
DEFINE FONT oFont6 NAME "Calibri" SIZE 0,14        Of oPrn

oFont6	 	:= TFont():New("Calibri",06,06,,.F.,,,,.T.,.F.)
oFont7	 	:= TFont():New("Calibri",07,07,,.F.,,,,.T.,.F.)
oFont7n	 	:= TFont():New("Calibri",07,07,,.T.,,,,.T.,.F.)
oFont8	 	:= TFont():New("Calibri",08,08,,.F.,,,,.T.,.F.)
oFont8n  	:= TFont():New("Calibri",08,08,,.T.,,,,.T.,.F.)
oFont9	 	:= TFont():New("Calibri",09,09,,.F.,,,,.T.,.F.)
oFont9n  	:= TFont():New("Calibri",09,09,,.T.,,,,.T.,.F.)
oFont10	 	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont11   	:= TFont():New("Calibri",11,11,,.F.,,,,.T.,.F.)
oFont14	 	:= TFont():New("Calibri",14,14,,.F.,,,,.T.,.F.)
oFont16	 	:= TFont():New("Calibri",16,16,,.F.,,,,.T.,.F.)
oFont10n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont12   	:= TFont():New("Calibri",10,10,,.F.,,,,.T.,.F.)
oFont12n  	:= TFont():New("Calibri",10,10,,.T.,,,,.T.,.F.)
oFont16n  	:= TFont():New("Calibri",16,16,,.T.,,,,.T.,.F.)
oFont14n  	:= TFont():New("Calibri",14,14,,.T.,,,,.T.,.F.)
oFont6n  	:= TFont():New("Calibri",06,06,,.T.,,,,.T.,.F.)
oFont20  	:= TFont():New("Calibri",20,20,,.T.,,,,.T.,.F.)
cFileLogo	:= GetSrvProfString('Startpath','') + 'LOGORECH02' + '.BMP';


oBrush := TBrush():NEW("",CLR_HGRAY)
oBrush2 := TBrush():NEW("",CLR_HGRAY)


oPrn := TMSPrinter():New( cTitulo )
oPrn:Setup()
oPrn:SetLandsCape()                //SetPortrait() //SetLansCape()
oPrn:StartPage()

PrintGC08()

oPrn:EndPage()
oPrn:End()

oPrn:Preview()

//DEFINE MSDIALOG oDlg FROM 264,182 TO 441,613 TITLE cTitulo OF oDlg PIXEL

@ 004,010 TO 082,157 LABEL "" OF oDlg PIXEL

oPrn:End()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrintGC08()

PrnGCC08()
Ms_Flush()

Return( NIL )

//--------------------------------------------------------------------------------------------

Static Function PrnGCC08()

	Local nXi
	
	Private nLinha := 0
	Private nCont  := 0
	Private nCont1 := 1
	Private Cont   := 1
	Private Cont1  := 1
	
	cOperUnit 	:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XEQUIP"))
	cClient		:= alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XCLIENT"))
	cNRedu		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNREDU"))
	cIDPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XIDPM"))
	CNomPM		:= Alltrim(Posicione("CTD",1,xFilial("CTD")+_cItemConta,"CTD_XNOMPM"))

	cFileLogo := "lgrl" + cEmpAnt + ".bmp"

	oPrn:StartPage()
	
	nCont	:= 0

	//**********
	If Cont > Cont1
		
		nCont1 := nCont1 + 1
		cabec()
		Cont := 1
	Endif
	Cont := Cont + 1

	lCrtPag	:= .T.
	nLinMax	:= 32
	nLinAtu	:= 1
  
  	If lCrtPag
  		
		nCont := nCont + 1
	Endif
	
	nLinha    := 0500
	nLinha2   := 0500

	While ! TRB1->( Eof() ) //.AND. TRB1->CAMPO == "VLREMP"
		
		if nLinha > 2200 .OR. nLinha == 0   
			if nLinha <> 0	
				oPrn:Say  (2300,3000,"Pagina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
			  	If lCrtPag
					nCont := nCont + 1
					nCont1 := nCont1 + 1
				Endif
				
				nLinha  := 0500
				oPrn:EndPage()		
			endif
		End if
		
		oPrn:Box	(0050,0050,0400,3350) //Box Cabe�a

		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO PLANEJADO -  " + _cItemConta ,oFont20)
		
		
		oPrn:Box	(0050,2900,0190,3350) // Data Emissao
		oPrn:Say  (0080,3000,"Data Emissao " ,oFont12)
		oPrn:Say  (0120,3000,DTOC(DDatabase) ,oFont12)
		
		oPrn:Box	(0190,0050,0300,1190) // Detalhes
		oPrn:Say  (0220,0060,"Cliente: " + cClient + " - " + cNRedu ,oFont9n)
		
		oPrn:Box	(0190,1190,0300,2190) // Detalhes
		oPrn:Say  (0220,1200,"Coordenador: " + cIDPM + " - " + CNomPM ,oFont9n)
		
		oPrn:Box	(0190,2190,0300,3300) // Detalhes
		oPrn:Say  (0220,2200,"Operacao Unitaria: " + cOperUnit ,oFont9n)
		
		oPrn:Box	(0300,0050,0400,0640) // Detalhes
		oPrn:Say  (0320,0060,"Venda c/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,0640,0400,1240) // Detalhes
		oPrn:Say  (0320,0650,"s/ Trib.: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1240,0400,1740) // Detalhes
		oPrn:Say  (0320,1250,"s/ Trib. (s/Frete):: " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,1740,0400,2240) // Detalhes
		oPrn:Say  (0320,1750,"Venda c/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99")  ,oFont8n)
		
		oPrn:Box	(0300,2240,0400,2740) // Detalhes
		oPrn:Say  (0320,2250,"s/ Trib. (Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0300,2740,0400,3300) // Detalhes	
		oPrn:Say  (0320,2750,"s/ Trib.(s/Frete - Rev.): " + transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) ,oFont8n)
		
		oPrn:Box	(0400,0050,0500,3350) // Detalhes
		//oPrn:Box	(0400,0050,0500,0200) // Detalhes
		oPrn:Say  (0430,0070,"Data",oFont7n)
		
		//oPrn:Box	(0400,0200,0500,0290) // Detalhes
		oPrn:Say  (0430,0220,"Origem",oFont7n)
		
		//oPrn:Box	(0400,0290,0500,0440) // Detalhes
		oPrn:Say  (0430,0350,"Numero",oFont7n)
		
		//oPrn:Box	(0400,0440,0500,0740) // Detalhes
		oPrn:Say  (0430,0500,"Produto",oFont7n)
		
		//oPrn:Box	(0400,0740,0500,1440) // Detalhes
		oPrn:Say  (0430,0790,"Historico",oFont7n)
		
		//oPrn:Box	(0400,1440,0500,1560) // Detalhes
		oPrn:Say  (0430,1470,"Qtd.",oFont7n)
		
		//oPrn:Box	(0400,1560,0500,1640) // Detalhes
		oPrn:Say  (0430,1540,"Unid..",oFont7n)
		
		//oPrn:Box	(0400,1640,0500,1890) // Detalhes
		oPrn:Say  (0430,1720,"Vlr.s/Trib.",oFont7n)
		
		//oPrn:Box	(0400,1890,0500,2010) // Detalhes
		oPrn:Say  (0430,2000,"Vlr.c/Trib.",oFont7n)
		
		//oPrn:Box	(0400,2010,0500,2140) // Detalhes
		oPrn:Say  (0430,2150,"Codigo",oFont7n)
		
		//oPrn:Box	(0400,2140,0500,2790) // Detalhes
		oPrn:Say  (0430,2290,"Fornecedor",oFont7n)
		
		//oPrn:Box	(0400,2790,0500,2890) // Detalhes
		oPrn:Say  (0430,2800,"Codigo",oFont7n)
		
		oPrn:Say  (0430,2900,"Natureza",oFont7n)
	
		oPrn:Say  (nLinha,0070,DTOC(TRB1->DATAMOV)	,oFont7) //data movimento
		oPrn:Say  (nLinha,0220,TRB1->ORIGEM			,oFont7) //origem
		oPrn:Say  (nLinha,0350,TRB1->NUMERO			,oFont7) //numero
		//oPrn:Say  (nLinha,0450,TRB1->TIPO			,oFont7) //tipo
		oPrn:Say  (nLinha,0500,TRB1->PRODUTO		,oFont7) //codigo produto
		
		oPrn:Say  (nLinha,1520,Alltrim(Transform(TRB1->QUANTIDADE		,"@E 999,999.9999")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,1540,TRB1->UNIDADE		,oFont7) //codigo produto
		oPrn:Say  (nLinha,1820,Alltrim(Transform(TRB1->VALOR		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2120,Alltrim(Transform(TRB1->VALOR2		,"@E 999,999,999.99")),oFont7,20,,,1) //quantidade
		oPrn:Say  (nLinha,2150,TRB1->CODFORN		,oFont7) //codigo fornecedor	
		//oPrn:Say  (nLinha,2150,TRB1->FORNECEDOR		,oFont7) //codigo fornecedor	
		oPrn:Say  (nLinha,2800,TRB1->NATUREZA		,oFont7) //codigo fornecedor
		oPrn:Say  (nLinha,2900,TRB1->DNATUREZA		,oFont7) //codigo fornecedor
		
		For nXi := 1 To MLCount(TRB1->HISTORICO,40)
	     If ! Empty(MLCount(TRB1->HISTORICO,40))
		          If ! Empty(MemoLine(TRB1->HISTORICO,40,nXi))
		               oPrn:Say(nLinha,0790,OemToAnsi(MemoLine(TRB1->HISTORICO,40,nXi)),oFont7)
		               oPrn:Say(nLinha,2290,OemToAnsi(MemoLine(TRB1->FORNECEDOR,35,nXi)),oFont7)
		               nLinha+=40
		          EndIf
		     EndIf
	     Next nXi
	     
	     oPrn:Box	(nLinha+2,0050,nLinha+2,3350) // logo
	    
		//oPrn:Say	(nLinha,0750,(cTxtLinha),oFont7)
	
		//oPrn:Say  (nLinha,0750,TRB1->HISTORICO		,oFont7) //codigo produto
			
		
		//oPrint:Say  (nPosicao,2300, Alltrim(Transform(TRB2->VLRSLD,"@E 999,999,999.99")),oFont9,20,,,1) //VALOR SALDO	
		
		oPrn:Say  (2300,0070,"LEGENDA ORIGEM: VD - Vendido / PL - Planejado / OC - Ordem de Compra / DE - Documento de Entrada / DR - Rateio Documento de Entrada / FN - Financeiro / FR - Financeiro Rateio / HR - Apontamento de Horas / EQ - Estoque / CC - Contabil Custo / CE - Contabil Estoque ",oFont7)
		
		
		nLinha+=0010
		nLinha2+=0010
		
		TRB1->(dbSkip())
	
		EndDo

		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina

oPrn:EndPage()

DbGoTop()

Return( NIL )

Static Function cabec8()
	oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:Box	(0050,0050,0190,0740) // logo
		oPrn:SayBitmap(0060,0060,cFileLogo,630,90)
		oPrn:Say  ( 0150,0210,"Equipamentos Industriais Ltda" ,oFont8n) // Nome da empresa //****UPPER(ALLTRIM(aDadosEmp[1])

		// Ordem de Compra
		oPrn:Box	(0050,0740,0190,2900) // Titulo Pedido
		oPrn:Say  (0070,0760,"GESTAO DE CONTRATO - CUSTO PLANEJADO -  " + _cItemConta ,oFont20)
		
		//oPrn:Say  (2300,3000,"P�gina: " + Transform(StrZero(nCont1,3),"")		,oFont7) //numero de pagina
		
Return ( Nil )

//************* Estrutura Planejamento ********************

static function zEstruPLN()

local aSays		:=	{}
local aButtons 	:= 	{}
local nOpca 	:= 	0
local cCadastro	:= 	"Custo de Contratos"
local _cOldData	:= 	dDataBase // Grava a database

private cPerg 	:= 	"GCIN01"
private _cArq	:= 	"GCIN01.XLS"
private CR 		:= chr(13)+chr(10)
private _cFilCTD:= xFilial("CTD")

private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cItemConta := CTD->CTD_ITEM
private _cFilial 	:= ALLTRIM(CTD->CTD_FILIAL)

private _cNProp
private _cCodCoord
private _cNomCoord

private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
private cArqTrb4 := CriaTrab(NIL,.F.)


Private _aGrpSint:= {}

//ValidPerg()

//FormBatch( cCadastro, aSays, aButtons )

// Se confirmado o processamento
//if nOpcA == 1

	_cItemConta 	:= CTD->CTD_ITEM
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZC->ZC_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZD")
	dbSetOrder(3)
	//SET FILTER TO alltrim(SZD->ZD_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZO")
	dbSetOrder(4)
	//SET FILTER TO alltrim(SZO->ZO_ITEMIC) = '_cItemConta'
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	//SET FILTER TO alltrim(SZU->ZU_ITEMIC) = '_cItemConta'


	MntEstru()

//endif


return


static function MntEstru()
//Local oGet1
Local oGet1 := Space(13)
Local nposi

Local IMAGE1 := "FOLDER5"
Local IMAGE2 := "FOLDER6"
Local IMAGE3 := "FOLDER7"
Local aNodes := {}

Local oGreen   	:= LoadBitmap( GetResources(), "BR_VERDE")
Local oRed    	:= LoadBitmap( GetResources(), "BR_VERMELHO")
Local oBlack	:= LoadBitmap( GetResources(), "BR_PRETO")
Local oYellow	:= LoadBitmap( GetResources(), "BR_AMARELO")
Local oBrown	:= LoadBitmap( GetResources(), "BR_MARROM")
Local oBlue		:= LoadBitmap( GetResources(), "BR_AZUL")
Local oOrange	:= LoadBitmap( GetResources(), "BR_LARANJA")
Local oViolet	:= LoadBitmap( GetResources(), "BR_VIOLETA")
Local oPink		:= LoadBitmap( GetResources(), "BR_PINK")
Local oGray		:= LoadBitmap( GetResources(), "BR_CINZA")

private _cItemConta := CTD->CTD_ITEM
private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ]+78, aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oDlgSint

	cCadastro :=  "Gestao de Contratos - Planejamento - " + _cItemConta

	DEFINE MSDIALOG _oDlgSint ;
	TITLE "Gestao de Contratos - Sintetico - " + _cItemConta ;
	From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"
	
	// Cria a Tree
	
	oTree := DbTree():New(aPosObj[1,1]+30,aPosObj[1,2],aPosObj[1,3],aPosObj[1,4],_oDlgSint,,,.T.)
	
	nX0 := 0
	nX1 := 1
	nX2 := 2
	nX3 := 3
	nX4 := 4
	aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"","[N0] " + AllTrim(_cItemConta),IMAGE1,IMAGE2})  
	
	nX0++
	nX1++
	
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	dbSelectArea("SZC")
	dbSetOrder(2)
	
	dbSelectArea("SZD")
	dbSetOrder(3)
		
	dbSelectArea("SZO")
	dbSetOrder(4)
	
	dbSelectArea("SZU")
	dbSetOrder(2)
	
	
	SZC->(dbgotop())
	
	//msginfo( cValToChar(nX0) )
	//msginfo( cValToChar(nX1) )
	
	If SZC->(dbSeek(_cItemConta)) //********
	
	While SZC->(!eof()) .AND. ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)
		
		if ALLTRIM(SZC->ZC_ITEMIC) == alltrim(_cItemConta)	
			
			
			cIDPlan := alltrim(SZC->ZC_IDPLAN)
			
			//msginfo( "nivel 2: " +  cValToChar(nX0) + " - " + cIDPlan + " " + _cItemConta )
			//msginfo( "nivel 2: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta )
			
			aadd(aNodes,{cValToChar(nX0),cValtoChar(nX1),"","[N1]" ;
			+ ALLTRIM(SZC->ZC_IDPLAN) + space(5) ;
			+ ALLTRIM(SZC->ZC_DESCRI) + space(5) ;
			+ SPACE(40 - LEN(ALLTRIM(SZC->ZC_DESCRI)) ) + space(5) ;
			+ "Qtd: " + alltrim(transform(SZC->ZC_QUANTR ,"@E 999,999,999.99")) + space(5) ;
			+ "Vlr.Unit.: " + alltrim(transform(SZC->ZC_UNITR ,"@E 999,999,999.99")) + space(5) ;
			+ "Total.: " + alltrim(transform(SZC->ZC_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
			nX1++
			
			
			SZD->(dbgotop())
			
			If SZD->(dbSeek(_cItemConta)) //********
				
			While SZD->(!eof()) .AND. ALLTRIM(SZD->ZD_ITEMIC) == alltrim(_cItemConta)
			
				if ALLTRIM(SZD->ZD_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZD->ZD_IDPLAN) == alltrim(cIDPlan) 
					//msginfo( "nivel 3: " +  cValToChar(nX2)  + " - " + cIDPlan + " " + _cItemConta  )
					//msginfo( "nivel 3: " + cValToChar(nX1)  + " - " + cIDPlan + " " + _cItemConta  )
					//+ "IDN1:" + ALLTRIM(SZD->ZD_IDPLAN) + space(5) ;
					
					cIDPLSUB := alltrim(SZD->ZD_IDPLSUB)
					aadd(aNodes,{cValToChar(nX2),cValtoChar(nX1),"","[N2]" ;
					+ ALLTRIM(SZD->ZD_IDPLSUB) + space(5) ;
					+ alltrim(SZD->ZD_DESCRI) + space(5) ;
					+ SPACE(40 - LEN(ALLTRIM(SZD->ZD_DESCRI)) ) + space(5) ;
					+ "Qtd: " + alltrim(transform(SZD->ZD_QUANTR ,"@E 999,999,999.99")) + space(5) ;
					+ "Vlr.Unit.: " + alltrim(transform(SZD->ZD_UNITR ,"@E 999,999,999.99")) + space(5) ;
					+ "Total.: " + alltrim(transform(SZD->ZD_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2})  
					nX1++
					
					//***************************
					
					SZO->(dbgotop())
					If SZO->(dbSeek(_cItemConta)) //********
					
					While SZO->(!eof()) .AND. ALLTRIM(SZO->ZO_ITEMIC) == alltrim(_cItemConta)
					 
						if ALLTRIM(SZO->ZO_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZO->ZO_IDPLSUB) == alltrim(cIDPLSUB) 
							
							//msginfo( "nivel 4: " +  cValToChar(nX3)  + " - " + cIDPLSUB + " " + _cItemConta  )
							//msginfo( "nivel 4: " + cValToChar(nX1)  + " - " + cIDPLSUB + " " + _cItemConta  )
							//+ "IDN2:" + ALLTRIM(SZO->ZO_IDPLSUB) + space(5) ;
							
							cIDPLSB2 := alltrim(SZO->ZO_IDPLSB2)
							aadd(aNodes,{cValToChar(nX3),cValtoChar(nX1),"","[N3]" ; 	
							+ ALLTRIM(SZO->ZO_IDPLSB2) + space(5) ;
							+ ALLTRIM(SZO->ZO_DESCRI) + space(5) ;
							+ SPACE(40 - LEN(ALLTRIM(SZO->ZO_DESCRI)) ) + space(5) ;
							+ "Qtd: " + alltrim(transform(SZO->ZO_QUANTR ,"@E 999,999,999.99")) + space(5) ;
							+ "Vlr.Unit.: " + alltrim(transform(SZO->ZO_UNITR ,"@E 999,999,999.99")) + space(5) ;
							+ "Total.: " + alltrim(transform(SZO->ZO_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
							nX1++
							
							//**************************				
							SZU->(dbgotop())
							
							If SZU->(dbSeek(_cItemConta)) //********
							
							While SZU->(!eof()) .AND. ALLTRIM(SZU->ZU_ITEMIC) == alltrim(_cItemConta)
							
								if ALLTRIM(SZU->ZU_ITEMIC) == ALLTRIM(_cItemConta) .AND. ALLTRIM(SZU->ZU_IDPLSB2) == alltrim(cIDPLSB2) 
								
									//msginfo( "nivel 5: " +  cValToChar(nX4)  + " - " + cIDPLSB2 + " " + _cItemConta  )
									//msginfo( "nivel 5: " + cValToChar(nX1)  + " - " + cIDPLSB2 + " " + _cItemConta  )
									//+ "IDN3:" + ALLTRIM(SZU->ZU_IDPLSB2) + space(5) ;
									
									aadd(aNodes,{cValToChar(nX4),cValtoChar(nX1),"","[N4]" ;
									+ ALLTRIM(SZU->ZU_IDPLSB3) + space(5);
									+ ALLTRIM(SZU->ZU_DESCRI) + space(5) ;
									+ SPACE(40 - LEN(ALLTRIM(SZU->ZU_DESCRI)) ) + space(5) ;
									+ "Qtd: " + alltrim(transform(SZU->ZU_QUANTR ,"@E 999,999,999.99")) + space(5) ;
									+ "Vlr.Unit.: " + alltrim(transform(SZU->ZU_UNITR ,"@E 999,999,999.99")) + space(5) ;
									+ "Total.: " + alltrim(transform(SZU->ZU_TOTALR ,"@E 999,999,999.99")) ,IMAGE1,IMAGE2}) 
									nX1++
									
								endif
								SZU->(dbSkip())
							enddo
							
							ENDIF
							///******************************
						
						endif
						SZO->(dbSkip())
					enddo
					
					ENDIF
					//****************************
				
				endif
				SZD->(dbSkip())
			enddo
			
			ENDIF
			
			
		endif
		SZC->(dbSkip())
		
	enddo
	
	ENDIF //*****
	oTree:PTSendTree( aNodes )


oGroup1:= TGroup():New(0029,0015,0053,0730,'',_oDlgSint,,,.T.)
oGroup2:= TGroup():New(0054,0015,0080,0345,'Venda',_oDlgSint,,,.T.)
oGroup3:= TGroup():New(0054,0350,0080,0730,'Venda Revisado',_oDlgSint,,,.T.)

oGroup4:= TGroup():New(0081,0015,0110,0345,'Custo Vendido',_oDlgSint,,,.T.)
oGroup5:= TGroup():New(0081,0350,0110,0730,'Custo Revisado',_oDlgSint,,,.T.)

@ 0030,0020 Say  "Item Conta: " COLORS 0, 16777215 PIXEL
@ 0038,0020 MSGET  _cItemConta  COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0120 Say  "No.Proposta: "  COLORS 0, 16777215 PIXEL
@ 0038,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_NPROP")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0200 Say  "Cod.Cliente: " 	 COLORS 0, 16777215 PIXEL
@ 0038,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCLIEN")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0280 Say  "Cliente: " COLORS 0, 16777215 PIXEL
@ 0038,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNREDU")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0480 Say  "Coord.Cod.: " COLORS 0, 16777215 PIXEL
@ 0038,0480 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XIDPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0030,0540 Say  "Coordenador " 	COLORS 0, 16777215 PIXEL
@ 0038,0540 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNOMPM")) COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0058,0040 Say  "c/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0100 Say  "s/ Tributos " 	COLORS 0, 16777215 PIXEL
@ 0066,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0160 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0220 Say  "c/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0220 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0280 Say  "s/ Tributos US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0058,0400 Say  "c/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0460 Say  "s/ Tributos  " 	COLORS 0, 16777215 PIXEL
@ 0066,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0520 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 PIXEL
@ 0066,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0580 Say  "c/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0058,0640 Say  "s/ Tributos  US$ " 	COLORS 0, 16777215 PIXEL
@ 0066,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0087,0040 Say  "Producao " 	COLORS 0, 16777215 PIXEL
@ 0095,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTO"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0100 Say  "COGS Vendido " 	COLORS 0, 16777215 PIXEL
@ 0095,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0160 Say  "Total " 	COLORS 0, 16777215 PIXEL
@ 0095,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOT"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0220 Say  "Data Cambio " 	COLORS 0, 16777215 PIXEL
@ 0095,0220 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XDTCB")) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0280 Say  "Vlr. Cambio " 	COLORS 0, 16777215 PIXEL
@ 0095,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCAMB"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.


@ 0087,0400 Say  "Producao " 	COLORS 0, 16777215 PIXEL
@ 0095,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0460 Say  "COGS REV. " 	COLORS 0, 16777215 PIXEL
@ 0095,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0520 Say  "Total" 	COLORS 0, 16777215 PIXEL
@ 0095,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.

@ 0087,0580 Say  "Verba adicional" 	COLORS 0, 16777215 PIXEL
@ 0095,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVBAD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 PIXEL VALID !Vazio() WHEN .F.
/*
TButton():New( 0120,0020,"Alterar do item", _oDlgSint,{|| ;
         zAltPlanj() },;
		 60,12,,,.F.,.T.,.F.,,.F.,,,.F. )
		 
TButton():New( 0120,0100,"Atualizar", _oDlgSint,{|| ;
         DBTree():PTRefresh()  },;
		 60,12,,,.F.,.T.,.F.,,.F.,,,.F. )
*/
ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| _oDlgSint:End()}, {||_oDlgSint:End()},, aButton)


/*
CTD->(dbclosearea())
SZC->(dbclosearea())
SZD->(dbclosearea())
SZO->(dbclosearea())
SZU->(dbclosearea())
*/

return

static function zAltPlanj()
	local  cRegistro := substr(oTree:GetCargo()+oTree:GetPrompt(.T.),5,9)
	local  cNivel	 := substr(oTree:GetCargo()+oTree:GetPrompt(.T.),1,4)
    Local aArea       := GetArea()
    Local aAreaZC     := SZC->(GetArea())
    Local aAreaZD     := SZD->(GetArea())
    Local aAreaZO     := SZO->(GetArea())
    Local aAreaZU     := SZU->(GetArea())
    Local nOpcao      := 0
      
    Private cCadastro 
    
    //msginfo( cRegistro+_cItemConta )
    
    IF cNivel == "[N1]"  
    	
    	cCadastro := "Alteracao Nivel 1"
    
	    DbSelectArea("SZC")
	    SZC->(DbSetOrder(3)) //B1_FILIAL + B1_COD
	    SZC->(DbGoTop())
	     
	    //Se conseguir posicionar no produto
	    If SZC->(DbSeek(xFilial('SZC')+cRegistro+_cItemConta))
	    	
	        nOpcao := fAltRegSZC()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	           
	        EndIf
	       
	    EndIf
	ENDIF
	
	IF cNivel == "N2"  
		cCadastro := "Alteracao Nivel 2"

	    DbSelectArea("SZD")
	    SZD->(DbSetOrder(4)) //B1_FILIAL + B1_COD
	  
		if SZD->(DbSeek(xFilial("SZD")+cRegistro+_cItemConta) )
			
	        nOpcao := zAltRegSZD()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	           	       
	        EndIf
	    endif
	ENDIF
		
	IF cNivel == "N3"  

		cCadastro := "Alteracao Nivel 3"
	
	    DbSelectArea("SZO")
	    SZO->(DbSetOrder(5)) //B1_FILIAL + B1_COD
	    SZO->(DbGoTop())
	    
	    //Se conseguir posicionar no produto
	    If SZO->(DbSeek(xFilial("SZO")+cRegistro+_cItemConta ))
	       nOpcao := fAltRegSZO()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	    EndIf
	    
	ENDIF
	
	IF cNivel == "N4"  

		cCadastro := "Alteracao Nivel 4"
	
	    DbSelectArea("SZU")
	    SZU->(DbSetOrder(3)) //B1_FILIAL + B1_COD
	    SZU->(DbGoTop())
	    
	    //Se conseguir posicionar no produto
	    If SZU->(DbSeek(xFilial("SZU")+cRegistro+_cItemConta ))
	       nOpcao := fAltRegSZU()
	        If nOpcao == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	    EndIf
	    
	ENDIF
	
	IF !cNivel $ "[N1]/[N2]"  
		 MsgInfo("Registro nao pode ser alterado...", "Atencao")
	ENDIF
   
	oTree:PTRefresh()
   
    RestArea(aAreaZC)
    RestArea(aAreaZD)
    RestArea(aAreaZO)
    RestArea(aAreaZU)
    RestArea(aArea)
Return

// Altera��o registro Contas a Receber
static Function fAltRegSZC()
Local oButton1
Local oButton2
Local oGet1
Local cGet1 := SZC->ZC_IDPLAN

Local oGet2
Local cGet2	:= _cItemConta

Local oGet3
Local cGet3 := SZC->ZC_DESCRI

Local oGet5
Local cGet5	:= SZC->ZC_UMR

Local oPanel1
Local oPanel2
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local _nOpc := 0

private oGet6
private nGet6	:= SZC->ZC_UNITR

private oGet4
private nGet4	:= SZC->ZC_QUANTR

private oGet7
private nGet7	:= SZC->ZC_TOTALR

Static _oDlg

  DEFINE MSDIALOG _oDlg TITLE "Altera Planejamento Nivel 1" FROM 000, 000  TO 200, 520 COLORS 0, 16777215 PIXEL

  	oGroup1:= TGroup():New(0002,0005,081,0258,'',_oDlg,,,.T.)

    @ 004, 010 SAY oSay1 PROMPT "IDPLAN" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 012, 010 MSGET oGet1 VAR cGet1 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 004, 070 SAY oSay2 PROMPT "Item Conta" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 012, 070 MSGET oGet2 VAR cGet2 When .F. SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 026, 010 SAY oSay3 PROMPT "Descricao" SIZE 032, 007 COLORS 0, 16777215 PIXEL
    @ 034, 010 MSGET oGet3 VAR cGet3 When .T. SIZE 242, 010  COLORS 0, 16777215 PIXEL
    
    @ 054, 010 SAY oSay4 PROMPT "Quantidade" SIZE 032, 007  COLORS 0, 16777215 PIXEL 
    @ 062, 010 MSGET oGet4 VAR  nGet4 PICTURE PesqPict("SZC","ZC_QUANTR") When .T. SIZE 070, 010 OF  COLORS 0, 16777215 PIXEL Valid Calcular(nGet4, nGet6) 
    
    @ 054, 090 SAY oSay5 PROMPT "Unidade" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 062, 090 MSGET oGet5 VAR cGet5 When .T. SIZE 015, 010  COLORS 0, 16777215 PIXEL
     
    @ 054, 120 SAY oSay6 PROMPT "Vlr.Unitario" SIZE 032, 007  COLORS 0, 16777215 PIXEL
    @ 062, 120 MSGET oGet6 VAR  nGet6 PICTURE PesqPict("SZC","ZC_UNITR") When .T. SIZE 060, 010  COLORS 0, 16777215 PIXEL Valid Calcular(nGet4,nGet6) 
    
        
    @ 054, 190 SAY oSay7 PROMPT "Total" SIZE 032, 007 COLORS 0, 16777215 PIXEL
    @ 062, 190 MSGET oGet7 VAR  Transform(nGet7,"@R 99,999,999.99")  When .F. SIZE 060, 010 COLORS 0, 16777215 PIXEL //Valid Calcular(nGet4, nGet6) 
 
    @ 085, 100 BUTTON oButton1 PROMPT "Cancelar" Action( _oDlg:End() ) SIZE 034, 010  PIXEL
    @ 085, 150 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End() ) SIZE 034, 010 PIXEL
    //@ 085, 150 BUTTON oButton3 PROMPT "Calcular" SIZE 034, 010 OF _oDlg PIXEL Action Calcular(nGet4, nGet6) 
    
  ACTIVATE MSDIALOG _oDlg CENTERED


  If _nOpc = 1
  	Reclock("SZC",.F.)
  	//SE1->E1_VENCTO 	:= dVencto
  	SZC->ZC_DESCRI  := cGet3
  	SZC->ZC_QUANTR  := nGet4 //Proximo dia �til
  	SZC->ZC_UMR		:= cGet5
  	SZC->ZC_UNITR	:= nGet6
  	SZC->ZC_TOTALR	:= nGet7
  	
  	MsUnlock()
  	
  Endif
  
  oTree:PTRefresh()
/*  
  Reclock("TRB1",.F.)
	if alltrim(oGet5) <> "PR"
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	else
		TRB1->DATAMOV := dVencto
		TRB1->DATAMOV2 := dVencto
		TRB1->VALOR := nValor
		TRB1->CAMPO		:= RetCampo(dVencto)
		TRB1->GRUPONAT	:= oGet6
	endif
  MsUnlock()
  */
Return _nOpc	

Static Function Calcular(nGet4, nGet6) 


//Local nQtde := nGet4 
//Local nValor := nGet6 
Local nSal 
nGet4	:= nGet4
nGet6	:= nGet6 

nSal   := nGet4 * nGet6 
nGet7 := nSal //  AllTrim(STR(nSal))
oGet7:Refresh()  

Return .T.
