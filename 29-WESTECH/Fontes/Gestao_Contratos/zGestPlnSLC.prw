#include "rwmake.ch"
#include "topconn.ch"
#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH'
#include "ap5mail.ch"
#INCLUDE "TOTVS.CH"

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                        Low Intensity colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_BLACK             0               // RGB(   0,   0,   0 ) 
#define CLR_BLUE        8388608               // RGB(   0,   0, 128 ) 
#define CLR_GREEN        32768               // RGB(   0, 128,   0 ) 
#define CLR_CYAN        8421376               // RGB(   0, 128, 128 ) 
#define CLR_RED             128               // RGB( 128,   0,   0 ) 
#define CLR_MAGENTA     8388736               // RGB( 128,   0, 128 ) 
#define CLR_BROWN        32896               // RGB( 128, 128,   0 ) 
#define CLR_HGRAY      12632256               // RGB( 192, 192, 192 ) 
#define CLR_LIGHTGRAY CLR_HGRAY 

//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 
//                      High Intensity Colors 
//ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ// 

#define CLR_GRAY        8421504               // RGB( 128, 128, 128 ) 
#define CLR_HBLUE      16711680               // RGB(   0,   0, 255 ) 
#define CLR_HGREEN        65280               // RGB(   0, 255,   0 ) 
#define CLR_HCYAN      16776960               // RGB(   0, 255, 255 ) 
#define CLR_HRED            255               // RGB( 255,   0,   0 ) 
#define CLR_HMAGENTA   16711935               // RGB( 255,   0, 255 ) 
#define CLR_YELLOW        65535               // RGB( 255, 255,   0 ) 
#define CLR_WHITE      16777215               // RGB( 255, 255, 255 ) 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Gera arquivo de Gestao de Contratos                        º±±
±±º          ³                                                            º±±
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºUso       ³ Especifico 		                                  º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
user function zGestPlnSLC()

Local nTotalGRS := 0
private cPerg 	:= 	"GPIN01"
private _cArq	:= 	"GPIN01.XLS"


private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cNProp		:= ""
private _cItemConta := CTD->CTD_ITEM
private _nPComiss 	:= 0
private _nXSISFV 	:= 0
private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
Private _aGrpSint:= {}
Private nDolar := CTD->CTD_XCAMB
	//_cNProp 	:= SZ9->Z9_NPROP
    _cItemConta := CTD->CTD_ITEM

	//pergunte(cPerg,.F.)

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	//msginfo( "1." + _cItemConta)

	//MSAguarde({||zAtuCustZ9()},"Atulizando Custos Planejado")

	MSAguarde({||zGrpsSLC()},"Processando Grupos Proposta")

	MSAguarde({||zDetProp()},"Processando Detalhamento Custo Vendido")

	MSAguarde({||zCustPlan()},"Processando Detalhamento Custo Planejado")
	
	MontaTela()

	TRB1->(dbclosearea())
	TRB2->(dbclosearea())

return


/* Montagem Grupo Proposta */

static function zGrpsSLC()

	local cGrupo	:= ""
	local cFor 		:= "ALLTRIM(QUERY2->ZZN_ITEMCT) == _cItemConta"
	local cQueryQTD
	local nTotReg 	:= 0

	//msginfo("2." + _cItemConta)

	ChkFile("ZZL",.F.,"QUERY") // Alias dos movimentos bancarios
	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZL_FILIAL+ZZL_ID",,,"Selecionando Registros...")
	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())

	ChkFile("ZZN",.F.,"QUERY2") // Alias dos movimentos bancarios
	IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZZN_FILIAL+ZZN_GRUPO",,cFor,"Selecionando Registros...")
	ProcRegua(QUERY2->(reccount()))
	QUERY2->(dbgotop())
	
	while QUERY->(!eof())

		QUERY2->(dbgotop())
		while QUERY2->(!eof()) 
			IF ALLTRIM(QUERY->ZZL_ID) == ALLTRIM(QUERY2->ZZN_GRUPO)
				cGrupo := ALLTRIM(QUERY2->ZZN_GRUPO)
			ENDIF
			QUERY2->(dbskip())
		ENDDO

		cQueryQTD := " SELECT * FROM ZZN010 WHERE ZZN_GRUPO = '" +  substring(cGrupo,1,3)  + "' AND ZZN_ITEMCT = '" + _cItemConta + "'"
		TCQuery cQueryQTD New Alias "TZZNQTD"
					
		Count To nTotReg
		TZZNQTD->(DbGoTop()) 
		
		If nTotReg = 0
			IF cGrupo <> '200'
				RecLock("TRB1",.T.)
					TRB1->GRUPO		:= QUERY->ZZL_ID
					TRB1->ITEMCTA	:= _cItemConta
					TRB1->ITEM		:= UPPER(QUERY->ZZL_DESC)
					TRB1->GS 		:= "G"
				MsUnlock()
			ENDIF
		ENDIF
		
		QUERY->(dbskip())

		TZZNQTD->(dbclosearea())
		nTotReg := 0
	enddo
	QUERY->(dbclosearea())
	QUERY2->(dbclosearea())
	TRB1->(dbgotop())
	
return

