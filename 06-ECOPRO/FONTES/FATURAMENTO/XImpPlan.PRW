#Include "Protheus.ch"
#Include "Totvs.ch"
#Include "FwMvcDef.ch"
#Include "FileIo.ch"
#Include "TopConn.ch"

User Function XImpPlan()

	Private dVigencia
	Private cTb

	CriaPerg()

	If Pergunte("CSVIMP",.T.)

		If !Empty(MV_PAR02)
			dVigencia := MV_PAR02
		Else
			dVigencia := YearSum(dDataBase,5)
		EndIf

		//U_BkpTblPrc()

		Processa( {|| Import() }, "Aguarde...", "Atualizando dados...",.F.)

		MsgInfo("Processo Finalizado!", "Concluido")

	else
		MsgAlert("Processo Cancelado!", "Cancelado")
	EndIf
Return



Static Function Import()

	Local cLinha  := ""
	Local aCabec  := {}
	Local aDados  := {}
	Local lCabec  := .F.
	Local lTab    := .T.
	Local nX, nPos, nPos2
	Local nJ, nI
	Local cGrava  := ""
	Local cDados  := ""
	Local lRet    := .F.
	Local aIndice := {}
	Local cIndice := ""
	Local cTipo   := ""
	Local aAux    := {}
	Local nRegs, nY
	Local nLin    := 3
	Local cMsg    := ""
	Local nCount  := 0
	Local cSql 	  := ""
	Local lalert  := .T.
	Private cTabela
	//Private cCodTab := DA0->DA0_CODTAB


	//Pergunte("CSVIMP",.F.)

/*	DbSelectArea("DA0")
	DA0->(DbSetOrder(1))
	DbSeek(xFilial("DA0")+cTb)

	RecLock("DA0",.F.)
	DA0->DA0_DATDE  := dDataBase
	DA0->DA0_DATATE := dVigencia
	DA0->(MsUnlock()) */ 

	FT_FUSE(MV_PAR01)
	FT_FGOTOP()

	While !FT_FEOF()

		cLinha := Upper(FT_FREADLN())

		If lTab
			aTab := Separa(cLinha,";",.T.)
			lTab := .F.
			lCabec := .T.
		ElseIf lCabec
			aCabec := Separa(cLinha,";",.T.)
			lCabec := .F.
		Else

			If "#" $ cLinha
				Exit
			EndIf

			If !"#" $ cLinha .And. !";;;" $ PadL(cLinha,3)
				aAdd(aDados,Separa(cLinha,";",.T.))
				nCount++
			EndIf
			
		EndIf

		If Len(aCabec) <= 0
			lCabec := .T.
		EndIf

		FT_FSKIP()
	EndDo

	cTabela := "DA1" //aTab[1]
	aAux := aClone(aTab)

	ProcRegua(nCount)

