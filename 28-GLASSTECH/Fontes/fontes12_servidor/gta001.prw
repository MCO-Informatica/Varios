#include "Protheus.ch"
#include "FwBrowse.ch"
#include "tbiconn.ch"
#include "tbicode.ch"

#define ID     1
#define DTVENC 2
#define VALOR  3

#define DS_MODALFRAME   128  // Sem o fechar window da tela

/* Função para coleta pagamentos */
User Function gta001(cNum,nOper)
	Local lRet  := .f.
	Local lcont := .t.

	Local cForn := ""
	Local cLoja := ""
	Local cNaturez := ""

	Local nVlrPag := 0
	Local nVlrTot := 0
	Local nFrete  := 0
	Local nEmbal  := 0
	Local nIpi    := 0
	Local nDesp   := 0
	Local nIcmsRet:= 0
	Local nDesc   := 0
	Local cNumE2  := StrZero( Val(cNum), 9 )

	Local lFrete := .f.

	Local aColFp

	Default nOper := 9999   // somente visualização

	Private cPref := "PC "	// getnewpar("MV_3DUPREF", "PC")

	sc7->(DbSetOrder(1))
	if sc7->(DbSeek(xFilial()+cNum))

		cForn := sc7->c7_fornece
		cLoja := sc7->c7_loja

		sa2->(DbSetOrder(1))
		sa2->(DbSeek(xFilial()+cForn+cLoja))
		cNaturez := sa2->a2_naturez

		se4->(DbSetOrder(1))
		if se4->(DbSeek(xFilial()+sc7->c7_cond)) .and. se4->e4_ctradt == "1"    //com adiantamento
			//E4_COND	Cond. Pagto	Condicao de pagto	C	Real	40
			//E4_DESCRI	Descricao	Descricao da Cond. Pagto	C	Real	15
			lFrete := .f.
			if sc7->c7_frete != 0
				nFrete += sc7->c7_frete
				lFrete := .t.
			endif

			While !sc7->(EoF()) .and. sc7->c7_num == cNum

				nVlrTot += sc7->c7_total
				if !lFrete
					nFrete += sc7->c7_valfre
				endif
				nDesc   += sc7->c7_vldesc
				nEmbal  += sc7->c7_valemb
				nIpi    += sc7->c7_valipi
				nDesp   += sc7->c7_despesa
				nIcmsRet+= sc7->c7_icmsret

				sc7->(DbSkip())
			End

			nVlrPag := nVlrTot + nFrete + nEmbal + nIpi + nDesp + nIcmsRet - nDesc

			if nVlrPag > 0

				aColFp := pegPag(cNumE2)

				if nOper = 9999								// nOper => 3 - Inclusão; 4 - Alteração; 5 - Exclusão; 6 - Cópia; 7 - Devolução de Compras
					lRet := telaPag(cNum,nVlrPag,aColFp)   	// tela informações de pagamento na tela
				elseif nOper == 5
					delPag(cNumE2)
				else
					while lcont
						lRet := telaPag(cNum,nVlrPag,@aColFp,.t.)	// tela informações de pagamento na tela
						lcont := !lRet
					end
					if lret
						delPag(cNumE2)
						incPag(cNumE2,cForn,cLoja,cNaturez,aColFp)
					endif
				endif

			else
				delPag(cNumE2)
			endif
		else
			delPag(cNumE2)
		endif

	elseif nOper == 5
		delPag(cNumE2)
	else
		MsgInfo("O pedido de vendas "+cNum+" não foi encontrado !", "Inconsistêcnia")
	endif

Return

