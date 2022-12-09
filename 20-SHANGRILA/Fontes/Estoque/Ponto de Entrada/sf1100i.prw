#include "rwmake.ch"

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//  Função.....: SF1100I                          Módulo..: SIGACOM    //
//                                                                     //
//  Autor......: GENILSON MOREIRA LUCAS           Data....: 01/04/2010 //
//                                                                     //
//  Descrição..: Ponto de Entrada na Inclusão do Documento de Entrada  //
//               para Digitação de Dados Complementares                //
//                                                                     //
//  Uso........: Específico Shangri-lá                                 //
//                                                                     //
/////////////////////////////////////////////////////////////////////////

User Function SF1100I

Private _aArea    := GetArea()
Private _cMensa1  := SF1->F1_MENSAGE  			// Mensagem 1
Private _cMensa2  := SF1->F1_MENSAG2  			// Mensagem 2
Private _cMenPad  := SF1->F1_FORMULA  			// Mensagem Padrão
Private _nPesoLi  := SF1->F1_PLIQUI          	// Peso Líquido
Private _nPesoBr  := SF1->F1_PBRUTO         	// Peso Bruto
Private _nVolume  := SF1->F1_VOLUME1         	// Volume
Private _cEspecie := SF1->F1_ESPECI1         	// Espécie
Private _cNDI 		:= SPACE(10)
Private _dDTDI		:= CTOD("")
Private _cUFDI		:= SPACE(2)
Private _cLocDese	:= SPACE(20)
Private _dDTDesem	:= CTOD("")
Private _cEXPORT	:= SPACE(6)
Private _cADICAO	:= SPACE(3)
Private _cSEQADI	:= SPACE(3)
Private _cFABRICA	:= SPACE(6)
Private _cADIC		:= SPACE(100)
_nVolume    :=  0
_cEspecie     :=  "CONTAINER"
_lSair      :=  .F.

dbSelectArea("SD1")
_aAreaSD1 := GetArea()
dbSetOrder(1)
dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),.F.)

If Subs(SD1->D1_CF,1,1)$"3"
/*While .t.
		
		@ 025,005 To 600,705 Dialog janela1 Title OemToAnsi("DI Nota Fiscal")
		
		@ 010,010 Say OemToAnsi("Nota Fiscal")
		@ 010,045 Get SF1->F1_DOC Picture "@!" When .f.
		@ 010,090 Say OemToAnsi("Serie")
		@ 010,119 Get SF1->F1_SERIE Picture "@!" When .f.
		@ 010,150 Say OemToAnsi("Emissao")
		@ 010,180 Get SF1->F1_EMISSAO When .f.
		If SF1->F1_TIPO$"D/B"
			@ 025,010 Say OemToAnsi("Fornecedor") Size 30,10
			@ 025,045 Get SF1->F1_FORNECE When .f. Size 30,10
			@ 025,090 Say OemToAnsi("Loja")
			@ 025,125 Get SF1->F1_LOJA When .f.
			@ 040,010 Say OemToAnsi("Nome Forn.:")
			@ 040,045 Get SA2->A2_NOME When .f. Size 180,10
		Else
			@ 025,010 Say OemToAnsi("Fornecedor") Size 30,10
			@ 025,045 Get SF1->F1_FORNECE When .f. Size 30,10
			@ 025,090 Say OemToAnsi("Loja")
			@ 025,125 Get SF1->F1_LOJA When .f.
			@ 040,010 Say OemToAnsi("Nome Forn.:")
			@ 040,045 Get SA2->A2_NOME When .f. Size 180,10
		EndIf
		@ 055,010 Say OemToAnsi("Numero DI :") Size 50,10
		@ 055,070 Get _cNDI Picture "999999999999"  When .t. Size 60,10
		
		@ 070,010 Say OemToAnsi("DT DI :") Size 50,10
		@ 070,070 Get _dDTDI Picture "D"  When .t.
		
		@ 085,010 Say OemToAnsi("Estado DI :") Size 50,10
		@ 085,070 Get _cUFDI Picture "@!"  When .t. Size 30,10
		
		@ 100,010 Say OemToAnsi("Local Desembarque :") Size 50,10
		@ 100,070 Get _cLocDese Picture "@!"  When .t. Size 70,10
		
		@ 115,010 Say OemToAnsi("DT Desembarque :") Size 50,10
		@ 115,070 Get _dDTDesem Picture "D"  When .t.
		
		@ 130,010 Say OemToAnsi("Cod. Exportacao :") Size 50,10
		@ 130,070 Get _cEXPORT Picture "999999999999"  When .t. Size 60,10
		
		@ 145,010 Say OemToAnsi("Adição :") Size 50,10
		@ 145,070 Get _cADICAO Picture "999999999999"  When .t. Size 30,10
		
		@ 160,010 Say OemToAnsi("Seq. Adição :") Size 50,10
		@ 160,070 Get _cSEQADI Picture "999999999999"  When .t. Size 30,10
		
		@ 175,010 Say OemToAnsi("Fabrica :") Size 50,10
		@ 175,070 Get _cFABRICA Picture "999999999999"  When .t. Size 60,10
		
		@ 190,010 Say OemToAnsi("Peso Liquido:") Size 150,110
		@ 190,070 Get _nPesoLi Picture "999,999.9999"  When .t. Size 70,10
		
		@ 205,010 Say OemToAnsi("Peso Bruto:") Size 150,110
		@ 205,070 Get _nPesoBr Picture "999,999.9999"  When .t. Size 70,10
		
		@ 220,010 Say OemToAnsi("Volume :") Size 50,10
		@ 220,070 Get _nVolume Picture "9999" When .t. Size 50,10
		
		@ 220,145 Say OemToAnsi("Especie") Size 50,10
		@ 220,170 Get _cEspecie Picture "@!" When .t. Size 50,10
		
		@ 235,010 Say OemToAnsi("Dados Adicionais") Size 180,10
		@ 235,070 Get _cAdic Picture "@!" When .t.  Size 180,10
		
		@ 235,260 BmpButton Type 1 Action GravaObs()
		
		Activate Dialog janela1
		
		If _lSair
			Exit
		EndIf
	EndDo */
