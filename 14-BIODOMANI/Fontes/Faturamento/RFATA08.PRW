#include "Protheus.ch"
#include "FwBrowse.ch"
#include "topconn.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

#define ID     1
#define FORMA  2
#define DTVENC 3
#define COND   4
#define DESCON 5
#define VALOR  6
#define AUTOR  7
#define DTAUT  8
#define TERMI  9

#define DS_MODALFRAME   128  // Sem o fechar window da tela

/* Função para coleta pagamentos */
User Function RFATA08(cNum,nOper)
	Local lRet := .f.
	Local lcont := .t.
	Local nIt   := 0

	Local nVlrTot := 0
	Local nVlrFre := 0
	Local nVlrIcm := 0
	Local nVlrIpi := 0
	Local nVlrSol := 0
	Local nVlrRec := 0

	Local aColFp

	Default nOper := 9999   // somente visualização

	DbSelectArea("SZ3")
	sc5->(DbSetOrder(1))
	if sc5->(DbSeek(xFilial()+cNum))

		// Se forma de pagamento for diversos (DV) faça operações com Pagamerntos diversos
		if sc5->c5_formapg == 'DV'

            /* IMPOSTOS */ 
			MaFisIni(sc5->c5_cliente,;                // 01 - Codigo Cliente/Fornecedor
			sc5->c5_lojacli,;                         // 02 - Loja do Cliente/Fornecedor
			Iif(sc5->c5_tipo $ "D;B", "F", "C"),;     // 03 - C:Cliente , F:Fornecedor
			sc5->C5_tipo,;                            // 04 - Tipo da NF
			sc5->c5_tipocli,;                         // 05 - Tipo do Cliente/Fornecedor
			MaFisRelImp(FunName(), {"SC5", "SC6"}),;  // 06 - Relacao de Impostos que suportados no arquivo
			,;                                        // 07 - Tipo de complemento
			,;                                        // 08 - Permite Incluir Impostos no Rodape .T./.F.
			"SB1",;                                   // 09 - Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
			FunName())                                // 10 - Nome da rotina que esta utilizando a funcao

			sc6->(DbSetOrder(1))
			sc6->(DbSeek(xFilial()+cNum))
			While !sc6->(EoF()) .and. sc6->c6_num == cNum

				++nIt

				sb1->(DbSeek(xFilial()+sc6->c6_produto))
				sf4->(DbSeek(xFilial()+sc6->c6_tes))
				if sf4->f4_duplic == 'S'
					MaFisAdd(sc6->c6_produto   , ;  // 01 - Codigo do Produto                    ( Obrigatorio )
					sc6->c6_tes                , ;  // 02 - Codigo do TES                        ( Opcional )
					sc6->c6_qtdven             , ;  // 03 - Quantidade                           ( Obrigatorio )
					sc6->c6_prcven             , ;  // 04 - Preco Unitario                       ( Obrigatorio )
					0                          , ;  // 05 - Desconto
					sc6->c6_nfori              , ;  // 06 - Numero da NF Original                ( Devolucao/Benef )
					sc6->c6_seriori            , ;  // 07 - Serie da NF Original                 ( Devolucao/Benef )
					0                          , ;  // 08 - RecNo da NF Original no arq SD1/SD2
					0                          , ;  // 09 - Valor do Frete do Item               ( Opcional )
					0                          , ;  // 10 - Valor da Despesa do item             ( Opcional )
					0                          , ;  // 11 - Valor do Seguro do item              ( Opcional )
					0                          , ;  // 12 - Valor do Frete Autonomo              ( Opcional )
					sc6->c6_valor              , ; // 13 - Valor da Mercadoria                  ( Obrigatorio )
					0                          , ;  // 14 - Valor da Embalagem                   ( Opcional )
					sb1->(RecNo())             , ;  // 15 - RecNo do SB1
					0)                              // 16 - RecNo do SF4
				endif

				//nVlrICM += MaFisRet(nIt, "IT_VALICM")
				//nVlrIPI += MaFisRet(nIt, "IT_VALIPI")
				//nVlrSol += MaFisRet(nIt, "IT_VALSOL")
				//nVlrTot += MaFisRet(nIt, "IT_TOTAL")
				//nVlrTot += sc6->c6_valor
				sc6->(DbSkip())
			End

			MaFisAlt("NF_FRETE"   , sc5->c5_frete)
			MaFisAlt("NF_AUTONOMO", sc5->c5_fretaut)
			MaFisAlt("NF_SEGURO"  , sc5->c5_seguro)
			MaFisAlt("NF_DESPESA" , sc5->c5_despesa)
			If sc5->c5_descont > 0
				MaFisAlt("NF_DESCONTO", Min(MaFisRet(, "NF_VALMERC")-0.01, sc5->c5_descont+MaFisRet(, "NF_DESCONTO")) )
			EndIf
			If sc5->c5_pdescab > 0
				MaFisAlt("NF_DESCONTO", A410Arred(MaFisRet(, "NF_VALMERC")*sc5->c5_pdescab/100, "C6_VALOR") + MaFisRet(, "NF_DESCONTO"))
			EndIf

			nVlrTot := MaFisRet(, "NF_TOTAL")
			nVlrFre := MaFisRet(, "NF_FRETE")
			nVlrICM := MaFisRet(, "NF_VALICM") + MaFisRet(, "NF_ICMFRETE")
			nVlrIPI := MaFisRet(, "NF_VALIPI")
			//nVlrSol := MaFisRet(, "NF_VALSOL")

			MaFisEnd()
            /* IMPOSTOS */

			nVlrRec := nVlrTot + nVlrIPI + nVlrSol

			if nVlrRec > 0

				aColFp := pegPag(cNum)

				if nOper = 9999                                 // nOper => 3 - Inclusão; 4 - Alteração; 5 - Exclusão; 6 - Cópia; 7 - Devolução de Compras
					lRet := telaPag(cNum,nVlrRec,aColFp)         // tela informações de pagamento na tela
				elseif nOper == 5
					delPag(cNum)
				else
					while lcont
						lRet := telaPag(cNum,nVlrRec,@aColFp,.t.) // tela informações de pagamento na tela
						lcont := !lRet
					end
					if lret
						delPag(cNum)
						incPag(cNum,aColFp)
					endif
				endif

			else
				delPag(cNum)
			endif

		elseif nOper != 9999
			delPag(cNum)
		else
			MsgAlert("O pedido de vendas "+cNum+" não possui forma de pagamento DIVERSOS, portanto essa rotina não pode ser visualizada.", "Inconsistêcnia Forma Pagamento")
			Return
		endif

	elseif nOper == 5
		delPag(cNum)
	else
		MsgInfo("O pedido de vendas "+cNum+" não foi encontrado !", "Inconsistêcnia")
	endif