Static Function telaPag(cNum,nVlrPag,aColFp,lEdit)
	Local oDlg
	//Local oBrw
	Local oPn1
	Local oPnl
	Local oGet01
	Local oGet02
	Local oGet03
	Local oButton

	Local nI := 0
	Local nVlrDig := 0

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	Local lRet := .f.

	Default lEdit := .f.

	Private oBrw

	for nI := 1 to len(aColFp)
		nVlrDig += aColFp[nI,VALOR]
	next

	DEFINE MSDIALOG oDlg TITLE "Pagamentos" FROM 000, 000  TO 350, 798 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .f.

    oPn1 := tPanel():New(000,003,,oDlg,,,,,/*CLR_HCYAN*/,390,025)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cLabelText := "PEDIDO:"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cNum   ,cNum   := u)},oPn1,040,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cNum"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Vlr Pagamento:"
	oGet02 := TGet():New(003,053,{|u|If(PCount()==0,nVlrPag,nVlrPag:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nVlrPag",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	if lEdit
		cLabelText := "Vlr Digitado:"
		oGet03 := TGet():New(003,153,{|u|If(PCount()==0,nVlrDig,nVlrDig:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nVlrDig",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	endif

	@ 003, 330 BUTTON oButton PROMPT "Confirmar" SIZE 037, 012 action ( lRet:=iif(avaPag(cNum,nVlrPag,oBrw),oDlg:End(),.f.) ) OF oDlg PIXEL
	if lEdit
		@ 003, 265 BUTTON oButton PROMPT "Restaura/Deleta Linha" SIZE 060, 012 action oBrw:DelLine()						  OF oDlg PIXEL
	endif

	oPnl:=tPanel():New(025,003,,oDlg,,,,,/*CLR_HCYAN*/,390,150)
	oBrw:=fwBrowse():New()
	oBrw:SetOwner( oPnl )
	oBrw:SetDataArray()
	oBrw:SetArray( aColFp )
	oBrw:DisableConfig()
	oBrw:DisableReport()
	oBrw:SetLocate()                     // Habilita a Localização de registros

	oBrw:addColumn({"Id"        , {||aColFp[oBrw:nAt,01]}, "C", "@!"               , 1, 02     , 0, .F.  ,                                     , .F., , "cItem" , , .F., .T.,        , "cItem"  })
	oBrw:addColumn({"Dt Vencto" , {||aColFp[oBrw:nAt,02]}, "D", "@D"               , 1, 08     , 0, lEdit, { || verDtven(oBrw,DTVENC) }        , .F., , "dDtVen", , .F., .T.,        , "dDtVen" })
	oBrw:addColumn({"Valor"     , {||aColFp[oBrw:nAt,03]}, "N", "@E 99,999,999.99" , 2, 13     , 2, lEdit, { || verVal(oBrw,@nVlrDig,VALOR) }  , .F., , "nValor", , .F., .T.,        , "nValor" })

	if lEdit
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


Static Function verDtven(oObj,nCol)
	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.

	if aObj[oObj:nAt, ID] == 'XX'
		MsgInfo("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
		return(lRet)
	endif

	if !empty(&(cVar)) .and. dtos(&(cVar)) < dtos(dDataBase)
		lRet := .f.
		MsgInfo("Data vencimento não pode ser menor que data do sistema !", "Inconsistêcnia")
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
		MsgInfo("Esta linha esta marcada como deletada! ", "Inconsistência" )
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
		Aadd(aObj, {strzero( nX ,2), stod(' '), 0 } )
	endif

return


Static Function verLin(oObj,nLin)
	Local aObj := oObj:oData:aArray
	Local lRet := .t.

	Default nLin := oObj:nAt

	if aObj[nLin, ID] == 'XX'
		return(lRet)
	endif

	if aObj[nLin,VALOR] == 0
		lRet := .f.
		MsgInfo("Campos VALOR da linha atual devem ser preenchidos", "Inconcistência")
	elseif empty(aObj[nLin,DTVENC]) .and. dtos(aObj[nLin,DTVENC]) < dtos(dDataBase)
		lRet := .f.
		MsgInfo("Deve ser digitado Condição de pgto ou Data vencimento !", "Inconsistêcnia")
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


Static Function avaPag(cNum,nVlrPag,oObj)
	Local lRet := .t.
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nVlrDig := 0

	for nI := 1 to len(aObj)
		if aObj[nI, ID] != 'XX'
			nVlrDig += aObj[nI,VALOR]
			lRet := verLin(oObj,nI)
			if !lRet
				exit
			endif
		endif
	next

	if nVlrDig > nVlrPag
		lRet := .f.
		MsgInfo("O Valor digitado na tela de pagamentos (R$"+alltrim(transform(nVlrRec,"@E 99,999,999.99"))+") é maior que total do pedido de compras (R$"+alltrim(transform(nVlrPag,"@E 99,999,999.99"))+") !", "Inconsistêcnia")
	endif

return(lRet)


Static Function pegPag(cNum)
	Local cSql  := ""
	Local aColFp:= {}
	Local cTrb  := GetNextAlias()
	Local nI    := 0

	cSql := "select * from "+RetSQLName("SE2")+" e2 "
	cSql += "where e2_filial = '"+xFilial("SE2")+"' and e2_prefixo = '"+cPref+"' and e2_num = '"+cNum+"' and e2.d_e_l_e_t_ = ' ' "
	cSql += "order by e2_parcela"

	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),ctrb,.F.,.T.)

	while !(ctrb)->( Eof() )
		nI += 1 
		Aadd(aColFp, { strzero(nI,2), StoD((ctrb)->e2_vencrea), (ctrb)->e2_valor } )
		(ctrb)->( DbSkip() )
	End
	(ctrb)->( DbCloseArea() )

	if empty(aColFp)
		aColFp := { {'01', stod(' '), 0 } }
	endif

return(aColFp)


Static Function delPag(cNum)

	Local cError := ""

	se2->(DbSetOrder(1))
	se2->(dbseek(xfilial()+cPref+cNum))
	while !se2->(eof()) .and. se2->e2_prefixo == cPref .and. se2->e2_num == cNum

		aDuplic :={	{"E2_FILIAL"	,xfilial("SE2")	,Nil},;
			{"E2_PREFIXO"			,cPref			,Nil},;
			{"E2_NUM"				,cNum			,Nil},;
			{"E2_PARCELA"			,se2->e2_parcela,Nil},;
			{"E2_TIPO"				,se2->e2_tipo   ,Nil}}

		cError := u_fazFina050(aDuplic, 5, .f., "", "")
		if !empty(cError)
			MsgInfo(cError, "Inconsistência" )
		endif

		se2->(dbskip())
	end

return

Static Function incPag(cNum,cForn,cLoja,cNaturez,aColFp)
	Local nI := 0
	Local cX := "0"

	for nI := 1 to len(aColFp)

		if aColFp[nI, ID] != 'XX'

			cX := soma1(cX)
			aDuplic :={	{"E2_FILIAL"	,xfilial("SE2")	,Nil},;
				{"E2_PREFIXO"			,cPref			,Nil},;
				{"E2_NUM"				,cNum			,Nil},;
				{"E2_PARCELA"			,cX				,Nil},;
				{"E2_TIPO"				,'PR'			,Nil},;
				{"E2_NATUREZ"			,cNaturez		,Nil},;
				{"E2_FORNECE"			,cForn			,Nil},;
				{"E2_LOJA"				,cLoja			,Nil},;
				{"E2_EMISSAO"			,dDataBase		,NIL},;
				{"E2_VENCTO"			,aColFp[nI, DTVENC],NIL},;
				{"E2_VENCREA"			,DataValida( aColFp[nI, DTVENC] ),NIL},;
                {"E2_HIST"			    ,"PAGAMENTO ANTECIPADO PARA PC "+substr(cNum,4,6) ,NIL},;
				{"E2_VALOR"				,aColFp[nI, VALOR] ,Nil}}

			cError := u_fazFina050(aDuplic, 3, .f., "", "")
			if !empty(cError)
				MsgInfo(cError, "Inconsistência" )
			endif

		endif

	next

return


User Function fazFina050(aDuplic, nOpc, lAmb, cGruDest, cFilDest)

	Local nI := 0
	Local aLog := {}
	Local cError := ""
	Local oError := ErrorBlock( { |e| cError := e:Description} )
	Local cOpc	:= ""

	if nOpc == 3
		cOpc := "Inclusão"
	elseif nOpc == 4
		cOpc := "Alteração"
	elseif nOpc == 5
		cOpc := "Exclusão"
	endif

	Private lMsErroAuto := .f.

	Begin sequence

		if lAmb
			//RpcClearEnv()
			RpcSetType( 3 )
			RpcSetEnv( cGruDest, cFilDest,,,'COM','FAZMATA140')
		endif

		if len(aDuplic) > 0
			MSExecAuto({|x,y,z| Fina050(x,y,z)},aDuplic,,nOpc)
			If lMsErroAuto
				cError += "Erro "+cOpc+": "
				aLog := GetAutoGRLog()
				For nI := 1 To Len(aLog)
					cError += aLog[nI]+chr(13)+chr(10)
				Next
			Endif
		else
			cError += "Erro "+cOpc+": Não foi passado nenhum título"
		endif

		if lAmb
			RpcClearEnv()
		endif

	End sequence

	ErrorBlock(oError)	//Restaurando bloco de erro do sistema
	If !Empty(cError)	//Se houve erro, será mostrado ao usuário
		cError := "Falha :"+chr(13)+chr(10)+"Título: " +aDuplic[2,2]+chr(13)+chr(10)+"Parcela: "+aDuplic[3,2]+chr(13)+chr(10)+substr(cError,1,150)
	EndIf

Return cError
