#Include "Protheus.ch"
#INCLUDE "TOPCONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "Ap5Mail.ch"
#INCLUDE "TbiConn.ch"

#DEFINE cDEBUG_EMPRESA "01"
#DEFINE cDEBUG_cFILIAL "07"

#DEFINE aPARAM_ACAO {"1 - Inclusão","2 - Exclusão"}
#DEFINE aPARAM_TRAB {"S - Sim","N - Não", "D - D.S.R.", "C - Compensado"}
#DEFINE aPARAM_NONA_HORA {"N - Não", "S - Sim"}
#DEFINE aPARAM_HE_NORMAL {"1 - Normal", ;
"2 - D.S.R.", ;
"3 - Compensado", ;
"4 - Feriado", ;
"5 - Noturna Normal", ;
"6 - Noturna D.S.R.", ;
"7 - Noturna Compensada", ;
"8 - Noturna Feriado"}
#DEFINE aPARAM_HE_NOTURNA    {"1 - Normal", ;
"2 - D.S.R.", ;
"3 - Compensado", ;
"4 - Feriado", ;
"5 - Noturna Normal", ;
"6 - Noturna D.S.R.", ;
"7 - Noturna Compensada", ;
"8 - Noturna Feriado"}
#DEFINE aPARAM_CHNT  {"N - Não", "S - Sim"}
#DEFINE aPARAM_CHNTI {"N - Não", "S - Sim"}
#DEFINE aPARAM_HORA_TAB_PAD {"S - Sim", "N - Não"}

user function CSRH250()
	Private aParSP2  := {}
	Private aLocTrab := {}
	Private aLTFilt := {}
	Private cCadastro := "Exceções por local de trabalho"
	private aParamBox := {}
	private aBrowse    := {}
	private aCodFol    := {}     // Matriz com Codigo da folha
	private anLinha    := {}
	private aStruSRF   := {}
	private CONTFL     := 1
	private cPd13o     := space(3)
	private cPerg      := "GPR130"
	private nLastKey   := 0
	private nLi        := 0
	private oBrwPar    := nil
	private oBroLoc    := nil
	private oBroSP2    := nil
	private oButton1   := nil
	private oButton2   := nil
	private oButton3   := nil
	private oButton4   := nil
	private oButton5   := nil
	private oButton6   := nil
	private oButton7   := nil
	private oButton8   := nil
	private oButton9   := nil
	private oButton10  := nil
	private oDlgP      := nil
	private oLayer 	   := FWLayer():new()
	private oPanel1    := nil
	private oPanel2    := nil
	private oPanel3    := nil
	private oPanel4    := nil
	private oPnl3a    := nil
	private oPnl3b   := nil
	private oPnl3c   := nil
	private oColumn   := nil
	private oPnlDet := nil
	private oBrwLocMk := nil 
	private oMark := nil
	private cAliasFunc := ""
	private oBrwSP2 := nil

	rpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cDEBUG_EMPRESA FILIAL cDEBUG_cFILIAL

	telaGeral()

	RESET ENVIRONMENT
return