//DbSelectArea(aTab[1])


	/*If Select("QRYDA1") > 0
		QRYDA1->(DbCloseArea())
	EndIf

	SELECIONA TODOS OS ITENS DA TABELA ATUAL 
	cSql := "SELECT * FROM "+RetSqlName("DA1")+" DA1 WHERE DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.DA1_CODTAB = '"+cTb+"' AND DA1.D_E_L_E_T_<>'*' "
	TcQuery ChangeQuery(cSql) New Alias "QRYDA1"


	While !QRYDA1->(EOF())

		//DbSelectArea("DA1")
		//DA1->(DbSetOrder(1))
		DA1->(DbGoTo(QRYDA1->R_E_C_N_O_))

		//CRIA NOVO ITEM
		RecLock("DA1",.F.)
		DA1->(DbDelete())
		QRYDA1->(DbSkip())

	End

	If Select("QRYDA1") > 0
		QRYDA1->(DbCloseArea())
	EndIf*/

	For nX := 1 To Len(aDados)
		//cDado := StrTran(AllTrim(aDados[nX][2]),'*','0' )

		If Empty(Posicione("SB1",1,xFilial("SB1")+aDados[nX][2],"B1_DESC"))
			Alert("Item: "+AllTrim(PadL(aDados[nX][2],TamSX3("DA1_CODPRO")[2],'0'))+" não existe no cadastro de produtos!","Atenção")
			Loop
		EndIf
		
		If cTb <> aDados[nX][1] //QRYDA1->DA1_CODPROD

			DbSelectArea("DA0")
			DA0->(DbSetOrder(1)) 

			If DbSeek(xFilial("DA0")+aDados[nX][1])
				lAlert := .T.
				cTb := aDados[nX][1]
				RecLock("DA0",.F.)
				DA0->DA0_DATDE  := dDataBase
				DA0->DA0_DATATE := dVigencia
				DA0->(MsUnlock())
			
				/*If Select("QRYDA1") > 0
					QRYDA1->(DbCloseArea())
				EndIf

					 SELECIONA TODOS OS ITENS DA TABELA ATUAL 
				cSql := "SELECT * FROM "+RetSqlName("DA1")+" DA1 WHERE DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.DA1_CODTAB = '"+cTb+"' AND DA1.D_E_L_E_T_<>'*' "
				TcQuery ChangeQuery(cSql) New Alias "QRYDA1"


				While !QRYDA1->(EOF())

					DbSelectArea("DA1")
					DA1->(DbSetOrder(1))
					DA1->(DbGoTo(QRYDA1->R_E_C_N_O_))

					CRIA NOVO ITEM
					RecLock("DA1",.F.)
					DA1->(DbDelete())
					QRYDA1->(DbSkip())

				End

				If Select("QRYDA1") > 0
					QRYDA1->(DbCloseArea())
				EndIf	*/		
			Else
					If lalert
						lalert := .F.
						Alert("Tabela: "+AllTrim(PadL(aDados[nX][1],TamSX3("DA1_CODTAB")[1],'0'))+" não existe na tabela de preços!","Atenção")
					EndIf
					Loop
			EndIf

		EndIf
	
		DbSelectArea("DA1")
		DA1->(DbSetOrder(1)) 

		If DbSeek(xFilial("DA1")+cTb+aDados[nX][2])
			RecLock("DA1",.F.)		//Se achar o produto na tabela de precos, altera.
		Else
			RecLock("DA1",.T.)     //Se não achar o produto na tabela de precos, inclui.  
		EndIf		
		DA1_FILIAL  := xFilial("DA1")
		DA1_CODTAB  := cTb //DA0->DA0_CODTAB
		DA1_ITEM    := StrZero(nX,4) //QRYDA1->DA1_ITEM
		DA1_CODPROD := aDados[nX][2] //QRYDA1->DA1_CODPROD
		//DA1_DESCRI  := Posicione("SB1",1,xFilial("SB1")+aDados[nX][1],"B1_DESC")
		DA1_PRCVEN  := Val(aDados[nX][3]) //QRYDA1->DA1_PRCVEN
		DA1_VLRDES  := 0 //QRYDA1->DA1_VLRDES
		DA1_PERDES  := 0 //QRYDA1->DA1_PERDES
		DA1_ATIVO   := "1" //QRYDA1->DA1_ATIVO
		DA1_FRETE   := 0 //QRYDA1->DA1_FRETE
		DA1_TPOPER  := "4" //QRYDA1->DA1_TPOPER
		DA1_QTDLOT  := 999999.99 //QRYDA1->DA1_QTDLOT 999999.99
		//DA1_INDLOT  := 000000000999999.99  //QRYDA1->DA1_INDLOT
		DA1_MOEDA   := 1 //QRYDA1->DA1_MOEDA
		DA1_DATVIG  := dDataBase //YearSum(DA0->DA0_DATDE,5) // data final de vigencia (colocar antes do backup) (data de inicio da vigencia)
		//DA1_DTUMOV  := StoD(QRYDA1->DA1_DTUMOV)
		//DA1_HRUMOV  := QRYDA1->DA1_HRUMOV
		DA1->(MsUnlock())

	IncProc()
Next

If !Empty(cMsg)
	cMsg := "Aumente os campos não alterados, de preferência campos chave para refinar a pesquisa e garantir a atualização. As linhas listadas abaixo não foram alteradas:" + CRLF + CRLF + cMsg
	Aviso("Problemas na atualização",cMsg,{"Ok"},3)
EndIf

Return