/* Montagem Detalhamento Proposta */
static function zDetProp()

		Local nTotGRS := 0
		Local nTotGRSLB := 0
		Local nTotGRSEF := 0
		Local nTotGR200 := 0
		Local nTotGR200LB := 0
		Local nTotGR200EF := 0
		local _cQuery 	:= ""
		Local _cFilZZM 	:= xFilial("ZZM")
		local cFor 		:= "" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
		local cForZZN	:= "ALLTRIM(QUERYZZN->ZZN_ITEMCT) == _cItemConta"
		local nTotPR 	:= 0
		local nTotLB 	:= 0
		local nTotEF 	:= 0
		local nTotGR 	:= 0
		local cICta		:= ""
		local cPlan		:= ""

		//msginfo("3." + _cItemConta)

		ChkFile("ZZN",.F.,"QUERYZZN")
		IndRegua("QUERYZZN",CriaTrab(NIL,.F.),"ZZN_FILIAL+ZZN_ITEMCT",,cForZZN,"Selecionando Registros...")
		ProcRegua(QUERYZZN->(reccount()))

		cPlan := QUERYZZN->ZZN_PL

		//SZ4->(dbsetorder(9)) 
		ChkFile("ZZM",.F.,"QUERY") // Alias dos movimentos bancarios
		if cPlan = "P1"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		elseif cPlan = "P2"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC2) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC2
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC2",,cFor,"Selecionando Registros...")

		elseif cPlan = "P3"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC3) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC3
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC3",,cFor,"Selecionando Registros...")

		elseif cPlan = "P4"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC4) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC4
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC4",,cFor,"Selecionando Registros...")

		elseif cPlan = "P5" 
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC5) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC5
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC5",,cFor,"Selecionando Registros...")

		elseif cPlan = "P6"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC6) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC6
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC6",,cFor,"Selecionando Registros...")

		elseif cPlan = "P7"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC7) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC7
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC7",,cFor,"Selecionando Registros...")

		elseif cPlan = "P8"
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMC8) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMC8
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMC8",,cFor,"Selecionando Registros...")
		eLSE
			cFor 		:= "ALLTRIM(QUERY->ZZM_ITEMCT) == _cItemConta" //"ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
			//cICta		:= QUERY->ZZM_ITEMCT
			IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")

		endif

		if empty(cICta)
			cICta := _cItemConta
		endif
		//IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_ITEMCT",,cFor,"Selecionando Registros...")
		ProcRegua(QUERY->(reccount()))

		QUERY->(dbgotop())
		while QUERY->(!eof())
				RecLock("TRB2",.T.)
				TRB2->VGRUPO	:= QUERY->ZZM_GRUPO
				TRB2->VITEM		:= UPPER(QUERY->ZZM_ITEM)
				TRB2->VPL		:= cPlan

				if cPlan = "P1"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP1
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP1
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP1
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP1L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP1L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP1L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP1E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP1E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
				elseif cPlan = "P2"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP2
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP2
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP2
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP2L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP2L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP2L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP2E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP2E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP2E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E //QUERY->ZZM_TOTGR
				elseif cPlan = "P3"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP3
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP3
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP3
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP3L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP3L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP3L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP3E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP3E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP3E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E //QUERY->ZZM_TOTGR
				elseif cPlan = "P4"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP4
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP4
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP4
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP4L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP4L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP4L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP4E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP4E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP4E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E //QUERY->ZZM_TOTGR
				elseif cPlan = "P5"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP5
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP5
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP5
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP5L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP5L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP5L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP5E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP5E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP5E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E //QUERY->ZZM_TOTGR
				elseif cPlan = "P6"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP6
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP6
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP6
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP6L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP6L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP6L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP6E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP6E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP6E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E //QUERY->ZZM_TOTGR
				elseif cPlan = "P7"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP7
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP7
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP7
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP7L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP7L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP7L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP7E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP7E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP7E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E //QUERY->ZZM_TOTGR
				elseif cPlan = "P8"
					TRB2->VQUANT	:= QUERY->ZZM_QTDP8
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP8
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP8
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP8L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP8L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP8L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP8E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP8E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP8E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E //QUERY->ZZM_TOTGR
				else
					TRB2->VQUANT	:= QUERY->ZZM_QTDP1
					TRB2->VVUNIT	:= QUERY->ZZM_UNITP1
					TRB2->VTOTAL	:= QUERY->ZZM_TOTP1
					TRB2->VQUANTLB	:= QUERY->ZZM_QTDP1L
					TRB2->VVUNITLB	:= QUERY->ZZM_UNIP1L
					TRB2->VTOTLB	:= QUERY->ZZM_TOTP1L
					TRB2->VQUANTEF	:= QUERY->ZZM_QTDP1E
					TRB2->VVUNITEF	:= QUERY->ZZM_UNIP1E
					TRB2->VTOTEF	:= QUERY->ZZM_TOTP1E
					TRB2->VTOTGR	:= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E //QUERY->ZZM_TOTGR
				endif
				
				TRB2->VNPROP	:= QUERY->ZZM_NPROP
				TRB2->VITEMCTA	:= cICta
				TRB2->VGS 		:= QUERY->ZZM_GS
				//_cItemConta     := cICta
				_cNProp			:= QUERY->ZZM_NPROP
				MsUnlock()
				QUERY->(dbskip())
		enddo
		
		// Totalizando Grupos
		DbSelectArea("ZZL")
		ZZL->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZL->(DbGoTop())

		DbSelectArea("ZZM")
		ZZM->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZM->(DbGoTop())

		while ZZL->(!eof())
			cGrupo := ZZL->ZZL_ID
			/*if alltrim(cGrupo) == '801'
				ZZL->(dbskip())
				loop
			endif*/
			// Totalizando Grupos EXECETO GRUPO 200
			ZZM->(DbGoTop())
			while ZZM->(!eof())
				IF substr(alltrim(ZZM->ZZM_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(cICta) == alltrim(_cItemConta) .and. LEN(alltrim(ZZM->ZZM_GRUPO)) > 3 ;
					.AND. !alltrim(ZZM->ZZM_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/908")  
					if cPlan = "P1"
						nTotGRS 	+= ZZM->ZZM_TOTP1
						nTotGRSLB 	+= ZZM->ZZM_TOTP1L
						nTotGRSEF 	+= ZZM->ZZM_TOTP1E
					elseif cPlan = "P2"
						nTotGRS 	+= ZZM->ZZM_TOTP2
						nTotGRSLB 	+= ZZM->ZZM_TOTP2L
						nTotGRSEF 	+= ZZM->ZZM_TOTP2E
					elseif cPlan = "P3"
						nTotGRS 	+= ZZM->ZZM_TOTP3
						nTotGRSLB 	+= ZZM->ZZM_TOTP3L
						nTotGRSEF 	+= ZZM->ZZM_TOTP3E
					elseif cPlan = "P4"
						nTotGRS 	+= ZZM->ZZM_TOTP4
						nTotGRSLB 	+= ZZM->ZZM_TOTP4L
						nTotGRSEF 	+= ZZM->ZZM_TOTP4E
					elseif cPlan = "P5"
						nTotGRS 	+= ZZM->ZZM_TOTP5
						nTotGRSLB 	+= ZZM->ZZM_TOTP5L
						nTotGRSEF 	+= ZZM->ZZM_TOTP5E
					elseif cPlan = "P6"
						nTotGRS 	+= ZZM->ZZM_TOTP6
						nTotGRSLB 	+= ZZM->ZZM_TOTP6L
						nTotGRSEF 	+= ZZM->ZZM_TOTP6E
					elseif cPlan = "P7"
						nTotGRS 	+= ZZM->ZZM_TOTP7
						nTotGRSLB 	+= ZZM->ZZM_TOTP7L
						nTotGRSEF 	+= ZZM->ZZM_TOTP7E
					elseif cPlan = "P8"
						nTotGRS 	+= ZZM->ZZM_TOTP8
						nTotGRSLB 	+= ZZM->ZZM_TOTP8L
						nTotGRSEF 	+= ZZM->ZZM_TOTP8E
					else
						nTotGRS 	+= ZZM->ZZM_TOTP1
						nTotGRSLB 	+= ZZM->ZZM_TOTP1L
						nTotGRSEF 	+= ZZM->ZZM_TOTP1E
					endif
				ENDIF
				ZZM->(dbskip())
			enddo
			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB2->(DbGoTop())
			while TRB2->(!eof())
				if alltrim(TRB2->VGRUPO) == alltrim(cGrupo) .and. TRB2->VGS == 'G' .AND. alltrim(TRB2->VITEMCTA) == alltrim(_cItemConta);
					.AND. !alltrim(TRB2->VGRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/908")  
					TRB2->VTOTAL 	:= nTotGRS
					TRB2->VTOTLB 	:= nTotGRSLB
					TRB2->VTOTEF 	:= nTotGRSEF
					TRB2->VTOTGR 	:= nTotGRS + nTotGRSLB + nTotGRSEF
					TRB2->VITEMCTA	:= _cItemConta
					TRB2->VNPROP	:= _cNProp
					TRB2->VGS		:= "G"
				ENDIF
				TRB2->(dbskip())
			enddo
			nTotGRS 	:= 0
			nTotGRSLB 	:= 0
			nTotGRSEF 	:= 0

			// Totalizando Grupo 200
			ZZM->(DbGoTop())
			while ZZM->(!eof())
				IF substr(alltrim(ZZM->ZZM_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(cICta) == alltrim(_cItemConta) ;
					.AND. alltrim(ZZM->ZZM_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/908")  
					if cPlan = "P1"
						nTotGR200 	+= ZZM->ZZM_TOTP1
						nTotGR200LB += ZZM->ZZM_TOTP1L
						nTotGR200EF += ZZM->ZZM_TOTP1E
					elseif cPlan = "P2"
						nTotGR200 	+= ZZM->ZZM_TOTP2
						nTotGR200LB += ZZM->ZZM_TOTP2L
						nTotGR200EF += ZZM->ZZM_TOTP2E
					elseif cPlan = "P3"
						nTotGR200 	+= ZZM->ZZM_TOTP3
						nTotGR200LB += ZZM->ZZM_TOTP3L
						nTotGR200EF += ZZM->ZZM_TOTP3E
					elseif cPlan = "P4"
						nTotGR200 	+= ZZM->ZZM_TOTP4
						nTotGR200LB += ZZM->ZZM_TOTP4L
						nTotGR200EF += ZZM->ZZM_TOTP4E
					elseif cPlan = "P5"
						nTotGR200 	+= ZZM->ZZM_TOTP5
						nTotGR200LB += ZZM->ZZM_TOTP5L
						nTotGR200EF += ZZM->ZZM_TOTP5E
					elseif cPlan = "P6"
						nTotGR200 	+= ZZM->ZZM_TOTP6
						nTotGR200LB += ZZM->ZZM_TOTP6L
						nTotGR200EF += ZZM->ZZM_TOTP6E
					elseif cPlan = "P7"
						nTotGR200 	+= ZZM->ZZM_TOTP7
						nTotGR200LB += ZZM->ZZM_TOTP7L
						nTotGR200EF += ZZM->ZZM_TOTP7E
					elseif cPlan = "P8"
						nTotGR200 	+= ZZM->ZZM_TOTP8
						nTotGR200LB += ZZM->ZZM_TOTP8L
						nTotGR200EF += ZZM->ZZM_TOTP8E
					else
						nTotGR200 	+= ZZM->ZZM_TOTP1
						nTotGR200LB += ZZM->ZZM_TOTP1L
						nTotGR200EF += ZZM->ZZM_TOTP1E
					endif
				ENDIF
				ZZM->(dbskip())
			enddo

			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB2->(DbGoTop())
			while TRB2->(!eof())
				// GRAVAR NA TRB1 O TOTAL DOS GRUPO 200
				if alltrim(TRB2->VGRUPO) == '200' .and. TRB2->VGS == 'G' .AND.  alltrim(TRB2->VITEMCTA) == alltrim(_cItemConta);
					.AND. !alltrim(TRB2->VGRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
					TRB2->VTOTAL 	:= nTotGR200
					TRB2->VTOTLB 	:= nTotGR200LB
					TRB2->VTOTEF 	:= nTotGR200EF
					TRB2->VTOTGR 	:= nTotGR200 + nTotGR200LB + nTotGR200EF
					TRB2->VITEMCTA	:= _cItemConta
					TRB2->VNPROP	:= _cNProp
					TRB2->VGS			:= "G"
				ENDIF
				
				TRB2->(dbskip())
			enddo
			/*nTotGRS 	:= 0
			nTotGRSLB 	:= 0
			nTotGRSEF 	:= 0*/
			
			ZZL->(dbskip())
		enddo
	
		QUERY->(dbgotop())
		RecLock("TRB2",.T.)
			TRB2->VGRUPO		:= "199"
			TRB2->VITEM		:= "TOTAL MATERIAIS"
			
			while QUERY->(!eof())
				IF alltrim(QUERY->ZZM_GRUPO) $ ("101/102/103/104/105/106/107/108/109") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) == 3 .AND. alltrim(cICta) == alltrim(_cItemConta)
					if cPlan = "P1"
						nTotPR		+= QUERY->ZZM_TOTP1	
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E
					elseif  cPlan = "P2"
						nTotPR		+= QUERY->ZZM_TOTP2	
						nTotLB		+= QUERY->ZZM_TOTP2L
						nTotEF		+= QUERY->ZZM_TOTP2E	
						nTotGR		+= QUERY->ZZM_TOTP2 + QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E
					elseif  cPlan = "P3"
						nTotPR		+= QUERY->ZZM_TOTP3	
						nTotLB		+= QUERY->ZZM_TOTP3L
						nTotEF		+= QUERY->ZZM_TOTP3E	
						nTotGR		+= QUERY->ZZM_TOTP3 + QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E
					elseif  cPlan = "P4"
						nTotPR		+= QUERY->ZZM_TOTP4	
						nTotLB		+= QUERY->ZZM_TOTP4L
						nTotEF		+= QUERY->ZZM_TOTP4E	
						nTotGR		+= QUERY->ZZM_TOTP4 + QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E
					elseif  cPlan = "P5"
						nTotPR		+= QUERY->ZZM_TOTP5	
						nTotLB		+= QUERY->ZZM_TOTP5L
						nTotEF		+= QUERY->ZZM_TOTP5E	
						nTotGR		+= QUERY->ZZM_TOTP5 + QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E
					elseif  cPlan = "P6"
						nTotPR		+= QUERY->ZZM_TOTP6	
						nTotLB		+= QUERY->ZZM_TOTP6L
						nTotEF		+= QUERY->ZZM_TOTP6E	
						nTotGR		+= QUERY->ZZM_TOTP6 + QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E
					elseif  cPlan = "P7"
						nTotPR		+= QUERY->ZZM_TOTP7	
						nTotLB		+= QUERY->ZZM_TOTP7L
						nTotEF		+= QUERY->ZZM_TOTP7E	
						nTotGR		+= QUERY->ZZM_TOTP7 + QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E
					elseif  cPlan = "P8"
						nTotPR		+= QUERY->ZZM_TOTP8	
						nTotLB		+= QUERY->ZZM_TOTP8L
						nTotEF		+= QUERY->ZZM_TOTP8E	
						nTotGR		+= QUERY->ZZM_TOTP8 + QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E
					else
						nTotPR		+= QUERY->ZZM_TOTP1	
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1 + QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB2->VTOTAL		:= nTotPR
			TRB2->VTOTLB		:= nTotLB
			TRB2->VTOTEF		:= nTotEF
			TRB2->VTOTGR		:= nTotGR
			TRB2->VITEMCTA		:= _cItemConta
			TRB2->VNPROP		:= _cNProp
			TRB2->VGS 			:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		QUERY->(dbgotop())
		RecLock("TRB2",.T.)
			TRB2->VGRUPO		:= "209"
			TRB2->VITEM		:= "ENGENHARIA SUBTOTAL"
			
			while QUERY->(!eof())
				IF ALLTRIM(QUERY->ZZM_GRUPO) $ ("201/202/204/205/206/207") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) = 3 .AND. alltrim(cICta) == alltrim(_cItemConta)
					if cPlan = "P1"
						nTotPR		+= QUERY->ZZM_TOTP1
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1	+ QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E	
					elseif cPlan = "P2"
						nTotPR		+= QUERY->ZZM_TOTP2
						nTotLB		+= QUERY->ZZM_TOTP2L
						nTotEF		+= QUERY->ZZM_TOTP2E	
						nTotGR		+= QUERY->ZZM_TOTP2	+ QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E	
					elseif cPlan = "P3"
						nTotPR		+= QUERY->ZZM_TOTP3
						nTotLB		+= QUERY->ZZM_TOTP3L
						nTotEF		+= QUERY->ZZM_TOTP3E	
						nTotGR		+= QUERY->ZZM_TOTP3	+ QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E
					elseif cPlan = "P4"
						nTotPR		+= QUERY->ZZM_TOTP4
						nTotLB		+= QUERY->ZZM_TOTP4L
						nTotEF		+= QUERY->ZZM_TOTP4E	
						nTotGR		+= QUERY->ZZM_TOTP4	+ QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E
					elseif cPlan = "P5"
						nTotPR		+= QUERY->ZZM_TOTP5
						nTotLB		+= QUERY->ZZM_TOTP5L
						nTotEF		+= QUERY->ZZM_TOTP5E	
						nTotGR		+= QUERY->ZZM_TOTP5	+ QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E
					elseif cPlan = "P6"
						nTotPR		+= QUERY->ZZM_TOTP6
						nTotLB		+= QUERY->ZZM_TOTP6L
						nTotEF		+= QUERY->ZZM_TOTP6E	
						nTotGR		+= QUERY->ZZM_TOTP6	+ QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E
					elseif cPlan = "P7"
						nTotPR		+= QUERY->ZZM_TOTP7
						nTotLB		+= QUERY->ZZM_TOTP7L
						nTotEF		+= QUERY->ZZM_TOTP7E	
						nTotGR		+= QUERY->ZZM_TOTP7	+ QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E
					elseif cPlan = "P8"
						nTotPR		+= QUERY->ZZM_TOTP8
						nTotLB		+= QUERY->ZZM_TOTP8L
						nTotEF		+= QUERY->ZZM_TOTP8E	
						nTotGR		+= QUERY->ZZM_TOTP8	+ QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E	
					else
						nTotPR		+= QUERY->ZZM_TOTP1
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1	+ QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E						
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB2->VTOTAL		:= nTotPR
			TRB2->VTOTLB		:= nTotLB
			TRB2->VTOTEF		:= nTotEF
			TRB2->VTOTGR		:= nTotGR
			TRB2->VITEMCTA		:= _cItemConta
			TRB2->VNPROP		:= _cNProp
			TRB2->VGS 			:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		QUERY->(dbgotop())
		RecLock("TRB2",.T.)
			TRB2->VGRUPO		:= "299"
			TRB2->VITEM		:= "OPERACOES"
			
			while QUERY->(!eof())
				IF   alltrim(QUERY->ZZM_GRUPO) $ ("210/211/212/213/217/218/220/221/222") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) = 3 ;
				.AND. cICta = _cItemConta
					if cPlan = "P1"
						nTotPR		+= QUERY->ZZM_TOTP1	
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1	+ QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E
					elseif cPlan = "P2"
						nTotPR		+= QUERY->ZZM_TOTP2	
						nTotLB		+= QUERY->ZZM_TOTP2L
						nTotEF		+= QUERY->ZZM_TOTP2E	
						nTotGR		+= QUERY->ZZM_TOTP2	+ QUERY->ZZM_TOTP2L + QUERY->ZZM_TOTP2E
					elseif cPlan = "P3"
						nTotPR		+= QUERY->ZZM_TOTP3	
						nTotLB		+= QUERY->ZZM_TOTP3L
						nTotEF		+= QUERY->ZZM_TOTP3E	
						nTotGR		+= QUERY->ZZM_TOTP3	+ QUERY->ZZM_TOTP3L + QUERY->ZZM_TOTP3E
					elseif cPlan = "P4"
						nTotPR		+= QUERY->ZZM_TOTP4	
						nTotLB		+= QUERY->ZZM_TOTP4L
						nTotEF		+= QUERY->ZZM_TOTP4E	
						nTotGR		+= QUERY->ZZM_TOTP4	+ QUERY->ZZM_TOTP4L + QUERY->ZZM_TOTP4E
					elseif cPlan = "P5"
						nTotPR		+= QUERY->ZZM_TOTP5	
						nTotLB		+= QUERY->ZZM_TOTP5L
						nTotEF		+= QUERY->ZZM_TOTP5E	
						nTotGR		+= QUERY->ZZM_TOTP5	+ QUERY->ZZM_TOTP5L + QUERY->ZZM_TOTP5E
					elseif cPlan = "P6"
						nTotPR		+= QUERY->ZZM_TOTP6	
						nTotLB		+= QUERY->ZZM_TOTP6L
						nTotEF		+= QUERY->ZZM_TOTP6E	
						nTotGR		+= QUERY->ZZM_TOTP6	+ QUERY->ZZM_TOTP6L + QUERY->ZZM_TOTP6E
					elseif cPlan = "P7"
						nTotPR		+= QUERY->ZZM_TOTP7	
						nTotLB		+= QUERY->ZZM_TOTP7L
						nTotEF		+= QUERY->ZZM_TOTP7E	
						nTotGR		+= QUERY->ZZM_TOTP7	+ QUERY->ZZM_TOTP7L + QUERY->ZZM_TOTP7E
					elseif cPlan = "P8"
						nTotPR		+= QUERY->ZZM_TOTP8	
						nTotLB		+= QUERY->ZZM_TOTP8L
						nTotEF		+= QUERY->ZZM_TOTP8E	
						nTotGR		+= QUERY->ZZM_TOTP8	+ QUERY->ZZM_TOTP8L + QUERY->ZZM_TOTP8E
					else
						nTotPR		+= QUERY->ZZM_TOTP1	
						nTotLB		+= QUERY->ZZM_TOTP1L
						nTotEF		+= QUERY->ZZM_TOTP1E	
						nTotGR		+= QUERY->ZZM_TOTP1	+ QUERY->ZZM_TOTP1L + QUERY->ZZM_TOTP1E
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB2->VTOTAL		:= nTotPR
			TRB2->VTOTLB		:= nTotLB
			TRB2->VTOTEF		:= nTotEF
			TRB2->VTOTGR		:= nTotGR
			TRB2->VITEMCTA		:= _cItemConta
			TRB2->VNPROP		:= _cNProp
			TRB2->VGS 			:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		QUERY->(dbgotop())
		RecLock("TRB2",.T.)
			TRB2->VGRUPO	:= "799"
			TRB2->VITEM		:= "CUSTO DE PRODUCAO"
			QUERY->(dbgotop())
			while QUERY->(!eof())
					if cPlan = "P1"	
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP1	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP1L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP1E	
						ENDIF
					elseif cPlan = "P2"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP2	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP2L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP2E	
						ENDIF
					elseif cPlan = "P3"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP3	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP3L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP3E	
						ENDIF
					elseif cPlan = "P4"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP4	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP4L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP4E	
						ENDIF
					elseif cPlan = "P5"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP5	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP5L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP5E	
						ENDIF
					elseif cPlan = "P6"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP6	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP6L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP6E	
						ENDIF
					elseif cPlan = "P7"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP7	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP7L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP7E	
						ENDIF
					elseif cPlan = "P8"
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP8	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP8L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP8E	
						ENDIF
					else
						IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotPR		+= QUERY->ZZM_TOTP1	
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotLB		+= QUERY->ZZM_TOTP1L
						ENDIF
						IF cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
							.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
							nTotEF		+= QUERY->ZZM_TOTP1E	
						ENDIF
					endif
				QUERY->(dbskip())
			enddo
			TRB2->VTOTAL		:= nTotPR
			TRB2->VTOTLB		:= nTotLB
			TRB2->VTOTEF		:= nTotEF
			TRB2->VTOTGR		:= nTotPR + nTotLB + nTotEF
			TRB2->VITEMCTA		:= _cItemConta
			TRB2->VNPROP		:= _cNProp
			TRB2->VGS 			:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		QUERY->(dbgotop())
		RecLock("TRB2",.T.)
			TRB2->VGRUPO	:= "999"
			TRB2->VITEM		:= "CUSTO TOTAL"
			
			while QUERY->(!eof())
				if cPlan = "P1"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP1	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP1L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP1E
					ENDIF
				elseif cPlan = "P2"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP2	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP2L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP2E
					ENDIF
				elseif cPlan = "P3"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP3	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP3L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP3E
					ENDIF
				elseif cPlan = "P4"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP4	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP4L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP4E
					ENDIF
				elseif cPlan = "P5"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP5	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP5L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP5E
					ENDIF
				elseif cPlan = "P6"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP6	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP6L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP6E
					ENDIF
				elseif cPlan = "P7"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP7	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP7L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP7E
					ENDIF
				elseif cPlan = "P8"
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP8	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP8L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP8E
					ENDIF
				else
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotPR		+= QUERY->ZZM_TOTP1	
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotLB		+= QUERY->ZZM_TOTP1L
					ENDIF
					IF  cICta = _cItemConta .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
						.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
						nTotEF		+= QUERY->ZZM_TOTP1E
					ENDIF
				endif

				QUERY->(dbskip())
			enddo
			TRB2->VTOTAL		:= nTotPR
			TRB2->VTOTLB		:= nTotLB
			TRB2->VTOTEF		:= nTotEF
			TRB2->VTOTGR		:= nTotPR + nTotLB + nTotEF
			TRB2->VITEMCTA		:= _cItemConta
			TRB2->VNPROP		:= _cNProp
			TRB2->VGS 			:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		
		
		//zAtuCustZ9()

TRB2->(dbgotop())
QUERY->(dbclosearea())
QUERYZZN->(dbclosearea())
//GetdRefresh()

//msginfo("4." + _cItemConta)
return

/* Montagem Detalhamento Custo Planejado */
static function zCustPlan()

		Local nTotGRS := 0
		Local nTotGRSLB := 0
		Local nTotGRSEF := 0
		Local nTotGR200 := 0
		Local nTotGR200LB := 0
		Local nTotGR200EF := 0
		local _cQuery 	:= ""
		Local _cFilZZM 	:= xFilial("ZZN")
		local cFor 		:= "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta"
		local cForCTD	:= "ALLTRIM(QUERYCTD->CTD_ITEM) == _cItemConta"
		local nTotPR 	:= 0
		local nTotLB 	:= 0
		local nTotEF 	:= 0
		local nTotGR 	:= 0

		Local nTotGRSD := 0
		Local nTotGRSLBD := 0
		Local nTotGRSEFD := 0
		Local nTotGR200D := 0
		Local nTotGR200LBD := 0
		Local nTotGR200EFD := 0
		local nTotPRD 	:= 0
		local nTotLBD 	:= 0
		local nTotEFD 	:= 0
		local nTotGRD 	:= 0

		local nDolar	:= 0
		local dData

		//msginfo("5." + _cItemConta)

		SM2->(dbsetorder(1)) // E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA
		ChkFile("SM2",.F.,"QUERYSM2") // Alias dos movimentos bancarios
		IndRegua("QUERYSM2",CriaTrab(NIL,.F.),"M2_DATA",,,"Selecionando Registros...")
		ProcRegua(QUERYSM2->(reccount()))
		SM2->(dbgotop())


		//SZ4->(dbsetorder(9)) 
		//ChkFile("CTD",.F.,"QUERYCTD") // Alias dos movimentos bancarios
		//IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_ITEM",,cForCTD,"Selecionando Registros...")
		//ProcRegua(QUERYCTD->(reccount()))

		//nDolar := QUERYCTD->CTD_XCAMB

		/*if nDolar = 0
			dData := dDatabase
			//msginfo ( dData )
			while QUERYSM2->(!eof()) //QUERY2->(dbseek(dData,.F.)) .OR. nValor = 0

				while  QUERYSM2->(!eof())
					
					nDolar := QUERYSM2->M2_MOEDA2
				
					if dData == QUERYSM2->M2_DATA .AND. nDolar > 0
						nDolar 	:= QUERYSM2->M2_MOEDA2
						dData	:= QUERYSM2->M2_DATA	
						Exit
					else
						QUERYSM2->(dbSkip())
					endif

				enddo
				if dData == QUERYSM2->M2_DATA .AND. nDolar > 0
					exit
				ENDIF
				dData--
				
			enddo
		EndIf*/

		//SZ4->(dbsetorder(9)) 
		ChkFile("ZZN",.F.,"QUERY") // Alias dos movimentos bancarios
		IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZN_FILIAL+ZZN_GRUPO+ZZN_ITEMCT",,cFor,"Selecionando Registros...")
		ProcRegua(QUERY->(reccount()))

		QUERY->(dbgotop())
		while QUERY->(!eof())
				RecLock("TRB1",.T.)
				TRB1->GRUPO		:= QUERY->ZZN_GRUPO
				TRB1->ITEM		:= UPPER(QUERY->ZZN_ITEM)
				TRB1->QUANT		:= QUERY->ZZN_QUANT
				TRB1->VUNIT		:= QUERY->ZZN_VUNIT
				TRB1->TOTAL		:= QUERY->ZZN_TOTAL
				TRB1->QUANTLB	:= QUERY->ZZN_QTDLB
				TRB1->VUNITLB	:= QUERY->ZZN_UNITLB
				TRB1->TOTLB		:= QUERY->ZZN_TOTLB
				TRB1->QUANTEF	:= QUERY->ZZN_QTDEF
				TRB1->VUNITEF	:= QUERY->ZZN_UNITEF
				TRB1->TOTEF		:= QUERY->ZZN_TOTEF
				TRB1->TOTGR		:= QUERY->ZZN_TOTAL + QUERY->ZZN_TOTLB + QUERY->ZZN_TOTEF //QUERY->ZZM_TOTGR
				TRB1->NPROP		:= QUERY->ZZN_NPROP
				TRB1->ITEMCTA	:= QUERY->ZZN_ITEMCT
				TRB1->GS 		:= QUERY->ZZN_GS
				TRB1->PL 		:= QUERY->ZZN_PL

				_cItemConta     := QUERY->ZZN_ITEMCT
				_cNProp 		:= QUERY->ZZN_NPROP

				iF nDolar = 0
					TRB1->VUNITD	:= QUERY->ZZN_VUNITD
					TRB1->TOTALD	:= QUERY->ZZN_TOTALD
					
					TRB1->UNITLD	:= QUERY->ZZN_UNITLD
					TRB1->TOTLD		:= QUERY->ZZN_TOTLD
					
					TRB1->UNITED	:= QUERY->ZZN_UNITED
					TRB1->TOTED		:= QUERY->ZZN_TOTED

					TRB1->TOTGRD	:= QUERY->ZZN_TOTALD + QUERY->ZZN_TOTLD + QUERY->ZZN_TOTED //QUERY->ZZM_TOTGR
				else
					TRB1->VUNITD	:= QUERY->ZZN_VUNIT / nDolar
					TRB1->TOTALD	:= QUERY->ZZN_TOTAL / nDolar
					
					TRB1->UNITLD	:= QUERY->ZZN_UNITLB / nDolar
					TRB1->TOTLD		:= QUERY->ZZN_TOTLB / nDolar
					
					TRB1->UNITED	:= QUERY->ZZN_UNITEF / nDolar
					TRB1->TOTED		:= QUERY->ZZN_TOTEF / nDolar

					TRB1->TOTGRD	:= (QUERY->ZZN_TOTAL / nDolar) + (QUERY->ZZN_TOTLB / nDolar) + (QUERY->ZZN_TOTEF / nDolar) //QUERY->ZZM_TOTGR
				endif

				MsUnlock()
				QUERY->(dbskip())
		enddo
		
		// Totalizando Grupos
		DbSelectArea("ZZL")
		ZZL->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZL->(DbGoTop())

		/*DbSelectArea("ZZN")
		ZZN->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZN->(DbGoTop())*/
		//ZZN->( dbSetFilter( { || &cFor }, cFor ) )

		while ZZL->(!eof())
			cGrupo := ZZL->ZZL_ID
			/*if alltrim(cGrupo) == '801'
				ZZL->(dbskip())
				loop
			endif*/
			// Totalizando Grupos EXECETO GRUPO 200

			

			QUERY->(DbGoTop())
			while QUERY->(!eof())
				IF substr(alltrim(QUERY->ZZN_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(QUERY->ZZN_ITEMCT) == alltrim(_cItemConta) .and. LEN(alltrim(QUERY->ZZN_GRUPO)) > 3 ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/802/803/804/805/806/908")  
					nTotGRS 	+= QUERY->ZZN_TOTAL
					nTotGRSLB 	+= QUERY->ZZN_TOTLB
					nTotGRSEF 	+= QUERY->ZZN_TOTEF

					if nDolar = 0
						nTotGRSD 	+= QUERY->ZZN_TOTAL / nDolar
						nTotGRSLBD 	+= QUERY->ZZN_TOTLB / nDolar
						nTotGRSEFD 	+= QUERY->ZZN_TOTEF / nDolar
					else
						nTotGRSD 	+= QUERY->ZZN_TOTALD
						nTotGRSLBD 	+= QUERY->ZZN_TOTLD
						nTotGRSEFD 	+= QUERY->ZZN_TOTED
					endif
				ENDIF
				QUERY->(dbskip())
			enddo

			

			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB1->(DbGoTop())
			while TRB1->(!eof())
				if alltrim(TRB1->GRUPO) == alltrim(cGrupo) .and. TRB1->GS == 'G' .AND. alltrim(TRB1->ITEMCTA) == alltrim(_cItemConta);
					.AND. !alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/802/803/804/805/806/807/908")  
					TRB1->TOTAL 	:= nTotGRS
					TRB1->TOTLB 	:= nTotGRSLB
					TRB1->TOTEF 	:= nTotGRSEF
					TRB1->TOTGR 	:= nTotGRS + nTotGRSLB + nTotGRSEF

					TRB1->TOTALD 	:= nTotGRSD
					TRB1->TOTLD 	:= nTotGRSLBD
					TRB1->TOTED 	:= nTotGRSEFD
					TRB1->TOTGRD 	:= nTotGRSD + nTotGRSLBD + nTotGRSEFD
					
					TRB1->ITEMCTA	:= _cItemConta
					TRB1->NPROP		:= _cNProp
					TRB1->GS 		:= "G"
				ENDIF
				TRB1->(dbskip())
			enddo
			nTotGRS 	:= 0
			nTotGRSLB 	:= 0
			nTotGRSEF 	:= 0

			nTotGRSD 	:= 0
			nTotGRSLBD 	:= 0
			nTotGRSEFD 	:= 0

			// Totalizando Grupo 200
			QUERY->(DbGoTop())
			while QUERY->(!eof())
				IF substr(alltrim(QUERY->ZZN_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(QUERY->ZZN_ITEMCT) == alltrim(_cItemConta) ;
					.AND. alltrim(QUERY->ZZN_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
					nTotGR200 	+= QUERY->ZZN_TOTAL
					nTotGR200LB += QUERY->ZZN_TOTLB
					nTotGR200EF += QUERY->ZZN_TOTEF

					if nDolar = 0
						nTotGR200D 	 += QUERY->ZZN_TOTAL / nDolar
						nTotGR200LBD += QUERY->ZZN_TOTLB / nDolar
						nTotGR200EFD += QUERY->ZZN_TOTEF / nDolar
					else
						nTotGR200D 	 += QUERY->ZZN_TOTALD
						nTotGR200LBD += QUERY->ZZN_TOTLD
						nTotGR200EFD += QUERY->ZZN_TOTED
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB1->(DbGoTop())
			while TRB1->(!eof())
				// GRAVAR NA TRB1 O TOTAL DOS GRUPO 200
				if alltrim(TRB1->GRUPO) == '200' .and. TRB1->GS == 'G' .AND. alltrim(TRB1->ITEMCTA) == alltrim(_cItemConta);
					.AND. !alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
					TRB1->TOTAL 	:= nTotGR200
					TRB1->TOTLB 	:= nTotGR200LB
					TRB1->TOTEF	 	:= nTotGR200EF
					TRB1->TOTGR 	:= nTotGR200 + nTotGR200LB + nTotGR200EF

					TRB1->TOTALD 	:= nTotGR200D
					TRB1->TOTLD 	:= nTotGR200LBD
					TRB1->TOTED	 	:= nTotGR200EFD
					TRB1->TOTGRD 	:= nTotGR200D + nTotGR200LBD + nTotGR200EFD

					TRB1->ITEMCTA	:= _cItemConta
					TRB1->NPROP		:= _cNProp
					TRB1->GS 		:= "G"
				ENDIF
				
				TRB1->(dbskip())
			enddo
			/*nTotGRS 	:= 0
			nTotGRSLB 	:= 0
			nTotGRSEF 	:= 0*/
			
			ZZL->(dbskip())
		enddo
	
		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "199"
			TRB1->ITEM		:= "TOTAL MATERIAIS"
			TRB1->ITEMCTA	:= _cItemConta
			
			while QUERY->(!eof())
				IF alltrim(QUERY->ZZN_GRUPO) $ ("101/102/103/104/105/106/107/108/109") .AND.  LEN(ALLTRIM(QUERY->ZZN_GRUPO)) == 3 .AND. QUERY->ZZN_ITEMCT = alltrim(_cItemConta)
					nTotPR		+= QUERY->ZZN_TOTAL	
					nTotLB		+= QUERY->ZZN_TOTLB
					nTotEF		+= QUERY->ZZN_TOTEF	
					nTotGR		+= QUERY->ZZN_TOTGR

					if nDolar = 0
						nTotPRD		+= QUERY->ZZN_TOTAL	/ nDolar
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
						nTotGRD		+= QUERY->ZZN_TOTGR / nDolar
					else
						nTotPRD		+= QUERY->ZZN_TOTALD	
						nTotLBD		+= QUERY->ZZN_TOTLD
						nTotEFD		+= QUERY->ZZN_TOTED	
						nTotGRD		+= QUERY->ZZN_TOTGRD
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotGR

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotGRD

			TRB1->ITEMCTA	:= _cItemConta
			TRB1->NPROP		:= _cNProp
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD := 0
		nTotEFD	:= 0
		nTotGRD := 0

		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "209"
			TRB1->ITEM		:= "ENGENHARIA SUBTOTAL"
			TRB1->ITEMCTA	:= _cItemConta
			
			while QUERY->(!eof())
				IF ALLTRIM(QUERY->ZZN_GRUPO) $ ("201/202/204/205/206/207") .AND.  LEN(ALLTRIM(QUERY->ZZN_GRUPO)) = 3 .AND. QUERY->ZZN_ITEMCT = _cItemConta
					nTotPR		+= QUERY->ZZN_TOTAL
					nTotLB		+= QUERY->ZZN_TOTLB
					nTotEF		+= QUERY->ZZN_TOTEF	
					nTotGR		+= QUERY->ZZN_TOTAL	+ QUERY->ZZN_TOTLB + QUERY->ZZN_TOTEF	

					if nDolar = 0
						nTotPRD		+= QUERY->ZZN_TOTAL / nDolar
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
						nTotGRD		+= (QUERY->ZZN_TOTAL / nDolar)	+ (QUERY->ZZN_TOTLB / nDolar) + (QUERY->ZZN_TOTEF / nDolar)	
					else
						nTotPRD		+= QUERY->ZZN_TOTALD
						nTotLBD		+= QUERY->ZZN_TOTLD
						nTotEFD		+= QUERY->ZZN_TOTED	
						nTotGRD		+= QUERY->ZZN_TOTALD + QUERY->ZZN_TOTLD + QUERY->ZZN_TOTED	
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotGR

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotGRD

			TRB1->ITEMCTA	:= _cItemConta
			TRB1->NPROP		:= _cNProp
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD := 0
		nTotEFD	:= 0
		nTotGRD	:= 0

		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "299"
			TRB1->ITEM		:= "OPERACOES"
			TRB1->ITEMCTA	:= _cItemConta
			
			while QUERY->(!eof())
				IF   alltrim(QUERY->ZZN_GRUPO) $ ("210/211/212/213/217/218/220/221/222") .AND.  LEN(ALLTRIM(QUERY->ZZN_GRUPO)) = 3 ;
				.AND. QUERY->ZZN_ITEMCT = _cItemConta
					nTotPR		+= QUERY->ZZN_TOTAL	
					nTotLB		+= QUERY->ZZN_TOTLB
					nTotEF		+= QUERY->ZZN_TOTEF	
					nTotGR		+= QUERY->ZZN_TOTAL	+ QUERY->ZZN_TOTLB + QUERY->ZZN_TOTEF

					if nDolar = 0 
						nTotPRD		+= QUERY->ZZN_TOTAL	/ nDolar
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
						nTotGRD		+= (QUERY->ZZN_TOTAL / nDolar)	+ (QUERY->ZZN_TOTLB / nDolar) + (QUERY->ZZN_TOTEF / nDolar)
					else
						nTotPRD		+= QUERY->ZZN_TOTALD	
						nTotLBD		+= QUERY->ZZN_TOTLD
						nTotEFD		+= QUERY->ZZN_TOTED	
						nTotGRD		+= QUERY->ZZN_TOTALD + QUERY->ZZN_TOTLD + QUERY->ZZN_TOTED
					endif

				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotGR

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotGRD

			TRB1->ITEMCTA	:= _cItemConta
			TRB1->NPROP		:= _cNProp
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD	:= 0
		nTotEFD	:= 0
		nTotGRD	:= 0


		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "799"
			TRB1->ITEM		:= "CUSTO DE PRODUCAO"
			TRB1->ITEMCTA	:= _cItemConta
			QUERY->(dbgotop())
			while QUERY->(!eof())
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/801/802/803/804/805/806/807/900/901/902/903/904/905/906/908/999") 
					nTotPR		+= QUERY->ZZN_TOTAL	
					if nDolar = 0
						nTotPRD		+= QUERY->ZZN_TOTAL	/ nDolar
					else
						nTotPRD		+= QUERY->ZZN_TOTALD	
					endif
				ENDIF
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/801/801/802/803/804/805/806/807/900/901/902/903/904/905/906/908/999") 
					nTotLB		+= QUERY->ZZN_TOTLB
					if nDolar = 0
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
					else
						nTotLBD		+= QUERY->ZZN_TOTLD
					endif
				ENDIF
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/801/802/803/804/805/806/807/900/901/902/903/904/905/906/908/999") 
					nTotEF		+= QUERY->ZZN_TOTEF	
					if nDolar = 0 
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
					else
						nTotEFD		+= QUERY->ZZN_TOTED
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotPR + nTotLB + nTotEF

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotPRD + nTotLBD + nTotEFD

			TRB1->NPROP		:= _cNProp
			TRB1->ITEMCTA	:= _cItemConta
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD	:= 0
		nTotEFD	:= 0
		nTotGRD	:= 0
		//**************** COGS
		
		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "907"
			TRB1->ITEM		:= "COGS"
			TRB1->ITEMCTA	:= _cItemConta
			
			while QUERY->(!eof())
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotPR		+= QUERY->ZZN_TOTAL	

					if nDolar = 0
						nTotPRD		+= QUERY->ZZN_TOTAL	/ nDolar
					else
						nTotPRD		+= QUERY->ZZN_TOTALD	
					endif
				ENDIF
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotLB		+= QUERY->ZZN_TOTLB

					if nDolar = 0
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
					else
						nTotLBD		+= QUERY->ZZN_TOTLD
					endif
				ENDIF
				IF QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotEF		+= QUERY->ZZN_TOTEF	

					if nDolar = 0
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
					else
						nTotEFD		+= QUERY->ZZN_TOTED
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotPR + nTotLB + nTotEF

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotPRD + nTotLBD + nTotEFD

			TRB1->NPROP		:= _cNProp
			TRB1->ITEMCTA	:= _cItemConta
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD	:= 0
		nTotEFD	:= 0
		nTotGRD	:= 0

		//**************** CUSTO TOTAL 
		QUERY->(dbgotop())
		RecLock("TRB1",.T.)
			TRB1->GRUPO		:= "999"
			TRB1->ITEM		:= "CUSTO TOTAL"
			TRB1->ITEMCTA	:= _cItemConta
			
			while QUERY->(!eof())
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/999") 
					nTotPR		+= QUERY->ZZN_TOTAL	

					if nDolar = 0
						nTotPRD		+= QUERY->ZZN_TOTAL	/ nDolar
					else
						nTotPRD		+= QUERY->ZZN_TOTALD	
					endif
				ENDIF
				IF  QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/999") 
					nTotLB		+= QUERY->ZZN_TOTLB

					if nDolar = 0
						nTotLBD		+= QUERY->ZZN_TOTLB / nDolar
					else
						nTotLBD		+= QUERY->ZZN_TOTLD
					endif
				ENDIF
				IF QUERY->ZZN_ITEMCT = _cItemConta .AND. SUBSTR(QUERY->ZZN_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZN_GRUPO) $ ("199/209/299/799/200/299/900/901/999") 
					nTotEF		+= QUERY->ZZN_TOTEF	

					if nDolar = 0
						nTotEFD		+= QUERY->ZZN_TOTEF	/ nDolar
					else
						nTotEFD		+= QUERY->ZZN_TOTED
					endif
				ENDIF
				QUERY->(dbskip())
			enddo
			TRB1->TOTAL		:= nTotPR
			TRB1->TOTLB		:= nTotLB
			TRB1->TOTEF		:= nTotEF
			TRB1->TOTGR		:= nTotPR + nTotLB + nTotEF

			TRB1->TOTALD	:= nTotPRD
			TRB1->TOTLD		:= nTotLBD
			TRB1->TOTED		:= nTotEFD
			TRB1->TOTGRD	:= nTotPRD + nTotLBD + nTotEFD

			TRB1->NPROP		:= _cNProp
			TRB1->ITEMCTA	:= _cItemConta
			TRB1->GS 		:= "G"
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD	:= 0
		nTotEFD	:= 0
		nTotGRD	:= 0
		
		//zAtuCustZ9()
//ZZN->(DBClearFilter())
TRB1->(dbgotop())
QUERY->(dbclosearea())
//QUERYCTD->(dbclosearea())
QUERYSM2->(dbclosearea())
GetdRefresh()
return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Monta a tela de visualizacao do Fluxo Sintetico            º±±
±±º          ³                                                            º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function MontaTela()


private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
Private aSize   := MsAdvSize(,.F.,400)
Private aObjects:= { { 450, 450, .T., .T. } }
Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
Private aHeader	:= {}
Private lRefresh:= .T.
Private aButton := {}
Private _oGetDbSint
Private _oGetDbCUST

private _nOpc

Private oGet1, oGet2, oGet3, oGet4, oGet5, oGet6, oGet7, oGet8, oGet9, oGet10, oGet11, oGet12, oGet13, oGet14, oGet15, oGet16, oGet17, oGet18, oGet19, oGet20
Private oGet21, oGet22, oGet23, oGet24, oGet25, oGet26, oGet27, oGet28, oGet29, oGet30, oGet31, oGet132, oGet33, oGet34, oGet35, oGet36, oGet37, oGet38, oGet39, oGet40
Private oGet41, oGet42, oGet43, oGet44, oGet45, oGet46, oGet47, oGet48, oGet49, oGet50, oGet51, oGet152, oGet53, oGet54, oGet55, oGet56, oGet57, oGet59, oGet60
Private cGet1, cGet2, cGet3, cGet4, cGet5, cGet6, cGet7, cGet8, cGet9, cGet10, cGet11, cGet12, cGet13, cGet14, cGet15, cGet16, cGet17, cGet18, cGet19, cGet20
Private cGet21, cGet22, cGet23, cGet24, cGet25, cGet26, cGet27, cGet28, cGet29, cGet30, cGet31, cGet32, cGet33, cGet34, cGet35, cGet36, cGet37, cGet38,cGet39, cGet40
Private cGet41, cGet42, cGet43, cGet44, cGet45, cGet46, cGet47, cGet48, cGet49, cGet50, cGet51, cGet52, cGet53, cGet54, cGet55, cGet56, cGet57, cGet59, cGet60
Private oComboBx1, oComboBx2, oComboBx3
Private oFolder1
Private oPGrupo := space(3)
private cPGrupo := space(3)
Private oPGrupo2 := space(3)
private cPGrupo2 := space(3)

static _oDlgPln

//msginfo("6." + _cItemConta)

cCadastro :=  "Gestao de Custo Planejado - Contrato - " + _cItemConta

DEFINE MSDIALOG _oDlgPln ;
TITLE "Gestao de Custo Planejado - Contrato - " + _cItemConta ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

 @ aPosObj[1,1]+2,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-10 OF _oDlgPln ;
	  	ITEMS "Detalhamento", "Custo Planejado", "Custo Vendido" COLORS 0, 16777215 PIXEL
	  	
zCabecGC()
zTelaCustos()
zTelaCV()

DbSelectArea("CTD")
CTD->(DbSetOrder(1)) //B1_FILIAL + B1_COD
CTD->(DbGoTop())

CTD->(DbSeek(xFilial('CTD')+_cItemConta))
//zTelaCustos()

//aadd(aButton , { "BMPTABLE" , { || zExpExcGC01()}, "Export. Custos Excel " } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCRes()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgPln ON INIT EnchoiceBar(_oDlgPln,{|| zSalvar(),_oDlgPln:End()}, {||_oDlgPln:End()},, aButton)
//ACTIVATE MSDIALOG _oDlg ON INIT EnchoiceBar(_oDlg,{|| zSalvar(),_oDlg:End()}, {||_oDlg:End()},, aButton)

return
/******************* Tela Faturamento Realizado ************************/

static function zTelaCustos()

	// Monta aHeader do TRB1
	
	aadd(aHeader, {" Grupo"						,"GRUPO",		"",12,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item"						,"ITEM",		"",60,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Quant.Pri." 				,"QUANT",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.Pri.R$"			,"VUNIT",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Pri R$"				,"TOTAL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Quant.LB."	 				,"QUANTLB",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.LB.R$"				,"VUNITLB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total LB R$"				,"TOTLB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Quant.EF." 					,"QUANTEF",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.EF.R$"				,"VUNITEF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total EF R$"				,"TOTEF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Geral R$"				,"TOTGR",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"Vlr.Unit.Pri. US$"			,"VUNITD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Pri US$"				,"TOTALD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	
	aadd(aHeader, {"Vlr.Unit.LB. US$"			,"UNITLD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total LB US$"				,"TOTLD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	
	aadd(aHeader, {"Vlr.Unit.EF.US$"			,"UNITED",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total EF US$"				,"TOTED",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Geral US$"			,"TOTGRD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"No.Proposta"				,"NPROP",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta" 				,"ITEMCTA",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"GS"							,"GS",			"",01,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Pl"							,"PL",			"",02,0,"","","C","TRB1","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+5  BUTTON 'Exportar Excel' 	Size 60, 10 action(zExpCUPL()) OF oFolder1:aDialogs[2] Pixel
    @ aPosObj[1,1]-30 , aPosObj[1,2]+70 BUTTON 'Incluir'        	Size 60, 10 action(zIncRegZZM()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+135 BUTTON 'Salvar/Atualizar'  Size 60, 10 action(zAtuSalvar()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+200 BUTTON 'Excluir'       	Size 60, 10 action(zExcZZM()) OF oFolder1:aDialogs[2] Pixel

	// filtro tela planejado
	@ 0007,0330 Say  "Filtrar: " 	 COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+350 BUTTON 'Grupos'       	Size 60, 10 action(zFilGrupo()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+415 BUTTON 'SubGrupos'     Size 60, 10 action(zFilSGrupo()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+480 BUTTON 'Todos'       	Size 60, 10 action(zFilTodos()) OF oFolder1:aDialogs[2] Pixel

	@ 0005, 0550 SAY oSay1 PROMPT "Selecione Grupo" SIZE 070, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ 0005, 0595 MSGET oPGrupo VAR cPGrupo When .T. Picture "@!" Pixel F3 "ZZL2" SIZE 030, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+630 BUTTON 'Consultar'     Size 60, 10 action(zGrupoFil()) OF oFolder1:aDialogs[2] Pixel

	// filtro tela vendido
	@ 0007,0330 Say  "Filtrar: " 	 COLORS 0, 16777215 OF oFolder1:aDialogs[3] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+350 BUTTON 'Grupos'       	Size 60, 10 action(z2FilGrupo()) OF oFolder1:aDialogs[3] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+415 BUTTON 'SubGrupos'     Size 60, 10 action(z2FilSGrupo()) OF oFolder1:aDialogs[3] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+480 BUTTON 'Todos'       	Size 60, 10 action(z2FilTodos()) OF oFolder1:aDialogs[3] Pixel

	@ 0005, 0550 SAY oSay1 PROMPT "Selecione Grupo" SIZE 070, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[3] PIXEL
	@ 0005, 0595 MSGET oPGrupo2 VAR cPGrupo2 When .T. Picture "@!" Pixel F3 "ZZL2" SIZE 030, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[3] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+630 BUTTON 'Consultar'     Size 60, 10 action(z2GrupoFil()) OF oFolder1:aDialogs[3] Pixel

	_oGetDbCUST := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3])-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[2])
	
    _oGetDbCUST:oBrowse:BlDblClick := {|| zEditZZM()}

	// COR DA FONTE
	_oGetDbCUST:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
	// COR DA LINHA
	_oGetDbCUST:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha
	
return

// Filtrar somente grupos planejado
static function zFilGrupo()
	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "TRB1->GS = 'G'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB1->(dbgotop())

return

// Filtrar somente subgrupos 
static function zFilSGrupo()
	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "TRB1->GS = 'S'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB1->(dbgotop())

return

// Filtrar POR CONTIDO
static function zGrupoFil()

	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "substr(alltrim(TRB1->GRUPO),1,len(cPGrupo)) $ '" + substr(Alltrim(cPGrupo),1,len(cPGrupo)) + "'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB1->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB1->(dbgotop())

return

// Filtrar exibir todos 
static function zFilTodos()

	TRB1->(dbclearfil())
	TRB1->(dbgotop())

return

// Filtrar somente grupos vendido
static function z2FilGrupo()
	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "TRB2->VGS = 'G'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB2->(dbgotop())

return

// Filtrar somente subgrupos 
static function z2FilSGrupo()
	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "TRB2->VGS = 'S'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB2->(dbgotop())

return

// Filtrar POR CONTIDO
static function z2GrupoFil()

	local cFiltra 	:= ""

	// Monta filtro no TRB1 
	cFiltra :=  "substr(alltrim(TRB2->VGRUPO),1,len(cPGrupo2)) $ '" + substr(Alltrim(cPGrupo2),1,len(cPGrupo2)) + "'"
	//cFiltra :=   "TRB15->DITEMCTA = '" + _cItemConta + "' "
	TRB2->(dbsetfilter({|| &(cFiltra)} , cFiltra))
	TRB2->(dbgotop())

return

// Filtrar exibir todos 
static function z2FilTodos()

	TRB2->(dbclearfil())
	TRB2->(dbgotop())

return

Static Function SFMudaCor(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  
   	  //if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	    	 
    endif
   
    if nIOpcao == 2 // Cor da Fonte
   		if ALLTRIM(TRB1->GRUPO) ==  "100"; _cCor := CLR_HCYAN ; endif
   	  	if ALLTRIM(TRB1->GRUPO) ==  "101"; _cCor := CLR_HCYAN ; endif	  
	  	if ALLTRIM(TRB1->GRUPO) ==  "102"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "103"; _cCor := CLR_HCYAN ; endif	  
		if ALLTRIM(TRB1->GRUPO) ==  "104"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "105"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "106"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "107"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "108"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "109"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "199"; _cCor := CLR_HGREEN ; endif
		if ALLTRIM(TRB1->GRUPO) ==  "200"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "209"; _cCor := CLR_YELLOW ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "299"; _cCor := CLR_YELLOW ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "301"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "501"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "601"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB1->GRUPO) ==  "701"; _cCor := CLR_HCYAN ; endif
		if ALLTRIM(TRB1->GRUPO) ==  "799"; _cCor := CLR_HGREEN ; endif		
		//if ALLTRIM(TRB1->GRUPO) ==  "900"; _cCor := CLR_YELLOW ; endif	
		//if ALLTRIM(TRB1->GRUPO) ==  "901"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "902"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "903"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "904"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "905"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "906"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB1->GRUPO) ==  "908"; _cCor := CLR_HGREEN ; endif
		if ALLTRIM(TRB1->GRUPO) ==  "999"; _cCor := CLR_HGREEN ; endif
		
    endif
Return _cCor



static function zTelaCV()

	// Monta aHeader do TRB2
	
	aadd(aHeader, {" Grupo"						,"VGRUPO",		"",12,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Item"						,"VITEM",		"",60,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Quant.Pri." 				,"VQUANT",		"@E 999,999.999999",14,6,"","","N","TRB2","R"})
	aadd(aHeader, {"Vlr.Unit.Pri."				,"VVUNIT",		"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Total Primary"				,"VTOTAL",		"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Quant.LB."	 				,"VQUANTLB",	"@E 9,999,999.999999",15,6,"","","N","TRB2","R"})
	aadd(aHeader, {"Vlr.Unit.LB."				,"VVUNITLB",	"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Total Large Buyouts"		,"VTOTLB",		"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Quant.EF." 					,"VQUANTEF",	"@E 9,999,999.999999",15,6,"","","N","TRB2","R"})
	aadd(aHeader, {"Vlr.Unit.EF."				,"VVUNITEF",	"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Total Exotic Fab"			,"VTOTEF",		"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"Total Geral"				,"VTOTGR",		"@E 999,999,999.99",15,2,"","","N","TRB2","R"})
	aadd(aHeader, {"No.Proposta"				,"VNPROP",		"",13,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Item Conta" 				,"VITEMCTA",	"",13,0,"","","C","TRB2","R"})
	aadd(aHeader, {"GS"							,"VGS",			"",01,0,"","","C","TRB2","R"})
	aadd(aHeader, {"Pl"							,"VPL",			"",02,0,"","","C","TRB2","R"})
	
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+5  BUTTON 'Exportar Excel' 	Size 60, 10 action(zExpCUVD()) OF oFolder1:aDialogs[3] Pixel
    //@ aPosObj[1,1]-30 , aPosObj[1,2]+70 BUTTON 'Incluir'        	Size 60, 10 action(zIncRegZZM()) OF oFolder1:aDialogs[2] Pixel
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+140 BUTTON 'Salvar/Atualizar'  Size 60, 10 action(zAtualizar()) OF oFolder1:aDialogs[2] Pixel
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+210 BUTTON 'Excluir'       	Size 60, 10 action(zExcZZM()) OF oFolder1:aDialogs[2] Pixel
		
	_oGetDbCUST := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3])-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB2",,,,oFolder1:aDialogs[3])
	
    //_oGetDbCUST:oBrowse:BlDblClick := {|| zEditZZM()}

	// COR DA FONTE
	_oGetDbCUST:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor2(1)}
	// COR DA LINHA
	_oGetDbCUST:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor2(2)} //Cor da Linha
	
return

Static Function SFMudaCor2(nIOpcao)
   Private _cCor := ""
   if nIOpcao == 1 // Cor da Fonte
   	  
   	  //if EMPTY(ALLTRIM(TRB2->DESCRICAO)) .AND. EMPTY(ALLTRIM(TRB2->GRUPO)); _cCor := CLR_LIGHTGRAY; endif
   	    	 
    endif
   
    if nIOpcao == 2 // Cor da Fonte
   		if ALLTRIM(TRB2->VGRUPO) ==  "100"; _cCor := CLR_HCYAN ; endif
   	  	if ALLTRIM(TRB2->VGRUPO) ==  "101"; _cCor := CLR_HCYAN ; endif	  
	  	if ALLTRIM(TRB2->VGRUPO) ==  "102"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "103"; _cCor := CLR_HCYAN ; endif	  
		if ALLTRIM(TRB2->VGRUPO) ==  "104"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "105"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "106"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "107"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "108"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "109"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "199"; _cCor := CLR_HGREEN ; endif
		if ALLTRIM(TRB2->VGRUPO) ==  "200"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "209"; _cCor := CLR_YELLOW ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "299"; _cCor := CLR_YELLOW ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "301"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "501"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "601"; _cCor := CLR_HCYAN ; endif	
		if ALLTRIM(TRB2->VGRUPO) ==  "701"; _cCor := CLR_HCYAN ; endif
		if ALLTRIM(TRB2->VGRUPO) ==  "799"; _cCor := CLR_HGREEN ; endif	
		//if ALLTRIM(TRB2->VGRUPO) ==  "900"; _cCor := CLR_YELLOW ; endif	
		//if ALLTRIM(TRB2->VGRUPO) ==  "901"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "902"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "903"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "904"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "905"; _cCor := CLR_HGREEN ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "906"; _cCor := CLR_YELLOW ; endif
		//if ALLTRIM(TRB2->VGRUPO) ==  "908"; _cCor := CLR_HGREEN ; endif
		if ALLTRIM(TRB2->VGRUPO) ==  "999"; _cCor := CLR_HGREEN ; endif
		if ALLTRIM(TRB2->VGRUPO) =  "907"; _cCor := CLR_HCYAN ; endif	
    endif
Return _cCor

/********************Excluir custo vendido **********************************/
Static Function zExcZZM()
    Local aArea       := GetArea()
    Local aAreaZZM    := ZZM->(GetArea())
    Local nOpcao1      := 0
	Local cGrupo	  := alltrim(TRB1->GRUPO)
    Local cNProp	  := alltrim(TRB1->NPROP)
    Local cItemIC	  := alltrim(TRB1->ITEMCTA)
 
    Private cCadastro 
 
   	cCadastro := "Exclusao Custo Vendido"
    
	DbSelectArea("ZZN")
	ZZN->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZN->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	if substr(Alltrim(TRB1->GRUPO),1,3) $ ("101/102/103/104/105/106/107/108/108/109/301/501/601/701/908/801/803/805/806/802/999") .AND. LEN(Alltrim(TRB1->GRUPO)) > 3
			nOpcao1 := zExcRegZZM()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	Elseif Alltrim(TRB1->GRUPO) $ ("101/102/103/104/105/106/107/108/108/109/301/501/601/701/908/801/803/805/806/802/201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/908")   
			MSGALERT( "Registro nao pode ser excluido.", "Westech" )
			return .F.
	EndIf
	
    RestArea(aAreaZZM)
    RestArea(aArea)
Return

/*****************Exclusao Custo Vendido******************/

static Function zExcRegZZM()

Local oGrupo
Local cGrupo 		:= TRB1->GRUPO
Local oItem
Local cItem 		:= TRB1->ITEM
Local oNProp
Local cNProp    	:= _cNProp
Local oItemCTA
Local cItemCTA  	:= _cItemConta
Local oGS
Local cGS       	:= "S"

Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7
Local _nOpc := 0

Private nQuant  	:= TRB1->QUANT  
Private nVunit  	:= TRB1->VUNIT  
Private nTotal  	:= TRB1->TOTAL  
Private nQuantLB  	:= TRB1->QUANTLB  
Private nVunitLB  	:= TRB1->VUNITLB  
Private nTotLB  	:= TRB1->TOTLB 
Private nQuantEF  	:= TRB1->QUANTEF  
Private nVunitEF  	:= TRB1->VUNITEF  
Private nTotEF  	:= TRB1->TOTEF 
Private oTotal  	:= 0
Private oTotalLB  	:= 0
Private oTotalEF  	:= 0

Static _oDlg

DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Planejado (Contrato)" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
//Group():New( [ nTop ], [ nLeft ], [ nBottom ], [ nRight ], [ cCaption ], [ oWnd ], [ nClrText ], [ nClrPane ], [ lPixel ], [ uParam10 ] )
oGroup1:= TGroup():New(0005,0005,0065,0245,'',_oDlg,,,.T.)

oGroup2:= TGroup():New(0070,0005,0100,0145,'Primary',_oDlg,,,.T.)
oGroup2:= TGroup():New(0070,0150,0100,0245,'',_oDlg,,,.T.)

oGroup3:= TGroup():New(0105,0005,0135,0145,'Large Buyouts',_oDlg,,,.T.)
oGroup3:= TGroup():New(0105,0150,0135,0245,'',_oDlg,,,.T.)

oGroup4:= TGroup():New(0140,0005,0170,0145,'Exotic Fab',_oDlg,,,.T.)
oGroup4:= TGroup():New(0140,0150,0170,0245,'',_oDlg,,,.T.)
	
    @ 013, 010 SAY oSay1 PROMPT "Grupo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
	///if Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222") 
   		@ 022, 010 MSGET oGrupo VAR cGrupo When .F. Picture "@!" Pixel F3 "ZZL2" SIZE 042, 010  COLORS 0, 16777215 PIXEL
    //else
		//@ 022, 010 MSGET oGrupo VAR cGrupo When .T. Picture "@!" Pixel F3 "ZZL" SIZE 042, 010  COLORS 0, 16777215 PIXEL
	//endif
	
    @ 013, 062 SAY oSay2 PROMPT "No.Proposta" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oNProp VAR cNProp When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 122 SAY oSay3 PROMPT "Contrato" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 122 MSGET oItemCTA VAR cItemCTA When .F.  Picture "@!" Pixel F3 "CTD" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 182 SAY oSay4 PROMPT "GS" SIZE 022, 007  COLORS 0, 16777215 PIXEL
    @ 022, 182 MSGET oGS VAR cGS When .F. SIZE 022, 010  COLORS 0, 16777215 PIXEL
    
     /**************/

 	@ 037, 010 SAY oSay5 PROMPT "Item (Descricao Custo)" SIZE 150, 007  COLORS 0, 16777215 PIXEL
	if Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
    	@ 046, 010 MSGET oItem VAR cItem When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	else
		@ 046, 010 MSGET oItem VAR cItem When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	endif   
     /**************/
    
     // primary
	@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 085, 010 MSGET oQuant VAR nQuant When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 085, 080 MSGET oVUnit VAR nVUnit When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
    @ 077, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 086, 180 SAY  oTotal VAR (nQuant * nVUnit) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// large buyouts
	@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 010 MSGET oQuantLB VAR nQuantLB When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 080 MSGET oVUnitLB VAR nVUnitLB When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	
    @ 112, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 121, 180 SAY  oTotalLB VAR (nQuantLB * nVUnitLB) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// EXOTIC FAB
	@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 010 MSGET oQuantEF VAR nQuantEF When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 080 MSGET oVUnitEF VAR nVUnitEF When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
    @ 147, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 156, 180 SAY  oTotalEF VAR (nQuantEF * nVUnitEF) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 180, 079 BUTTON oButton1 PROMPT "Cancelar" Action(_oDlg:End() ) SIZE 039, 010  PIXEL
    @ 180, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End()) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	cGrupo := TRB1->GRUPO
	cNProp := TRB1->NPROP

	If _nOpc = 1
		
			DbSelectArea("ZZN")
			ZZN->( dbSeek( xFilial("ZZN")+cGrupo+cItemCTA) ) 
			Reclock("ZZN",.F.)
			IF ZZN->( dbSeek( xFilial("ZZN")+cGrupo+cItemCTA) ) 
				ZZN->(DbDelete())
			endif	
			MsUnlock()
	
			DbSelectArea("TRB1")
			TRB1->(dbgotop())
			zap
			//MSAguarde({||zGrpsSLC()},"Processando Grupos Proposta")
			MSAguarde({||zCustPlan()},"Processando Detalhamento Custo Planejado")
			TRB1->(DBGoBottom())
			TRB1->(dbgotop())
			GetdRefresh()
	
	Endif

Return _nOpc

/********************Edi��o Faturamento Planejado **********************************/
Static Function zEditZZM()
    Local aArea       := GetArea()
    //Local aAreaZZM    := ZZN->(GetArea())
    Local nOpcao1      := 0
	Local cGrupo	  := alltrim(TRB1->GRUPO)
    Local cNProp	  := alltrim(TRB1->NPROP)
    Local cItemCT	  := alltrim(TRB1->ITEMCTA)
 
    Private cCadastro 
 
   	cCadastro := "Alteracao Custos Vendido"
    
	DbSelectArea("ZZN")
	ZZN->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZN->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If ZZN->(DbSeek(cGrupo+cItemCT))
	        nOpcao1 := zAltTRB1()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	Elseif Alltrim(TRB1->GRUPO) $ ("101/102/103/104/105/106/107/108/108/109/301/501/601/701")
			MSGALERT( "Registro nao pode ser alterado", "Westech" )
			return .F.
	
	
	ELSEIF  !ZZN->(DbSeek(cGrupo+cItemCT)) .AND. Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/908/906/904/903/902/901/801/802/803/804/805/806")   
			nOpcao1 := zAltTRB1()
	        /*If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf */
	Elseif LEN(Alltrim(TRB1->GRUPO)) > 3
			nOpcao1 := zAltTRB1()
	        /*If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf*/
	EndIf
	
    //RestArea(aAreaZZN)
    RestArea(aArea)
Return

/*****************EdiCAOo Custo Vendido******************/

static Function zAltTRB1()

Local oGrupo
Local cGrupo 		:= TRB1->GRUPO
Local oItem
Local cItem 		:= TRB1->ITEM
Local oNProp
Local cNProp    	:= _cNProp
Local oItemCTA
Local cItemCTA  	:= _cItemConta
Local oGS
Local cGS       	:= "S"

Local nTotCUPRV 	:= 0
Local nTotCUPRP 	:= 0
Local nVBAD			:= 0

Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7
Local _nOpc := 0

//local cForCTD	:= "ALLTRIM(QUERYCTD->CTD_ITEM) == _cItemConta"
local nDolar	:= 0

Private nQuant  	:= TRB1->QUANT  
Private nVunit  	:= TRB1->VUNIT  
Private nTotal  	:= TRB1->TOTAL  
Private nQuantLB  	:= TRB1->QUANTLB  
Private nVunitLB  	:= TRB1->VUNITLB  
Private nTotLB  	:= TRB1->TOTLB 
Private nQuantEF  	:= TRB1->QUANTEF  
Private nVunitEF  	:= TRB1->VUNITEF  
Private nTotEF  	:= TRB1->TOTEF 

Private nQuant2  	:= 0
Private nVunit2  	:= 0
Private nQuantLB2  	:= 0
Private nVunitLB2 	:= 0 
Private nTotLB2 	:= 0 
Private nQuantEF2  	:= 0  
Private nVunitEF2  	:= 0  
Private nTotEF2  	:= 0
Private nAntCusto	:= 0
Private nNovoCusto	:= 0
Private nDifCusto	:= 0

Private oTotal  	:= 0
Private oTotalLB  	:= 0
Private oTotalEF  	:= 0
Static _oDlg

//ChkFile("CTD",.F.,"QUERYCTD") // Alias dos movimentos bancarios
//IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_ITEM",,cForCTD,"Selecionando Registros...")
//ProcRegua(QUERYCTD->(reccount()))

nDolar := POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCAMB")

DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Planejado (Contrato)" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
//Group():New( [ nTop ], [ nLeft ], [ nBottom ], [ nRight ], [ cCaption ], [ oWnd ], [ nClrText ], [ nClrPane ], [ lPixel ], [ uParam10 ] )
oGroup1:= TGroup():New(0005,0005,0065,0245,'',_oDlg,,,.T.)

oGroup2:= TGroup():New(0070,0005,0100,0145,'Primary',_oDlg,,,.T.)
oGroup2:= TGroup():New(0070,0150,0100,0245,'',_oDlg,,,.T.)

oGroup3:= TGroup():New(0105,0005,0135,0145,'Large Buyouts',_oDlg,,,.T.)
oGroup3:= TGroup():New(0105,0150,0135,0245,'',_oDlg,,,.T.)

oGroup4:= TGroup():New(0140,0005,0170,0145,'Exotic Fab',_oDlg,,,.T.)
oGroup4:= TGroup():New(0140,0150,0170,0245,'',_oDlg,,,.T.)

    @ 013, 010 SAY oSay1 PROMPT "Grupo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
	///if Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222") 
   		@ 022, 010 MSGET oGrupo VAR cGrupo When .F. Picture "@!" Pixel F3 "ZZL2" SIZE 042, 010  COLORS 0, 16777215 PIXEL
    //else
		//@ 022, 010 MSGET oGrupo VAR cGrupo When .T. Picture "@!" Pixel F3 "ZZL" SIZE 042, 010  COLORS 0, 16777215 PIXEL
	//endif
	
    @ 013, 062 SAY oSay2 PROMPT "No.Proposta" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oNProp VAR cNProp When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 122 SAY oSay3 PROMPT "Contrato" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 122 MSGET oItemCTA VAR cItemCTA  Picture "@!" Pixel F3 "CTD" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 182 SAY oSay4 PROMPT "GS" SIZE 022, 007  COLORS 0, 16777215 PIXEL
    @ 022, 182 MSGET oGS VAR cGS When .F. SIZE 022, 010  COLORS 0, 16777215 PIXEL
    
     /**************/

 	@ 037, 010 SAY oSay5 PROMPT "Item (Descricao Custo)" SIZE 150, 007  COLORS 0, 16777215 PIXEL
	if Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
    	@ 046, 010 MSGET oItem VAR cItem When .F. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	else
		@ 046, 010 MSGET oItem VAR cItem When .T. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	endif   
     /**************/
    // primary
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "1" .OR. substring(cGrupo,1,1) = "2" .OR. substring(cGrupo,1,1) = "8" .OR. substring(cGrupo,1,1) = "9"
		@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 010 MSGET oQuant VAR nQuant PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 080 MSGET oVUnit VAR nVUnit PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	ELSE
		@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 010 MSGET oQuant VAR nQuant When .F. PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 080 MSGET oVUnit VAR nVUnit When .F. PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	ENDIF
    
    @ 077, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 086, 180 SAY  oTotal VAR (nQuant * nVUnit) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// large buyouts
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "2" .OR. substring(cGrupo,1,1) = "2".OR. substring(cGrupo,1,1) = "8" .OR. substring(cGrupo,1,1) = "9"
		@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oQuantLB VAR nQuantLB PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 080 MSGET oVUnitLB VAR nVUnitLB PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	else
		@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oQuantLB VAR nQuantLB  When .F. PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 080 MSGET oVUnitLB VAR nVUnitLB  When .F. PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	endif	
    @ 112, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 121, 180 SAY  oTotalLB VAR (nQuantLB * nVUnitLB) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// EXOTIC FAB
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "3" .OR. substring(cGrupo,1,1) = "2".OR. substring(cGrupo,1,1) = "8" .OR. substring(cGrupo,1,1) = "9"
		@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 010 MSGET oQuantEF VAR nQuantEF PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 080 MSGET oVUnitEF VAR nVUnitEF PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	else
		@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 010 MSGET oQuantEF VAR nQuantEF  When .F. PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 080 MSGET oVUnitEF VAR nVUnitEF  When .F. PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	endif

    
    @ 147, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 156, 180 SAY  oTotalEF VAR (nQuantEF * nVUnitEF) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 180, 079 BUTTON oButton1 PROMPT "Cancelar" Action(_oDlg:End() ) SIZE 039, 010  PIXEL
    @ 180, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End()) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if EMPTY(cGrupo) 
		MSGALERT( "Informe nome do Grupo." , "Westech" )
		_nOpc := 2
	ENDIF

	/*if EMPTY(cItemCTA)
		MSGALERT( "Informe Contrato." , "Westech" )
		_nOpc := 2
	ENDIF*/

	if EMPTY(cItem)
		MSGALERT( "Informe Item (Descricao)." , "Westech" )
		_nOpc := 2
	ENDIF


	//DbSelectArea("CTD")
	//CTD->(DbSetOrder(1)) 
	//CTD->(DbSeek(xFilial('CTD')+_cItemConta))

	nQuant2  	:= nQuant
	nVunit2  	:= nVunit
	nQuantLB2  	:= nQuantLB
	nVunitLB2 	:= nVunitLB
	nTotLB2 	:= nTotLB 
	nQuantEF2  	:= nQuantEF
	nVunitEF2  	:= nVunitEF 
	nTotEF2  	:= nTotEF2


	nAntCusto	:= (TRB1->QUANT  * TRB1->VUNIT) + (TRB1->QUANTLB * TRB1->VUNITLB) + (TRB1->QUANTEF  * TRB1->VUNITEF)
	nNovoCusto	:= (nQuant2 * nVUnit2) + (nQuantLB2 * nVUnitLB2) + (nQuantEF2 * nVUnitEF2)
	nDifCusto	:= nNovoCusto -nAntCusto 
	
	nTotCUPRV		:= CTD->CTD_XCUSTO	
	nTotCUPRP		:= CTD->CTD_XCUPRR		
	nVBAD			:= CTD->CTD_XVBAD

	//cValToChar(Transform(nTotalNF, "@E 999,999,999.99" ))
	if !alltrim(cGrupo) $ ("907/908/906/904/903/902/901/801/803/804/805/806/802")
		if 	nDifCusto > 0  
			if (nTotCUPRP+nDifCusto) > (nTotCUPRV+nVBAD)
				_nOpc := 2
				MSGALERT(cGrupo + "Operacao nao pode ser realizada porque supera realizada porque supera verba do contrato..." + chr(13) + chr(10) + ;
						"Custo Atual: " + cValToChar(Transform(nTotCUPRV, "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
						"Verba Adicional:" + cValToChar(Transform(nVBAD, "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
						"Limite Verba Total:"  + cValToChar(Transform((nTotCUPRV+nVBAD), "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
						"Verba restante: " + cValToChar(Transform((nTotCUPRV+nVBAD)-(nTotCUPRP), "@E 999,999,999.99" ))    )
						//QUERYCTD->(DbCloseArea())
				return .F.
			endif
		ENDIF
	endif

  	If _nOpc = 1

		Reclock("TRB1",.F.)
	 
	  		TRB1->GRUPO	 	:= cGrupo
	  		TRB1->ITEM		:= cItem 
	  		TRB1->QUANT		:= nQuant
			TRB1->VUNIT		:= nVUnit
	  		TRB1->TOTAL		:= nQuant * nVUnit

			// R$
			TRB1->QUANTLB	:= nQuantLB
			TRB1->VUNITLB	:= nVUnitLB
	  		TRB1->TOTLB		:= nQuantLB * nVUnitLB

			TRB1->QUANTEF	:= nQuantEF
			TRB1->VUNITEF	:= nVUnitEF
	  		TRB1->TOTEF		:= nQuantEF * nVUnitEF

			TRB1->TOTGR		:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)

			// us$
			TRB1->VUNITD	:= nVUnit / nDolar
	  		TRB1->TOTALD	:= (nQuant * nVUnit) / nDolar

			TRB1->UNITLD	:= nVUnitLB / nDolar
	  		TRB1->TOTLD		:= (nQuantLB * nVUnitLB) / nDolar

			TRB1->UNITED	:= nVUnitEF / nDolar
	  		TRB1->TOTED		:= (nQuantEF * nVUnitEF) / nDolar

			TRB1->TOTGRD	:= ((nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)) / nDolar

			TRB1->NPROP		:= cNProp
			TRB1->ITEMCTA	:= cItemCTA
	  	 		
	  	MsUnlock()
		
	  	DbSelectArea("TRB1")
		TRB1->(dbgotop())
		/*Zap
		MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")
		TRB1->(DBGoBottom())
		TRB1->(dbgotop())*/
	  	GetdRefresh()

		//QUERYCTD->(DbCloseArea())
    endif
	
  	/*
	SZF->(DbGoTop())
    TSZF->(DbCloseArea()) 
    QUERY2->(DbCloseArea()) 
	*/



Return _nOpc

/******************* Inserir custo vendido ************************/

static function zIncRegZZM()

Local oGrupo
Local cGrupo 		:= space(6)
Local oItem
Local cItem 		:= space(80)
Local oNProp
Local cNProp    	:= _cNProp
Local oItemCTA
Local cItemCTA  	:= _cItemConta
Local oGS
Local cGS       	:= "S"
local nTotReg 		:= 0
local nTotRegLB 	:= 0
local nTotRegEF		:= 0

Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7
Local _nOpc 		:= 0
Local cSubGrupo 	:=	""
Local cSubGrupoLB 	:=	""
Local cSubGrupoEF 	:=	""

local cForCTD	:= "ALLTRIM(QUERYCTD->CTD_ITEM) == _cItemConta"
local nDolar	:= 0

Private nQuant  	:= 0 //TRB1->QUANT  
Private nVunit  	:= 0 //TRB1->VUNIT  
Private nTotal  	:= 0 //TRB1->TOTAL  
Private nQuantLB  	:= 0 //TRB1->QUANTLB  
Private nVunitLB  	:= 0 //TRB1->VUNITLB  
Private nTotLB  	:= 0 //TRB1->TOTLB 
Private nQuantEF  	:= 0 //TRB1->QUANTEF  
Private nVunitEF  	:= 0 //TRB1->VUNITEF  
Private nTotEF  	:= 0 //TRB1->TOTEF 
Private oTotal  	:= 0
Private oTotalLB  	:= 0
Private oTotalEF  	:= 0
Private nQuant2  	:= 0
Private nVunit2  	:= 0
Private nQuantLB2  	:= 0
Private nVunitLB2 	:= 0 
Private nTotLB2 	:= 0 
Private nQuantEF2  	:= 0  
Private nVunitEF2  	:= 0  
Private nTotEF2  	:= 0
Private nAntCusto	:= 0
Private nNovoCusto	:= 0
Private nDifCusto	:= 0

Static _oDlg

ChkFile("CTD",.F.,"QUERYCTD") // Alias dos movimentos bancarios
IndRegua("QUERYCTD",CriaTrab(NIL,.F.),"CTD_FILIAL+CTD_ITEM",,cForCTD,"Selecionando Registros...")
ProcRegua(QUERYCTD->(reccount()))

nDolar := QUERYCTD->CTD_XCAMB

TRB1->(dbclearfil())

DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Planejado (Contrato)" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
//Group():New( [ nTop ], [ nLeft ], [ nBottom ], [ nRight ], [ cCaption ], [ oWnd ], [ nClrText ], [ nClrPane ], [ lPixel ], [ uParam10 ] )
oGroup1:= TGroup():New(0005,0005,0065,0245,'',_oDlg,,,.T.)

oGroup2:= TGroup():New(0070,0005,0100,0145,'Primary',_oDlg,,,.T.)
oGroup2:= TGroup():New(0070,0150,0100,0245,'',_oDlg,,,.T.)

oGroup3:= TGroup():New(0105,0005,0135,0145,'Large Buyouts',_oDlg,,,.T.)
oGroup3:= TGroup():New(0105,0150,0135,0245,'',_oDlg,,,.T.)

oGroup4:= TGroup():New(0140,0005,0170,0145,'Exotic Fab',_oDlg,,,.T.)
oGroup4:= TGroup():New(0140,0150,0170,0245,'',_oDlg,,,.T.)

    @ 013, 010 SAY oSay1 PROMPT "Grupo" SIZE 020, 007  COLORS 0, 16777215 PIXEL
    @ 022, 010 MSGET oGrupo VAR cGrupo When .T. Picture "@!" Pixel F3 "ZZL2" SIZE 042, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 062 SAY oSay2 PROMPT "No.Proposta" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 062 MSGET oNProp VAR cNProp When .F. SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 122 SAY oSay3 PROMPT "Contrato" SIZE 052, 007  COLORS 0, 16777215 PIXEL
    @ 022, 122 MSGET oItemCTA VAR cItemCTA When .T. Picture "@!" Pixel F3 "CTD" SIZE 052, 010  COLORS 0, 16777215 PIXEL
    
    @ 013, 182 SAY oSay4 PROMPT "GS" SIZE 022, 007  COLORS 0, 16777215 PIXEL
    @ 022, 182 MSGET oGS VAR cGS When .F. SIZE 022, 010  COLORS 0, 16777215 PIXEL
    
     /**************/

 	@ 037, 010 SAY oSay5 PROMPT "Item (Descricao Custo)" SIZE 150, 007  COLORS 0, 16777215 PIXEL
    @ 046, 010 MSGET oItem VAR cItem When .T. SIZE 230, 010  COLORS 0, 16777215 PIXEL
	   
     /**************/
    
     // primary
	@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 085, 010 MSGET oQuant VAR nQuant PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 085, 080 MSGET oVUnit VAR nVUnit PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
    @ 077, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 086, 180 SAY  oTotal VAR (nQuant * nVUnit) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// large buyouts
	@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 010 MSGET oQuantLB VAR nQuantLB PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 080 MSGET oVUnitLB VAR nVUnitLB PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	
    @ 112, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 121, 180 SAY  oTotalLB VAR (nQuantLB * nVUnitLB) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// EXOTIC FAB
	@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 010 MSGET oQuantEF VAR nQuantEF PICTURE PesqPict("ZZN","ZZN_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 080 MSGET oVUnitEF VAR nVUnitEF PICTURE PesqPict("ZZN","ZZN_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
    @ 147, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 156, 180 SAY  oTotalEF VAR (nQuantEF * nVUnitEF) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

    //@ 049, 061 MSGET oGet4 VAR nValor PICTURE PesqPict("SE2","E2_VALOR") SIZE 060, 010 OF oPanel2 COLORS 0, 16777215 PIXEL
    @ 180, 079 BUTTON oButton1 PROMPT "Cancelar" Action(_oDlg:End() ) SIZE 039, 010  PIXEL
    @ 180, 127 BUTTON oButton2 PROMPT "OK" Action( _nOpc := 1, _oDlg:End()) SIZE 039, 010  PIXEL

  ACTIVATE MSDIALOG _oDlg CENTERED

	if EMPTY(cGrupo) 
		MSGALERT( "Informe nome do Grupo." , "Westech" )
		_nOpc := 2
		RETURN .F.
	ENDIF

	if EMPTY(cItem)
		MSGALERT( "Informe Item (Descricao)." , "Westech" )
		_nOpc := 2
		RETURN .F.
	ENDIF

	if alltrim(cGrupo) $ ("201/202/203/204/205/206/207/210/211/212/213/217/218/220/221/222")
		msginfo("Nao e possivel inserir registro no grupo Mao-de-Obra, de um clique duplo no registro para editar e informe os dados.")
		return .F.
	ENDIF

	if !alltrim(cGrupo) $ ("101/102/103/104/105/106/107/108/109/301/501/601/701")
		msginfo("Grupo informado nao pertence ao Grupo de Custos.")
		return .F.
	ENDIF

	DbSelectArea("CTD")
	CTD->(DbSetOrder(1)) 
	CTD->(DbSeek(xFilial('CTD')+_cItemConta))
	
	nTotCUPRV		:= CTD->CTD_XCUSTO	
	nTotCUPRP		:= CTD->CTD_XCUPRR		
	nVBAD			:= CTD->CTD_XVBAD	

	nQuant2  	:= nQuant
	nVunit2  	:= nVunit
	nQuantLB2  	:= nQuantLB
	nVunitLB2 	:= nVunitLB
	nTotLB2 	:= nTotLB 
	nQuantEF2  	:= nQuantEF
	nVunitEF2  	:= nVunitEF 
	nTotEF2  	:= nTotEF2

	nNovoCusto	:= (nQuant2 * nVUnit2) + (nQuantLB2 * nVUnitLB2) + (nQuantEF2 * nVUnitEF2)
	
	nTotCUPRV		:= CTD->CTD_XCUSTO	
	nTotCUPRP		:= CTD->CTD_XCUPRR		
	nVBAD			:= CTD->CTD_XVBAD	

	/*
	if 	(nTotCUPRP+nNovoCusto) > nTotCUPRV+nVBAD
		_nOpc := 2
		MSGALERT("Operacao nao pode ser realizada porque supera realizada porque supera verba do contrato."+ ;
					"Custo Atual: " + cValToChar(Transform(nTotCUPRV, "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
					"Verba Adicional:" + cValToChar(Transform(nVBAD, "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
					"Limite Verba Total:"  + cValToChar(Transform((nTotCUPRV+nVBAD), "@E 999,999,999.99" ))  + chr(13) + chr(10) + ;
					"Verba restante: " + cValToChar(Transform((nTotCUPRV+nVBAD)-(nTotCUPRP), "@E 999,999,999.99" ))    )
					QUERYCTD->(DbCloseArea())
		return .F.
	ENDIF
	*/
	DbSelectArea("ZZN")
	ZZN->(DbSetOrder(1)) 
	ZZN->(DbGoTop())

	If _nOpc = 1
		// PRIMARY
		if (nQuant * nVUnit) > 0
			cQuery := " SELECT * FROM ZZN010 WHERE ZZN_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZN_ITEMCT = '" + cItemCTA + "' AND LEN(ZZN_GRUPO) > 3 "
			TCQuery cQuery New Alias "TZZNG"
					
			Count To nTotReg
			TZZNG->(DbGoTop()) 
			nTotReg := nTotReg+1

			cSubGrupo	:= alltrim(cGrupo) + "-1" + cValToChar(nTotReg)
			//msginfo(cSubGrupo)

			cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZN010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZN010) "
			TCQuery cQuery2 New Alias "TZZN"

			ZZN->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZN->RECNO+1
				ZZN->ZZN_FILIAL	:= "01"
				ZZN->ZZN_GRUPO	:= cSubGrupo
				ZZN->ZZN_ITEM	:= cItem 
				ZZN->ZZN_QUANT	:= nQuant
				ZZN->ZZN_VUNIT	:= nVUnit
				ZZN->ZZN_TOTAL	:= nQuant * nVUnit
				ZZN->ZZN_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)

				ZZN->ZZN_VUNITD	:= nVUnit / nDolar
				ZZN->ZZN_TOTALD	:= (nQuant * nVUnit) / nDolar
				ZZN->ZZN_TOTGRD	:= ((nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)) / nDolar

				ZZN->ZZN_NPROP	:= cNProp
				ZZN->ZZN_ITEMCT	:= cItemCTA
				ZZN->ZZN_GS		:= "S"
			ZZN->( DBCommit() )

			TZZNG->(DbCloseArea())
  			TZZN->(DbCloseArea())
		endif
		// LARGE BUYOUTS
		if (nQuantLB * nVUnitLB) > 0
			cQueryLB := " SELECT * FROM ZZN010 WHERE ZZN_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZN_ITEMCT = '" + cItemCTA + "' AND LEN(ZZN_GRUPO) > 3 "
			TCQuery cQueryLB New Alias "TZZNGLB"
					
			Count To nTotRegLB
			TZZNGLB->(DbGoTop()) 
			nTotRegLB := nTotRegLB+1

			cSubGrupoLB	:= alltrim(cGrupo) + "-2" + cValToChar(nTotRegLB)
			//msginfo(cSubGrupo)

			cQuery2LB := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZN010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZN010) "
			TCQuery cQuery2LB New Alias "TZZNLB"

			ZZN->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZNLB->RECNO+1
				ZZN->ZZN_FILIAL	:= "01"
				ZZN->ZZN_GRUPO	:= cSubGrupoLB
				ZZN->ZZN_ITEM	:= cItem 
				ZZN->ZZN_QTDLB	:= nQuantLB
				ZZN->ZZN_UNITLB	:= nVUnitLB
				ZZN->ZZN_TOTLB	:= nQuantLB * nVUnitLB
				ZZN->ZZN_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)

				ZZN->ZZN_UNITLD	:= nVUnitLB / nDolar
				ZZN->ZZN_TOTLD	:= (nQuantLB * nVUnitLB) / nDolar
				ZZN->ZZN_TOTGRD	:= ((nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)) / nDolar

				ZZN->ZZN_NPROP	:= cNProp
				ZZN->ZZN_ITEMCT	:= cItemCTA
				ZZN->ZZN_GS		:= "S"
			ZZN->( DBCommit() )

			TZZNGLB->(DbCloseArea())
  			TZZNLB->(DbCloseArea())
		endif
		// EXOTIC FAB
		if (nQuantEF * nVUnitEF) > 0
			cQueryEF := " SELECT * FROM ZZN010 WHERE ZZN_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZN_ITEMCT = '" + cItemCTA + "' AND LEN(ZZN_GRUPO) > 3 "
			TCQuery cQueryEF New Alias "TZZNGEF"
					
			Count To nTotRegEF
			TZZNGEF->(DbGoTop()) 
			nTotRegEF := nTotRegEF+1

			cSubGrupoEF	:= alltrim(cGrupo) + "-3" + cValToChar(nTotRegEF)
			//msginfo(cSubGrupo)

			cQuery2EF := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZN010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZN010) "
			TCQuery cQuery2EF New Alias "TZZNEF"

			ZZN->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZNEF->RECNO+1
				ZZN->ZZN_FILIAL	:= "01"
				ZZN->ZZN_GRUPO	:= cSubGrupoEF
				ZZN->ZZN_ITEM	:= cItem 
				ZZN->ZZN_QTDEF	:= nQuantEF
				ZZN->ZZN_UNITEF	:= nVUnitEF
				ZZN->ZZN_TOTEF	:= nQuantEF * nVUnitEF
				ZZN->ZZN_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)

				ZZN->ZZN_UNITED	:= nVUnitEF / nDolar
				ZZN->ZZN_TOTED	:= (nQuantEF * nVUnitEF) / nDolar
				ZZN->ZZN_TOTGRD	:= ((nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)) / nDolar

				ZZN->ZZN_NPROP	:= cNProp
				ZZN->ZZN_ITEMCT	:= cItemCTA

				ZZN->ZZN_GS		:= "S"
			ZZN->( DBCommit() )

			TZZNGEF->(DbCloseArea())
  			TZZNEF->(DbCloseArea())
		endif

		
		QUERYCTD->(DbCloseArea())
		DbSelectArea("TRB1")
		TRB1->(dbgotop())
		zap
		MSAguarde({||zCustPlan()},"Processando Detalhamento Custo Planejado")
		TRB1->(DBGoBottom())
		TRB1->(dbgotop())
		zGrpsSLC()
		GetdRefresh()
	Endif

	
	TRB1->(dbgotop())
	//QUERYCTD->(DbCloseArea())

	//TZZNG->(DbCloseArea())
  	//TZZM->(DbCloseArea())
  
Return _nOpc

/********************* Cabeçalho formulário principal ******************/
static function zCabecGC()
  //oGroup1:= TGroup():New(LS-TOP,CE-LEFT,LI-BOTTOM,CD-RIGTH,'',oFolder1:aDialogs[1] ,,,.T.)
	oGroup1:= TGroup():New(0009,0015,0033,0730,'',oFolder1:aDialogs[1] ,,,.T.)
	oGroup2:= TGroup():New(0034,0015,0060,0345,'Venda',oFolder1:aDialogs[1] ,,,.T.)
	oGroup3:= TGroup():New(0034,0350,0060,0730,'Venda Revisado',oFolder1:aDialogs[1] ,,,.T.)
	
	oGroup4:= TGroup():New(0061,0015,0090,0345,'Custo Vendido',oFolder1:aDialogs[1] ,,,.T.)
	oGroup5:= TGroup():New(0061,0350,0090,0730,'Custo Revisado',oFolder1:aDialogs[1] ,,,.T.)

	oGroup4:= TGroup():New(0094,0015,0126,0345,'Venda / Custo US$ ',oFolder1:aDialogs[1] ,,,.T.)
	oGroup5:= TGroup():New(0094,0350,0126,0730,'--------',oFolder1:aDialogs[1] ,,,.T.)

	@ 0010,0020 Say  "Item Conta: " COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0020 MSGET  _cItemConta  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0010,0120 Say  "No.Proposta: "  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0120 MSGET alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_NPROP")) COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0010,0200 Say  "Cod.Cliente: " 	 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0200 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCLIEN")) COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0010,0280 Say  "Cliente: " COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0280 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNREDU")) COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0010,0480 Say  "Coord.Cod.: " COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0480 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XIDPM")) COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0010,0540 Say  "Coordenador " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0018,0540 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XNOMPM")) COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// venda R$
	@ 0038,0040 Say  "c/ Tributos " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0038,0100 Say  "s/ Tributos " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSI"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0038,0160 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// Venda US$
	@ 0100,0040 Say  "Venda c/ Tributos US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0100,0100 Say  "Venda s/ Tributos US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSID"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	// custo vendido US$
	@ 0100,0160 Say  "Custo Producao US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0100,0220 Say  "Custo Total US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0220 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// Vendas R$
	@ 0038,0400 Say  "c/ Tributos  " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0038,0460 Say  "s/ Tributos  " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVDSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0038,0520 Say  "s/ Tributos (s/Frete) " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0046,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XSISFR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	//@ 0038,0580 Say  "Venda c/ Tributos  US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	//@ 0046,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	//@ 0038,0640 Say  "Venda s/ Tributos  US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	//@ 0046,0640 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// Custo vendido R$
	@ 0067,0040 Say  "Producao " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0040 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUSTO"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0100 Say  "COGS Vendido " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0100 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSV"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0160 Say  "Total " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0160 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOT"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0220 Say  "Data Cambio " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0220 MSGET  alltrim(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XDTCB")) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0280 Say  "Vlr. Cambio " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0280 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCAMB"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// Custo Revisado R$
	@ 0067,0400 Say  "Producao " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0460 Say  "COGS REV. " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCOGSR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0520 Say  "Total" 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTOR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0067,0580 Say  "Verba adicional" 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0075,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVBAD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.

	// custo vendido US$ revisado

	@ 0100,0400 Say  "Venda c/ Tributos  US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0400 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVCIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0100,0460 Say  "Venda s/ Tributos  US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0460 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XVSIR"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	// vendido US$ revisado US$
	@ 0100,0520 Say  "Custo Producao US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0520 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUPRD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	
	@ 0100,0580 Say  "Custo Total US$ " 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
	@ 0108,0580 MSGET  transform(POSICIONE("CTD",1,XFILIAL("CTD")+_cItemConta,"CTD_XCUTRD"), "@E 999,999,999.99" ) SIZE 56,10 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL VALID !Vazio() WHEN .F.
	

RETURN

// Salvar e Atualizar 
static function zAtuSalvar()
	zAtualizar()
	zAtualizar()
return

static function zAtualizar()

	    Local cGrupo 		:= ""
		Local cNProp 		:= ""
		Local cItemCTA 		:= ""
		Local nTotGRS	 	:= 0
		local nTotGR200		:= 0
		Local nTotGRSLB 	:= 0
		local nTotGR200LB	:= 0
		Local nTotGRSEF 	:= 0
		local nTotGR200EF	:= 0
		Local nTotGRSGR 	:= 0
		local nTotGR200GR	:= 0
		Local nTotGRS 		:= 0
		local _cQuery 		:= ""
		Local _cFilZZN 		:= xFilial("ZZN")
		local cFor 			:= "ALLTRIM(QUERY->ZZN_ITEMCT) == _cItemConta"
	
		local nTotPR 		:= 0
		local nTotLB 		:= 0
		local nTotEF 		:= 0
		local nTotGR 		:= 0

		TRB1->(dbclearfil())
		TRB1->(DbGoTop())

		DbSelectArea("ZZM")
		ZZN->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZN->(DbGoTop())

		// Totalizando Grupos
		DbSelectArea("ZZL")
		ZZL->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZL->(DbGoTop())

		
		TRB1->(DbGoTop())
		while TRB1->(!eof())
			cGrupo 		:= TRB1->GRUPO
			cNProp 		:= alltrim(TRB1->NPROP) 
			cItemCTA 	:= _cItemConta
			//msginfo("Inicio" + cGrupo + cNProp)
			
			IF ZZN->( dbSeek( xFilial("ZZN")+cGrupo+_cItemConta) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/907/999")
					Reclock("ZZN",.F.)
						//msginfo("Edit" + cGrupo + cNProp)	
						ZZN->ZZN_FILIAL	:= "01"
						ZZN->ZZN_GRUPO	:= TRB1->GRUPO
						ZZN->ZZN_ITEM	:= TRB1->ITEM	
						//PRIMARY	
						ZZN->ZZN_QUANT	:= TRB1->QUANT	
						ZZN->ZZN_VUNIT	:= TRB1->VUNIT
						ZZN->ZZN_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZN->ZZN_QTDLB	:= TRB1->QUANTLB	
						ZZN->ZZN_UNITLB	:= TRB1->VUNITLB
						ZZN->ZZN_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZN->ZZN_QTDEF	:= TRB1->QUANTEF	
						ZZN->ZZN_UNITEF	:= TRB1->VUNITEF
						ZZN->ZZN_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZN->ZZN_TOTGR	:= TRB1->TOTGR 
						
						//PRIMARY US$		
						ZZN->ZZN_VUNITD	:= TRB1->VUNITD
						ZZN->ZZN_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZN->ZZN_UNITLD	:= TRB1->UNITLD
						ZZN->ZZN_TOTLD	:= TRB1->TOTLD
						// EXOTIC FAB US$	
						ZZN->ZZN_UNITED	:= TRB1->UNITED
						ZZN->ZZN_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZN->ZZN_TOTGRD	:= TRB1->TOTGRD 


						ZZN->ZZN_NPROP 	:= TRB1->NPROP		
						ZZN->ZZN_ITEMCT	:= TRB1->ITEMCTA
						ZZN->ZZN_GS		:= TRB1->GS
					MsUnlock()
		
			elseIF !ZZN->( dbSeek( xFilial("ZZN")+cGrupo+_cItemConta) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/907/999")
					ZZN->( DBAppend( .F. ) )
						//msginfo("append" + cGrupo + cNProp)
						ZZN->ZZN_FILIAL	:= "01"
						ZZN->ZZN_GRUPO	:= TRB1->GRUPO
						ZZN->ZZN_ITEM	:= TRB1->ITEM	
						//PRIMARY	
						ZZN->ZZN_QUANT	:= TRB1->QUANT	
						ZZN->ZZN_VUNIT	:= TRB1->VUNIT
						ZZN->ZZN_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZN->ZZN_QTDLB	:= TRB1->QUANTLB	
						ZZN->ZZN_UNITLB	:= TRB1->VUNITLB
						ZZN->ZZN_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZN->ZZN_QTDEF	:= TRB1->QUANTEF	
						ZZN->ZZN_UNITEF	:= TRB1->VUNITEF
						ZZN->ZZN_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZN->ZZN_TOTGR	:= TRB1->TOTGR 

						//PRIMARY US$		
						ZZN->ZZN_VUNITD	:= TRB1->VUNITD
						ZZN->ZZN_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZN->ZZN_UNITLD	:= TRB1->UNITLD
						ZZN->ZZN_TOTLD	:= TRB1->TOTLD
						// EXOTIC FAB US$	
						ZZN->ZZN_UNITED	:= TRB1->UNITED
						ZZN->ZZN_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZN->ZZN_TOTGRD	:= TRB1->TOTGRD 

						ZZN->ZZN_NPROP 	:= TRB1->NPROP		
						ZZN->ZZN_ITEMCT	:= TRB1->ITEMCTA
						ZZN->ZZN_GS		:= TRB1->GS
					ZZN->( DBCommit() )
			ENDIF
			
			TRB1->(dbskip())
		enddo

		
	  	DbSelectArea("TRB1")
		TRB1->(dbgotop())
		zap
		MSAguarde({||zCustPlan()},"Processando Detalhamento Custo Planejado")
		TRB1->(DBGoBottom())
		TRB1->(dbgotop())
		GetdRefresh()

		zAtuCustZ9()
		

TRB1->(dbgotop())

//QUERYCTD->(DbCloseArea())

return

static function zSalvar()
		
		Local cGrupo 		:= ""
		Local cNProp 		:= ""
		Local nTotalGRS 	:= 0
		Local nTotalGR200 	:= 0

		TRB1->(DbGoTop())

		DbSelectArea("ZZN")
		ZZN->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZN->(DbGoTop())
		
		while TRB1->(!eof())
			cGrupo := TRB1->GRUPO
			cNProp := TRB1->NPROP
			//msginfo("Inicio" + cGrupo + cNProp)
			IF cGrupo $ ("199/209/299/799")
				TRB1->(dbskip())
				cGrupo := ALLTRIM(TRB1->GRUPO)
			ENDIF

			ZZN->( dbSeek( xFilial("ZZN")+cGrupo+_cItemConta) ) 
			IF ZZN->( dbSeek( xFilial("ZZN")+cGrupo+_cItemConta) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/907/999")
				Reclock("ZZN",.F.)
					//msginfo("Edit" + cGrupo + cNProp)	
					ZZN->ZZN_FILIAL	:= "01"
					ZZN->ZZN_GRUPO	:= TRB1->GRUPO
					ZZN->ZZN_ITEM	:= TRB1->ITEM	
					//PRIMARY	
						ZZN->ZZN_QUANT	:= TRB1->QUANT	
						ZZN->ZZN_VUNIT	:= TRB1->VUNIT
						ZZN->ZZN_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZN->ZZN_QTDLB	:= TRB1->QUANTLB	
						ZZN->ZZN_UNITLB	:= TRB1->VUNITLB
						ZZN->ZZN_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZN->ZZN_QTDEF	:= TRB1->QUANTEF	
						ZZN->ZZN_UNITEF	:= TRB1->VUNITEF
						ZZN->ZZN_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZN->ZZN_TOTGR	:= TRB1->TOTGR 

					//PRIMARY US$		
						ZZN->ZZN_VUNITD	:= TRB1->VUNITD
						ZZN->ZZN_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZN->ZZN_UNITLD	:= TRB1->UNITLD
						ZZN->ZZN_TOTLD	:= TRB1->TOTLD
						// EXOTIC FAB US$	
						ZZN->ZZN_UNITED	:= TRB1->UNITED
						ZZN->ZZN_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZN->ZZN_TOTGRD	:= TRB1->TOTGRD 

					ZZN->ZZN_NPROP 	:= TRB1->NPROP		
					ZZN->ZZN_ITEMCT	:= TRB1->ITEMCTA
					ZZN->ZZN_GS		:= TRB1->GS
				MsUnlock()
			ENDIF
			
			IF !ZZN->( dbSeek( xFilial("ZZN")+cGrupo+_cItemConta) ) .AND. !alltrim(cGrupo) $ ("199/209/299/799/907/999")
				ZZN->( DBAppend( .F. ) )
					//msginfo("append" + cGrupo + cNProp)
					ZZN->ZZN_FILIAL	:= "01"
					ZZN->ZZN_GRUPO	:= TRB1->GRUPO
					ZZN->ZZN_ITEM	:= TRB1->ITEM	
					//PRIMARY	
						ZZN->ZZN_QUANT	:= TRB1->QUANT	
						ZZN->ZZN_VUNIT	:= TRB1->VUNIT
						ZZN->ZZN_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZN->ZZN_QTDLB	:= TRB1->QUANTLB	
						ZZN->ZZN_UNITLB	:= TRB1->VUNITLB
						ZZN->ZZN_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZN->ZZN_QTDEF	:= TRB1->QUANTEF	
						ZZN->ZZN_UNITEF	:= TRB1->VUNITEF
						ZZN->ZZN_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZN->ZZN_TOTGR	:= TRB1->TOTGR 

					//PRIMARY US$		
						ZZN->ZZN_VUNITD	:= TRB1->VUNITD
						ZZN->ZZN_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZN->ZZN_UNITLD	:= TRB1->UNITLD
						ZZN->ZZN_TOTLD	:= TRB1->TOTLD
						// EXOTIC FAB US$	
						ZZN->ZZN_UNITED	:= TRB1->UNITED
						ZZN->ZZN_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZN->ZZN_TOTGRD	:= TRB1->TOTGRD 

					ZZN->ZZN_NPROP 	:= TRB1->NPROP		
					ZZN->ZZN_ITEMCT	:= TRB1->ITEMCTA
					ZZN->ZZN_GS		:= TRB1->GS
				ZZN->( DBCommit() )
			ENDIF
			
			TRB1->(dbskip())
		enddo

		zAtuCustZ9()
		
		TRB1->(dbgotop())
	
		_oDlgPln:End()

Return 

//************** ATUALIZAR CUSTO DE PRODUCAO E CUSTO TOTAL

static function zAtuCustZ9()
	
		local nTotalCUPR := 0
		local nTotalCUTO := 0
		local nTotCUPRD := 0
		local nTotCUTOD := 0
		local nTCUPRVD := 0
		local nTCUTOVD := 0
		local nTCOGS := 0
		local nTCOGSD := 0
		local nComiss 	:= 0
		local nContar := 0

		cQuery := " SELECT ZZN_ITEMCT AS 'TMP_ITEMCT' FROM ZZN010 WHERE ZZN_ITEMCT = '" + _cItemConta + "' AND D_E_L_E_T_ <> '*' "
		TCQuery cQuery New Alias "TZZN"
				
		Count To nTotReg
		TZZN->(DbGoTop()) 

    	nContar := nTotReg

		if nContar > 0

			TRB1->(dbgotop())
			while TRB1->(!eof())
				IF  alltrim(TRB1->ITEMCTA) = _cItemConta .AND. alltrim(TRB1->GRUPO) = "999"
					nTotalCUTO		:= TRB1->TOTGR 
					nTotCUTOD		:= TRB1->TOTGRD
					
				ENDIF
				IF  alltrim(TRB1->ITEMCTA) = _cItemConta .AND. alltrim(TRB1->GRUPO) = "799" 
					nTotalCUPR		:= TRB1->TOTGR	
					nTotCUPRD		:= TRB1->TOTGRD	
				ENDIF
				IF  alltrim(TRB1->ITEMCTA) = _cItemConta .AND. alltrim(TRB1->GRUPO) = "908"
					nComiss		:= TRB1->TOTGR 
					
				ENDIF
				IF  alltrim(TRB1->ITEMCTA) = _cItemConta .AND. alltrim(TRB1->GRUPO) = "907"
					nTCOGS		:= TRB1->TOTGR 
					nTCOGSD		:= TRB1->TOTGRD
				ENDIF
				TRB1->(dbskip())
			enddo
			
			DbSelectArea("CTD")
			CTD->(DbSetOrder(1)) 
			CTD->(DbSeek(xFilial('CTD')+_cItemConta))
			Reclock("CTD",.F.)
				CTD->CTD_XCUPRR		:= nTotalCUPR
				CTD->CTD_XCUTOR		:= nTotalCUTO
				CTD->CTD_XCOGSR		:= nTCOGS 
				CTD->CTD_XCUPRD		:= nTotCUPRD
				CTD->CTD_XCUTRD		:= nTotCUTOD
			MsUnlock()
			nTotalCUPR := 0

		ENDIF

		TZZN->(DbCloseArea())

return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ÌÝÝÝÝÝÝÝÝÝÝØÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÊÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¹±±
±±ºDesc.     ³ Abre os arquivos necessarios                               º±±
±±ÈÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝÝ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
static function AbreArq()
local aStru 	:= {}


if file(_cArq) .and. ferase(_cArq) == -1
	msgstop("Não foi possível abrir o arquivo GCIN01.XLS pois ele pode estar aberto por outro usuário.")
	return(.F.)
endif

/******** CAMPOS DETALHES CUSTOS PROPOSTA ***************/
aStru := {}
aAdd(aStru,{"GRUPO"		,"C",12,0}) // GRUPO
aAdd(aStru,{"ITEM"		,"C",80,0}) // DESCRICAO ITEM
aAdd(aStru,{"QUANT"		,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNIT"		,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTAL"		,"N",15,2}) // TOTAL
aAdd(aStru,{"QUANTLB"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNITLB"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTLB"		,"N",15,2}) // TOTAL
aAdd(aStru,{"QUANTEF"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VUNITEF"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"TOTEF"		,"N",15,2}) // TOTAL
aAdd(aStru,{"TOTGR"		,"N",15,2}) // TOTAL
aAdd(aStru,{"NPROP"		,"C",13,0}) // NUMERO PROPOSTA

aAdd(aStru,{"ITEMCTA"	,"C",13,0}) // ITEM CONTA
aAdd(aStru,{"GS"		,"C",01,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"PLAN"		,"C",02,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"PL"		,"C",02,0}) // GRUPO OU SUBGRUPO


aAdd(aStru,{"VUNITD"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"TOTALD"	,"N",15,2}) // TOTAL US$

aAdd(aStru,{"UNITLD"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"TOTLD"		,"N",15,2}) // TOTAL US$

aAdd(aStru,{"UNITED"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"TOTED"		,"N",15,2}) // TOTAL US$
aAdd(aStru,{"TOTGRD"	,"N",15,2}) // TOTAL GERAL US$

dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
index on GRUPO to &(cArqTrb1+"1")
set index to &(cArqTrb1+"1")

aStru := {}
aAdd(aStru,{"VGRUPO"	,"C",12,0}) // GRUPO
aAdd(aStru,{"VITEM"		,"C",80,0}) // DESCRICAO ITEM
aAdd(aStru,{"VQUANT"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNIT"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTAL"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VQUANTLB"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNITLB"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTLB"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VQUANTEF"	,"N",15,6}) // QUANTIDADE
aAdd(aStru,{"VVUNITEF"	,"N",15,2}) // VALOR UNITARIO
aAdd(aStru,{"VTOTEF"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VTOTGR"	,"N",15,2}) // TOTAL
aAdd(aStru,{"VNPROP"	,"C",13,0}) // NUMERO PROPOSTA
aAdd(aStru,{"VITEMCTA"	,"C",13,0}) // ITEM CONTA
aAdd(aStru,{"VGS"		,"C",01,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"VPL"		,"C",02,0}) // GRUPO OU SUBGRUPO

aAdd(aStru,{"VVUNITD"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"VTOTALD"	,"N",15,2}) // TOTAL US$

aAdd(aStru,{"VUNITLD"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"VTOTLD"		,"N",15,2}) // TOTAL US$

aAdd(aStru,{"VUNITED"	,"N",15,2}) // VALOR UNITARIO US$
aAdd(aStru,{"VTOTED"		,"N",15,2}) // TOTAL US$
aAdd(aStru,{"VTOTGRD"	,"N",15,2}) // TOTAL GERAL US$

dbcreate(cArqTrb2,aStru)
dbUseArea(.T.,,cArqTrb2,"TRB2",.F.,.F.)
index on VGRUPO to &(cArqTrb2+"1")
set index to &(cArqTrb2+"1")

return(.T.)

static function VldParam()

/*
if empty(_dDataIni) .or. empty(_dDataFim) .or. empty(_dDtRef) // Alguma data vazia
	msgstop("Todas as datas dos parâmetros devem ser informadas.")
	return(.F.)
endif

if _dDataIni > _dDtRef // Data de inicio maior que data de referencia
	msgstop("A data de início do processamento deve ser menor ou igual a data de referência.")
	return(.F.)
endif

if _dDataFim < _dDtRef // Data de fim menor que data de referencia
	msgstop("A data de final do processamento deve ser maior ou igual a data de referência.")
	return(.F.)
endif
*/
return(.T.)

/**************** Exportacao Excel TRB1 planejado ********************/

Static Function zExpCUPL()
     Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExoCUVD.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMSExcelEx():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
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
    oFWMsExcel:AddworkSheet("Custos Contrato - Planejado") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta)
        
        aAdd(aColunas, "Grupo" )							// 1 Grupo
        aAdd(aColunas, "Item")								// 2 Item
        aAdd(aColunas, "Quant.Pri.")						// 3 Quantidade
        aAdd(aColunas, "Vlr.Unit.Pri.")						// 4 Vlr.Unitario
        aAdd(aColunas, "Total Pri.")						// 5 Total
		aAdd(aColunas, "Quant.Lb.")							// 6 Quantidade
        aAdd(aColunas, "Vlr.Unit.Lb.")						// 7 Vlr.Unitario
        aAdd(aColunas, "Total LB.")							// 8 Total
		aAdd(aColunas, "Quant.EF.")							// 9 Quantidade
        aAdd(aColunas, "Vlr.Unit.EF.")						// 10 Vlr.Unitario
        aAdd(aColunas, "Total EF.")							// 11 Total
		aAdd(aColunas, "Total Geral")						// 12 Total
        aAdd(aColunas, "No.Proposta")						// 13 No.Proposta
        aAdd(aColunas, "Contrato")							// 14 Contrato
        aAdd(aColunas, "GS")								// 15 GS
        
      
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Grupo" + SPACE(10),1,2)					// 1 Grupo
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Item" + SPACE(20),1,2)					// 2 Item
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Quantidade Pri." + SPACE(5),1,2)			// 3 Quantidade
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Vlr.Unitario Pim." + SPACE(5),1,2)		// 4 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Total Pri." + SPACE(5),1,2)				// 5 Total

		oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Quantidade LB" + SPACE(5),1,2)			// 6 Quantidade
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Vlr.Unitario LB" + SPACE(5),1,2)			// 7 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Total LB" + SPACE(5),1,2)				// 8 Total

		oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Quantidade EF" + SPACE(5),1,2)			// 9 Quantidade
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Vlr.Unitario EF" + SPACE(5),1,2)			// 10 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Total EF" + SPACE(5),1,2)				// 11 Total

		oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Total Geral" + SPACE(5),1,2)				// 12 Total

        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "No.Proposta" + SPACE(5),1,2)				// 13 No.Proposta
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "Contrato" + SPACE(5),1,2)				// 14 Contrato
        oFWMsExcel:AddColumn("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, "GS" + SPACE(5),1,2)						// 15 GS
            
        
        For nAux := 1 To Len(aColunas)
            aAdd(aColsMa,  nX1 )
            nX1++
        Next
                                         
        While  !(TRB1->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB1->GRUPO
        	aLinhaAux[2] := TRB1->ITEM
        	aLinhaAux[3] := TRB1->QUANT
        	aLinhaAux[4] := TRB1->VUNIT
        	aLinhaAux[5] := TRB1->TOTAL

			aLinhaAux[6] := TRB1->QUANTLB
        	aLinhaAux[7] := TRB1->VUNITLB
        	aLinhaAux[8] := TRB1->TOTLB

			aLinhaAux[9] := TRB1->QUANTEF
        	aLinhaAux[10] := TRB1->VUNITEF
        	aLinhaAux[11] := TRB1->TOTEF

			aLinhaAux[12] := TRB1->TOTGR

        	aLinhaAux[13] := TRB1->NPROP
        	aLinhaAux[14] := TRB1->ITEMCTA
        	aLinhaAux[15] := TRB1->GS
        	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        	
        	if LEN(alltrim(aLinhaAux[1])) = 3 .AND. !alltrim(aLinhaAux[1]) $ "201/202/203/204/205/206/207/209/299/199/799/999/210/211/212/213/217/218/220/221/222" // Total por Grupo
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, aLinhaAux,aColsMa)

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "209/299/801/901/902/903/904/905/906" // Subtotais
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#FFFAF0")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, aLinhaAux,aColsMa)        

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "201/202/203/204/205/206/207/210/211/212/213/217/218/220/221/222" // Mao de obra
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, aLinhaAux,aColsMa)      	

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "199/799/999" // Totais
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#00008B")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, aLinhaAux,aColsMa)      
            	
            elseif LEN(alltrim(aLinhaAux[1])) > 3 // Subgrupos
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Contrato - Planejado","Custos Contrato - Planejado - "  + _cItemConta, aLinhaAux,aColsMa)
          
            //else	
        		//oFWMsExcel:AddRow("Gest�o de Contratos","Gest�o de Contratos - Sint�tico - "  + _cItemConta, aLinhaAux,aColsMa)
            endif
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



Return

/**************** Exportacao Excel TRB2 VENDIDO ********************/

Static Function zExpCUVD()
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local oExcel
    Local cArquivo  := GetTempPath()+'zExoCUVD.xml'
    Local aLinhaAux := {}
    Local aColunas  := {}
    Local nX1		:= 1 
    //Local oFWMsExcel := FWMSExcel():New()
    Local oFWMsExcel := FWMSExcelEx():New()
    //Local oFWMsEx := FWMsExcelEx():New()
    Local aColsMa	:= {}
    Local nCL		:= 1
   
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
    oFWMsExcel:AddworkSheet("Custos Vendido") //N�o utilizar n�mero junto com sinal de menos. Ex.: 1-
        //Criando a Tabela
        oFWMsExcel:AddTable("Custos Vendido","Custos Vendido - "  + _cNProp)
        
        aAdd(aColunas, "Grupo" )							// 1 Grupo
        aAdd(aColunas, "Item")								// 2 Item
        aAdd(aColunas, "Quant.Pri.")						// 3 Quantidade
        aAdd(aColunas, "Vlr.Unit.Pri.")						// 4 Vlr.Unitario
        aAdd(aColunas, "Total Pri.")						// 5 Total
		aAdd(aColunas, "Quant.Lb.")							// 6 Quantidade
        aAdd(aColunas, "Vlr.Unit.Lb.")						// 7 Vlr.Unitario
        aAdd(aColunas, "Total LB.")							// 8 Total
		aAdd(aColunas, "Quant.EF.")							// 9 Quantidade
        aAdd(aColunas, "Vlr.Unit.EF.")						// 10 Vlr.Unitario
        aAdd(aColunas, "Total EF.")							// 11 Total
		aAdd(aColunas, "Total Geral")						// 12 Total
        aAdd(aColunas, "No.Proposta")						// 13 No.Proposta
        aAdd(aColunas, "Contrato")							// 14 Contrato
        aAdd(aColunas, "GS")								// 15 GS
        
      
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Grupo" + SPACE(10),1,2)					// 1 Grupo
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Item" + SPACE(20),1,2)					// 2 Item
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Quantidade Pri." + SPACE(5),1,2)			// 3 Quantidade
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Vlr.Unitario Pim." + SPACE(5),1,2)		// 4 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Total Pri." + SPACE(5),1,2)				// 5 Total

		oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Quantidade LB" + SPACE(5),1,2)			// 6 Quantidade
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Vlr.Unitario LB" + SPACE(5),1,2)			// 7 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Total LB" + SPACE(5),1,2)				// 8 Total

		oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Quantidade EF" + SPACE(5),1,2)			// 9 Quantidade
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Vlr.Unitario EF" + SPACE(5),1,2)			// 10 Vlr.Unitario
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Total EF" + SPACE(5),1,2)				// 11 Total

		oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Total Geral" + SPACE(5),1,2)				// 12 Total

        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "No.Proposta" + SPACE(5),1,2)				// 13 No.Proposta
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "Contrato" + SPACE(5),1,2)				// 14 Contrato
        oFWMsExcel:AddColumn("Custos Vendido","Custos Vendido - "  + _cNProp, "GS" + SPACE(5),1,2)						// 15 GS
            
        
        For nAux := 1 To Len(aColunas)
            aAdd(aColsMa,  nX1 )
            nX1++
        Next
                                         
        While  !(TRB2->(EoF()))
        
        	aLinhaAux := Array(Len(aColunas))
        	aLinhaAux[1] := TRB2->VGRUPO
        	aLinhaAux[2] := TRB2->VITEM
        	aLinhaAux[3] := TRB2->VQUANT
        	aLinhaAux[4] := TRB2->VVUNIT
        	aLinhaAux[5] := TRB2->VTOTAL

			aLinhaAux[6] := TRB2->VQUANTLB
        	aLinhaAux[7] := TRB2->VVUNITLB
        	aLinhaAux[8] := TRB2->VTOTLB

			aLinhaAux[9] := TRB2->VQUANTEF
        	aLinhaAux[10] := TRB2->VVUNITEF
        	aLinhaAux[11] := TRB2->VTOTEF

			aLinhaAux[12] := TRB2->VTOTGR

        	aLinhaAux[13] := TRB2->VNPROP
        	aLinhaAux[14] := TRB2->VITEMCTA
        	aLinhaAux[15] := TRB2->VGS
        	
        	//if substr(alltrim(aLinhaAux[1]),1,5) == "TOTAL"
        	//	oFWMsExcel:SetCelBgColor("#4169E1")
        	//	oFWMsExcel:AddRow("Project Status","Project Status", aLinhaAux,{1})
        	//else
        	
        	if LEN(alltrim(aLinhaAux[1])) = 3 .AND. !alltrim(aLinhaAux[1]) $ "201/202/203/204/205/206/207/209/299/199/799/999/210/211/212/213/217/218/220/221/222" // Total por Grupo
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#E0FFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "209/299/801/901/902/903/904/905/906" // Subtotais
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#FFFAF0")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)        

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "201/202/203/204/205/206/207/210/211/212/213/217/218/220/221/222" // Mao de obra
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)      	

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "199/799/999" // Totais
            	oFWMsExcel:SetCelBold(.T.)
            	oFWMsExcel:SetCelBgColor("#00008B")
            	oFWMsExcel:SetCelFrColor("#FFFFFF")
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)      
            	
            elseif LEN(alltrim(aLinhaAux[1])) > 3 // Subgrupos
            	oFWMsExcel:SetCelBold(.F.)
            	oFWMsExcel:SetCelBgColor("#FFFFFF")
            	oFWMsExcel:SetCelFrColor("#000000")
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)
          
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
