#Include 'protheus.ch'

//Função para Baixa de títulos de uma planilha no formato csv
User function ecoa004()

	Local aRet  := {}
	Local aPar  := {}

	Local cArqTxt := space(080)
	Local nCab  := 0
	Local aCbCab := {"1-Sim","2-Não"}
	Local cBco 	:= space(tamSx3("A6_COD")[1])
	Local cAge 	:= space(tamSx3("A6_AGENCIA")[1])
	Local cCta 	:= space(tamSx3("A6_NUMCON")[1])
	Local cHistBx := space(tamSx3("E5_HISTOR")[1])

	//cArqTxt := "c:\temp\NFSIS5816teste.csv"
	//cHistBx := "Inconsistência na programação - SIS-5816"

	aAdd(aPar,{6,"Arquivo CSV:"    ,cArqTxt,"","","",len(cArqTxt),.t.,"Arquivos (*.CSV) |*.CSV"})
	aAdd(aPar,{2,"Tem Cabeçalho:"  ,1,aCbCab,30,"",.t.})
	aAdd(aPar,{1,"Banco:"          ,cBco,"","","SA6",".t.",40,.t.})
	aAdd(aPar,{1,"Agência:"        ,cAge,"","","   ",".t.",40,.t.})
	aAdd(aPar,{1,"Conta:"          ,cCta,"","","   ",".t.",40,.t.})
	aAdd(aPar,{1,"Historico Baixa:",cHistBx,"","",""   ,".t.",80,.f.})
	//aAdd(aPar,{9,"O Arq CSV deve conter nas colunas 4,5,6,7, os campos prefixo,número,parcela e tipo respectivamente !",200,5,.t.})

	if ParamBox(aPar,"Parâmetros -",@aRet,,,,,,,,.t.,.t.)	//if ParamBox(aPar,"Parâmetros -",@aRet)
		cArqTxt := aRet[1]
		nCab	:= aRet[2]
		cBco 	:= aRet[3]
		cAge 	:= aRet[4]
		cCta 	:= aRet[5]
		cHistBx := aRet[6]
		Processa({|| ( ecoa004a(cArqTxt,nCab,cBco,cAge,cCta,cHistBx) ) },"Lendo arquivo Texto e baixando títulos...", "Processando aguarde...", .F.)
	endif

Return