Static Function fPBoxSP2()
	local i := 1
	local lOk := .F.

	if len(aParamBox) == 0
		aAdd(aParamBox,{2,"Ação"	  		,aPARAM_ACAO[1],aPARAM_ACAO ,50,"",.T.}) //1 - acao
		aAdd(aParamBox,{1,"Exceção de"  	,dDataBase,"","","","",50,.T.}) //2 - data inicio
		aAdd(aParamBox,{1,"Exceção até"  	,dDataBase,"","","","",50,.T.}) //3 - data fim
		aAdd(aParamBox,{2,"Trabalhado"		,aPARAM_TRAB[1],aPARAM_TRAB,50,"",.F.}) //4 - trabalhado
		aAdd(aParamBox,{1,"Motivo"			,Space(30),"","","","",100,.F.}) //5 - motivo
		aAdd(aParamBox,{2,"Nona hora"		,aPARAM_NONA_HORA[1],aPARAM_NONA_HORA,50,"",.T.}) //6 - nona hora
		aAdd(aParamBox,{2,"H.E. Normal"		,aPARAM_HE_NORMAL[1],aPARAM_HE_NORMAL,50,"",.T.}) //7 - hora extra normal
		aAdd(aParamBox,{2,"H.E. Noturna"	,aPARAM_HE_NOTURNA[1],aPARAM_HE_NOTURNA,50,"",.T.}) //8 - hora estra noturna
		aAdd(aParamBox,{1,"Cod. Refeição"	,Space(2),"","existCpo('SP1') .or. vazio()","SP1","",0,.F.}) //9 - codigo refeicao
		aAdd(aParamBox,{1,"Ini Hora Not" 	,22,"@E 99.99","mv_par02>0","","",20,.T.}) //10 - hora inicial noturna
		aAdd(aParamBox,{1,"Fim Hora Not" 	,05,"@E 99.99","mv_par02>0","","",20,.T.}) //11 - hora final noturna
		aAdd(aParamBox,{1,"Min Hora Not" 	,52.5,"@E 99.99","mv_par02>0","","",20,.T.}) //12 - minutos da hora noturna
		aAdd(aParamBox,{2,"Con H. N. Tab." 	,aPARAM_CHNT[1],aPARAM_CHNT,50,"",.T.}) //13 - Indica se, na Totalização das Horas Trabalhadas em Exceções, irá considerar a Hora Noturna Reduzida (Adicional Noturno)
		aAdd(aParamBox,{2,"Con H. N. Tb. I"	,aPARAM_CHNTI[1],aPARAM_CHNTI,50,"",.T.}) //14 - Indica se, na Totalização das Horas de Intervalo  em Exceções, irá considerar a Hora Noturna Reduzida (Adicional Noturno)
		aAdd(aParamBox,{1,"Regra Apont."	,Space(2),"","existCpo('SPA') .or. vazio()","SPA","",0,.F.}) //15 - regra de apontamento
		aAdd(aParamBox,{2,"Hr. Tab. Pad." 	,aPARAM_HORA_TAB_PAD[1],aPARAM_HORA_TAB_PAD,50,"",.T.}) //16 -
	else
		for i := 1 to len(aParamBox)
			aParamBox[i][3] := aParSP2[i]
		next
	endif
	aParSP2 := {}

	If ParamBox(aParamBox,"Teste Parâmetros...",@aParSP2,/*bOk*/,/*aButtons*/,.T.,/*nPosX*/,/*nPosY*/, /*oDlgParamWizard*/   , .T., .T. )
		lOk := .T.
	Endif

	telaLoc()
Return lOk

