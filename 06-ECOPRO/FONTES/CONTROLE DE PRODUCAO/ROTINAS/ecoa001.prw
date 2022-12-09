#Include 'Protheus.ch'

#define DS_MODALFRAME   128  // Sem o fechar window da tela

User Function ecoa001(nOpc)
	Local cFilter     := ""
	Local aCores      := {}

	Default nOpc      := 0

	Private cCadastro := 'Apontamentos do Retrabalho'
	Private cDelFunc  := '.T.'
	Private aRotina   := {}
	Private cAlias    := 'SC2'

	if nOpc == 0

		aAdd( aRotina, { 'Pesquisar'  , 'AxPesqui', 0, 1 } )
		aAdd( aRotina, { "Visualizar" , "AxVisual", 0, 2 })
		aAdd( aRotina, { 'Apontar'    , 'u_mntAponta(1)', 0, 3 } )
		aAdd( aRotina, { 'Excluir'    , 'u_mntAponta(3)', 0, 4 } )

		cFilter := "C2_SEQUEN = '001'"

		dbSelectArea(cAlias)
		dbSetOrder(1)
		dbGoTop()
		mBrowse(10,10,60,120,cAlias,,,,,, aCores,,,,,,,,cFilter)

	elseif nOpc != 0

		u_mntAponta(nOpc)

	endif

Return Nil

