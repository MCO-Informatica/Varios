#Include 'protheus.ch'
#Include "topconn.ch"

//Função para Baixa de títulos de um arquivo, sem contabilização (MOTIVO BNC)
User function csfin34(cArqTxt)

	Local lJob 	  := ( Select( "SX6" ) == 0 )
	Local lBlind  := IsBlind()
	Local lCont   := .t.
	Local aRet      := {}
	Local aPar    := {}
	Local cJobEmp := '01'
	Local cJobFil := '02'
	Local cJobMod := 'FIN'

	If lJob
		RpcClearEnv()
		RpcSetType( 3 )
		RpcSetEnv( cJobEmp, cJobFil, , , cJobMod )
	endif

	Default cArqTxt := space(090)

	if !lBlind
		//aAdd(aPar,{1,"Arquivo CSV:",cArqTxt,"","","",".T.",0,.T.})
		aAdd(aPar,{6,"Arquivo CSV:",cArqTxt,"","","",len(cArqTxt),.t.,"Arquivos (*.CSV) |*.CSV"})
		aAdd(aPar,{9,"O Arq CSV deve conter nas colunas 1,2,3 os campos",200,7,.T.})
		aAdd(aPar,{9,"prefixo,número,parcela respectivamente!",200,7,.T.})
		aAdd(aPar,{9,"Todos os títuloS no csv, devem ser do tipo NCC!",200,7,.T.})
        aAdd(aPar,{9,"ESTE PROGRAMA PEGA COMPENSAÇÕES DOS TÍTULOS DO CSV,",200,7,.T.})
        aAdd(aPar,{9,"ALTERA DATA PRA 6/7/2021 BEM COMO A NATUREZA!",200,7,.T.})
		While lCont
			if ParamBox(aPar,"Parâmetros...",@aRet)
				cArqTxt := aPar[1,3] := aRet[1]
				if Empty(cArqTxt)
					Msgalert("Favor preencher o nome e local do arquivo CSV !","Atenção")
					Loop
				endif
				lCont := .f.
			else
				return
			endif
		end
	EndIf

	Processa({|| ( csfin34a(cArqTxt) ) },"Lendo arquivo Texto e baixando títulos...", "Processando aguarde...", .F.)

Return