static function telaGeral()
	local nHeightBtn   := 15
	local nHeight 	   :=  500
	local nWidth 	   := 1350
	local nTop 		   := -100
	local nLeft 	   := 0

	oDlgP := tDialog():New(nTop, nLeft, 0,0,'Exceções por local de trabalho',,,,,CLR_BLACK,CLR_WHITE,,,.T.,,,, nWidth, nHeight)

	oPanel1:= tPanel():New(0,0,"",oDlgP,,,,,,240,13)
	oPanel1:setCSS("QLabel{background-color:rgb(239,243,247)}")

	oPanel1:Align:= CONTROL_ALIGN_BOTTOM

	oButton2 := tButton():New( 002, 002, "Fechar",oPanel1,{||oDlgP:End()}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton2:SetCSS("QPushButton{}")
	oButton2:Align:= CONTROL_ALIGN_RIGHT

	oButton8 := tButton():New( 002, 002, "Ajuda",oPanel1,{||alert("Ajuda")}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton8:SetCSS("QPushButton{}")
	oButton8:Align:= CONTROL_ALIGN_LEFT

	oLayer:init(oDlgP,.F.)

	oLayer:addCollumn('Col01',15,.F.)
	oLayer:addCollumn('Col02',85,.F.)

	oLayer:addWindow('Col01','C1_Win01','Parâmetros'			,100,.F.,.F.,{|| },,{|| })
	oLayer:addWindow('Col02','C1_Win02','Detalhes'	,100,.F.,.F.,{|| },,{|| })

	oPanel2:= tPanel():New(0,0,"",oLayer:getWinPanel('Col01','C1_Win01'),,,,,,240,13)
	oPanel2:Align:= CONTROL_ALIGN_ALLCLIENT


	oButton1 := tButton():New( 002, 002, "1 - Geral",oPanel2,{|| fPBoxSP2() }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton1:SetCSS("QPushButton{}")
	oButton1:Align:= CONTROL_ALIGN_TOP

	oButton3 := tButton():New( 002, 002, "2 - Locais de trabalho",oPanel2,{||telaLoc()}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton3:SetCSS("QPushButton{}")
	oButton3:Align:= CONTROL_ALIGN_TOP

	oButton2 := tButton():New( 002, 002, "3 - Conferência",oPanel2,{|| telaProc() }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton2:SetCSS("QPushButton{}")
	oButton2:Align:= CONTROL_ALIGN_TOP

	//oButton6 := tButton():New( 002, 002, "Solicitar bloqueio TI",oPanel2,{||alert("Solicitar bloqueio TI")}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	//oButton6:SetCSS("QPushButton{}")
	//oButton6:Align:= CONTROL_ALIGN_TOP

	//oButton7 := tButton():New( 002, 002, "Relatório Checklist",oPanel2,{||alert("Relatório Checklist")}, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	//oButton7:SetCSS("QPushButton{}")
	//oButton7:Align:= CONTROL_ALIGN_TOP
	fPBoxSP2()

	oDlgP:Activate(,,,.T.)	

return 

static function telaLoc()
	FreeObj(oPnlDet)

	oPnlDet := tPanel():New(0,0,"",oLayer:getWinPanel('Col02','C1_Win02'),,,,,,0,100)
	oPnlDet:Align:= CONTROL_ALIGN_ALLCLIENT

	oPanel3 := tPanel():New(0,0,"",oPnlDet,,,,,,0,100)
	oPanel3:Align:= CONTROL_ALIGN_ALLCLIENT

	oPanel5 := tPanel():New(0,0,"",oPnlDet,,,,,,0, 13)
	oPanel5:Align:= CONTROL_ALIGN_BOTTOM

	markLoc()
	botaoLoc()
return

static function botaoLoc()
	local oButton := nil
	local nHeightBtn   := 15
	oButton := tButton():New( 002, 002, "Marcar Todos",oPanel5,{|| markTodos("LBOK") }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT

	oButton := tButton():New( 002, 002, "Desmarcar Todos",oPanel5,{|| markTodos("LBNO") }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT	
return

static function markTodos(cMark)
	local i := 0

	for i := 1 to len(aLocTrab)
		aLocTrab[i][1] := cMark
	next i

	oBrwLocMk:Refresh()
	oBrwLocMk:GoTop(.T.)
return

static function fLocTrab()
	local aAux 		 := {}
	local aLista    := {}
	local cAlias     := GetNextAlias() //Alias resevardo para consulta SQL
	local cQuery  	 := qryLoc() 	//Query SQL
	local lExeChange := .T. //Executa o change Query
	local lTotaliza  := .F.
	local nRec 		 := 0 	//Numero Total de Registros da consulta SQL

	//Executa consulta SQL
	if U_MontarSQ( cAlias, @nRec, cQuery, lExeChange, lTotaliza )
		while (cAlias)->( !EoF() )
			aAux := {}
			aAdd( aAux, "LBNO" ) //01
			aAdd( aAux, (cAlias)->CODIGO 	) //02
			aAdd( aAux, (cAlias)->NOME 	) //02
			aAdd( aAux, (cAlias)->MATRIZ ) //03
			aAdd( aAux, (cAlias)->CNPJ	 ) //04
			aAdd( aAux, (cAlias)->TELEFONE 	) //05
			aAdd( aAux, (cAlias)->CEP 	) //06
			aAdd( aAux, (cAlias)->ENDERECO 	) //07
			aAdd( aAux, (cAlias)->NUMERO 	) //08
			aAdd( aAux, (cAlias)->COMP 	) //09
			aAdd( aAux, (cAlias)->BAIRRO 	) //10
			aAdd( aAux, (cAlias)->CIDADE 	) //12
			aAdd( aAux, (cAlias)->UF 	)			 //13

			aAdd( aLista, aAux)
			(cAlias)->( dbSkip() )
		end
		(cAlias)->( dbCloseArea() )
	endif
	return aLista

	static functio marcarLoc( i )
	if aLocTrab[i][1] == "LBNO"
		aLocTrab[i][1] := "LBOK"
	else
		aLocTrab[i][1] := "LBNO"
	endif
	//oBrwLocMk:Refresh( .T. )
return

static function markLoc()
	FreeObj( oPnl3b )
	oPnl3b := tPanel():New(0,0,"",oPanel3,,,,,, 130, 13)
	oPnl3b:Align := CONTROL_ALIGN_ALLCLIENT

	if len(aLocTrab) == 0
		aLocTrab := fLocTrab()
	endif

	oBrwLocMk := FWBrowse():New(oPanel3)
	oBrwLocMk:SetDataArray()
	oBrwLocMk:SetArray( aLocTrab  ) 
	oBrwLocMk:DisableConfig()
	oBrwLocMk:DisableReport()
	oBrwLocMk:SetDoubleClick({|| marcarLoc( oBrwLocMk:nAt ) }) 

	// Cria uma coluna de marca/desmarca
	oBrwLocMk:AddMarkColumns({|| iif( aLocTrab[oBrwLocMk:nAt][1]=="LBNO", "LBNO", "LBOK" ) },{|oBrwLocMk|marcarLoc( oBrwLocMk:nAt )},{|oBrwLocMk|/* Função de HEADERCLICK*/})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,2] })
	oColumn:SetTitle("Código")
	oColumn:SetSize(3)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,3] })
	oColumn:SetTitle("Descrição")
	oColumn:SetSize(20)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,4] })
	oColumn:SetTitle("Matriz")
	oColumn:SetSize(20)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,5] })
	oColumn:SetTitle("CNPJ")
	oColumn:SetSize(14)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,6] })
	oColumn:SetTitle("Telefone")
	oColumn:SetSize(14)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,7] })
	oColumn:SetTitle("CEP")
	oColumn:SetSize(10)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,8] })
	oColumn:SetTitle("Endereço")
	oColumn:SetSize(20)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,9] })
	oColumn:SetTitle("Número")
	oColumn:SetSize(5)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,10] })
	oColumn:SetTitle("Complemento")
	oColumn:SetSize(20)
	oBrwLocMk:SetColumns({oColumn})	

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,11] })
	oColumn:SetTitle("Bairro")
	oColumn:SetSize(10)
	oBrwLocMk:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,12] })
	oColumn:SetTitle("Cidade")
	oColumn:SetSize(10)
	oBrwLocMk:SetColumns({oColumn})	

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|| aLocTrab[oBrwLocMk:nAt,13] })
	oColumn:SetTitle("UF")
	oColumn:SetSize(2)
	oBrwLocMk:SetColumns({oColumn})	

	oBrwLocMk:Activate()
	return

