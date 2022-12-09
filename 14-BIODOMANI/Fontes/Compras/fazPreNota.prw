#Include 'Protheus.ch'
#Include "TbiConn.ch"
/*
Função: fazPreNota
Descrição: Inclusão de pré-nota de entrada com autoexec mata140
Parametros: 
nQtdLab - total da amostra para separar e enviar ao laboratório, se tiver
*/
User Function fazPreNota(cDoc, nSerie, cCliente, cLojCli, cFornec, cLojFor, nQtdLab, cGruDest, cFilDest)
	Local aAreaAtu	:= GetArea()
	Local aAreaSF2  := sf2->(GetArea())
	Local aAreaSD2  := sd2->(GetArea())

	Local cRet      := ""
	Local nOpc      := 3 //inclusão da pré-nota de entrada
	Local aCabec    := {}
	Local aLinha    := {}
	Local aItNF     := {}
	Local nItem 	:= 0
	//Local nI		:= 0
	Local cObs		:= ""

	Default nQtdLab := 0
	Default cGruDest := cEmpAnt
	Default cFilDest := cFilAnt

	//if nQtdLab > 0
	//	if nPorQtd > nQtdLab .or. mod(nQtdLab,nPorQtd) != 0
	//		lRet := .f.
	//		MessageBox("A quantidade que será separada não pode ser maior que, ou ter resto na divisão da sua amostra total!","ATENÇÃO", 16)
	//		break
	//	endif
	//endif

	sf2->(DbSetOrder(1))	//F2_FILIAL + F2_DOC + F2_SERIE + F2_CLIENTE + F2_LOJA + F2_FORMUL + F2_TIPO
	if sf2->(dbSeek(xFilial()+cDoc+nSerie+cCliente+cLojCli))
		sd2->(DbSetOrder(3))	//D2_FILIAL + D2_DOC + D2_SERIE + D2_CLIENTE + D2_LOJA + D2_COD + D2_ITEM
		if sd2->(dbSeek(xFilial()+sf2->f2_doc+sf2->f2_serie+sf2->f2_cliente+sf2->f2_loja))
			aCabec  := {{'F1_TIPO'     ,'N',NIL},;
				{'F1_FORMUL'   ,'S',NIL},;
				{'F1_DOC'      ,sf2->f2_doc,NIL},;
				{"F1_SERIE"    ,sf2->f2_serie,NIL},;
				{"F1_EMISSAO"  ,sf2->f2_emissao,NIL},;
				{'F1_FORNECE'  ,cFornec,NIL},;
				{'F1_LOJA'     ,cLojFor,NIL},;
				{"F1_ESPECIE"  ,'NFE',NIL},;
				{"F1_STATUS"   ,' ',NIL} }

			nItem := 0
			aLinha := {}
			while sd2->(!Eof()) .and. sd2->d2_doc == sf2->f2_doc .and. sd2->d2_serie == sf2->f2_serie .and. ;
					sd2->d2_cliente == sf2->f2_cliente .and. sd2->d2_loja == sf2->f2_loja
				nQtd := sd2->d2_quant
				nPrcVen := sd2->d2_prcven
				cObs := "GERADO A PARTIR NF SAIDA/SÉRIE/ITEM: "+sf2->f2_doc+"/"+sf2->f2_serie+"/"+sd2->d2_item
				/*
				if nQtdLab > 0 .and. nQtd > nQtdLab
					for nI := 1 to nQtdLab step nPorQtd
						nItem += 1
						aItNF  := { {'D1_ITEM',strzero(nItem,4),NIL},;
							{'D1_COD'    ,sd2->d2_cod,NIL},;
							{"D1_QUANT"  ,nPorQtd,Nil},;
							{"D1_VUNIT"  ,nPrcVen,Nil},;
							{"D1_TOTAL"  ,Round((nPorQtd*nPrcVen),2),Nil},;
							{"D1_TES"    ,'',NIL},;
							{'D1_YOBS'   ,cObs,NIL}, ;
							{'D1_XQTDLAB',nQtdLab,NIL},;
							{'D1_LOTECTL',sd2->d2_lotectl,NIL}, ;
							{'D1_DTVALID',sd2->d2_dtvalid,NIL} }
						aAdd(aLinha,aItNF)
					next
					nQtd -= nQtdLab
				endif
				*/
				nItem += 1
				aItNF  := { {'D1_ITEM',strzero(nItem,4),NIL},;
					{'D1_COD'    ,sd2->d2_cod,NIL},;
					{"D1_QUANT"  ,nQtd	,Nil},;
					{"D1_VUNIT"  ,nPrcVen,Nil},;
					{"D1_TOTAL"  ,Round((nQtd*nPrcVen),2),Nil},;
					{"D1_TES"    ,'',NIL},;
					{'D1_YOBS'   ,cObs,NIL}, ;
					{'D1_XQTDLAB',nQtdLab,NIL},;
					{'D1_LOTECTL',sd2->d2_lotectl,NIL}, ;
					{'D1_DTVALID',sd2->d2_dtvalid,NIL} }

				aAdd(aLinha,aItNF)
				sd2->(dbSkip())
			end

			if len(aLinha) > 0

				cRet := StartJob("u_fazMata140",GetEnvServer(), .t.,aCabec, aLinha, nOpc, .t., cGruDest, cFilDest)

			else
				cRet := "Inclusão de NF de Entrada não realizada, pois não encontrou itens da NF de saída!"
			endif

		else
			cRet := "Nenhum item da NF foi encontrado. Inclusão de NF de Entrada não realizada!"
		endif
	else
		cRet := "Cabeçlho NF não encontrado. Inclusão de NF de Entrada não realizada!"
	endif

	RestArea(aAreaSD2)
	RestArea(aAreaSF2)
	RestArea(aAreaAtu)

Return cRet

User Function fazMata140(aCabec, aLinha, nOpc, lAmb, cGruDest, cFilDest)

	Local nI := 0
	Local aLog := {}
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description} )
	Local cOpc := ""

	if nOpc == 3
		cOpc := "Inclusão"
	elseif nOpc == 4
		cOpc := "Alteração"
	elseif nOpc == 5
		cOpc := "Exclusão"
	endif

	Private lMsErroAuto := .F.

	Begin sequence

		if lAmb
			//RpcClearEnv()
			RpcSetType( 3 )
			RpcSetEnv( cGruDest, cFilDest,,,'COM','FAZMATA140')
		endif

		MSExecAuto({|x,y,z,a,b| MATA140(x,y,z,a,b)}, aCabec, aLinha, nOpc,,)
		If lMsErroAuto
			cError += "Erro "+cOpc+": "
			aLog := GetAutoGRLog()
			For nI := 1 To Len(aLog)
				cError += aLog[nI]+chr(13)+chr(10)
			Next
		endif

		if lAmb
			RpcClearEnv()
		endif

	End sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		cError := "Falha "+cOpc+":"+chr(13)+chr(10)+"Nota Fiscal: " +aCabec[3,2]+chr(13)+chr(10)+"Série: "+aCabec[4,2]+chr(13)+chr(10)+substr(cError,1,150)
	EndIf

Return cError
