#Include "Protheus.Ch"
#Include "TopConn.Ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: Z05Fecha  | Autor: Celso Ferrone Martins  | Data: 04/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao | Fechamento dos debitos/crditos vendedores                  |||
||+-----------+------------------------------------------------------------+||
||| Alteracao | 08/07/2015 - ajuste no fechamento                          |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function Z05Fecha()

Local oDlg
Local nOpca		:= 0
Local dDataFec	:= LastDay(GetMV("VQ_DCULMES", .F.)+1)

If dDataBase < dDataFec
	MsgInfo("A data base do sistema está menor que a última data de fechamento. Por favor, altere a mesma.")
	Return()
EndIf

Define MsDialog oDlg From 100,004 To 260,300 Title "Fechamento Debito/Credito" Pixel

@ 005,004 To 060,150 LABEL "" Pixel

@ 009,009 Say "O programa fará a transferência dos saldos finais," Size 150,024 Pixel
@ 019,009 Say "calculados na rotina de Fechamento Debito/Credito," Size 150,024 Pixel
@ 029,009 Say "para os saldos iniciais do proximo período."        Size 150,024 Pixel

@ 042,050 MsGet	dDataFec Size 039,009 Valid !Empty(dDataFec) When .F. Pixel

Define sButton From 065,090 Type 1 Action (nOpca := 1,oDlg:End()) Enable Of oDlg
Define sButton From 065,120 Type 2 Action oDlg:End()              Enable Of oDlg
Activate MsDialog oDlg Center

Processa( {|| Z05Exec(dDataFec,nOpca) }, "Fechamento Débito/Crédito", "Processando...", .F.)

Return()

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+---------------------+-------------------------------+------------------+||
||| Programa: Z05Exec   | Autor: Celso Ferrone Martins  | Data: 04/06/2014 |||
||+-----------+---------+-------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function Z05Exec(dDataFec,nOpca)

DbSelectArea("Z05") ; DbSetOrder(1)
_nTotal := 0
If nOpca == 1    
	cQuery := " SELECT "
	cQuery += "   VENDEDOR, "
	//	cQuery += "   REGIAO, "
	//	cQuery += "   GRPVEN, "
	cQuery += "   SUM(VALOR) AS VALOR "
	cQuery += " FROM ( SELECT "
	cQuery += "      Z04_VENDED AS VENDEDOR, "
	cQuery += "      Z04_REGIAO AS REGIAO, "
	cQuery += "      Z04_GRPVEN AS GRPVEN, "
	cQuery += "         CASE "
	cQuery += "            WHEN Z04_TIPODC = 'C' THEN sum(Z04_VALOR) "
	cQuery += "            WHEN Z04_TIPODC = 'D' THEN sum(Z04_VALOR)*-1 "
	cQuery += "         END AS VALOR "
	cQuery += "      FROM " + RetSQLName("Z04")+" "
	cQuery += "      WHERE "
	cQuery += "         D_E_L_E_T_ <> '*' "
	cQuery += "         AND Z04_EMISSA BETWEEN '"+DtoS(FirstDay(dDataFec))+"' AND '"+DtoS(dDataFec)+"' "
	cQuery += "      GROUP BY Z04_VENDED, Z04_REGIAO, Z04_GRPVEN, Z04_TIPODC "
	cQuery += " )"
	cQuery += " GROUP BY VENDEDOR "
	cQuery += " ORDER BY VENDEDOR "
	//	cQuery += "	,GRPVEN "

	cQuery := ChangeQuery(cQuery)
	
	If Select("TMPZ04") > 0
		TMPZ04->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias "TMPZ04"
	
	DbSelectArea("TMPZ04")
	nTotalReg := TMPZ04->(RecCount())//Contar("TMPZ04", "!Eof()")
	//	TMPZ04->(DbGoTop())
	ProcRegua(nTotalReg)
	
	While TMPZ04->(!Eof())

		IncProc(AllTrim(TMPZ04->VENDEDOR))

		RecLock("Z05", .T.)
		Z05->Z05_FILIAL := xFilial("Z05")
		Z05->Z05_VENDED := TMPZ04->VENDEDOR    
		_dData := FirstDay(dDataFec)
		_nSaldoAnt := SldAtVd2(TMPZ04->VENDEDOR, _dData)
		//Z05->Z05_REGIAO := TMPZ04->REGIAO //08/12/2014
		//Z05->Z05_GRPVEN := TMPZ04->GRPVEN //08/12/2014
		Z05->Z05_DATA   := dDataFec
		_nTotal := TMPZ04->VALOR + _nSaldoAnt				
		Z05->Z05_TIPODC := If(_nTotal > 0, "C", "D")  		
		Z05->Z05_VALOR  := Abs(_nTotal)
		Z05->Z05_USER   := __cUserId
		Z05->Z05_DTLANC := Date()
		Z05->Z05_HRLANC := Time()
		Z05->(MsUnlock())

		TMPZ04->(DbSkip())
	EndDo

	PutMV("VQ_DCULMES", DtoS(dDataFec))

	If Select("TMPZ04") > 0
		TMPZ04->(DbCloseArea())
	EndIf

