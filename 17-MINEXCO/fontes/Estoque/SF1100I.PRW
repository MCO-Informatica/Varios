#include "protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1100I  ³ Autor ³     Rafael de Souza     ³ Data ³ 10/02/2011 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Gera tela para informacoes de DI e Volumes no Doc. de Entrada. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³                                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ricaelle Industria e Comercio Ltda                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function SF1100I()

_aArea := GetArea()

//A455LibAut("SC9")

Private _nPeso		:= 0
Private _nPesoB		:= 0
Private _cNDI 		:= SPACE(10)
Private _dDTDI		:= CTOD("")
Private _cUFDI		:= SPACE(2)
Private _cLocDese	:= SPACE(20)
Private _dDTDesem	:= CTOD("")
Private _cEXPORT	:= SPACE(6)
Private _cADICAO	:= SPACE(3)
Private _cSEQADI	:= SPACE(3)
Private _cFABRICA	:= SPACE(6)
Private nTotM2		:= 0
Private cConTainer	:= space(40)

_nVolume    :=  0
_cEspec     :=  "CONTAINER"
_lSair      :=  .F.

//If Alltrim(SF1->F1_EST) == "EX"
While .t.
	
	@ 025,005 To 500,605 Dialog janela1 Title OemToAnsi("DI Nota Fiscal")
	
	@ 010,010 Say OemToAnsi("Nota Fiscal")
	@ 010,045 Get SF1->F1_DOC Picture "@!" When .f.
	@ 010,090 Say OemToAnsi("Serie")
	@ 010,119 Get SF1->F1_SERIE Picture "@!" When .f.
	@ 010,150 Say OemToAnsi("Emissao")
	@ 010,180 Get SF1->F1_EMISSAO  Size 50,10 When .f.
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
	@ 070,070 Get _dDTDI Picture "D" Size 50,10 When .t.
	
	@ 085,010 Say OemToAnsi("Estado DI :") Size 50,10
	@ 085,070 Get _cUFDI Picture "@!"  When .t. Size 30,10
	
	@ 100,010 Say OemToAnsi("Local Desembarque :") Size 50,10
	@ 100,070 Get _cLocDese Picture "@!"  When .t. Size 70,10
	
	@ 115,010 Say OemToAnsi("DT Desembarque :") Size 50,10
	@ 115,070 Get _dDTDesem Picture "D" Size 50,10 When .t.
	
	@ 130,010 Say OemToAnsi("Cod. Exportacao :") Size 50,10
	@ 130,070 Get _cEXPORT Picture "999999999999"  When .t. Size 60,10
	
	@ 145,010 Say OemToAnsi("Adição :") Size 50,10
	@ 145,070 Get _cADICAO Picture "999999999999"  When .t. Size 30,10
	
	@ 160,010 Say OemToAnsi("Seq. Adição :") Size 50,10
	@ 160,070 Get _cSEQADI Picture "999999999999"  When .t. Size 30,10
	
	@ 175,010 Say OemToAnsi("Fabrica :") Size 50,10
	@ 175,070 Get _cFABRICA Picture "999999999999"  When .t. Size 60,10
	
	@ 190,010 Say OemToAnsi("Peso Liquido:") Size 150,110
	@ 190,070 Get _nPeso Picture "999,999.9999"  When .t. Size 70,10
	
	@ 190,145 Say OemToAnsi("Peso Bruto:") Size 150,110
	@ 190,180 Get _nPesoB Picture "999,999.9999"  When .t. Size 70,10
	
	@ 205,010 Say OemToAnsi("Container:") Size 150,110
	@ 205,070 Get cContainer Picture "@!"  When .t. Size 180,10
	
	@ 220,010 Say OemToAnsi("Volume :") Size 50,10
	@ 220,070 Get _nVolume Picture "9999" When .t. Size 50,10
	
	@ 220,145 Say OemToAnsi("Especie") Size 50,10
	@ 220,170 Get _cEspec Picture "@!" When .t. Size 50,10
	
	@ 220,260 BmpButton Type 1 Action GravaObs()
	
	Activate Dialog janela1
	
	If _lSair
		Exit
	EndIf
EndDo

RestArea(_aArea)

SysRefresh()
//Endif

Return()