ElseIf SF1->F1_FORMUL$"S"
	
	@ 000,00 To 310,600 Dialog oDlg Title "Dados Complementares"
	@ 005,05 To 135,295
	@ 015,10 Say "Mensagem 1" 											Size 50,10
	@ 015,65 Get _cMensa1 	Picture "@!"   						Size 220,10
	@ 030,10 Say "Mensagem 2" 											Size 50,10
	@ 030,65 Get _cMensa2 	Picture "@!"   						Size 220,10
	@ 045,10 Say "Mensagem Padrão" 									Size 50,10
	@ 045,65 Get _cMenPad 	Picture "@!" F3 "SM4" Valid (Vazio() .Or. ExistCpo("SM4"))  Size 20,10
	@ 060,10 Say "Peso Líquido"									Size 50,10
	@ 060,65 Get _nPesoLi 	Picture "@E 999999.9999"   			Size 50,10
	@ 075,10 Say "Peso Bruto" 									Size 50,10
	@ 075,65 Get _nPesoBr 	Picture "@E 999999.9999"   			Size 50,10
	@ 090,10 Say "Volume"			 							Size 50,10
	@ 090,65 Get _nVolume 	Picture "@E 999,999.99"   			Size 50,10
	@ 105,10 Say "Espécie"	 									Size 50,10
	@ 105,65 Get _cEspecie 	Picture "@!"   						Size 50,10
	
	@ 140,265 BmpButton Type 1 Action Grava()
	
	Activate Dialog oDlg Centered
	
EndIf


dbSelectArea("SE2")
_aAreaSE2	:=	GetArea()
dbSetOrder(6)
If dbSeek(SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC),.f.)
	
	While Eof() == .f. .and. SE2->(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM) == SF1->(F1_FILIAL+F1_FORNECE+F1_LOJA+F1_SERIE+F1_DOC)
		RecLock("SE2",.f.)
		SE2->E2_DEBITO				:=		Iif(!Empty(SD1->D1_CONTA),SD1->D1_CONTA,"111010001")
		SE2->E2_CCD					:=		SD1->D1_CC
		SE2->E2_CREDIT				:=		Iif(!Empty(POSICIONE("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_CONTA")),POSICIONE("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_CONTA"),"211010001")
		MsUnLock()
		dbSkip()
	EndDo
EndIf
//----> retorna a posicao original antes do PONTO DE ENTRADA
RestArea(_aAreaSE2)

RestArea(_aArea)

SysRefresh()

Return()

Static Function CloseJan()

_lSair := .T.

Close(janela1)

Return()

Static Function GravaObs()

dbSelectArea("CD5")
RecLock("CD5",.T.)
CD5->CD5_FILIAL	:=	xFilial("CD5")
CD5->CD5_DOC	:=	SF1->F1_DOC
CD5->CD5_SERIE	:=	SF1->F1_SERIE
CD5->CD5_ESPEC	:=	"SPED"
CD5->CD5_FORNEC	:=	SF1->F1_FORNECE
CD5->CD5_LOJA	:=	SF1->F1_LOJA
CD5->CD5_NDI	:=  _cNDI
CD5->CD5_DTDI	:= _dDTDI
CD5->CD5_UFDES	:= _cUFDI
CD5->CD5_LOCDES	:= _cLocDese
CD5->CD5_DTDES	:= _dDTDesem
CD5->CD5_CODEXP	:= _cEXPORT
CD5->CD5_NADIC	:=	_cAdicao
CD5->CD5_SQADIC	:=	_cSeqAdi
CD5->CD5_CODFAB	:=	_cFabrica
CD5->CD5_ITEM	:=	"0001"
MsUnLock()

DbSelectArea("SF1")
RecLock("SF1",.F.)
SF1->F1_MENSAGE  := _cADIC
SF1->F1_MENSAG2  := _cMensa2
SF1->F1_FORMULA  := _cMenPad
SF1->F1_PLIQUI   := _nPesoLi
SF1->F1_PBRUTO   := _nPesoBr
SF1->F1_VOLUME1  := _nVolume
SF1->F1_ESPECI1  := _cEspecie
MsUnLock()

_lSair := .T.

Close(janela1)

Return()


/////////////////////
Static Function Grava
/////////////////////

Close(oDlg)

DbSelectArea("SF1")
RecLock("SF1",.F.)
SF1->F1_MENSAGE  := _cMensa1
SF1->F1_MENSAG2  := _cMensa2
SF1->F1_FORMULA   := _cMenPad
SF1->F1_PLIQUI   := _nPesoLi
SF1->F1_PBRUTO   := _nPesoBr
SF1->F1_VOLUME1  := _nVolume
SF1->F1_ESPECI1  := _cEspecie
MsUnLock()

Return