/*
nOpc => 1 - Apontamento
        2 - Exclusão
*/
User Function mntAponta(nOpc)

	Local oDlg

	Local cNumop := ""
	Local cItemop:= ""
	Local nQuant := 0
	Local cDesc	 := ""

	Local cPart1 := ""
	Local cPart2 := ""
	Local cPart3 := ""
	Local cNumSer:= ""

	Local oGet1
	Local oGet2

	Local bSetGet
	Local bValid := {|| .t. }
	Local bWhen  := {|| .t. }
	Local bChange := {|| }
	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""      //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1       //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Local oButton1
	Local oButton2

	Local oBrw
	//Local aCodRet := {}
	Local aColsEx := {}

	Local cCodRet1 := space(2)
	Local dDtRet1 := stod(" ")
	Local cCodRet2 := space(2)
	Local dDtRet2 := stod(" ")
	Local cCodRet3 := space(2)
	Local dDtRet3 := stod(" ")
	Local cCodRet4 := space(2)
	Local dDtRet4 := stod(" ")
	Local cCodRet5 := space(2)
	Local dDtRet5 := stod(" ")
	Local cCodRet6 := space(2)
	Local dDtRet6 := stod(" ")
	Local cCodRet7 := space(2)
	Local dDtRet7 := stod(" ")
	Local cCodRet8 := space(2)
	Local dDtRet8 := stod(" ")

	Local nI := 0
	Local nIx := 0

	Private aOperacao := {"Inclusão","Alteração","Exclusao","","","","","",""}

	cNumop := sc2->c2_num
	cItemop:= sc2->c2_item
	nQuant := sc2->c2_quant

	cQuery := "select * from "+RetSQLName("SC2")+" c2 "
	cQuery += "inner join "+RetSQLName("SD3")+" d3 on d3_filial = c2_filial and d3_op = c2_num||c2_item||c2_sequen and d3_cod = c2_produto and d3.d_e_l_e_t_ = ' ' and d3_estorno != 'S' "
	cQuery += "where c2_filial = '"+xFilial("SC2")+"' and c2_num = '"+cNumop+"' and c2_item = '"+cItemop+"' and c2_sequen = '001' and c2.d_e_l_e_t_ = ' ' "
	cQuery := ChangeQuery( cQuery )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRB",.f.,.t.)

	if trb->( Eof() )
		MsgInfo("Apontamento da ordem de produção tem que existir para apontar o retrabalho!", "Atenção")
		trb->( DbCloseArea() )
		return
	endif

	trb->( DbCloseArea() )

	sb1->(dbSetORder(1))
	sb1->(dbSeek(xFilial("SB1")+sc2->c2_produto))
	cDesc := sb1->b1_desc

	cPart1 := cNumop
	cPart3 := Month2Str(sc2->c2_emissao)+Substr(Year2Str(sc2->c2_emissao),3,2)
	/*
	cSql := "select * from "+RetSQLName("SX5")+" x5 where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.f.,.t.)
	while !(ctrb)->( Eof() )
		Aadd(aCodRet, substr((ctrb)->x5_chave,1,2)+"-"+alltrim((ctrb)->x5_descri) )
		(ctrb)->( DbSkip() )
	end
	(ctrb)->( DbCloseArea() )
	*/
	dbSelectArea("SZ1")
	cSql := "select * from "+RetSQLName("SZ1")+" z1 "
	//cSql += "left join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela = 'TR' and x5_chave = z1_codret and x5.d_e_l_e_t_ = ' '"
	cSql += "where z1_filial = '"+xFilial("SZ1")+"' and z1_numop = '"+cNumop+"' and z1_itemop = '"+cItemop+"' and z1.d_e_l_e_t_ = ' ' order by z1_numser,z1_itretr"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.f.,.t.)
	if (ctrb)->( Eof() )

		for nI := 1 to nQuant
			cPart2  := strzero(nI,3)
			cNumSer := cPart1+"."+cPart2+"."+cPart3
			Aadd(aColsEx, { cNumSer, space(2), stod(" "),space(2), stod(" "),space(2), stod(" "),space(2), stod(" "),space(2), stod(" "),space(2), stod(" "),space(2), stod(" "),space(2), stod(" "), .f. })
		next

	else
		if nOpc == 1
			nOpc := 2
		endif

		while !(ctrb)->( Eof() )
			nIx := 0
			cNumSer := (ctrb)->z1_numser
			while !(ctrb)->( Eof() ) .and. cNumSer == (ctrb)->z1_numser
				nIx += 1
				&("cCodRet"+alltrim(str(nIx))) := (ctrb)->z1_codret
				&("dDtRet"+alltrim(str(nIx))) := stod((ctrb)->z1_dtreg)
				(ctrb)->( DbSkip() )
			end
			nIx += 1
			for nI := nIx to nQuant
				&("cCodRet"+alltrim(str(nI))) := space(2)
				&("dDtRet"+alltrim(str(nI))) := stod(" ")
			next
			Aadd(aColsEx, { cNumSer, cCodRet1, dDtRet1, cCodRet2, dDtRet2, cCodRet3, dDtRet3, cCodRet4, dDtRet4, cCodRet5, dDtRet5, cCodRet6, dDtRet6, cCodRet7, dDtRet7, cCodRet8, dDtRet8, .f. })
		end
	endif
	(ctrb)->( DbCloseArea() )

	DEFINE MSDIALOG oDlg TITLE cCadastro+" - "+aOperacao[nOpc] FROM 000, 000 TO 500, 1300 COLORS 0, 16777215 pixel Style DS_MODALFRAME

	oDlg:lEscClose := .f.

	bSetGet := { |u| If(PCount()==0,cNumop, cNumop:= u) }
	cLabelText := "OP: "
	oGet1 := TGet():New(010,005,bSetGet,oDlg,035,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cNumop" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

	bSetGet := { |u| If(PCount()==0,nQuant, nQuant:= u) }
	cLabelText := "Quantidade: "
	oGet2 := TGet():New(010,080,bSetGet,oDlg,035,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"nQuant"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

	bSetGet := { |u| If(PCount()==0,cDesc, cDesc:= u) }
	cLabelText := "Produto: "
	oGet2 := TGet():New(010,160,bSetGet,oDlg,095,010,"@!" ,bValid,,,/*Font*/,,,.T.,,,bWhen,,,bChange,.t./*lReadOnly*/,.F.,,"cDesc"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos, /*fonte*/,/*nLabelColor*/,,,.t./*lFocSel*/)

	@ 010, 400 BUTTON oButton2 PROMPT "Cód. Retrabalho"	SIZE 055, 012 action u_mntSx5('TR','CÓDIGOS DE RETRABALHO',TamSx3("Z1_CODRET")[1],.t.)	of oDlg pixel
	@ 010, 510 BUTTON oButton2 PROMPT "Confirmar"		SIZE 055, 012 action iif(confAponta(nOpc,cNumop,cItemop,oBrw),oDlg:End(),.f.)					of oDlg pixel
	@ 010, 590 BUTTON oButton1 PROMPT "Fechar"			SIZE 055, 012 action oDlg:End()																	of oDlg pixel
	//lin,col       			     col,lin
	oPnl := tPanel():New(032,004,,oDlg,,,,,/*CLR_HCYAN*/,645,210)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA
	//oPnl:Align := CONTROL_ALIGN_ALLCLIENT

	oBrw:=fwBrowse():New()
	oBrw:setOwner( oPnl )
	oBrw:setDataArray()
	oBrw:setArray( aColsEx )
	oBrw:disableConfig()
	oBrw:disableReport()
	oBrw:SetLocate() // Habilita a Localização de registros

	oBrw:addColumn({"Nº Série" , {||aColsEx[oBrw:nAt,01]}, "C", "@!" , 1,  13 ,  0  , .F. , 						  , .F.,, "cNumSer" ,, .F., .T.,              , "cNumSer"  })
	oBrw:addColumn({"Código 1" , {||aColsEx[oBrw:nAt,02]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,02) } , .F.,, "cCodRet1",, .F., .T., /*aCombOpc*/ , "cCodRet1" })
	oBrw:addColumn({"Data 1"   , {||aColsEx[oBrw:nAt,03]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,03) } , .F.,, "dDtRet1" ,, .F., .T.,              , "dDtRet1"  })
	oBrw:addColumn({"Código 2" , {||aColsEx[oBrw:nAt,04]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,04) } , .F.,, "cCodRet2",, .F., .T., /*aCombOpc*/ , "cCodRet2" })
	oBrw:addColumn({"Data 2"   , {||aColsEx[oBrw:nAt,05]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,05) } , .F.,, "dDtRet2" ,, .F., .T.,              , "dDtRet2"  })
	oBrw:addColumn({"Código 3" , {||aColsEx[oBrw:nAt,06]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,06) } , .F.,, "cCodRet3",, .F., .T., /*aCombOpc*/ , "cCodRet3" })
	oBrw:addColumn({"Data 3"   , {||aColsEx[oBrw:nAt,07]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,07) } , .F.,, "dDtRet3" ,, .F., .T.,              , "dDtRet3"  })
	oBrw:addColumn({"Código 4" , {||aColsEx[oBrw:nAt,08]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,08) } , .F.,, "cCodRet4",, .F., .T., /*aCombOpc*/ , "cCodRet4" })
	oBrw:addColumn({"Data 4"   , {||aColsEx[oBrw:nAt,09]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,09) } , .F.,, "dDtRet4" ,, .F., .T.,              , "dDtRet4"  })
	oBrw:addColumn({"Código 5" , {||aColsEx[oBrw:nAt,10]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,10) } , .F.,, "cCodRet5",, .F., .T., /*aCombOpc*/ , "cCodRet5" })
	oBrw:addColumn({"Data 5"   , {||aColsEx[oBrw:nAt,11]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,11) } , .F.,, "dDtRet5" ,, .F., .T.,              , "dDtRet5"  })
	oBrw:addColumn({"Código 6" , {||aColsEx[oBrw:nAt,12]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,12) } , .F.,, "cCodRet6",, .F., .T., /*aCombOpc*/ , "cCodRet6" })
	oBrw:addColumn({"Data 6"   , {||aColsEx[oBrw:nAt,13]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,13) } , .F.,, "dDtRet6" ,, .F., .T.,              , "dDtRet6"  })
	oBrw:addColumn({"Código 7" , {||aColsEx[oBrw:nAt,14]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,14) } , .F.,, "cCodRet7",, .F., .T., /*aCombOpc*/ , "cCodRet7" })
	oBrw:addColumn({"Data 7"   , {||aColsEx[oBrw:nAt,15]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,15) } , .F.,, "dDtRet7" ,, .F., .T.,              , "dDtRet7"  })
	oBrw:addColumn({"Código 8" , {||aColsEx[oBrw:nAt,16]}, "C", "@!" , 1,  02 ,  0  , .T. , { || PreeCampo(oBrw,16) } , .F.,, "cCodRet8",, .F., .T., /*aCombOpc*/ , "cCodRet8" })
	oBrw:addColumn({"Data 8"   , {||aColsEx[oBrw:nAt,17]}, "N", "@D" , 1,  08 ,  0  , .T. , { || PreeCampo(oBrw,17) } , .F.,, "dDtRet8" ,, .F., .T.,              , "dDtRet8"  })

	oBrw:aColumns[2]:xF3 := "TR"
	oBrw:aColumns[4]:xF3 := "TR"
	oBrw:aColumns[6]:xF3 := "TR"
	oBrw:aColumns[8]:xF3 := "TR"
	oBrw:aColumns[10]:xF3 := "TR"
	oBrw:aColumns[12]:xF3 := "TR"
	oBrw:aColumns[14]:xF3 := "TR"
	oBrw:aColumns[16]:xF3 := "TR"

	oBrw:SetEditCell( .t. )      // Ativa edit and code block for validation
	//oBrw:SetInsert(.t.)                       // Indica que o usuário poderá inserir novas linhas no Browse.
	//oBrw:SetAddLine( { || AddLin(oBrw) } )	  // Indica a Code-Block executado para adicionar linha no browse.
	oBrw:SetLineOk( { || VerLin(oBrw) } )     // Indica o Code-Block executado na troca de linha do Browse.
	//oBrw:SetChange({ || .t. })       		  //Indica a Code-Block executado após a mudança de uma linha.
	//oBrw:SetDelete(.t., { || DelLin(oBrw) } ) // Indica que o usuário pode excluir linhas no Browse.
	//oBrw:SetDelOk( { || verDel(oBrw) } ) 	  // Indica o Code-Block executado para validar a exclusão da linha.

	oBrw:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

