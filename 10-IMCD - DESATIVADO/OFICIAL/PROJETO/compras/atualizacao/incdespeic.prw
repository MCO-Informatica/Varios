#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ INCDESPEIC º Autor ³  Junior Carvalho   º Data ³ 04/02/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Função para gerar custos das despesas de importação          º±±
±±º          ³ em movimentação internas modelo 2                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Específico MAKENI                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function INCDESPEIC()

	Local aCpos		:= {}
	Local cTitBrow	:= OemToAnsi( "Notas de Custos" )
	Local lRet 		:= .T.

	Private _cArq     := "T_"+Criatrab(,.F.)
	Private cNomeUser := Alltrim(UsrRetName(__CUSERID))
	Private oBrowse
	Private ESDESPEIC := SuperGetMv("ES_DESPEIC",,'244')+',  '
	Private cDespFor  := SuperGetMv("ES_DESPFOR",,'02482')+',  '
	Private cAliasTRB := GetNextAlias()
	Private cAliasTMP := GetNextAlias()
	Private aRotina   := {{"Gerar Custos","U_GRVEICD3()", 0,4}}
	Private oMark
	Private cMarca    := GetMark()
	Private aSeek     := {}

	Private cCodPrd := CriaVar("D1_COD",.F.)
	Private cConhec := CriaVar("D1_CONHEC",.F.)
	Private cChvSF1 := SF1->F1_FILIAL+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
	Private aPrdOri := {}
	Private aPrdSv  := {}
	Private nVBrut	:= 0
	Private cArqTrab

	If !( (SF1->F1_FORMUL == 'S' .OR. Alltrim(SF1->F1_FORNECE) $ cDespFor ).and. !EMPTY(SF1->F1_HAWB) .AND. ALLTRIM(SF1->F1_ESPECIE) == 'SPED'  )
		Alert("Não é uma nota de Importação")
		Return()
	ENDIF
	If EMPTY(SF1->F1_STATUS)
		Alert("Nota não Classificada.")
		Return()
	ENDIF

	cConhec := SF1->F1_HAWB

	PROCESSA( { || ITENSNF(@lRet)  }, "BUSCANDO DADOS","IMCD")

	if !lRet
		Return()
	EndIf

	PROCESSA( { || BSCDADOS() }, "BUSCANDO DADOS","IMCD")


	cTitBrow := " IMPORTAÇÃO "+cConhec

	aCpos := {}
//aAdd(aCpos,{'Filial' ,'D1_FILIAL','C',7,0,"@!"})
	aAdd(aCpos,{'Documento','D1_DOC','C',9,0,"@!"})
	aAdd(aCpos,{'Serie'	   ,'D1_SERIE','C',3,0,"@!"})
	aAdd(aCpos,{'Tes'	   ,'D1_TES','C',3,0,"@!"})
	aAdd(aCpos,{'Dt.Emissão','D1_EMISSAO','D',8,0,PesqPict('SD1','D1_EMISSAO')})
	aAdd(aCpos,{'Dt.Digitação','D1_DTDIGIT','D',8,0,PesqPict('SD1','D1_DTDIGIT')})
	aAdd(aCpos,{'Produto','D1_COD','C',20,0,"@!"})
	aAdd(aCpos,{'Descrição','B1_DESC','C',30,0,"@!"})
	aAdd(aCpos,{'Valor','D1_TOTAL','N',15,4,PesqPict('SD1','D1_TOTAL')})
	aAdd(aCpos,{'Custo','D1_CUSTO','N',15,4,PesqPict('SD1','D1_CUSTO')})

	aAdd(aSeek,{"Filial+Documento" , {},1,.T.})
	aAdd(aSeek,{"Filial+Produto"   , {},2,.T.})

	cAliasTRB := (cArqTrab) // remover pos-testes.

//????????????????????????????
//?Construcao do MarkBrowse?
//????????????????????????????
	oMark:= FWMarkBrowse():NEW()   // Cria o objeto oMark - MarkBrowse
	oMark:SetAlias(cAliasTRB)      // Define a tabela do MarkBrowse
	oMark:SetDescription(cTitBrow) // Define o titulo do MarkBrowse
//oMark:SetFieldMark("MRKOK")    // Define o campo utilizado para a marcacao
	oMark:SetFilterDefault()       // Define o filtro a ser aplicado no MarkBrowse
	oMark:SetFields(aCpos)         // Define os campos a serem mostrados no MarkBrowse
	oMark:SetSemaphore(.F.)        // Define se utiliza marcacao exclusiva
	oMark:SetTemporary(.T.)
//oMark:DisableDetails()         // Desabilita a exibicao dos detalhes do MarkBrowse
//oMark:DisableConfig()          // Desabilita a opcao de configuracao do MarkBrowse
//oMark:DisableReport()          // Desabilita a opcao de imprimir
	oMark:SetUseFilter(.T.)