return lOk

static function telaProc()
	FreeObj(oPnlDet)

	oPnlDet := tPanel():New(0,0,"",oLayer:getWinPanel('Col02','C1_Win02'),,,,,,0,100)
	oPnlDet:Align:= CONTROL_ALIGN_ALLCLIENT

	oPanel3 := tPanel():New(0,0,"",oPnlDet,,,,,,0, 80)
	oPanel3:Align:= CONTROL_ALIGN_TOP

	oPanel4 := tPanel():New(0,0,"",oPnlDet,,,,,,0, 0)
	oPanel4:Align:= CONTROL_ALIGN_ALLCLIENT

	oPanel5 := tPanel():New(0,0,"",oPnlDet,,,,,,0, 13)
	oPanel5:Align:= CONTROL_ALIGN_BOTTOM

	loadPar()
	loadLoc()
	loadSP2()
	botaoProc()
return

static function botaoProc()
	local oButton := nil
	local nHeightBtn   := 15
	oButton := tButton():New( 002, 002, "Processar",oPanel5,{|| Processa( pExcecao(), "Aguarde...", "Processando...",.F.) }, 100,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT

	oButton := tButton():New( 002, 002, "Imprimir conferência",oPanel5,{|| oBrwSP2:report() }, 100,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT



	/*
	oButton := tButton():New( 002, 002, "Marca todos",oPanel5,{|| telaProc() }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT

	oButton := tButton():New( 002, 002, "Desmarcar todos",oPanel5,{|| telaProc() }, 050,nHeightBtn,,,.F.,.T.,.F.,,.F.,,,.F. )
	oButton:SetCSS("QPushButton{}")
	oButton:Align:= CONTROL_ALIGN_LEFT
	*/	
return

static function qrySP2()
	local cQuery := ""
	local cLista := ""
	local i := 0

	for i := 1 to len(aLTFilt)
		if !empty(cLista)
			cLista += "','"
		endif
		cLista += aLTFilt[i][1]
	next i

	cQuery := " SELECT RA_FILIAL, RA_MAT, RA_NOME, RA_CODLT,  SUBSTRING(RCC_CONTEU, 001, 30) LOCALTRAB, RA_CC, CTT_DESC01, RA_TNOTRAB "
	cQuery += " FROM "+RetSqlName('SRA')+" SRA "
	cQuery += " INNER JOIN "+RetSqlName('CTT')+" CTT ON "
	cQuery += " 	CTT.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND CTT.CTT_CUSTO = SRA.RA_CC "
	cQuery += " INNER JOIN "+RetSqlName('RCC')+" RCC ON "
	cQuery += " 	RCC.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND RCC.RCC_CODIGO = 'U006' "
	cQuery += " 	AND RCC.RCC_SEQUEN = SRA.RA_CODLT "	
	cQuery += " WHERE  "
	cQuery += " 	SRA.D_E_L_E_T_ = ' ' "
	cQuery += " 	AND SRA.RA_CODLT IN ('"+cLista+"') "
	cQuery += " 	AND SRA.RA_DEMISSA = ' ' "
	cQuery += " ORDER BY RA_NOME, LOCALTRAB, CTT_DESC01 "

return cQuery 

static function qryLoc()
	local cQuery := ""

	cQuery  	 := " SELECT "
	cQuery  	 += " RCC_SEQUEN CODIGO, " //01
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 001, 30) NOME, " //02
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 001, 30) MATRIZ, " //03
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 206, 18) CNPJ, " //04
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 158, 13) TELEFONE, " //05
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 139, 09) CEP, " //06
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 031, 30) ENDERECO, " //07
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 061, 06) NUMERO, " //08
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 067, 30) COMP, " //09
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 097, 20) BAIRRO, " //10
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 117, 20) CIDADE, " //12
	cQuery  	 += " SUBSTRING(RCC_CONTEU, 137, 02) UF" //13
	cQuery  	 += " FROM
	cQuery  	 += " 	"+RetSqlName('RCC')+" RCC "
	cQuery  	 += " WHERE
	cQuery  	 += " 	RCC_CODIGO = 'U006'
	cQuery  	 += " 	AND D_E_L_E_T_ = ' '
