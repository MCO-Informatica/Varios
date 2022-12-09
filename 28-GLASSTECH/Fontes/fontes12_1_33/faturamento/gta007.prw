#include "Protheus.ch"

#define DS_MODALFRAME   128  // Sem o fechar window da tela

/* Cadastro de anotações de relacionamento com o o cliente */

User Function gta007()

	Local aAreas  := {sa1->(GetArea()), GetArea()}
	Local cCodCli := ""
	Local cLojCli := ""
	Local cNomCli := ""
	Local cConCli := ""

	Local nT      := 0
	Local l_Edit   := .f.

	Local lHasbutton := .f.
	Local lNobutton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Local oBrw
	Local oDlg
	Local oGet01
	Local oPn1
	Local oPn2

	Private aCols := {}

	if funname() == "MATA415"
		cCodCli := m->cj_cliente
		cLojCli   := m->cj_loja
	elseif funname() == "MATA010"
		cCodCli := m->a1_cod
		cLojCli := m->a1_loja
	endif

	if empty(cCodCli+cLojCli)
		MsgInfo("O código do cliente não foi digitado. Verifique ! ","Atenção")
		Return
	endif

	if funname() == "MATA415"
		if cCodCli+cLojCli != sa1->a1_cod+sa1->a1_loja
			sa1->(DbSetOrder(1))
			if !sa1->( DbSeek( xFilial()+cCodCli+cLojCli ) )
				MsgInfo("O cliente não foi encontrado ! ","Atenção")
				Return
			endif
		endif
		cNomCli := sa1->a1_nome
	else
		cNomCli := m->a1_nome
	endif

	if inclui .or. Altera
		l_Edit := .t.
	endif

	dbSelectArea("sz4")
	cSql := "select z4_item,z4_autor,z4_anota,z4_dathor from "+RetSQLName("sz4")+" z4 "
	cSql += "where z4_filial = '"+xFilial("sz4")+"' and z4_codcli = '"+cCodCli+"' and z4_lojcli = '"+cLojCli+"' "
	cSql += "and z4.d_e_l_e_t_ = ' ' order by z4_item"
	cSql := ChangeQuery( cSql )
	dbUseArea(.t.,"TOPCONN",TcGenQry(,,cSql),"trb",.f.,.t.)
	while !trb->( Eof() )
		nT++
		Aadd(aCols, { trb->z4_item, trb->z4_autor, trb->z4_anota, trb->z4_dathor, trb->z4_item })
		trb->( DbSkip() )
	End
	trb->( DbCloseArea() )
	if Empty(aCols)
		Aadd(aCols, { "001", cUserName,space(250),space(20), "nov" })
	endif

	DEFINE MSDIALOG oDlg TITLE "Anotações de relacionamento com cliente" FROM 000, 000  TO 400, 940 COLORS 0, 16777215 PIXEL //Style DS_MODALFRAME
	//oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,002,,oDlg,,,,,/*CLR_HCYAN*/,468,030)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cConCli := cCodCli+"/"+cLojCli+" - "+cNomCli
	cLabelText := "Cliente:"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cConCli,cConCli:=u)},oPn1,140,10,"@!",,,,,.f.,,.t.,,.f.,,.f.,.f.,,.t./*lReadOnly*/,.f.,,"cConCli",,,, lHasbutton , lNobutton,, cLabelText, nLabelPos)

	@ 010, 340 button obutton prompt "Confirmar" size 037, 012 action ( iif(confAnot(oBrw,cCodCli,cLojCli),oDlg:End(),.f.) ) of oPn1 pixel
	@ 010, 380 button obutton prompt "Sair"      size 037, 012 action oDlg:End() of oPn1 pixel

    /*******************************************************/
	oPn2 := tPanel():New(030,002,,oDlg,,,,,/*CLR_HCYAN*/,468,168)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	oBrw := fwBrowse():New()
	oBrw:setOwner( oPn2 )
	oBrw:setDataArray()
	oBrw:setArray( aCols )
	oBrw:disableConfig()
	oBrw:disableReport()
	oBrw:SetLocate() // Habilita a Localização de registros
	oBrw:addColumn({"Id"         , {||aCols[oBrw:nAt,01]}, "C", "@!" , 1, 003 , 0, .f.   ,                       , .f., , "cItem" , , .f., .t., , "IdItem"   })
	oBrw:addColumn({"Autor"      , {||aCols[oBrw:nAt,02]}, "C", "@!" , 1, 020 , 0, .f.   ,                       , .f., , "cAutor", , .f., .t., , "IdcAutor" })
	oBrw:addColumn({"Anotação"   , {||aCols[oBrw:nAt,03]}, "C", "@!" , 1, 255 , 0, l_Edit,{ || preench(oBrw,3) } , .f., , "cAnota", , .f., .t., , "IdcAnota" })
	oBrw:addColumn({"Dt.Inclusão", {||aCols[oBrw:nAt,04]}, "C", "@!" , 1, 020 , 0, .f.   ,			             , .f., , "cDtInc", , .f., .f., , "IdcDtInc" })
	oBrw:addColumn({"Id.SZ4"     , {||aCols[oBrw:nAt,05]}, "C", "@!" , 1, 003 , 0, .f.   ,                       , .f., , "cItZ4" , , .f., .t., , "IdItZ4"   })

	oBrw:acolumns[5]:ldeleted := .t.
	if l_Edit
		oBrw:SetEditCell( .t. )                    		// Ativa edit and code block for validation
		oBrw:SetInsert( .t. )                   		// Indica que o usuário poderá inserir novas linhas no Browse.
		oBrw:SetAddLine( { || AddLin(oBrw) } )			// Indica a Code-Block executado para adicionar linha no browse.
		//oBrw:SetLineOk( { || altLin(oBrw) } )         // Indica o Code-Block para validação, executado na troca de linha do Browse. FWBrowse():LineOk( ) --> lRet
		//oBrw:SetChange( { || altLin(oBrw)  })         // Indica a Code-Block executado após a mudança de uma linha.
		oBrw:SetDelete( .t. , { || DelLin(oBrw) } )		// Indica que o usuário pode excluir linhas no Browse.
		oBrw:SetDelOk( { || .t. } ) 	            	// Indica o Code-Block executado para validar a exclusão da linha.
		oBrw:SetBlkBackColor( { || verCor(oBrw)} )
	endif
	oBrw:Activate(.t.)

    /*******************************************************/

	activate msdialog oDlg centered

	aEval(aAreas, {|x| RestArea(x) })

