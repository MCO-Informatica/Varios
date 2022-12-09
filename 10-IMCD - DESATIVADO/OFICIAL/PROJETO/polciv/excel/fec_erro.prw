#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"


USER FUNCTION FEC_ERRO()

	Local cQuery := ""
	Local cPerg := "FECHERRO"
	PRIVATE cArqQry := GetNextAlias()
	PRIVATE cData := '20161031'

	If ! Pergunte( cPerg, .T.)
		RETURN()
	endif
	cData := DTOS(MV_PAR01)

	cQuery := " SELECT B2_FILIAL, B2_COD,B2_LOCAL,B2_QFIM, B9_FILIAL, B9_COD,B9_LOCAL, B9_DATA, B9_QINI, B9_VINI1, B9_VINI2, B9_VINI3, "
	cQuery += " B9_VINI4, B9_VINI5, B9_CUSTD, B9_MCUSTD, B9_CM1, B9_CM2, B9_CM3, B9_CM4, B9_CM5,SB9.R_E_C_N_O_, B1_DESC  "
	cQuery += " FROM "+RETSQLNAME("SB1") +" SB1, "+RETSQLNAME("SB2") +" SB2 LEFT JOIN "+RETSQLNAME("SB9") +" SB9  ON "
	cQuery += " B9_DATA = '"+DTOS(MV_PAR01)+"' "

	cQuery += " AND B9_LOCAL = B2_LOCAL "
	cQuery += " AND B9_COD = B2_COD "
	cQuery += " AND B9_FILIAL = B2_FILIAL "
	cQuery += " AND SB9.D_E_L_E_T_ <> '*' "

	cQuery += " WHERE B1_COD = B2_COD "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*'  "

	if !EMPTY(MV_PAR02)
		cQuery += " AND B2_COD = '"+MV_PAR02+"' "
	ENDIF

	cQuery += " AND B2_FILIAL = '"+XFILIAL("SB2")+"' "
	cQuery += " AND SB2.D_E_L_E_T_ <> '*'  "
	cQuery += " ORDER BY 1,2,4

	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),cArqQry,.T.,.F.)

	If Select( (cArqQry) ) > 0

		Processa( {|lEnd| GERAREXCEL(@lEnd) } , "Aguarde...","Processando Estoque "+DTOC(MV_PAR01)+". Para o Excel",.T. )
		(cArqQry)->( dbCloseArea() )

	EndIf

Return()
Static Function GERAREXCEL(lEnd)

	Local aCabec := {"FILIAL","PRODUTO","DESCRICAO","LOCAL","DATA FECHAM","QTD FECHAMENTO","VLR UNIT FECHAMENTO",;
	"QTD VIRADA","QTD FIM MES","VLR UNIT FIM MES"}
	Local aDados := {}

	dbSelectArea(cArqQry)
	ProcRegua(RecCount())
	dbGotop()

	Do While !(cArqQry)->(EOF() )
		IncProc()
		aSaldos := CalcEst((cArqQry)->B2_COD, (cArqQry)->B2_LOCAL, STOD(cData)+1)
		nSaldo  := 0
		nValEst := 0
		IF aSaldos <> Nil .AND. Len(aSaldos) > 0
			nSaldo := aSaldos[1]
			nValEst := aSaldos[2]
		EndIf

		IF MV_PAR03 == 'D'
			IF nSaldo > 0 .AND. (cArqQry)->B9_QINI <> nSaldo			
				Aadd(aDados,{(cArqQry)->B2_FILIAL, (cArqQry)->B2_COD, (cArqQry)->B1_DESC, (cArqQry)->B2_LOCAL, ;
				(cArqQry)->B9_DATA, (cArqQry)->B9_QINI,(cArqQry)->B9_CM1, (cArqQry)->B2_QFIM,nSaldo, nValEst	})
			Endif
		ELSE

			//IF 	(cArqQry)->B2_QFIM <>  nSaldo

			Aadd(aDados,{(cArqQry)->B2_FILIAL, (cArqQry)->B2_COD, (cArqQry)->B1_DESC, (cArqQry)->B2_LOCAL, ;
			(cArqQry)->B9_DATA, (cArqQry)->B9_QINI,(cArqQry)->B9_CM1, (cArqQry)->B2_QFIM,nSaldo, nValEst	})

			// ENDIF
		ENDIF

		If lEnd
			alert("Cancelado!")
			Return()
		EndIf

		DBSKIP()
		LOOP

	ENDDO

	IF LEN(aDados) > 0
		DlgToExcel({ {"ARRAY", "ACERTOS ESTOQUE", aCabec, aDados} })
	else
		aLERT("NAO HÁ DIVERGENCIAS DE ESTOQUE")
	ENDIF

Return()

