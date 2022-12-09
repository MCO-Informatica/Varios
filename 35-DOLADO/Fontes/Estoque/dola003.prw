#Include 'Protheus.ch'
//#Include 'Colors.ch'

#define MARK     1
#define CODIGO   2
#define DESCPRO  3
#define UNIDADE  4
#define LOCAL    5
#define ENDERECO 6
#define QTDDISP  7
#define QTDTRAN  8
#define LOCDEST  9
#define ENDDEST  10

#define DS_MODALFRAME   128  // Sem o fechar window da tela

#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}

User Function dola003()

	//local aCores    := {}
	local cNomArq	:= ""
	local aColsEx	:= {}

	Local cDir := ""
	Local aArq := {}
	Local aColArq := {}

	Local nI := 0
	Local lOk := .t.

	cDir := alltrim(cGetFile("*.csv|*.csv|",'Importação Plan. p/ transferência Page', 1,'C:\', .t.,GETF_MULTISELECT + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY,.t.,.t.))
	aArq := Directory(cDir+"*.CSV")

	for nI := 1 TO Len(aArq)  //Nome      tamanho     data        hora
		if Right(aArq[nI,1],4) $ ".CSV|.csv"
			Aadd(aColArq, {  .f., aArq[nI,1], aArq[nI,2], aArq[nI,3], aArq[nI,4]  })
		endif
	next
	if !empty(cDir) .and. len(aColArq) > 0
		if len(aColArq) > 1
			dola003a(cDir,aColArq,@aColsEx,@lOk,@cNomArq)
		else
			Processa({|| ( dola003b(cDir,aColArq[1,2],@aColsEx,@lOk) ) },"Lendo arquivo Texto..."+aColArq[1,2], "Processando aguarde...", .F.)
			aColArq[1,1] := .t.
			cNomArq := alltrim(aColArq[1,2])
		endif
	elseif len(aColArq) == 0
		MsgAlert("Arquivo CSV Nenhum foi encontrado!")
	endif

	if lOk .and. len(aColsEx) > 0
		dola003c(cNomArq,@aColsEx,@lOk)
		if lOk .and. MsgYesNo("Faz inclusão de PV com itens referente aos produtos dos arquivos usados na transferência", "Inclusão da PV")
			fazPv(aColsEx,@lOk)
		endif
		if lOk
			for nI := 1 to Len(aColArq)
				if aColArq[nI,1]
					if fRename(cDir+aColArq[nI,2], cDir+aColArq[nI,2]+"Transfer") = -1
						MsgAlert("Error: " + str(fError()))
						lOk := .f.
					endif
				endif
			next
		endif
	endif

Return Nil


Static Function dola003a(cDir,aColArq,aColsEx,lOk,cNomArq)
	Local nI := 0

	Local lMark := .t.

	DEFINE MSDIALOG oDlg TITLE "Escolha os arquivos para importação, da pasta "+cDir FROM 000, 000  TO 500, 950 COLORS 0, 16777215 PIXEL

	@ 230, 010 BUTTON oButton2 PROMPT "Confirmar" SIZE 037, 012 action (oDlg:End(),lOk:=.t.) OF oDlg PIXEL
	@ 230, 060 BUTTON oButton1 PROMPT "Fechar" SIZE 037, 012 action (oDlg:End(),lOk:=.f.) OF oDlg PIXEL

	//lin, col        col lin
	oPnl1 := tPanel():New(001,001,,oDlg,,,,,,475,220)

	oBrw := fwBrowse():New()
	oBrw:setOwner( oPnl1 )
	oBrw:setDataArray()
	oBrw:setArray( aColArq )
	oBrw:disableConfig()
	oBrw:disableReport()
	oBrw:SetLocate() // Habilita a Localização de registros
	//Create Mark Column
	oBrw:AddMarkColumns({|| IIf(aColArq[oBrw:nAt,01], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrw, @lMark, aColArq)},; //Code-Block Double Click
	{|| SelectAll(oBrw, @lMark ,aColArq) }) //Code-Block Header Click
	oBrw:addColumn({"Arquivo"  , {||aColArq[oBrw:nAt,02]}, "C", "@!"            , 1,  50 ,  0  , .F. , , .F.,, "aColArq[oBrw:nAt,02]",, .F., .T.,  , "IdArq"  })
	oBrw:addColumn({"Tamanho"  , {||aColArq[oBrw:nAt,03]}, "N", "@E 999,999,999", 2,  11 ,  0  , .F. , , .F.,, "aColArq[oBrw:nAt,03]",, .F., .T.,  , "IdTam"  })
	oBrw:addColumn({"Data"     , {||aColArq[oBrw:nAt,04]}, "D", "@D"            , 1,  10 ,  0  , .F. , , .F.,, "aColArq[oBrw:nAt,04]",, .F., .T.,  , "IdDat"  })
	oBrw:addColumn({"Hora"     , {||aColArq[oBrw:nAt,05]}, "C", "@!"            , 1,  08 ,  0  , .F. , , .F.,, "aColArq[oBrw:nAt,05]",, .F., .T.,  , "IdHor"  })
	oBrw:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
	oBrw:Activate(.T.)

	ACTIVATE MSDIALOG oDlg CENTERED

	if lOk
		for nI := 1 to Len(aColArq)
			if aColArq[nI,1]
				Processa({|| ( dola003b(cDir,aColArq[nI,2],@aColsEx,@lOk) ) },"Lendo arquivo Texto..."+aColArq[nI,2], "Processando aguarde...", .F.)
				if lOk
					cNomArq += alltrim(aColArq[nI,2])+"; "
				else
					exit
				endif
			endif
		next
	endif

Return

Static Function SelectOne(oBrowse, lMark, aArquivo)

	aArquivo[oBrowse:nAt,MARK] := !lMark
	lMark := !lMark

	oBrowse:Refresh()

Return .t.

Static Function SelectAll(oBrowse, lMark, aArquivo)

	local nI := 0

	For nI := 1 to len(aArquivo)
		aArquivo[ni,MARK] := !lMark
	Next
	lMark := !lMark

	oBrowse:Refresh()

Return .t.


Static Function dola003b(cDir,cArq,aColsEx,lOk)

	Local nHdl    := 0
	Local cLinha  := ""
	Local nlinhas  := 0
	Local cEol     := Chr(13)+Chr(10)
	Local nBuffer  := 0                 // Define o tamanho da linha
	Local cBuffer  := Space(1)          // Variavel para criacao da linha do registro para leitura
	Local cBufferA := "A"
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

	Local cProduto := ''	//CÓDIGO DO PRODUTO
	Local cLocal   := ''	//ARMAZEM ORIGEM
	Local cEndereco:= ''	//ENDERE€O ORIGEM
	Local nDisp	   := 0
	Local nQuant   := 0		//QUANTIDADE
	Local cLocDes  := ''	//ARMAZEM DESTINO
	Local cEndDes  := ''	//ENDERE€O DESTINO

	//local aErroAuto := {}
	//Local cLogErro := ""
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description } )

	//Ordem dos campos que serão usados para localizar o título
	aadd(aCampos,{1,'cProduto' ,tamSx3('B1_COD')[1],'C','C'})
	aadd(aCampos,{2,'cLocal'   ,tamSx3('B2_LOCAL')[1],'C','N'})
	aadd(aCampos,{3,'cEndereco',tamSx3('B2_LOCALIZ')[1],'C','C'})
	aadd(aCampos,{4,'nQuant'   ,13,'N','N'})
	aadd(aCampos,{5,'cLocDes'  ,tamSx3('B2_LOCAL')[1],'C','N'})
	aadd(aCampos,{6,'cEndDes'  ,tamSx3('B2_LOCALIZ')[1],'C','C'})

	if !file(cDir+cArq,,.f.)
		Msgalert("Arquivo "+cDir+cArq+" não encontrado!","Atenção")
		Return
	endif

	nHdl := fOpen(cDir+cArq)                    //abrir o arquivo em modo compartilhado de leitura e escrita
	If nHdl == -1
		MsgAlert("O arquivo de nome "+cDir+cArq+" nao pode ser aberto! ","Atenção")
		Return
	Endif
	nTamFile := fSeek(nHdl,0,2)   // tamanho total do arquivo

	sb1->(dbSetOrder(1))

	Begin Sequence

		ProcRegua(1)
		While nTamFile > nTBtLidos

			IncProc()
			nPos := nBuffer := 0
			while nPos == 0 .and. cBufferA != cBuffer      // SE CARACTER DE FINAL DE LINHA NAO FOR ENCONTRADO
				nPosFile := fSeek(nHdl,nPosFile,0)         // REPOSICIONA PONTEIRO DO ARQUIVO
				nBuffer  += 60                             // AUMENTA TAMANHO DO BUFFER
				cBufferA := cBuffer
				cBuffer  := space(nBuffer)                 // REALOCA BUFFER
				nBtLidos := fRead(nHdl,@cBuffer,nBuffer)   // LE OS CARACTERES DO ARQUIVO
				nPos := at(cEol, cBuffer, 1)               // PROCURA O PRIMEIRO FINAL DE LINHA
			end
			if cBufferA == cBuffer .and. nPos == 0
				nPos += len(cBuffer)
			endif
			nPosFile := fSeek(nHdl,nPosFile,0)      // REPOSICIONA PONTEIRO DO ARQUIVO
			nPos += 1                               // ACERTO FIM DE LINHA
			cBuffer  := space(nPos)                 // REALOCA BUFFER
			nBtLidos := fRead(nHdl,@cBuffer,nPos)   // LE OS CARACTERES DO ARQUIVO

			cLinha := replace(cBuffer,cEol,"")

			if !empty(cLinha) .and. nlinhas > 0
				for nI := 1 to len(aCampos)
					&(aCampos[nI,2]) := ""
				next
				nOrdem := 0
				for nI := 1 to len(cLinha)
					if substr(cLinha,nI,1) == ";" .or. nI == 1
						nOrdem += 1
						nDado := aScan(aCampos,{|x| x[1]== nOrdem })
						if nDado > 0
							nColIni := nI + iif(substr(cLinha,nI,1)==";",1,0)
							nColFim := at(";", cLinha, nColIni)
							if nColFim == 0
								nColFim := len(cLinha)+1
							endif
							&(aCampos[nDado,2]) := replace(substr(cLinha,nColIni,nColFim-nColIni),',','.')
							//&(aCampos[nDado,2]) += space( aCampos[nDado,3] - len(&(aCampos[nDado,2])) )
							//&(aCampos[nDado,2]) := substr( &(aCampos[nDado,2]), 1, aCampos[nDado,3]  )
							if aCampos[nDado,4] == "N"
								&(aCampos[nDado,2]) := val(&(aCampos[nDado,2]))
							elseif aCampos[nDado,4] == "C"
								if aCampos[nDado,5] == "N"
									&(aCampos[nDado,2]) := strzero(val(&(aCampos[nDado,2])),aCampos[nDado,3])
								elseif aCampos[nDado,5] == "C"
									&(aCampos[nDado,2]) := padR(&(aCampos[nDado,2]),aCampos[nDado,3])
								endif
							endif
						endif
					endif
				next
				sb1->( dbSeek( xfilial()+cProduto ) )
				nDisp := u_verSaldo(cProduto,cLocal,cEndereco)
				aadd(aColsEx,{.t.,cProduto,sb1->b1_desc,sb1->b1_um,cLocal,cEndereco,nDisp,nQuant,cLocDes,cEndDes})

			endif

			nPosFile += nPos
			nTBtLidos += nBtLidos

			nlinhas += 1
		End

		fClose(nHdl)
		//MsgInfo(str(nlinhas) + " linhas processadas")

	End Sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	if !Empty(cError)	//Se houve erro, será mostrado ao usuário
		MsgAlert("Error: " + Substr(cError,1,150) + ". NA lEITURA DO ARQUIVO CSV, "+cDir+cArq )
		lOk := .f.
	endIf