Static Function CriaPerg()

	Local aEstrut := {}
	Local aGrava  := {}
	Local cTit    := "Arquivo .CSV?"
	Local nI, nJ

	dbSelectArea('SX1')
	SX1->(dbSetOrder(1))
	If SX1->(!dbSeek('CSVIMP'))
		//::Monta a Estrutura do SX1
		aEstrut := {"X1_GRUPO"	,"X1_ORDEM"		,"X1_PERGUNT"	,"X1_PERSPA"	,"X1_PERENG"	,"X1_VARIAVL"	,;
			"X1_TIPO"	,"X1_TAMANHO"	,"X1_DECIMAL"	,"X1_PRESEL"	,"X1_GSC"		,"X1_VALID"		,;
			"X1_VAR01"	,"X1_DEF01"		,"X1_DEFSPA1"	,"X1_DEFENG1"	,"X1_CNT01"		,"X1_F3"		,;
			"X1_PYME"	,"X1_GRPSXG"	,"X1_HELP"		,"X1_PICTURE"									}
		//::Adiciona os dados a gravar
		aADD(aGrava,{"CSVIMP"	,"01"			,cTit	    	,cTit		    ,cTit	    	,"mv_ch1"		,;
			"C"		,75				,0				,0				,"F"			,""				,;
			"MV_PAR01"	,"56"				,""				,""				,""				,""		    ,;
			""			,""				,""				,""												})
		aADD(aGrava,{"CSVIMP"	,"02"			,"Vigencia ate?"	    	,"Vigencia ate?"		    ,"Vigencia ate?"	    	,"mv_ch2"		,;
			"D"		,8				,0				,0				,"F"			,""				,;
			"MV_PAR02"	,"57"				,""				,""				,""				,""		    ,;
			""			,""				,""				,""												})

		//::Grava no SX1
		For nI:= 1 to len(aGrava)
			RecLock("SX1",.T.)
			For nJ:=1 To Len(aGrava[nI])
				If FieldPos(aEstrut[nJ])>0 .And. aGrava[nI,nJ] != NIL
					FieldPut(FieldPos(aEstrut[nJ]),aGrava[nI,nJ])
				EndIf
			Next nJ
			SX1->(msUnLock())

		Next nI

	EndIf

Return



Static Function Verify(cCampo)

	Local cTipo

	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))

	SX3->(DbSeek(cCampo))

	cTipo := SX3->X3_TIPO

Return cTipo

Static Function fPesquisar(aCabec,aDados)

	Local nQtd      := 0
	Local cQuery    := ""
	Local cAliasQry := GetNextAlias()
	Local nI
	Local aAlt      := aClone(aTab)

	cQuery := "Select R_E_C_N_O_ RECORD from "+RetSqlName(cTabela)
	cQuery += " Where D_E_L_E_T_ = ' '"
	For nI := 1 to Len(aCabec)
		If aAlt[nI] <> "*"
			cTipo := Verify((aCabec[nI]))
			cQuery += " And "
			cQuery += aCabec[nI]
			cQuery += " = "

			cDado  := StrTran( AllTrim(aDados[nI]), '*', '0' )
			If cTipo $ "C"
				cQuery += "'" + cDado + "'"
			Else
				cQuery += StrTran(cDado, ",", ".")
			EndIf
		EndIF
	Next

	cQuery := ChangeQuery(cQuery)
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.T.,.T.)

	While !(cAliasQry)->( EOF() )
		(cTabela)->(DbGoto((cAliasQry)->RECORD ))
		nQtd++
		(cAliasQry)->(DbSkip())
	EndDo

	(cAliasQry)->(DbCloseArea())

Return nQtd



