#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

User Function AjusTab2()

	Local cQuery := ""

	RpcSetType( 3 )
	RpcSetEnv('01', '02' )

	cQuery := "  SELECT DA1_CODTAB,DA1_ITEM,DA1_CODPRO, DA1_MOEDA,DA1_CUSTD, B1_CUSTD, B1_COD,B1_MCUSTD "
	cQuery += "  FROM DA1010 DA1 "
	cQuery += "  INNER JOIN SB1010 SB1 "
	cQuery += "  ON B1_COD = DA1_CODPRO "
	cQuery += "  AND B1_MCUSTD = TO_CHAR(DA1_MOEDA)  "
	cQuery += "  AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += "  WHERE DA1_CODTAB BETWEEN  '100' AND '107'   "
	cQuery += "  AND DA1.D_E_L_E_T_ <> '*' "
	cQuery += "  ORDER BY DA1_CODTAB,DA1_ITEm "

	If ( SELECT("TSZO1") ) > 0
		dbSelectArea("TSZO1")
		TSZO1->(dbCloseArea())
	EndIf

	TcQuery cQuery Alias TSZO1 new
	TcSetField( "TSZO1", "B1_CUSTD", "N", 14, 4 )

	While !(TSZO1->(EOF()))
		dbselectarea("DA1")
		dbsetorder(1)
		dbgotop()
		IF dbseek(xfilial("DA1")+ TSZO1->DA1_CODTAB + TSZO1->DA1_CODPRO )
			RECLOCK("DA1",.F.)
			//	DA1->DA1_MOEDA := Val(TSZO1->B1_MCUSTD)
			DA1->DA1_CUSTD := TSZO1->B1_CUSTD
			MSUNLOCK()
		ENDIF
		TSZO1->(dbSkip())

	Enddo


	FT_FUSE()
RPCCLEARENV()

Return
