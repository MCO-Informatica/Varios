#include "Protheus.ch"

#define DS_MODALFRAME   128  // Sem o fechar window da tela

/* Cadastro do perfil de vendas do Cliente */
/*
nOpc => 1 - InclusÃ£o
        2 - AlteraÃ§Ã£o
        3 - ExclusÃ£o
*/
User Function gta002()

	Local cCodCli := m->a1_cod
	Local cLoja   := m->a1_loja
	Local cTes    := m->a1_xtes
	Local cVend   := m->a1_vend
	Local nOpc    := 0
	Local nC      := 0
	Local nT      := 0

	Local lEdit   := .f.

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Local oDlg
	Local oGet01
	Local oGet02
	Local oGet03

	Private oFolder
	Private aCols1 := {}
	Private aCols2 := {}

	if empty(cCodCli+cLoja)
		MsgInfo("O código do cliente não foi digitado. Verifique ! ","Atenção")
		Return
	endif

	if inclui
		nOpc := 1
	elseif Altera
		nOpc := 2
	endif

	if inclui .or. Altera
		lEdit := .t.
	endif

	se4->(DbSetOrder(1))
	sa4->(DbSetOrder(1))
	sz2->(DbSetOrder(1))

	dbSelectArea("SZ2")
	cSql := "select z2_tipo,z2_codigo from "+RetSQLName("SZ2")+" z2 "
	cSql += "where z2_filial = '"+xFilial("SZ2")+"' and z2_codcli = '"+cCodCli+"' and z2_lojcli = '"+cLoja+"' and z2.d_e_l_e_t_ = ' '"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		if (ctrb)->z2_tipo == "C"       //cond.pagamento
			nC++
			if se4->( DbSeek( xFilial()+alltrim((ctrb)->z2_codigo) ) )
				Aadd(aCols1, { strzero( nC ,2), (ctrb)->z2_codigo, se4->e4_descri, (ctrb)->z2_codigo })
			endif
		elseif (ctrb)->z2_tipo == "T"   //transportadora
			nT++
			if sa4->( DbSeek( xFilial()+(ctrb)->z2_codigo ) )
				Aadd(aCols2, { strzero( nT ,2), (ctrb)->z2_codigo, sa4->a4_nome, (ctrb)->z2_codigo })
			endif
		endif
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )
	if Empty(aCols1)
		Aadd(aCols1, { "01", space(03),space(40),space(03) })
	endif
	if Empty(aCols2)
		Aadd(aCols2, { "01", space(06),space(40),space(06) })
	endif

	DEFINE MSDIALOG oDlg TITLE "Perfil do cliente" FROM 000, 000  TO 350, 798 COLORS 0, 16777215 PIXEL //Style DS_MODALFRAME

	//oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,003,,oDlg,,,,,/*CLR_HCYAN*/,390,065)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cCodCli := cCodCli+"/"+cLoja+" - "+m->a1_nome
	cLabelText := "Cliente:"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cCodCli,cCodCli:=u)},oPn1,140,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cCodCli",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	cVend := cVend+" - "+posicione("SA3",1,xfilial("SA3")+cVend,"A3_NOME")
	cLabelText := "Vendedor:"
	oGet02 := TGet():New(023,003,{|u|If(PCount()==0,cVend  ,cVend := u)},oPn1,140,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cVend"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	cTes := cTes+" - "+posicione("SF4",1,xfilial("SF4")+cTes,"F4_TEXTO")
	cLabelText := "Tes:"
	oGet03 := TGet():New(043,003,{|u|If(PCount()==0,cTes   ,cTes  := u)},oPn1,140,10,"@!",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cTes"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	@ 003, 330 BUTTON oButton PROMPT "Confirmar" SIZE 037, 012 action ( lRet:=iif(confPerf(nOpc,oBrw1,oBrw2),oDlg:End(),.f.) ) OF oDlg pixel
	@ 023, 330 BUTTON oButton PROMPT "Sair"      SIZE 037, 012 action oDlg:End() of oDlg pixel
	if lEdit
		@ 003, 265 BUTTON oButton PROMPT "Restaura/Deleta Linha" SIZE 060, 012 action iif(oFolder:nOption==1,oBrw1:DelLine(),oBrw2:DelLine()) of oDlg Pixel
	endif

    /*******************************************************/
	@ 075, 000 FOLDER oFolder SIZE 402, 210 OF oDlg ITEMS "Cond.Pagamento","Transportadora" colors 0, 16777215 pixel

	oBrw1:=fwBrowse():New()
	oBrw1:setOwner( oFolder:aDialogs[1] )
	oBrw1:setDataArray()
	oBrw1:setArray( aCols1 )
	oBrw1:disableConfig()
	oBrw1:disableReport()
	oBrw1:SetLocate() // Habilita a Localização de registros
	oBrw1:addColumn({"Id"        , {||aCols1[oBrw1:nAt,01]}, "C", "@!" , 1, 02, 0, .F.  ,                        , .F., , "IdIte1", , .F., .T., , "IdIte1" })
	oBrw1:addColumn({"Cond.Pagar", {||aCols1[oBrw1:nAt,02]}, "C", "@!" , 1, 03, 0, lEdit,{ || preench(oBrw1,2) } , .F., , "IdCod1", , .F., .T., , "IdCod1" })
	oBrw1:addColumn({"Descrição" , {||aCols1[oBrw1:nAt,03]}, "C", "@!" , 1, 40, 0, .F.  ,                        , .F., , "IdDes1", , .F., .T., , "IdDes1" })
	oBrw1:addColumn({"C.PagarOri", {||aCols1[oBrw1:nAt,04]}, "C", "@!" , 1, 03, 0, .F.  ,{ || .f. }              , .F., , "IdCoO1", , .F., .F., , "IdCoO1" })
	if lEdit
		oBrw1:aColumns[2]:xF3 := "SE4"
		obrw1:acolumns[4]:ldeleted := .t.
		oBrw1:SetEditCell( .t. )                    // Ativa edit and code block for validation
		oBrw1:SetInsert(.t.)                        // Indica que o usuário poderá inserir novas linhas no Browse.
		oBrw1:SetAddLine( { || AddLin(oBrw1,3) } )	// Indica a Code-Block executado para adicionar linha no browse.
		oBrw1:SetLineOk( { || .t. } )               // Indica o Code-Block executado na troca de linha do Browse.
		//oBrw1:SetChange({ || .t. })               // Indica a Code-Block executado após a mudança de uma linha.
		oBrw1:SetDelete(.t., { || DelLin(oBrw1) } ) // Indica que o usuário pode excluir linhas no Browse.
		oBrw1:SetDelOk( { || .t. } ) 	            // Indica o Code-Block executado para validar a exclusão da linha.
		oBrw1:SetBlkBackColor( { || verCor(oBrw1)} )
	endif
	oBrw1:Activate(.t.)

	oBrw2:=fwBrowse():New()
	oBrw2:setOwner( oFolder:aDialogs[2] )
	oBrw2:setDataArray()
	oBrw2:setArray( aCols2 )
	oBrw2:disableConfig()
	oBrw2:disableReport()
	oBrw2:SetLocate() // Habilita a Localização de registros
	oBrw2:addColumn({"Id"     , {||aCols2[oBrw2:nAt,01]}, "C", "@!" , 1, 02, 0, .F.  ,                         , .F., , "IdIte2", , .F., .T., , "IdIte2" })
	oBrw2:addColumn({"Transp.", {||aCols2[oBrw2:nAt,02]}, "C", "@!" , 1, 06, 0, lEdit, { || preench(oBrw2,2) } , .F., , "IdCod2", , .F., .T., , "IdCod2" })
	oBrw2:addColumn({"Nome"   , {||aCols2[oBrw2:nAt,03]}, "C", "@!" , 1, 40, 0, .F.  ,                         , .F., , "IdDes2", , .F., .T., , "IdDes2" })
	oBrw2:addColumn({"Tra.Ori", {||aCols2[oBrw2:nAt,04]}, "C", "@!" , 1, 06, 0, .F.  , { || .F. }              , .F., , "IdCoO2", , .F., .F., , "IdCoO2" })
	if lEdit
		oBrw2:aColumns[2]:xF3 := "SA4"
		obrw2:acolumns[4]:ldeleted := .t.
		oBrw2:SetEditCell( .t. )                    // Ativa edit and code block for validation
		oBrw2:SetInsert(.t.)                        // Indica que o usuário poderá inserir novas linhas no Browse.
		oBrw2:SetAddLine( { || AddLin(oBrw2,6) } )	// Indica a Code-Block executado para adicionar linha no browse.
		oBrw2:SetLineOk( { || .t. } )               // Indica o Code-Block executado na troca de linha do Browse.
		//oBrw2:SetChange({ || .t. })               // Indica a Code-Block executado após a mudança de uma linha.
		oBrw2:SetDelete(.t., { || DelLin(oBrw2) } ) // Indica que o usuário pode excluir linhas no Browse.
		oBrw2:SetDelOk( { || .t. } ) 	            // Indica o Code-Block executado para validar a exclusão da linha.
		oBrw2:SetBlkBackColor( { || verCor(oBrw2)} )
	endif
	oBrw2:Activate(.t.)

    /*******************************************************/

	ACTIVATE MSDIALOG oDlg CENTERED

Return


Static Function addLin(oObj,nTam)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0

	if oObj:nAt > 1
		for nI := 1 to len(aObj)
			if aObj[nI,1] != 'XX'
				nX := val(aObj[nI,1])
			endif
		next
		++nX
		Aadd(aObj, {strzero( nX ,2), space(nTam), space(40), space(nTam)  } )
	endif

return


Static Function delLin(oObj)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0
	//Local aColTmp := {}

	if aObj[oObj:nAt,1] == 'XX'
		aObj[oObj:nAt,1] := 'TT'
		for nI := 1 to len(aObj)
			if aObj[nI,1] != 'XX'
				++nX
				aObj[nI,1] := strzero(nx,2)
			endif
		next
	else
		aObj[oObj:nAt,1] := 'XX'
	endif
	oObj:setArray( aObj )
	oObj:refresh(.t.)
	for nI := 1 to len(aObj)
		oObj:LineRefresh(nI-1)
	next
	oObj:refresh(.t.)

return


Static Function verCor(oObj)
	Local aObj := oObj:oData:aArray
	Local oCor

	if aObj[oObj:nAt, 1] == 'XX'
		oCor := CLR_HGRAY
	else
		oCor := nil //CLR_WHITE //CLR_HBLUE
	endif

return(oCor)


Static Function preench(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.
	Local cDesc := ""

	if aObj[oObj:nAt, 1] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
	elseif empty(aObj[oObj:nAt, 4])
		if oObj:aColumns[nCol]:xF3 == "SE4"
			if !se4->(dbseek(xfilial()+&(cVar))) .or. se4->e4_msblql == "1"
				lRet := .f.
			else
				cDesc := se4->e4_descri
			endif
		elseif oObj:aColumns[nCol]:xF3 == "SA4"
			if !sa4->(dbseek(xfilial()+&(cVar))) .or. sa4->a4_msblql == "1"
				lRet := .f.
			else
				cDesc := sa4->a4_nome
			endif
		endif
		if lRet
			aObj[oObj:nAt,nCol] := &(cVar)
			aObj[oObj:nAt,nCol+1] := cDesc
		else
			aObj[oObj:nAt,nCol+1] := "? ou Bloqueado"
		endif

		//oObj:setArray( aObj )
		//oObj:refresh(.t.)
	elseif &(cVar) != aObj[oObj:nAt, 4]
		MsgAlert("Esta linha não pode ser alterada. Favor exclui-la e incluir uma nova linha com o novo código! ", "Inconsistência" )
		lRet := .f.
		&(cVar) := aObj[oObj:nAt, 4]
		//oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)


Static Function confPerf(nOpc,oBrw1,oBrw2)

	Local lRet := .t.
	Local nId  := 0
	Local nIp  := 0
	Local cTipo := ""
	Local aTud := {oBrw1,oBrw2}
	Local aObj := {}
	Local lCond := .f.

	if nOpc < 0 .or. nOpc > 2
		MsgInfo("A operacao que esta sendo usada esta incorreta. Favor falar com responsavel sistema! ","Atenção")
		Return .f.
	endif

	for nIp := 1 to len(aTud)
		if aTud[nIp]:aColumns[2]:xF3 == "SE4"
			cTexto := "Condição de pagamento"
		elseif aTud[nIp]:aColumns[2]:xF3 == "SA4"
			cTexto := "Transportadora"
		endif
		aObj := aTud[nIp]:oData:aArray
		for nId := 1 to len(aObj)
			if aObj[nId,1] != 'XX'
				if empty(aObj[nId,2])
					MsgInfo("Verifique preenchimento da "+cTexto+" no item "+aObj[nId,1]+" ! ","Atenção")
					Return .f.
				endif
				if aTud[nIp]:aColumns[2]:xF3 == "SE4"
					if !empty(m->a1_cond) .and. aObj[nId,2] == m->a1_cond
						lCond := .t.
					endif
				endif
			endif
		next
	next

    /*
	for nId := 1 to len(aObj)
		if aObj[nId,1] != 'XX'
			if empty(aObj[nId,2])
				MsgInfo("Verifique preenchimento da Condição de pagamento no item "+aObj[nId,1]+" ! ","Atenção")
				Return .f.
			endif
		endif
	next

	aObj := oBrw2:oData:aArray
	for nId := 1 to len(aObj)
		if aObj[nId,1] != 'XX'
			if empty(aObj[nId,2])
				MsgInfo("Verifique preenchimento da transportadora no item "+aObj[nId,1]+" ! ","Atenção")
				Return .f.
			endif
		endif
	next
    */

	if nOpc != 0 .and. MsgYesNo("Confirma atualização ?","ATENÇÃO","YESNO")

		for nIp := 1 to len(aTud)
			if aTud[nIp]:aColumns[2]:xF3 == "SE4"
				cTipo := "C"
			elseif aTud[nIp]:aColumns[2]:xF3 == "SA4"
				cTipo := "T"
			endif
			aObj := aTud[nIp]:oData:aArray
			for nId := 1 to len(aObj)
				if aObj[nId,1] != 'XX' .and. nOpc != 3
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo+aObj[nId,2] ) )
						sz2->(RecLock("SZ2",.f.))
					else
						sz2->(RecLock("SZ2",.t.))
						sz2->z2_filial := sz2->(xfilial())
						sz2->z2_codcli := m->a1_cod
						sz2->z2_lojcli := m->a1_loja
						sz2->z2_tipo   := cTipo
						sz2->z2_codigo := aObj[nId,2]
					endif
					sz2->(MsUnLock())

					if aTud[nIp]:aColumns[2]:xF3 == "SE4"
						if !lCond
							m->a1_cond := sz2->z2_codigo
						endif
					elseif aTud[nIp]:aColumns[2]:xF3 == "SA4"
						m->a1_transp := sz2->z2_codigo
					endif

				else
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo ) )
						sz2->(RecLock("SZ2",.f.))
						sz2->(DbDelete())
						sz2->(MsUnLock())
					endif
				endif
			next
		next
        /*
		if oBrw1:aColumns[2]:xF3 == "SE4"
			cTipo := "C"
			aObj := oBrw1:oData:aArray
			for nId := 1 to len(aObj)
				if aObj[nId,1] != 'XX' .and. nOpc != 3
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo ) )
						sz2->(RecLock("SZ2",.f.))
					else
						sz2->(RecLock("SZ2",.t.))
						sz2->z2_filial := sz2->(xfilial())
						sz2->z2_codcli := m->a1_cod
						sz2->z2_lojcli := m->a1_loja
						sz2->z2_tipo   := cTipo
					endif
					sz2->z2_codigo := aObj[nId,2]
					sz2->(MsUnLock())
					m->a1_cond := sz2->z2_codigo
				else
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo ) )
						sz2->(RecLock("SZ2",.f.))
						sz2->(DbDelete())
						sz2->(MsUnLock())
					endif
				endif
			next

		Endif
		if oBrw2:aColumns[2]:xF3 == "SA4"
			cTipo := "T"
			aObj := oBrw2:oData:aArray
			for nId := 1 to len(aObj)
				if aObj[nId,1] != 'XX' .and. nOpc != 3
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo ) )
						sz2->(RecLock("SZ2",.f.))
					else
						sz2->(RecLock("SZ2",.t.))
						sz2->z2_filial := sz2->(xfilial())
						sz2->z2_codcli := m->a1_cod
						sz2->z2_lojcli := m->a1_loja
						sz2->z2_tipo   := cTipo
					endif
					sz2->z2_codigo := aObj[nId,2]
					sz2->(MsUnLock())
					m->a1_transp := sz2->z2_codigo
				else
					if sz2->( DbSeek( xFilial()+m->a1_cod+m->a1_loja+cTipo ) )
						sz2->(RecLock("SZ2",.f.))
						sz2->(DbDelete())
						sz2->(MsUnLock())
					endif
				endif
			next
		endif
        */
	endif

Return lRet