EndIf

Return()   


Static Function SldAtVd2(_cVend, _cData)

Local nSldAnt  := 0
Local dUltFech := cTod("  /  /  ")

cQuery := " SELECT "
cQuery += "    MAX(Z05_DATA) AS ULTFECH"
cQuery += " FROM "+RetSqlName("Z05")
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND Z05_FILIAL = '"+xFilial("Z05")+"' "
cQuery += "    AND Z05_DATA   < '"+DtoS(_cData)+"' "

cQuery := ChangeQuery(cQuery)

If Select("TMPDAT") > 0
	TMPDAT->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPDAT"

If !TMPDAT->(Eof())
	dUltFech := sTod(TMPDAT->ULTFECH)
EndIf

If Select("TMPDAT") > 0
	TMPDAT->(DbCloseArea())
EndIf

cQuery := ""
cQuery += " SELECT SUM(Z05_VALOR) AS VALOR FROM ( "
cQuery += " SELECT "
cQuery += "      CASE "
cQuery += "         WHEN Z05_TIPODC = 'D' THEN Z05_VALOR*-1 "
cQuery += "         ELSE Z05_VALOR  "                          
cQuery += "      END Z05_VALOR    "  
cQuery += " FROM " + RetSqlName("Z05") + " Z05 "
cQuery += " WHERE "
cQuery += "    D_E_L_E_T_ <> '*' "
cQuery += "    AND Z05_DATA = '"+dTos(dUltFech)+"' "
cQuery += "    AND Z05_VENDED = '"+_cVend+"' "

If dUltFech+1 <= _cData-1
	cQuery += " UNION ALL "
	
	cQuery += " SELECT "
	cQuery += "   SUM(VALOR) AS VALOR "
	cQuery += " FROM ( "
	cQuery += "    SELECT "
	cQuery += "      Z04_VENDED AS VENDEDOR, "
	cQuery += "      Z04_REGIAO AS REGIAO, "
	cQuery += "      Z04_GRPVEN AS GRPVEN, "
	cQuery += "         CASE "
	cQuery += "            WHEN Z04_TIPODC = 'C' THEN sum(Z04_VALOR) "
	cQuery += "            WHEN Z04_TIPODC = 'D' THEN sum(Z04_VALOR)*-1 "
	cQuery += "         END AS VALOR "
	cQuery += "    FROM " + RetSQLName("Z04")+" "
	cQuery += "    WHERE "
	cQuery += "       D_E_L_E_T_ <> '*' "
	cQuery += "       AND Z04_EMISSA BETWEEN '"+DtoS((dUltFech+1))+"' AND '"+DtoS((_cData-1))+"' "
	cQuery += "       AND Z04_VENDED = '"+_cVend+"' "
	cQuery += "    GROUP BY Z04_VENDED, Z04_REGIAO, Z04_GRPVEN, Z04_TIPODC "
	cQuery += " )"
EndIf
cQuery += " )"

cQuery := ChangeQuery(cQuery)

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TMPZ05"

If !TMPZ05->(Eof())
	nSldAnt := TMPZ05->VALOR
EndIf

If Select("TMPZ05") > 0
	TMPZ05->(DbCloseArea())
EndIf


Return(nSldAnt)