Static function ecoa004a(cArqTxt,nCab,cBco,cAge,cCta,cHistBx)

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

	Local cStatus := ""	//Tem que ser igual a "Pago" para prosseguir com a baixa
	Local cBanArq := ""
	Local cAgeArq := ""
	Local cConArq := ""
	Local cPagto  := ""
	Local dpgto   := stod("")
	//Local cQtdPar := ""	//Qtd de parcelas vendidas
	Local cTid	  := ""	//Identificação da transação
	Local ntPar   := tamSx3("E1_PARCELA")[1]
	Local cPar	  := space(ntPar)	//Parcela que esta sendo paga
	Local cVlrBru := ""	//Valor bruto, valor da parcela
	Local cVlrLiq := ""	//Valor liquido, valor efetivamente recebido


	Local cPrefixo := space(tamSx3("E1_PREFIXO")[1])
	Local cNum     := space(tamSx3("E1_NUM")[1])
	Local cTipo    := "NF "	//space(tamSx3("E1_TIPO")[1])
	Local cHistor  	:= space(tamSx3("E5_HISTOR")[1])

	Local nVlrBru := 0	//Valor bruto, valor da parcela
	Local nVlrLiq := 0  //Valor liquido, valor efetivamente recebido
	Local nDesc := 0

	Local cAgel := alltrim(str(val(cAge))) 
	Local cCtal := alltrim(cCta)

	aadd(aCampos,{01,'cStatus',''})				//Tem que ser igual a "Pago" para prosseguir com a baixa
	aadd(aCampos,{04,'cBanArq',''})				//Banco do arquivo
	aadd(aCampos,{05,'cAgeArq',''})				//Agência do arquivo
	aadd(aCampos,{06,'cConArq',''})				//Conta do arquivo
	aadd(aCampos,{11,'cPagto' ,''})				//data do pagamento
	aadd(aCampos,{15,'cPar'   ,''})				//Parcela que esta sendo paga
	//aadd(aCampos,{13,'cQtdPar',''})			//Qtd de parcelas vendidas
	aadd(aCampos,{19,'cTid'   ,''})				//Identificação da transação
	aadd(aCampos,{22,'cVlrBru',''})				//Valor bruto, valor da parcela
	aadd(aCampos,{23,'cVlrLiq',''})				//Valor liquido, valor efetivamente recebido

	if !file(cArqTxt)
		Msgalert("Arquivo "+cArqTxt+" não encontrado!","Atenção")
		Return
	endif

	nHdl := fOpen(cArqTxt)			//abrir o arquivo em modo compartilhado de leitura e escrita
	If nHdl == -1
		MsgAlert("Arquivo "+cArqTxt+" nao pode ser aberto! ","Atenção")
		Return
	Endif
	nTamFile := fSeek(nHdl,0,2)		//tamanho total do arquivo

	sa6->(DbSetOrder(1))	//A6_FILIAL + A6_COD + A6_AGENCIA + A6_NUMCON
	sa6->( dbseek( xfilial()+cBco+cAge+cCta ) )

	sc5->(DbSetOrder(12))
	sc6->(DbSetOrder(1))

	ProcRegua(50)
	While nTamFile > nTBtLidos

		IncProc()
		nPos := nBuffer := 0
		while nPos == 0                              // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
			nPosFile := fSeek(nHdl,nPosFile,0)       // REPOSICIONA PONTEIRO DO ARQUIVO
			nBuffer  += 60                           // AUMENTA TAMANHO DO BUFFER
			cBuffer  := space(nBuffer)               // REALOCA BUFFER
			nBtLidos := fRead(nHdl,@cBuffer,nBuffer) // LE OS CARACTERES DO ARQUIVO
			nPos := at(cEol, cBuffer, 1)             // PROCURA O PRIMEIRO FINAL DE LINHA
		end
		nPosFile := fSeek(nHdl,nPosFile,0)      // REPOSICIONA PONTEIRO DO ARQUIVO
		nPos += 1                               // ACERTO FIM DE LINHA
		cBuffer  := space(nPos)                 // REALOCA BUFFER
		nBtLidos := fRead(nHdl,@cBuffer,nPos)   // LE OS CARACTERES DO ARQUIVO

		cLinha := cBuffer
		nlinhas += 1
		if !empty(cLinha) .and. (nCab == 2 .or. substr(cLinha,1,4) == "Pago")
			nOrdem := 0
			for nI := 1 to len(cLinha)
				if substr(cLinha,nI,1) == ";" .or. nI == 1
					nOrdem += 1
					nDado := aScan(aCampos,{|x| x[1] == nOrdem })
					if nDado > 0
						nColIni := nI + iif(substr(cLinha,nI,1) != ";",0,1)
						nColFim := at(";", cLinha, nColIni)
						&(aCampos[nDado,2]) := replace(substr(cLinha,nColIni,nColFim-nColIni),',','.')
					endif
				endif
			next

			cMens := ""

			if "bradesco" $ lower(cBanArq)
				cBanArq := "237"
			elseif "itau" $ lower(cBanArq) .or. "itaú" $ lower(cBanArq)
				cBanArq := "341"
			elseif "brasil" $ lower(cBanArq)
				cBanArq := "001"
			else
				cBanArq := alltrim(cBanArq)
			endif
			cAgeArq := cAgeArq
			cConArq := substr(cConArq,1, at("-",cConArq,1)-1 )

			if alltrim(cBco) == alltrim(cBanArq) .and. alltrim(cAgel) == alltrim(cAgeArq) .and. alltrim(cCtal) == alltrim(cConArq)

				if cStatus == "Pago" .and. sc5->( dbseek( xfilial()+cTid ) )

					if sc6->( dbseek( xfilial()+sc5->c5_num ) )

						cPrefixo := sc6->c6_serie
						cNum     := sc6->c6_nota
						if cPar == "0"
							cPar := space(ntPar)
						else
							cPar += space(ntPar-len(cPar))
						endif

						if se1->( dbseek( xfilial()+cPrefixo+cNum+cPar+cTipo ) )
							if se1->e1_saldo > 0

								cMotBx := "NOR"
								dpgto := ctod(cPagto)

								if !empty(cHistBx)
									cHistor := cHistBx
								else
									cHistor := "VALOR RECEBIDO S/ TITULO"
								endif

								nVlrBru := val(replace(cVlrBru,"R$",""))
								nVlrLiq := val(replace(cVlrLiq,"R$",""))
								nDesc := nVlrBru-nVlrLiq

								if !u_bxCtRec( 3, cPrefixo, cNum, cPar, cTipo, cMotBx, cBco, cAge, cCta, dpgto, dpgto, cHistor, nVlrLiq, nDesc, @cMens )
									MsgAlert(cMens,"Atenção")
								endif

							else
								MsgAlert("Não há saldo para baixar do título "+cPrefixo+cNum+cPar+cTipo+" !","Atenção")
							endif
						else
							MsgAlert("Não encontrou o  título: "+cPrefixo+cNum+cPar+cTipo+", na atual filial!","Atenção")
						endif
					endif

				else
					if cStatus == "Pago"
						MsgAlert("A transação "+cTid+" não foi encontrada !","Atenção")
					else
						MsgAlert("A transação "+cTid+" não esta com status de paga !","Atenção")
					endif
				endif
			else
				MsgAlert("O banco, agência ou conta da transação "+cTid+", não correspondem ao banco escolhido para sua liquidação !","Atenção")
			endif
		endif

		nPosFile += nPos
		nTBtLidos += nBtLidos
	End

	fClose(nHdl)
	MsgInfo(str(nlinhas) + " linhas da planilha processadas")

Return