Static function csfin34a(cArqTxt)

	Local nHdl    := 0
	Local cLinha  := ""
	Local nlinhas  := 0
	Local cEol     := Chr(13)+Chr(10)
	Local nBuffer  := 0                 // Define o tamanho da linha
	Local cBuffer  := Space(1)          // Variavel para criacao da linha do registro para leitura
	Local nTamFile := 0
	Local nBtLidos := 0
	Local nTBtLidos:= 0
	Local nPosFile := 0

	Local nI      := 0
	Local aCampos := {}
	Local nDado   := 0
	Local nOrdem  := 0
	Local nColIni := 0
	Local nColFim := 0

	Local cPrefixo := space(tamSx3("E1_PREFIXO")[1])
	Local cNum     := space(tamSx3("E1_NUM")[1])
	Local cParcela := space(tamSx3("E1_PARCELA")[1])
	//Local cCliente := space(tamSx3("E1_CLIENTE")[1])

	Local cSql := ""
	Local cTrb := GetNextAlias()
	Local cTmp := GetNextAlias()
	Local cTmp1:= GetNextAlias()

	aadd(aCampos,{1,'cPrefixo','E1_PREFIXO'})      //Ordem dos campos que serão usados para localizar o título
	aadd(aCampos,{2,'cNum','E1_NUM'})
	aadd(aCampos,{3,'cParcela','E1_PARCELA'})
	//aadd(aCampos,{4,'cCliente','E1_CLIENTE'})

	if !file(cArqTxt)
		Msgalert("Arquivo "+cArqTxt+" não encontrado!","Atenção")
		Return
	endif

	nHdl := fOpen(cArqTxt)                    //abrir o arquivo em modo compartilhado de leitura e escrita
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser aberto! ","Atenção")
		Return
	Endif
	nTamFile := fSeek(nHdl,0,2)   // tamanho total do arquivo

	se1->(DbSetOrder(1))
	ProcRegua(1)
	While nTamFile > nTBtLidos

		IncProc()
		nPos := nBuffer := 0
		while nPos == 0                              // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
			nPosFile := fSeek(nHdl,nPosFile,0)         // REPOSICIONA PONTEIRO DO ARQUIVO
			nBuffer  += 60                             // AUMENTA TAMANHO DO BUFFER
			cBuffer  := space(nBuffer)                 // REALOCA BUFFER
			nBtLidos := fRead(nHdl,@cBuffer,nBuffer)   // LE OS CARACTERES DO ARQUIVO
			nPos := at(cEol, cBuffer, 1)               // PROCURA O PRIMEIRO FINAL DE LINHA
		end

		nPosFile := fSeek(nHdl,nPosFile,0)      // REPOSICIONA PONTEIRO DO ARQUIVO
		nPos += 1                               // ACERTO FIM DE LINHA
		cBuffer  := space(nPos)                 // REALOCA BUFFER
		nBtLidos := fRead(nHdl,@cBuffer,nPos)   // LE OS CARACTERES DO ARQUIVO

		cLinha := cBuffer

		if !empty(cLinha)
			nOrdem := 0
			for nI := 1 to len(cLinha)
				if substr(cLinha,nI,1) == ";" .or. nI == 1
					nOrdem += 1
					nDado := aScan(aCampos,{|x| x[1] == nOrdem })
					if nDado > 0
						if nI == 1
							nColIni := 1
						else
							nColIni := nI + 1
						endif
						nColFim := at(";", cLinha, nColIni)
						&(aCampos[nDado,2]) := replace(substr(cLinha,nColIni,nColFim-nColIni),',','.')
						&(aCampos[nDado,2]) += space( tamSx3(aCampos[nDado,3])[1] - len(&(aCampos[nDado,2])) )
						&(aCampos[nDado,2]) := substr( &(aCampos[nDado,2]), 1, tamSx3(aCampos[nDado,3])[1]  )
					endif
				endif
			next

			cSql := "SELECT * FROM ( "
			cSql += "SELECT E5.R_E_C_N_O_ RECSE5,E5_PREFIXO PREF,E5_NUMERO,E5_PARCELA PAR,E5_TIPO,E5_CLIFOR CLI,"
			cSql += "E5_LOJA LJ,E5_VALOR,E5_MOTBX,E5_DOCUMEN,E5_DATA,E5_IDORIG,E5_TABORI,"
			cSql += "(SELECT E1_NATUREZ FROM "+RetSqlName("SE1")+" E1 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = E5_TIPO AND E1.D_E_L_E_T_ = ' ' ) NATSE1,"
			cSql += "(SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E11 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = E5_TIPO AND E11.D_E_L_E_T_ = ' ') EMITIT,"
			cSql += "(SELECT E1_EMISSAO FROM "+RetSqlName("SE1")+" E12 WHERE E1_FILIAL = E5_FILIAL AND E1_PREFIXO = E5_PREFIXO AND E1_NUM = E5_NUMERO AND E1_PARCELA = E5_PARCELA AND E1_TIPO = 'PR' AND E12.D_E_L_E_T_ = ' ') EMIPR,"
			cSql += "(SELECT MAX(E1_EMISSAO) FROM "+RetSqlName("SE1")+" E13 WHERE E1_FILIAL = E5_FILIAL AND E1_PEDIDO = SUBSTR(E5_NUMERO,1,6) AND E1_TIPO = 'NF' AND E13.D_E_L_E_T_ = ' ') EMINF "
			cSql += "FROM "+RetSqlName("SE5")+" E5 "
			cSql += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_PREFIXO = '"+cPrefixo+"' AND E5_NUMERO = '"+cNum+"' AND E5_PARCELA = '"+cParcela+"' AND E5_TIPO = 'NCC' AND E5.D_E_L_E_T_ = ' ' AND E5_MOTBX != ' ' AND E5_DOCUMEN != ' ' "
			cSql += ") "

			cSql := ChangeQuery( cSql )
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTrb,.F.,.T.)
			Conout( "INICIO PROCESSAMENTO BuscaTit csfin34 - "+dtoc(date())+"-"+time() )
			While !(cTrb)->( Eof() )

				SE5->( dbGoTo( (cTrb)->recse5 ) )

				SE5->( RecLock( "SE5", .F. ) )
				SE5->E5_DATA    := stod('20210706')
				SE5->E5_DTDIGIT := stod('20210706')
				SE5->E5_DTDISPO := stod('20210706')
				SE5->E5_NATUREZ := (cTrb)->NATSE1
				SE5->(MsUnLock())

				if SE5->E5_TABORI == "FK1"
					cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
					cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

					cSql := ChangeQuery( cSql )
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
					if !(cTmp)->( Eof() )

						FK1->( dbGoTo( (cTmp)->recfk1 ) )

						FK1->( RecLock( "FK1", .F. ) )
						FK1->FK1_DATA   := stod('20210706')
						FK1->FK1_DTDIGI := stod('20210706')
						FK1->FK1_DTDISP := stod('20210706')
						FK1->FK1_NATURE := (cTrb)->NATSE1
						FK1->(MsUnLock())
					endif
					(cTmp)->( dbCloseArea() )
					FErase( cTmp + GetDBExtension() )
				elseif SE5->E5_TABORI == "FK5"
					cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
					cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

					cSql := ChangeQuery( cSql )
					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
					if !(cTmp)->( Eof() )

						FK5->( dbGoTo( (cTmp)->recfk5 ) )

						FK5->( RecLock( "FK1", .F. ) )
						FK5->FK5_DATA   := stod('20210706')
						FK5->FK5_DTDISP := stod('20210706')
						FK5->FK5_NATURE := (cTrb)->NATSE1
						FK5->(MsUnLock())
					endif
					(cTmp)->( dbCloseArea() )
					FErase( cTmp + GetDBExtension() )
				endif
				Conout( "PROCESSAMENTO BuscaTit TITULO: "+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA )

				cSql := "SELECT E5.R_E_C_N_O_ RECSE5 FROM "+RetSqlName("SE5")+" E5 "
				cSql += "WHERE E5_FILIAL = '"+xFilial("SE5")+"' AND E5_PREFIXO = '"+substr(se5->e5_documen,1,3)+"' "
				cSql += "AND E5_NUMERO = '"+substr(se5->e5_documen,4,9)+"' AND E5_PARCELA = '"+substr(se5->e5_documen,13,2)+"' "
				cSql += "AND E5_TIPO = '"+substr(se5->e5_documen,15,3)+"' "
				cSql += "AND E5_CLIFOR = '"+se5->e5_clifor+"' AND E5_LOJA = '"+se5->e5_loja+"' AND E5.D_E_L_E_T_ = ' ' "
				cSql += "AND E5_DOCUMEN = '"+se5->e5_prefixo+se5->e5_numero+se5->e5_parcela+se5->e5_tipo+substr((cTrb)->e5_documen,18,2)+"' "

				cSql := ChangeQuery( cSql )
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp,.F.,.T.)
				While !(cTmp)->( Eof() )

					SE5->( dbGoTo( (cTmp)->recse5 ) )

					SE5->( RecLock( "SE5", .F. ) )
					SE5->E5_DATA    := stod('20210706')
					SE5->E5_DTDIGIT := stod('20210706')
					SE5->E5_DTDISPO := stod('20210706')
					SE5->E5_NATUREZ := (cTrb)->NATSE1
					SE5->(MsUnLock())

					if SE5->E5_TABORI == "FK1"
						cSql := "SELECT R_E_C_N_O_ RECFK1 FROM "+RetSqlName("FK1")+" WHERE FK1_FILIAL = '"+xFilial("FK1")+"' "
						cSql += "AND FK1_IDFK1 = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

						cSql := ChangeQuery( cSql )
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp1,.F.,.T.)
						if !(cTmp1)->( Eof() )

							FK1->( dbGoTo( (cTmp1)->recfk1 ) )

							FK1->( RecLock( "FK1", .F. ) )
							FK1->FK1_DATA   := stod('20210706')
							FK1->FK1_DTDIGI := stod('20210706')
							FK1->FK1_DTDISP := stod('20210706')
							FK1->FK1_NATURE := (cTrb)->NATSE1
							FK1->(MsUnLock())
						endif
						(cTmp1)->( dbCloseArea() )
						FErase( cTmp1 + GetDBExtension() )
					elseif SE5->E5_TABORI == "FK5"
						cSql := "SELECT R_E_C_N_O_ RECFK5 FROM "+RetSqlName("FK5")+" WHERE FK5_FILIAL = '"+xFilial("FK5")+"' "
						cSql += "AND FK5_IDMOV = '"+SE5->E5_IDORIG+"' AND D_E_L_E_T_ = ' ' "

						cSql := ChangeQuery( cSql )
						dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),cTmp1,.F.,.T.)
						if !(cTmp1)->( Eof() )

							FK5->( dbGoTo( (cTmp1)->recfk5 ) )

							FK5->( RecLock( "FK5", .F. ) )
							FK5->FK5_DATA   := stod('20210706')
							FK5->FK5_DTDISP := stod('20210706')
							FK5->FK5_NATURE := (cTrb)->NATSE1
							FK5->(MsUnLock())
						endif
						(cTmp1)->( dbCloseArea() )
						FErase( cTmp1 + GetDBExtension() )
					endif
					Conout( "PROCESSAMENTO BuscaTit TITULO: "+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA )

					(cTmp)->( dbSkip() )
				end

				(cTmp)->( dbCloseArea() )
				FErase( cTmp + GetDBExtension() )

				(cTrb)->( dbSkip() )
			end

			(cTrb)->( dbCloseArea() )
			FErase( cTrb + GetDBExtension() )

		endif
		nPosFile += nPos
		nTBtLidos += nBtLidos

		nlinhas += 1
	End

	fClose(nHdl)
	MsgInfo(str(nlinhas) + " linhas processadas")

Return
