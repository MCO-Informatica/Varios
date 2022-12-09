
#INCLUDE "RWMAKE.CH"
#include "protheus.ch"

//#DEFINE xRefresh  {|| Nil}
#DEFINE xRefresh  {|| SysRefresh(), ProcessMessages()}

#DEFINE cTodos  "SA1ALL"  // De->Para
#DEFINE cFinal  "SA1UNI"  // Final (CNPJ unico)

User Function RNV_JSA1
Local cDriver := "TOPCONN"
Local cSA1Ori := RetSqlName("SA1")
Local aTabs   := {cTodos, cFinal}
Local nLoop   := Nil
Local bBloco  := Nil

Local aStru     := Nil
Local aAddStru  := Nil
Local nLoop     := Nil

If Aviso("Unificação Clientes", "Alterar para SA1BKP?", {" Não ", " Sim "}) == 2
	cSA1Ori := "SA1BKP"
	SA1->(dbCloseArea())
	dbUseArea(.T., "TOPCONN", "SA1BKP", "SA1", .T., .F.)
Endif

For nLoop := 1 To Len(aTabs)
	If Select(aTabs[nLoop]) > 0
		(aTabs[nLoop])->(dbCloseArea())
	Endif
	If MsFile(aTabs[nLoop],, "TOPCONN")
		TCSQLExec("DROP TABLE " + aTabs[nLoop])
	Endif
Next

aStru := ModiStru(SA1->(dbStruct()), ;
                 {{"XX_FILIAL", "C", Len(SA1->A1_FILIAL), 0}, ;
                  {"XX_COD"   , "C", Len(SA1->A1_COD   ), 0}, ;
                  {"XX_LOJA"  , "C", Len(SA1->A1_LOJA  ), 0}, ;
                  {"A1_CGC"   , "C", Len(SA1->A1_CGC   ), 0}},, ;
                 {{"A1_CGC" }})

dbCreate(cTodos, aStru, "TOPCONN")
dbUseArea(.T., "TOPCONN", cTodos, cTodos, .T., .F.)

Index on A1_FILIAL + A1_COD + A1_LOJA  TO (cTodos + "1")
Index on A1_CGC                        TO (cTodos + "2")
dbClearIndex()
dbSetIndex(cTodos + "1")
dbSetIndex(cTodos + "2")

__dbApp(cSA1Ori , { },,,,,.F., cDriver )

dbEval({|| RecLock(cTodos, .F.), ;
           (cTodos)->XX_FILIAL := (cTodos)->A1_FILIAL  , ;
            MsUnLock()})

aStru := ModiStru(SA1->(dbStruct()), ;
                 {{"XX_FILIAL", "C", Len(SA1->A1_FILIAL), 0}, ;
                  {"A1_CGC"   , "C", Len(SA1->A1_CGC   ), 0}},, ;
                 {{"A1_CGC" }})

dbCreate(cFinal, aStru, "TOPCONN")
dbUseArea(.T., "TOPCONN", cFinal, cFinal, .T., .F.)

Index on A1_CGC TO (cFinal + "1")
dbClearIndex()
dbSetIndex(cFinal + "1")

For nLoop := 1 to 2
	If nLoop == 1
		bBloco := {||   LEFT(A1_FILIAL, 3) == "003"}
	Else
		bBloco := {|| ! LEFT(A1_FILIAL, 3) == "003"}
	Endif
	dbSelectArea(cTodos)
	dbGoTop()
	Do While ! Eof()
		If ! Eval(bBloco)
			dbSkip()
			Loop
		Endif
		If ! (cFinal)->(dbSeek((cTodos)->A1_CGC))
			RecLock(cFinal, .T.)
			dbTrans(cTodos, cFinal)
			(cFinal)->A1_COD    := StrZero( (cFinal)->(Recno()), Len( (cFinal)->A1_COD  ))
			(cFinal)->A1_LOJA   := StrZero(                   1, Len( (cFinal)->A1_LOJA ))
			(cFinal)->A1_FILIAL := ""
			MsUnlock()
		Endif
		dbSelectArea(cTodos)
		RecLock(cTodos, .F.)
		(cTodos)->XX_COD    := (cFinal)->A1_COD
		(cTodos)->XX_LOJA   := (cFinal)->A1_LOJA
		MsUnlock()
		dbSkip()
	Enddo