//oMark:SetSeek(.T.,aSeek)

	oMark:AddMarkColumns ({|| Iif(MRKOK == cMarca,'LBOK','LBNO')},{|| MARCAR() },{|| .F. })

//define as legendas
//oMark:AddLegend('EMPTY(MRKOK) ',"BR_VERDE" ,"OK")

	oMark:Activate()

//?????????????????????????????????????
//?estaura condicao original          ?
//?????????????????????????????????????
	dbSelectArea(cAliasTRB)
	(cAliasTRB)->(dbCloseArea())

	FERASE(_cArq+".DTC")

Return()

Static Function BSCDADOS()

	local aStruct as array

	local oTempTable as object

	local cQuery as char
	local cTempAlias as char

	local nloop as numeric


	aStruct := {}

	cQuery := ""
	cTempAlias := GetNextAlias()

	nloop := 0

	cQuery := "SELECT '  ' MRKOK, "
	cQuery += " D1_CONHEC, D1_FILIAL, "
	cQuery += " D1_SERIE,D1_DOC, "
	cQuery += " D1_ITEM,D1_TES, D1_COD, B1_DESC, "
	cQuery += " D1_VUNIT,D1_QUANT ,D1_TOTAL, "
	cQuery += " D1_FORNECE,	D1_LOJA, "
	cQuery += " D1_EMISSAO,D1_DTDIGIT,D1_CUSTO, "
	cQuery += " D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA||D1_COD||D1_ITEM CHVSD1, SD1.R_E_C_N_O_ D1RECNO  "
	cQuery += " FROM "+RetSqlName("SD1")+" SD1, "+RetSqlName("SB1")+" SB1 "
	cQuery += " WHERE "
	cQuery += " B1_COD = D1_COD AND B1_FILIAL = '"+XFILIAL("SB1")+"' "
	cQuery += " AND B1_TIPO NOT IN ('MR','MA' ) "
	cQuery += " AND SB1.D_E_L_E_T_ <> '*' "
	cQuery += " AND D1_XINTSD3 = ' ' "
	cQuery += " AND D1_TES NOT IN " + FormatIn(ESDESPEIC,',')
	//cQuery += " AND D1_TES NOT IN (' ', '244') "
	cQuery += " AND D1_CONHEC = '"+cConhec+"' "
	//cQuery += " AND SUBSTR(D1_COD,1,2) <> 'MR' "
	cQuery += " AND D1_FILIAL||D1_DOC||D1_SERIE||D1_FORNECE||D1_LOJA <> '"+cChvSF1+"' "
	cQuery += " AND D1_FILIAL = '"+XFILIAL("SD1")+"' "
	cQuery += " AND SD1.D_E_L_E_T_ <> '*' "

	cQuery := ChangeQuery(cQuery)

	dbUseArea(.T.,"TOPCONN", TcGenQry(,,cQuery ), cTempAlias, .T., .F.)
	TcSetField(cTempAlias,"D1_EMISSAO","D")
	TcSetField(cTempAlias,"D1_DTDIGIT","D")

	If oTempTable <> NIL
		oTempTable:Delete()
		oTempTable := nil
	EndIf

	cArqTrab := GetNextAlias()
	aStruct := (cTempAlias)->(DBStruct())
	(cTempAlias)->(DBCloseArea())

	oTemptable := FWTemporaryTable():New(cArqTrab)
	oTemptable:SetFields(aStruct)
	oTemptable:AddIndex("1",{"D1_FILIAL","D1_COD"})

	oTempTable:Create()

//dbUseArea( .T.,__LOCALDRIVER, _cArq,cTempAlias, .T. , .F. )

	Processa({||SqltoTrb(cQuery, aStruct, cArqTrab)})

Return

Static Function MARCAR()

	dbSelectArea(cAliasTRB)

	RecLock(cAliasTRB,.F.)
	If (cAliasTRB)->MRKOK <> cMarca
		(cAliasTRB)->MRKOK := cMarca

	Else
		(cAliasTRB)->MRKOK := Space(Len( (cAliasTRB)->MRKOK ) )

	EndIf
	(cAliasTRB)->(MsUnlock())
	oMark:oBrowse:Refresh(.T.)

Return()


