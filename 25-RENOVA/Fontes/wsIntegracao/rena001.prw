#Include 'Protheus.ch'
#Include 'Colors.ch'

#Define MATERIAL 1
#Define DESCPRO  2
#Define ARMAZEM  3
#Define ENDERECO 4
#Define QTDORIG  5
#Define QTDSOLI  6
#Define RESERVA  7
#Define CODRESE  8
#Define CONSUMO  9

#xtranslate bSetGet(<uVar>) => {|u| If(PCount()== 0, <uVar>,<uVar> := u)}

User Function rena001()

	local aCores	:= {}
	local cFilter	:= ""

	Private cCadastro := 'Demanda de materiais para manutenção'
	Private cDelFunc  := '.t.'
	Private aRotina   := {}
	Private cAlias    := 'SZM'

	aAdd( aCores, {'szm->zm_situa=="0"', 'BR_BRANCO' } )       // Programado
	aAdd( aCores, {'szm->zm_situa=="1"', 'BR_AMARELO' } )      // Devolvido-Programado
	aAdd( aCores, {'szm->zm_situa=="2"', 'BR_VERDE' } )        // Em Campo
	aAdd( aCores, {'szm->zm_situa=="3"', 'BR_PINK' } )         // Consumo informado
	aAdd( aCores, {'szm->zm_situa=="4"', 'BR_AZUL' } )         // Consumo confirmado
	aAdd( aCores, {'szm->zm_situa=="5"', 'BR_VERMELHO' } )     // Sol.Transf. Exec
	aAdd( aCores, {'szm->zm_situa=="6"', 'BR_CINZA' } )        // Cancelado

	aAdd( aRotina, { 'Pesquisar'    , 'AxPesqui'    , 0, 1 } )
	aAdd( aRotina, { 'Controlar'    , 'u_rena001a()', 0, 4 } )
	aAdd( aRotina, { 'Repr.Sol.Transfer.', 'u_renp105(szm->zm_demanda)', 0, 4 } )
	aAdd( aRotina, { 'Legenda'      , 'u_rena001leg()', 0, 4 } )

	DbSelectArea(cAlias)
	dbSetOrder(1)
	dbGoTop()
	mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

return Nil

User Function rena001leg()    // função para leenda colorida

	local aLegenda := {{"BR_BRANCO","Programado"},;
		{"BR_AMARELO","Devolvido-Programado"},;
		{"BR_VERDE"   , "Em Campo"},;
		{"BR_PINK"    , "Consumo informado"},;
		{"BR_AZUL"  , "Consumo confirmado"},;
		{"BR_VERMELHO", "Sol.Transf. Exec"},;
		{"BR_CINZA"   , "Cancelado"}}

	BrwLegenda(cCadastro,"Legenda",aLegenda)
return