Next



Static Function dbTrans(cOrigem, cDestino, bUpdate)
Local nCount  := (cDestino)->(fCount())
Local nField  := Nil
Local nLoop   := Nil

For nLoop := 1 to nCount
	If (nField := (cOrigem)->(FieldPos((cDestino)->(FieldName(nLoop))))) > 0
		(cDestino)->(FieldPut(nLoop, (cOrigem)->(FieldGet(nField))))
	Endif
Next

If bUpdate # Nil
	Eval(bUpdate)
Endif

Return(.T.)

Static Function ModiStru(aStruOri, aAddStru, lAddFirst, aExclStru)
Local nLoop    := Nil
Local nScan    := Nil
Local aNewStru := Nil

Default lAddFirst := .T.

aNewStru := aClone(aStruOri)

If aExclStru <> Nil
	For nLoop := 1 to Len(aExclStru)
		If (nScan := aScan(aNewStru, {|z| z[1] == aExclStru[nLoop, 1]})) > 0
			aDel(aNewStru, nScan)
			aSize(aNewStru, Len(aNewStru) - 1)
		Endif
	Next
Endif

If lAddFirst
	For nLoop := Len(aAddStru) To 1 Step -1
		Aadd(aNewStru, Nil)
		Ains(aNewStru, 1)
		aNewStru[1] := aAddStru[nLoop]
	Next
Else
	For nLoop := 1 to Len(aAddStru)
		Aadd(aNewStru, aAddStru[nLoop])
	Next
Endif

Return(aClone(aNewStru))

/*
User Function ExAlias
Local nLoop     := Nil
Local cTab      := Nil
Local cQuery    := Nil
Local cAliasTop := "TRBSQL"
Local cTexto    := ""
Local aAlias    := {"AA3", "AA4", "AAH", "AAJ", "AAK", "AAM", "AB1", "AB2", "AB3", "AB4", "AB6", "AB7", "AB8", "ABA", "ABH", "ABK", "ACK", "ACO", "ACQ", "ACS",  ;
                    "ACW", "AD1", "AD5", "AD7", "AD8", "ADA", "ADC", "ADY", "AF1", "AF8", "AFP", "AGU", "AH1", "AHA", "AI1", "AI4", "B44", "BA0", "BA1", "BA3",  ;
                    "BG9", "BJM", "BJP", "BMP", "BQC", "BT5", "CA1", "CCX", "CD2", "CD3", "CDE", "CDL", "CF7", "CN9", "CNA", "CND", "CNY", "CTK", "DA7", "DAD",  ;
                    "DAF", "DAH", "DAJ", "DCK", "DE6", "DE7", "DEC", "DF1", "DI6", "DIG", "DIK", "DT4", "DT5", "DT6", "DTC", "DTE", "DTH", "DTI", "DU1", "DUB",  ;
                    "DUE", "DUL", "DUO", "DUU", "DV1", "DV2", "DV3", "DV5", "DV6", "DV7", "DVC", "DVD", "DVN", "DVO", "DVZ", "DW2", "DW3", "DW7", "DW8", "DWO",  ;
                    "DWZ", "EEQ", "EFA", "EG0", "EX6", "FRA", "FS5", "FSB", "FSC", "FSI", "FSL", "FSN", "FSR", "FTH", "FTN", "GA9", "GAH", "JC5", "JHP", "MAH",  ;
                    "MAS", "MAX", "MB1", "MBR", "MDD", "ME1", "MEN", "N01", "N04", "N05", "N0B", "N0E", "N43", "NNR", "NO1", "NPA", "NPD", "NPI", "NPK", "NPL",  ;
                    "NPO", "NPR", "NU8", "NU9", "NUA", "NUB", "NUC", "NUD", "NVS", "QF6", "QI2", "QI3", "QM2", "QMZ", "QQ4", "QQ7", "RE0", "SA1", "SA6", "SA7",  ;
                    "SAA", "SAB", "SAO", "SAR", "SC5", "SC6", "SCA", "SCB", "SCJ", "SCK", "SD2", "SD6", "SDH", "SE1", "SE3", "SE6", "SEF", "SEL", "SEM", "SEX",  ;
                    "SF2", "SF9", "SFM", "SFU", "SFX", "SJ3", "SK1", "SL1", "SLM", "SLQ", "SNM", "SNP", "SO5", "SO6", "SO8", "ST9", "SU3", "SU5", "SUS", "SV1",  ;
                    "SY5", "TLL", "TM0", "TMW", "TO0", "VA7", "VAR", "VCF", "VE6", "VIL", "VSA", "VZF"}

If Select(cAliasTop) > 0
	(cAliasTop)->(dbCloseArea())
Endif

For nLoop := 1 to Len(aAlias)
//	If MsFile(cTab := RetSqlName(aAlias[nLoop]),, "TOPCONN")
	If MsFile(cTab := aAlias[nLoop] + "000",, "TOPCONN")
		cQuery := " SELECT COUNT(*) QUANT FROM " + cTab
		cQuery := ChangeQuery(cQuery)

		dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop, .F., .T.)
		If (cAliasTop)->QUANT > 0
			cTexto += aAlias[nLoop] + Chr(13) + Chr(10)
		Endif
		(cAliasTop)->(dbCloseArea())
	Endif
Next

u_idlgtexto(ctexto)
*/


