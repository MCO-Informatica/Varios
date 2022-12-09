#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³MTA410T   ³ Autor ³ Eneovaldo Roveri Juni ³ Data ³25/11/2009³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Depois de Liberar o Pedido automático de Venda Enviar email ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function MTA410T()
	Local aArea := GetArea()
	Local _lRet := .T.
	Local _aVal := {}
	Local _cPed := SC5->C5_NUM
	Local _nReg5:= SC5->( recno() )
	Local _nReg6:= SC6->( recno() )
	Local _nReg9:= SC9->( recno() )
	Local _i := 0
	Local lBlqMonit := .F.
	Local lDevBenef := " "
	Local lblqCred := .F.

	IF IsInCallStack("MATA311")

		SC5->( dbgoto( _nReg5 ) )
		SC6->( dbgoto( _nReg6 ) )
		SC9->( dbgoto( _nReg9 ) )

		RestArea(aArea)

		RETURN(.T.)

	ENDIF

	IF SC5->C5_CONDPAG <> "100"

		lBlqMonit := IIF(SA1->A1_POSCLI == "M",.T.,.F.)

	ENDIF

	if PROCNAME( 2 ) == "A440PROCES"
		_aVal := U_A440CKPD( _cPed, .F. ) //Numero do Pedido, .F. - para não exibir mensagens

		For _i := 1 to len( _aVal )
			if .not. _aVal[ _i, 2 ]
				_lRet := .F.
			endif
		Next _i

		if _lRet
			U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Liberacao Pedido Automatica')
		endif
	endif

	if IsInCallStack("MATA440")

		IF procname( 2 ) ==   "A440GRAVA"

			if lBlqMonit

				U_GrvLogPd(SC5->C5_NUM,SC5->C5_CLIENTE,SC5->C5_LOJACLI,'Liberacao Pedido',"O Status do cliente é MONITORADO")

			ENDIF
		ENDIF
	ENDIF

	lDevBenef := SC5->C5_TIPO $'D|B'

	//GRAVA O CAMPO C5_XENTREG em todos os itens do pedido no campo C6_ENTREG:
	SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
	Do While SC6->(!eof()) .AND. SC6->C6_FILIAL + SC6->C6_NUM == xFilial("SC6")+SC5->C5_NUM
		lblqCred := .F.
		Reclock("SC6")
		SC6->C6_ENTREG := SC5->C5_XENTREG
		SC6->(MsUnlock())
		IF !lDevBenef
			dbSelectArea("SC9")
			SC9->(dbSetOrder(1))
			SC9->(dbSeek(SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM))
			do WHile !Eof() .and. SC9->(C9_FILIAL+C9_PEDIDO+C9_ITEM) == SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM
				SC9->( RecLock("SC9",.F.) )
				SC9->C9_ENTREG := SC5->C5_XENTREG

				IF (cEmpAnt == '01' )
					if SC5->C5_CONDPAG $ ('000') .or. lBlqMonit
						lblqCred := .T.
					ENDIF
				elseif cEmpAnt == '02'
					if  ALLTRIM(SC5->C5_CONDPAG) $ ('01/') .or. lBlqMonit
						lblqCred := .T.
					Endif
				Endif
				/*
				
				IF !lblqCred
					lExibMsg := .F.
					lblqCred :=  U_VALIDCONDPAG(SC5->C5_NUM,SC5->C5_CONDPAG,SA1->A1_COND,lExibMsg)
				ENDIF
				
				*/

				DbSelectArea("SC9")
				
				if lblqCred
					SC9->C9_BLCRED := "01"
				endif

				SC9->( MsUnlock() )

				dbSkip()

			Enddo
		ENDIF

		dbSelectArea("SC6")
		SC6->(DbSkip())
	Enddo

	SC5->( dbgoto( _nReg5 ) )
	SC6->( dbgoto( _nReg6 ) )
	SC9->( dbgoto( _nReg9 ) )

	RestArea(aArea)

Return(_lRet)
