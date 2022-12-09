#Include 'Protheus.ch'


/*/{Protheus.doc} M460FIM
(long_description)
@type function
@author Thiago Souza
@since 16/11/2020
@version 1.0
@Return lVer, logico, Valor Logico
@example
@see (links_or_references)
/*/
User Function M460FIM()

	Local aArea	:= GetArea()
	Local aFin 	:= BUSTIT()
	Local nI	:= 0
	Local c5Desc:= ""
	Local E1razao:=""

	For nI := 1 to Len(aFin)

		dbSelectArea("SE1")
		dbSetOrder(1)

		SE1->(DBGoto( aFin[nI,01] ))

		c5Desc := Alltrim(SC5->C5_ZDESC)
		E1razao:= Alltrim(SC5->C5_ZNOMCLI)

		If RecLock("SE1",.F.)

			Replace SE1->E1_ZDESC With c5Desc
			Replace SE1->E1_ZNOMCLI With E1razao

			SE1->(MsUnLock())
		EndIf

	Next

	RestArea(aArea)

Return


Static Function BUSTIT(cDoc,cSer)

	Local cQueryP   := ""
	Local aArea	  	:= GetArea()
	Local aFin		:= {}

	cAliasPQry := GetNextAlias( )

	If (Select(cAliasPQry) <> 0)
		dbSelectArea(cAliasPQry)
		dbCloseArea()
	EndIf

	cQueryP :=	"SELECT SE1.R_E_C_N_O_ SE1RECNO												"+;
		"FROM "+RetSqlName("SE1")+" SE1												"+;
		"WHERE 	SE1.D_E_L_E_T_ <> '*' 												"+;
		"		AND SE1.E1_NUM = '"+SF2->F2_DOC+"'									"+;
		"		AND SE1.E1_PREFIXO = '"+SF2->F2_SERIE+"'							"+;
		"       AND SE1.E1_CLIENTE = '"+SF2->F2_CLIENTE+"'							"+;
		"       AND SE1.E1_LOJA = '"+SF2->F2_LOJA+"'							    "+;
		"		AND SE1.E1_FILIAL = '"+xFilial("SE1")+"'							"

	cQueryP := ChangeQuery( cQueryP )

	DbUseArea(.T., "TOPCONN",TCGenQry(,,cQueryP),cAliasPQry,.F., .T.)

	While((cAliasPQry)->(!Eof()))

		aAdd(aFin,{	(cAliasPQry)->SE1RECNO})

		(cAliasPQry)->(dbSkip())

	EndDo

	If (Select(cAliasPQry) <> 0)
		dbSelectArea(cAliasPQry)
		dbCloseArea()
	EndIf

	RestArea(aArea)

Return aFin