User Function ChgClie // U_ChgClie()
Local nSecIni     := Seconds()
Local lSimula     := Nil
Local lFinalizado := Nil
Local bBloco      := Nil

lSimula := iDlgChkBox("Troca de Clientes", "Apenas Simulado", .T., "Prosseguir")

bBloco  := {|oSay1, oSay2, oSay3, oRegua, oDlg| lFinalizado := U__ChgClie(lSimula, oSay1, oSay2, oSay3, oRegua, oDlg)}

iProcRegua(bBloco, "Trocando Códigos de Clientes")

Default lFinalizado := .F.

Aviso("Atualização de Clientes", "Processamento " + If(lFinalizado, "Finalizado!", "Abortado!") + Chr(13) + Chr(10) + ;
                                 "Tempo Total: " + iTString(Seconds() - nSecIni), {" Ok "})

User Function _ChgClie(lSimula, oSay1, oSay2, oSay3, oRegua, oDlg)
Local nSecMail   := Seconds()
Local lX2Unico   := Nil
Local cAlias     := Nil
Local cFile      := "\ChangeClie.txt"
Local nHandle    := Nil
Local lErro      := Nil
Local bBlocoClie := Nil
Local cX2Unico   := Nil
Local nLastRec   := Nil
Local nPosFili   := Nil
Local nPosClie   := Nil
Local nPosLoja   := Nil
Local aTroca     := Nil

Local nSecIni    := Nil
Local nQtdRecnos := Nil

Local aFields  := {{"AF8", "AF8_CLIENT", "AF8_LOJA"    }, ;
                   {"CD2", "CD2_CODCLI", "CD2_LOJCLI"  }, ;
                   {"CN9", "CN9_CLIENT", "CN9_LOJACL"  }, ;
                   {"CNA", "CNA_CLIENT", "CNA_LOJACL"  }, ;
                   {"CND", "CND_CLIENT", "CND_LOJACL"  }, ;
                   {"CTK", "CTK_CODCLI"                }, ;
                   {"NNR", "NNR_CODCLI", "NNR_LOJCLI"  }, ;
                   {"SA6", "A6_CODCLI" , "A6_LOJCLI"   }, ;
                   {"SC5", "C5_CLIENTE", "C5_LOJACLI"  , {|| C5_TIPO $ "CN"}}, ;
                   {"SC5", "C5_CLIENT" , "C5_LOJAENT"  , {|| C5_TIPO $ "CN"}}, ;
                   {"SC6", "C6_CLI"    , "C6_LOJA"     , {|| Posicione("SC5", 1, SC6->(C6_FILIAL + C6_NUM), "C5_TIPO") $ "CN"}}, ;
                   {"SC6", "C6_CODFAB" , "C6_LOJAFA"   , {|| Posicione("SC5", 1, SC6->(C6_FILIAL + C6_NUM), "C5_TIPO") $ "CN"}}, ;
                   {"SE1", "E1_CLIENTE", "E1_LOJA"     }, ;
                   {"SEF", "EF_CLIENTE", "EF_LOJACLI"  }, ;
                   {"SD2", "D2_CLIENTE", "D2_LOJA"     , {|| D2_TIPO $ "CN"         }}, ;
                   {"SD2", "D2_CODFAB" , "D2_LOJAFA"   , {|| D2_TIPO $ "CN"         }}, ;
                   {"SF2", "F2_CLIENTE", "F2_LOJA"     , {|| F2_TIPO $ "CN"         }}, ;
                   {"SFT", "FT_CLIEFOR", "FT_LOJA"     , {|| FT_TIPOMOV == "S" .And. (! FT_TIPO $ "BD") }}, ;
                   {"SF3", "F3_CLIEFOR", "F3_LOJA"     , {|| Left(F3_CFO, 1) >= "5" .And. (! F3_TIPO $ "BD")}}, ;
                   {"SE5", "E5_DOCUMEN",               , {|| E5_RECPAG = "R" .And. E5_TIPODOC $ "BA;CP"}, {|nHandle, lSimula| UpdDocum( nHandle, lSimula)}}, ;
                   {"SE1", "E1_TITPAI" ,               ,                                                , {|nHandle, lSimula| UpdTitPai(nHandle, lSimula)}}}