return

Static function dola003c(cNomArq,aColsEx,lOk)

	local lMark := .t.

	local cCadastro := 'Tranferências de produtos por Planilha Eletrônica'

	local oDlg
	local oPnl
	local oBrw
	local oButton1
	local oButton2

	local oGet1

	local bSetGet
	local bValid := {|| .t. }
	local bWhen  := {|| .t. }
	local bChange := {|| }
	local lHasButton := .f.
	local lNoButton  := .t.
	local cLabelText := ""      //indica o texto que será apresentado na Label.
	local nLabelPos  := 1       //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000, 000 TO 500, 1300 COLORS 0, 16777215 pixel Style DS_MODALFRAME

	oDlg:lEscClose := .f.

	bSetGet := { |u| If(PCount()==0,cNomArq, cNomArq:= u) }
	cLabelText := "Nome(s) do(s) Arquivo(s): "
	oGet1 := TGet():New(010,005,bSetGet,oDlg,250,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cNomArq" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

	@ 010, 420 BUTTON oButton2 PROMPT "Confirmar"	SIZE 055, 012 action ( lOk:=fazTransfer(oBrw), iif(lOk,oDlg:End(),.f.) ) of oDlg pixel
	@ 010, 500 BUTTON oButton1 PROMPT "Fechar"		SIZE 055, 012 action ( lOk:=.f., oDlg:End() ) of oDlg pixel
	//lin,col       			     col,lin
	oPnl := tPanel():New(032,004,,oDlg,,,,,/*CLR_HCYAN*/,645,210)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA
	//oPnl:Align := CONTROL_ALIGN_ALLCLIENT

	oBrw:=fwBrowse():New()
	oBrw:setOwner( oPnl )
	oBrw:setDataArray()
	oBrw:setArray( aColsEx )
	oBrw:disableConfig()
	oBrw:disableReport()
	oBrw:SetLocate() // Habilita a localização de registros
	//Create Mark Column
	oBrw:AddMarkColumns({|| IIf(aColsEx[oBrw:nAt,MARK], "LBOK", "LBNO")},; //Code-Block image
	{|| SelectOne(oBrw, @lMark, aColsEx)},; //Code-Block Double Click
	{|| SelectAll(oBrw, @lMark ,aColsEx) }) //Code-Block Header Click
	oBrw:addColumn({"Código"   			, {||aColsEx[oBrw:nAt,CODIGO ]}, "C", "@!" 			   , 1,  15 ,  0  , .T. , , .F.,, "cCod" ,, .F., .T.,  , "cCod"  })
	oBrw:addColumn({"Descrição"			, {||aColsEx[oBrw:nAt,DESCPRO]}, "N", "@!"			   , 1,  40 ,  0  , .T. , , .F.,, "cDesc",, .F., .T.,  , "cDesc" })
	oBrw:addColumn({"Unidade"  			, {||aColsEx[oBrw:nAt,UNIDADE]}, "C", "@!"			   , 1,  02 ,  0  , .T. , , .F.,, "cUni" ,, .F., .T.,  , "cUni"  })
	oBrw:addColumn({"local"    			, {||aColsEx[oBrw:nAt,LOCAL  ]}, "C", "@!" 			   , 1,  02 ,  0  , .T. , , .F.,, "cLoc" ,, .F., .T.,  , "cLoc"  })
	oBrw:addColumn({"Endereço" 			, {||aColsEx[oBrw:nAt,ENDERECO]},"C", "@!" 			   , 1,  15 ,  0  , .T. , , .F.,, "cLoc" ,, .F., .T.,  , "cLoc"  })
	oBrw:addColumn({"Qtd Disponível"   	, {||aColsEx[oBrw:nAt,QTDDISP]}, "N", "@E 9,999,999.99", 2,  12 ,  2  , .T. , , .F.,, "nQDis",, .F., .T.,  , "nQDis" })
	oBrw:addColumn({"Qtd Transferência"	, {||aColsEx[oBrw:nAt,QTDTRAN]}, "N", "@E 9,999,999.99", 2,  12 ,  2  , .T. , , .F.,, "nQTra",, .F., .T.,  , "nQTra" })
	oBrw:addColumn({"local Desino"		, {||aColsEx[oBrw:nAt,LOCDEST]}, "C", "@!" 			   , 1,  02 ,  0  , .T. , , .F.,, "cLoc" ,, .F., .T.,  , "cLoc"  })
	oBrw:addColumn({"Endereço Destino"	, {||aColsEx[oBrw:nAt,ENDDEST]}, "C", "@!" 			   , 1,  15 ,  0  , .T. , , .F.,, "cLoc" ,, .F., .T.,  , "cLoc"  })

	oBrw:SetEditCell( .f. )      // Ativa edit and code block for validation
	//oBrw:SetInsert(.t.)                       // Indica que o usuário poderá inserir novas linhas no Browse.
	//oBrw:SetAddLine( { || AddLin(oBrw) } )	  // Indica a Code-Block executado para adicionar linha no browse.
	//oBrw:SetLineOk( { || VerLin(oBrw) } )     // Indica o Code-Block executado na troca de linha do Browse.
	//oBrw:SetChange({ || .t. })       		  //Indica a Code-Block executado após a mudança de uma linha.
	//oBrw:SetDelete(.t., { || DelLin(oBrw) } ) // Indica que o usuário pode excluir linhas no Browse.
	//oBrw:SetDelOk( { || verDel(oBrw) } ) 	  // Indica o Code-Block executado para validar a exclusão da linha.

	oBrw:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function fazTransfer(oBrw)

	local aAuto := {}
	local aLinha := {}

	local aLista := oBrw:oData:aArray //Os produtos a serem utilizados
	local nI	:= 0
	local nP    := 0
	local lFaz 	:= .t.
	local lFez 	:= .t.
	local cMens := ""

	local cTexto := "Somente os produtos com saldo maior ou igual ao solicitado serão transferidos."+Chr(13)+Chr(10)+"Confirma transferências de almoxarifado ?"

	sb1->(dbSetOrder(1))
	sb2->(dbSetOrder(1))
	nnr->(dbSetOrder(1))

	//Cabecalho a Incluir
	aadd(aAuto,{"",dDataBase}) //Cabecalho

	for nI := 1 to len(aLista)

		if aLista[nI,MARK]

			if aLista[nI,QTDDISP] >= aLista[nI,QTDTRAN]

				if nnr->( dbSeek( xfilial()+aLista[nI,LOCDEST] ) )

					lFaz := .t.

					If !sb2->(dbSeek(xFilial()+aLista[nI,CODIGO]+aLista[nI,LOCDEST],.f.))
						cTexto := 'Armazém '+aLista[nI,LOCDEST]+' ainda não existente para o produto '+aLista[nI,CODIGO]+' na filial '+sb2->(xFilial())+'.'+Chr(13)+Chr(10)
						cTexto += 'Deseja criar o armazém?'
						if MsgYesNo(cTexto, "Transferencia de Saldos")
							sb2->(RecLock('SB2',.t.))
							sb2->b2_filial := sb2->(xFilial())
							sb2->b2_cod    := aLista[nI,CODIGO]
							sb2->b2_local  := aLista[nI,LOCDEST]
							sb2->b2_localiz:= nnr->nnr_descri
							sb2->(MsUnLock())
						else
							lFaz := .f.
						EndIf
					EndIf

					if lFaz

						aLinha := {}
						sb1->(DbSeek(xFilial()+PadR(aLista[nI,CODIGO], tamsx3('D3_COD')[1] )))

						nP += 1

						aadd(aLinha,{"ITEM",'00'+cvaltochar(nP),Nil})

						//Origem
						aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //Cod Produto origem
						aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto origem
						aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida origem
						aadd(aLinha,{"D3_LOCAL", aLista[nI,LOCAL], Nil}) //armazem origem
						aadd(aLinha,{"D3_LOCALIZ", aLista[nI,ENDERECO],Nil}) //Informar endereÃ§o origem
						//Destino
						aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
						aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
						aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
						aadd(aLinha,{"D3_LOCAL", aLista[nI,LOCDEST], Nil}) //armazem destino
						aadd(aLinha,{"D3_LOCALIZ", aLista[nI,ENDDEST],Nil}) //Informar endereÃ§o destino

						aadd(aLinha,{"D3_NUMSERI", "", Nil}) //Numero serie
						aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote Origem
						aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote origem
						aadd(aLinha,{"D3_DTVALID", '', Nil}) //data validade
						aadd(aLinha,{"D3_POTENCI", 0, Nil}) // Potencia
						aadd(aLinha,{"D3_QUANT", aLista[nI,QTDTRAN], Nil}) //Quantidade
						aadd(aLinha,{"D3_QTSEGUM", 0, Nil}) //Seg unidade medida
						aadd(aLinha,{"D3_ESTORNO", "", Nil}) //Estorno
						aadd(aLinha,{"D3_NUMSEQ", "", Nil}) // Numero sequencia D3_NUMSEQ

						aadd(aLinha,{"D3_LOTECTL", "", Nil}) //Lote destino
						aadd(aLinha,{"D3_NUMLOTE", "", Nil}) //sublote destino
						aadd(aLinha,{"D3_DTVALID", '', Nil}) //validade lote destino
						aadd(aLinha,{"D3_ITEMGRD", "", Nil}) //Item Grade

						//aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod origem
						//aadd(aLinha,{"D3_CODLAN", "", Nil}) //cat83 prod destino

						aAdd(aAuto,aLinha)

					endif
				else
					lFez := .f.
					cMens := "O almoxarifado não esta cadastrado (NRR) !"
					MsgInfo(cMens, "Transferência cancelada!")
				EndIf
			else
				lFez := .f.
				cMens := "O produto "+alltrim(aLista[nI,CODIGO])+" no local/endereço "+alltrim(aLista[nI,LOCAL])+"/"+alltrim(aLista[nI,ENDERECO])+", não possui saldo sufiente para fazer a transferências !"
				MsgInfo(cMens, "Transferência cancelada!")
			endif

		endif

	Next nI

	if MsgYesNo(cTexto, "Transferência de Saldos")
		lFaz := .t.
		if !lFez
			if !MsgYesNo("Favor confirmar outra vez, pois tivemos problemas de saldo e de almoxarifado não existente para alguns produtos", "Transferência de Saldos")
				lFaz := .f.
			endif
			lFez := .t.
		endif
		if lFaz
			if len(aAuto) > 1
				lFez := u_fazTransfM(aAuto,3,@cMens)	//3 - Inclusao
				if lFez
					cMens := "Transferência realizada com sucesso !"
					MsgInfo(cMens, "Transferência")
				else
					MsgInfo(cMens, "Erro da transferência")
				endif
			else
				lFez := .f.
				cMens := "Nenhum item foi selecionado !"
				MsgInfo(cMens, "Transferência")
			endif
		endif
	else
		lFez := .f.
		cMens := "Transferência cancelada pelo usuário"
		MsgInfo(cMens, "Transferência cancelada!")
	endif

return lFez


Static Function fazPv(aPedIt,lOk)
	local nI := 0

	local aCabec := {}
	local aLinha := {}
	local aItens := {}

	local cCodCli := PadR("0013137151892",tamSx3("A1_COD")[1])
	local cLojCli := PadR("0000",tamSx3("A1_LOJA")[1])
	local cCondPg := "003"
	local cFormPg := "000000"

	local nX := 0
	local cProd := ""
	local cLocal :=  ""
	local nQtdVen:= 0
	local nPrcVen := 0
	local coper := ""
	local cTes := ""

	local nOpcAuto 	:= 3
	local cEvento := iif(nOpcAuto==3,"Inclusão","")
	local cMens := ""

	//sb1->(dbSetOrder(1))
	sa1->(DbSetOrder(1))
	sa1->(DbSeek(xFilial()+cCodCli+cLojCli))

	aadd(aCabec, {"C5_NUM"    , ""			,Nil})
	aadd(aCabec, {"C5_TIPO"   , "N"			,Nil})
	aadd(aCabec, {"C5_CLIENTE", sa1->a1_cod	,Nil})
	aadd(aCabec, {"C5_LOJACLI", sa1->a1_loja,Nil})
	//aadd(aCabec, {"C5_CLIENT ", sa1->a1_cod	,Nil})
	//aadd(aCabec, {"C5_LOJAENT", sa1->a1_loja,Nil})
	//aadd(aCabec, {"C5_TIPOCLI", sa1->a1_tipo,Nil})
	aadd(aCabec, {"C5_CONDPAG", cCondPg		,Nil})
	aadd(aCabec, {"C5_XFORMPG", cFormPg		,Nil})
	aadd(aCabec, {"C5_VOLUME1", 1			,Nil})
	aadd(aCabec, {"C5_ESPECI1", "BOX"		,Nil})
	aadd(aCabec, {"C5_MENNOTA", "NAO FATURAR",Nil})

	for nI := 1 to len(aPedIt)

		if aPedIt[nI, MARK]

			nX++
			cProd := aPedIt[nI, CODIGO]
			cLocal :=  aPedIt[nI, LOCDEST]
			nQtdVen	:= aPedIt[nI, QTDTRAN]
			nPrcVen := 1	//aPedIt[nI,?]
			coper := "F"
			cTes := "583"

			//sb1->(dbseek(xfilial()+cProd))

			aLinha := {}
			aadd(aLinha,{"C6_ITEM"   ,strzero(nX,2) ,Nil})
			aadd(aLinha,{"C6_PRODUTO",cProd			,Nil})
			aadd(aLinha,{"C6_LOCAL"	 ,cLocal		,Nil})
			aadd(aLinha,{"C6_QTDVEN" ,nQtdVen		,Nil})
			aadd(aLinha,{"C6_PRCVEN" ,nPrcVen		,Nil})
			aadd(aLinha,{"C6_QTDLIB" ,nQtdVen		,Nil})
			//aadd(aLinha,{"C6_OPER"   ,coper			,Nil})
			aadd(aLinha,{"C6_TES"    ,cTes			,Nil})
			aadd(aItens, aLinha)

		endif
	next

	if u_cadPedido(aCabec,aItens,nOpcAuto,@cMens)
		cMens := "Sucesso na "+cEvento+" do Pedido: "+cMens+" !"
	else
		lOk := .f.
		cMens := "Erro na "+cEvento+" do pedido: "+cMens
	endif
	if lOk
		Msgalert(cMens,cEvento+" de PV")
	endif

Return