User Function GRVEICD3()
	Local nTotSrv := 0
	Local nX := 0
	aPrdSv := {}
	dbSelectArea(cAliasTRB)
	dbGoTop()
	ProcRegua(RecCount())

	While !(cALiasTRB)->(Eof())
		IncProc( OemToAnsi( (cAliasTRB)->D1_DOC ) )

		if (cAliasTRB)->MRKOK == cMarca
			aAdd(aPrdSv, {(cAliasTRB)->CHVSD1, (cAliasTRB)->D1_DOC,(cAliasTRB)->D1_SERIE,(cAliasTRB)->D1_CUSTO,(cAliasTRB)->D1RECNO,.F.})

			dbSelectArea(cALiasTRB)
			RecLock(cAliasTRB , .F.)
			(cAliasTRB)->MRKOK := ' '
			dbDelete()
			MsUnLock()

		Endif
		(cALiasTRB)->(DBSKIP())
		Loop

	EndDo

	if Len(aPrdSv) > 0
		lGerou := .F.

		PROCESSA( { || GRVSD3(@lGerou)  }, "GERANDO CUSTOS","IMCD - INCDESPEIC")
		if lGerou
			FOR nX:= 1 To Len( aPrdSv )
				IF aPrdSv[nX][6]
					nTotSrv += aPrdSv[nX][4]
					cQuery := "UPDATE "+RetSqlName("SD1")+" SET D1_XINTSD3 = '"+DTOS(dDataBase)+"' WHERE R_E_C_N_O_ = "+Str(aPrdSv[nX][5])

					If TCSQLExec(cQuery) < 0
						cSqlErr := TCSqlError()
						HS_MsgInf("Ocorreu um erro :" + Chr(10) + Chr(13) + cSqlErr, "Atenção!!!", "Inconsistência")
					EndIf
				ELSE
					Alert("Erro na Nota "+ aPrdSv[nX][2]+" Serie "+ aPrdSv[nX][3])
				ENDIF
			Next
			Alert("Total serviços: "+ transform(nTotSrv,"@E 999,999.99") )
		Else
			Alert("Erro na Geração dos Custos ")
		Endif

	Else
		ALERT("Nenhum documento Marcado.")
	Endif

Return

Static Function ITENSNF(lRet)
	Local nX := 0

	dbSelectArea("SD1")
	dbSetOrder(1)
	nVBrut := 0
	if MsSeek(cChvSF1)
		While SD1->(!Eof()) .and. cChvSF1 == SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA)

			aAdd(aPrdOri,{SD1->D1_COD, SD1->D1_UM, SD1->D1_LOCAL, SD1->D1_TOTAL,0,SD1->D1_CONHEC} )
			nVBrut += SD1->D1_TOTAL

			SD1->(DbSkip())
			Loop
		EndDo

	Endif

	FOR nX:= 1 to Len( aPrdOri )
		aPrdOri[nX][5]  := ROUND((aPrdOri[nX][4] / nVBrut),6)
	Next

Return

Static Function GRVSD3(lGerou)

	Local aCab		:= {}
	Local aItem		:= {}
	Local aItens	:={}
	Local nPrOri    := 0
	Local nPrSv     := 0
	Local cTM		:= SUBSTR(SuperGetMv("ES_TESCUST", ,"007"),1,3 )
	Private lMsHelpAuto := .T. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .F. //necessario a criacao

	nQtItens := Len(aPrdSv)

	ProcRegua(nQtItens)
	if nQtItens > 0

		BEGIN TRANSACTION
			For nPrOri := 1 To Len(aPrdOri)

				lMsErroAuto := .F.

				aCab := { {"D3_FILIAL"	, XFILIAL("SD3"),Nil},;
					{"D3_TM" 		,cTM , NIL},;
					{"D3_DOC" 	, SUBSTR(ALLTRIM( aPrdOri[nPrOri][6] ),1,9), NIL},;
					{"D3_EMISSAO" 	,dDataBase, NIL} }

				IncProc(OemToAnsi("GERANDO "+aPrdOri[nPrOri][1]))

				For nPrSv := 1 To nQtItens
					DbSelectArea("SB1")
					DbSetOrder(1)
					cTipo := POSICIONE("SB1",1,xFilial("SB1")+aPrdOri[nPrOri][1],"B1_TIPO")

					cLocPrd := iif(Alltrim(cTipo) = 'MR','01', aPrdOri[1][3] )
					aItem:={{"D3_COD" , aPrdOri[nPrOri][1] ,NIL},;
						{"D3_DOC" 	, SUBSTR(ALLTRIM( aPrdOri[nPrOri][6] ),1,9), NIL},;
						{"D3_UM" 		, aPrdOri[nPrOri][2] ,NIL},;
						{"D3_CUSTO1"	, ROUND(aPrdOri[nPrOri][5] * aPrdSv[nPrSv][4],5),Nil},;
						{"D3_LOCAL" 	, cLocPrd ,NIL},;
						{"D3_XIMPEIC"	, aPrdSv[nPrSv][1]+" EIC "+aPrdOri[nPrOri][6]  ,Nil } }

					aPrdSv[nPrSv][6] := .T.

					aadd(aItens,aItem)
					IncProc()

				Next nPrSv

				MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItens,3)
				aItens := {}
				lGerou := .T.

				If lMsErroAuto
					Mostraerro()
					DisarmTransaction()
					lGerou := .F.
				EndIf

			Next nPrSv

		END TRANSACTION

	Else
		ALERT("Não há itens para gerar Custos.")
	Endif

Return()
