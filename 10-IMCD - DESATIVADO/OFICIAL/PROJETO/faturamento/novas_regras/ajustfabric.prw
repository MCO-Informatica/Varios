#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

User Function AjusFabric()

	Local cQuery := ""

	RpcSetType( 3 )
	RpcSetEnv('01', '02' )

	cQuery := "  SELECT * FROM SB8010 WHERE B8_DFABRIC <> B8_DTFABRI AND D_E_L_E_T_ <> '*'  "

	If ( SELECT("TSZO1") ) > 0
		dbSelectArea("TSZO1")
		TSZO1->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TSZO1"

	While !(TSZO1->(EOF()))
		dbselectarea("SB8")
		dbsetorder(3)
		dbgotop()
		IF dbseek( TSZO1->B8_FILIAL+ TSZO1->B8_PRODUTO + TSZO1->B8_LOCAL + TSZO1->B8_LOTECTL )

			If !Empty(TSZO1->B8_DFABRIC) .and. Empty(TSZO1->B8_DTFABRI)
				RECLOCK("SB8",.F.)
				SB8->B8_DTFABRI := Stod(TSZO1->B8_DFABRIC)
				MSUNLOCK()
			ElseIf Empty(TSZO1->B8_DFABRIC) .and. !Empty(TSZO1->B8_DTFABRI)
				RECLOCK("SB8",.F.)
				SB8->B8_DFABRIC := Stod(TSZO1->B8_DTFABRI)
				MSUNLOCK()
			Endif

		ENDIF
		TSZO1->(dbSkip())

	Enddo


	cQuery := "  SELECT C2_FILIAL, C2_PRODUTO, C2_LOTECTL, C2_LOCAL, B8_DFABRIC, B8_DTFABRI, MAX(C2_DTFABRI) AS FBDATA FROM SC2010 "
	cQuery += "  INNER JOIN SB8010 ON C2_PRODUTO = B8_PRODUTO AND C2_LOTECTL = B8_LOTECTL AND C2_LOCAL = B8_LOCAL AND SC2010.D_E_L_E_T_ <> '*' AND SB8010.D_E_L_E_T_ <> '*' AND C2_FILIAL = B8_FILIAL "
	cQuery += " WHERE C2_EMISSAO >= '20180101'  "
	cQuery += "  GROUP BY C2_LOCAL, C2_FILIAL, C2_PRODUTO, C2_LOTECTL, B8_DFABRIC, B8_DTFABRI  "

	If ( SELECT("TSZO2") ) > 0
		dbSelectArea("TSZO2")
		TSZO2->(dbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TSZO2"

	While !(TSZO2->(EOF()))
		dbselectarea("SB8")
		dbsetorder(3)
		dbgotop()
		IF dbseek( TSZO2->C2_FILIAL+ TSZO2->C2_PRODUTO + TSZO2->C2_LOCAL + TSZO2->C2_LOTECTL  )

			If Stod(TSZO2->FBDATA) <> SB8->B8_DTFABRI .and. !empty(TSZO2->FBDATA)
				RECLOCK("SB8",.F.)
				SB8->B8_DTFABRI := Stod(TSZO2->FBDATA)
				MSUNLOCK()
			Endif

			If Stod(TSZO2->FBDATA) <> SB8->B8_DFABRIC  .and. !empty(TSZO2->FBDATA)
				RECLOCK("SB8",.F.)
				SB8->B8_DFABRIC := Stod(TSZO2->FBDATA)
				MSUNLOCK()
			Endif

		ENDIF
		TSZO2->(dbSkip())

	Enddo

	FT_FUSE()

	RPCCLEARENV()
	
Return