return cQuery


static function loadPar()
	local aLista := {}
	local i := 0

	for i := 1 to len(aParamBox)
		aAdd(aLista, {aParamBox[i][2], aParSP2[i] } )
	next i

	FreeObj( oPnl3a )
	oPnl3a := tPanel():New(0,0,"",oPanel3,,,,,, 130, 13)
	oPnl3a:Align := CONTROL_ALIGN_LEFT

	oBrwPar := FWBrowse():New(oPnl3a)
	oBrwPar:SetDataArray()
	oBrwPar:SetArray( aLista  ) 
	oBrwPar:DisableConfig()
	oBrwPar:DisableReport()

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||aLista[oBrwPar:nAt,1]})
	oColumn:SetTitle("Parâmetro")
	oColumn:SetSize(10)
	oBrwPar:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||aLista[oBrwPar:nAt,2]})
	oColumn:SetTitle("Conteúdo")
	oColumn:SetSize(10)
	oBrwPar:SetColumns({oColumn})	

	oBrwPar:Activate()
return

static function loadLoc()
	local aLista := {}
	local i := 0
	local j := 0

	aLTFilt:={}

	for i := 1 to len(aLocTrab)
		if aLocTrab[i][1] = "LBOK"
			aLista := {}
			for j := 2 to len(aLocTrab[i])
				aAdd(aLista, aLocTrab[i][j] )
			next j
			aAdd( aLTFilt, aLista)
		endif
	next i


	FreeObj( oPnl3b )
	oPnl3b := tPanel():New(0,0,"",oPanel3,,,,,, 130, 13)
	oPnl3b:Align := CONTROL_ALIGN_ALLCLIENT

	oBrwLoc := FWBrowse():New(oPnl3b)
	oBrwLoc:SetDataArray()
	oBrwLoc:SetArray( aLTFilt  ) 
	oBrwLoc:DisableConfig()
	oBrwLoc:DisableReport()

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,1]})
	oColumn:SetTitle("Código")
	oColumn:SetSize(3)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,2]})
	oColumn:SetTitle("Descrição")
	oColumn:SetSize(20)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,3]})
	oColumn:SetTitle("Matriz")
	oColumn:SetSize(20)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,4]})
	oColumn:SetTitle("CNPJ")
	oColumn:SetSize(14)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,5]})
	oColumn:SetTitle("Telefone")
	oColumn:SetSize(14)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,6]})
	oColumn:SetTitle("CEP")
	oColumn:SetSize(10)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,7]})
	oColumn:SetTitle("Endereço")
	oColumn:SetSize(20)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,8]})
	oColumn:SetTitle("Número")
	oColumn:SetSize(5)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,9]})
	oColumn:SetTitle("Complemento")
	oColumn:SetSize(20)
	oBrwLoc:SetColumns({oColumn})	

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,10]})
	oColumn:SetTitle("Bairro")
	oColumn:SetSize(10)
	oBrwLoc:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,11]})
	oColumn:SetTitle("Cidade")
	oColumn:SetSize(10)
	oBrwLoc:SetColumns({oColumn})	

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({|oBrwLoc|aLTFilt[oBrwLoc:nAt,12]})
	oColumn:SetTitle("UF")
	oColumn:SetSize(2)
	oBrwLoc:SetColumns({oColumn})	

	oBrwLoc:Activate()