Return

Static Function PreeCampo(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if "ccodret" $ lower(cVar) .and. !empty(&(cVar))
		if !sx5->(dbseek(xFilial()+"TR"+&(cVar)))
			lRet := .f.
			MsgInfo("Código retrabalho não existe", "Inconcistência")
		endif
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)


Static Function verLin(oObj,nLin)
	//Local aObj := oObj:oData:aArray
	Local lRet := .t.

	Default nLin := oObj:nAt
/*
	if aObj[nLin,VALOR] == 0
		lRet := .f.
		MsgInfo("Campos VALOR da linha atual devem ser preenchidos", "Inconcistência")
	elseif empty(aObj[nLin,DTVENC])
		lRet := .f.
		MsgInfo("Deve ser digitado Condição de pgto ou Data vencimento !", "Inconsistêcnia")
	endif
*/
return(lRet)


Static Function confAponta(nOpc,cNumop,cItemop,oBrw)

	Local lRet := .t.
	Local aObj := oBrw:oData:aArray
	Local aLin	:= {}
	Local nId  := 0
	Local nIx  := 0
	Local nI   := 0
	Local lIncZ1 := .f.

	if nOpc < 0 .or. nOpc > 3
		MsgInfo("A operacao que esta sendo usada esta incorreta. Favor falar com responsavel sistema! ","Atencao")
		Return .f.
	endif

	if MsgYesNo("Confirma a "+aOperacao[nOpc]+" do apontamento do retrabalho para OP ?","ATENÇÃO","YESNO")

		sz1->(dbSetORder(1))
		for nId := 1 to len(aObj)
			aLin := aObj[nId]
			nI := 0
			for nIx := 2 to len(aLin)-1 step 2
				nI += 1
				lIncZ1 := .f.
				if !sz1->(dbSeek( xFilial()+cNumop+cItemop+aObj[nId,1]+strzero(nI,2) ))
					lIncZ1 := .t.
				endif
				if nOpc == 1 .or. lIncZ1
					if sz1->(RecLock("SZ1",.t.))
						sz1->z1_filial  := sz1->(xfilial())
						sz1->z1_numop	:= cNumop
						sz1->z1_itemop	:= cItemop
						sz1->z1_numser	:= aObj[nId,1]
						sz1->z1_itretr	:= strzero(nI,2)
						sz1->z1_codret	:= aLin[nIx]
						sz1->z1_dtreg	:= aLin[nIx+1]
					else
						lRet := .f.
					endif
				elseif sz1->(RecLock("SZ1",.f.))
					if nOpc == 3
						sz1->(DbDelete())
					else
						sz1->z1_itretr	:= strzero(nI,2)
						sz1->z1_codret	:= aLin[nIx]
						sz1->z1_dtreg	:= aLin[nIx+1]
					endif
				else
					lRet := .f.
				endif
				sz1->(MsUnLock())
			next
			if !lRet
				MsgInfo("Problemas nas garavações das operações, favor verificar os dados da Norma ! ","Atencao")
			endif
		next
	endif

Return lRet