Return


Static Function addLin(oObj)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0

	if oObj:nAt > 1
		for nI := 1 to len(aObj)
			if aObj[nI,1] != 'XXX'
				nX := val(aObj[nI,1])
			endif
		next
		++nX
		Aadd(aObj, {strzero( nX ,3), cUserName, space(250), space(20), "nov" } )
	endif

return

Static Function altLin(oObj)
	Local aObj := oObj:oData:aArray
	Local lRet := .t.

	if aObj[oObj:nAt, 5] == 'nov' .or. lGer .or. lDir
		lRet := .t.
	else
		MsgAlert("A linha não pode ser modificada! ", "Inconsistência" )
		lRet := .f.
	endif

return lRet


Static Function delLin(oObj)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0

	if aObj[oObj:nAt, 5] == 'nov' .or. lGer .or. lDir

		if aObj[oObj:nAt,1] == 'XXX'
			aObj[oObj:nAt,1] := 'TT'
			for nI := 1 to len(aObj)
				if aObj[nI,1] != 'XXX'
					if aObj[nI,5] != "nov"
						aObj[nI,1] := aObj[nI,5]
						nX := val(aObj[nI,5])
					else
						++nX
						aObj[nI,1] := strzero(nx,3)
					endif
				endif
			next
		else
			aObj[oObj:nAt,1] := 'XXX'
		endif

		oObj:setArray( aObj )
		oObj:refresh(.t.)
		for nI := 1 to len(aObj)
			oObj:LineRefresh(nI-1)
		next
		oObj:refresh(.t.)
	else
		MsgAlert("Esta linha não pode ser excluida! ", "Inconsistência" )
	endif

return


Static Function verCor(oObj)
	Local aObj := oObj:oData:aArray
	Local oCor

	if aObj[oObj:nAt, 1] == 'XXX'
		oCor := CLR_HGRAY
	else
		oCor := nil //CLR_WHITE //CLR_HBLUE
	endif

return(oCor)


Static Function preench(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, 1] == 'XXX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
	elseif aObj[oObj:nAt, 5] == 'nov' .or. lGer .or. lDir
		aObj[oObj:nAt,nCol] := &(cVar)
		if empty(aObj[oObj:nAt, nCol+1])
			aObj[oObj:nAt,nCol+1] := dtoc(date())+" "+time()
		endif
		//oObj:setArray( aObj )
		//oObj:refresh(.t.)
	else
		&(cVar) := aObj[oObj:nAt,nCol]
		lRet := .f.
		MsgAlert("Esta linha não pode ser alterada! ", "Inconsistência" )
	endif

return(lRet)


Static Function confAnot(oBrw,cCodCli,cLojCli)

	Local lRet := .t.
	Local nId  := 0
	Local nIp  := 0
	Local aTud := {oBrw}
	Local aObj := {}

	for nIp := 1 to len(aTud)
		aObj := aTud[nIp]:oData:aArray
		for nId := 1 to len(aObj)
			if aObj[nId,1] != 'XXX'
				if empty(aObj[nId,3])
					MsgInfo("Verifique preenchimento da "+aTud[nIp]:aColumns[3]:cTitle+" no item "+aObj[nId,1]+" ! ","Atenção")
					Return .f.
				endif
			endif
		next
	next

	if MsgYesNo("Confirma atualização ?","ATENÇÃO","YESNO")

		for nIp := 1 to len(aTud)

			aObj := aTud[nIp]:oData:aArray
			for nId := 1 to len(aObj)
				if aObj[nId,1] != 'XXX'
					if sz4->( DbSeek( xFilial()+cCodCli+cLojCli+aObj[nId,1] ) )
						sz4->(RecLock("sz4",.f.))
					else
						sz4->(RecLock("sz4",.t.))
						sz4->z4_filial := sz4->(xfilial())
						sz4->z4_codcli := cCodCli
						sz4->z4_lojcli := cLojCli
						sz4->z4_item   := aObj[nId,1]
						sz4->z4_autor  := aObj[nId,2]
						sz4->z4_dathor := aObj[nId,4]
					endif
					sz4->z4_anota  := aObj[nId,3]
					sz4->(MsUnLock())
				else
					if sz4->( DbSeek( xFilial()+cCodCli+cLojCli+aObj[nId,5] ) )
						sz4->(RecLock("sz4",.f.))
						sz4->(DbDelete())
						sz4->(MsUnLock())
					endif
				endif
			next
		next
	endif

Return lRet