Return

Static Function delPag(cNum)

	sz3->(DbSetOrder(1))
	sz3->(dbseek(xfilial()+cNum))
	while !sz3->(eof()) .and. sz3->z3_pedido == cNum

		sz3->(RecLock("SZ3",.f.))
		sz3->(DbDelete())
		sz3->(MsUnLock())

		sz3->(dbskip())
	end

return

Static Function incPag(cNum,aColFp)
	Local nI := 0

	for nI := 1 to len(aColFp)

		if aColFp[nI, ID] != 'XX'
			sz3->(RecLock("SZ3",.t.))
			sz3->z3_filial := sz3->(xfilial())
			sz3->z3_pedido := cNum
			sz3->z3_item   := aColFp[nI,ID]
			sz3->z3_forma  := aColFp[nI,FORMA]
			sz3->z3_dtvenc := aColFp[nI,DTVENC]
			sz3->z3_condpg := aColFp[nI,COND]
			sz3->z3_valor  := aColFp[nI,VALOR]
			sz3->z3_numaut := aColFp[nI,AUTOR]
			sz3->z3_dtaut  := aColFp[nI,DTAUT]
			sz3->z3_numter := aColFp[nI,TERMI]
			sz3->(MsUnLock())
		endif

	next

return

Static Function telaPag(cNum,nVlrRec,aColFp,lEdit)
	Local oDlg
	//Local oBrw
	Local oPn1
	Local oPnl
	Local oGet01
	Local oGet02
	Local oGet03
	Local oButton
	Local aOpcFor := {}

	Local nTamFor := 10
	Local nTamCon := TamSx3("E4_CODIGO")[1]
	Local nTamDco := TamSx3("E4_DESCRI")[1]

	Local nI := 0
	Local nVlrDig := 0

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	Local lRet := .f.

	Default lEdit := .f.

	Private oBrw

	//c5_formapg
	cSql := "select trim(x5_chave)||'-'||substring(x5_descri,1,15) opcfor,x5_chave from "+RetSQLName("SX5")+" x5 "
	cSql += "where x5_filial = '"+xFilial("SX5")+"' and x5_tabela = '24' and x5_chave in ('BO','CC','CD','CH','DA','R$') "
	cSql += "and x5.d_e_l_e_t_ = ' ' order by x5_chave"
	cSql := ChangeQuery( cSql )
	cTrb := GetNextAlias()
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)
	while !(ctrb)->( Eof() )
		Aadd(aOpcFor, (ctrb)->opcfor )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	for nI := 1 to len(aColFp)
		nVlrDig += aColFp[nI,VALOR]
	next

	DEFINE MSDIALOG oDlg TITLE "Pagamentos" FROM 000, 000  TO 500, 980 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,003,,oDlg,,,,,/*CLR_HCYAN*/,490,025)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cLabelText := "PEDIDO:"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cNum   ,cNum   := u)},oPn1,040,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cNum"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Vlr Recebimento:"
	oGet02 := TGet():New(003,053,{|u|If(PCount()==0,nVlrRec,nVlrRec:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nVlrRec",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	if lEdit
		cLabelText := "Vlr Digitado:"
		oGet03 := TGet():New(003,153,{|u|If(PCount()==0,nVlrDig,nVlrDig:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nVlrDig",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	endif

	@ 003, 430 BUTTON oButton PROMPT "Confirmar" SIZE 037, 012 action ( lRet:=iif(lEdit, iif(avaPag(cNum,nVlrRec,oBrw),oDlg:End(),.f.) ,oDlg:End()) ) OF oDlg PIXEL
	if lEdit
		@ 003, 365 BUTTON oButton PROMPT "Restaura/Deleta Linha" SIZE 060, 012 action oBrw:DelLine()						  OF oDlg PIXEL
	endif

	oPnl:=tPanel():New(025,003,,oDlg,,,,,/*CLR_HCYAN*/,490,150)
	oBrw:=fwBrowse():New()
	oBrw:SetOwner( oPnl )
	oBrw:SetDataArray()
	oBrw:SetArray( aColFp )
	oBrw:DisableConfig()
	oBrw:DisableReport()
	oBrw:SetLocate()                     // Habilita a Localização de registros

	oBrw:addColumn({"Id"          , {||aColFp[oBrw:nAt,01]}, "C", "@!"               , 1, 02     , 0, .F.  ,                                     , .F., , "cItem" , , .F., .T.,        , "cItem"  })
	oBrw:addColumn({"Forma Pgto"  , {||aColFp[oBrw:nAt,02]}, "C", "@!"               , 1, nTamFor, 0, lEdit, { || verFor(oBrw,FORMA)  }          , .F., , "cForma", , .F., .T., aOpcFor, "cForma" })
	oBrw:addColumn({"Dt Vencto"   , {||aColFp[oBrw:nAt,03]}, "D", "@D"               , 1, 08     , 0, lEdit, { || verDtven(oBrw,DTVENC) }        , .F., , "dDtVen", , .F., .T.,        , "dDtVen" })
	oBrw:addColumn({"Cond Pgto"   , {||aColFp[oBrw:nAt,04]}, "C", "@!"               , 1, nTamCon, 0, lEdit, { || verCond(oBrw,COND) }           , .F., , "cCond" , , .F., .T.,        , "cCond"  })
	oBrw:addColumn({"Desc.Cond"   , {||aColFp[oBrw:nAt,05]}, "C", "@!"               , 1, nTamDco, 0, .F.  ,                                     , .F., , "cDcond", , .F., .T.,        , "cDcond" })
	oBrw:addColumn({"Valor"       , {||aColFp[oBrw:nAt,06]}, "N", "@E 99,999,999.99" , 2, 13     , 2, lEdit, { || verVal(oBrw,@nVlrDig,VALOR) }  , .F., , "nValor", , .F., .T.,        , "nValor" })
	oBrw:addColumn({"Autorização" , {||aColFp[oBrw:nAt,07]}, "C", "@!"               , 1, 06     , 0, lEdit, { || verAut(oBrw,AUTOR)  }          , .F., , "cAutor", , .F., .T.,        , "cAutor" })
	oBrw:addColumn({"Dt Autoriza" , {||aColFp[oBrw:nAt,08]}, "D", "@D"               , 1, 08     , 0, lEdit, { || verDau(oBrw,DTAUT)  }          , .F., , "dDtAut", , .F., .T.,        , "dDtAut" })
	oBrw:addColumn({"Terminal"    , {||aColFp[oBrw:nAt,09]}, "C", "@!"               , 1, 06     , 0, lEdit, { || verTer(oBrw,TERMI)  }          , .F., , "cTermi", , .F., .T.,        , "cTermi" })

	if lEdit
		oBrw:aColumns[COND]:xF3 := "SE4"
		oBrw:aColumns[TERMI]:xF3 := "SZ1"
		//oBrw:SetEditCell( .t. , { || .t. } )      // Ativa edit and code block for validation
		oBrw:SetEditCell( .t. )      // Ativa edit and code block for validation
		oBrw:SetInsert(.t.)                       // Indica que o usuário poderá inserir novas linhas no Browse.
		oBrw:SetAddLine( { || AddLin(oBrw) } )	  // Indica a Code-Block executado para adicionar linha no browse.
		oBrw:SetLineOk( { || VerLin(oBrw) } )     // Indica o Code-Block executado na troca de linha do Browse.
		//oBrw:SetChange({ || .t. })       		  //Indica a Code-Block executado após a mudança de uma linha.
		oBrw:SetDelete(.t., { || DelLin(oBrw) } ) // Indica que o usuário pode excluir linhas no Browse.
		oBrw:SetDelOk( { || verDel(oBrw) } ) 	  // Indica o Code-Block executado para validar a exclusão da linha.

		oBrw:SetBlkBackColor( { || verCor(oBrw)} )
	endif

	oBrw:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

return(lRet)

Static Function verFor(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !(substr(&(cVar),1,2) $ "CC,CD")
		if !empty(aObj[oObj:nAt,AUTOR]) .or. !empty(aObj[oObj:nAt,DTAUT]) .or. !empty(aObj[oObj:nAt,TERMI])
			lRet := .f.
			MsgInfo("Os consteúdos dos campos Autorização , data autorização e terminal devem ser apagados, pois não se trata de pagamentos com cartão crédito/débito !", "Inconsistêcnia")
		endif
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		if substr(&(cVar),1,2) $ "DA|R$"
			aObj[oObj:nAt,DTVENC] := datavalida(dDatabase+3)
		endif
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)

Static Function verDtven(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !empty(&(cVar)) .and. !empty(aObj[oObj:nAt,COND])
		lRet := .f.
		MsgInfo("Quando Cond. pagamento for digitada, a Dt do vencimento não deverá ser digitada também !", "Inconsistêcnia")
	endif

	if empty(aObj[oObj:nAt,COND]) .and. dtos(dDatabase) > dtos(dDtVen)
		lRet := .f.
		MsgInfo("Data do vencimento menor que data atual !", "Inconsistêcnia")
	elseif substr(aObj[oObj:nAt,FORMA],1,2) $ "DA|R$" .and. dtos(datavalida(dDatabase+3)) != dtos(dDtVen)
		lRet := .f.
		MsgInfo("Quando forma de pagamento for Depósito Antecipado o vencimento deve ser + 3 dias da data do sistema !", "Inconsistêcnia")
		aObj[oObj:nAt,nCol] := datavalida(dDatabase+3)
		dDtVen := datavalida(dDatabase+3)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)

Static Function verCond(oObj,nCol)
	Local aObj := oObj:oData:aArray
	local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !empty(&(cVar))
		if !empty(aObj[oObj:nAt,DTVENC])
			lRet := .f.
			MsgInfo("Quando data vencimento for digitada, a forma de pgto não deverá ser digitada também !", "Inconsistêcnia")
		else

			if se4->(dbseek(xfilial()+&(cVar))) .and. se4->e4_msblql != "1"
				aObj[oObj:nAt,DESCON] := se4->e4_descri
			else
				lRet := .f.
				aObj[oObj:nAt,DESCON] := "? ou Bloqueado"
			endif

		endif
	else
		aObj[oObj:nAt,DESCON] := " "
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)


Static Function verVal(oObj,nVlrDig,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.
	Local nI := 0

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)

		nVlrDig := 0
		for nI := 1 to len(aObj)
			nVlrDig += aObj[nI,nCol]
		next

	endif

return(lRet)


Static Function verAut(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !(substr(aObj[oObj:nAt,FORMA],1,2) $ "CC,CD") .and. !empty(&(cVar))
		lRet := .f.
		MsgInfo("A autorização não deve ser digitada, pois não se trata de cartão !", "Inconsistêcnia")
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)

Static Function verDau(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !(substr(aObj[oObj:nAt,FORMA],1,2) $ "CC,CD") .and. !empty(&(cVar))
		lRet := .f.
		MsgInfo("A data da autorização não deve ser digitada, pois não se trata de cartão !", "Inconsistêcnia")
	endif

	if lRet
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

return(lRet)

Static Function verTer(oObj,nCol)
	Local aArea:= getarea()
	Local aAreaSZ1 := sz1->(getarea())
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !(substr(aObj[oObj:nAt,FORMA],1,2) $ "CC,CD") .and. !empty(&(cVar))
		lRet := .f.
		MsgInfo("O código do terminal não deve ser digitada, pois não se trata de cartão !", "Inconsistêcnia")
	endif

	if lRet
		if !empty(&(cVar))
			sz1->(DbSetOrder(1))
			if !sz1->(DbSeek(xFilial()+&(cVar)))
				lRet := .f.
				MsgInfo("O código do terminal não esta registrado. Favor verificar !", "Inconsistêcnia")
			endif
			Restarea(aAreaSZ1)
		endif
		aObj[oObj:nAt,nCol] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
	endif

	RestArea(aArea)
return(lRet)

Static Function addLin(oObj)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0

	if oObj:nAt > 1
		for nI := 1 to len(aObj)
			if aObj[nI,ID] != 'XX'
				nX := val(aObj[nI,ID])
			endif
		next
		++nX
		Aadd(aObj, {strzero( nX ,2), space(TamSx3("X5_CHAVE")[1]), stod(' '),space(TamSx3("E4_CODIGO")[1]),space(TamSx3("E4_DESCRI")[1]), 0, space(6), stod(' '), space(6) } )
		//Aadd(aObj, {strzero( val(aObj[oObj:nAt-1,ID] ) + 1 ,2), space(TamSx3("X5_CHAVE")[1]), stod(' '),space(TamSx3("E4_CODIGO")[1]),space(TamSx3("E4_DESCRI")[1]), 0, space(6), stod(' '), space(6) } )
	endif

return

Static Function verLin(oObj,nLin)
	Local aObj := oObj:oData:aArray
	Local lRet := .t.

	Default nLin := oObj:nAt

	if aObj[nLin, ID] == 'XX'
		return(lRet)
	endif

	if (empty(aObj[nLin,FORMA]) .or. aObj[nLin,VALOR] == 0)
		MsgInfo("Campos da FORMA e VALOR da linha atual devem ser preenchidos", "Inconcistência")
		lRet := .f.
	elseif substr(aObj[nLin,FORMA],1,2) $ "CC,CD" .and. ;
			( empty(aObj[nLin,AUTOR]) .or. empty(aObj[nLin,DTAUT]) .or. empty(aObj[nLin,TERMI]) )
		MsgInfo("Quando forma for cartão as informações Autorização, data da autorização e terminal devem se preenchidos!", "Inconcistência")
		lRet := .f.
	else
		if !empty(aObj[nLin,COND])
			if !empty(aObj[nLin,DTVENC])
				lRet := .f.
				MsgInfo("Quando data vencimento for digitada, a forma de pgto não deverá ser digitada também !", "Inconsistêcnia")
			endif
		elseif empty(aObj[nLin,DTVENC])
			lRet := .f.
			MsgInfo("Deve ser digitado Condição de pgto ou Data vencimento !", "Inconsistêcnia")
		elseif dtos(dDatabase) > dtos(aObj[nLin,DTVENC])
			lRet := .f.
			MsgInfo("Data do vencimento menor que data atual !", "Inconsistêcnia")
		endif
	endif

return(lRet)

Static Function verDel(oObj)
	Local aObj := oObj:oData:aArray
	Local lRet := .t.
	Local cOper:= 'Exclusão'

	if aObj[oObj:nAt,ID] == 'XX'
		cOper := 'Recuperação'
	endif

	if !MsgYesNo("Confirma "+cOper+" da linha "+aObj[oObj:nAt,ID]+" selecionada ?", cOper+" da linha")
		lRet := .f.
	endif

return(lRet)

Static Function delLin(oObj)
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nX := 0
	//Local aColTmp := {}

	if aObj[oObj:nAt,ID] == 'XX'
		aObj[oObj:nAt,ID] := 'TT'
		for nI := 1 to len(aObj)
			if aObj[nI,ID] != 'XX'
				++nX
				aObj[nI,ID] := strzero(nx,2)
			endif
		next
	else
		aObj[oObj:nAt,ID] := 'XX'
	endif
	oObj:setArray( aObj )
	oObj:refresh(.t.)
	for nI := 1 to len(aObj)
		oObj:LineRefresh(nI-1)
	next
	oObj:refresh(.t.)

   /*
   oObj:acolumns[6]:readvar()
   oObj:setArray( aObj )
   oObj:GoBottom()
   oObj:GoTop()
   oObj:refresh()
   ttl:= oObj:At()
   oObj:LineRefresh(ttl)
   oObj:GoTo(ttl,.t.)
   ttc:= oObj:ColPos()
   ttl:= oObj:At()
   cc := readVar()
   oObj:GoColumn(6)
   ttc:= oObj:ColPos()
   ttl:= oObj:At()
   cc := readVar()
   */
return


Static Function verCor(oObj)
	Local aObj := oObj:oData:aArray
	Local oCor

	if aObj[oObj:nAt, ID] == 'XX'
		oCor := CLR_HGRAY
	else
		oCor := nil //CLR_WHITE //CLR_HBLUE
	endif

return(oCor)

Static Function avaPag(cNum,nVlrRec,oObj)
	Local lRet := .t.
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nVlrPag := 0

	for nI := 1 to len(aObj)
		if aObj[nI, ID] != 'XX'
			nVlrPag += aObj[nI,VALOR]
			lRet := verLin(oObj,nI)
			if !lRet
				exit
			endif
		endif
	next

	if lRet .and. nVlrRec != nVlrPag
		lRet := .f.
		MsgInfo("O Valor digitado na tela de pagamentos (R$"+alltrim(transform(nVlrPag,"@E 99,999,999.99"))+") é diferente ao total do pedido de vendas (R$"+alltrim(transform(nVlrRec,"@E 99,999,999.99"))+") !", "Inconsistêcnia")
	endif

return(lRet)

Static Function pegPag(cNum)
	Local cSql := ""
	Local aColFp := {}
	Local cTrb := GetNextAlias()

	cSql := "select * from "+RetSQLName("SZ3")+" z3 "
	cSql += "inner join "+RetSQLName("SX5")+" x5 on x5_filial = '"+xFilial("SX5")+"' and x5_tabela ='24' "
	cSql += "and x5_chave = z3_forma and x5.d_e_l_e_t_ = ' ' "
	cSql += "left join "+RetSQLName("SE4")+" e4 on e4_filial = '"+xFilial("SE4")+"' and e4_codigo = z3_condpg "
	cSql += "and e4.d_e_l_e_t_ = ' ' "
	cSql += "where z3_filial = '"+xFilial("SZ3")+"' and z3_pedido = '"+cNum+"' and z3.d_e_l_e_t_ = ' ' "
	cSql += "order by z3_item"

	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)

	while !(ctrb)->( Eof() )
		Aadd(aColFp, { (ctrb)->z3_item, (ctrb)->z3_forma+"-"+substr((ctrb)->x5_descri,1,20), StoD((ctrb)->z3_dtvenc), (ctrb)->z3_condpg, (ctrb)->e4_descri , (ctrb)->z3_valor, (ctrb)->z3_numaut, StoD((ctrb)->z3_dtaut), (ctrb)->z3_numter } )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	if empty(aColFp)
		aColFp := { {'01', space(TamSx3("X5_CHAVE")[1]), stod(' '),space(TamSx3("E4_CODIGO")[1]),space(TamSx3("E4_DESCRI")[1]), 0, space(6), stod(' '), space(6) } }
	endif

return(aColFp)
