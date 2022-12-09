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
user function zGestProp()

Local nTotalGRS := 0
private cPerg 	:= 	"GPIN01"
private _cArq	:= 	"GPIN01.XLS"


private _aCpos	:= {} // Campos de datas criados no TRB2
private _nCampos:= 0 // numero de campos de data - len(_aCpos)
private _nRecSaldo 	:= 0 // Recno da linha de saldo
//private _cItemConta
private _cCodCli
private _cNomCli
private _cNProp		:= SZ9->Z9_NPROP
private _cItemConta := ""
private _nPComiss 	:= 0
private _nXSISFV 	:= 0
private cArqTrb1 := CriaTrab(NIL,.F.)
private cArqTrb2 := CriaTrab(NIL,.F.)
Private _aGrpSint:= {}
Private _cCampo		:= ""

	_cNProp 	:= SZ9->Z9_NPROP

	pergunte(cPerg,.F.)

	// Faz consistencias iniciais para permitir a execucao da rotina
	if !VldParam() .or. !AbreArq()
		return
	endif

	//MSAguarde({||zGrpsSLC()},"Processando Grupos Proposta")

	MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")

	//MSAguarde({||zAtuCustZ9()},"Atualizando Custos Proposta")
	
	MontaTela()

	TRB1->(dbclosearea())
	//TRB2->(dbclosearea())

return

/* Montagem Grupo Proposta */