aEval(aFields, {|z,w| aSize(aFields[w], 5), aFields[w, 3] := If(aFields[w, 3] == Nil, "", z[3])})

Ferase(cFile)
oRegua:nTotal := 100

If ! lSimula
	If Aviso("Atualização de Clientes", "Confirma processamento na opção ATUALIZAR DADOS?", {" Não ", " Sim "}) <> 2
		Return(.F.)
	Endif
Else
	If (lX2Unico := Aviso("Atualização de Clientes", 'Deseja "Limpar" X2_UNICO?', {" Não ", " Sim "}) == 2)
		Aviso("Atualização de Clientes", 'Rodando apenas limpando X2_UNICO', {" Ok "})
	Else
		Aviso("Atualização de Clientes", "Rodando em modo SIMULAÇÃO sem ATUALIZAR DADOS?", {" Ok "})
	Endif
Endif

nHandle := If(File(cFile), fOpen(cFile, 1), Fcreate(cFile, 0))
fSeek(nHandle, 0, 2)

If lX2Unico
	oDlg:cCaption := "Limpando X2_UNICO"
	oSay1:SetText("Backup SX2 (SX2000_SA1BKP) no banco")
	Eval(xRefresh)
	dbSelectArea("SX2")
	dbSetOrder(1)
	dbGoTop()

	If MsFile("SX2000_SA1BKP",, "TOPCONN")
		TCSQLExec("DROP TABLE SX2000_SA1BKP")
	Endif
	aEval(Directory("\SX2000_SA1BKP.*"), {|z| Ferase("\" + z[1])})
	__dbCopy( "SX2000_SA1BKP",{},,,,,.F.,"TOPCONN")
	oSay1:SetText("Backup SX2 (SX2000_SA1BKP) no ProtheusData")
	Eval(xRefresh)
	__dbCopy("\SX2000_SA1BKP",{},,,,,.F.,"DBFCDX" )
	oSay1:SetText("Limpando X2_UNICO...")
	Fwrite(nHandle, "Local aX2Unico := {}" + Chr(13) + Chr(10))
Else
	oSay1:SetText(If(lSimula, "Simulando atualização", "Atualizando dados") + "...")
	Eval(xRefresh)
Endif

	For nLoop := 1 to Len(aFields)

		oRegua:Set(nLoop * 100 / Len(aFields))
		oSay2:SetText("Tabela " + aFields[nLoop, 1] + " (" + iDicX2(aFields[nLoop, 1]) + ")")
		Eval(xRefresh)

		If lX2Unico
			dbSelectArea("SX2")
			dbSetOrder(1)
			dbSeek(cAlias := Upper(Alltrim(aFields[nLoop, 1])))
			If (! Eof()) .And. ! Empty(SX2->X2_UNICO)
				cX2Unico := Alltrim(SX2->X2_UNICO)
				RecLock("SX2", .F.)
			//	SX2->X2_UNICO := ""
				MsUnlock("SX2")
				Fwrite(nHandle, 'Aadd(aX2Unico, {"' + cAlias + '", "' + cX2Unico + '"})' + Chr(13) + Chr(10))
			Endif
			Loop
		Endif

		dbSelectArea(cAlias := Upper(Alltrim(aFields[nLoop, 1])))
		dbSetOrder(0)

		SET FILTER TO &(" ! Empty(" + aFields[nLoop, 2] + ")")

		dbGoTop()

		nPosFili := FieldPos(iFldFilial(aFields[nLoop, 1]))
		nPosClie := FieldPos(           aFields[nLoop, 2])
		nPosLoja := FieldPos(           aFields[nLoop, 3])

		If nPosFili == 0 .Or. ;
           nPosClie == 0
			Loop
		Endif

		If Len(aFields[nLoop]) > 3
			bBlocoClie := aFields[nLoop, 4]
		Else
			bBlocoClie := Nil
		Endif

		nLastRec   := LastRec()
		nSecIni    := Seconds()
		nQtdRecnos := 0

		Do While ! Eof()
			iProgress(oSay3, Alltrim(Str(Recno() * 100 / nLastRec, 12, 0)) + " %")

            lErro := .F.

			If ! (bBlocoClie == Nil .Or. Eval(bBlocoClie))
				dbSkip()
				Loop
			Endif

			/*
			If Empty(FieldGet(nPosClie))
			//	Fwrite(nHandle, "Campo " + FieldName(nPosClie) + " nao preenchido" + Chr(13) + Chr(10))
				dbSkip()
				Loop
			Endif
			*/

			If aFields[nLoop, 5] <> Nil
				Eval(aFields[nLoop, 5], nHandle, lSimula)
				nQtdRecnos ++
				dbSkip()
				Loop
			Endif

			aTroca := NewCodClie(aFields[nLoop, 1] , ;
                                 FieldGet(nPosFili), ;
                                 FieldGet(nPosClie), ;
                                 If(nPosLoja > 0, ;
                                 FieldGet(nPosLoja), ;
                                 Nil))

			If aTroca == Nil
				Fwrite(nHandle, "Cliente nao encontrado " + ;
                                aFields[nLoop, 2] + " " + FieldGet(nPosClie) + Chr(13) + Chr(10))
				dbSkip()
				Loop
			Endif

			If nPosLoja > 0 .And. Empty(FieldGet(nPosLoja))
				Fwrite(nHandle, "Loja sem preenchimento" + Chr(13) + Chr(10))
				dbSkip()
				Loop
			Endif

			If ! lSimula
				RecLock(cAlias)
				FieldPut(nPosClie, aTroca[ 1])
				If nPosLoja > 0
					FieldPut(nPosLoja, aTroca[ 2])
				Endif
				MsUnlock()
/*
			Else
				Fwrite(nHandle, "Trocando " +  FieldName(nPosClie) + " de: " + FieldGet(nPosClie) + " por: " + aTroca[ 1] + " / " + ;
				                               FieldName(nPosLoja) + " de: " + FieldGet(nPosLoja) + " por: " + aTroca[ 2] + Chr(13) + Chr(10))
*/
			Endif
			nQtdRecnos ++
			dbSkip()

		Enddo

		SET FILTER TO

		TcSQLExec("COMMIT")  // If TcGetDB() $ "ORACLE"

		Fwrite(nHandle, aFields[nLoop, 1] + Chr(9) + iTString(Seconds() - nSecIni) + Chr(9) + ;
                        Alltrim(Str(nLastRec)) + Chr(9) + Alltrim(Str(nQtdRecnos)) + Chr(13) + Chr(10))

	Next

fClose(nHandle)

Ferase("C:" + cFile)
CpyS2T(cFile, "C:\LOG")

//cChgClie += "Arquivo gravado em C:\" + Chr(13) + Chr(10)

/*
oSay1:SetText("Enviando E-Mail")
oSay2:SetText("")
oSay3:SetText("")
Eval(xRefresh)

//U_iSndMail("Fim processamento", "marcelo@iuspa.com.br", "Fim do processamento " + Time())
U_iSndMail("Fim processamento", "marcelo@iuspa.com.br", "Finalizado " + Time() + " - Tempo Total: " + iTString(Seconds() - nSecMail),, cFile)
*/

Return(.T.)

Static Function UpdDocum(nHandle, lSimula)
Local aTroca   := Nil
Local cNewDoc  := Nil
Local cClie    := Nil
Local cLoja    := Nil
Local nLenCli  := Len(SA1->A1_COD)
Local nLenLoja := Len(SA1->A1_LOJA)

If Len(Alltrim(SE5->E5_DOCUMEN)) <> 26
	FWrite(nHandle, "E5_DOCUMEN com tamanho diferente de 26" + Chr(13) + Chr(10))
	Return
Endif

cClie := Right(Alltrim(SE5->E5_DOCUMEN), nLenCli + nLenLoja)
cLoja := Right(cClie, nLenLoja)
cClie := Left( cClie, nLenCli )

aTroca  := NewCodClie("SE5", SE5->E5_FILIAL, cClie, cLoja)
cClie   := aTroca[1]
cLoja   := aTroca[2]

cNewDoc := Left(Alltrim(SE5->E5_DOCUMEN), Len(Alltrim(SE5->E5_DOCUMEN)) - (nLenCli + nLenLoja)) + cClie + cLoja

If lSimula
	FWrite(nHandle, "E5_DOCUMEN (a): " + SE5->E5_DOCUMEN + Chr(13) + Chr(10) + ;
                    "E5_DOCUMEN (d): " + cNewDoc         + Chr(13) + Chr(10))
Else
	RecLock("SE5", .F.)
	SE5->E5_DOCUMEN := cNewDoc
	MsUnlock()
Endif
Return

Static Function UpdTitPai(nHandle, lSimula)
/* E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA */
Local nPosClie    := Len(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)) + 1
Local cNewTitPai  := Nil
Local cClie       := Nil
Local cLoja       := Nil
Local nLenCli     := Len(SA1->A1_COD)
Local nLenLoja    := Len(SA1->A1_LOJA)

If Len(Alltrim(SE1->E1_TITPAI)) <> Len(SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))
	FWrite(nHandle, "Erro Tamanho E1_TITPAI recno # " + Alltrim(Str(SE1->(Recno()))) + Chr(13) + Chr(10))
	Return
Endif

cClie := Right(Alltrim(SE1->E1_TITPAI), nLenCli + nLenLoja)
cLoja := Right(cClie, nLenLoja)
cClie := Left( cClie, nLenCli )

aTroca  := NewCodClie("SE1", SE1->E1_FILIAL, cClie, cLoja)
cClie   := aTroca[1]
cLoja   := aTroca[2]

cNewTitPai := Left(SE1->E1_TITPAI, nPosClie - 1) + cClie + cLoja

If lSimula
	Fwrite(nHandle, "E1_TITPAI (a): " + SE1->E1_TITPAI + Chr(13) + Chr(10) + ;
                    "E1_TITPAI (d): " + cNewTitPai     + Chr(13) + Chr(10))
Else
	RecLock("SE1", .F.)
	SE1->E1_TITPAI := cNewTitPai	
	MsUnlock()
Endif
Return

Static Function NewCodClie(cAlias, cCodFil, cCodigo, cLoja)
Static aCods    := Nil
Local aSavAre   := Nil
Local cAliasTop := "TRBNEXT"
Local cQuery    := Nil
Local nScan     := Nil
Local aCodLoja  := Nil

If aCods == Nil
	aSavAre   := GetArea()
	aCods := {}

	cQuery := " SELECT A1_FILIAL, A1_COD, A1_LOJA, XX_COD, XX_LOJA, A1_CGC, A1_NOME FROM " + cTodos

	cQuery := ChangeQuery(cQuery)

	If Select(cAliasTop) > 0
		(cAliasTop)->(dbCloseArea())
	Endif

	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cAliasTop, .F., .T.)

	Do While ! Eof()
		Aadd(aCods, {A1_FILIAL, A1_COD, A1_LOJA, XX_COD, XX_LOJA, A1_CGC, A1_NOME})
		dbSkip()
	Enddo

	(cAliasTop)->(dbCloseArea())

	RestArea(aSavAre)
