#Include "Protheus.Ch"
#Include "TopConn.Ch"

User Function CfmEstoque()

Local aParamBox	:= {}
Local aRet		:= {}
Local aProdutos := {}
Local cEof      := Chr(13)+Chr(10)

aAdd(aParamBox,{1,"Produto"           ,Space(TamSX3("B1_COD")[1]),PesqPict("SB1","B1_COD") ,"","SB1","",TamSX3("B1_COD" )[1]+40,.T.})
aAdd(aParamBox,{1,"Data do Fechamento",GetMv("MV_ULMES")         ,PesqPict("SB9","B9_DATA"),"",""   ,"",TamSX3("B9_DATA")[1]+40,.T.})

If ParamBox(aParamBox,"Relatorio de Estoque",@aRet)
	
	cQuery := ""
	
	If !Empty(aRet[2])
		
		cQuery += " SELECT                                     " + cEof
		cQuery += "    'SB9'      ORIGEM,                      " + cEof
		cQuery += "    B1_COD     PRODUTO,                     " + cEof
		cQuery += "    B1_VQ_MP   MTPRIMA,                     " + cEof
		cQuery += "    B1_DESC    DESCRI,                      " + cEof
		cQuery += "    B1_TIPO    TIPO,                        " + cEof
		cQuery += "    B9_DATA    DATA,                        " + cEof
		cQuery += "    B9_LOCAL   LOCAL,                       " + cEof
		cQuery += "    BK_LOCALIZ LOCALIZ,                     " + cEof
		cQuery += "    BJ_LOTECTL LOTECTL,                     " + cEof
		cQuery += "    BJ_QINI    QTDE                         " + cEof
		cQuery += " FROM "+RetSqlName("SB1")+" SB1             " + cEof
		cQuery += "    INNER JOIN "+RetSqlName("SB9")+" SB9 ON " + cEof
		cQuery += "       SB9.D_E_L_E_T_ <> '*'                " + cEof
		cQuery += "       AND B9_FILIAL = '"+xFilial("SB9")+"' " + cEof
		cQuery += "       AND B9_DATA   = '"+dTos(aRet[2])+"'  " + cEof
		cQuery += "       AND B9_COD    = B1_COD               " + cEof
		cQuery += "    INNER JOIN "+RetSqlName("SBK")+" SBK ON " + cEof
		cQuery += "       SBK.D_E_L_E_T_ <> '*'                " + cEof
		cQuery += "       AND BK_FILIAL  = '"+xFilial("SBK")+"'" + cEof
		cQuery += "       AND BK_COD     = B9_COD              " + cEof
		cQuery += "       AND BK_LOCAL   = B9_LOCAL            " + cEof
		cQuery += "       AND BK_DATA    = B9_DATA             " + cEof
		cQuery += "    INNER JOIN "+RetSqlName("SBJ")+" SBJ ON " + cEof
		cQuery += "       SBJ.D_E_L_E_T_ <> '*'                " + cEof
		cQuery += "       AND BJ_FILIAL  = '"+xFilial("SBJ")+"'" + cEof
		cQuery += "       AND BJ_COD     = BK_COD              " + cEof
		cQuery += "       AND BJ_LOCAL   = BK_LOCAL            " + cEof
		cQuery += "       AND BJ_DATA    = BK_DATA             " + cEof
		cQuery += "       AND BJ_LOTECTL = BK_LOTECTL          " + cEof
		cQuery += " WHERE                                      " + cEof
		cQuery += "    SB1.D_E_L_E_T_ <> '*'                   " + cEof
		cQuery += "    AND B1_FILIAL  = '"+xFilial("SB1")+"'   " + cEof
		If !Empty(aRet[1])
			cQuery += "    AND (                                   " + cEof
			cQuery += "          B1_COD   = '"+aRet[1]+"'          " + cEof
			cQuery += "       OR B1_VQ_MP = '"+aRet[1]+"'          " + cEof
			cQuery += "        )                                       " + cEof
		EndIf
		cQuery += " UNION ALL                                  " + cEof
		
	EndIf        
	
	cQuery += " SELECT                                     " + cEof
	cQuery += "    'SB2'      ORIGEM,                      " + cEof
	cQuery += "    B1_COD     PRODUTO,                     " + cEof
	cQuery += "    B1_VQ_MP   MTPRIMA,                     " + cEof
	cQuery += "    B1_DESC    DESCRI,                      " + cEof
	cQuery += "    B1_TIPO    TIPO,                        " + cEof
	cQuery += "    ' '        DATA,                        " + cEof
	cQuery += "    B2_LOCAL   LOCAL,                       " + cEof
	cQuery += "    BF_LOCALIZ LOCALIZ,                     " + cEof
	cQuery += "    B8_LOTECTL LOTECTL,                     " + cEof
	cQuery += "    B8_SALDO   QTDE                         " + cEof
	cQuery += " FROM "+RetSqlName("SB1")+" SB1             " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SB2")+" SB2 ON " + cEof
	cQuery += "       SB2.D_E_L_E_T_ <> '*'                " + cEof
	cQuery += "       AND B2_FILIAL = '"+xFilial("SB2")+"' " + cEof
	cQuery += "       AND B2_COD    = B1_COD               " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SBF")+" SBF ON " + cEof
	cQuery += "       SBF.D_E_L_E_T_ <> '*'                " + cEof
	cQuery += "       AND BF_FILIAL  = '"+xFilial("SBF")+"'" + cEof
	cQuery += "       AND BF_PRODUTO = B2_COD              " + cEof
	cQuery += "       AND BF_LOCAL   = B2_LOCAL            " + cEof
	cQuery += "    INNER JOIN "+RetSqlName("SB8")+" SB8 ON " + cEof
	cQuery += "       SB8.D_E_L_E_T_ <> '*'                " + cEof
	cQuery += "       AND B8_FILIAL  = '"+xFilial("SBJ")+"'" + cEof
	cQuery += "       AND B8_PRODUTO = BF_PRODUTO          " + cEof
	cQuery += "       AND B8_LOCAL   = BF_LOCAL            " + cEof
	cQuery += "       AND B8_LOTECTL = BF_LOTECTL          " + cEof
	cQuery += " WHERE                                      " + cEof
	cQuery += "    SB1.D_E_L_E_T_ <> '*'                   " + cEof
	cQuery += "    AND B1_FILIAL  = '"+xFilial("SB1")+"'   " + cEof
	If !Empty(aRet[1])
		cQuery += "    AND (                                   " + cEof
		cQuery += "          B1_COD   = '"+aRet[1]+"'          " + cEof
		cQuery += "       OR B1_VQ_MP = '"+aRet[1]+"'          " + cEof
		cQuery += "        )                                       " + cEof
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
	TcQuery cQuery New Alias "TMP"
	
	While !TMP->(Eof())
		//		If TMP->TIPO == "MP"
		cChave := TMP->(PRODUTO+LOCAL+LOCALIZ+LOTECTL)
		//		Else
		//			cChave := TMP->(MTPRIMA+LOCAL+LOCALIZ+LOTECTL)
		//		EndIf
		
		nPos := aScan(aProdutos,{|x|x[1] == cChave})
		
		nSb2 := 0
		nSb9 := 0  
		
		If TMP->ORIGEM == "SB2"
			nSb2 := TMP->QTDE
		ElseIf TMP->ORIGEM == "SB9"
			nSb9 := TMP->QTDE
		EndIf
		
		If TMP->TIPO == "MP"
			cCodMp := TMP->PRODUTO
		Else
			cCodMp := TMP->MTPRIMA
		EndIf
		
		If nPos == 0
			aAdd(aProdutos ,{    ;
			cChave          ,;
			TMP->PRODUTO    ,;
			cCodMp          ,;
			TMP->DESCRI     ,;
			TMP->TIPO       ,;
			sTod(TMP->DATA) ,;
			TMP->LOCAL      ,;
			TMP->LOCALIZ    ,;
			TMP->LOTECTL    ,;
			nSb9            ,;
			nSb2             ;
			})
		ELse
			aProdutos[nPos][10] += nSb9
			aProdutos[nPos][11] += nSb2
		EndIf
		
		TMP->(DbSkip())
	EndDo
	
	If Select("TMP") > 0
		TMP->(DbCloseArea())
	EndIf
	
