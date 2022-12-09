#include "Protheus.ch"
#include "FwBrowse.ch"
//#include "topconn.ch"
//#include "tbiconn.ch"
//#include "tbicode.ch"

#define IT     1
#define CODPRO 2
#define DESCRI 3
#define LOCAL  4
#define ENDERE 5
#define QTDENT 6
#define QITVOL 7

#define ID     1
#define QTDVOL 2
#define QTDIT  3
#define OPERA  4

#define VIT     1
#define VLOCAL  2
#define VENDER  3
#define VID     4
#define VQTDVOL 5
#define VQTDIT  6
#define VOPERA  7

#define DS_MODALFRAME   128  // Sem o fechar window da tela

/* Função para coleta pagamentos */
User Function rcoma001(nMenu)	//nMenu chamado do programa de etiqueta (1) ou não (0)
	Local lRet := .f.
	local cSql := ""

	local cDoc  := sf1->f1_doc
	local cSerie:= sf1->f1_serie
	local nQtdvol := 0
	local aItens := {}
	Local aVol := {}	// item,id,qtdvol,qtdit,oper

	Local oDlg
	Local oBrw
	Local oPn1
	Local oPnl
	Local oGet01
	Local oGet02
	Local oButton1
	Local oButton2
	Local oButton3

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda

	Default nMenu := 0

	cSql := "select d1_filial,d1_doc,d1_serie,d1_fornece,d1_loja,d1_item,d1_cod,d1_descri,d1_local,d1_quant,"
	cSql += "d1_dtvalid,d1_lotectl,d1_numlote,'' d1_x_lforn,"
	cSql += "db_local,db_localiz,db_lotectl,db_numlote,db_quant "
	cSql += "from "+RetSqlName("SD1")+" d1 "
	cSql += "left join "+RetSqlName("SDB")+" db on db_filial = d1_filial and db_doc = d1_doc and db_serie = d1_serie "
	cSql += "and db_clifor = d1_fornece and db_loja = d1_loja and db_tiponf = d1_tipo "
	cSql += "and db_produto = d1_cod and db_local = d1_local and db_lotectl = d1_lotectl and db.d_e_l_e_t_ = ' ' "
	cSql += "where d1_filial = '"+sd1->(xfilial())+"' and d1_doc = '"+sf1->f1_doc+"' and d1_serie = '"+sf1->f1_serie+"' "
	cSql += "and d1_fornece = '"+sf1->f1_fornece+"' and d1_loja = '"+sf1->f1_loja+"' and d1.d_e_l_e_t_ = ' ' "
	//cSql += "and d1_local = '01A3' order by d1_item "
	cSql += "order by d1_item "
	//cSql := "select * from "+RetSQLName("SD1")+" d1 "
	//cSql += "inner join "+RetSQLName("SB1")+" b1 on b1_filial = '"+xFilial("SB1")+"' and b1_cod = d1_cod and b1.d_e_l_e_t_ = ' ' "
	//cSql += "where d1_filial = '"+sd1->(xfilial())+"' and d1_doc = '"+sf1->f1_doc+"' and d1_serie = '"+sf1->f1_serie+"' "
	//cSql += "and d1_fornece = '"+sf1->f1_fornece+"' and d1_loja = '"+sf1->f1_loja+"' and d1.d_e_l_e_t_ = ' ' "
	//cSql += "and d1_local = '01A3' "
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb",.F.,.T.)
	while !trb->( Eof() )
		nQtdvol := 0
		cSql := "select * from "+RetSQLName("sz4")+" z4 where z4_filial = '"+xFilial("sz4")+"' "
		cSql += "and z4_doc = '"+trb->d1_doc+"' and z4_serie = '"+trb->d1_serie+"' and z4_fornece = '"+trb->d1_fornece+"' "
		cSql += "and z4_loja = '"+trb->d1_loja+"' and z4_item = '"+trb->d1_item+"' "
		cSql += "and z4_local = '"+trb->d1_local+"' and z4_localiz = '"+trb->db_localiz+"' "
		cSql += "and z4.d_e_l_e_t_ = ' ' "
		cSql := ChangeQuery( cSql )
		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb1",.F.,.T.)
		while !trb1->( Eof() )
			Aadd(aVol, { trb->d1_item, trb->d1_local, trb->db_localiz, trb1->z4_itvol, trb1->z4_qtdvol, trb1->z4_qtdIte, "" } )
			nQtdvol += trb1->z4_qtdvol
			trb1->( DbSkip() )
		End
		trb1->( DbCloseArea() )
		Aadd(aItens, {trb->d1_item, trb->d1_cod, trb->d1_descri, trb->d1_local, trb->db_localiz, iif(empty(trb->db_quant),trb->d1_quant,trb->db_quant), nQtdvol} )
		trb->( DbSkip() )
	End
	trb->( DbCloseArea() )

	if len(aItens) == 0
		MsgInfo("A NF "+sf1->f1_doc+" não corresponde ao almoxarifado 01A3 !", "Inconsistêcnia")
		return .f.
	endif

	DEFINE MSDIALOG oDlg TITLE "Itens NF - Inclusão de volumes dos produtos" FROM 000, 000  TO 310, 980 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,003,,oDlg,,,,,/*CLR_HCYAN*/,490,025)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA

	cLabelText := "NF Entrada:"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cDoc  ,cDoc:= u  )},oPn1,040,10,"@!"    ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cDoc"   ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Série:"
	oGet02 := TGet():New(003,053,{|u|If(PCount()==0,cSerie,cSerie:= u)},oPn1,040,10,"@!"    ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cSeriec",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	@ 008, 290 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 action ( lRet:=avaTela(oBrw,@aVol), iif(lRet,oDlg:End(),.f.) ) OF oDlg PIXEL
	@ 008, 360 BUTTON oButton2 PROMPT "Incl. Volume"   SIZE 037, 012 action telaVol(@oBrw,@aVol) OF oDlg PIXEL
	if nMenu == 1
		@ 008, 430 BUTTON oButton3 PROMPT "Sair"   SIZE 037, 012 action ( lRet:=.f., oDlg:End() ) OF oDlg PIXEL
	endif

	oPnl:=tPanel():New(025,003,,oDlg,,,,,/*CLR_HCYAN*/,490,130)
	oBrw:=fwBrowse():New()
	oBrw:SetOwner( oPnl )
	oBrw:SetDataArray()
	oBrw:SetArray( aItens )
	oBrw:DisableConfig()
	oBrw:DisableReport()
	oBrw:SetLocate()                     // Habilita a Localização de registros

	oBrw:addColumn({"Item"        , {||aItens[oBrw:nAt,01]}, "C", "@!"               , 1, 02  , 0, .F.,  , .F., , "cItem"  , , .F., .T., , "cItem"   })
	oBrw:addColumn({"Cód.Prod"    , {||aItens[oBrw:nAt,02]}, "C", "@!"               , 1, 15  , 0, .F.,  , .F., , "cCodPro", , .F., .T., , "cCodPro" })
	oBrw:addColumn({"Descrição"   , {||aItens[oBrw:nAt,03]}, "C", "@!"               , 1, 30  , 0, .F.,  , .F., , "cDesc"  , , .F., .T., , "cDesc"   })
	oBrw:addColumn({"Local" 	  , {||aItens[oBrw:nAt,04]}, "C", "@!"               , 1, 04  , 0, .F.,  , .F., , "cLocal" , , .F., .T., , "cLocal"  })
	oBrw:addColumn({"Endereço"    , {||aItens[oBrw:nAt,05]}, "C", "@!"               , 1, 15  , 0, .F.,  , .F., , "cEndere", , .F., .T., , "cEndere" })
	oBrw:addColumn({"Quantidade"  , {||aItens[oBrw:nAt,06]}, "N", "@E 9,999,999.99"  , 2, 12  , 2, .F.,  , .F., , "nQuant" , , .F., .T., , "nQuant"  })
	oBrw:addColumn({"Volumes"     , {||aItens[oBrw:nAt,07]}, "N", "@E 9,999,999.99"  , 2, 12  , 2, .F.,  , .F., , "nVolu"  , , .F., .T., , "nVolu"   })

	oBrw:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

	if lRet
		incVol(sf1->f1_doc,sf1->f1_serie,sf1->f1_fornece,sf1->f1_loja,aVol)
	endif

Return lRet

Static Function avaTela(oObj,aVol)

	local lRet := .t.
	Local aObj := oObj:oData:aArray
	local nx := 0
	local nI := 0
	local nQtdDig := 0

	for nX := 1 to len(aObj)
		nQtdDig := 0
		for nI := 1 to len(aVol)
			if aObj[nX, IT] == aVol[nI, VIT] .and. ;
				aObj[nX, LOCAL] == aVol[nI, VLOCAL] .and. ;
				aObj[nX, ENDERE] == aVol[nI, VENDER] .and. aVol[nI, VOPERA] != 'X'
				nQtdDig += ( aVol[nI,VQTDVOL] * aVol[nI, VQTDIT] )
			endif
		next
		if aObj[nX, QTDENT] != nQtdDig
			lRet := .f.
			MsgInfo("O quantidade total digitada do item ("+alltrim(transform(nQtdDig,"@E 99,999,999.99"))+") é diferente ao total do item "+aObj[nX, IT]+" da NF ("+alltrim(transform(aObj[nX, QTDENT],"@E 99,999,999.99"))+") !", "Inconsistêcnia")
		endif
	next

return lRet

Static Function telaVol(oObj,aVol)

	Local aObj := oObj:oData:aArray
	Local nI := oObj:nAt
	Local nX := 0

	Local cItem   := aObj[nI,IT]
	Local cCodPro := aObj[nI,CODPRO]
	Local cDesc := aObj[nI,DESCRI]
	Local cLocal := aObj[nI,LOCAL]
	Local cEndere := aObj[nI,ENDERE]
	Local nQtdRec := aObj[nI,QTDENT]
	Local nQtdInf := aObj[nI,QTDENT]
	Local nQtdVol := aObj[nI,QTDVOL]
	Local aVolumes := {}
	local aVoltmp := {}

	Local oDlg
	Local oBrw
	Local oPn1
	Local oPnl
	Local oGet01
	Local oGet02
	Local oGet03
	Local oGet04
	Local oGet05
	Local oButton1
	Local oButton2

	Local lHasButton := .f.
	Local lNoButton  := .t.
	Local cLabelText := ""    //indica o texto que será apresentado na Label.
	Local nLabelPos  := 1     //Indica a posição da label, sendo 1=Topo e 2=Esquerda
	Local lRet := .f.

	if len(aVol) > 0
		for nX := 1 to len(aVol)
			if cItem == aVol[nX,VIT] .and. cLocal == aVol[nX,VLOCAL] .and. cEndere == aVol[nX,VENDER]
				aadd(aVolumes, { aVol[nX,VID], aVol[nX,VQTDVOL], aVol[nX,VQTDIT], aVol[nX,VOPERA] } ) // id,qtdvol,qtdit,oper
			endif
		next
	endif
	//if len(aVolumes) == 0
	//	aVolumes := pegVol(sf1->f1_doc,sf1->f1_serie,sf1->f1_fornece,sf1->f1_loja,cItem)
	//endif
	if len(aVolumes) == 0
		aVolumes := { { "0001",1,aObj[nI,QTDENT],"" } }
	endif

	DEFINE MSDIALOG oDlg TITLE "inclusão de Volumes" FROM 000, 000  TO 600, 600 COLORS 0, 16777215 PIXEL Style DS_MODALFRAME

	oDlg:lEscClose := .f.

	oPn1 := tPanel():New(000,003,,oDlg,,,,,/*CLR_HCYAN*/,300,045)  //CLR_HGRAY,CLR_HCYAN,CLR_HMAGENTA
	cLabelText := "Item :"
	oGet01 := TGet():New(003,003,{|u|If(PCount()==0,cItem  ,cItem  := u)},oPn1,010,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cItem"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Cód.Produto :"
	oGet02 := TGet():New(003,030,{|u|If(PCount()==0,cCodPro,cCodPro:= u)},oPn1,050,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cCodPro",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Descrição :"
	oGet03 := TGet():New(003,080,{|u|If(PCount()==0,cDesc  ,cDesc  := u)},oPn1,150,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cDesc"  ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	cLabelText := "Local:"
	oGet04 := TGet():New(025,003,{|u|If(PCount()==0,cLocal ,cLocal := u)},oPn1,010,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cLocal" ,,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Endereço:"
	oGet05 := TGet():New(025,030,{|u|If(PCount()==0,cEndere,cEndere:= u)},oPn1,050,10,"@!"              ,,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"cEndere",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Qtd Recebida:"
	oGet04 := TGet():New(025,080,{|u|If(PCount()==0,nQtdRec,nQtdRec:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nQtdRec",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)
	cLabelText := "Qtd informada:"
	oGet05 := TGet():New(025,130,{|u|If(PCount()==0,nQtdInf,nQtdInf:= u)},oPn1,040,10,"@E 99,999,999.99",,,,,.F.,,.T.,,.F.,,.F.,.F.,,.T./*lReadOnly*/,.F.,,"nQtdInf",,,, lHasButton , lNoButton,, cLabelText, nLabelPos)

	@ 012, 235 BUTTON oButton1 PROMPT "Confirmar"          SIZE 060, 012 action ( lRet:=avaVol(nQtdRec,@nQtdVol,oBrw),iif(lRet,oDlg:End(),.f.) ) OF oDlg PIXEL
	@ 028, 235 BUTTON oButton2 PROMPT "Restaura/Del.Linha" SIZE 060, 012 action oBrw:DelLine() OF oDlg PIXEL

	oPnl:=tPanel():New(045,003,,oDlg,,,,,/*CLR_HCYAN*/,300,280)
	oBrw:=fwBrowse():New()
	oBrw:SetOwner( oPnl )
	oBrw:SetDataArray()
	oBrw:SetArray( aVolumes )
	oBrw:DisableConfig()
	oBrw:DisableReport()
	oBrw:SetLocate()                     // Habilita a Localização de registros

	oBrw:addColumn({"Identificção"          , {||aVolumes[oBrw:nAt,01]}, "C", "@!"              , 1, 04 , 0, .f.  ,                             , .f., , "cId"  , , .f., .t., , "cId"  })
	oBrw:addColumn({"Qtd Volumes"           , {||aVolumes[oBrw:nAt,02]}, "C", "@E 9,999,999.99" , 2, 12 , 2, .t., { || verQVol(oBrw,@nQtdInf) } , .f., , "nQVol", , .f., .t., , "nQVol"})
	oBrw:addColumn({"QTd Itens por Volumes" , {||aVolumes[oBrw:nAt,03]}, "N", "@E 9,999,999.99" , 2, 12 , 2, .t., { || verQIt(oBrw,@nQtdInf) }  , .f., , "nQIt" , , .f., .t., , "nQIt" })
	oBrw:addColumn({"Sit.Linha"             , {||aVolumes[oBrw:nAt,04]}, "C", "@!"              , 1, 01 , 0, .f.  ,                             , .f., , "cOpe" , , .f., .t., , "cOpe" })

	oBrw:SetEditCell( .t. )      // Ativa edit and code block for validation
	oBrw:SetInsert(.t.)                       // Indica que o usuário poderá inserir novas linhas no Browse.
	oBrw:SetAddLine( { || addLin(oBrw) } )	  // Indica a Code-Block executado para adicionar linha no browse.
	oBrw:SetLineOk( { || verLin(oBrw) } )     // Indica o Code-Block executado na troca de linha do Browse.

	oBrw:SetDelete(.t., { || delLin(oBrw,@nQtdInf,oGet05) } ) // Indica que o usuário pode excluir linhas no Browse.
	oBrw:SetDelOk( { || verDel(oBrw) } ) 	  // Indica o Code-Block executado para validar a exclusão da linha.

	oBrw:SetBlkBackColor( { || verCor(oBrw)} )

	oBrw:Activate(.t.)

	ACTIVATE MSDIALOG oDlg CENTERED

	if lRet
		aObj[nI,QITVOL] := nQtdVol
		oObj:setArray( aObj )
		oObj:refresh(.t.)

		aVoltmp := aVol
		aVol := {}
		for nI := 1 to len(aVoltmp)
			if cItem != aVoltmp[nI,VIT] .or. cLocal != aVoltmp[nI,VLOCAL] .or. cEndere != aVoltmp[nI,VENDER]
				aadd(aVol, { aVoltmp[nI,VIT], aVoltmp[nI,VLOCAL],aVoltmp[nI,VENDER], aVoltmp[nI,VID], aVoltmp[nI,VQTDVOL], aVoltmp[nI,VQTDIT], aVoltmp[nI,VOPERA] } ) // item,local,endere,id,qtdvol,qtdit,oper
			endif
		next
		for nI := 1 to len(aVolumes)
			aadd(aVol, { cItem, cLocal, cEndere, aVolumes[nI, ID], aVolumes[nI, QTDVOL], aVolumes[nI, QTDIT], aVolumes[nI, OPERA] } ) // item,local,endere,id,qtdvol,qtdit,oper
		next
	endif

return lRet

Static Function verQVol(oObj,nQtdDig)

	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.
	local ni := 0

	if aObj[oObj:nAt, OPERA] == 'X'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
	else
		if &(cVar) <= 0
			MsgAlert("O volume deve ser informado! ", "Inconsistência" )
			lRet := .f.
		endif
		aObj[oObj:nAt, QTDVOL] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
		nQtdDig := 0
		for nI := 1 to len(aObj)
			if aObj[nI, OPERA] != 'X'
				nQtdDig += ( aObj[nI, QTDIT] * aObj[nI, QTDVOL] )
			endif
		next
	endif

return lRet

Static Function verQIt(oObj,nQtdDig)

	Local aObj := oObj:oData:aArray
	Local cVar := readVar()
	Local lRet := .t.
	Local nI := 0

	if aObj[oObj:nAt, OPERA] == 'X'
		MsgAlert("Esta linha esta marcada como deletada! ", "Inconsistência" )
		lRet := .f.
	else
		aObj[oObj:nAt, QTDIT] := &(cVar)
		oObj:setArray( aObj )
		//oObj:refresh(.t.)
		nQtdDig := 0
		for nI := 1 to len(aObj)
			if aObj[nI, OPERA] != 'X'
				nQtdDig += ( aObj[nI, QTDIT] * aObj[nI, QTDVOL] )
			endif
		next
	endif

return lRet


Static Function addLin(oObj)

	Local aObj := oObj:oData:aArray
	//Local nX := len(aObj)

	if oObj:nAt > 1
		cItem := soma1( aObj[len(aObj), ID], 4 )
		Aadd(aObj, {cItem, 0, 0,"" } )
		//++nX
		//Aadd(aObj, {strzero(nX,4), 0, 0,"" } )
	endif

return

Static Function verLin(oObj,nLin)

	Local aObj := oObj:oData:aArray
	Local lRet := .t.

	Default nLin := oObj:nAt

	if aObj[nLin, OPERA] != 'X'
		if aObj[nLin,QTDVOL] == 0 .or. aObj[nLin,QTDIT] == 0
			MsgInfo("Campos devem ser preenchidos", "Inconsistência")
			lRet := .f.
		endif
	endif

return lRet

Static Function verDel(oObj,nQtdInf)

	Local aObj := oObj:oData:aArray
	Local lRet := .t.
	Local cOper:= 'Exclusão'

	if aObj[oObj:nAt,OPERA] == 'X'
		cOper := 'Recuperação'
	endif

	if !MsgYesNo("Confirma "+cOper+" da linha "+aObj[oObj:nAt,ID]+" selecionada ?", cOper+" da linha")
		lRet := .f.
	endif

return lRet

Static Function delLin(oObj,nQtdInf,oGet)

	Local aObj := oObj:oData:aArray
	Local nI := 0

	if aObj[oObj:nAt,OPERA] == 'X'
		aObj[oObj:nAt,OPERA] := ''
	else
		aObj[oObj:nAt,OPERA] := 'X'
	endif
	oObj:setArray( aObj )
	oObj:refresh(.t.)
	for nI := 1 to len(aObj)
		oObj:LineRefresh(nI-1)
	next
	oObj:refresh(.t.)

	nQtdInf := 0
	for nI := 1 to len(aObj)
		if aObj[nI, OPERA] != 'X'
			nQtdInf += ( aObj[nI, QTDIT] * aObj[nI, QTDVOL] )
		endif
	next
	oGet:refresh()

return

Static Function verCor(oObj)

	Local aObj := oObj:oData:aArray
	Local oCor

	if aObj[oObj:nAt,OPERA] == 'X'
		oCor := CLR_HGRAY
	else
		oCor := nil //CLR_WHITE //CLR_HBLUE
	endif

return(oCor)

Static Function avaVol(nQtdRec,nQtdVol,oObj)

	Local lRet := .t.
	Local aObj := oObj:oData:aArray
	Local nI := 0
	Local nQtdInf := 0

	nQtdVol := 0

	for nI := 1 to len(aObj)
		if aObj[nI, OPERA] != 'X'
			nQtdVol += aObj[nI, QTDVOL]
			nQtdInf += ( aObj[nI, QTDIT] * aObj[nI, QTDVOL] )
			lRet := verLin(oObj,nI)
			if !lRet
				exit
			endif
		endif
	next

	if lRet .and. nQtdRec != nQtdInf
		lRet := .f.
		nQtdVol := 0
		MsgInfo("O quantidade total de itens por volumes ("+alltrim(transform(nQtdInf,"@E 99,999,999.99"))+") é diferente ao total do item da NF ("+alltrim(transform(nQtdRec,"@E 99,999,999.99"))+") !", "Inconsistêcnia")
	endif

return lRet
/*
Static Function pegVol(cdoc,cserie,cfornece,cloja,cItem)

	Local cSql := ""
	Local aVol := {}

	cSql := "select * from "+RetSQLName("sz4")+" z4 where z4_filial = '"+xFilial("sz4")+"' "
	cSql += "and z4_doc = '"+cDoc+"' and z4_serie = '"+cSerie+"' and z4_fornece = '"+cFornece+"' "
	cSql += "and z4_loja = '"+cLoja+"' and z4_item = '"+cItem+"' and z4.d_e_l_e_t_ = ' ' "
	cSql += "order by z4_itvol"
	cSql := ChangeQuery( cSql )
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cSql),"trb1",.F.,.T.)
	while !trb1->( Eof() )
		Aadd(aVol, { trb1->z4_itvol, trb1->z4_qtdvol, trb1->z4_qtdIte, "" } )
		trb1->( DbSkip() )
	End
	trb1->( DbCloseArea() )

return aVol
*/
Static Function incVol(cDoc,cSerie,cFornece,cLoja,aVol)

	Local nI := 0

	sz4->(DbSetOrder(1))

	for nI := 1 to len(aVol)
		sz4->(dbseek( xfilial()+cDoc+cSerie+cFornece+cLoja+aVol[nI,VIT]+aVol[nI,VLOCAL]+aVol[nI,VENDER]+aVol[nI,VID] ) )
		if !(sz4->(eof()) .and. aVol[nI,VOPERA] == 'X')
			if sz4->(eof())
				sz4->(RecLock("sz4",.t.))
				sz4->z4_filial := sz4->(xfilial())
				sz4->z4_doc    := cDoc
				sz4->z4_serie  := cSerie
				sz4->z4_fornece:= cFornece
				sz4->z4_loja   := cLoja
				sz4->z4_item   := aVol[nI,VIT]
				sz4->z4_local  := aVol[nI,VLOCAL]
				sz4->z4_localiz:= aVol[nI,VENDER]
				sz4->z4_itvol  := aVol[nI,VID]
			else
				sz4->(RecLock("sz4",.f.))
			endif
			if aVol[nI,VOPERA] == 'X'
				sz4->(DbDelete())
			else
				sz4->z4_qtdvol := aVol[nI,VQTDVOL]      //qtd de volumes
				sz4->z4_qtdIte := aVol[nI,VQTDIT]      //qtd de itens por volumes
			endif
			sz4->(MsUnLock())
		endif
	next

return