Endif

cCodFil := Pad(cCodFil, Len(Alltrim(xFilial("SA1"))))
cCodFil := Pad(cCodFil, Len(aCods[1, 1]))

If (nScan := aScan(aCods, {|z| z[1] == cCodFil .And. z[2] == cCodigo .And. (z[3] == Nil .Or. z[3] == cLoja)})) > 0
	aCodLoja := {aCods[nScan, 4], aCods[nScan, 5]}
Endif

/*
If Aviso("Unificação Clientes", "Continua?", {" Não ", " Sim "}) <> 2
	Final(time())
Endif
*/

Return(aCodLoja)


Static Function iProcRegua(bBloco, cTitulo, cMsg1, cMsg2)
Local oDlg
Local oSay1
Local nRegua := 0

Default cTitulo := "Aguarde o Processamento"
Default cMsg1   := ""
Default cMsg2   := ""

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to 110,340 PIXEL

@ 10,  10 Say oSay1 Prompt cMsg1  SIZE 150,07 OF oDlg PIXEL
@ 22,  10 Say oSay2 Prompt cMsg2  SIZE 150,07 OF oDlg PIXEL
@ 47, 110 Say oSay3 Prompt cMsg2  SIZE  50,07 OF oDlg PIXEL RIGHT // 110

@ 35,010 METER oRegua VAR nRegua TOTAL 100 SIZE 150,8 OF oDlg NOPERCENTAGE PIXEL