User Function rena001a()

	local aArea := GetArea()
	local aAreaSm0 := sm0->(GetArea())

	local cOs := ""
	local cDemanda := ""
	local cStat := ""
	local dEmiss:= stod(" ")
	local dNeces:= stod(" ")
	local cDestino := ""
	local dDtfim := stod(" ")
	local cSolTrf := ""
	local aSitua := {	{"0","Programado"}, ;
		{"1","Devolvido-Programado"}, ;
		{"2","Em campo"}, ;
		{"3","Consumo informado"}, ;
		{"4","Consumo confirmado"}, ;
		{"5","Sol.Transf. Exec"}, ;
		{"6","Cancelado"} }
	/*
	0-Programado			- Indica que a programação dos materiais foi feita.
	1-Devolvido-Programado	- Indica que o material que foi a campo retornou,e voltou ao status de programado.
	2-Em campo				- Indica que o material foi entregue ao técnico para que a manutenção seja executada.
	3-Consumo informado		- Indica que o Cmms enviou o consumo dos materiais usados na manutenção. 
	4-Consumo confirmado	- Indica que o consumo está confirmado. 
			  				As operações necessárias de ajustes de estoque foram realizadas com sucesso e a transferência entre filiais 
							poderá ser feita.
	5-Sol.Transf. Exec		- Após verificação, se permitido, será executado a solicitação de transferência entre filiais.
							Esta operação não será realizada nesta tela.
	6-Cancelado				- Indica que a Demanda/OS foi cancelada.
	*/
	local cSql := ""
	local nExcSobr := 0

	local oDlg
	local oPnl1
	local oPnl2
	local oGet1,oGet2,oGet3,oGet4,oGet5,oGet6
	local oButton1
	local oButton2
	local oButton3
	local oButton4
	//local oButton5
	local oFont12N := tFont():New("Arial",12,12,,.t.,,,,.t.,.f.)

	local lHasButton := .f.
	local lNoButton  := .t.
	local cLabelText := ""    //indica o texto que será apresentado na Label.
	local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	//local bSetGet := {|| }
	local bValid := {|| .t. }
	local bWhen := {|| .t. }
	local bChange := {|| }

	Private oBrwIt
	Private aColsIt := {}
	Private cMate := ""
	Private cDesc := ""
	Private cArma := ""
	Private cEnde := ""
	Private nQori := 0
	Private nQsol := 0
	Private nQRes := 0
	Private cRes  := ""
	Private nCons := 0
	Private nCeS := 0
	Private cArmO := ""
	Private cCodSt := ""

	DbSelectArea("SZO")
	DbSelectArea("SZN")
	DbSelectArea("SZM")

	szm->(dbSetOrder(1))
	szn->(dbSetOrder(1))
	szo->(dbSetOrder(1))

	cOs := szm->zm_codios
	cDemanda := szm->zm_demanda

	dEmiss:= szm->zm_emissao
	cHora := szm->zm_hora
	dNeces := szm->zm_dtneces
	cDestino := szm->zm_destino
	cSolTrf := szm->zm_soltrf

	sm0->(dbSetOrder(1))
	sm0->(dbSeek(cEmpAnt+cDestino))
	cNomDes := sm0->m0_nomecom
	RestArea(aAreaSm0)
	RestArea(aArea)

	dDtfim := szm->zm_dtfim
	cHrFim := szm->zm_horafi

	cCodSt := szm->zm_situa
	cStat := aSitua[ aScan(aSitua,{|x| x[1] == cCodSt }), 2]

	cSql := "select * from "+RetSQLName("SZN")+" zn "
	cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+xFilial("SB1")+"' and b1_cod = zn_materia "
	cSql += "and b1.d_e_l_e_t_ = ' ' "
	cSql += "left join "+RetSQLName("SC0")+" c0 on c0_filial = '"+xFilial("SC0")+"' and c0_num = zn_codres "
	cSql += "and c0_produto = zn_materia and c0_local = zn_local and c0_localiz = zn_localiz and c0.d_e_l_e_t_ = ' ' "
	cSql += "where zn_filial = '"+xFilial("SZN")+"' and zn_demanda = '"+cDemanda+"' "
	cSql += "and zn.d_e_l_e_t_ = ' ' order by zn_materia"
	cSql := ChangeQuery( cSql )
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
	while !trb->( Eof() )
		nExcSobr := iif(cCodSt>"2",trb->zn_quant-trb->zn_qtdcons,0)
		Aadd(aColsIt, { trb->zn_materia, trb->b1_desc, trb->zn_local, trb->zn_localiz, trb->zn_qorig, trb->zn_quant, trb->c0_quant, trb->c0_num, trb->zn_qtdcons, nExcSobr } )
		trb->( DbSkip() )
	End
	trb->( DbCloseArea() )

	DEFINE MSDIALOG oDlg TITLE "Controle dos Itens na manutenção" FROM 000, 000  TO 615, 1398 COLORS 0, 16777215 PIXEL
	//					lin,col                     col,lin
	oPnl1:= tPanel():New(000,000,,oDlg,,,,,CLR_HCYAN,700,063)
	oPnl2:= tPanel():New(063,000,,oDlg,,,,,CLR_HGRAY,700,245)

	//@ 015, 475 BUTTON oButton5 PROMPT "Reservar"           SIZE 055, 015 action iif(reseMat(cDemanda,oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL
	@ 015, 515 BUTTON oButton5 PROMPT "Receber Devolução"  SIZE 055, 015 action iif(devoMat(cDemanda,oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL
	@ 015, 580 BUTTON oButton3 PROMPT "Entregar Materiais" SIZE 055, 015 action iif(entrMat(cDemanda,oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL
	@ 015, 645 BUTTON oButton4 PROMPT "Rastro"             SIZE 045, 015 action verRast(cDemanda,oBrwIt)					 OF oPnl1 PIXEL
	@ 035, 580 BUTTON oButton2 PROMPT "Confirmar Consumo"  SIZE 055, 015 action iif(procFim(cDemanda,oBrwIt),oDlg:End(),.f.) OF oPnl1 PIXEL
	@ 035, 645 BUTTON oButton1 PROMPT "Sair"               SIZE 045, 015 action oDlg:End() 									 OF oPnl1 PIXEL

	cLabelText := "OS código:"
	oGet1 := TGet():New(005,003,bSetGet(cOs)   ,oPnl1,120,013,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cOs"    ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet1:lcangotfocus := .f.
	cLabelText := "Demanda:"
	oGet2 := TGet():New(005,145,bSetGet(cDemanda) ,oPnl1,030,013,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cDemanda"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet2:lcangotfocus := .f.
	cLabelText := "Status:"
	oGet3 := TGet():New(005,215,bSetGet(cStat) ,oPnl1,135,013,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cStat"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet3:lcangotfocus := .f.
	oGet3:SetColor(CLR_HRED,)
	cLabelText := "Emissão:"
	oGet4 := TGet():New(005,365,bSetGet(dEmiss),oPnl1,055,013,"@D" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"dEmiss" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet4:lcangotfocus := .f.

	cLabelText := "Necessidade:"
	oGet5 := TGet():New(033,003,bSetGet(dNeces),oPnl1,055,013,"@!" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"dNeces" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet5:lcangotfocus := .f.
	cLabelText := "Destino:"
	oGet6 := TGet():New(033,070,bSetGet(cDestino),oPnl1,030,013,"@!",bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cDestino"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet6:lcangotfocus := .f.
	cLabelText := "Nome"
	oGet2 := TGet():New(033,145,bSetGet(cNomDes),oPnl1,205,013,"@!",bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cDemanda"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet2:lcangotfocus := .f.
	cLabelText := "Dt Fim: "
	oGet7 := TGet():New(033,365,bSetGet(dDtfim),oPnl1,055,013,"@D" ,bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"dDtfim" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet7:lcangotfocus := .f.
	cLabelText := "Sol. Transf.: "
	oGet8 := TGet():New(033,440,bSetGet(cSolTrf),oPnl1,055,013,"@!",bValid,,,oFont12N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cSolTrf" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet8:lcangotfocus := .f.

	/*******************************************************/
	oBrwIt:=fwBrowse():New()
	oBrwIt:setOwner( oPnl2 )
	oBrwIt:setDataArray()
	oBrwIt:setArray( aColsIt )
	oBrwIt:disableConfig()
	oBrwIt:disableReport()
	oBrwIt:SetLocate() // Habilita a localização de registros
	//oBrwIt:SetLineOk( {||  } )
	//oBrwIt:SetChange( {||  } )
	//oBrwIt:SetDoubleClick( { || oBrwIt:oData:aArray[oBrwIt:nAt,CONTAGEM] := fazContagem(oBrwIt:oData:aArray[oBrwIt:nAt]) } )
	// Cria uma coluna de status
	//oBrwIt:AddStatusColumns({||Iif(!empty(aColsIt[oBrwIt:nAt,CONTAGEM]),'BR_VERDE','BR_VERMELHO')},{|oBrwIt|/*Função de DOUBLECLICK*/})

	// Adiciona legenda no Browse
	oBrwIt:AddLegend('cCodSt <= "2" .and. empty(aColsIt[oBrwIt:nAt,08]) '				   ,"BROWN" ,"Não Reservado")
	oBrwIt:AddLegend('cCodSt <= "2" .and. aColsIt[oBrwIt:nAt,06] == aColsIt[oBrwIt:nAt,07]',"GREEN" ,"Reservado")
	oBrwIt:AddLegend('cCodSt <= "2" .and. aColsIt[oBrwIt:nAt,06] > aColsIt[oBrwIt:nAt,07]' ,"RED"	,"Reserva Parcial")
	oBrwIt:AddLegend('cCodSt >= "3" .and. aColsIt[oBrwIt:nAt,06] == aColsIt[oBrwIt:nAt,09]',"BLUE"  ,"Consumido")
	oBrwIt:AddLegend('cCodSt >= "3" .and. aColsIt[oBrwIt:nAt,06] > aColsIt[oBrwIt:nAt,09]' ,"YELLOW","Com Sobra")
	oBrwIt:AddLegend('cCodSt >= "3" .and. aColsIt[oBrwIt:nAt,06] < aColsIt[oBrwIt:nAt,09]' ,"BLACK" ,"Com Excesso")

	oBrwIt:addColumn({"Material"   , {||aColsIt[oBrwIt:nAt,01]}, "C", "@!"            ,1 ,15 ,  , .F./*lEdicao*/, , .F., , "cMate" , , .F., .T./*lExibeCol*/,  , "cMate" })
	oBrwIt:addColumn({"Descrição"  , {||aColsIt[oBrwIt:nAt,02]}, "C", "@!"            ,1 ,40 ,  , .F./*lEdicao*/, , .F., , "cDesc" , , .F., .T./*lExibeCol*/,  , "cDesc" })
	oBrwIt:addColumn({"Armazém"    , {||aColsIt[oBrwIt:nAt,03]}, "C", "@!"            ,1 ,05 ,  , .F./*lEdicao*/, , .F., , "cArma" , , .F., .T./*lExibeCol*/,  , "cArma" })
	oBrwIt:addColumn({"Endereço"   , {||aColsIt[oBrwIt:nAt,04]}, "C", "@!"            ,1 ,15 ,  , .F./*lEdicao*/, , .F., , "cEnde" , , .F., .T./*lExibeCol*/,  , "cEnde" })
	oBrwIt:addColumn({"Qtd Orig."  , {||aColsIt[oBrwIt:nAt,05]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nQori" , , .F., .T./*lExibeCol*/,  , "nQori" })
	oBrwIt:addColumn({"Qtd Solic." , {||aColsIt[oBrwIt:nAt,06]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nQsol" , , .F., .T./*lExibeCol*/,  , "nQsol" })
	oBrwIt:addColumn({"Reservado"  , {||aColsIt[oBrwIt:nAt,07]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nQRes" , , .F., .T./*lExibeCol*/,  , "nQRes" })
	oBrwIt:addColumn({"Cód.Reser"  , {||aColsIt[oBrwIt:nAt,08]}, "C", "@!"            ,1 ,06 ,  , .F./*lEdicao*/, , .F., , "cRes"  , , .F., .T./*lExibeCol*/,  , "cRes"  })
	oBrwIt:addColumn({"Consumido"  , {||aColsIt[oBrwIt:nAt,09]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nCons" , , .F., .T./*lExibeCol*/,  , "nCons" })
	oBrwIt:addColumn({"Exce/Sobra" , {||aColsIt[oBrwIt:nAt,10]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nCeS"  , , .F., .T./*lExibeCol*/,  , "nCeS"  })
	//oBrwIt:addColumn({"Armaz.Oper" , {||aColsIt[oBrwIt:nAt,10]}, "C", "@!"            ,1 ,05 ,  , .F./*lEdicao*/, , .F., , "cArmO" , , .F., .T./*lExibeCol*/,  , "cArmO" })
	//oBrwIt:addColumn({"Ender.Oper" , {||aColsIt[oBrwIt:nAt,11]}, "C", "@!"            ,1 ,15 ,  , .F./*lEdicao*/, , .F., , "cEndO" , , .F., .T./*lExibeCol*/,  , "cEndO" })

	//oBrwIt:setEditCell( .t. , { || .t. } ) //activa edit and code block for validation

	oBrwIt:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

return

Static Function entrMat(cDemanda,oBrwIt)
	local lRet := .t.
	local aObj := oBrwIt:oData:aArray
	local nI := 0

	Local cMaterial := ""
	Local nQtdsol := 0
	Local nQtdres := 0

	szm->(dbSetOrder(1))
	if szm->(dbSeek(xFilial()+cDemanda))
		if szm->zm_situa > "1"
			MsgInfo("Material demandado Já foi entregue", "Entrega Material")
			lRet := .f.
		else
			for nI := 1 to len(aObj)
				cMaterial := aObj[nI,MATERIAL]
				nQtdsol := aObj[nI,QTDSOLI]
				nQtdres := aObj[nI,RESERVA]
				if nQtdsol != nQtdres
					lRet := .f.
					MsgInfo("A qtd programada do material "+cMaterial+" não esta iqual a qtd resevada", "Entrega Material")
				endif
			next
			if lRet
				szm->(RecLock("szm",.f.))
				szm->zm_situa := '2'
				szm->(MsUnLock())
				MsgInfo("Demanda entregue!", "Entrega Material")
			endif
		endif
	else
		MsgInfo("Demanda Não foi encontrada", "Entrega Material")
		lRet := .f.
	endif

return lRet


Static Function devoMat(cDemanda,oBrwIt)
	local lRet := .t.
	local aObj := oBrwIt:oData:aArray
	local nI := 0

	Local cMaterial := ""
	Local nQtdsol := 0
	Local nQtdres := 0

	szm->(dbSetOrder(1))
	if szm->(dbSeek(xFilial()+cDemanda))
		if szm->zm_situa != "2"
			MsgInfo("Material demandado não esta em campo", "Devolução Material")
			lRet := .f.
		else
			for nI := 1 to len(aObj)
				cMaterial := aObj[nI,MATERIAL]
				nQtdsol := aObj[nI,QTDSOLI]
				nQtdres := aObj[nI,RESERVA]
				if nQtdsol != nQtdres
					lRet := .f.
					MsgInfo("A qtd programada do material "+cMaterial+" não esta iqual a qtd resevada", "Devolução Material")
				endif
			next
			if lRet
				szm->(RecLock("szm",.f.))
				szm->zm_situa := '1'
				szm->(MsUnLock())
				MsgInfo("Materiais devolvidos!", "Devolução Material")
			endif
		endif
	else
		MsgInfo("Demanda Não foi encontrada", "Devolução Material")
		lRet := .f.
	endif

return lRet


Static Function procFim(cDemanda,oBrwIt)

	lRet := .t.

	if !confCon(cDemanda,oBrwIt)
		lRet := .f.
	else
		if !u_renp105(cDemanda,oBrwIt)
			lRet := .f.
		endif
	endif

return lRet


Static Function confCon(cDemanda,oBrwIt)
	local lRet := .t.
	local aObj := oBrwIt:oData:aArray
	local nI := 0
	local cMens := ""

	Local cMaterial := ""
	Local cArmazem := ""
	Local cEndereco := ""
	Local cCodRes := ""
	Local nQtdsol := 0
	Local nQtdres := 0
	Local nQtdCon := 0

	Local nQtdDP := 0
	Local cLocDP := space(TamSx3("B2_LOCAL")[1])
	Local cEndDP := space(TamSx3("BF_LOCALIZ")[1])

	Local nqtdTrf := 0
	Local cLocOri := ""
	Local cEndOri := ""
	Local cLocDes := ""
	Local cEndDes := ""

	szm->(dbSetOrder(1))
	if szm->(dbSeek(xFilial()+cDemanda))
		if szm->zm_situa != "3"
			if szm->zm_situa > "3"
				cMens := "Consumo materiais demandados Já foi confirmado"
			else
				cMens := "Consumo materiais demandados ainda não foi informado"
			endif
			MsgInfo(cMens, "Confirma Consumo")
			lRet := .f.
		else
			for nI := 1 to len(aObj)
				cMaterial := aObj[nI,MATERIAL]
				cArmazem := aObj[nI,ARMAZEM]
				cEndereco := aObj[nI,ENDERECO]
				nQtdsol := aObj[nI,QTDSOLI]
				nQtdres := aObj[nI,RESERVA]
				nQtdCon := aObj[nI,CONSUMO]
				if nQtdres != nQtdCon
					if nQtdsol != nQtdres
						lRet := .f.
						MsgInfo("A qtd programada do material "+cMaterial+" não esta iqual a qtd resevada", "Confirma Consumo")
					elseif nQtdCon > nQtdSol
						nSldAtu := u_verSaldo(cMaterial,cArmazem,cEndereco)
						if nSldAtu < nQtdCon-nQtdSol
							lRet := .f.
							MsgInfo("O material "+cMaterial+'/'+cArmazem+'/'+alltrim(cEndereco)+" não possui estoque para atender o consumo.", "Confirma Consumo")
						endif
					endif
				endif
			next
		endif

	else
		MsgInfo("Demanda Não foi encontrada", "Confirma Consumo")
		lRet := .f.
	endif

	if lRet
		szo->(dbSetOrder(1))
		for nI := 1 to len(aObj)
			cMaterial := aObj[nI,MATERIAL]
			cArmazem := aObj[nI,ARMAZEM]
			cEndereco := aObj[nI,ENDERECO]
			cCodRes := aObj[nI,CODRESE]
			nQtdsol := aObj[nI,QTDSOLI]
			nQtdres := aObj[nI,RESERVA]
			nQtdCon := aObj[nI,CONSUMO]
			if nQtdCon != nQtdres
				if nQtdCon < nQtdres
					lRet := u_altReserva(cCodRes,cMaterial,cArmazem,cEndereco,@nQtdCon,@cMens)
				endif
				if lRet .and. szo->(dbSeek(xFilial()+cDemanda+cMaterial+cArmazem+cEndereco))
					while !szo->(eof()) .and. cDemanda == szo->zo_demanda .and. ;
					cMaterial == szo->zo_materia .and. cArmazem == szo->zo_local .and. cEndereco == szo->zo_localiz
						nQtdDP := szo->zo_quant
						cLocDP := szo->zo_adesori
						cEndDP := szo->zo_edesori
						if cArmazem+cEndereco != cLocDP+cEndDP
							if nQtdCon > nQtdres
								nqtdTrf := nQtdDP
								cLocOri := cLocDP
								cEndOri := cEndDP
								cLocDes := cArmazem
								cEndDes := cEndereco
							else
								nqtdTrf := nQtdDP
								cLocOri := cArmazem
								cEndOri := cEndereco
								cLocDes := cLocDP
								cEndDes := cEndDP
							endif
							if !u_renp090({{cMaterial,nqtdTrf,cLocOri,cEndOri,cLocDes,cEndDes}},@cMens)
								lRet := .f.
							endif
						endif
						szo->(dbskip())
					end
				endif
				if lRet .and. nQtdCon > nQtdres
					lRet := u_altReserva(cCodRes,cMaterial,cArmazem,cEndereco,@nQtdCon,@cMens)
				endif
			endif
		next
		if lRet
			szm->(RecLock("szm",.f.))
			szm->zm_situa := '4'
			szm->(MsUnLock())
		endif
	endif
return lRet


Static Function verRast(cDemanda,oBrwIt)

	local aObj := oBrwIt:oData:aArray
	local nI := oBrwIt:nAt
	local cSql := ""

	local cMaterial := ""
	local cDescri	:= ""
	local cArmazem := ""
	local cEndereco := ""

	local oDlg1
	local oPnl1
	local oPnl2
	local oGet1,oGet2,oGet3,oGet4
	local oButton1
	local oFont08N := tFont():New("Arial",08,08,,.t.,,,,.t.,.f.)
	local oFont10N := tFont():New("Arial",10,10,,.t.,,,,.t.,.f.)

	local lHasButton := .f.
	local lNoButton  := .t.
	local cLabelText := ""    //indica o texto que será apresentado na Label.
	local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	//local bSetGet := {|| }
	local bValid := {|| .t. }
	local bWhen := {|| .t. }
	local bChange := {|| }

	Private oBrw2
	Private aCols2 := {}
	Private cArmaz := ""
	Private cEnder := ""
	Private nQuant := 0
	Private cMovim := ""

	if empty(aObj)
		MsgInfo("Não temos Itens nessa demada. Ela deve esta cancelada!")
		return
	endif

	cMaterial := aObj[nI,MATERIAL]
	cDescri	:= aObj[nI,DESCPRO]
	cArmazem := aObj[nI,ARMAZEM]
	cEndereco := aObj[nI,ENDERECO]

	cSql := "select * from "+RetSQLName("SZO")+" zo "
	cSql += "where zo_filial = '"+xFilial("SZO")+"' and zo_demanda = '"+cDemanda+"' "
	cSql += "and zo_materia = '"+cMaterial+"' and zo_local = '"+cArmazem+"' and zo_localiz = '"+cEndereco+"' "
	cSql += "and zo.d_e_l_e_t_ = ' ' "
	cSql := ChangeQuery( cSql )
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"tr2",.f.,.t.)
	while !tr2->( Eof() )
		cMovim := iif(tr2->zo_tpmov=="D","Destino","Origem")
		nQuant := tr2->zo_quant
		if tr2->zo_tpmov == "D"
			nQuant *= -1
		endif
		Aadd(aCols2, { tr2->zo_adesori,tr2->zo_edesori,nQuant,cMovim} )
		tr2->( DbSkip() )
	End
	tr2->( DbCloseArea() )

	if len(aCols2) == 0
		MsgInfo("Não tivemos movimentos para ajustar o consumo!")
		return
	endif

	DEFINE MSDIALOG oDlg1 TITLE "Rastreabilidade" FROM 000, 000  TO 308, 600 COLORS 0, 16777215 PIXEL
	//					lin,col                     col,lin
	oPnl1:= tPanel():New(000,000,,oDlg1,,,,,CLR_HCYAN,305,053)
	oPnl2:= tPanel():New(053,000,,oDlg1,,,,,CLR_HGRAY,305,245)

	@ 037, 245 BUTTON oButton1 PROMPT "Sair"               SIZE 045, 015 action oDlg1:End() 							OF oPnl1 PIXEL

	cLabelText := "Material:"
	oGet1 := TGet():New(005,003,bSetGet(cMaterial),oPnl1,113,013,"@!" ,bValid,,,oFont10N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cMaterial" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet1:lcangotfocus := .f.
	cLabelText := "Descrição:"
	oGet2 := TGet():New(005,120,bSetGet(cDescri)  ,oPnl1,180,013,"@!" ,bValid,,,oFont08N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cDescri"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet2:lcangotfocus := .f.
	cLabelText := "Armazém:"
	oGet3 := TGet():New(030,003,bSetGet(cArmazem) ,oPnl1,050,013,"@!" ,bValid,,,oFont10N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cArmazem"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet3:lcangotfocus := .f.
	oGet3:SetColor(CLR_HRED,)
	cLabelText := "Endereço:"
	oGet4 := TGet():New(030,120,bSetGet(cEndereco),oPnl1,110,013,"@D" ,bValid,,,oFont10N,.F.,,.T.,,.F.,bWhen,,,bChange,.T./*lReadOnly*/,.F./*lPassword*/,,"cEndereco" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*oFont*/,/*nLabelColor*/,,,/*lFocSel*/)
	oGet4:lcangotfocus := .f.

	/*******************************************************/
	oBrw2:=fwBrowse():New()
	oBrw2:setOwner( oPnl2 )
	oBrw2:setDataArray()
	oBrw2:setArray( aCols2 )
	oBrw2:disableConfig()
	oBrw2:disableReport()
	oBrw2:SetLocate() // Habilita a localização de registros

	oBrw2:addColumn({"Armazém"    , {||aCols2[oBrw2:nAt,01]}, "C", "@!"            ,1 ,05 ,  , .F./*lEdicao*/, , .F., , "cArmaz" , , .F., .T./*lExibeCol*/,  , "cArmaz" })
	oBrw2:addColumn({"Endereço"   , {||aCols2[oBrw2:nAt,02]}, "C", "@!"            ,1 ,15 ,  , .F./*lEdicao*/, , .F., , "cEnder" , , .F., .T./*lExibeCol*/,  , "cEnder" })
	oBrw2:addColumn({"Quantidade" , {||aCols2[oBrw2:nAt,03]}, "N", "@E 999,999.99" ,2 ,10 ,2 , .F./*lEdicao*/, , .F., , "nQuant" , , .F., .T./*lExibeCol*/,  , "nQuant" })
	oBrw2:addColumn({"Movimento"  , {||aCols2[oBrw2:nAt,04]}, "C", "@!"            ,1 ,10 ,  , .F./*lEdicao*/, , .F., , "cMovim" , , .F., .T./*lExibeCol*/,  , "cMovim" })

	oBrw2:Activate(.t.)

	ACTIVATE MSDIALOG oDlg1 CENTERED

return

/*
Static Function reseMat(cDemanda,oBrwIt)

	local aObj := oBrwIt:oData:aArray
	local nI   := oBrwIt:nAt
	local lRet := .t.
	local nSldAtu := 0
	local nQtdaSol := 0
	Local lAchou := .f.

	local cArmazem := aObj[nI, ARMAZEM]
	local cEndereco := aObj[nI, ENDERECO]
	local cMaterial := aObj[nI, MATERIAL]
	local nQtdSol := aObj[nI, QTDSOLI]
	local nReserva := aObj[nI, RESERVA]
	local cReserva := aObj[nI, CODRESE]

	local aOperacao := {}
	local aLote	:= {"","",cEndereco,""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	Private aHeader := {}
	Private aCols	:= {}

	if !empty(cReserva) .and. nQtdSol == nReserva
		msginfo("O material "+cMaterial+'/'+cArmazem+'/'+alltrim(cEndereco)+" está reservado sob o Nº: "+cReserva,"Inconsistência")
		lRet := .f.
	elseif !empty(cReserva) .and. nQtdSol < nReserva
		msginfo("O material "+cMaterial+'/'+cArmazem+'/'+alltrim(cEndereco)+" possui reserva maior que a solicitação favor verificar.","Inconsistência")
		lRet := .f.
	else
		sbf->(dbSetOrder(1))
		if sbf->(dbSeek(xFilial()+cArmazem+cEndereco+cMaterial))
			nSldAtu := sbf->bf_quant-sbf->bf_empenho
		endif
		nQtdaSol := nQtdSol - nReserva
		if nQtdaSol > nSldAtu
			msginfo("Não existe estoque para atender a solicitação da reserva do material "+cMaterial+'/'+cArmazem+'/'+alltrim(cEndereco),"Inconsistência")
			lRet := .f.
		else
			if empty(cReserva) .and. nReserva == 0

				cReserva := u_renp050()
				aOperacao := {1,"PD",cDemanda,"CMMS",xFilial("SC0")}
				if !a430Reserv(aOperacao,cReserva,cMaterial,cArmazem,nQtdaSol,aLote,aHeader,aCols)
					msginfo("Problemas na alteração da reserva do item "+alltrim(cMaterial)+"/"+cArmazem+"/"+alltrim(cEndereco)+".","Inconsistência")
					lErro := .f.
				endif

			elseif !empty(cReserva) .and. nReserva > 0

				sc0->(dbSetOrder(1))
				if sc0->(DbSeek(xFilial()+cReserva+cMaterial+cArmazem))
					while !sc0->(eof()) .and. sc0->c0_filial == sc0->(xfilial()) .and. ;
							sc0->c0_num == cReserva  .and. sc0->c0_produto == cMaterial .and. ;
							sc0->c0_local == cArmazem

						if sc0->c0_localiz == cEndereco
							lAchou := .t.
							aOperacao := {2,sc0->c0_tipo,sc0->c0_docres,sc0->c0_solicit,sc0->c0_filial}
							if !a430Reserv(aOperacao,cReserva,cMaterial,cArmazem,nqtd,aLote,aHeader,aCols)
								msginfo("Problemas na alteração da reserva do item "+alltrim(cMaterial)+"/"+cArmazem+"/"+alltrim(cEndereco)+". ","Inconsistência")
								lRet := .f.
							endif
						endif

						sc0->(dbskip())
					end
				endif

				if !lAchou
					msginfo("O material "+alltrim(cMaterial)+"/"+cArmazem+"/"+alltrim(cEndereco)+" não esta reservado.","Inconsistência")
					lRet := .f.
				endif

			else
				msginfo("O material "+cMaterial+'/'+cArmazem+'/'+alltrim(cEndereco)+" está com problema de reserva.","Inconsistência")
				lRet := .f.
			endif

		endif
	endif

return lRet
*/

User Function altReserva(cReserva,cMaterial,cLocal,cLocaliz,nqtd,cMens)

	Local lAchou := .f.
	Local lErro := .t.
	Local nSldAtu := 0
	Local aOperacao := {}
	local nOper := 0
	Local aLote		:= {"","",cLocaliz,""}	//C0_NUMLOTE,C0_LOTECTL,C0_LOCALIZ,C0_NUMSERI

	Private aHeader := {}
	Private aCols	:= {}

	sbf->(dbSetOrder(1))
	if sbf->(dbSeek(xFilial()+cLocal+cLocaliz+cMaterial))
		nSldAtu := sbf->bf_quant-sbf->bf_empenho
	else
		nSldAtu := 0
	endif

	sc0->(dbSetOrder(1))
	if sc0->(DbSeek(xFilial()+cReserva+cMaterial+cLocal))
		while !sc0->(eof()) .and. sc0->c0_filial == sc0->(xfilial()) .and. ;
				sc0->c0_num == cReserva  .and. sc0->c0_produto == cMaterial .and. ;
				sc0->c0_local == cLocal

			if sc0->c0_localiz == cLocaliz
				lAchou := .t.
				if nqtd > sc0->c0_quant
					if nSldAtu < (nqtd-sc0->c0_quant)
						nqtd := sc0->c0_quant+nSldAtu
					endif
				endif
				if sc0->c0_quant != nqtd
					if nqtd == 0
						nOper := 3
						nQuant := sc0->c0_quant
					else
						nOper := 2
					endif
					aOperacao := {nOper,sc0->c0_tipo,sc0->c0_docres,sc0->c0_solicit,sc0->c0_filial}
					if !a430Reserv(aOperacao,cReserva,cMaterial,cLocal,nqtd,aLote,aHeader,aCols)
						cMens += 'Problemas na alteração da reserva do item '+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+'. '
						lErro := .f.
					endif
				endif
			endif

			sc0->(dbskip())
		end
	endif

	if !lAchou
		cMens += "O item - "+alltrim(cMaterial)+'/'+cLocal+'/'+alltrim(cLocaliz)+' não esta reservado. '
		lErro := .f.
	endif

Return lErro