static function zGrpsSLC()

	local cGrupo	:= ""
	local cFor 		:= "ALLTRIM(QUERY2->ZZM_NPROP) == _cNProp"

	ChkFile("ZZL",.F.,"QUERY") // Alias dos movimentos bancarios
	IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZL_FILIAL+ZZL_ID",,,"Selecionando Registros...")
	ProcRegua(QUERY->(reccount()))
	QUERY->(dbgotop())

	ChkFile("ZZM",.F.,"QUERY2") // Alias dos movimentos bancarios
	IndRegua("QUERY2",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_GRUPO",,cFor,"Selecionando Registros...")
	ProcRegua(QUERY2->(reccount()))
	QUERY2->(dbgotop())
	
	while QUERY->(!eof())

		QUERY2->(dbgotop())
		while QUERY2->(!eof()) 
			IF ALLTRIM(QUERY->ZZL_ID) == ALLTRIM(QUERY2->ZZM_GRUPO)
				cGrupo := QUERY2->ZZM_GRUPO
			ENDIF
			QUERY2->(dbskip())
		ENDDO
		
		If EMPTY(cGrupo)
			RecLock("TRB1",.T.)
				TRB1->GRUPO		:= QUERY->ZZL_ID
				TRB1->NPROP		:= _cNProp
				TRB1->ITEM		:= UPPER(QUERY->ZZL_DESC)
				TRB1->GS 		:= "G"
			MsUnlock()
		ENDIF
		
		QUERY->(dbskip())
	enddo
	QUERY->(dbclosearea())
	QUERY2->(dbclosearea())
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
		local cFor 		:= "ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
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

		//SZ4->(dbsetorder(9)) 
		ChkFile("ZZM",.F.,"QUERY") // Alias dos movimentos bancarios
		IndRegua("QUERY",CriaTrab(NIL,.F.),"ZZM_FILIAL+ZZM_NPROP",,cFor,"Selecionando Registros...")
		ProcRegua(QUERY->(reccount()))

		QUERY->(dbgotop())
		while QUERY->(!eof())
				RecLock("TRB1",.T.)
				TRB1->GRUPO		:= QUERY->ZZM_GRUPO
				TRB1->ITEM		:= UPPER(QUERY->ZZM_ITEM)
				TRB1->QUANT		:= QUERY->ZZM_QUANT
				TRB1->VUNIT		:= QUERY->ZZM_VUNIT
				TRB1->TOTAL		:= QUERY->ZZM_TOTAL
				TRB1->QUANTLB	:= QUERY->ZZM_QTDLB
				TRB1->VUNITLB	:= QUERY->ZZM_UNITLB
				TRB1->TOTLB		:= QUERY->ZZM_TOTLB
				TRB1->QUANTEF	:= QUERY->ZZM_QTDEF
				TRB1->VUNITEF	:= QUERY->ZZM_UNITEF
				TRB1->TOTEF		:= QUERY->ZZM_TOTEF
				TRB1->TOTGR		:= QUERY->ZZM_TOTAL + QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF //QUERY->ZZM_TOTGR
				TRB1->NPROP		:= QUERY->ZZM_NPROP
				//TRB1->ITEMCTA	:= QUERY->ZZM_ITEMCT
				TRB1->GS 		:= QUERY->ZZM_GS

				// valor em dolar
				TRB1->VUNITD	:= QUERY->ZZM_VUNITD
				TRB1->TOTALD	:= QUERY->ZZM_TOTALD
				
				TRB1->UNITLD	:= QUERY->ZZM_UNITLD
				TRB1->TOTLD		:= QUERY->ZZM_TOTLD
				
				TRB1->UNITED	:= QUERY->ZZM_UNITED
				TRB1->TOTED		:= QUERY->ZZM_TOTED
				TRB1->TOTGRD	:= QUERY->ZZM_TOTALD + QUERY->ZZM_TOTLD + QUERY->ZZM_TOTED //QUERY->ZZM_TOTGR

				TRB1->PL1		:= QUERY->ZZM_PL1
				TRB1->PL2		:= QUERY->ZZM_PL2
				TRB1->PL3		:= QUERY->ZZM_PL3
				TRB1->PL4		:= QUERY->ZZM_PL4
				TRB1->PL5		:= QUERY->ZZM_PL5
				TRB1->PL6		:= QUERY->ZZM_PL6
				TRB1->PL7		:= QUERY->ZZM_PL7
				TRB1->PL8		:= QUERY->ZZM_PL8
				TRB1->PL8		:= QUERY->ZZM_PL9
				TRB1->PL8		:= QUERY->ZZM_PL0
				TRB1->PL8		:= QUERY->ZZM_PLA
				TRB1->PL8		:= QUERY->ZZM_PLB
				TRB1->PL8		:= QUERY->ZZM_PLC
				TRB1->PL8		:= QUERY->ZZM_PLD
				TRB1->PL8		:= QUERY->ZZM_PLE
				TRB1->PL8		:= QUERY->ZZM_PLF

				TRB1->ITEMCT	:= QUERY->ZZM_ITEMCT
				TRB1->ITEMC2	:= QUERY->ZZM_ITEMC2
				TRB1->ITEMC3	:= QUERY->ZZM_ITEMC3
				TRB1->ITEMC4	:= QUERY->ZZM_ITEMC4
				TRB1->ITEMC5	:= QUERY->ZZM_ITEMC5
				TRB1->ITEMC6	:= QUERY->ZZM_ITEMC6
				TRB1->ITEMC7	:= QUERY->ZZM_ITEMC7
				TRB1->ITEMC8	:= QUERY->ZZM_ITEMC8
				TRB1->ITEMC9	:= QUERY->ZZM_ITEMC9
				TRB1->ITEMC0	:= QUERY->ZZM_ITEMC0
				TRB1->ITEMCA	:= QUERY->ZZM_ITEMCA
				TRB1->ITEMCB	:= QUERY->ZZM_ITEMCB
				TRB1->ITEMCC	:= QUERY->ZZM_ITEMCC
				TRB1->ITEMCD	:= QUERY->ZZM_ITEMCD
				TRB1->ITEMCE	:= QUERY->ZZM_ITEMCE
				TRB1->ITEMCF	:= QUERY->ZZM_ITEMCF

				// PRIMARY
				TRB1->QTDP1		:= QUERY->ZZM_QTDP1
				TRB1->UNITP1	:= QUERY->ZZM_UNITP1
				TRB1->TOTP1		:= QUERY->ZZM_TOTP1

				TRB1->QTDP2		:= QUERY->ZZM_QTDP2
				TRB1->UNITP2	:= QUERY->ZZM_UNITP2
				TRB1->TOTP2		:= QUERY->ZZM_TOTP2

				TRB1->QTDP3		:= QUERY->ZZM_QTDP3
				TRB1->UNITP3	:= QUERY->ZZM_UNITP3
				TRB1->TOTP3		:= QUERY->ZZM_TOTP3

				TRB1->QTDP4		:= QUERY->ZZM_QTDP4
				TRB1->UNITP4	:= QUERY->ZZM_UNITP4
				TRB1->TOTP4		:= QUERY->ZZM_TOTP4

				TRB1->QTDP5		:= QUERY->ZZM_QTDP5
				TRB1->UNITP5	:= QUERY->ZZM_UNITP5
				TRB1->TOTP5		:= QUERY->ZZM_TOTP5
				
				TRB1->QTDP6		:= QUERY->ZZM_QTDP6
				TRB1->UNITP6	:= QUERY->ZZM_UNITP6
				TRB1->TOTP6		:= QUERY->ZZM_TOTP6

				TRB1->QTDP7		:= QUERY->ZZM_QTDP7
				TRB1->UNITP7	:= QUERY->ZZM_UNITP7
				TRB1->TOTP7		:= QUERY->ZZM_TOTP7

				TRB1->QTDP8		:= QUERY->ZZM_QTDP8
				TRB1->UNITP8	:= QUERY->ZZM_UNITP8
				TRB1->TOTP8		:= QUERY->ZZM_TOTP8

				TRB1->QTDP8		:= QUERY->ZZM_QTDP9
				TRB1->UNITP8	:= QUERY->ZZM_UNITP9
				TRB1->TOTP8		:= QUERY->ZZM_TOTP9

				TRB1->QTDP8		:= QUERY->ZZM_QTDP0
				TRB1->UNITP8	:= QUERY->ZZM_UNITP0
				TRB1->TOTP8		:= QUERY->ZZM_TOTP0

				TRB1->QTDP8		:= QUERY->ZZM_QTDPA
				TRB1->UNITP8	:= QUERY->ZZM_UNITPA
				TRB1->TOTP8		:= QUERY->ZZM_TOTPA

				TRB1->QTDP8		:= QUERY->ZZM_QTDPB
				TRB1->UNITP8	:= QUERY->ZZM_UNITPB
				TRB1->TOTP8		:= QUERY->ZZM_TOTPB

				TRB1->QTDP8		:= QUERY->ZZM_QTDPC
				TRB1->UNITP8	:= QUERY->ZZM_UNITPC
				TRB1->TOTP8		:= QUERY->ZZM_TOTPC

				TRB1->QTDP8		:= QUERY->ZZM_QTDPC
				TRB1->UNITP8	:= QUERY->ZZM_UNITPC
				TRB1->TOTP8		:= QUERY->ZZM_TOTPC

				TRB1->QTDP8		:= QUERY->ZZM_QTDPD
				TRB1->UNITP8	:= QUERY->ZZM_UNITPD
				TRB1->TOTP8		:= QUERY->ZZM_TOTPD

				TRB1->QTDP8		:= QUERY->ZZM_QTDPE
				TRB1->UNITP8	:= QUERY->ZZM_UNITPE
				TRB1->TOTP8		:= QUERY->ZZM_TOTPE

				TRB1->QTDP8		:= QUERY->ZZM_QTDPF
				TRB1->UNITP8	:= QUERY->ZZM_UNITPF
				TRB1->TOTP8		:= QUERY->ZZM_TOTPF

				// LARGE BYOUTS
				TRB1->QTDP1L		:= QUERY->ZZM_QTDP1L
				TRB1->UNIP1L		:= QUERY->ZZM_UNIP1L
				TRB1->TOTP1L		:= QUERY->ZZM_TOTP1L

				TRB1->QTDP2L		:= QUERY->ZZM_QTDP2L
				TRB1->UNIP2L		:= QUERY->ZZM_UNIP2L
				TRB1->TOTP2L		:= QUERY->ZZM_TOTP2L

				TRB1->QTDP3L		:= QUERY->ZZM_QTDP3L
				TRB1->UNIP3L		:= QUERY->ZZM_UNIP3L
				TRB1->TOTP3L		:= QUERY->ZZM_TOTP3L

				TRB1->QTDP4L		:= QUERY->ZZM_QTDP4
				TRB1->UNIP4L		:= QUERY->ZZM_UNIP4L
				TRB1->TOTP4L		:= QUERY->ZZM_TOTP4L

				TRB1->QTDP5L		:= QUERY->ZZM_QTDP5L
				TRB1->UNIP5L		:= QUERY->ZZM_UNIP5L
				TRB1->TOTP5L		:= QUERY->ZZM_TOTP5L
				
				TRB1->QTDP6L		:= QUERY->ZZM_QTDP6L
				TRB1->UNIP6L		:= QUERY->ZZM_UNIP6L
				TRB1->TOTP6L		:= QUERY->ZZM_TOTP6L

				TRB1->QTDP7L		:= QUERY->ZZM_QTDP7L
				TRB1->UNIP7L		:= QUERY->ZZM_UNIP7L
				TRB1->TOTP7L		:= QUERY->ZZM_TOTP7L

				TRB1->QTDP8L		:= QUERY->ZZM_QTDP8L
				TRB1->UNIP8L		:= QUERY->ZZM_UNIP8L
				TRB1->TOTP8L		:= QUERY->ZZM_TOTP8L

				TRB1->QTDP8L		:= QUERY->ZZM_QTDP9L
				TRB1->UNIP8L		:= QUERY->ZZM_UNIP9L
				TRB1->TOTP8L		:= QUERY->ZZM_TOTP9L

				TRB1->QTDP8L		:= QUERY->ZZM_QTDP0L
				TRB1->UNIP8L		:= QUERY->ZZM_UNIP0L
				TRB1->TOTP8L		:= QUERY->ZZM_TOTP0L

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPAL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPAL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPAL

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPBL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPBL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPBL

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPCL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPCL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPCL

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPDL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPDL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPDL

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPEL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPEL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPEL

				TRB1->QTDP8L		:= QUERY->ZZM_QTDPFL
				TRB1->UNIP8L		:= QUERY->ZZM_UNIPFL
				TRB1->TOTP8L		:= QUERY->ZZM_TOTPFL

				// EXOTIC FAB
				TRB1->QTDP1E		:= QUERY->ZZM_QTDP1E
				TRB1->UNIP1E		:= QUERY->ZZM_UNIP1E
				TRB1->TOTP1E		:= QUERY->ZZM_TOTP1E

				TRB1->QTDP2E		:= QUERY->ZZM_QTDP2E
				TRB1->UNIP2E		:= QUERY->ZZM_UNIP2E
				TRB1->TOTP2E		:= QUERY->ZZM_TOTP2E

				TRB1->QTDP3E		:= QUERY->ZZM_QTDP3E
				TRB1->UNIP3E		:= QUERY->ZZM_UNIP3E
				TRB1->TOTP3E		:= QUERY->ZZM_TOTP3E

				TRB1->QTDP4E		:= QUERY->ZZM_QTDP4E
				TRB1->UNIP4E		:= QUERY->ZZM_UNIP4E
				TRB1->TOTP4E		:= QUERY->ZZM_TOTP4E

				TRB1->QTDP5E		:= QUERY->ZZM_QTDP5E
				TRB1->UNIP5E		:= QUERY->ZZM_UNIP5E
				TRB1->TOTP5E		:= QUERY->ZZM_TOTP5E
				
				TRB1->QTDP6E		:= QUERY->ZZM_QTDP6E
				TRB1->UNIP6E		:= QUERY->ZZM_UNIP6E
				TRB1->TOTP6E		:= QUERY->ZZM_TOTP6E

				TRB1->QTDP7E		:= QUERY->ZZM_QTDP7E
				TRB1->UNIP7E		:= QUERY->ZZM_UNIP7E
				TRB1->TOTP7E		:= QUERY->ZZM_TOTP7E

				TRB1->QTDP8E		:= QUERY->ZZM_QTDP8E
				TRB1->UNIP8E		:= QUERY->ZZM_UNIP8E
				TRB1->TOTP8E		:= QUERY->ZZM_TOTP8E

				TRB1->QTDP8E		:= QUERY->ZZM_QTDP9E
				TRB1->UNIP8E		:= QUERY->ZZM_UNIP9E
				TRB1->TOTP8E		:= QUERY->ZZM_TOTP9E

				TRB1->QTDP8E		:= QUERY->ZZM_QTDP0E
				TRB1->UNIP8E		:= QUERY->ZZM_UNIP0E
				TRB1->TOTP8E		:= QUERY->ZZM_TOTP0E

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPAE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPAE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPAE

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPBE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPBE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPBE

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPCE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPCE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPCE

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPDE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPDE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPDE

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPEE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPEE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPEE

				TRB1->QTDP8E		:= QUERY->ZZM_QTDPFE
				TRB1->UNIP8E		:= QUERY->ZZM_UNIPFE
				TRB1->TOTP8E		:= QUERY->ZZM_TOTPFE

				
				_cItemConta     := QUERY->ZZM_ITEMCT
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
				IF substr(alltrim(ZZM->ZZM_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(ZZM->ZZM_NPROP) == alltrim(_cNProp) .and. LEN(alltrim(ZZM->ZZM_GRUPO)) > 3 ;
					.AND. !alltrim(ZZM->ZZM_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/908")  
					nTotGRS += ZZM->ZZM_TOTAL
					nTotGRSLB += ZZM->ZZM_TOTLB
					nTotGRSEF += ZZM->ZZM_TOTEF

					nTotGRSD += ZZM->ZZM_TOTALD
					nTotGRSLBD += ZZM->ZZM_TOTLD
					nTotGRSEFD += ZZM->ZZM_TOTED
				ENDIF
				ZZM->(dbskip())
			enddo
			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB1->(DbGoTop())
			while TRB1->(!eof())
				if alltrim(TRB1->GRUPO) == alltrim(cGrupo) .and. TRB1->GS == 'G' .AND. alltrim(TRB1->NPROP) == alltrim(_cNProp);
					.AND. !alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222/801/908")  
					TRB1->TOTAL := nTotGRS
					TRB1->TOTLB := nTotGRSLB
					TRB1->TOTEF := nTotGRSEF
					TRB1->TOTGR := nTotGRS + nTotGRSLB + nTotGRSEF

					TRB1->TOTALD := nTotGRSD
					TRB1->TOTLD := nTotGRSLBD
					TRB1->TOTED := nTotGRSEFD
					TRB1->TOTGRD := nTotGRSD + nTotGRSLBD + nTotGRSEFD

					TRB1->NPROP	:= _cNProp
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
			ZZM->(DbGoTop())
			while ZZM->(!eof())
				IF substr(alltrim(ZZM->ZZM_GRUPO),1,3) == alltrim(cGrupo) .AND. alltrim(ZZM->ZZM_NPROP) == alltrim(_cNProp) ;
					.AND. alltrim(ZZM->ZZM_GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
					nTotGR200 += ZZM->ZZM_TOTAL
					nTotGR200LB += ZZM->ZZM_TOTLB
					nTotGR200EF += ZZM->ZZM_TOTEF

					nTotGR200D += ZZM->ZZM_TOTALD
					nTotGR200LBD += ZZM->ZZM_TOTLD
					nTotGR200EFD += ZZM->ZZM_TOTED
				ENDIF
				ZZM->(dbskip())
			enddo
			// GRAVAR NA TRB1 O TOTAL DOS GRUPOS EXECETO GRUPO 200
			TRB1->(DbGoTop())
			while TRB1->(!eof())
				// GRAVAR NA TRB1 O TOTAL DOS GRUPO 200
				if alltrim(TRB1->GRUPO) == '200' .and. TRB1->GS == 'G' .AND. alltrim(TRB1->NPROP) == alltrim(_cNProp);
					.AND. !alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")  
					TRB1->TOTAL := nTotGR200
					TRB1->TOTLB := nTotGR200LB
					TRB1->TOTEF := nTotGR200EF
					TRB1->TOTGR := nTotGR200 + nTotGR200LB + nTotGR200EF
					
					TRB1->TOTALD := nTotGR200D
					TRB1->TOTLD := nTotGR200LBD
					TRB1->TOTED := nTotGR200EFD
					TRB1->TOTGRD := nTotGR200D + nTotGR200LBD + nTotGR200EFD
					TRB1->NPROP		:= _cNProp
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
			TRB1->GS 		:= "G"
			
			while QUERY->(!eof())
				IF alltrim(QUERY->ZZM_GRUPO) $ ("101/102/103/104/105/106/107/108/109") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) == 3 .AND. QUERY->ZZM_NPROP = alltrim(_cNProp)
					nTotPR		+= QUERY->ZZM_TOTAL	
					nTotLB		+= QUERY->ZZM_TOTLB
					nTotEF		+= QUERY->ZZM_TOTEF	
					nTotGR		+= QUERY->ZZM_TOTGR

					nTotPRD		+= QUERY->ZZM_TOTALD	
					nTotLBD		+= QUERY->ZZM_TOTLD
					nTotEFD		+= QUERY->ZZM_TOTED	
					nTotGRD		+= QUERY->ZZM_TOTGRD
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
			TRB1->GS 		:= "G"
			
			while QUERY->(!eof())
				IF ALLTRIM(QUERY->ZZM_GRUPO) $ ("201/202/204/205/206/207") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) = 3 .AND. QUERY->ZZM_NPROP = _cNProp
					nTotPR		+= QUERY->ZZM_TOTAL
					nTotLB		+= QUERY->ZZM_TOTLB
					nTotEF		+= QUERY->ZZM_TOTEF	
					nTotGR		+= QUERY->ZZM_TOTAL	+ QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF	

					nTotPRD		+= QUERY->ZZM_TOTALD
					nTotLBD		+= QUERY->ZZM_TOTLD
					nTotEFD		+= QUERY->ZZM_TOTED	
					nTotGRD		+= QUERY->ZZM_TOTALD + QUERY->ZZM_TOTLD + QUERY->ZZM_TOTED	
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
			TRB1->NPROP		:= _cNProp
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
			TRB1->GRUPO		:= "299"
			TRB1->ITEM		:= "OPERACOES"
			TRB1->GS 		:= "G"
			
			while QUERY->(!eof())
				IF   alltrim(QUERY->ZZM_GRUPO) $ ("210/211/212/213/217/218/220/221/222") .AND.  LEN(ALLTRIM(QUERY->ZZM_GRUPO)) = 3 ;
				.AND. QUERY->ZZM_NPROP = _cNProp
					nTotPR		+= QUERY->ZZM_TOTAL	
					nTotLB		+= QUERY->ZZM_TOTLB
					nTotEF		+= QUERY->ZZM_TOTEF	
					nTotGR		+= QUERY->ZZM_TOTAL	+ QUERY->ZZM_TOTLB + QUERY->ZZM_TOTEF

					nTotPRD		+= QUERY->ZZM_TOTALD	
					nTotLBD		+= QUERY->ZZM_TOTLD
					nTotEFD		+= QUERY->ZZM_TOTED	
					nTotGRD		+= QUERY->ZZM_TOTALD + QUERY->ZZM_TOTLD + QUERY->ZZM_TOTED
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

			TRB1->NPROP		:= _cNProp
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
			TRB1->GS 		:= "G"
			QUERY->(dbgotop())
			while QUERY->(!eof())
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
					nTotPR		+= QUERY->ZZM_TOTAL	
					nTotPRD		+= QUERY->ZZM_TOTALD	
				ENDIF
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
					nTotLB		+= QUERY->ZZM_TOTLB
					nTotLBD		+= QUERY->ZZM_TOTLD
				ENDIF
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/801/900/901/902/903/904/905/906/908/999") 
					nTotEF		+= QUERY->ZZM_TOTEF	
					nTotEFD		+= QUERY->ZZM_TOTED	
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
			TRB1->GRUPO		:= "999"
			TRB1->ITEM		:= "CUSTO TOTAL"
			TRB1->GS 		:= "G"
			
			while QUERY->(!eof())
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotPR		+= QUERY->ZZM_TOTAL	
					nTotPRD		+= QUERY->ZZM_TOTALD	
				ENDIF
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotLB		+= QUERY->ZZM_TOTLB
					nTotLBD		+= QUERY->ZZM_TOTLD
				ENDIF
				IF  QUERY->ZZM_NPROP = _cNProp .AND. SUBSTR(QUERY->ZZM_GS,1,1) = 'G' ;
					.AND. !alltrim(QUERY->ZZM_GRUPO) $ ("199/209/299/799/200/299/900/901/908/999") 
					nTotEF		+= QUERY->ZZM_TOTEF	
					nTotEFD		+= QUERY->ZZM_TOTED	
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
		MsUnlock()
		nTotPR	:= 0
		nTotLB 	:= 0
		nTotEF	:= 0
		nTotGR 	:= 0

		nTotPRD	:= 0
		nTotLBD := 0
		nTotEFD	:= 0
		nTotGRD := 0
		
		//zAtuCustZ9()

TRB1->(dbgotop())
QUERY->(dbclosearea())
//GetdRefresh()

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

static _oDlgSint

cCadastro :=  "Gestao de Custos - Proposta - " + _cNProp

DEFINE MSDIALOG _oDlgSint ;
TITLE "Gestao de Propostas - Custos.... - " + _cNProp ;
From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL //"Cadastro de Orcamentos"

 @ aPosObj[1,1]+2,aPosObj[1,2] FOLDER oFolder1 SIZE  aPosObj[1,4],aPosObj[1,3]-10 OF _oDlgSint ;
	  	ITEMS "Detalhamento", "Custos" COLORS 0, 16777215 PIXEL
	  	
zCabecGC()
zTelaCustos()

DbSelectArea("SZ9")
SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
SZ9->(DbGoTop())

SZ9->(DbSeek(xFilial('SZ9')+_cNProp))
//zTelaCustos()

//aadd(aButton , { "BMPTABLE" , { || zExpExcGC01()}, "Export. Custos Excel " } )
//aadd(aButton , { "BMPTABLE" , { || GeraExcel("TRB2","",aHeader), TRB2->(dbgotop()), _oGetDbSint:ForceRefresh(), _oDlgSint:Refresh()}, "Gera Planilha Excel" } )
//aadd(aButton , { "BMPTABLE" , { || PRNGCRes()}, "Imprimir " } )

ACTIVATE MSDIALOG _oDlgSint ON INIT EnchoiceBar(_oDlgSint,{|| zSalvar(),_oDlgSint:End()}, {||_oDlgSint:End()},, aButton)

return
/******************* Tela Faturamento Realizado ************************/

static function zTelaCustos()

	// Monta aHeader do TRB1
	
	aadd(aHeader, {" Grupo"						,"GRUPO",		"",07,0,"","","C","TRB1","R"})
	//aadd(aHeader, {"At.Vlrs."					,"ATUAL",		"",01,0,"","","L","TRB1","R"})
	aadd(aHeader, {"Item"						,"ITEM",		"",60,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Quant.Pri." 				,"QUANT",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.Pri. R$"			,"VUNIT",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Pri. R$"				,"TOTAL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Quant.LB."	 				,"QUANTLB",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.LB. R$"			,"VUNITLB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total LB R$"				,"TOTLB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Quant.EF." 					,"QUANTEF",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.EF. R$"			,"VUNITEF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total EF R$"				,"TOTEF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Geral R$"				,"TOTGR",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.Pri. US$"			,"VUNITD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Pri. US$"				,"TOTALD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.LB. US$"			,"UNITLD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total LB US$"				,"TOTLD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Vlr.Unit.EF. US$"			,"UNITED",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total EF US$"				,"TOTED",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"Total Geral US$"			,"TOTGRD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"No.Proposta"				,"NPROP",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"PL1"						,"PL1",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 1" 				,"ITEMCT",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P1 PRI" 				,"QTDP1",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P1 PRI" 				,"UNITP1",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P1 PRI"					,"TOTP1",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P1 LB"	 				,"QTDP1L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P1 LB"					,"UNIP1L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P1 LB"					,"TOTP1L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P1 EF" 					,"QTDP1E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P1 EF"					,"UNIP1E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P1 EF"					,"TOTP1E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL2"						,"PL2",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 2" 				,"ITEMC2",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P2 PRI" 				,"QTDP2",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P2 PRI" 				,"UNITP2",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P2 PRI"					,"TOTP2",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P2 LB"	 				,"QTDP2L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P2 LB"					,"UNIP2L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P2 LB"					,"TOTP2L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P2 EF" 					,"QTDP2E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P2 EF"					,"UNIP2E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P2 EF"					,"TOTP2E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL3"						,"PL3",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 3" 				,"ITEMC3",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P3 PRI" 				,"QTDP3",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P3 PRI" 				,"UNITP3",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P3 PRI"					,"TOTP3",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P3 LB"	 				,"QTDP3L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P3 LB"					,"UNIP3L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P3 LB"					,"TOTP3L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P3 EF" 					,"QTDP3E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P3 EF"					,"UNIP3E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P3 EF"					,"TOTP3E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL4"						,"PL4",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 4" 				,"ITEMC4",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P4 PRI" 				,"QTDP4",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P4 PRI" 				,"UNITP4",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P4 PRI"					,"TOTP4",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P4 LB"	 				,"QTDP4L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P4 LB"					,"UNIP4L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P4 LB"					,"TOTP4L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P4 EF" 					,"QTDP4E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P4 EF"					,"UNIP4E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P4 EF"					,"TOTP4E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL5"						,"PL5",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 5" 				,"ITEMC5",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P5 PRI" 				,"QTDP5",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P5 PRI" 				,"UNITP5",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P5 PRI"					,"TOTP5",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P5 LB"	 				,"QTDP5L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P5 LB"					,"UNIP5L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P5 LB"					,"TOTP5L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P5 EF" 					,"QTDP5E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P5 EF"					,"UNIP5E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P5 EF"					,"TOTP5E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL6"						,"PL6",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 6" 				,"ITEMC6",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P6 PRI" 				,"QTDP6",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P6 PRI" 				,"UNITP6",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P6 PRI"					,"TOTP6",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P6 LB"	 				,"QTDP6L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P6 LB"					,"UNIP6L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P6 LB"					,"TOTP6L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P6 EF" 					,"QTDP6E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P6 EF"					,"UNIP6E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P6 EF"					,"TOTP6E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL7"						,"PL7",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 7" 				,"ITEMC7",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P7 PRI" 				,"QTDP7",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P7 PRI" 				,"UNITP7",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P7 PRI"					,"TOTP7",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P7 LB"	 				,"QTDP7L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P7 LB"					,"UNIP7L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P7 LB"					,"TOTP7L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P7 EF" 					,"QTDP7E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P7 EF"					,"UNIP7E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P7 EF"					,"TOTP7E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"PL8"						,"PL8",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 8" 				,"ITEMC8",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P8 PRI" 				,"QTDP8",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P8 PRI" 				,"UNITP8",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P8 PRI"					,"TOTP8",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P8 LB"	 				,"QTDP8L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P8 LB"					,"UNIP8L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P8 LB"					,"TOTP8L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P8 EF" 					,"QTDP8E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P8 EF"					,"UNIP8E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P8 EF"					,"TOTP8E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PL9"						,"PL9",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 9" 				,"ITEMC9",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P9 PRI" 				,"QTDP9",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P9 PRI" 				,"UNITP9",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P9 PRI"					,"TOTP9",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P9 LB"	 				,"QTDP9L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P9 LB"					,"UNIP9L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P9 LB"					,"TOTP9L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P9 EF" 					,"QTDP9E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P9 EF"					,"UNIP9E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P9 EF"					,"TOTP9E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PL0"						,"PL0",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta 0" 				,"ITEMC0",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD P0 PRI" 				,"QTDP0",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P0 PRI" 				,"UNITP0",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P0 PRI"					,"TOTP0",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P0 LB"	 				,"QTDP0L",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P0 LB"					,"UNIP0L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P0 LB"					,"TOTP0L",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD P0 EF" 					,"QTDP0E",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT P0 EF"					,"UNIP0E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT P0 EF"					,"TOTP0E",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLA"						,"PLA",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta A" 				,"ITEMCA",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PA PRI" 				,"QTDPA",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PA PRI" 				,"UNITPA",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PA PRI"					,"TOTPA",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PA LB"	 				,"QTDPAL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PA LB"					,"UNIPAL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PA LB"					,"TOTPAL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PA EF" 					,"QTDPAE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PA EF"					,"UNIPAE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PA EF"					,"TOTPAE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLB"						,"PLB",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta B" 				,"ITEMCB",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PB PRI" 				,"QTDPB",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PB PRI" 				,"UNITPB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PB PRI"					,"TOTPB",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PB LB"	 				,"QTDPBL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PB LB"					,"UNIPBL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PB LB"					,"TOTPBL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PB EF" 					,"QTDPBE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PB EF"					,"UNIPBE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PB EF"					,"TOTPBE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLC"						,"PLC",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta C" 				,"ITEMCC",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PC PRI" 				,"QTDPC",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PC PRI" 				,"UNITPC",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PC PRI"					,"TOTPC",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PC LB"	 				,"QTDPCL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PC LB"					,"UNIPCL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PC LB"					,"TOTPCL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PC EF" 					,"QTDPCE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PC EF"					,"UNIPCE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PC EF"					,"TOTPCE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLD"						,"PLD",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta D" 				,"ITEMCD",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PD PRI" 				,"QTDPD",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PD PRI" 				,"UNITPD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PD PRI"					,"TOTPD",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PD LB"	 				,"QTDPDL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PD LB"					,"UNIPDL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PD LB"					,"TOTPDL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PD EF" 					,"QTDPDE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PD EF"					,"UNIPDE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PD EF"					,"TOTPDE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLE"						,"PLE",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta E" 				,"ITEMCE",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PE PRI" 				,"QTDPE",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PE PRI" 				,"UNITPE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PE PRI"					,"TOTPE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PE LB"	 				,"QTDPEL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PE LB"					,"UNIPEL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PE LB"					,"TOTPEL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PE EF" 					,"QTDPEE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PE EF"					,"UNIPEE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PE EF"					,"TOTPEE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"PLF"						,"PLF",			"",02,0,"","","C","TRB1","R"})
	aadd(aHeader, {"Item Conta F" 				,"ITEMCF",		"",13,0,"","","C","TRB1","R"})
	aadd(aHeader, {"QTD PF PRI" 				,"QTDPF",		"@E 999,999.999999",14,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PF PRI" 				,"UNITPF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PF PRI"					,"TOTPF",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PF LB"	 				,"QTDPFL",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PF LB"					,"UNIPFL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PF LB"					,"TOTPFL",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"QTD PF EF" 					,"QTDPFE",		"@E 9,999,999.999999",15,6,"","","N","TRB1","R"})
	aadd(aHeader, {"UNIT PF EF"					,"UNIPFE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})
	aadd(aHeader, {"TOT PF EF"					,"TOTPFE",		"@E 999,999,999.99",15,2,"","","N","TRB1","R"})

	aadd(aHeader, {"GS"							,"GS",			"",01,0,"","","C","TRB1","R"})
	
	@ aPosObj[1,1]-30 , aPosObj[1,2]+5  BUTTON 'Exportar Excel' 	Size 60, 10 action(zExpCUVD()) OF oFolder1:aDialogs[2] Pixel
    //@ aPosObj[1,1]-30 , aPosObj[1,2]+70 BUTTON 'Incluir'        	Size 60, 10 action(zIncRegZZM()) OF oFolder1:aDialogs[2] Pixel
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+140 BUTTON 'Salvar/Atualizar'  Size 60, 10 action(zAtuSalvar()) OF oFolder1:aDialogs[2] Pixel
	//@ aPosObj[1,1]-30 , aPosObj[1,2]+210 BUTTON 'Excluir'       	Size 60, 10 action(zExcZZM()) OF oFolder1:aDialogs[2] Pixel
		
	_oGetDbCUST := MsGetDb():New(aPosObj[1,1]-15,aPosObj[1,2],(aPosObj[1,3])-60,aPosObj[1,4]-10, 2, "AllwaysTrue()", "AllwaysTrue()",,,,1,,"AllwaysTrue()","TRB1",,,,oFolder1:aDialogs[2])
	
	@ 0007,0330 Say  "Filtrar: " 	 COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+350 BUTTON 'Grupos'       	Size 60, 10 action(zFilGrupo()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+415 BUTTON 'SubGrupos'     Size 60, 10 action(zFilSGrupo()) OF oFolder1:aDialogs[2] Pixel
	@ aPosObj[1,1]-30 , aPosObj[1,2]+480 BUTTON 'Todos'       	Size 60, 10 action(zFilTodos()) OF oFolder1:aDialogs[2] Pixel

	@ 0005, 0550 SAY oSay1 PROMPT "Selecione Grupo" SIZE 070, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ 0005, 0595 MSGET oPGrupo VAR cPGrupo When .T. Picture "@!" Pixel F3 "ZZL2" SIZE 030, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[2] PIXEL
	@ aPosObj[1,1]-30 , aPosObj[1,2]+630 BUTTON 'Consultar'     Size 60, 10 action(zGrupoFil()) OF oFolder1:aDialogs[2] Pixel

    //_oGetDbCUST:oBrowse:BlDblClick := {|| zEditZZM()}
	
	// COR DA FONTE
	_oGetDbCUST:obrowse:acolumns[1]:BCLRFORE := {|SETVAL| SFMudaCor(1)}
	// COR DA LINHA
	_oGetDbCUST:obrowse:acolumns[1]:BCLRBACK := {|SETVAL| SFMudaCor(2)} //Cor da Linha
	
return

// Filtrar somente grupos 
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
		if ALLTRIM(TRB1->GRUPO) ==  "900"; _cCor := CLR_YELLOW ; endif	
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
    
	DbSelectArea("ZZM")
	ZZM->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZM->(DbGoTop())
	     
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
DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Proposta" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
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
		
			DbSelectArea("ZZM")
			ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) ) 
			Reclock("ZZM",.F.)
			IF ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) ) 
				ZZM->(DbDelete())
			endif	
			MsUnlock()
	
			DbSelectArea("TRB1")
			TRB1->(dbgotop())
			zap
			//MSAguarde({||zGrpsSLC()},"Processando Grupos Proposta")
			MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")
			TRB1->(DBGoBottom())
			TRB1->(dbgotop())
			GetdRefresh()
	
	Endif
Return _nOpc

/********************Edi��o Faturamento Planejado **********************************/
Static Function zEditZZM()
    Local aArea       := GetArea()
    Local aAreaZZM    := ZZM->(GetArea())
    Local nOpcao1      := 0
	Local cGrupo	  := alltrim(TRB1->GRUPO)
    Local cNProp	  := alltrim(TRB1->NPROP)
    Local cItemIC	  := alltrim(TRB1->ITEMCTA)
    
    Private cCadastro 
 
   	cCadastro := "Alteracao Custos Vendido"
    
	DbSelectArea("ZZM")
	ZZM->(DbSetOrder(1)) //B1_FILIAL + B1_COD
	ZZM->(DbGoTop())
	     
	 //Se conseguir posicionar no produto
	 If ZZM->(DbSeek(cGrupo+cNProp))
	        nOpcao1 := zAltTRB1()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	Elseif Alltrim(TRB1->GRUPO) $ ("101/102/103/104/105/106/107/108/108/109/301/501/601/701/908/801/803/805/806/802")
			MSGALERT( "Registro nao pode ser alterado", "Westech" )
			return .F.
	Elseif LEN(Alltrim(TRB1->GRUPO)) > 3
			nOpcao1 := zAltTRB1()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf
	ELSEIF  !ZZM->(DbSeek(cGrupo+cNProp)) .AND. Alltrim(TRB1->GRUPO) $ ("201/202/204/205/206/207/210/211/212/213/217/218/220/221/222")   
			nOpcao1 := zAltTRB1()
	        If nOpcao1 == 1
	            MsgInfo("Rotina confirmada", "Atencao")
	        EndIf 
	EndIf
	
    RestArea(aAreaZZM)
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
DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Proposta" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
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
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "1" .OR. substring(cGrupo,1,1) = "2"
		@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 010 MSGET oQuant VAR nQuant PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 080 MSGET oVUnit VAR nVUnit PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	ELSE
		@ 077, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 010 MSGET oQuant VAR nQuant When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 085, 080 MSGET oVUnit VAR nVUnit When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	ENDIF
    
    @ 077, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 086, 180 SAY  oTotal VAR (nQuant * nVUnit) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// large buyouts
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "2" .OR. substring(cGrupo,1,1) = "2"
		@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oQuantLB VAR nQuantLB PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 080 MSGET oVUnitLB VAR nVUnitLB PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	else
		@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 010 MSGET oQuantLB VAR nQuantLB  When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 121, 080 MSGET oVUnitLB VAR nVUnitLB  When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	endif	
    @ 112, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 121, 180 SAY  oTotalLB VAR (nQuantLB * nVUnitLB) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// EXOTIC FAB
	IF LEN(cGrupo) > 3 .AND. substring(cGrupo,5,1) = "3" .OR. substring(cGrupo,1,1) = "2"
		@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 010 MSGET oQuantEF VAR nQuantEF PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 080 MSGET oVUnitEF VAR nVUnitEF PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	else
		@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 010 MSGET oQuantEF VAR nQuantEF  When .F. PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
		@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
		@ 156, 080 MSGET oVUnitEF VAR nVUnitEF  When .F. PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
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

  	If _nOpc = 1

		Reclock("TRB1",.F.)
	 
	  		TRB1->GRUPO	 	:= cGrupo
	  		TRB1->ITEM		:= cItem 
	  		TRB1->QUANT		:= nQuant
			TRB1->VUNIT		:= nVUnit
	  		TRB1->TOTAL		:= nQuant * nVUnit

			TRB1->QUANTLB	:= nQuantLB
			TRB1->VUNITLB	:= nVUnitLB
	  		TRB1->TOTLB		:= nQuantLB * nVUnitLB

			TRB1->QUANTEF	:= nQuantEF
			TRB1->VUNITEF	:= nVUnitEF
	  		TRB1->TOTEF		:= nQuantEF * nVUnitEF

			TRB1->TOTGR		:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)

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

DEFINE MSDIALOG _oDlg TITLE "Edicao Custo Proposta" FROM 000, 000  TO 400, 498 COLORS 0, 16777215 PIXEL
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
	@ 085, 010 MSGET oQuant VAR nQuant PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 077, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 085, 080 MSGET oVUnit VAR nVUnit PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
    @ 077, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 086, 180 SAY  oTotal VAR (nQuant * nVUnit) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// large buyouts
	@ 112, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 010 MSGET oQuantLB VAR nQuantLB PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 112, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 121, 080 MSGET oVUnitLB VAR nVUnitLB PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	
    @ 112, 170 SAY oSay8 PROMPT "Total" SIZE 030, 007  COLORS 0, 16777215 PIXEL
    @ 121, 180 SAY  oTotalLB VAR (nQuantLB * nVUnitLB) PICTURE "@E 9,999,999,999.99" SIZE 060, 010  COLORS CLR_RED,CLR_HGREEN PIXEL 

	// EXOTIC FAB
	@ 147, 010 SAY oSay6 PROMPT "Quantidade" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 010 MSGET oQuantEF VAR nQuantEF PICTURE PesqPict("ZZM","ZZM_QUANT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
			
	@ 147, 080 SAY oSay7 PROMPT "Vlr.Unitario" SIZE 030, 007  COLORS 0, 16777215 PIXEL
	@ 156, 080 MSGET oVUnitEF VAR nVUnitEF PICTURE PesqPict("ZZM","ZZM_VUNIT") SIZE 060, 010  COLORS 0, 16777215 PIXEL
	    
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
	/*
	if  nQuant = 0
		MSGALERT( "Informe Quantidade." , "Westech" )
		_nOpc := 2
		RETURN .F.
	ENDIF

	if nVUnit = 0
		MSGALERT( "Informe Quantidade." , "Westech" )
		_nOpc := 2
		RETURN .F.
	ENDIF
	*/
	DbSelectArea("ZZM")
	ZZM->(DbSetOrder(1)) 
	ZZM->(DbGoTop())

	If _nOpc = 1
		// PRIMARY
		if (nQuant * nVUnit) > 0
			cQuery := " SELECT * FROM ZZM010 WHERE ZZM_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZM_NPROP = '" + cNProp + "' AND LEN(ZZM_GRUPO) > 3 "
			TCQuery cQuery New Alias "TZZMG"
					
			Count To nTotReg
			TZZMG->(DbGoTop()) 
			nTotReg := nTotReg+1

			cSubGrupo	:= alltrim(cGrupo) + "-1" + cValToChar(nTotReg)
			//msginfo(cSubGrupo)

			cQuery2 := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZM010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZM010) "
			TCQuery cQuery2 New Alias "TZZM"

			ZZM->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZM->RECNO+1
				ZZM->ZZM_FILIAL	:= "01"
				ZZM->ZZM_GRUPO	:= cSubGrupo
				ZZM->ZZM_ITEM	:= cItem 
				ZZM->ZZM_QUANT	:= nQuant
				ZZM->ZZM_VUNIT	:= nVUnit
				ZZM->ZZM_TOTAL	:= nQuant * nVUnit
				ZZM->ZZM_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)
				ZZM->ZZM_NPROP	:= cNProp
				ZZM->ZZM_ITEMCT	:= cItemCTA
				ZZM->ZZM_GS		:= "S"
			ZZM->( DBCommit() )

			TZZMG->(DbCloseArea())
  			TZZM->(DbCloseArea())
		endif
		// LARGE BUYOUTS
		if (nQuantLB * nVUnitLB) > 0
			cQueryLB := " SELECT * FROM ZZM010 WHERE ZZM_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZM_NPROP = '" + cNProp + "' AND LEN(ZZM_GRUPO) > 3 "
			TCQuery cQueryLB New Alias "TZZMGLB"
					
			Count To nTotRegLB
			TZZMGLB->(DbGoTop()) 
			nTotRegLB := nTotRegLB+1

			cSubGrupoLB	:= alltrim(cGrupo) + "-2" + cValToChar(nTotRegLB)
			//msginfo(cSubGrupo)

			cQuery2LB := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZM010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZM010) "
			TCQuery cQuery2LB New Alias "TZZMLB"

			ZZM->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZMLB->RECNO+1
				ZZM->ZZM_FILIAL	:= "01"
				ZZM->ZZM_GRUPO	:= cSubGrupoLB
				ZZM->ZZM_ITEM	:= cItem 
				ZZM->ZZM_QTDLB	:= nQuantLB
				ZZM->ZZM_UNITLB	:= nVUnitLB
				ZZM->ZZM_TOTLB	:= nQuantLB * nVUnitLB
				ZZM->ZZM_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)
				ZZM->ZZM_NPROP	:= cNProp
				ZZM->ZZM_ITEMCT	:= cItemCTA
				ZZM->ZZM_GS		:= "S"
			ZZM->( DBCommit() )

			TZZMGLB->(DbCloseArea())
  			TZZMLB->(DbCloseArea())
		endif
		// EXOTIC FAB
		if (nQuantEF * nVUnitEF) > 0
			cQueryEF := " SELECT * FROM ZZM010 WHERE ZZM_GRUPO LIKE '" + "%" + substring(cGrupo,1,3) + "%" + "' AND ZZM_NPROP = '" + cNProp + "' AND LEN(ZZM_GRUPO) > 3 "
			TCQuery cQueryEF New Alias "TZZMGEF"
					
			Count To nTotRegEF
			TZZMGEF->(DbGoTop()) 
			nTotRegEF := nTotRegEF+1

			cSubGrupoEF	:= alltrim(cGrupo) + "-3" + cValToChar(nTotRegEF)
			//msginfo(cSubGrupo)

			cQuery2EF := " SELECT R_E_C_N_O_ AS 'RECNO' FROM ZZM010 WHERE R_E_C_N_O_ = (SELECT MAX(R_E_C_N_O_) FROM ZZM010) "
			TCQuery cQuery2EF New Alias "TZZMEF"

			ZZM->( DBAppend( .F. ) )
				R_E_C_N_O_		:= TZZMEF->RECNO+1
				ZZM->ZZM_FILIAL	:= "01"
				ZZM->ZZM_GRUPO	:= cSubGrupoEF
				ZZM->ZZM_ITEM	:= cItem 
				ZZM->ZZM_QTDEF	:= nQuantEF
				ZZM->ZZM_UNITEF	:= nVUnitEF
				ZZM->ZZM_TOTEF	:= nQuantEF * nVUnitEF
				ZZM->ZZM_TOTGR	:= (nQuant * nVUnit) + (nQuantLB * nVUnitLB) + (nQuantEF * nVUnitEF)
				ZZM->ZZM_NPROP	:= cNProp
				ZZM->ZZM_ITEMCT	:= cItemCTA
				ZZM->ZZM_GS		:= "S"
			ZZM->( DBCommit() )

			TZZMGEF->(DbCloseArea())
  			TZZMEF->(DbCloseArea())
		endif

	
		DbSelectArea("TRB1")
		TRB1->(dbgotop())
		zap
		MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")
		TRB1->(DBGoBottom())
		TRB1->(dbgotop())
		GetdRefresh()
	Endif

	///TZZMG->(DbCloseArea())
  	//TZZM->(DbCloseArea())
 
Return _nOpc

/********************* Cabeçalho formulário principal ******************/
static function zCabecGC()

		Local oButton1
		Local oButton2
		Local cClass
		Local cMerc
		Local cTipo
		Local cViaExec
		Local nValor := 0
		Local oPanel1, oPanel2
		Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12, oSay13, oSay14, oSay15, oSay16, oSay17, oSay18, oSay19, oSay20
		Local oSay21, oSay22, oSay23, oSay24, oSay25, oSay26, oSay27, oSay28, oSay29, oSay30, oSay31, oSay32, oSay33, oSay34, oSay35, oSay36, oSay37, oSay38, oSay39, oSay40
		Local oSay41, oSay42, oSay43, oSay44, oSay45, oSay46, oSay47, oSay48, oSay49, oSay50, oSay51, oSay52, oSay53, oSay54, oSay55, oSay56, oSay57, oSay58, oSay59, oSay60
		Local nTotReg := 0

		//Local _nOpcao := 1
		Local _nOpc 		:= 0

		private aRotina := {{"","",0,1},{"","",0,2},{"","",0,2},{"","",0,2},{"","",0,2}}
		Private aSize   := MsAdvSize(,.F.,400)
		Private aObjects:= { { 450, 450, .T., .T. }, { 025, 025, .T., .T. } }
		Private aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 5, 5 }
		Private aPosObj := MsObjSize( aInfo, aObjects, .T. )
		Private aHeader	:= {}
		Private lRefresh:= .T.
		Private aButton	:= {}

		Private _oGetDbAnalit
		Static _oDlg

		cGet1 		:= alltrim(SZ9->Z9_NPROP)
		cGet2 		:= SZ9->Z9_CLASS
		cGet3		:= SZ9->Z9_MERCADO
		cGet4		:= SZ9->Z9_INDUSTR
		cGet5		:= SZ9->Z9_TIPO
		cComboBx1	:= {"","1 - General","2 - Marketing Platform","3 - Booking"}
		cGet6		:= SZ9->Z9_BOOK
		cComboBx2	:= {"","1 - Viabilidade","2 - Execucao"}
		cGet7		:= SZ9->Z9_VIAEXEC
		cGet8		:= SZ9->Z9_IDCONTR
		cGet9		:= Posicione("SA1",1,xFilial("SA1") + SZ9->Z9_IDCONTR, "A1_NREDUZ")
		cGet10		:= SZ9->Z9_IDCLFIN
		cGet11		:= Posicione("SA1",1,xFilial("SA1") + SZ9->Z9_IDCONTR, "A1_NREDUZ")
		cGet12		:= SZ9->Z9_XCOEQ
		cGet13		:= SZ9->Z9_XEQUIP
		cGet14		:= SZ9->Z9_DIMENS
		cGet15		:= SZ9->Z9_DTREG
		cGet16		:= SZ9->Z9_DTEPROP
		cGet17		:= SZ9->Z9_DTEREAL
		cGet18		:= SZ9->Z9_DTPREV
		cGet19		:= SZ9->Z9_IDELAB
		cGet20		:= POSICIONE("SZL",1,XFILIAL("SZL")+SZ9->Z9_IDELAB,"ZL_NOME")                                            
		cGet21		:= SZ9->Z9_IDRESP
		cGet22		:= POSICIONE("SZL",1,XFILIAL("SZL")+SZ9->Z9_IDRESP,"ZL_NOME")                                            
		cGet23		:= SZ9->Z9_CODPAIS
		cGet24		:= POSICIONE("SYA",1,XFILIAL("SYA")+SZ9->Z9_CODPAIS,"YA_DESCR")                                          
		cGet25		:= SZ9->Z9_CODREP
		cGet26		:= POSICIONE("SA3",1,XFILIAL("SA3")+SZ9->Z9_CODREP,"A3_NOME")                                            
		cGet27		:= SZ9->Z9_LOCAL
		cGet28		:= SZ9->Z9_PROJETO
		cGet29		:= Alltrim(SZ9->Z9_STATUS)
		cComboBx3	:= {"","1 - Ativa","2 - Cancelada","3 - Declinada","4 - Nao Enviada","5 - Perdida","6 - SLC","7 - Vendida"}
		cGet30		:= SZ9->Z9_PCONT
		cGet31		:= SZ9->Z9_CUSFIN
		cGet32		:= SZ9->Z9_FIANCAS
		cGet33		:= SZ9->Z9_PROVGAR
		cGet34		:= SZ9->Z9_PERDIMP
		cGet35		:= SZ9->Z9_PROYALT
		cGet36		:= SZ9->Z9_PCOMIS
		cGet37		:= SZ9->Z9_CUSTPR
		cGet38		:= SZ9->Z9_CUSTOT
		cGet39		:= SZ9->Z9_TOTSI
		cGet40		:= SZ9->Z9_TOTCI
		cGet41		:= SZ9->Z9_CUSPRD
		cGet42		:= SZ9->Z9_CUSTOD
		cGet43		:= SZ9->Z9_TOTSID
		cGet44		:= SZ9->Z9_TOTCID
		cGet45		:= SZ9->Z9_DCAMBIO
		cGet46		:= SZ9->Z9_CAMBIO

		if cGet2 = "1"
			cClass := cGet2 + " - " + "Equipamento"
		elseif cGet2 = "2"
			cClass := cGet2 + " - " + "Assistencia Tecnica"
		elseif cGet2 = "3"
			cClass := cGet2 + " - " + "Peca"
		elseif cGet2 = "4"
			cClass := cGet2 + " - " + "Sistema"
		elseif cGet2 = "5"
			cClass := cGet2 + " - " + "Engenharia"
		endif

		if cGet3 = "1"
			cMerc := cGet3 + " - " + "Mineracao"
		elseif cGet3 = "2"
			cMerc := cGet3 + " - " + "Papel e Celulose"
		elseif cGet3 = "3"
			cMerc := cGet3 + " - " + "Quimica"
		elseif cGet3 = "4"
			cMerc := cGet3 + " - " + "Fertilizantes"
		elseif cGet3 = "5"
			cMerc := cGet3 + " - " + "Siderurgia"
		elseif cGet3 = "6"
			cMerc := cGet3 + " - " + "Municipal"
		elseif cGet3 = "7"
			cMerc := cGet3 + " - " + "Petroquimica"
		elseif cGet3 = "8"
			cMerc := cGet3 + " - " + "Alimentos"
		elseif cGet3 = "9"
			cMerc := cGet3 + " - " + "Outros"
		endif

		if cGet5 = "1"
			cTipo := cGet5 + " - " + "Firme"
		elseif cGet5 = "2"
			cTipo := cGet5 + " - " + "Estimativa"
		elseif cGet5 = "3"
			cTipo := cGet5 + " - " + "Prospeccao"
		endif

		if cGet6 = "1"
			oComboBx1 := cGet6 + " - " + "General"
		elseif cGet6 = "2"
			oComboBx1 := cGet6 + " - " + "Marketing Platform"
		elseif cGet6 = "3"
			oComboBx1 := cGet6 + " - " + "Booking"
		else
			oComboBx1 := ""
		endif

		if cGet7 = "1"
			oComboBx2 := cGet7 + " - " + "Viabilidade"
		elseif cGet7 = "2"
			oComboBx2 := cGet7 + " - " + "Execucao"
		else
			oComboBx2 := ""
		endif

		if cGet29 = "1"
			oComboBx3 := cGet29 + " - " + "Ativa"
		elseif cGet29 = "2"
			oComboBx3 := cGet29 + " - " + "Cancelada"
		elseif cGet29 = "3"
			oComboBx3 := cGet29 + " - " + "Declinada"
		elseif cGet29 = "4"
			oComboBx3 := cGet29 + " - " + "Nao Enviada"
		elseif cGet29 = "5"
			oComboBx3 := cGet29 + " - " + "Perdida"
		elseif cGet29 = "6"
			oComboBx3 := cGet29 + " - " + "SLC"
		elseif cGet29 = "7"
			oComboBx3 := cGet29 + " - " + "Vendida"
		else
			oComboBx3 := ""
		endif

		oGroup1:= TGroup():New(0005,0005,0035,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup2:= TGroup():New(0040,0005,0070,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup3:= TGroup():New(0075,0005,0105,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup4:= TGroup():New(0110,0005,0140,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup5:= TGroup():New(0145,0005,0175,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup6:= TGroup():New(0180,0005,0210,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup7:= TGroup():New(0215,0005,0245,0635,'',oFolder1:aDialogs[1],,,.T.)
		oGroup8:= TGroup():New(0250,0005,0280,0635,'',oFolder1:aDialogs[1],,,.T.)
		//oGroup9:= TGroup():New(0285,0005,0315,0605,'',oFolder1:aDialogs[1],,,.T.)
				
			// ITEM CONTA
			@ 007, 010 SAY oSay1 PROMPT "Numro Proposta" 	SIZE 020, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			@ 016, 010 MSGET oGet1 VAR cGet1 When .F. 	SIZE 042, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
			@ 007, 063 SAY oSay2 PROMPT "Classificacao" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			@ 016, 061 MSGET oGet2 VAR cClass   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
			@ 007, 145 SAY oSay3 PROMPT "Mercado" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			@ 016, 142 MSGET oGet3 VAR cMerc   When .F. SIZE 072, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
			@ 007, 225 SAY oSay4 PROMPT "Prod.Final"  SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			@ 016, 222 MSGET oGet4 VAR cGet4  Picture "@!" Pixel F3 "ZZJ" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
			@ 007, 295 SAY oSay5 PROMPT "Tipo" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			@ 016, 292 MSGET oGet5 VAR cTipo   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
			if cGet29 = "7"
				@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				//@ 007, 435 SAY oSay7 PROMPT "Viabilidade/Execucao" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
				//@ 016, 432 ComboBox oComboBx2 Items cComboBx2   When .F. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
				
				@ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .F. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				/*********************************/
				@ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 010 MSGET oGet8 VAR cGet8 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				@ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				@ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 285 MSGET oGet10 VAR cGet10 When .F.  SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 230, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				/********************************/    
				@ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 071 MSGET oGet16 VAR cGet16 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 131 MSGET oGet17 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 193 SAY oSay18 PROMPT "Previsao Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 191 MSGET oGet18 VAR cGet18 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				/*********************************/
				@ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 010 MSGET oGet19 VAR cGet19  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1]  PIXEL
				@ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 270 MSGET oGet21 VAR cGet21  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				/*******************************/
				@ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 010 MSGET oGet23 VAR cGet23  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 247 MSGET oGet25 VAR cGet25  When .F. SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				/********************************/
				@ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 193, 010 MSGET oGet27 VAR cGet27 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 193, 230 MSGET oGet28 VAR cGet28 When .F. SIZE 260, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 150 SAY oSay32 PROMPT "% Fianças" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 220, 500 SAY oSay45 PROMPT "Data Cambio" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 500 MSGET oGet45 VAR cGet45 PICTURE PesqPict("SZ9","Z9_DCAMBIO") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 220, 570 SAY oSay46 PROMPT "Cambio" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 570 MSGET oGet46 VAR cGet46 PICTURE PesqPict("SZ9","Z9_CAMBIO") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				//***************************** R$
				@ 255, 010 SAY oSay37 PROMPT "Custo Producao R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 010 MSGET oGet37 VAR cGet37 PICTURE PesqPict("SZ9","Z9_CUSTPR") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 080 SAY oSay38 PROMPT "Custo Total R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 080 MSGET oGet38 VAR cGet38 PICTURE PesqPict("SZ9","Z9_CUSTOT") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 150 SAY oSay39 PROMPT "Venda s/ Tributos R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 150 MSGET oGet39 VAR cGet39 PICTURE PesqPict("SZ9","Z9_TOTSI") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 220 SAY oSay40 PROMPT "Venda c/ Tributos R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 220 MSGET oGet40 VAR cGet40 PICTURE PesqPict("SZ9","Z9_TOTCI") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				//***************************** US$
				@ 255, 290 SAY oSay41 PROMPT "Custo Producao US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 290 MSGET oGet41 VAR cGet41 PICTURE PesqPict("SZ9","Z9_CUSPRD") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 360 SAY oSay42 PROMPT "Custo Total US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 360 MSGET oGet42 VAR cGet42 PICTURE PesqPict("SZ9","Z9_CUSTOD") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 430 SAY oSay43 PROMPT "Venda s/ Tributos US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 430 MSGET oGet43 VAR cGet43 PICTURE PesqPict("SZ9","Z9_TOTSID") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 500 SAY oSay44 PROMPT "Venda c/ Tributos US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 500 MSGET oGet44 VAR cGet44 PICTURE PesqPict("SZ9","Z9_TOTCID") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

					
			else
				@ 007, 365 SAY oSay6 PROMPT "Booking" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 016, 362 ComboBox oComboBx1 Items cComboBx1   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				//@ 007, 435 SAY oSay7 PROMPT "Viabilidade/Execucao" 	SIZE 062, 007  COLORS 0, 16777215 PIXEL
				//@ 016, 432 ComboBox oComboBx2 Items cComboBx2   When .T. SIZE 062, 010 	COLORS 0, 16777215 PIXEL
			
				@ 007, 435 SAY oSay29 PROMPT "Status" 	SIZE 062, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 016, 432 ComboBox oComboBx3 Items cComboBx3   When .T. SIZE 062, 010 	COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				/********************************/
				@ 042, 010 SAY oSay8 PROMPT "Id Contr." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 010 MSGET oGet8 VAR cGet8 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				@ 042, 068 SAY oSay9 PROMPT "Contratante" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 066 MSGET oGet9 VAR cGet9 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
			
				@ 042, 288 SAY oSay10 PROMPT "Id Cli.Final." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 285 MSGET oGet10 VAR cGet10 Picture "@!" Pixel F3 "SA1_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 042, 343 SAY oSay11 PROMPT "Cliente Final" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 051, 340 MSGET oGet11 VAR cGet11 When .F. SIZE 210, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				/******************************/
				
				@ 076, 010 SAY oSay15 PROMPT "Data Registro" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 010 MSGET oGet15 VAR cGet15 When .F. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 073 SAY oSay16 PROMPT "Entrega Proposta" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 071 MSGET oGet16 VAR cGet16 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 133 SAY oSay17 PROMPT "Entrega Real Prop." SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 131 MSGET oGet17 VAR cGet15 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 076, 193 SAY oSay18 PROMPT "PrevisAo Venda" SIZE 052, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 085, 191 MSGET oGet18 VAR cGet18 When .T. SIZE 048, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				/***************************/
				@ 112, 010 SAY oSay19 PROMPT "Id Resp.Elab." SIZE 032, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 010 MSGET oGet19 VAR cGet19 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 073 SAY oSay20 PROMPT "Resp.Elab." SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 070 MSGET oGet20 VAR cGet20 When .F. SIZE 190, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 273 SAY oSay21 PROMPT "Id Responsavel" SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 270 MSGET oGet21 VAR cGet21 Picture "@!" Pixel F3 "zColab" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 112, 333 SAY oSay22 PROMPT "Responsavel" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 121, 330 MSGET oGet22 VAR cGet22 When .F. SIZE 220, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				/**************************/
				@ 148, 010 SAY oSay23 PROMPT "Cod.Pais" SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 010 MSGET oGet23 VAR cGet23 Picture "@!" Pixel F3 "SYA_2" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 073 SAY oSay24 PROMPT "Pais" SIZE 032, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 073 MSGET oGet24 VAR cGet24 When .F. SIZE 160, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 248 SAY oSay25 PROMPT "Cod.Repr." SIZE 052, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 247 MSGET oGet25 VAR cGet25 Picture "@!" Pixel F3 "SA3" SIZE 048, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 148, 308 SAY oSay26 PROMPT "Representante" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 157, 307 MSGET oGet26 VAR cGet26 When .F. SIZE 240, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL  
				/***************************/
				@ 184, 010 SAY oSay27 PROMPT "Local" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 193, 010 MSGET oGet27 VAR cGet27 When .T. SIZE 210, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL 

				@ 184, 230 SAY oSay28 PROMPT "Projeto" SIZE 042, 007 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 193, 230 MSGET oGet28 VAR cGet28 When .T. SIZE 260, 010  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				

				@ 220, 010 SAY oSay30 PROMPT "% Contingencias" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 010 MSGET oGet30 VAR cGet30 PICTURE PesqPict("SZ9","Z9_PCONT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 080 SAY oSay31 PROMPT "% Custo Financeiro" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 080 MSGET oGet31 VAR cGet31 PICTURE PesqPict("SZ9","Z9_CUSFIN") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 150 SAY oSay32 PROMPT "% Fianças" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 150 MSGET oGet32 VAR cGet32 PICTURE PesqPict("SZ9","Z9_FIANCAS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 220 SAY oSay33 PROMPT "% Provisao Garantia" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 220 MSGET oGet33 VAR cGet33 PICTURE PesqPict("SZ9","Z9_PROVGAR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 290 SAY oSay34 PROMPT "% Perda Impostos" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 290 MSGET oGet34 VAR cGet34 PICTURE PesqPict("SZ9","Z9_PERDIMP") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
					
				@ 220, 360 SAY oSay35 PROMPT "% Royalt" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 360 MSGET oGet35 VAR cGet35 PICTURE PesqPict("SZ9","Z9_PROYALT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				@ 220, 430 SAY oSay36 PROMPT "% Comissao" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 430 MSGET oGet36 VAR cGet36 PICTURE PesqPict("SZ9","Z9_PCOMIS") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 220, 500 SAY oSay45 PROMPT "Data Cambio" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 500 MSGET oGet45 VAR cGet45 PICTURE PesqPict("SZ9","Z9_DCAMBIO") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 220, 570 SAY oSay46 PROMPT "Cambio" SIZE 050, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 229, 570 MSGET oGet46 VAR cGet46 PICTURE PesqPict("SZ9","Z9_CAMBIO") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				
				//***************************** R$

				@ 255, 010 SAY oSay37 PROMPT "Custo Producao R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 010 MSGET oGet37 VAR cGet37 PICTURE PesqPict("SZ9","Z9_CUSTPR") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 080 SAY oSay38 PROMPT "Custo Total R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 080 MSGET oGet38 VAR cGet38 PICTURE PesqPict("SZ9","Z9_CUSTOT") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 150 SAY oSay39 PROMPT "Venda s/ Tributos R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 150 MSGET oGet39 VAR cGet39 PICTURE PesqPict("SZ9","Z9_TOTSI") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 220 SAY oSay40 PROMPT "Venda c/ Tributos R$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 220 MSGET oGet40 VAR cGet40 PICTURE PesqPict("SZ9","Z9_TOTCI") When .T. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				//***************************** US$
				@ 255, 290 SAY oSay41 PROMPT "Custo Producao US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 290 MSGET oGet41 VAR cGet41 PICTURE PesqPict("SZ9","Z9_CUSPRD") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 360 SAY oSay42 PROMPT "Custo Total US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 360 MSGET oGet42 VAR cGet42 PICTURE PesqPict("SZ9","Z9_CUSTOD") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 430 SAY oSay43 PROMPT "Venda s/ Tributos US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 430 MSGET oGet43 VAR cGet43 PICTURE PesqPict("SZ9","Z9_TOTSID") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL

				@ 255, 500 SAY oSay44 PROMPT "Venda c/ Tributos US$" SIZE 065, 007  COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL
				@ 264, 500 MSGET oGet44 VAR cGet44 PICTURE PesqPict("SZ9","Z9_TOTCID") When .F. SIZE 060, 010 COLORS 0, 16777215 OF oFolder1:aDialogs[1] PIXEL


			endif		
	
RETURN

// Salvar e Atualizar 
static function zAtuSalvar()
	zAtualizar()
	zAtualizar()
return

static function zAtualizar()

		Local cGrupo 		:= ""
		Local cNProp 		:= ""
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
		Local _cFilZZM 		:= xFilial("ZZM")
		local cFor 			:= "ALLTRIM(QUERY->ZZM_NPROP) == _cNProp"
	
		local nTotPR 		:= 0
		local nTotLB 		:= 0
		local nTotEF 		:= 0
		local nTotGR 		:= 0

			TRB1->(DbGoTop())

		DbSelectArea("ZZM")
		ZZM->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZM->(DbGoTop())

		// Totalizando Grupos
		DbSelectArea("ZZL")
		ZZL->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZL->(DbGoTop())

		DbSelectArea("SZ9")
			SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
			SZ9->(DbGoTop())

			SZ9->(DbSeek(xFilial('SZ9')+_cNProp))

			Reclock("SZ9",.F.)
				SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
				//SZ9->Z9_VIAEXEC		:= SUBSTR(oComboBx2,1,1)
				SZ9->Z9_INDUSTR		:= cGet4 
				SZ9->Z9_IDCONTR		:= cGet8
				SZ9->Z9_CONTR		:= cGet9
				SZ9->Z9_IDCLFIN		:= cGet10
				SZ9->Z9_CLIFIN		:= cGet11
				//SZ9->Z9_XCOEQ		:= cGet12
				//SZ9->Z9_XEQUIP	:= cGet13
				//SZ9->Z9_DIMENS	:= cGet14
				SZ9->Z9_DTREG		:= cGet15
				SZ9->Z9_DTEPROP		:= cGet16
				SZ9->Z9_DTEREAL		:= cGet17
				SZ9->Z9_DTPREV		:= cGet18
				SZ9->Z9_IDELAB		:= cGet19
				SZ9->Z9_RESPELA		:= cGet20
				SZ9->Z9_IDRESP		:= cGet21
				SZ9->Z9_RESP		:= cGet22
				SZ9->Z9_CODPAIS		:= cGet23
				SZ9->Z9_PAIS		:= cGet24
				SZ9->Z9_CODREP		:= cGet25
				SZ9->Z9_REPRE		:= cGet26
				SZ9->Z9_LOCAL		:= cGet27
				SZ9->Z9_PROJETO		:= cGet28
				SZ9->Z9_STATUS		:= SUBSTR(oComboBx3,1,1)
				SZ9->Z9_PCONT		:= cGet30
				SZ9->Z9_CUSFIN		:= cGet31
				SZ9->Z9_FIANCAS		:= cGet32
				SZ9->Z9_PROVGAR		:= cGet33
				SZ9->Z9_PERDIMP		:= cGet34
				SZ9->Z9_PROYALT		:= cGet35
				SZ9->Z9_PCOMIS		:= cGet36
				SZ9->Z9_CUSTPR		:= cGet37
				SZ9->Z9_CUSTOT		:= cGet38
				SZ9->Z9_TOTSI		:= cGet39
				SZ9->Z9_TOTCI		:= cGet40
			MsUnlock()

		TRB1->(DbGoTop())
		while TRB1->(!eof())
			cGrupo := TRB1->GRUPO
			cNProp := alltrim(TRB1->NPROP) 
			//msginfo("Inicio" + cGrupo + cNProp)
			
			IF ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/999")
					Reclock("ZZM",.F.)
						//msginfo("Edit" + cGrupo + cNProp)	
						ZZM->ZZM_FILIAL	:= "01"
						ZZM->ZZM_GRUPO	:= TRB1->GRUPO
						ZZM->ZZM_ITEM	:= TRB1->ITEM	
						//PRIMARY R$	
						ZZM->ZZM_QUANT	:= TRB1->QUANT	
						ZZM->ZZM_VUNIT	:= TRB1->VUNIT
						ZZM->ZZM_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS R$
						ZZM->ZZM_QTDLB	:= TRB1->QUANTLB	
						ZZM->ZZM_UNITLB	:= TRB1->VUNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB R$
						ZZM->ZZM_QTDEF	:= TRB1->QUANTEF	
						ZZM->ZZM_UNITEF	:= TRB1->VUNITEF
						ZZM->ZZM_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL R$
						ZZM->ZZM_TOTGR	:= TRB1->TOTGR 

						//PRIMARY US$	
						ZZM->ZZM_VUNITD	:= TRB1->VUNITD
						ZZM->ZZM_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZM->ZZM_UNITLD	:= TRB1->UNITLD
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB US$
						ZZM->ZZM_UNITED	:= TRB1->UNITED
						ZZM->ZZM_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZM->ZZM_TOTGRD	:= TRB1->TOTGRD

						ZZM->ZZM_NPROP 	:= TRB1->NPROP		
						ZZM->ZZM_ITEMCT	:= TRB1->ITEMCTA
						ZZM->ZZM_GS		:= TRB1->GS
					MsUnlock()
		
			elseIF !ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/999")
					ZZM->( DBAppend( .F. ) )
						//msginfo("append" + cGrupo + cNProp)
						ZZM->ZZM_FILIAL	:= "01"
						ZZM->ZZM_GRUPO	:= TRB1->GRUPO
						ZZM->ZZM_ITEM	:= TRB1->ITEM	
						//PRIMARY	
						ZZM->ZZM_QUANT	:= TRB1->QUANT	
						ZZM->ZZM_VUNIT	:= TRB1->VUNIT
						ZZM->ZZM_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZM->ZZM_QTDLB	:= TRB1->QUANTLB	
						ZZM->ZZM_UNITLB	:= TRB1->VUNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZM->ZZM_QTDEF	:= TRB1->QUANTEF	
						ZZM->ZZM_UNITEF	:= TRB1->VUNITEF
						ZZM->ZZM_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZM->ZZM_TOTGR	:= TRB1->TOTGR 

						//PRIMARY US$	
						ZZM->ZZM_VUNITD	:= TRB1->VUNITD
						ZZM->ZZM_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZM->ZZM_UNITLD	:= TRB1->UNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB US$
						ZZM->ZZM_UNITED	:= TRB1->UNITED
						ZZM->ZZM_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZM->ZZM_TOTGRD	:= TRB1->TOTGRD

						ZZM->ZZM_NPROP 	:= TRB1->NPROP		
						ZZM->ZZM_ITEMCT	:= TRB1->ITEMCTA
						ZZM->ZZM_GS		:= TRB1->GS
					ZZM->( DBCommit() )
			ENDIF
			
			TRB1->(dbskip())
		enddo

		
	  	DbSelectArea("TRB1")
		TRB1->(dbgotop())
		zap
		MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")
		TRB1->(DBGoBottom())
		TRB1->(dbgotop())
		GetdRefresh()

		zAtuCustZ9()
		
TRB1->(dbgotop())

return

static function zSalvar()
			Local cGrupo 		:= ""
			Local cNProp 		:= ""
			Local nTotalGRS 	:= 0
			Local nTotalGR200 	:= 0
			Local nTotGRSLB 	:= 0
			local nTotGR200LB	:= 0
			Local nTotGRSEF 	:= 0
			local nTotGR200EF	:= 0
			Local nTotGRSGR 	:= 0
			local nTotGR200GR	:= 0

			DbSelectArea("SZ9")
			SZ9->(DbSetOrder(1)) //B1_FILIAL + B1_COD
			SZ9->(DbGoTop())

			SZ9->(DbSeek(xFilial('SZ9')+_cNProp))

			Reclock("SZ9",.F.)
				SZ9->Z9_BOOK	 	:= SUBSTR(oComboBx1,1,1)
				//SZ9->Z9_VIAEXEC		:= SUBSTR(oComboBx2,1,1)
				SZ9->Z9_INDUSTR		:= cGet4 
				SZ9->Z9_IDCONTR		:= cGet8
				SZ9->Z9_CONTR		:= cGet9
				SZ9->Z9_IDCLFIN		:= cGet10
				SZ9->Z9_CLIFIN		:= cGet11
				//SZ9->Z9_XCOEQ		:= cGet12
				//SZ9->Z9_XEQUIP		:= cGet13
				//SZ9->Z9_DIMENS		:= cGet14
				SZ9->Z9_DTREG		:= cGet15
				SZ9->Z9_DTEPROP		:= cGet16
				SZ9->Z9_DTEREAL		:= cGet17
				SZ9->Z9_DTPREV		:= cGet18
				SZ9->Z9_IDELAB		:= cGet19
				SZ9->Z9_RESPELA		:= cGet20
				SZ9->Z9_IDRESP		:= cGet21
				SZ9->Z9_RESP		:= cGet22
				SZ9->Z9_CODPAIS		:= cGet23
				SZ9->Z9_PAIS		:= cGet24
				SZ9->Z9_CODREP		:= cGet25
				SZ9->Z9_REPRE		:= cGet26
				SZ9->Z9_LOCAL		:= cGet27
				SZ9->Z9_PROJETO		:= cGet28
				SZ9->Z9_STATUS		:= SUBSTR(oComboBx3,1,1)
				SZ9->Z9_PCONT		:= cGet30
				SZ9->Z9_CUSFIN		:= cGet31
				SZ9->Z9_FIANCAS		:= cGet32
				SZ9->Z9_PROVGAR		:= cGet33
				SZ9->Z9_PERDIMP		:= cGet34
				SZ9->Z9_PROYALT		:= cGet35
				SZ9->Z9_PCOMIS		:= cGet36
				//SZ9->Z9_CUSTPR		:= cGet37
				//SZ9->Z9_CUSTOT		:= cGet38
				SZ9->Z9_TOTSI		:= cGet39
				SZ9->Z9_TOTCI		:= cGet40
			MsUnlock()

		DbSelectArea("ZZM")
		ZZM->(DbSetOrder(1)) //B1_FILIAL + B1_COD
		ZZM->(DbGoTop())

		TRB1->(DbGoTop())
		while TRB1->(!eof())
			cGrupo := TRB1->GRUPO
			cNProp := alltrim(TRB1->NPROP) 
			//msginfo("Inicio" + cGrupo + cNProp)
			
			IF ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/999")
					Reclock("ZZM",.F.)
						//msginfo("Edit" + cGrupo + cNProp)	
						ZZM->ZZM_FILIAL	:= "01"
						ZZM->ZZM_GRUPO	:= TRB1->GRUPO
						ZZM->ZZM_ITEM	:= TRB1->ITEM	
						//PRIMARY	
						ZZM->ZZM_QUANT	:= TRB1->QUANT	
						ZZM->ZZM_VUNIT	:= TRB1->VUNIT
						ZZM->ZZM_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZM->ZZM_QTDLB	:= TRB1->QUANTLB	
						ZZM->ZZM_UNITLB	:= TRB1->VUNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZM->ZZM_QTDEF	:= TRB1->QUANTEF	
						ZZM->ZZM_UNITEF	:= TRB1->VUNITEF
						ZZM->ZZM_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZM->ZZM_TOTGR	:= TRB1->TOTGR 

						//PRIMARY US$	
						ZZM->ZZM_VUNITD	:= TRB1->VUNITD
						ZZM->ZZM_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZM->ZZM_UNITLD	:= TRB1->UNITLD
						ZZM->ZZM_TOTLB	:= TRB1->TOTLD
						// EXOTIC FAB US$
						ZZM->ZZM_UNITED	:= TRB1->UNITED
						ZZM->ZZM_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZM->ZZM_TOTGRD	:= TRB1->TOTGRD

						ZZM->ZZM_NPROP 	:= TRB1->NPROP		
						ZZM->ZZM_ITEMCT	:= TRB1->ITEMCT
						ZZM->ZZM_GS		:= TRB1->GS
					MsUnlock()
		
			elseIF !ZZM->( dbSeek( xFilial("ZZM")+cGrupo+cNProp) )  .AND. !alltrim(cGrupo) $ ("199/209/299/799/999")
					ZZM->( DBAppend( .F. ) )
						//msginfo("append" + cGrupo + cNProp)
						ZZM->ZZM_FILIAL	:= "01"
						ZZM->ZZM_GRUPO	:= TRB1->GRUPO
						ZZM->ZZM_ITEM	:= TRB1->ITEM	
						//PRIMARY	
						ZZM->ZZM_QUANT	:= TRB1->QUANT	
						ZZM->ZZM_VUNIT	:= TRB1->VUNIT
						ZZM->ZZM_TOTAL	:= TRB1->TOTAL
						// LARGE BUYOUTS
						ZZM->ZZM_QTDLB	:= TRB1->QUANTLB	
						ZZM->ZZM_UNITLB	:= TRB1->VUNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB
						ZZM->ZZM_QTDEF	:= TRB1->QUANTEF	
						ZZM->ZZM_UNITEF	:= TRB1->VUNITEF
						ZZM->ZZM_TOTEF	:= TRB1->TOTEF
						// TOTAL GERAL
						ZZM->ZZM_TOTGR	:= TRB1->TOTGR 

						//PRIMARY US$	
						ZZM->ZZM_VUNITD	:= TRB1->VUNITD
						ZZM->ZZM_TOTALD	:= TRB1->TOTALD
						// LARGE BUYOUTS US$
						ZZM->ZZM_UNITLD	:= TRB1->UNITLB
						ZZM->ZZM_TOTLB	:= TRB1->TOTLB
						// EXOTIC FAB US$
						ZZM->ZZM_UNITED	:= TRB1->UNITED
						ZZM->ZZM_TOTED	:= TRB1->TOTED
						// TOTAL GERAL US$
						ZZM->ZZM_TOTGRD	:= TRB1->TOTGRD

						ZZM->ZZM_NPROP 	:= TRB1->NPROP		
						ZZM->ZZM_ITEMCT	:= TRB1->ITEMCT
						ZZM->ZZM_GS		:= TRB1->GS
					ZZM->( DBCommit() )
			ENDIF
			
			TRB1->(dbskip())
		enddo
		TRB1->(dbgotop())
		
		/*DbSelectArea("TRB1")
		TRB1->(dbgotop())
		zap
		MSAguarde({||zDetProp()},"Processando Detalhamento Proposta")
		TRB1->(DBGoBottom())
		GetdRefresh()*/

		zAtuCustZ9()
		
		_oDlgSint:End()

Return 

//************** ATUALIZAR CUSTO DE PRODUCAO E CUSTO TOTAL
static function zAtuCustZ9()
	
		local nTotalCUPR := 0
		local nTotalCUTO := 0
		local nContar := 0

		cQuery := " SELECT ZZM_NPROP AS 'TMP_NPROP' FROM ZZM010 WHERE ZZM_NPROP = '" + _cNProp + "' AND D_E_L_E_T_ <> '*' "
		TCQuery cQuery New Alias "TZZM"
				
		Count To nTotReg
		TZZM->(DbGoTop()) 

    	nContar := nTotReg

		if nContar > 0

			TRB1->(dbgotop())
			while TRB1->(!eof())
				IF  alltrim(TRB1->NPROP) = _cNProp .AND. alltrim(TRB1->GRUPO) = "999"
					nTotalCUTO		:= TRB1->TOTGR	
					
				ENDIF
				IF  alltrim(TRB1->NPROP) = _cNProp .AND. alltrim(TRB1->GRUPO) = "799" 
					nTotalCUPR		:= TRB1->TOTGR	
				ENDIF
				TRB1->(dbskip())
			enddo

			SZ9->(DbSeek(xFilial('SZ9')+_cNProp))
			Reclock("SZ9",.F.)
				SZ9->Z9_CUSTPR		:= nTotalCUPR
				SZ9->Z9_CUSTOT		:= nTotalCUTO
				oGet37				:= nTotalCUPR
				oGet38				:= nTotalCUTO
			MsUnlock()
			nTotalCUPR := 0
			nTotalCUTO := 0
			
		ENDIF

		TZZM->(DbCloseArea())
	
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
aAdd(aStru,{"GRUPO"	,"C",12,0}) // GRUPO
aAdd(aStru,{"ATUAL"	,"L",01,0}) // ATUALIZACAO DINAMICA
aAdd(aStru,{"ITEM"	,"C",80,0}) // DESCRICAO ITEM

aAdd(aStru,{"QUANT"	,"N",15,6}) // QUANTIDADE

aAdd(aStru,{"VUNIT"	,"N",15,2}) // VALOR UNITARIO R$ PRIMARY
aAdd(aStru,{"TOTAL"	,"N",15,2}) // TOTAL R$ PRIMARY
aAdd(aStru,{"VUNITD","N",15,2}) // VALOR UNITARIO US$ PRIMARY
aAdd(aStru,{"TOTALD","N",15,2}) // TOTAL US$ PRIMARY

aAdd(aStru,{"QUANTLB","N",15,6}) // QUANTIDADE

aAdd(aStru,{"VUNITLB","N",15,2}) // VALOR UNITARIO R$ LARGE BUYOUTS
aAdd(aStru,{"TOTLB"	,"N",15,2}) // TOTAL R$ LARGE BUYOUTS
aAdd(aStru,{"UNITLD","N",15,2}) // VALOR UNITARIO US$ LARGE BUYOUTS
aAdd(aStru,{"TOTLD"	,"N",15,2}) // TOTAL US$ LARGE BUYOUTS

aAdd(aStru,{"QUANTEF","N",15,6}) // QUANTIDADE

aAdd(aStru,{"VUNITEF","N",15,2}) // VALOR UNITARIO R$ EXOT FAV
aAdd(aStru,{"TOTEF"	,"N",15,2}) // TOTAL R$ EXOT FAB
aAdd(aStru,{"UNITED","N",15,2}) // VALOR UNITARIO US$ EXOT FAV
aAdd(aStru,{"TOTED"	,"N",15,2}) // TOTAL US$ EXOT FAB

aAdd(aStru,{"TOTGR"	,"N",15,2}) // TOTAL R$
aAdd(aStru,{"TOTGRD","N",15,2}) // TOTAL R$ US$

aAdd(aStru,{"NPROP"	,"C",13,0}) // NUMERO PROPOSTA

aAdd(aStru,{"ITEMCT","C",13,0}) // ITEM CONTA 1
aAdd(aStru,{"ITEMC2","C",13,0}) // ITEM CONTA 2
aAdd(aStru,{"ITEMC3","C",13,0}) // ITEM CONTA 3
aAdd(aStru,{"ITEMC4","C",13,0}) // ITEM CONTA 4
aAdd(aStru,{"ITEMC5","C",13,0}) // ITEM CONTA 5 
aAdd(aStru,{"ITEMC6","C",13,0}) // ITEM CONTA 6
aAdd(aStru,{"ITEMC7","C",13,0}) // ITEM CONTA 7
aAdd(aStru,{"ITEMC8","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMC9","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMC0","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCA","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCB","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCC","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCD","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCE","C",13,0}) // ITEM CONTA 8
aAdd(aStru,{"ITEMCF","C",13,0}) // ITEM CONTA 8

aAdd(aStru,{"GS"	,"C",01,0}) // GRUPO OU SUBGRUPO
aAdd(aStru,{"PL1"	,"C",02,0}) // PLANILHA 1
aAdd(aStru,{"PL2"	,"C",02,0}) // PLANILHA 2
aAdd(aStru,{"PL3"	,"C",02,0}) // PLANILHA 3
aAdd(aStru,{"PL4"	,"C",02,0}) // PLANILHA 4
aAdd(aStru,{"PL5"	,"C",02,0}) // PLANILHA 5
aAdd(aStru,{"PL6"	,"C",02,0}) // PLANILHA 6
aAdd(aStru,{"PL7"	,"C",02,0}) // PLANILHA 7
aAdd(aStru,{"PL8"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PL9"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PL0"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLA"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLB"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLC"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLD"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLE"	,"C",02,0}) // PLANILHA 8
aAdd(aStru,{"PLF"	,"C",02,0}) // PLANILHA 8

// PRIMARY
aAdd(aStru,{"QTDP1","N",15,2}) // QTD P1
aAdd(aStru,{"UNITP1","N",15,2}) // UNIT P1
aAdd(aStru,{"TOTP1","N",15,2}) // TOTAL P1

aAdd(aStru,{"QTDP2","N",15,2}) // QTD P2
aAdd(aStru,{"UNITP2","N",15,2}) // UNIT P2
aAdd(aStru,{"TOTP2","N",15,2}) // TOTAL P2

aAdd(aStru,{"QTDP3","N",15,2}) // QTD P3
aAdd(aStru,{"UNITP3","N",15,2}) // UNIT P3
aAdd(aStru,{"TOTP3","N",15,2}) // TOTAL P3

aAdd(aStru,{"QTDP4","N",15,2}) // QTD P4
aAdd(aStru,{"UNITP4","N",15,2}) // UNIT P4
aAdd(aStru,{"TOTP4","N",15,2}) // TOTAL P4

aAdd(aStru,{"QTDP5","N",15,2}) // QTD P5
aAdd(aStru,{"UNITP5","N",15,2}) // UNIT P5
aAdd(aStru,{"TOTP5","N",15,2}) // TOTAL P5

aAdd(aStru,{"QTDP6","N",15,2}) // QTD P6
aAdd(aStru,{"UNITP6","N",15,2}) // UNIT P6
aAdd(aStru,{"TOTP6","N",15,2}) // TOTAL P6

aAdd(aStru,{"QTDP7","N",15,2}) // QTD P7
aAdd(aStru,{"UNITP7","N",15,2}) // UNIT P7
aAdd(aStru,{"TOTP7","N",15,2}) // TOTAL P7

aAdd(aStru,{"QTDP8","N",15,2}) // QTD P8
aAdd(aStru,{"UNITP8","N",15,2}) // UNIT P8
aAdd(aStru,{"TOTP8","N",15,2}) // TOTAL P8

aAdd(aStru,{"QTDP9","N",15,2}) // QTD P9
aAdd(aStru,{"UNITP9","N",15,2}) // UNIT P9
aAdd(aStru,{"TOTP9","N",15,2}) // TOTAL P9

aAdd(aStru,{"QTDP0","N",15,2}) // QTD P0
aAdd(aStru,{"UNITP0","N",15,2}) // UNIT P0
aAdd(aStru,{"TOTP0","N",15,2}) // TOTAL P0

aAdd(aStru,{"QTDPA","N",15,2}) // QTD PA
aAdd(aStru,{"UNITPA","N",15,2}) // UNIT PA
aAdd(aStru,{"TOTPA","N",15,2}) // TOTAL PA

aAdd(aStru,{"QTDPB","N",15,2}) // QTD PB
aAdd(aStru,{"UNITPB","N",15,2}) // UNIT PB
aAdd(aStru,{"TOTPB","N",15,2}) // TOTAL PB

aAdd(aStru,{"QTDPC","N",15,2}) // QTD PC
aAdd(aStru,{"UNITPC","N",15,2}) // UNIT PC
aAdd(aStru,{"TOTPC","N",15,2}) // TOTAL PC

aAdd(aStru,{"QTDPD","N",15,2}) // QTD PD
aAdd(aStru,{"UNITPD","N",15,2}) // UNIT PD
aAdd(aStru,{"TOTPD","N",15,2}) // TOTAL PD

aAdd(aStru,{"QTDPE","N",15,2}) // QTD PE
aAdd(aStru,{"UNITPE","N",15,2}) // UNIT PE
aAdd(aStru,{"TOTPE","N",15,2}) // TOTAL PE

aAdd(aStru,{"QTDPF","N",15,2}) // QTD PF
aAdd(aStru,{"UNITPF","N",15,2}) // UNIT PF
aAdd(aStru,{"TOTPF","N",15,2}) // TOTAL PF
// LARGE BYOUTS
aAdd(aStru,{"QTDP1L","N",15,2}) // QTD P1 LB
aAdd(aStru,{"UNIP1L","N",15,2}) // UNIT P1 LB
aAdd(aStru,{"TOTP1L","N",15,2}) // TOTAL P1 LB

aAdd(aStru,{"QTDP2L","N",15,2}) // QTD P2 LB
aAdd(aStru,{"UNIP2L","N",15,2}) // UNIT P2 LB
aAdd(aStru,{"TOTP2L","N",15,2}) // TOTAL P2 LB

aAdd(aStru,{"QTDP3L","N",15,2}) // QTD P3 LB
aAdd(aStru,{"UNIP3L","N",15,2}) // UNIT P3 LB
aAdd(aStru,{"TOTP3L","N",15,2}) // TOTAL P3 LB

aAdd(aStru,{"QTDP4L","N",15,2}) // QTD P4 LB
aAdd(aStru,{"UNIP4L","N",15,2}) // UNIT P4 LB
aAdd(aStru,{"TOTP4L","N",15,2}) // TOTAL P4 LB

aAdd(aStru,{"QTDP5L","N",15,2}) // QTD P5 LB
aAdd(aStru,{"UNIP5L","N",15,2}) // UNIT P5 LB
aAdd(aStru,{"TOTP5L","N",15,2}) // TOTAL P5 LB

aAdd(aStru,{"QTDP6L","N",15,2}) // QTD P6 LB
aAdd(aStru,{"UNIP6L","N",15,2}) // UNIT P6 LB
aAdd(aStru,{"TOTP6L","N",15,2}) // TOTAL P6 LB

aAdd(aStru,{"QTDP7L","N",15,2}) // QTD P7 LB
aAdd(aStru,{"UNIP7L","N",15,2}) // UNIT P7 LB
aAdd(aStru,{"TOTP7L","N",15,2}) // TOTAL P7 LB

aAdd(aStru,{"QTDP8L","N",15,2}) // QTD P8 LB
aAdd(aStru,{"UNIP8L","N",15,2}) // UNIT P8 LB
aAdd(aStru,{"TOTP8L","N",15,2}) // TOTAL P8 LB

aAdd(aStru,{"QTDP9L","N",15,2}) // QTD P9 LB
aAdd(aStru,{"UNIP9L","N",15,2}) // UNIT P9 LB
aAdd(aStru,{"TOTP9L","N",15,2}) // TOTAL P9 LB

aAdd(aStru,{"QTDP0L","N",15,2}) // QTD P0 LB
aAdd(aStru,{"UNIP0L","N",15,2}) // UNIT P0 LB
aAdd(aStru,{"TOTP0L","N",15,2}) // TOTAL P0 LB

aAdd(aStru,{"QTDPAL","N",15,2}) // QTD PA LB
aAdd(aStru,{"UNIPAL","N",15,2}) // UNIT PA LB
aAdd(aStru,{"TOTPAL","N",15,2}) // TOTAL PA LB

aAdd(aStru,{"QTDPBL","N",15,2}) // QTD PB LB
aAdd(aStru,{"UNIPBL","N",15,2}) // UNIT PB LB
aAdd(aStru,{"TOTPBL","N",15,2}) // TOTAL PB LB

aAdd(aStru,{"QTDPCL","N",15,2}) // QTD PC LB
aAdd(aStru,{"UNIPCL","N",15,2}) // UNIT PC LB
aAdd(aStru,{"TOTPCL","N",15,2}) // TOTAL PC LB

aAdd(aStru,{"QTDPDL","N",15,2}) // QTD PD LB
aAdd(aStru,{"UNIPDL","N",15,2}) // UNIT PD LB
aAdd(aStru,{"TOTPDL","N",15,2}) // TOTAL PD LB

aAdd(aStru,{"QTDPEL","N",15,2}) // QTD PE LB
aAdd(aStru,{"UNIPEL","N",15,2}) // UNIT PE LB
aAdd(aStru,{"TOTPEL","N",15,2}) // TOTAL PE LB

aAdd(aStru,{"QTDPFL","N",15,2}) // QTD P8 LB
aAdd(aStru,{"UNIPFL","N",15,2}) // UNIT P8 LB
aAdd(aStru,{"TOTPFL","N",15,2}) // TOTAL P8 LB

// EXOTIC FAB
aAdd(aStru,{"QTDP1E","N",15,2}) // QTD P1 EF
aAdd(aStru,{"UNIP1E","N",15,2}) // UNIT P1 EF
aAdd(aStru,{"TOTP1E","N",15,2}) // TOTAL P1 EF

aAdd(aStru,{"QTDP2E","N",15,2}) // QTD P2 EF
aAdd(aStru,{"UNIP2E","N",15,2}) // UNIT P2 EF
aAdd(aStru,{"TOTP2E","N",15,2}) // TOTAL P2 EF

aAdd(aStru,{"QTDP3E","N",15,2}) // QTD P3 EF
aAdd(aStru,{"UNIP3E","N",15,2}) // UNIT P3 EF
aAdd(aStru,{"TOTP3E","N",15,2}) // TOTAL P3 EF

aAdd(aStru,{"QTDP4E","N",15,2}) // QTD P4 EF
aAdd(aStru,{"UNIP4E","N",15,2}) // UNIT P4 EF
aAdd(aStru,{"TOTP4E","N",15,2}) // TOTAL P4 EF

aAdd(aStru,{"QTDP5E","N",15,2}) // QTD P5 EF
aAdd(aStru,{"UNIP5E","N",15,2}) // UNIT P5 EF
aAdd(aStru,{"TOTP5E","N",15,2}) // TOTAL P5 EF

aAdd(aStru,{"QTDP6E","N",15,2}) // QTD P6 EF
aAdd(aStru,{"UNIP6E","N",15,2}) // UNIT P6 EF
aAdd(aStru,{"TOTP6E","N",15,2}) // TOTAL P6 EF

aAdd(aStru,{"QTDP7E","N",15,2}) // QTD P7 EF
aAdd(aStru,{"UNIP7E","N",15,2}) // UNIT P7 EF
aAdd(aStru,{"TOTP7E","N",15,2}) // TOTAL P7 EF

aAdd(aStru,{"QTDP8E","N",15,2}) // QTD P8 EF
aAdd(aStru,{"UNIP8E","N",15,2}) // UNIT P8 EF
aAdd(aStru,{"TOTP8E","N",15,2}) // TOTAL P8 EF

aAdd(aStru,{"QTDP9E","N",15,2}) // QTD P9 EF
aAdd(aStru,{"UNIP9E","N",15,2}) // UNIT P9 EF
aAdd(aStru,{"TOTP9E","N",15,2}) // TOTAL P9 EF

aAdd(aStru,{"QTDP0E","N",15,2}) // QTD P0 EF
aAdd(aStru,{"UNIP0E","N",15,2}) // UNIT P0 EF
aAdd(aStru,{"TOTP0E","N",15,2}) // TOTAL P0 EF

aAdd(aStru,{"QTDPAE","N",15,2}) // QTD PA EF
aAdd(aStru,{"UNIPAE","N",15,2}) // UNIT PA EF
aAdd(aStru,{"TOTPAE","N",15,2}) // TOTAL PA EF

aAdd(aStru,{"QTDPBE","N",15,2}) // QTD PB EF
aAdd(aStru,{"UNIPBE","N",15,2}) // UNIT PB EF
aAdd(aStru,{"TOTPBE","N",15,2}) // TOTAL PB EF

aAdd(aStru,{"QTDPCE","N",15,2}) // QTD PC EF
aAdd(aStru,{"UNIPCE","N",15,2}) // UNIT PC EF
aAdd(aStru,{"TOTPCE","N",15,2}) // TOTAL PC EF

aAdd(aStru,{"QTDPDE","N",15,2}) // QTD PD EF
aAdd(aStru,{"UNIPDE","N",15,2}) // UNIT PD EF
aAdd(aStru,{"TOTPDE","N",15,2}) // TOTAL PD EF

aAdd(aStru,{"QTDPEE","N",15,2}) // QTD PE EF
aAdd(aStru,{"UNIPEE","N",15,2}) // UNIT PE EF
aAdd(aStru,{"TOTPEE","N",15,2}) // TOTAL PE EF

aAdd(aStru,{"QTDPFE","N",15,2}) // QTD PF EF
aAdd(aStru,{"UNIPFE","N",15,2}) // UNIT PF EF
aAdd(aStru,{"TOTPFE","N",15,2}) // TOTAL PF EF



dbcreate(cArqTrb1,aStru)
dbUseArea(.T.,,cArqTrb1,"TRB1",.F.,.F.)
index on GRUPO to &(cArqTrb1+"1")
set index to &(cArqTrb1+"1")

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

/**************** Exportacao Excel TRB6 Faturamento planejado ********************/

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
            	oFWMsExcel:AddRow("Custos Vendido","Custos Vendido - "  + _cNProp, aLinhaAux,aColsMa)

			elseif LEN(alltrim(aLinhaAux[1])) = 3 .AND. alltrim(aLinhaAux[1]) $ "209/299" // Subtotais
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