Static Function CloseJan()

_lSair := .T.

Close(janela1)

Return()

Static Function GravaObs()

RecLock("SF1",.f.)
SF1->F1_NDI		:=  _cNDI
SF1->F1_DTDI		:= _dDTDI
SF1->F1_UFDI		:= _cUFDI
SF1->F1_LOCDESE	:= _cLocDese
SF1->F1_DTDESEM	:= _dDTDesem
SF1->F1_EXPORT	:= _cEXPORT
SF1->F1_PLIQUI	:= _nPeso
SF1->F1_PBRUTO	:= _nPesoB
SF1->F1_VOLUME1 := _nVolume
SF1->F1_ESPECI1 := _cEspec
SF1->F1_CONTAI	:= cContainer
//SF1->F1_MENNOTA := "DI: "+_cNDI+" DE "+DTOC(_dDTDI)
MsUnLock()

dbSelectArea("SD1")
_aAreaSD1 := GetArea()
dbSetOrder(1)
If dbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA),.F.)
	While Eof() = .f. .And. SD1->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA) == SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)
		
		RecLock("SD1",.f.)
		SD1->D1_TOTAL := SD1->D1_QUANT * SD1->D1_VUNIT
		MsUnLock()
		
		
		If Alltrim(SF1->F1_EST) == "EX"

			_lNotaNac := .f.	//----> NÃO É NOTA NACIONAL
			
			If posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_XTPGRP") $ "C"  //PRODUTO CHAPA
				nTotM2 += SD1->D1_QUANT			
			EndIf

			dbselectarea("CD5")
			dbsetorder(3)
			If !dbseek(xfilial("CD5")+_cAdicao+_cSeqAdi,.f.)
				
				reclock("CD5",.t.)
				CD5_FILIAL	:= xfilial("CD5")
				CD5_DOC		:= SD1->D1_DOC
				CD5_SERIE		:= SD1->D1_SERIE
				CD5_ESPEC		:= SD1->D1_TIPO
				CD5_FORNEC	:= SF1->F1_FORNECE
				CD5_LOJA		:= SF1->F1_LOJA
				CD5_TPIMP		:= "0"
				CD5_DOCIMP	:= _cNdi
				CD5_NDI		:= _cNdi
				CD5_DTDI		:= _dDtDi
				CD5_LOCDES	:= _cLocDese
				CD5_UFDES		:= _cUFDI
				CD5_DTDES		:= _dDtDesem
				CD5_CODEXP	:= SF1->F1_FORNECE
				CD5_NADIC		:= _cAdicao
				CD5_SQADIC	:= _cSeqAdi
				CD5_CODFAB	:= SF1->F1_FORNECE
				CD5_ITEM		:= SD1->D1_ITEM   
				CD5_INTERM	:= "1"
				CD5_VTRANS	:= "1"
				CD5_LOCAL		:= "0"   
			//	CD5_VAFRMM	:= '0.00'


				msunlock()
				
				_cSeqAdi := Soma1(_cSeqAdi)
				
			EndIf
		Else
		
			_lNotaNac := .t.	//----> É NOTA NACIONAL

			If posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_XTPGRP") $ "C"  .and. posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_TIPO") $ "PA"
				nTotM2 += SD1->D1_QUANT			
			EndIf

		EndIf
		
		If !Empty(SD1->D1_OBSMIN)
			RecLock("SF1",.F.)
			SF1->F1_MENNOTA := SD1->D1_OBSMIN
			MsUnLock()
		EndIf
		
		dbSelectArea("SD1")
		dbSkip()
	EndDo
EndIf

If nTotM2 <> 0
	If _lNotaNac
		If MsgYesNo("NOTA FISCAL NACIONAL - Deseja alimentar a rotina de manutenção de container?","Manutenção Container","YesNo")
			RecLock("SF1",.F.)
				SF1->F1_XTOTM2 	:= nTotM2
				SF1->F1_XSTATUS := "1"
			MsUnLock()
    	EndIf
	Else
		RecLock("SF1",.F.)
			SF1->F1_XTOTM2 	:= nTotM2
			SF1->F1_XSTATUS := "1"
		MsUnLock()
	EndIf
EndIf

_lSair := .T.

Close(janela1)

Return()