return

static function loadSP2()
	cAliasFunc := getNextAlias()

	oBrwSP2 := FWBrowse():New(oPanel4)
	oBrwSP2:SetDataQuery()
	oBrwSP2:SetQuery ( qrySP2()  ) 
	oBrwSP2:SetAlias ( cAliasFunc )
	oBrwSP2:DisableConfig()
	oBrwSP2:DisableReport()

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||RA_FILIAL})
	oColumn:SetTitle("Filial")
	oColumn:SetSize(2)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||RA_MAT})
	oColumn:SetTitle("Matrícula")
	oColumn:SetSize(8)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||RA_NOME})
	oColumn:SetTitle("Nome")
	oColumn:SetSize(30)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||RA_CODLT})
	oColumn:SetTitle("Cod. Loc. Trab.")
	oColumn:SetSize(2)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||LOCALTRAB})
	oColumn:SetTitle("Local Trabalho")
	oColumn:SetSize(15)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||RA_CC})
	oColumn:SetTitle("Cod. Cc.")

	oColumn:SetSize(9)
	oBrwSP2:SetColumns({oColumn})

	// Adiciona as colunas do Browse
	oColumn := FWBrwColumn():New()
	oColumn:SetData({||CTT_DESC01})
	oColumn:SetTitle("Centro de Custo")
	oColumn:SetSize(20)
	oBrwSP2:SetColumns({oColumn})	

	oBrwSP2:Activate()