ACTIVATE MSDIALOG oDlg CENTERED ;
ON INIT (Eval(bBloco, oSay1, oSay2, oSay3, oRegua, oDlg), oDlg:End())  // bStart bInit

Static Function iDlgChkBox(cTitulo, cCheckBox, lCheckBox, cTextoBotao)
Local oDlg           := Nil
Local nLineButton    := Nil
Local nColButton     := Nil
Local nSpaceButton   := 2

Local nWidthButton   :=  42
Local nDlgWidth      := 380
Local nDlgHeight     := 120

Local oChkBox        := Nil

Default lCheckBox    := .F.
Default cTextoBotao  := "Fecha"

DEFINE MSDIALOG oDlg TITLE cTitulo From 0,0 to nDlgHeight, nDlgWidth  PIXEL

nLineButton := __DlgHeight(oDlg) - 24
nColButton  := __DlgWidth( oDlg) -  4

@ nLineButton - 25, 10 CheckBox oChkBox Var  lCheckBox Prompt cCheckBox Message cCheckBox Size 140, 007 Pixel Of oDlg

TButton():New(nLineButton    , nColButton - (1 * (nWidthButton + nSpaceButton)), cTextoBotao, oDlg,{|| oDlg:End()}                                                                                  ,nWidthButton,10,,oDlg:oFont,.F.,.T.,.F.,,.F.,,,.F.)

