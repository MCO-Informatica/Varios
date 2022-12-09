#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Fun‡„o	 ³ IMCD_SPCGET	³ Autor³ Totvs (SK)	        ³ Data ³ 19/08/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Retonar o campo disponivel para get (Lançamento Ponto)	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ U_IMCD_SPCGET()											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ X3_WHEN dos campos PC_PDI e PC_ABONO                        ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Eventos do ponto que não poderão sofrer manutenção (PC_PDI e PC_ABONO   ±±
±± Cód.          - Descrição											   ±±
±± 437 - *** HRS NAO TRABALHADAS										   ±±
±± 101 - *** HORAS TRABALHADAS                                             ±±
±± 																		   ±±
±± 438 - **HRS NOTURN.NAO TRAB                                             ±±
±± 107 - *** HORAS NOTURNAS TRAB.                                          ±±
±± Para eventos 001/101/002/005 nao permitir get nos campos PC_PDI/PC_ABONO±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SPCGET()

	Local lRet 		:= .T.
	Local cVar		:= ReadVar()
	Local cAlias	:= "SPC"  
	Local cPrefix	:= ( PrefixoCpo( cAlias ) + "_" )

	//-- Numericos -- Posicionamento dos campos em aHeader
	Local nPosPD	:= GdFieldPos( cPrefix + "PD" 		)

	IF aCols[n, nPosPD] $ "101/107/437/438" // EVENTOS QUE O CAMPO NAO PODE TER GET

		If cVar == ("M->" + cPrefix + "PDI") .OR. cVar == ("M->" + cPrefix + "ABONO") 
			lRet 		:= .F.
		ENDIF

	ENDIF

RETURN(LRET)