return

static function pExcecao()
	local cChaveSP2 := ""
	local nQtd := oBrwSP2:LogicLen()
	local nProc := 0

	if nQtd == 0
		msgAlert("Parâmetros inválidos", "Não processou")
	endif

	(cAliasFunc)->(dbGoTop())
	oBrwSP2:Refresh()

	ProcRegua( nQtd )
	SP2->(dbSetOrder(3)) //P2_FILIAL+P2_MAT+P2_CC+P2_TURNO+DTOS(P2_DATA)+P2_TIPODIA
	while (cAliasFunc)->( !EoF() )
		incProc()
		cChaveSP2 := (cAliasFunc)->(RA_FILIAL+RA_MAT+RA_CC+RA_TNOTRAB) +  DTOS( aParSP2[2] ) + SPACE(1)
		if left(aParSP2[1],1) == "1" //INCLUIR
			if SP2->(dbSeek(cChaveSP2))
				recLock("SP2",.F.)
			else
				recLock("SP2",.T.)
			endif	
			SP2->P2_FILIAL := (cAliasFunc)->RA_FILIAL
			SP2->P2_MAT := (cAliasFunc)->RA_MAT
			SP2->P2_DATA := aParSP2[2]
			SP2->P2_DATAATE := aParSP2[3]
			//SP2->P2_TURNO := (cAliasFunc)->RA_TNOTRAB
			SP2->P2_CC := (cAliasFunc)->RA_CC
			SP2->P2_TRABA :=  aParSP2[4]
			SP2->P2_MOTIVO := alltrim(aParSP2[5])
			SP2->P2_NONAHOR :=  aParSP2[6]
			SP2->P2_CODHEXT := aParSP2[7]
			SP2->P2_CODHNOT := aParSP2[8]
			SP2->P2_CODREF := aParSP2[9]
			SP2->P2_INIHNOT := aParSP2[10]
			SP2->P2_FIMHNOT := aParSP2[11]
			SP2->P2_MINHNOT := aParSP2[12]
			SP2->P2_HNOTTAB := aParSP2[13]
			SP2->P2_HNOTTBI := aParSP2[14]
			SP2->P2_REGRA :=  aParSP2[15]
			SP2->P2_HERDHOR := aParSP2[16]

			SP2->(msUnlock())
			nProc ++
		else
			if SP2->(dbSeek(cChaveSP2))
				recLock("SP2",.F.)
				SP2->(dbDelete())
				SP2->(msUnlock())
				nProc ++
			endif
		endif
		(cAliasFunc)->( dbSkip() )
	end
	(cAliasFunc)->(dbGoTop())
	oBrwSP2:Refresh()
	
	if nProc > 0
		msgInfo("Foram processados "+cValToChar(nProc)+" funcionários.")
	else
		msgAlert("Nenhum registro encontrado para processamento.")
	endif

return