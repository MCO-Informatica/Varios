#INCLUDE "rwmake.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCFAT070   บAutor  ณGiane               บ Data ณ  07/10/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConsulta movimentos estoque                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CFAT070()
	Local aArea:= GetArea()
	Local aButtons := {}			//Botoes da EnchoiceBar
	Local cFiltro  := ""
	Local aConf    := {}

//	oLogTXT := EPLOGTXT():NEW( UPPER(ALLTRIM(FUNNAME())) , "CFAT070" , __cUserID )

	Private cPerg := 'CONSFAT070'

	Private bExcel   := {||}
	Private oDlg						//Dialogo Principal
	Private oGet						//GetDados Principal
	Private oPanel					//Painel para escolha do produto
	Private aHeader  := {}			//Header do sistema
	Private aCols    := {}
	Private oSayPro					//Objeto do Codigo do produto
	Private oSayNom					//Objeto do Nome do produto
	Private cSayPro  := Space(15)     //Texto do Codigo do produto
	Private cSayNom  := SPACE( TamSX3("B1_DESC")[1] )		//Objeto do Nome do produto
	Private oSayGru					//Objeto do Codigo do grupo do produto
	Private oSayDes					//Objeto da descricao do grupo
	Private cSayGru  := Space(06)     //Texto do Codigo do grupo do produto
	Private cSayDes  := SPACE( TamSX3("BM_GRUPO")[1] )		//Objeto da descricao do grupo

	Private cMVpar01, cMVpar02, cMVpar03, cMVpar04
	Private cMVpar05, cMVpar06, cMVpar07, cMVpar08

	Private cCadastro := "Consulta Movimentos Estoque"
	Private cAlias := "XCON"
	Private cTemp := CriaTrab(Nil,.F.)
	Private lGerente := .T.
	Private cArqTrab
	Private cTmpAlias := GetNextAlias()
	Private oTmpTable

	Pergunte(cPerg,.f.)
	cMVPAR01 := MV_PAR01
	cMVPAR02 := MV_PAR02
	cMVPAR03 := MV_PAR03
	cMVPAR04 := MV_PAR04
	cMVPAR05 := MV_PAR05
	cMVPAR06 := MV_PAR06
	cMVPAR07 := MV_PAR07
	cMVPAR08 := MV_PAR08
	cMVPAR09 := MV_PAR09
	cMVPAR10 := MV_PAR10

	dbSelectArea("SF2")
	dbSetOrder(1)
	dbGotop()
	/* retirado apos a migracao, nao ha mais regras de confidencialidade
	//=========== Regra de Confidencialidade =====================================
	aConf := U_Chkcfg(__cUserId)
	cGrpAcesso:= aConf[1]

	lGerente := aConf[2]
	*/
	AAdd(aHeader,{"Data"          , "DATAMOV" ,"" ,08,0,'' ,"๛" ,"D",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Cod.Produto"   , "CODPRO"  ,"" ,TamSX3("B1_COD")[1] ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Descri็ใo"     , "B1_DESC" ,"" ,TamSX3("B1_DESC")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Cliente/Forn"  , "CLIFOR"  ,"" ,TamSX3("A1_COD")[1] ,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Loja"          , "LOJA"    ,"" ,TamSX3("A1_LOJA")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nome" , "NOME"    ,"" ,TamSX3("A1_NOME")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"CnpjCli/For" , "CNPJCF"    ,"" ,TamSX3("A1_CGC")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Pedido"        , "PEDIDO"  ,"" ,TamSX3("C5_NUM")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Movimento"     , "NUMMOV"  ,"" ,TamSX3("D3_NUMSEQ")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Tipo"          , "TPMOV"   ,"" ,10,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Origem/Destino", "DESCMOV" ,"" ,TamSX3("F4_TEXTO")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Quantidade"    , "QUANT"   ,"" ,16,2,'' ,"๛" ,"N",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Unidade"       , "UNID"    ,"" ,02,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Localiza็ใo"   , "LOCALIZ" ,"" ,15,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Lote"          , "LOTE"    ,"" ,10,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Lote Fornecedor", "LOTEFOR","" ,10,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Sub-Lote"      , "SUBLOTE" ,"" ,06,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nota fiscal"   , "NFISCAL" ,"" ,09,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Serie"         , "SERIENF" ,"" ,03,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Nr.Ordem"      , "NUMOP"   ,"" ,13,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Transportadora", "TRANSP"  ,"" ,TamSX3("A4_NOME")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})
	AAdd(aHeader,{"Placa"         , "PLACA"   ,"" ,08,0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	AAdd(aHeader,{"CNPJTran"         , "CNPJTRAN"   ,"" ,TamSX3("A4_CGC")[1],0,'' ,"๛" ,"C",""," " ,NIL,NIL,NIL,"V"})

	aCols := {{"","","","","","","","","","","",0,"","","","","","","","","","","",.F.}}

	//Definicao de Size da Tela
	aSize := MsAdvSize()

	//Botoes que complementarao a EnchoiceBar

	aAdd(aButtons,{'TRILEFT' ,{ || LeftCli(oGet) }  , "Anterior", "Anterior"})
	aAdd(aButtons,{'TRIRIGHT',{ || RightCli(oGet) } , "Pr๓ximo", "Pr๓ximo"})
	AAdd(aButtons,{PmsBExcel()[1], { || GERAEXCEL(oGet) }, "Exp.Tela", "Exp.Tela" } )
	aadd(aButtons,{PmsBExcel()[1],{||Processa( {|lEnd| MontaExcel()}, "Aguarde...","Processando Dados no Excel", .T. ) },"Exp.Todos"})
	aadd(aButtons,{'S4WB005N',{||Processa( {|lEnd| VerNFiscal(oGet)} ) },"Nota Fiscal"})
	aadd(aButtons,{ 'C9',{||Processa( {|lEnd| fInicio(.F.) }, "","", .T. ) },"  Parโmetros"})

	DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 to aSize[6],aSize[5] of oMainWnd PIXEL

	oDlg:lMaximized := .T.

	@ 500,500 MSPANEL oPanel PROMPT "" SIZE 500,500 OF oDlg RAISED

	@013,005 SAY "Produto" PIXEL OF oPanel
	@010,030 MSGET oSayPro VAR cSayPro SIZE 60, 10  PIXEL OF oPanel READONLY
	@010,095 MSGET oSayNom VAR cSayNom SIZE 200, 10 PIXEL OF oPanel READONLY

	@033,005 SAY "Grupo" PIXEL OF oPanel
	@030,030 MSGET oSayGru VAR cSayGru SIZE 60, 10  PIXEL OF oPanel READONLY
	@030,095 MSGET oSayDes VAR cSayDes SIZE 100, 10 PIXEL OF oPanel READONLY

	/*@033,220 SAY "Segmento Responsavel" PIXEL OF oPanel
	@030,275 MSGET oSayGru VAR cSayGru SIZE 60, 10 PIXEL OF oPanel HASBUTTON
	@030,340 MSGET oSayDes VAR cSayDes SIZE 100, 10 PIXEL OF oPanel READONLY
	*/
	oGet := MsNewGetDados():New( 500, 500, 500, 500, 2, ,,,,,Len(aCols),,,,oDlg,@aHeader,@aCols)

	AlignObject( oDlg, {oPanel,oGet:oBrowse}, 1, 2, {100,100} )
	ACTIVATE MSDIALOG oDlg ON INIT (EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()},,aButtons), fInicio(.t.) )  //RunQuery(oGet))

	If Select("cArqTrab") > 0
		(cArqTrab)->( dbCloseArea() )
	EndIf

	If File(cTemp+GetDBExtension())
		FErase(cTemp+GetDBExtension())
	EndIf

	If File(cTemp+OrdBagExt())
		FErase(cTemp+OrdBagExt())
	EndIf

	RestArea(aArea)
Return Nil

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfInicio   บAutor  ณ Giane              บ Data ณ 06/10/2010  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Recalcula total geral de acordo com parametros digitados   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
Static Function fInicio(lTipo)
	Local oPntemp := oPanel
	//If lTipo
	If !Pergunte(cPerg)
		Return
	endif
	//Endif

	cMVPAR01 := MV_PAR01
	cMVPAR02 := MV_PAR02
	cMVPAR03 := MV_PAR03
	cMVPAR04 := MV_PAR04
	cMVPAR05 := MV_PAR05
	cMVPAR06 := MV_PAR06
	cMVPAR07 := MV_PAR07
	cMVPAR08 := MV_PAR08
	cMVPAR09 := MV_PAR09
	cMVPAR10 := MV_PAR10
	/*
	if cMVPAR08 == 1
	if cMVPAR03 <> cMVPAR04
	alert("Produto diferentes. Revise os parametros")
	return()
	endif
	Else
	if cMVPAR05 <> cMVPAR06
	alert("Grupos diferentes. Revise os parametros")
	return()
	endif
	endif
	*/
	oPanel := oPntemp
	aCols := {{"","","","","","","","","","","",0,"","","","","","","","","","","",.F.}}

	If Select(cArqTrab) > 0
		(cArqTrab)->( dbCloseArea() )
	EndIf

	If File(cTemp+GetDBExtension())
		FErase(cTemp+GetDBExtension())
	EndIf

	If File(cTemp+OrdBagExt())
		FErase(cTemp+OrdBagExt())
	EndIf

	MsgRun("Processando parโmetros, aguarde...","",{|| fSqlTRB() })

	DbSetOrder(1)

	If cMVpar08 == 1
		cSayPro := (cArqTrab)->B1_COD
		oSayPro:Refresh()

		cSayNom := (cArqTrab)->B1_DESC
		oSayNom:Refresh()

		cSayGru := SPACE( TamSX3("B1_GRUPO")[1] )
		oSayGru:Refresh()
		cSayDes := SPACE( TamSX3("BM_DESC")[1] )
		oSayDes:Refresh()
	Else
		cSayGru := (cArqTrab)->B1_GRUPO
		oSayGru:Refresh()

		cSayDes := (cArqTrab)->BM_DESC
		oSayDes:Refresh()

		cSayPro := SPACE( TamSX3("B1_COD")[1] )
		oSayPro:Refresh()
		cSayNom := SPACE( TamSX3("B1_DESC")[1] )
		oSayNom:Refresh()
	Endif

	RunQuery(oGet)

	oGet:oBrowse:SetFocus()

	AlignObject( oDlg, {oPanel,oGet:oBrowse}, 1, 2, {100,100} )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVerNFiscalบAutor  ณGiane               บ Data ณ  05/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chama tela de consulta de N.Fiscal Entrada e Saida         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VerNFiscal(oGet)
	Local aAreaAnt := GetArea()
	Local nLinha
	Local cNota
	Local nReg
	Local lGspInUseM := If(Type('lGspInUse')=='L', lGspInUse, .F.)
	Local lPyme      := Iif(Type("__lPyme") <> "U",__lPyme,.F.)

	PRIVATE aRotina	:= {}

	nLinha := oGet:oBrowse:nAt

	nPosTp := aScan( oGet:aHeader,{|x| x[2] == "TPMOV"})
	nPosNF := aScan( oGet:aHeader,{|x| x[2] == "NFISCAL"})
	nPosSer := aScan( oGet:aHeader,{|x| x[2] == "SERIENF"})
	nFornec := aScan( oGet:aHeader,{|x| x[2] == "CLIFOR"})
	cNota := oGet:aCols[nlinha,nPosNF] + oGet:aCols[nlinha,nPosSer]
	cFornece := oGet:aCols[nlinha,nFornec]

	If Left( oGet:aCols[nLinha,nPosTp],1) == 'S'
		DbSelectArea("SF2")
		DbSetOrder(1)
		If DbSeek(xFilial("SF2") + cNota)
			nReg := SF2->(Recno())
			Mc090Visual("SF2",nReg,2)
		Endif

	Else
		nPosPro := aScan( oGet:aHeader,{|x| x[2] == "CODPRO"})
		cProduto := oGet:aCols[nlinha,nPosPro]

		cSegmento := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_SEGMENT")

		//if ('TODOS' $ cGrpAcesso ) .or. (lGerente .and. (cSegmento $ cGrpAcesso) )

		aAdd(aRotina,{"Pesquisar", "AxPesqui"   , 0 , 1, 0, .F.})
		aAdd(aRotina,{"Visualizar", "A103NFiscal", 0 , 2, 0, nil})

		DbSelectArea("SF1")
		DbSetOrder(1)
		If DbSeek(xFilial("SF1") + cNota + cFornece)
			nReg := SF1->(Recno())
			A103NFiscal("SF1",nReg,2,.F.,.F.)
		Endif
		/*
		Else
		MsgStop("USUARIO SEM PERMISSAO - REGRA DE CONFIDENCIALIDADE","Aten็ใo!")

		Endif
		*/
	Endif

	RestArea(aAreaAnt)
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRunQuery  บAutor  ณFernando            บ Data ณ  07/15/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta dados a serem exibidos                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RunQuery(oGet)

	Local cAlias := 'XCON'

	oGet:aCols := {}
	oGet:oBrowse:Refresh()

	MontaQry('U',cAlias)

	Do While !(cAlias)->(Eof())

		AAdd( oGet:aCols,{(cAlias)->DATAMOV,(cAlias)->CODPRO, (cAlias)->B1_DESC,(cAlias)->CLIFOR,(cAlias)->LOJA,;
		(cAlias)->NOME,(cAlias)->CGCCF, (cAlias)->PEDIDO, (cAlias)->NUMMOV,(cAlias)->TPMOV, (cAlias)->DESCMOV,;
		(cAlias)->QUANT, (cAlias)->UNID, (cAlias)->LOCALIZ, (cAlias)->LOTE, (cAlias)->LOTEFOR,;
		(cAlias)->SUBLOTE, (cAlias)->NFISCAL, (cAlias)->SERIENF, (cAlias)->NUMOP,;
		IIF((cAlias)->TPMOV=='Entrada',Posicione("SA4",1,xFilial("SA4")+Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_TRANSP"),"A4_NOME"),;
		IIF((cAlias)->TPMOV=='Saida  ',Posicione("SA4",1,xFilial("SA4")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_TRANSP"),"A4_NOME"),;
		"")),;
		IIF((cAlias)->TPMOV=='Entrada',Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_PLACA"),;
		IIF((cAlias)->TPMOV=='Saida  ',Posicione("DA3",1,xFilial("DA3")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_VEICUL1"),"DA3_PLACA"),;
		"")),;
		IIF((cAlias)->TPMOV=='Entrada',Posicione("SA4",1,xFilial("SA4")+Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_TRANSP"),"A4_CGC"),;
		IIF((cAlias)->TPMOV=='Saida  ',Posicione("SA4",1,xFilial("SA4")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_TRANSP"),"A4_CGC"),;
		"")),;		
		.F. })  
		
		
		
		
		(cAlias)->(dbSkip())
	EndDo

	oGet:oBrowse:Refresh()


Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaQry  บAutor  ณGiane               บ Data ณ  04/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta dados a serem exibidos                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaQry(cTipo,cAlias)
	Local cQuery := ""

	cQuery := "SELECT DISTINCT "
	cQuery += "  SD1.D1_NUMSEQ NUMSEQ ,SD1.D1_DTDIGIT DATAMOV, SD1.D1_COD CODPRO, SB1.B1_DESC, SB1.B1_GRUPO, SD1.D1_FORNECE CLIFOR, SD1.D1_LOJA LOJA, "
	//cQuery += "  DECODE( SA2.A2_NOME, NULL, SA1.A1_NOME, SA2.A2_NOME ) NOME, DECODE( SA2.A2_CGC, NULL, SA1.A1_CGC, SA2.A2_CGC ) CGCCF, 
	cQuery += " CASE WHEN D1_TIPO IN ( 'D','B') THEN  SA1.A1_NOME  ELSE SA2.A2_NOME  END  NOME, " 
	cQuery += " CASE WHEN D1_TIPO IN ( 'D','B') THEN  SA1.A1_CGC  ELSE SA2.A2_CGC  END  CGCCF, "
	cQuery += " SD1.D1_PEDIDO PEDIDO, SD1.D1_QUANT QUANT,  "
	cQuery += "  SD1.D1_UM UNID, SD1.D1_LOTECTL LOTE, SD1.D1_NUMLOTE SUBLOTE, SD1.D1_LOTEFOR LOTEFOR, '' LOCALIZ, SD1.D1_DOC NFISCAL, "
	cQuery += "  SD1.D1_SERIE SERIENF, SD1.D1_OP NUMOP, SD1.D1_NUMSEQ NUMMOV, 'Entrada' TPMOV, SF4.F4_TEXTO DESCMOV"
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD1") + " SD1 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD1.D1_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "     SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
	cQuery += "     SD1.D1_TES = SF4.F4_CODIGO AND "
	cQuery += "     SF4.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON "
	cQuery += "     SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND "
	cQuery += "     SA2.A2_COD = SD1.D1_FORNECE AND SA2.A2_LOJA = SD1.D1_LOJA AND "
	cQuery += "     SA2.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "     SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	cQuery += "     SA1.A1_COD = SD1.D1_FORNECE AND SA1.A1_LOJA = SD1.D1_LOJA AND "
	cQuery += "     SA1.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery += "  SD1.D1_DTDIGIT BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD1.D1_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "  SD1.D1_ORIGLAN <> 'LF' AND SF4.F4_ESTOQUE = 'S' AND "	// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal
	cQuery += "  SD1.D_E_L_E_T_ = ' ' "
	If cTipo <> 'T'
		If cMVPAR08 == 1
			cQuery += " AND SD1.D1_COD = '" + (cArqTrab)->B1_COD + "' "
		Else
			cQuery += " AND SB1.B1_GRUPO = '" + (cArqTrab)->B1_GRUPO + "' "
		Endif
	Endif

	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif

	cQuery += "UNION ALL "

	cQuery += "SELECT DISTINCT "
	cQuery += "  SD2.D2_NUMSEQ NUMSEQ, SD2.D2_EMISSAO DATAMOV, SD2.D2_COD CODPRO, SB1.B1_DESC, SB1.B1_GRUPO, SD2.D2_CLIENTE CLIFOR, SD2.D2_LOJA LOJA,  "
	//cQuery += "  DECODE( SA1.A1_NOME, NULL, SA2.A2_NOME, SA1.A1_NOME ) NOME, DECODE( SA1.A1_CGC, NULL, SA2.A2_CGC, SA1.A1_CGC ) CGCCF,  
	cQuery += " CASE WHEN D2_TIPO IN ( 'D','B') THEN  SA1.A1_NOME  ELSE  SA1.A1_NOME  END  NOME, " 
	cQuery += " CASE WHEN D2_TIPO IN ( 'D','B') THEN  SA2.A2_CGC  ELSE  SA1.A1_CGC END  CGCCF, "
	cQuery += "  SD2.D2_PEDIDO PEDIDO, SD2.D2_QUANT QUANT, "
	cQuery += "  SD2.D2_UM UNID, SD2.D2_LOTECTL LOTE, SD2.D2_NUMLOTE SUBLOTE, '' LOTEFOR, SD2.D2_LOCALIZ LOCALIZ, SD2.D2_DOC NFISCAL, "
	cQuery += "  SD2.D2_SERIE SERIENF, SD2.D2_OP NUMOP, SD2.D2_NUMSEQ NUMMOV, 'Saida' TPMOV, SF4.F4_TEXTO DESCMOV"
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD2") + " SD2 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD2.D2_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "     SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
	cQuery += "     SD2.D2_TES = SF4.F4_CODIGO AND "
	cQuery += "     SF4.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA1") + " SA1 ON "
	cQuery += "     SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND "
	cQuery += "     SA1.A1_COD = SD2.D2_CLIENTE AND SA1.A1_LOJA = SD2.D2_LOJA AND "
	cQuery += "     SA1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SA2") + " SA2 ON "
	cQuery += "     SA2.A2_FILIAL = '"+xFilial("SA2")+"' AND "
	cQuery += "     SA2.A2_COD = SD2.D2_CLIENTE AND SA2.A2_LOJA = SD2.D2_LOJA AND "
	cQuery += "     SA2.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery += "  SD2.D2_EMISSAO BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD2.D2_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD2.D2_CLIENTE BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "
	cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
	cQuery += "  SD2.D2_ORIGLAN <> 'LF' AND SF4.F4_ESTOQUE = 'S' AND "	// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal
	cQuery += "  SD2.D_E_L_E_T_ = ' ' "
	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif
	If cTipo <> 'T'
		If cMVPAR08 == 1
			cQuery += " AND SD2.D2_COD = '" + (cArqTrab)->B1_COD + "' "
		Else
			cQuery += " AND SB1.B1_GRUPO = '" + (cArqTrab)->B1_GRUPO + "' "
		Endif
	Endif

	cQuery += "UNION ALL "

	cQuery += "SELECT DISTINCT "
	cQuery += "  SD3.D3_NUMSEQ NUMSEQ, SD3.D3_EMISSAO DATAMOV, SD3.D3_COD CODPRO, SB1.B1_DESC, SB1.B1_GRUPO, '' CLIFOR, '' LOJA, '' NOME, '' CGCCF, '' PEDIDO, SD3.D3_QUANT QUANT, "
	cQuery += "  SD3.D3_UM UNID, SD3.D3_LOTECTL LOTE, SD3.D3_NUMLOTE SUBLOTE, '' LOTEFOR, SD3.D3_LOCALIZ LOCALIZ, '' NFISCAL,  "
	cQuery += "  '' SERIENF, SD3.D3_OP NUMOP, SD3.D3_DOC NUMMOV, "
	cQuery += "  DECODE( greatest(SD3.D3_TM,'000'), least(SD3.D3_TM,'499'), 'Entrada','Saida') TPMOV, "
	cQuery += "  DECODE(SF5.F5_TEXTO, NULL, "   //caso f5.texto seja nulo, entao verifica o d3_cf para cada codigo no decode abaixo, e monta a descri็็ao:
	cQuery +=                              "DECODE( SUBSTR(SD3.D3_CF,1,2) || SUBSTR(SD3.D3_CF,3,1), "
	cQuery +=                                      " 'RE0', 'Requisi็ใo Manual', 'RE1', 'Requisi็ใo Automatica', "
	cQuery +=                                      " 'RE2', 'Requisi็ใo de Processo','RE3', 'Requisi็ใo Material Indireto',  "
	cQuery +=                                      " 'RE4', 'Transferencia entre Armazens', 'RE5','Req. Automatica NF Entrada direto p/OP', "
	cQuery +=                                      " 'RE6', 'Requisicao manual de materiais (valorizada)', 'RE7', 'Desmontagens', "
	cQuery +=                                      " 'DE0', 'Devolu็ใo Manual', 'DE1', 'Devolu็ใo Automatica', 'DE2','Devolu็ใo Automแtica (processoOP)', "
	cQuery +=                                      " 'DE3', 'Devolu็ใo Manual (armazem processo)', 'DE5', 'Devolu็ใo Automแtica NFE direto p/OP', "
	cQuery +=                                      " 'DE4', 'Transferencia', 'DE6', 'Transferencia Manual', 'DE7', 'Desmontagem de Produtos', "
	cQuery +=                                      " 'ER0', 'Estorno Producao Manual', 'ER1','Estorno Producao Automatica' ) "
	cQuery +=         " ,SF5.F5_TEXTO ) DESCMOV " //caso f5.texto nใo seja nulo, entao o descmov sera o proprio f5_texto.
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD3") + " SD3 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD3.D3_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SF5") + " SF5 ON "
	cQuery += "     SF5.F5_FILIAL = '"+xFilial("SF5")+"' AND "
	cQuery += "     SD3.D3_TM = SF5.F5_CODIGO AND "
	cQuery += "     SF5.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery += "  SD3.D3_LOCAL = '01' AND "
	cQuery += "  SD3.D3_EMISSAO BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD3.D3_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD3.D3_FILIAL = '" + xFilial("SD2") + "' AND "
	cQuery += "  SD3.D_E_L_E_T_ = ' ' "
	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif
	If cTipo <> 'T'
		If cMVPAR08 == 1
			cQuery += " AND SD3.D3_COD = '" + (cArqTrab)->B1_COD + "' "
			cQuery += "ORDER BY DATAMOV, NUMSEQ "
		Else
			cQuery += " AND SB1.B1_GRUPO = '" + (cArqTrab)->B1_GRUPO + "' "
			cQuery += "ORDER BY DATAMOV, NUMSEQ , CODPRO "
		Endif
	Else
		If cMVPAR08 == 1
			cQuery += " ORDER BY CODPRO, DATAMOV, NUMSEQ "
		Else
			cQuery += " ORDER BY B1_GRUPO, DATAMOV, NUMSEQ , CODPRO "
		Endif
	Endif

	If Select(cAlias) > 0
		(cAlias)->(DbCloseArea())
	Endif

	cQuery := ChangeQuery(cQuery)

	//MEMOWRITE('C:\CFAT070.SQL',CQUERY)

	MsgRun("Montando consulta, aguarde...","Movimentos Estoque", {|| dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.f.) })

	TcSetField(cAlias,'DATAMOV','D',8,0)

	dbgotop()

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSqlTrb   บAutor  ณGiane               บ Data ณ  04/11/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Monta arquivo de trabalho com todos os produtos ou todos osบฑฑ
ฑฑบ          ณ grupos de produtos, para navega็ใo na consulta.            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function fSqlTRB()

	Local cQuery := ""

	cQuery := "SELECT "
	If cMVPAR08 == 1 //por produto
		cQuery += "  SB1.B1_COD, SB1.B1_DESC "
	Else
		cQuery += "  SB1.B1_GRUPO, SBM.BM_DESC "
	Endif
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD1") + " SD1 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD1.D1_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "     SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
	cQuery += "     SD1.D1_TES = SF4.F4_CODIGO AND "
	cQuery += "     SF4.D_E_L_E_T_ = ' ' "
	If cMVPAR08 == 2
		cQuery += " JOIN " + RetSqlName("SBM") + " SBM ON "
		cQuery += "   SBM.BM_GRUPO = SB1.B1_GRUPO AND "
		cQuery += "   SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND "
		cQuery += "   SBM.D_E_L_E_T_ = ' ' "
	Endif
	cQuery += "WHERE "
	cQuery += "  SD1.D1_DTDIGIT BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD1.D1_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD1.D1_FILIAL = '" + xFilial("SD1") + "' AND "
	cQuery += "  SD1.D1_ORIGLAN <> 'LF' AND SF4.F4_ESTOQUE = 'S' AND "	// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal
	cQuery += "  SD1.D_E_L_E_T_ = ' ' "

	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif

	cQuery += "UNION "

	cQuery += "SELECT "
	If cMVPAR08 == 1 //por produto
		cQuery += "  SB1.B1_COD, SB1.B1_DESC "
	Else
		cQuery += "  SB1.B1_GRUPO, SBM.BM_DESC "
	Endif
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD2") + " SD2 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD2.D2_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  JOIN " + RetSqlName("SF4") + " SF4 ON "
	cQuery += "     SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND "
	cQuery += "     SD2.D2_TES = SF4.F4_CODIGO AND "
	cQuery += "     SF4.D_E_L_E_T_ = ' ' "
	If cMVPAR08 == 2
		cQuery += " JOIN " + RetSqlName("SBM") + " SBM ON "
		cQuery += "   SBM.BM_GRUPO = SB1.B1_GRUPO AND "
		cQuery += "   SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND "
		cQuery += "   SBM.D_E_L_E_T_ = ' ' "
	Endif
	cQuery += "WHERE "
	cQuery += "  SD2.D2_EMISSAO BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD2.D2_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD2.D2_CLIENTE BETWEEN '" + cMVPAR09 + "' AND '" + cMVPAR10 + "' AND "
	cQuery += "  SD2.D2_FILIAL = '" + xFilial("SD2") + "' AND "
	cQuery += "  SD2.D2_ORIGLAN <> 'LF' AND SF4.F4_ESTOQUE = 'S' AND "	// Despreza Notas Fiscais Lancadas Pelo Modulo do Livro Fiscal
	cQuery += "  SD2.D_E_L_E_T_ = ' ' "
	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif

	cQuery += "UNION "

	cQuery += "SELECT "
	If cMVPAR08 == 1 //por produto
		cQuery += "  SB1.B1_COD, SB1.B1_DESC "
	Else
		cQuery += "  SB1.B1_GRUPO, SBM.BM_DESC "
	Endif
	cQuery += "FROM "
	cQuery +=   RetSqlName("SD3") + " SD3 "
	cQuery += "  JOIN " + RetSqlName("SB1") + " SB1 ON "
	cQuery += "    SD3.D3_COD = SB1.B1_COD AND "
	cQuery += "    SB1.B1_FILIAL = '" + xFilial("SB1") + "' AND "
	cQuery += "    SB1.D_E_L_E_T_ = ' ' "
	cQuery += "  LEFT JOIN " + RetSqlName("SF5") + " SF5 ON "
	cQuery += "     SF5.F5_FILIAL = '"+xFilial("SF5")+"' AND "
	cQuery += "     SD3.D3_TM = SF5.F5_CODIGO AND "
	cQuery += "     SF5.D_E_L_E_T_ = ' ' "
	If cMVPAR08 == 2
		cQuery += " JOIN " + RetSqlName("SBM") + " SBM ON "
		cQuery += "   SBM.BM_GRUPO = SB1.B1_GRUPO AND "
		cQuery += "   SBM.BM_FILIAL = '" + xFilial("SBM") + "' AND "
		cQuery += "   SBM.D_E_L_E_T_ = ' ' "
	Endif
	cQuery += "WHERE "
	cQuery += "  SD3.D3_LOCAL = '01' AND "
	cQuery += "  SD3.D3_EMISSAO BETWEEN '" + DTOS(cMVPAR01) + "' AND '" + DTOS(cMVPAR02) + "' AND "
	cQuery += "  SD3.D3_COD BETWEEN '" + cMVPAR03 + "' AND '" + cMVPAR04 + "' AND "
	cQuery += "  SB1.B1_GRUPO BETWEEN '" + cMVPAR05 + "' AND '" + cMVPAR06 + "' AND "
	cQuery += "  SD3.D3_FILIAL = '" + xFilial("SD2") + "' AND "
	cQuery += "  SD3.D_E_L_E_T_ = ' ' "
	If !empty(cMVPAR07) .and. upper(cMVPAR07) <> 'ZZZZZZ'
		cQuery += " AND SB1.B1_SEGMENT = '" + cMVPAR07 + "' "
	Endif

	If cMVPAR08 == 1
		cQuery += "ORDER BY B1_COD "
		cIndice := 'B1_COD'
	Else
		cQuery += "ORDER BY B1_GRUPO "
		cIndice := "B1_GRUPO"
	endif

	cQuery := ChangeQuery(cQuery)

	//memowrite('c:\CFAT070.sql',cqUEry)

	DbUseArea(.T., "TOPCONN", TcGenQry( , , cQuery ), cTmpAlias, .T., .f.)

	If oTmpTable <> Nil
		oTmpTable:Delete()
		oTmpTable := Nil
	Endif
	
	cArqTrab := GetNextAlias()
	aStru    := (cTmpAlias)->(DBSTRUCT())	
	(cTmpAlias)->(dbCloseArea())
	
	oTmpTable := FWTemporaryTable():New( cArqTrab )  
	oTmpTable:SetFields(aStru) 
	oTmpTable:AddIndex("1", {cIndice})
	
	
	//------------------
	//Criacao da tabela temporaria
	//------------------
	
	oTmpTable:Create()  
	
	Processa({||SqlToTrb(cQuery, aStru, cArqTrab)})


	//COPY TO &(cTemp) VIA __LocalDriver
	//TPRO->( dbCloseArea() )

	//USE &(cTemp) ALIAS "cArqTrab" NEW  VIA  __LocalDriver
	//dbUseArea( .T. , __LocalDriver, cTemp+GetDBExtension() , "cArqTrab" , .f. ,.F. )
	//If File(cTemp+OrdBagExt())
	//		FErase(cTemp+OrdBagExt())
	//Endif

	//DbSelectArea("cArqTrab")
	//IndRegua("cArqTrab",cTemp,cIndice,,,"Aguarde Indexando...")

	//DbGotop()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMontaExcelบAutor  ณGiane               บ Data ณ  20/07/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMonta o arquivo excel com todos os registros referente aos  บฑฑ
ฑฑบ          ณparametros digitados pelo usuแrio.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MontaExcel()

	Local cQry := ""
	Local nHandle   := 0
	Local cArquivo  := CriaTrab(,.F.)
	Local cDirDocs  := MsDocPath()
	Local cPath     := AllTrim(GetTempPath())

	Local aCabec := {}
	Local cBuffer
	Local cDescGru
	Local cCampo
	Local cChave
	Local nCont
	Local nX := 0

	Local cLinha
	Local nQtdReg := 0
	Local nx

	Private cQry := ""
	Private cAlias := "TPLAN"

	cArquivo += ".CSV"

	DbSelectArea("SBM")
	DbSetorder(1)

	nHandle := FCreate(cDirDocs + "\" + cArquivo)

	If nHandle == -1
		MsgStop("Erro na criacao do arquivo na estacao local. Contate o administrador do sistema")
		Return
	EndIf

	MontaQry("T","TPLAN") //monta query com todos os produtos/grupos, para exportar para o excel
	COUNT TO nQtdReg
	ProcRegua(nQtdReg)

	dbGotop()

	If cMVpar08 == 1

		Acabec := {"Cod.Produto","Descri็ใo","Data","Cliente/Fornecedor","Loja","Nome ","CnpjCliFor","Pedido","Movimento","Tipo","Origem/Destino","Quantidade",;
		"Unidade","Localiza็ใo","Lote","Lote Fornecedor","Sub Lote","N.Fiscal","Serie","Nr.Ordem","Transportadora","Placa","CnpjTrans"}
	else

		Acabec := {"Grupo Produto", "Descri็ใo Grupo ","Data","Cod.Produto","Descri็ใo","Cliente/Fornecedor","Loja","Nome ","CnpjCliFor","Pedido","Movimento","Tipo","Origem/Destino","Quantidade",;
		"Unidade","Localiza็ใo","Lote","Lote Fornecedor","Sub Lote","N.Fiscal","Serie","Nr.Ordem","Transportadora","Placa","CnpjTrans"}
	Endif


	FWrite(nHandle, cCadastro) //imprime titulo do relatorio
	FWrite(nHandle, CRLF)
	FWrite(nHandle, CRLF)


	cBuffer := ""
	//imprime o cabecalho
	For nX := 1 To Len(aCabec)
		If nX == Len(aCabec)
			cBuffer += aCabec[nX]
		Else
			cBuffer += aCabec[nX] + ";"
		EndIf
	Next nX

	FWrite(nHandle, cBuffer)
	FWrite(nHandle, CRLF)

	cBuffer := ""
	nCont := 1
	Do While !Eof()

		If cMVPAR08 == 1
			cChave := (cAlias)->CODPRO
			cCampo := '(cAlias)->CODPRO'
		Else
			cChave := (cAlias)->B1_GRUPO
			cCampo := '(cAlias)->B1_GRUPO'
		Endif

		cBuffer := ""
		Do While !eof() .and. &cCampo == cChave
			IncProc()

			If cMVPAR08 == 2
				cBuffer :=  '="' + (cAlias)->B1_GRUPO  + '"' + ';'
				cDescGru := Posicione("SBM",1,xFilial("SBM") + (cAlias)->B1_GRUPO, "BM_DESC")
				cBuffer += cDescGru + ';'
				cBuffer += DTOC((cAlias)->DATAMOV) + ';'
				cBuffer += '="' + (cAlias)->CODPRO + '"' + ';'
			Else
				cBuffer := '="' + (cAlias)->CODPRO + '"' + ';'
			Endif

			cBuffer += (cAlias)->B1_DESC + ';'
			If cMVPAR08 == 1
				cBuffer +=  DTOC((cAlias)->DATAMOV) + ';'
			Endif

			cBuffer +=  '="' +(cAlias)->CLIFOR + '"' + ';'
			cBuffer +=  '="' +(cAlias)->LOJA  + '"' + ';'
			cBuffer += (cAlias)->NOME + ';'
			cBuffer += (cAlias)->CGCCF + ';'
			cBuffer +=  '="' +(cAlias)->PEDIDO + '"' + ';'
			cBuffer +=  '="' +(cAlias)->NUMMOV + '"' + ';'
			cBuffer += (cAlias)->TPMOV + ';'
			cBuffer += (cAlias)->DESCMOV + ';'
			cBuffer += ToXlsFormat( (cAlias)->QUANT ) + ';'
			cBuffer += (cAlias)->UNID + ';'
			cBuffer +=  '="' +(cAlias)->LOCALIZ + '"' + ';'
			cBuffer +=  '="' +(cAlias)->LOTE +  '"' + ';'
			cBuffer +=  '="' +(cAlias)->LOTEFOR + '"' + ';'
			cBuffer +=  '="' +(cAlias)->SUBLOTE + '"' + ';'
			cBuffer +=  '="' +(cAlias)->NFISCAL + '"' + ';'
			cBuffer +=  '="' +(cAlias)->SERIENF + '"' + ';'
			cBuffer +=  '="' +(cAlias)->NUMOP + '"' + ';'
			cBuffer +=  '="' +IIF((cAlias)->TPMOV=='Entrada',Posicione("SA4",1,xFilial("SA4")+Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_TRANSP"),"A4_NOME"),;
			IIF((cAlias)->TPMOV=='Saida  ',Posicione("SA4",1,xFilial("SA4")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_TRANSP"),"A4_NOME"),;
			"")) + '"' + ';'
			cBuffer +=  '="' +IIF((cAlias)->TPMOV=='Entrada',Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_PLACA"),;
			IIF((cAlias)->TPMOV=='Saida  ',Posicione("DA3",1,xFilial("DA3")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_VEICUL1"),"DA3_PLACA"),;
			"")) + '"' + ';'

			cBuffer +=  '="' +IIF((cAlias)->TPMOV=='Entrada',Posicione("SA4",1,xFilial("SA4")+Posicione("SF1",1,xFilial("SF1")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F1_TRANSP"),"A4_CGC"),;
			IIF((cAlias)->TPMOV=='Saida  ',Posicione("SA4",1,xFilial("SA4")+Posicione("SF2",1,xFilial("SF2")+(cAlias)->NFISCAL+(cAlias)->SERIENF,"F2_TRANSP"),"A4_CGC"),;
			"")) + '"'
			
			FWrite(nHandle, cBuffer)
			FWrite(nHandle, CRLF)

			dbSkip()
		Enddo

		FWrite(nHandle, CRLF)

	EndDo


	FClose(nHandle)

	// copia o arquivo do servidor para o remote
	CpyS2T(cDirDocs + "\" + cArquivo, cPath, .T.)

	oExcelApp := MsExcel():New()
	oExcelApp:WorkBooks:Open(cPath + cArquivo)
	oExcelApp:SetVisible(.T.)
	oExcelApp:Destroy()

	If Select(cAlias) > 0
		(cAlias)->( dbCloseArea() )
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeftCli   บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no produto/grupo anterior e monta consulta para   บฑฑ
ฑฑบ          ณeste produto/grupo                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeftCli(oGet)

	(cArqTrab)->( dbSkip(-1) )

	If cMVpar08 == 1
		cSayPro := (cArqTrab)->B1_COD
		oSayPro:Refresh()

		cSayNom := (cArqTrab)->B1_DESC
		oSayNom:Refresh()
	Else
		cSayGru := (cArqTrab)->B1_GRUPO
		oSayGru:Refresh()

		cSayDes := (cArqTrab)->BM_DESC
		oSayDes:Refresh()
	Endif

	RunQuery(oGet)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRightCli  บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no pr๓ximo produto/grupo e monta a consulta para  บฑฑ
ฑฑบ          ณeste produto/grupo                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RightCli(oGet)

	(cArqTrab)->( dbSkip() )

	If cMVpar08 == 1
		cSayPro := (cArqTrab)->B1_COD
		oSayPro:Refresh()

		cSayNom := (cArqTrab)->B1_DESC
		oSayNom:Refresh()
	Else
		cSayGru := (cArqTrab)->B1_GRUPO
		oSayGru:Refresh()

		cSayDes := (cArqTrab)->BM_DESC
		oSayDes:Refresh()
	Endif

	RunQuery(oGet)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldPro    บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no produto que o usuario digitar na caixa de      บฑฑ
ฑฑบ          ณ   texto e monta a consulta para este produto               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldPro(oGet)
	Local lRet := .T.

	If cMVpar08 != 1
		Return .t.
	Endif

	(cArqTrab)->( dbSetOrder(1) )
	(cArqTrab)->( dbSeek( cSayPro ))

	If (cArqTrab)->(Found())
		cSayPro := (cArqTrab)->B1_COD
		oSayPro:Refresh()

		cSayNom := (cArqTrab)->B1_DESC
		oSayNom:Refresh()

		RunQuery(oGet)
		oGet:oBrowse:SetFocus()
	Else
		Help(" ",1,"REGNOIS")
		lRet := .F.
	EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณVldGru    บAutor  ณMicrosiga           บ Data ณ  07/13/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPosiciona no grupo do produto q usuario digitar na caixa de บฑฑ
ฑฑบ          ณ   texto e monta a consulta para este grupo de produto      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function VldGru(oGet)
	Local lRet := .T.

	If cMVpar08 != 2
		Return .t.
	Endif

	(cArqTrab)->( dbSetOrder(1) )
	(cArqTrab)->( dbSeek( cSayGru ))

	If cArqTrab->(Found())
		cSayGru := (cArqTrab)->B1_GRUPO
		oSayGru:Refresh()

		cSayDes := (cArqTrab)->BM_DESC
		oSayDes:Refresh()

		RunQuery(oGet)
		oGet:oBrowse:SetFocus()
	Else
		Help(" ",1,"REGNOIS")
		lRet := .F.
	EndIf

Return lRet

Static Function GERAEXCEL(oGet)
	//Exportacao para o Excel
	If cMVpar08 == 1 //produto
		DlgToExcel( {{"ARRAY","Produto",{"Codigo Produto","Descri็ใo"},{{(cArqTrab)->B1_COD,(cArqTrab)->B1_DESC}}},{"GETDADOS","Movimentos",oGet:aHeader,oGet:aCols} })
	Else
		//por grupo de produto
		DlgToExcel( {{"ARRAY","Grupo Produto",{"Grupo Produto"},{{(cArqTrab)->(B1_GRUPO+' - '+BM_DESC) }}},{"GETDADOS","Movimentos",oGet:aHeader,oGet:aCols} })
	Endif
Return Nil