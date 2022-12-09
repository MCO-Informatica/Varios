#include "rwmake.ch"
#include "topconn.ch"
#include "protheus.ch"

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CFMFATMET  | Autor: Celso Ferrone Martins | Data: 04/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Meta de Faturamento                                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
User Function CFMFATMET()

Local cPerg := "CFMFATMET"

SX1->(dbSetOrder(1))

PutSX1(cPerg,"01","Data Inicial ","","","MV_CH1","D",08,0,0,"G","",""   ,"","","MV_PAR01","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"02","Data Final   ","","","MV_CH2","D",08,0,0,"G","",""   ,"","","MV_PAR02","","","","","","","","","","","","","","","","","","","")
PutSX1(cPerg,"03","Meta         ","","","MV_CH3","N",14,2,0,"G","",""   ,"","","MV_PAR03","","","","","","","","","","","","","","","","","","","")


If Pergunte(cPerg,.T.)
	Processa( {|| Imprime2()}, "Processando Dados..." )
EndIf

Return


/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: Imprime    | Autor: Celso Ferrone Martins | Data: 04/12/2014 |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao | Meta de Faturamento                                        |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/
Static Function Imprime()

Local cQuery := "  "
Local cIpLocal := StrTran(GetClientIp(),".","")
Local cNomeTmp := "TMP" + __cUserId + cIpLocal
Local aResult  := {}

cQuery := "DROP TABLE " + cNomeTmp 
MsAguarde({ | | TcSqlExec(cQuery) },"Por favor aguarde","Exec. Procedure...")


//cQuery := "EXEC SP_DADOS_FATURAMENTO('20150101','20150131',80000000,'TMPALVES')"
//MsAguarde({ | | TcSqlExec(cQuery) },"Por favor aguarde","Exec. Procedure...")

/*
cQuery := " SP_DADOS_FATURAMENTO( " 
cQuery += " '"+dTos(MV_PAR01)+"', " 
cQuery += " '"+dTos(MV_PAR02)+"', " 
cQuery += " "+AllTrim(Str(MV_PAR03))+", " 
cQuery += " '" + cNomeTmp + "'  ) " 
*/
aResult := TCSPExec(xProcedures("SP_DADOS_FATURAMENTO"),dTos(MV_PAR01),dTos(MV_PAR02),AllTrim(Str(MV_PAR03)),cNomeTmp)
//aResult := TCSPExec(xProcedures("SP_DADOS_FATURAMENTO"),'20150101','20150131',80000000,cNomeTmp)

/*
If Empty(aResult)
	cProcErr := TCSQLError()
	MsgStop("TCSQLError() " + cProcErr)
	
	nSbsErr := 1
	For nCnt := 1 To ( nPos := MlCount(cProcErr,100) )
		If nCnt < nPos
			cDescErr += Substr( cProcErr, nSbsErr, 100 ) + CRLF
		Else
			cDescErr += Substr( cProcErr, nSbsErr, Len(cProcErr) - nSbsErr + 1 )
		EndIf
		
		nSbsErr += 100
	Next nCnt
	
	aAdd( aErrProc[2], "TCSQLError() " + cDescErr )
	lGerouSRZ := .F.
EndIf
*/




cQuery := "SELECT * FROM " + cNomeTmp
/*
cQuery += " SELECT "
cQuery += "    SUM(D2_TOTAL) AS D2_TOTAL, "
cQuery += "    D2_EMISSAO, "
cQuery += "    FN_CALCULA_META_MES("+AllTrim(Str(MV_PAR03))+", SUBSTR(D2_EMISSAO,5,2), SUBSTR('"+dTos(MV_PAR01)+"',0,4)) AS META_MES "
cQuery += " FROM "+RetSqlName("SF2")+" SF2 "
cQuery += "     INNER JOIN "+RetSqlName("SD2")+" SD2 ON "
cQuery += "        SD2.D_E_L_E_T_ <> '*' "
cQuery += "        AND D2_FILIAL = '"+xFilial("SD2")+"' "
cQuery += "        AND D2_DOC   = F2_DOC "
cQuery += "        AND D2_SERIE = F2_SERIE "
cQuery += "     INNER JOIN "+RetSqlName("SF4")+" SF4 ON "
cQuery += "        SF4.D_E_L_E_T_ <> '*' "
cQuery += "        AND F4_FILIAL = '"+xFilial("SF4")+"' "
cQuery += "        AND F4_CODIGO = D2_TES "
cQuery += "        AND F4_DUPLIC = 'S' "
cQuery += " WHERE "
cQuery += "    SF2.D_E_L_E_T_ <> '*' "
cQuery += "    AND F2_FILIAL = '"+xFilial("SF2")+"' "
cQuery += "    AND F2_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
cQuery += "    AND F2_TIPO = 'N' "
cQuery += " GROUP BY D2_EMISSAO, FN_CALCULA_META_MES("+AllTrim(Str(MV_PAR03))+", SUBSTR(D2_EMISSAO,5,2), SUBSTR('"+dTos(MV_PAR01)+"',0,4)) "
cQuery += " ORDER BY D2_EMISSAO ASC "
*/
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

IncProc()

//TcQuery cQuery New Alias "TRB"

/*
// Cria arquivo temporario
aAdd(aStru,	{"DIAS"       ,"D",08,0} )
aAdd(aStru,	{"FATURAMENT" ,"N",18,2} )
aAdd(aStru,	{"ACUMULADO"  ,"N",18,2} )
aAdd(aStru,	{"DIFERENCA"  ,"N",18,2} )
aAdd(aStru,	{"REALIZADO"  ,"N",18,2} )
aAdd(aStru,	{"POR_RATA"   ,"N",18,2} )

If Select("TEMP") > 0
	TEMP->(DbCloseArea())
EndIf

cArquivo := CriaTrab(aStru)
dbUseArea(.T.,, cArquivo, "TEMP", .F., .F.)

While !TRB->(Eof())
	IncProc()
	RecLock("TEMP",.T.)
	TEMP->DIAS       := sTod(TRB->D2_EMISSAO)
	TEMP->FATURAMENT := TRB->META_MES
	TEMP->ACUMULADO  := 0
	TEMP->DIFERENCA  := 0
	TEMP->REALIZADO  := TRB->D2_TOTAL
	TEMP->POR_RATA   := 0
	TEMP->(MsUnLock())
	
	TRB->(DbSkip())
Enddo
*/
If Select("TRB") > 0
	TRB->(DbCloseArea())
EndIf

If Select("TEMP") > 0
	TEMP->(DbCloseArea())
EndIf

/*
__CopyFIle(cArquivo+".DBF" , AllTrim(GetTempPath())+cArquivo+".XLS")
If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado')
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+cArquivo+".XLS") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
EndIf
*/
Return()




Static Function Imprime2()

Local cEof       := Chr(13) + Chr(10)
Local dDiaIni    := MV_PAR01
Local dDiaFin    := MV_PAR02
Local nDMesUteis := 0
Local nDAnoUteis := 0
Local aFeriados  := {}
Local dFeriado   := cTod("")
Local nPos       := 0
Local aMetasAno  := {}
Local aFatDiario := {}

If Year(MV_PAR01) != Year(MV_PAR02)
	MsgAlert("Ano nao pode ser dirente entre data inicial e data final","Atencao!!!")
	Return()
EndIf

DbSelectArea("SX5") ; DbSetOrder(1)
SX5->(DbSeek(xFilial("SX5")+"63"))
While !SX5->(Eof()) .And. SX5->(X5_FILIAL+X5_TABELA) == xFilial("SX5")+"63"
	If Len(AllTrim(SubStr(X5_DESCRI,1,8))) == 8
	   	dFeriado := cTod(AllTrim(SubStr(X5_DESCRI,1,8)))
	Else
	   	dFeriado := cTod(AllTrim(SubStr(X5_DESCRI,1,5))+"/"+AllTrim(Str(Year(MV_PAR01))))
	EndIf
	Aadd(aFeriados,dFeriado)
	SX5->(DbSkip())
EndDo

dDiaIni := cTod("01/01/"+AllTrim(Str(Year(MV_PAR01))))
dDiaFin := cTod("31/12/"+AllTrim(Str(Year(MV_PAR01))))
 
cMesAtu := ""
While dDiaIni <= dDiaFin
	If !AllTrim(Str(Dow(dDiaIni))) $ "1/7"
		nPos := aScan(aFeriados,{|x| x == dDiaIni })
		If nPos == 0
			if cMesAtu != cMonth(dDiaIni)  
				cMesAtu := cMonth(dDiaIni)
				Aadd(aMetasAno,{cMesAtu,1,0,0})
			Else
				nPos := aScan(aMetasAno,{|x| AllTrim(x[1]) == cMesAtu })
				aMetasAno[nPos][2] ++
			EndIf
			nDAnoUteis ++
		EndIf
	EndIf
	dDiaIni ++
EndDo

For nX := 1 To Len(aMetasAno)
	aMetasAno[nX][3] := nDAnoUteis
	aMetasAno[nX][4] := (MV_PAR03/nDAnoUteis)*aMetasAno[nX][2]
Next nX

cQuery := " SELECT " 
cQuery += "    D2_EMISSAO, " 
cQuery += "    SUM(D2_TOTAL) AS D2_TOTAL "
cQuery += " FROM " + RetSqlName("SF2") + " SF2 " 
cQuery += "    INNER JOIN " + RetSqlName("SD2") + " SD2 ON " 
cQuery += "       SD2.D_E_L_E_T_ <> '*' "  
cQuery += "       AND D2_DOC     = F2_DOC " 
cQuery += "       AND D2_SERIE   = F2_SERIE "
cQuery += "    INNER JOIN " + RetSqlName("SF4") + " SF4 ON " 
cQuery += "       SF4.D_E_L_E_T_ <> '*' "
cQuery += "       AND F4_CODIGO = D2_TES " 
cQuery += "       AND F4_DUPLIC = 'S' "
cQuery += " WHERE "
cQuery += "    SF2.D_E_L_E_T_ <> '*' "
cQuery += "    AND F2_TIPO = 'N' "
cQuery += "    AND F2_EMISSAO BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
cQuery += " GROUP BY D2_EMISSAO "
cQuery += " ORDER BY D2_EMISSAO "

If Select("TRBSD2") > 0
	TRBSD2->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSD2"

While !TRBSD2->(Eof())

	nPos := aScan(aFatDiario,{|x| x[1] == sTod(TRBSD2->D2_EMISSAO) })
	If nPos == 0
		aAdd(aFatDiario,{sTod(TRBSD2->D2_EMISSAO),TRBSD2->D2_TOTAL,0,0,0,0,0,0})
	Else
		aFatDiario[nPos][2] += TRBSD2->D2_TOTAL
	EndIf

	TRBSD2->(DbSkip())
EndDo

If Select("TRBSD2") > 0
	TRBSD2->(DbCloseArea())
EndIf


cQuery := " SELECT " 
cQuery += "    D1_DTDIGIT, " 
cQuery += "    SUM(D1_TOTAL) AS D1_TOTAL "
cQuery += " FROM " + RetSqlName("SF1") + " SF1 " 
cQuery += "    INNER JOIN " + RetSqlName("SD1") + " SD1 ON " 
cQuery += "       SD1.D_E_L_E_T_ <> '*' "  
cQuery += "       AND D1_DOC     = F1_DOC " 
cQuery += "       AND D1_SERIE   = F1_SERIE "
cQuery += "       AND D1_FORNECE = F1_FORNECE " 
cQuery += "       AND D1_LOJA    = F1_LOJA "
cQuery += "    INNER JOIN " + RetSqlName("SF4") + " SF4 ON " 
cQuery += "       SF4.D_E_L_E_T_ <> '*' "
cQuery += "       AND F4_CODIGO = D1_TES " 
cQuery += "       AND F4_DUPLIC = 'S' "
cQuery += " WHERE "
cQuery += "    SF1.D_E_L_E_T_ <> '*' "
cQuery += "    AND F1_TIPO = 'D' "
cQuery += "    AND D1_DTDIGIT BETWEEN '"+dTos(MV_PAR01)+"' AND '"+dTos(MV_PAR02)+"' "
cQuery += " GROUP BY D1_DTDIGIT "
cQuery += " ORDER BY D1_DTDIGIT "

If Select("TRBSD1") > 0
	TRBSD1->(DbCloseArea())
EndIf

TcQuery cQuery New Alias "TRBSD1"

While !TRBSD1->(Eof())

	nPos := aScan(aFatDiario,{|x| x[1] == sTod(TRBSD1->D1_DTDIGIT) })
	If nPos == 0
		aAdd(aFatDiario,{sTod(TRBSD1->D1_DTDIGIT),0,TRBSD1->D1_TOTAL,0,0,0,0,0})
	Else
		aFatDiario[nPos][3] += TRBSD1->D1_TOTAL
	EndIf

	TRBSD1->(DbSkip())
EndDo

If Select("TRBSD1") > 0
	TRBSD1->(DbCloseArea())
EndIf

// 01 - DATA
// 02 - VENDA
// 03 - DEVOLUCAO
// 04 - ACUMULADO
// 05 - DIFERENCA
// 06 - REALIZADO
// 07 - PRO RATA

nAcumul := 0
For nX := 1 To Len(aFatDiario)

	nAcumul += (aFatDiario[nX][2]-aFatDiario[nX][3])
	aFatDiario[nX][4] := nAcumul
	
	nPos := aScan(aMetasAno,{|x| AllTrim(x[1]) == AllTrim(cMonth(aFatDiario[nX][1])) })
	If nPos != 0
		aFatDiario[nX][5] := aMetasAno[nPos][4] - aFatDiario[nX][4]
		aFatDiario[nX][6] := (((aFatDiario[nX][5]/aMetasAno[nPos][4])*100)-100)*-1 
		aFatDiario[nX][7] := ((aMetasAno[nPos][4]/aMetasAno[nPos][2])*nX)/aMetasAno[nPos][4]*100
	EndIf
Next Nx

aStru := {}
aAdd(aStru,	{"DIAS"       ,"D",08,0} )
aAdd(aStru,	{"FATURAMENT" ,"N",18,2} )
aAdd(aStru,	{"ACUMULADO"  ,"N",18,2} )
aAdd(aStru,	{"DIFERENCA"  ,"N",18,2} )
aAdd(aStru,	{"REALIZADO"  ,"N",18,2} )
aAdd(aStru,	{"POR_RATA"   ,"N",18,2} )

If Select("TEMP") > 0
	TEMP->(DbCloseArea())
EndIf

cArquivo := CriaTrab(aStru)
dbUseArea(.T.,, cArquivo, "TEMP", .F., .F.)

For nX := 1 To Len(aFatDiario)
	RecLock("TEMP",.T.)
	TEMP->DIAS       := aFatDiario[nX][1]
	TEMP->FATURAMENT := aFatDiario[nX][2]-aFatDiario[nX][3]
	TEMP->ACUMULADO  := aFatDiario[nX][4]
	TEMP->DIFERENCA  := aFatDiario[nX][5]
	TEMP->REALIZADO  := aFatDiario[nX][6]
	TEMP->POR_RATA   := aFatDiario[nX][7]
	TEMP->(MsUnLock())
// 01 - DATA
// 02 - VENDA
// 03 - DEVOLUCAO
// 04 - ACUMULADO
// 05 - DIFERENCA
// 06 - REALIZADO
// 07 - PRO RATA
Next nX

If Select("TEMP") > 0
	TEMP->(DbCloseArea())
EndIf

__CopyFIle(cArquivo+".DBF" , AllTrim(GetTempPath())+cArquivo+".XLS")
If ! ApOleClient( 'MsExcel' )
	MsgStop( 'MsExcel nao instalado')
Else
	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+cArquivo+".XLS") // Abre uma planilha
	oExcelApp:SetVisible(.T.)
EndIf

Return()