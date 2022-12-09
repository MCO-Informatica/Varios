
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"


User Function RNV_DSA2  // U_RNV_DSA2()
ProcRegua({|oSay1, oSay2, oSay3, oRegua, oDlg| U__RNV_DSA2(oSay1, oSay2, oSay3, oRegua, oDlg)}, "Consultando CGCs duplicados em Fornecedores")


User Function _RNV_DSA2(oSay1, oSay2, oSay3, oRegua, oDlg)
Local cAliasTop := "TRBXXANT"
Local aTabelas  := {}
Local nLoop     := Nil
Local cDups     := ""
Local cFile     := "SA2_DUPL.CSV"
Local cPathOri  := "\"
Local cPathDes  := "C:\"
Local nHandle   := Nil
Local cEnter    := Chr(13) + Chr(10)

nHandle := Fcreate(cPathOri + cFile, 0)

fWrite(nHandle, "EMPRESA;CGC;CODIGO;LOJA;NOME" + cEnter)

oSay1:SetText("Identificando tabelas fornecedores")
SysRefresh()
ProcessMessages()

dbUseArea( .T., "TOPCONN","TOP_FILES", cAliasTop)

Do While ! Eof()
	cTabela := Alltrim(Upper((cAliasTop)->FNAMF1))
	If Left(cTabela, 3) == "SA2" .And. Right(cTabela, 1) == "0" .And. Len(cTabela) == 6
		Aadd(aTabelas, cTabela)
	Endif
	dbSkip()
Enddo

(cAliasTop)->(dbCloseArea())

oRegua:nTotal := 100

For nLoop := 1 to Len(aTabelas)
	oRegua:Set(nLoop * 100 / Len(aTabelas))
	oSay1:SetText("Lendo Tabela " + aTabelas[nLoop])
	SysRefresh()
	ProcessMessages()

	cDups := ""
	cQuery := " SELECT A2_CGC FROM " + aTabelas[nLoop] + " WHERE D_E_L_E_T_ <> '*' AND A2_CGC <> ' ' AND A2_CGC NOT LIKE '000000%' GROUP BY A2_CGC HAVING COUNT(*) > 1 "
	dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop)
	Do While ! Eof()
		cDups += ",'" + (cAliasTop)->A2_CGC + "'"
		dbSkip()
	Enddo
	(cAliasTop)->(dbCloseArea())

	If Len(cDups) > 1
		cQuery := " SELECT '" + Substr(aTabelas[nLoop], 4, 2) + "' EMPRESA, A2_CGC, A2_COD, A2_LOJA, A2_NOME FROM " + ;
		aTabelas[nLoop] + " WHERE D_E_L_E_T_ <> '*' AND A2_CGC IN (" + Substr(cDups, 2) + ") "
		dbUseArea( .T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop)
		Do While ! Eof()
			fWrite(nHandle, '="' + (cAliasTop)->EMPRESA + '";="' + (cAliasTop)->A2_CGC + '";="' + (cAliasTop)->A2_COD + '";="' + (cAliasTop)->A2_LOJA + '";="' + Alltrim((cAliasTop)->A2_NOME) + '"' + cEnter)
			dbSkip()
		Enddo
		(cAliasTop)->(dbCloseArea())
	Endif
Next

fClose(nHandle)
Ferase(cPathDes + cFile)
CpyS2T(cPathOri + cFile, cPathDes)
Alert("Copiado para " + cPathDes + cFile)


Static Function ProcRegua(bBloco, cTitulo, cMsg1, cMsg2)
Local oDlg
Local oSay1
Local nRegua := 0

Default cTitulo := "Aguarde o Processamento"
Default cMsg1   := ""
Default cMsg2   := ""

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 110,340 PIXEL

@ 10,  10 Say oSay1 Prompt cMsg1  SIZE 150,10 OF oDlg PIXEL
@ 22,  10 Say oSay2 Prompt cMsg2  SIZE 150,10 OF oDlg PIXEL
@ 47, 130 Say oSay3 Prompt cMsg2  SIZE  80,10 OF oDlg PIXEL

@ 35,010 METER oRegua VAR nRegua TOTAL 100 SIZE 150,8 OF oDlg NOPERCENTAGE PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ;
ON INIT (Eval(bBloco, oSay1, oSay2, oSay3, oRegua, oDlg), oDlg:End())  // bStart bInit


