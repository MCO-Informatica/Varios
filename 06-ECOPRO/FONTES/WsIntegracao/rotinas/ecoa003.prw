#Include 'Protheus.ch'
//#Include 'Colors.ch'

#define MARK     1
#define CODIGO   2
#define LOCAL    3
#define DESCPRO  4
#define UNIDADE  5
#define QTDDISP  6
#define QTDTRAN  7

#define DS_MODALFRAME   128  // Sem o fechar window da tela

#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}

User Function ecoa003()

	//local aCores    := {}
	local aPar		:= {}
	local aRet		:= {}
	local cGruIni	:= space(04)
	local cGruFim	:= space(04)
	local cLocOri	:= space(02)
	local nPTrans   := 0
	local cQuery	:= ""
	local aColsEx	:= {}

	local lMark := .t.

	local cCadastro := 'Tranferências de produtos por Percentual para o Almoxarifado E-Commerce'

	local oDlg
	local oPnl
	local oBrw
	local oButton1
	local oButton2

	local oGet1
	local oGet2
	local oGet3
	local oGet4

	local bSetGet
	local bValid := {|| .t. }
	local bWhen  := {|| .t. }
	local bChange := {|| }
	local lHasButton := .f.
	local lNoButton  := .t.
	local cLabelText := ""      //indica o texto que será apresentado na Label.
	local nLabelPos  := 1       //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	aAdd(aPar,{1,"Grupo de"  ,cGruIni ,""      ,"","",".T.",20,.T.})
	aAdd(aPar,{1,"Grupo até" ,cGruFim ,""      ,"","",".T.",20,.T.})
	aAdd(aPar,{1,"local Orig",cLocOri	,""      ,"","",".T.",20,.T.})
	aAdd(aPar,{1,"%Tranfer." ,nPTrans ,"@E 999","","",".T.",20,.T.})

	aAdd(aPar,{9,"Programa que se destina a fazer tranferências do almoxarifado",190,7,.T.})
	aAdd(aPar,{9,"origem (parâmetro acima) para o almoxarifado do E-Commerce",190,7,.T.})
	aAdd(aPar,{9,"definido pelo parâmetro MV_XDESTI",190,7,.T.})

	if ParamBox(aPar,"Filtro das Tranferências...",@aRet,,,,,,,,.t.,.t.)

		cGruIni := aRet[1]
		cGruFim := aRet[2]
		cLocOri	:= aRet[3]
		nPTrans := aRet[4]

		cQuery := "select * from "+RetSQLName("SB2")+" b2 "
		cQuery += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+sb1->(xfilial())+"' and b1_cod = b2_cod and b1.d_e_l_e_t_ = ' ' "
		cQuery += "where b2_filial = '"+sc2->(xFilial())+"' and substring(b2_cod,1,4) in ('1000','2000','3000','4000') "
		cQuery += "and substring(b2_cod,1,4) >= '"+cGruIni+"' and substring(b2_cod,1,4) <= '"+cGruFim+"' "
		cQuery += "and b2_local  = '"+cLocOri+"' and b2.d_e_l_e_t_ = ' ' "

		cQuery := ChangeQuery( cQuery )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)

		if trb->( Eof() )
			MsgInfo("Nenhum produto encontratado!", "Inconsistência na transferência")
		else
			nPTrans := nPTrans/100
			sb2->(DbSetOrder(1))
			while !trb->( Eof() )
				//dbSelectArea(“SB2”)
				sb2->(dbSeek(trb->b2_filial+trb->b2_cod+trb->b2_local))
				nQtdDis := SaldoSb2()
				nQtdTra := nQtdDis*nPTrans
				if nQtdTra > 0 .and. nQtdTra < 1 .and. nQtdDis >= 1
					nQtdTra := 1
				else
					nQtdTra := round(nQtdDis*nPTrans,0)
				endif
				Aadd(aColsEx, { .t., trb->b2_cod, trb->b2_local, trb->b1_desc, trb->b1_um, nQtdDis, nQtdTra})
				trb->( DbSkip() )
			end
		endif

		trb->( DbCloseArea() )

		if len(aColsEx) > 0
			DEFINE MSDIALOG oDlg TITLE cCadastro FROM 000, 000 TO 500, 1100 COLORS 0, 16777215 pixel Style DS_MODALFRAME

			oDlg:lEscClose := .f.

			nPTrans := aRet[4]

			bSetGet := { |u| If(PCount()==0,cGruIni, cGruIni:= u) }
			cLabelText := "Do grupo: "
			oGet1 := TGet():New(010,005,bSetGet,oDlg,035,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cNumop" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

			bSetGet := { |u| If(PCount()==0,cGruFim, cGruFim:= u) }
			cLabelText := "Até Grupo: "
			oGet2 := TGet():New(010,080,bSetGet,oDlg,035,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"nQuant"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

			bSetGet := { |u| If(PCount()==0,cLocOri, cLocOri:= u) }
			cLabelText := "local: "
			oGet3 := TGet():New(010,160,bSetGet,oDlg,025,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cDesc"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

			bSetGet := { |u| If(PCount()==0,nPTrans, nPTrans:= u) }
			cLabelText := "%Perc: "
			oGet4 := TGet():New(010,240,bSetGet,oDlg,025,010,"@E 999" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cDesc"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

			@ 010, 400 BUTTON oButton2 PROMPT "Confirmar"		SIZE 055, 012 action iif(fazTransfer(oBrw),oDlg:End(),.f.)	of oDlg pixel
			@ 010, 480 BUTTON oButton1 PROMPT "Fechar"			SIZE 055, 012 action oDlg:End()								of oDlg pixel
			//lin,col       			     col,lin
			oPnl := tPanel():New(032,004,,oDlg,,,,,/*CLR_HCYAN*/,545,210)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA
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
			oBrw:addColumn({"local"    			, {||aColsEx[oBrw:nAt,LOCAL  ]}, "C", "@!" 			   , 1,  02 ,  0  , .T. , , .F.,, "cLoc" ,, .F., .T.,  , "cLoc"  })
			oBrw:addColumn({"Descrição"			, {||aColsEx[oBrw:nAt,DESCPRO]}, "N", "@!"			   , 1,  40 ,  0  , .T. , , .F.,, "cDesc",, .F., .T.,  , "cDesc" })
			oBrw:addColumn({"Unidade"  			, {||aColsEx[oBrw:nAt,UNIDADE]}, "C", "@!"			   , 1,  02 ,  0  , .T. , , .F.,, "cUni" ,, .F., .T.,  , "cUni"  })
			oBrw:addColumn({"Qtd Disponível"   	, {||aColsEx[oBrw:nAt,QTDDISP]}, "N", "@E 9,999,999.99", 2,  12 ,  2  , .T. , , .F.,, "nQDis",, .F., .T.,  , "nQDis" })
			oBrw:addColumn({"Qtd Transferência"	, {||aColsEx[oBrw:nAt,QTDTRAN]}, "N", "@E 9,999,999.99", 2,  12 ,  2  , .T. , , .F.,, "nQTra",, .F., .T.,  , "nQTra" })

			oBrw:SetEditCell( .f. )      // Ativa edit and code block for validation
			//oBrw:SetInsert(.t.)                       // Indica que o usuário poderá inserir novas linhas no Browse.
			//oBrw:SetAddLine( { || AddLin(oBrw) } )	  // Indica a Code-Block executado para adicionar linha no browse.
			//oBrw:SetLineOk( { || VerLin(oBrw) } )     // Indica o Code-Block executado na troca de linha do Browse.
			//oBrw:SetChange({ || .t. })       		  //Indica a Code-Block executado após a mudança de uma linha.
			//oBrw:SetDelete(.t., { || DelLin(oBrw) } ) // Indica que o usuário pode excluir linhas no Browse.
			//oBrw:SetDelOk( { || verDel(oBrw) } ) 	  // Indica o Code-Block executado para validar a exclusão da linha.

			oBrw:Activate(.t.)

			ACTIVATE MSDIALOG oDlg CENTERED
		endif

	endif

Return Nil

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

Static Function fazTransfer(oBrw)

	local aAuto := {}
	local aLinha := {}

	local aLista := oBrw:oData:aArray //Os produtos a serem utilizados
	local nI	:= 0
	local nP    := 0
	local lFaz 	:= .t.
	local lFez 	:= .t.
	local cMens := ""

	local cLocDes := GetNewPar("MV_XDESTI","XX")
	local cTexto := "Somente os produtos com saldo positivo serão transferidos."+Chr(13)+Chr(10)+"Confirma transferências para o almoxarifado "+cLocDes+" ?"

	if MsgYesNo(cTexto, "Transferencia de Saldos")

		sb1->(dbSetOrder(1))
		sb2->(dbSetOrder(1))
		nnr->(dbSetOrder(1))

		if nnr->( dbSeek( xfilial()+cLocDes ) )

			//Cabecalho a Incluir
			aadd(aAuto,{"",dDataBase}) //Cabecalho

			for nI := 1 to len(aLista)

				if aLista[nI,MARK] .and. aLista[nI,QTDDISP] > 0

					lFaz := .t.

					If !sb2->(dbSeek(xFilial()+aLista[nI,CODIGO]+cLocDes,.f.))
						cTexto := 'Armazém '+cLocDes+' ainda não existente para o produto '+aLista[nI,CODIGO]+' na filial '+sb2->(xFilial())+'.'+Chr(13)+Chr(10)
						cTexto += 'Deseja criar o armazém?'
						if MsgYesNo(cTexto, "Transferencia de Saldos")
							sb2->(RecLock('SB2',.t.))
							sb2->b2_filial := sb2->(xFilial())
							sb2->b2_cod    := aLista[nI,CODIGO]
							sb2->b2_local  := cLocDes
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
						aadd(aLinha,{"D3_LOCALIZ", PadR("", tamsx3('D3_LOCALIZ')[1]),Nil}) //Informar endereÃ§o origem
						//Destino
						aadd(aLinha,{"D3_COD", SB1->B1_COD, Nil}) //cod produto destino
						aadd(aLinha,{"D3_DESCRI", SB1->B1_DESC, Nil}) //descr produto destino
						aadd(aLinha,{"D3_UM", SB1->B1_UM, Nil}) //unidade medida destino
						aadd(aLinha,{"D3_LOCAL", cLocDes, Nil}) //armazem destino
						aadd(aLinha,{"D3_LOCALIZ", PadR("", tamsx3('D3_LOCALIZ')[1]),Nil}) //Informar endereÃ§o destino

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

				endif

			Next nI

			if len(aAuto) > 1
				lFez := u_fazTransferM(aAuto,3,@cMens)	//3 - Inclusao
				if lFez
					cMens := "Transferência realizada com sucesso !"
					MsgInfo(cMens, "Transferência")
				else
					MsgInfo(cMens, "Erro da transferência")
				endif
			else
				cMens := "Nenhum item foi selecionado !"
				MsgInfo(cMens, "Transferência")
			endif

		else
			lFez := .t.
			cMens := "O almoxarifado não esta cadastrado (NRR) !"
			MsgInfo(cMens, "Transferência cancelada!")
		endif

	else
		lFez := .t.
		cMens := "Transferência cancelada pelo usuário"
		MsgInfo(cMens, "Transferência cancelada!")
	endif

return lFez
