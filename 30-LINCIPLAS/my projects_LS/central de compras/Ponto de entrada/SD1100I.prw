#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"
#INCLUDE "topconn.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TbiCode.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³P.Entrada ³SD1100I   ³Autor  ³Vitor Raspa                ³Data  ³ 24.Jun.08³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Ponto de Entrada localizado apos a gravacao do SD1             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function SD1100I()


Local _nSaldo 	:= 0
Local _nQtdAux	:= 0
Local _nCusto	:= 0
Local _aArea    := GetArea() 
Local _CGC		:= 	Posicione("SA1",1,xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA,"A1_CGC")  

//If SD1->D1_TES $ "409/410/070"

If SD1->D1_TES $ GetMv("MV_TESDEVC")
	
	_nQtdPag := SD1->D1_QUANT
	
	If Select("TMPSB6") > 0
		DbSelectArea("TMPSB6")
		DbCloseArea()
	EndIf
	
	cQrySB6 := " SELECT B6_DOC, B6_SERIE, B6_IDENT, B6_PRUNIT, B6_SALDO, B6_PRODUTO "
	cQrySB6 += " FROM "+RetSqlName("SB6")+" SB6 "
	cQrySB6 += " WHERE "
	cQrySB6 += " B6_FILIAL 			= '"+xFilial("SB6")+"' AND "
	cQrySB6 += " B6_PRODUTO 		= '"+SD1->D1_COD+"' AND "
	cQrySB6 += " B6_CLIFOR 			= '"+SD1->D1_FORNECE+"' AND "
	cQrySB6 += " B6_LOJA 			= '"+SD1->D1_LOJA+"' AND "
	cQrySB6 += " B6_PODER3 			= 'R' AND B6_SALDO > 0 AND B6_TPCF = 'C' AND "
	cQrySB6 += " SB6.D_E_L_E_T_ 	= '' "
	cQrySB6 += " ORDER BY B6_EMISSAO "
	TcQuery cQrySB6 NEW ALIAS "TMPSB6"
	
	DbSelectArea("TMPSB6")
	TMPSB6->( DbGoTop() )
	If TMPSB6->( !Eof() )
		
		While TMPSB6->( !Eof() )
			
			If _nQtdPag > 0
				
				If _nQtdPag <= TMPSB6->B6_SALDO
					_nQtdBx	:= _nQtdPag
				Else
					_nQtdBx := TMPSB6->B6_SALDO
				EndIf
				
				_cDocB6	:= TMPSB6->B6_DOC
				_cSerB6	:= TMPSB6->B6_SERIE
				_cIdeB6	:= TMPSB6->B6_IDENT
				
				_nVlrUnit	:= Round(TMPSB6->B6_PRUNIT,2)
				_nVlrItem   := Round((_nQtdBx * _nVlrUnit),2)
				
				DbSelectArea("SD2")
				SD2->( DbSetOrder(1) )
				If SD2->( DbSeek(xFilial("SD2")+SD1->D1_COD+SD1->D1_LOCAL+_cIdeB6) )
					_nCusto := SD2->D2_CUSTO1/SD2->D2_QUANT
				EndIf
				
				_nCusto 	:= _nCusto * SD1->D1_QUANT
				
				DbSelectArea("SB6")
				SB6->( DbSetOrder(1) )
				If SB6->( DbSeek(xFilial("SB6")+SD1->D1_COD+SD1->D1_FORNECE+SD1->D1_LOJA+_cIdeB6) )
					RecLock("SB6",.F.)
					If _nQtdBx <= SB6->B6_SALDO
						SB6->B6_SALDO := SB6->B6_SALDO - _nQtdBx
						_nQtdAux := _nQtdBx
					Else
						_nQtdAux := SB6->B6_SALDO
						SB6->B6_SALDO -= SB6->B6_SALDO
					EndIf
					
					MsUnLock()
					
					RecLock("SB6",.T.)
					
					SB6->B6_FILIAL	 := xFilial("SB6")
					SB6->B6_CLIFOR	 := SD1->D1_FORNECE
					SB6->B6_LOJA	 := SD1->D1_LOJA
					SB6->B6_PRODUTO	 := SD1->D1_COD
					SB6->B6_LOCAL	 := "01"
					SB6->B6_DOC		 := SD1->D1_DOC
					SB6->B6_SERIE	 := SD1->D1_SERIE
					SB6->B6_EMISSAO	 := SD1->D1_EMISSAO
					SB6->B6_QUANT	 := _nQtdAux
					SB6->B6_PRUNIT	 := SD1->D1_VUNIT
					SB6->B6_TES		 := SD1->D1_TES
					SB6->B6_TIPO	 := "E"
					SB6->B6_CUSTO1	 := _nCusto
					SB6->B6_DTDIGIT	 := dDataBase
					SB6->B6_UM		 := SD1->D1_UM
					SB6->B6_IDENT	 := _cIdeB6
					SB6->B6_TPCF	 := "C"
					SB6->B6_PODER3	 := "D"
					SB6->B6_ESTOQUE	 := "S"
					
					MsUnLock()
					
					_nCusto := 0
					
				EndIf
				
				_nQtdPag := _nQtdPag - _nQtdBx
				
			EndIf
			
			TMPSB6->( DbSkip() )
			
		EndDo
		
	EndIf
	
	DbSelectArea("TMPSB6")
	DbCloseArea()
	
EndIf

// /55" .AND. !Substr(_CGC,1,8) $ GETMV("MV_LSVCNPJ") .AND. !Substr(_CGC,1,8) $ GETMV("MV_CNPJCOL") INCLUIDO POR VANILSON 12-08-2011
If (xFilial('SD1') $ "01/55") .AND. !Substr(_CGC,1,8) $ GETMV("MV_LSVCNPJ") .AND. !Substr(_CGC,1,8) $ GETMV("MV_CNPJCOL")
	
	DbSelectArea("SF4")
	SF4->( DbSetOrder(1) )
	If SF4->( DbSeek(xFilial("SF4")+SD1->D1_TES) )
		
		If SF4->F4_UPRC == "S" .And. SF4->F4_ESTOQUE == "S"
			
			DbSelectArea("SBZ")
			SBZ->( DbSetOrder(1) )
			If SBZ->( DbSeek(xFilial('SD1') + SD1->D1_COD,.f.) )
				
				DbSelectArea("SB1")
				SB1->( DbSetOrder(1) )
				If SB1->( DbSeek(xFilial("SB1")+SD1->D1_COD,.f.) )
					RecLock("SB1",.F.)
					Replace SB1->B1_UPRC With SBZ->BZ_UPRC
					SB1->( MsUnLock() )
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
EndIf

RestArea(_aArea)

Return
   