ACTIVATE MSDIALOG oDlg CENTERED

Return(lCheckBox)




Static Function iProgress(oSay, cStatus)
Static nProgress := 300
Static cRet      := "\"

Default cStatus := ""

If nProgress >= 300
	nProgress := 0
	cRet := If(cRet == "\", "/", "\")
	oSay:SetText(cStatus + cRet)
	Eval(xRefresh)
Endif

nProgress ++

Return(.T.)

Static Function iFldFilial(cAlias)
Local cFldFilial := Upper(Alltrim(cAlias)) + "_FILIAL"

If Left(cFldFilial, 1) == "S"
	cFldFilial := Substr(cFldFilial, 2)
Endif

Return(cFldFilial)


Static Function iDicX2(cAlias)
Static aSX2 := Nil
Local aSavAre := Nil
Local nScan   := Nil
Local cRet    := ""

If aSX2 == Nil
	aSavAre := {SX2->(GetArea()), GetArea()}
	aSX2    := {}
	dbSelectArea("SX2")
	dbGoTop()
	Do While ! Eof()
		Aadd(aSX2, {Upper(SX2->X2_CHAVE), AllTrim(SX2->X2_NOME), SX2->X2_ARQUIVO})
		dbSkip()
	Enddo
	RestArea(aSavAre[1])
	RestArea(aSavAre[2])
Endif

If (nScan := aScan(aSX2, {|z| z[1] == cAlias})) > 0
	cRet := aSX2[nScan, 2]
Endif

Return(cRet)


Static Function iTString(cl_secs)
Return strzero( int(mod(cl_secs/3600, 24)), 2, 0 ) +':'+;
     strzero( int(mod(cl_secs/  60, 60)), 2, 0 ) +':'+;
     strzero( int(mod(cl_secs     , 60)), 2, 0 )