/* Função de backup de tabela de preços */
User Function BkpTblPrc()
	Local aArea  := GetArea()
	Local cSql 	 := ""
	Local cQry   := ""


	/* SELECT O ULTIMO REGISTRO COM CODIGO INICIADO EM Z */
	cQry := "SELECT MAX(DA0_CODTAB) AS DA0_CODTAB FROM "+RetSqlName("DA0")+" DA0 WHERE DA0.D_E_L_E_T_<>'*' AND DA0_FILIAL = '"+xFilial("DA0")+"' AND SUBSTRING(TRIM(DA0_CODTAB),1,1) ='Z' "
	If Select("QRYDA0") > 0
		QRYDA0->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cQry) New Alias "QRYDA0"

	/* ARMAZENA ESTE VALOR NA VARIAVEL E ADICIONA 1 AO SEQUENCIAL OU INICIA AS TABELAS PREFIXO Z */
	If !Empty(QRYDA0->DA0_CODTAB)
		cCodTab := Soma1(QRYDA0->DA0_CODTAB)
	Else
		cCodTab := "Z01"
	EndIf

	cQry := "SELECT * FROM "+RetSqlName("DA0")+" DA0 WHERE DA0.D_E_L_E_T_<>'*' AND DA0_FILIAL = '"+xFilial("DA0")+"' AND DA0_CODTAB = '"+DA0->DA0_CODTAB+"' "
	If Select("QRYDA0") > 0
		QRYDA0->(DbCloseArea())
	EndIf

	TcQuery ChangeQuery(cQry) New Alias "QRYDA0"

	cTb := QRYDA0->DA0_CODTAB

	/* INCLUI O CABEÇALHO DA TABELA BACKUP */
	If !Empty(cCodTab)

		RecLock("DA0",.T.)
		DA0_FILIAL := xFilial("DA0")
		DA0_CODTAB := cCodTab
		DA0_DESCRI := QRYDA0->DA0_DESCRI
		DA0_DATDE  := dDataBase //StoD(QRYDA0->DA0_DATDE)
		DA0_HORADE := QRYDA0->DA0_HORADE
		DA0_DATATE := dDataBase //StoD(QRYDA0->DA0_DATATE)
		DA0_HORATE := QRYDA0->DA0_HORATE
		DA0_CONDPG := QRYDA0->DA0_CONDPG
		DA0_TPHORA := QRYDA0->DA0_TPHORA
		DA0_ATIVO  := QRYDA0->DA0_ATIVO
		DA0->(MsUnlock())


		//FECHA TABELA TEMPORARIA DO CABEÇALHO
		If Select("QRYDA0") > 0
			QRYDA0->(DbCloseArea())
		EndIf


		/* VALIDA QUE A TABELA TEMPORARIA AINDA NÃO EXISTE */
		If Select("QRYDA1") > 0
			QRYDA1->(DbCloseArea())
		EndIf

		/* SELECIONA TODOS OS ITENS DA TABELA ATUAL */
		cSql := "SELECT * FROM "+RetSqlName("DA1")+" DA1 WHERE DA1.DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1.DA1_CODTAB = '"+cTb+"' AND DA1.D_E_L_E_T_<>'*' "
		TcQuery ChangeQuery(cSql) New Alias "QRYDA1"

		/* 
		PERCORRE A TABELA TEMPORARIA COM OS ITENS DA TABELA DE PREÇO SELECIONADA PELO USUARIO
		CRIANDO O MESMO ITEM NA NOVA TABELA DE BACKUP (Z)
		 */
		While !QRYDA1->(EOF())

			//DbSelectArea("DA1")
			//DA1->(DbSetOrder(1))
			//DA1->(DbGoTo(QRYDA1->R_E_C_N_O_))

			//CRIA NOVO ITEM
			RecLock("DA1",.T.)

			DA1_FILIAL  := xFilial("DA1")
			DA1_CODTAB  := cCodTab
			DA1_ITEM    := QRYDA1->DA1_ITEM
			DA1_CODPROD := QRYDA1->DA1_CODPROD
			DA1_PRCVEN  := QRYDA1->DA1_PRCVEN
			DA1_VLRDES  := QRYDA1->DA1_VLRDES
			DA1_PERDES  := QRYDA1->DA1_PERDES
			DA1_ATIVO   := QRYDA1->DA1_ATIVO
			DA1_FRETE   := QRYDA1->DA1_FRETE
			DA1_ESTADO  := QRYDA1->DA1_ESTADO
			DA1_TPOPER  := QRYDA1->DA1_TPOPER
			DA1_QTDLOT  := QRYDA1->DA1_QTDLOT
			DA1_INDLOT  := QRYDA1->DA1_INDLOT
			DA1_MOEDA   := QRYDA1->DA1_MOEDA
			DA1_DATVIG  := StoD(QRYDA1->DA1_DATVIG)
			DA1_DTUMOV  := StoD(QRYDA1->DA1_DTUMOV)
			DA1_HRUMOV  := QRYDA1->DA1_HRUMOV

			DA1->(MsUnlock())

			QRYDA1->(DbSkip())
		End

		//FECHA A TABELA TEMPORARIA
		If Select("QRYDA1") > 0
			QRYDA1->(DbCloseArea())
		EndIf

	EndIf

	RestArea(aArea)

	MsgInfo("Tabela "+cCodTab+" criada com sucesso!","Sucesso")

Return Nil