EndIf

If Len(aProdutos) > 0

	aProdutos := aSort( aProdutos ,,, { |x, y| (x[3]+x[2]+x[7]+x[8]+x[9]) < (y[3]+y[2]+y[7]+y[8]+y[9]) } )

	// Cria arquivo temporario
	aStru := {}
	aAdd(aStru,	{"MTPRIMA" ,"C",015,0} )
	aAdd(aStru,	{"PRODUTO" ,"C",015,0} )
	aAdd(aStru,	{"DESCRI"  ,"C",254,0} )
//	aAdd(aStru,	{"TIPO"    ,"C",002,0} )
	aAdd(aStru,	{"DATAB9"  ,"D",008,0} )
	aAdd(aStru,	{"LOCAL"   ,"C",002,0} )
	aAdd(aStru,	{"LOCALIZ" ,"C",015,0} )
	aAdd(aStru,	{"LOTECTL" ,"C",010,0} )
	aAdd(aStru,	{"QTDE_INI","N",018,2} )
	aAdd(aStru,	{"QTDE_ATU","N",018,2} )
	
	
	If Select("TEMP") > 0
		TEMP->(DbCloseArea())
	EndIf
	
	cArquivo := CriaTrab(aStru)
	dbUseArea(.T.,, cArquivo, "TEMP", .F., .F.)
	
	For nX := 1 To Len(aProdutos)
		RecLock("TEMP",.T.)
		TEMP->MTPRIMA  := aProdutos[nX][03]
		TEMP->PRODUTO  := aProdutos[nX][02]
		TEMP->DESCRI   := aProdutos[nX][04]
//		TEMP->TIPO     := aProdutos[nX][05]
		TEMP->DATAB9   := aProdutos[nX][06]
		TEMP->LOCAL    := aProdutos[nX][07]
		TEMP->LOCALIZ  := aProdutos[nX][08]
		TEMP->LOTECTL  := aProdutos[nX][09]
		TEMP->QTDE_INI := aProdutos[nX][10]
		TEMP->QTDE_ATU := aProdutos[nX][11]
		MsUnLock()	
	Next nX

	If Select("TEMP") > 0
		TEMP->(DbCloseArea())
	EndIf
	
	__CopyFile(cArquivo+".DBF" , AllTrim(GetTempPath())+cArquivo+".XLS")
	If ! ApOleClient( 'MsExcel' )
		MsgStop( 'MsExcel nao instalado')
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open(AllTrim(GetTempPath())+cArquivo+".XLS") // Abre uma planilha
		oExcelApp:SetVisible(.T.)
	EndIf

EndIf

Return()
