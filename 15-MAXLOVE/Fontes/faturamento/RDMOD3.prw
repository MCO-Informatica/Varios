#INCLUDE "PROTHEUS.CH"
/*эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁPrograma  ЁMITA001   Ё Autor Ё Ewerton F Brasiliano  Ё Data Ё03/04/2016Ё╠╠
╠╠цддддддддддеддддддддддадддддддеддддддддбддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁLocacao   Ё Fabr.Mcinfotech  ЁContato Ё ewe.brasiliano@gmail.com       Ё╠╠
╠╠цддддддддддеддддддддддддддддддаддддддддадддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁDescricao Ё                                                            Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ*/
User Function RDMOB3(acs,it)




	// Variaveis Locais da Funcao
	Local _aArea    := GetArea()

	//зддддддддддддддддддддддддддддддддддд©
	//Ё Inicio das variveis da Enchoice   Ё
	//юддддддддддддддддддддддддддддддддддды

	Local cAliasE := "SC5"        // Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
	// Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao
	// exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
	Local aCpoEnch  	:= {"C5_CLIENTE","C5_LOJA","C5_CONDPAG"}
	Local aAlterEnch	:= {""}		// Vetor com nome dos campos que poderao ser editados
	Local nOpc    		:= 1			// Numero da linha do aRotina que definira o tipo de edicao (Inclusao, Alteracao, Exclucao, Visualizacao)
	Local nReg    		:= 1			// Numero do Registro a ser Editado/Visualizado (Em caso de Alteracao/Visualizacao)
	// Vetor com coordenadas para criacao da enchoice no formato {<top>, <left>, <bottom>, <right>}
	Local aPos		  	:= {C(004),C(004),C(055),C(309)}
	Local nModelo	  	:= 3       	// Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
	Local lF3 		  	:= .F.		// Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
	Local lMemoria  	:= .T.		// Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
	Local lColumn	  	:= .F.		// Indica se a apresentacao dos campos sera em forma de coluna
	Local caTela 	  	:= "" 		// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
	Local lNoFolder 	:= .F.		// Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
	Local lProperty 	:= .T.		// Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
	Local cTabKit	 := Space(06)
	Local oclient
	Local ocNomcli
	Local ocPedido
	Local oTabKit
	Local Acsx
	Acsx:=acs
	//здддддддддддддддддддддддддддддддддддд©
	//Ё Termino das variveis da Enchoice   Ё
	//юдддддддддддддддддддддддддддддддддддды
	If Acsx="N"
		Return()
	ELSEIf Acsx="n"
		Return()
	EndIF
	// Variaveis Private da Funcao
	Public _oDlK				// Dialog Principal
	// Variaveis que definem a Acao do Formulario
	Private VISUAL := .F.
	Private INCLUI := .F.
	Private ALTERA := .T.
	Private DELETA := .F.

	Private _nEstoque := 0
	Private _cLotectl := ""
	Private _dDtvalid := CTOD("  /  /  ")
	Private _cProgram := M->C5_X_PROGR


	// Privates das NewGetDados
	Private RMAX
	Public aCoBrw5 := {}
	Public aHoBrw5 := {}
	Public noBrw5 := 0
	Public COTAC  := 0
	Public oBrw1
	Public aDados5:= {}

	PUBLIC cItem:=SC6->C6_ITEM

	PUBLIC N1,N2,N3,N4,N5,N6,N7
	PUBLIC Nx1,Nx2,Nx3,Nx4,Nx5,Nx6,Nx7,Nx8,Nx9,Nx10

	cQueryX1 := "SELECT TOP 1 ZKX_PEDIDO  FROM " + RetSqlName("ZKX") +" WHERE D_E_L_E_T_<>'*' GROUP BY ZKX_PEDIDO ORDER BY ZKX_PEDIDO DESC"

	cQueryX1 := ChangeQuery(cQueryX1)

	If Select("QRYX5") > 0
		QRYX5->(dbCloseArea())
	EndIf

	dbUseArea( .T., "TOPCONN", TcGenQry(,,cQueryX1), 'QRYX5', .F., .T.)
	KPED:=ALLTRIM(QRYX5->ZKX_PEDIDO)

	If Empty(KPED)
		KPED := "000000"
	EndIf

	pUBLIC _IT:=cvaltochar(it)
	PUBLIC cPedido:=Soma1(KPED)
	PRIVATE _cCliente:=M->C5_CLIENTE
	PRIVATE _cLoja:=M->C5_LOJACLI
	PRIVATE cNomCli
	PRIVATE cTabela
	PUBLIC KITOK
	public of:=oGetDad:oBrowse:nAt
	public acolsx:={}
	PUBLIC nAct1:=0

	oGetDad:Refresh(.T.)
	acolsx:=oGetDad:oBrowse:nAt

	QRYX5->(dbCloseArea())

	//ALERT("RDMOD3")

	DEFINE MSDIALOG _oDlK TITLE "Pedido Display Max Love" FROM C(226),C(211) TO C(640),C(835) PIXEL style 128


	if !Empty(_cCliente)
		cNomcli:=Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_NOME")
		cTabela:=Posicione("SA1",1,xFilial("SA1")+_cCliente+_cLoja,"A1_TABKIT")
	Endif

	// Chamadas das GetDados do Sistema
	@ C(008),C(032) Say "Pedido" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlK
	@ C(008),C(094) Say "Cliente" Size C(018),C(008) COLOR CLR_BLACK PIXEL OF _oDlK
	@ C(008),C(170) Say "DescriГЦo Cliente" Size C(047),C(008) COLOR CLR_BLACK PIXEL OF _oDlK

	@ C(015),C(013) MsGet ocPedido Var cPedido Size C(060),C(009) COLOR CLR_BLACK PIXEL OF _oDlK
	@ C(015),C(089) MsGet oclient Var _cCliente Size C(027),C(009) COLOR CLR_BLACK PIXEL OF _oDlK
	@ C(015),C(130) MsGet ocNomcli Var cNomcli Size C(120),C(009) COLOR CLR_BLACK PIXEL OF _oDlK

	_oDlK:lEscClose     := .F. //Nao permite sair ao se pressionar a tecla ESC.
	xped()

	ACTIVATE MSDIALOG _oDlK CENTERED

	IF nAct1=1
		ZK6GRV(oBrw1:aCols)
	ENDIF

	oGetDad:oBrowse:nAt //:=n
	oGetDad:oBrowse:Refresh()
	oGetDad:oBrowse:SetFocus()
	Restarea(_aArea)

Return(ALLTRIM(Nx10))

/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠*/
static Function xped

	/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de cVariable dos componentes                                 ╠╠
	ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
	Local oFont		:= TFont():New( "Tahoma",0,-13,,.T.,0,,700,.F.,.F.,,,,,, )
	Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE

	/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ DeclaraГЦo de Variaveis Private dos Objetos                             ╠╠
	ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/
	SetPrvt("_oDlK","oBrw1")

	/*дддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠ Definicao do Dialog e todos os seus componentes.                        ╠╠
	ы╠╠юддддддддддддддаддддддддаддддддадддддддддддддддддддддддддддддддддддддддд*/

	MHoBrw1()
	MCoBrw1()
	oBrw1      := MsNewGetDados():New(038,005,190,400,nOpc,'AllwaysTrue()','AllwaysTrue()','ZK6_ITEM',,0,30,'AllwaysTrue()','','AllwaysTrue()',_oDlK,aHoBrw5,aCoBrw5 )
	nPos  := oBrw1:oBrowse:nAt
	oBrw1:bChange := {||  U_SAT01() }

	oBtn1      := TButton():New( 200,136,"Confirma",_oDlK,{||nAct1:=1,_oDlK:End() },049,012,,oFont,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 200,186,"Cancela ",_oDlK,{|| _oDlK:End() },049,012,,oFont,,.T.,,"",,,,.F. )

Return

/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MHoBrw1() - Monta aHeader da MsNewGetDados para o Alias: ZK2
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MHoBrw1()

	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("ZK6")
	While !Eof() .and. SX3->X3_ARQUIVO == "ZK6"
		If X3Uso(SX3->X3_USADO) .and. cNivel >= SX3->X3_NIVEL
			noBrw5++
			Aadd(aHoBrw5,{Trim(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				"",;
				"",;
				SX3->X3_TIPO,;
				"",;
				"" } )
		EndIf
		DbSkip()
	End

Return


/*ддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбддддддддддддддддддд
Function  Ё MCoBrw1() - Monta aCols da MsNewGetDados para o Alias: ZK2
ддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддаддддддддддддддд*/
Static Function MCoBrw1()

	Local aAux := {}
	Local nY

	COTAC++
	Aadd(aCoBrw5,Array(noBrw5+1))

	For nY := 1 To noBrw5
		aCoBrw5[1][nY] := CriaVar(aHoBrw5[nY][2])
	Next
	aCoBrw5[1][noBrw5+1] := .F.

Return

/////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////
USER FUNCTION SAT01

	local nPos  := oBrw1:oBrowse:nAt
	local n
	n:=nPos
	COTAC:=nPos
	oBrw1:aCols[n][aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_ITEM"})]:=COTAC
	if !Empty(cTabela)
		oBrw1:aCols[n][aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TABELA"})]:=cTabela
	endif
	If nPos > 1
		oBrw1:aCols[n][aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TABELA"})]:=oBrw1:aCols[1,2]
		oBrw1:aCols[n][aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TES"})]:=oBrw1:aCols[1,3]
	Endif
	If nPos <> 0
		n:=nPos
		oBrw1:oBrowse:nAt:=nPos
		oBrw1:oBrowse:Refresh()
		oBrw1:oBrowse:SetFocus()
	EndIf


Return



Static Function ZK6GRV(aItens)

	Local ox,oy,ol
	Local   xCOD
	Local   grdx

	PUBLIC N1,N2,N3,N4,N5,N6,N7,N8,N9,N10
	PUBLIC Nx1,Nx2,Nx3,Nx4,Nx5,Nx6,Nx7,Nx8,Nx9,Nx10

	N1:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_ITEM"})
	N2:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TABELA"})
	N3:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TES"})
	N4:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_PROD"})
	N5:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_DESC"})
	N6:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_QUANT"})
	N7:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_PRVEND"})
	N8:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_TOTPRO"})
	N9:=aScan(aHoBrw5,{|x| Upper(Trim(x[2]))=="ZK6_ALT"})


	For ol:=1 to Len(aItens)


		Nx1:=oBrw1:aCols[ol,N1]
		Nx2:=oBrw1:aCols[ol,N2]
		Nx3:=oBrw1:aCols[ol,N3]
		Nx4:=oBrw1:aCols[ol,N4]
		Nx5:=oBrw1:aCols[ol,N5]
		Nx6:=oBrw1:aCols[ol,N6]
		Nx7:=oBrw1:aCols[ol,N7]
		Nx8:=oBrw1:aCols[ol,N8]
		Nx9:=cPedido
		Nx15:=oBrw1:aCols[ol,N9]


		RecLock("ZK6",.T.)
		fl1:=XFILIAL('ZK6')
		ZK6->ZK6_FILIAL:=fl1
		cCodigo=cvaltochar(Nx1)
		cCodigo=PadL(AllTrim(cCodigo), 2, "0")
		ZK6->ZK6_ITEM   :=cCodigo
		ZK6->ZK6_TABELA :=Nx2
		ZK6->ZK6_TES    :=Nx3
		ZK6->ZK6_PROD   :=Nx4
		ZK6->ZK6_DESC   :=Nx5
		ZK6->ZK6_QUANT  :=Nx6
		ZK6->ZK6_PRVEND :=Nx7
		ZK6->ZK6_TOTPRO :=Nx8
		ZK6->ZK6_NUM    :=Nx9
		MsUnlock("ZK6")

	Next

	U_FUTXPED()

Return


User Function FUTXPED

	local xCOD
	local xtes
	Local xped
	local xprd
	local xprt
	local xprd
	local xpvd
	local xpvt
	local grdx
	Local xcod
	Local xlin
	Local ox
	local xit
	LOCAL XTOT
	local titem
	Local HIT
	Local PRCVENDA
	Local PRC_BASE
	Local PRC_COMP
	Local PRC_DIF
	Local PRC_XBASE
	Local QTDPED
	Local PRC_UNIT
	Local VLR_AMT
	public upvx
	PUBLIC cTabela:=M->ZK6_TABELA
	public cCodX:={}

	oGetDad:Refresh()
	cCodX:=_IT


	//-----MONTA ACOLS DA ROTINA DE KIT PARA TELA DE PEDIDO
	For ox:=1 to Len(oBrw1:aCols)


		xCOD:=ALLTRIM(oBrw1:aCols[ox,N4])
		xqtp:=oBrw1:aCols[ox,N6]
		xpvd:=oBrw1:aCols[ox,N7]
		xtes:=oBrw1:aCols[ox,N3]
		XTOT:=oBrw1:aCols[ox,N8]
		XALT:=oBrw1:aCols[ox,N9]

		//QUERY COM OS DETALHES DO KIT
		cQuery := "SELECT ZK1_FILIAL,ZK1_CODIGO,ZK1_DESC,ZK1_COLUNA,ZK1_LINHA,ZK1_AMOSTR,ZK1_IMG,ZK1_GRADE,ZK1_PROV,ZK1_BASE,ZK1_ADESIV,ZK1_PRVEND FROM"  + RetSqlName("ZK1")
		cQuery += " WHERE ZK1_CODIGO='"+xCOD+"' AND D_E_L_E_T_ = ''"

		cQuery := ChangeQuery(cQuery)

		If Select("QRY") > 0
			QRY->(dbCloseArea())
		EndIf

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), 'QRY', .F., .T.)

		// VARIAVEIS COM DETALHES DO KIT
		xpex:=cPedido
		grdx:=ALLTRIM(QRY->ZK1_GRADE)
		xprd:=ALLTRIM(QRY->ZK1_PROV)
		xpvt:=QRY->ZK1_PRVEND
		xbas:=QRY->ZK1_BASE
		xade:=QRY->ZK1_ADESIV
		xcol:=VAL(QRY->ZK1_COLUNA)
		xlin:=VAL(QRY->ZK1_LINHA)
		xam:=VAL(QRY->ZK1_AMOSTR)
		_cComp=ALLTRIM(xbas)


		COLUNA:=VAL(QRY->ZK1_COLUNA)
		LINHA :=VAL(QRY->ZK1_LINHA)
		AMOSTRA :=VAL(QRY->ZK1_AMOSTR)

		nPercVF	:= SuperGetmv("MV_PERCVF",.F.,2)
		nPrcAde	:= SuperGetmv("MV_PRCADE",.F.,0.11)

		// MEMORIA DE CALCULO PARA O RATEIO DO KIT

		PRCVENDA:=xpvd     // PREгO DE VENDA

		PRC_BASE:=((PRCVENDA*nPercVF/100)-nPrcAde)      // PREгO DE DO VACCUMM 5% DO PREгO DE VENDA

		PRC_COMP :=PRCVENDA-PRC_BASE-nPrcAde   // PREгO LIQUIDO SEM O PREгO DO VACCUM

		PRC_DIF:=PRC_BASE+PRC_COMP-PRCVENDA   // CORRIGINDO AS DIFERENгAS

		PRC_XBASE:=PRC_BASE       // TOTAL DO PRECO VACCUM + DIFRENгAS

		QTDPED:=COLUNA*LINHA+COLUNA*AMOSTRA  //QUANTIDADE DE ITENS DE UM KIT

		PRC_UNIT:=PRC_COMP/ QTDPED         // PREгO UNITARIO POR ITEM


		VLR_AMT:=COLUNA/PRC_BASE          //VLR POR AMOSTRA

		vlu:=PRC_UNIT

		upvx:=PRC_UNIT

		//VERIFICA SE E O PRIMEIRO ITEM E INICIA O ACOLS DA TELA DE PEDIDOS
		if  ox==1
			Nx10:=ALLTRIM(QRY->ZK1_BASE )
		ElseIf ox==2
			Nx10:=ALLTRIM(QRY->ZK1_ADESIV)
		Else
			//n=n+1
			// aadd (aCols,{})
		EndIf

		//**TES UTILIZADO NO VACCUM E ADESIVO**//

		If Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")$"SP"
			If cFilAnt$"0101.0104"
				_cTes := "501"
			Else
				_cTes := "606"
			EndIf
		Else
			If cFilAnt$"0101.0104"
				_cTes := "529"
			Else
				_cTes := "831"
			EndIf
		EndIf

		_nEstoque := 0
		_cLotectl := ""
		_dDtValid := CTOD("  /  /  ")

		VERESTOQUE(Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD"),Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD"),xQTP)

		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD")+Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD"),.F.)

		//**LINHA DO VACCUM DO KIT **
		cCodX=PadL(AllTrim(cCodX), 2, "0")
		aCols[Len(aCols),Len(aHeader)+1]:=.F.
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_UM")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_DESC")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=xqtp
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(PRC_XBASE,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=A410Arred(xqtp*PRC_XBASE,"C6_VALOR")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=_cTes
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,_cTes,1,1,Val(cCodX))
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(PRC_XBASE,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(PRC_XBASE,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_SITTRIB")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

		If !_cProgram$"S"
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,xqtp,0)
		Else
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
		EndIf

		//**LINHA DO ADESIVO DO KIT **
		_cComp=ALLTRIM(xade)
		cCodX=soma1(cCodX)
		cCodX=PadL(AllTrim(cCodX), 2, "0")

		_nEstoque := 0
		_cLotectl := ""
		_dDtValid := CTOD("  /  /  ")

		VERESTOQUE(Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD"),Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD"),xQTP)

		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2")+Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD")+Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD"),.F.)

		aadd (aCols, aclone (aCols [1]))
		aCols[Len(aCols),Len(aHeader)+1]:=.F.
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_COD")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_UM")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_LOCPAD")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_DESC")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=xqtp
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(nPrcAde,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=A410Arred(xqtp*nPrcAde,"C6_VALOR")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=_cTes
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,_cTes,1,1,Val(cCodX))
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(nPrcAde,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(nPrcAde,4)
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+_cComp,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+_cTes,"F4_SITTRIB")
		aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

		If !_cProgram$"S"
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,xqtp,0)
		Else
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
			aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
		EndIf


		//****************************************//
		//*************  ZKX   *******************//
		//** VERIFICA SE O KIT FOI ALTERADO    ** //
		//** MONTA O ACOLS DOS ITENS GRAVADOS  ** //
		//****************************************//
		If !Empty(XALT)

			HIT :=ALLTRIM(cvaltochar(oX))
			cQuery21 := " SELECT B1_COD AS PRODUTO,SUBSTRING(B1_COD, 9, 3)AS COR ,(SELECT DISTINCT ZKX_QUANT FROM "+ RetSqlName("ZKX")+" WHERE SUBSTRING(B1_COD, 9, 3)=ZKX_COR AND ZKX_CODIGO='"+xCOD+"' AND ZKX_GRADE='"+grdx+"' AND ZKX_PEDIDO='"+nX9+"'  AND ZKX_ITEM='"+HIT+"'  AND D_E_L_E_T_<>'*')AS QUANT,* FROM  "  + RetSqlName("SB1")
			cQuery21 += " WHERE SUBSTRING(B1_COD, 9, 3) IN  (SELECT DISTINCT ZKX_COR FROM "+ RetSqlName("ZKX")+" WHERE ZKX_CODIGO='"+xCOD+"' AND ZKX_GRADE='"+grdx+"' AND ZKX_PEDIDO='"+nX9+"' AND ZKX_ITEM='"+HIT+"' AND D_E_L_E_T_<>'*') "
			cQuery21 += "  AND SUBSTRING(B1_COD, 1, 5) LIKE '%"+grdx+"%' "
			cQuery21 += "  AND D_E_L_E_T_<>'*' "

			cQuery21 := ChangeQuery(cQuery21)

			If Select("QRY21") > 0
				QRY21->(dbCloseArea())
			EndIf

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery21), 'QRY21', .F., .T.)

			While QRY21->(!EOF())
				QTX:=0
				QTA:=QRY21->QUANT
				QTX=xqtp*QTA
				//n=n+1

				cCodX=soma1(cCodX)
				cCodX=PadL(AllTrim(cCodX), 2, "0")
				aadd (aCols, aclone (aCols [1]))

				_nEstoque := 0
				_cLotectl := ""
				_dDtValid := CTOD("  /  /  ")

				VERESTOQUE(QRY21->B1_COD,QRY21->B1_LOCPAD,QTX)

				dbSelectArea("SB2")
				dbSetOrder(1)
				dbSeek(xFilial("SB2")+QRY21->B1_COD+QRY21->B1_LOCPAD,.F.)


				aCols[Len(aCols),Len(aHeader)+1]:=.F.
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=QRY21->B1_COD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=QRY21->B1_UM
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=QRY21->B1_LOCPAD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=QRY21->B1_DESC
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=QTX  //xqtp*VAL(QRY->ZK1_LINHA)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=round(QTX*aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})],2)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=xtes
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,xtes,1,1,Val(cCodX))
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+QRY21->B1_COD,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+xtes,"F4_SITTRIB")
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

				If !_cProgram$"S"
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,QTX,0)
				Else
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
				EndIf


				QRY21->(DbSkip())

			End
			//********************************************//
			//*************  ZK2   ***********************//
			//** KIT CADASTRADOS TABELAS ITENS        ** //
			//** MONTA O ACOLS DOS ITENS CADASTRADOS  ** //
			//******************************************//
			//******************************************//


		else
			cQuery2 := " SELECT B1_COD AS PRODUTO,SUBSTRING(B1_COD, 9, 3)AS COR ,* FROM  "  + RetSqlName("SB1")
			cQuery2 += " WHERE SUBSTRING(B1_COD, 9, 3) IN  (SELECT ZK2_COR FROM "+ RetSqlName("ZK2")+" WHERE ZK2_CODIGO='"+xCOD+"' AND ZK2_GRADE='"+grdx+"' AND D_E_L_E_T_<>'*') "
			cQuery2 += "  AND SUBSTRING(B1_COD, 1, 5) LIKE '%"+grdx+"%' "
			cQuery2 += "  AND D_E_L_E_T_<>'*' "

			cQuery2 := ChangeQuery(cQuery2)

			If Select("QRY2") > 0
				QRY2->(dbCloseArea())
			EndIf

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery2), 'QRY2', .F., .T.)

			While QRY2->(!EOF())

				//n=n+1
				QTX:=0
				QTX=xqtp*VAL(QRY->ZK1_LINHA) //*VAL(QRY->ZK1_COLUNA)
				cCodX=soma1(cCodX)
				cCodX=PadL(AllTrim(cCodX), 2, "0")

				_nEstoque := 0
				_cLotectl := ""
				_dDtValid := CTOD("  /  /  ")

				VERESTOQUE(QRY2->B1_COD,QRY2->B1_LOCPAD,QTX)

				dbSelectArea("SB2")
				dbSetOrder(1)
				dbSeek(xFilial("SB2")+QRY2->B1_COD+QRY2->B1_LOCPAD,.F.)

				aadd (aCols, aclone (aCols [1]))
				aCols[Len(aCols),Len(aHeader)+1]:=.F.
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=QRY2->B1_COD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=QRY2->B1_UM
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=QRY2->B1_LOCPAD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=QRY2->B1_DESC
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=QTX  //xqtp*VAL(QRY->ZK1_LINHA)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=round(QTX*aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})],2)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=xtes
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,xtes,1,1,Val(cCodX))
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(UPVX,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+QRY2->B1_COD,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+xtes,"F4_SITTRIB")
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

				If !_cProgram$"S"
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,QTX,0)
				Else
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
				EndIf

				QRY2->(DbSkip())

			End

		Endif


		//**********************************************//
		//*************  ZKX 2  ************************//
		//** VERIFICA SE O KIT FOI ALTERADO         ** //
		//** MONTA O ACOLS DOS PROVADORES GRAVADOS  ** //
		//********************************************//
		//*******************************************//
		If !Empty(XALT)

			HIT :=ALLTRIM(cvaltochar(oX))

			cQuery31 := " SELECT B1_COD AS PRODUTO,SUBSTRING(B1_COD, 9, 3)AS COR, (SELECT DISTINCT ZKX_QUANT FROM "+ RetSqlName("ZKX")+" WHERE SUBSTRING(B1_COD, 9, 3)=ZKX_COR AND ZKX_CODIGO='"+xCOD+"' AND ZKX_PROV='"+xprd+"' AND ZKX_PEDIDO='"+nX9+"' AND ZKX_ITEM='"+HIT+"'  AND D_E_L_E_T_<>'*')AS QUANT ,* FROM  "  + RetSqlName("SB1")
			cQuery31 += " WHERE SUBSTRING(B1_COD, 9, 3) IN  (SELECT DISTINCT ZKX_COR FROM "+ RetSqlName("ZKX")+" WHERE ZKX_CODIGO='"+xCOD+"' AND ZKX_PROV='"+xprd+"' AND ZKX_PEDIDO='"+nX9+"' AND ZKX_ITEM='"+HIT+"'  AND D_E_L_E_T_<>'*') "
			cQuery31 += "  AND SUBSTRING(B1_COD, 1, 5) LIKE '%"+xprd+"%' "
			cQuery31 += "  AND D_E_L_E_T_<>'*' "

			cQuery31 := ChangeQuery(cQuery31)

			If Select("QRY31") > 0
				QRY31->(dbCloseArea())
			EndIf

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery31), 'QRY31', .F., .T.)

			While QRY31->(!EOF())
				QTX1=0
				//n=n+1
				cCodX=soma1(cCodX)
				cCodX=PadL(AllTrim(cCodX), 2, "0")

				QTAP:=QRY31->QUANT
				if VAL(QRY->ZK1_AMOSTR)=0
					QTX1=xqtp*QTAP
				else
					QTX1=xqtp*QTAP
				endif

				_nEstoque := 0
				_cLotectl := ""
				_dDtValid := CTOD("  /  /  ")

				VERESTOQUE(QRY31->B1_COD,QRY31->B1_LOCPAD,QTX1)

				dbSelectArea("SB2")
				dbSetOrder(1)
				dbSeek(xFilial("SB2")+QRY31->B1_COD+QRY31->B1_LOCPAD,.F.)

				aadd (aCols, aclone (aCols [1]))
				aCols[Len(aCols),Len(aHeader)+1]:=.F.
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=QRY31->B1_COD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=QRY31->B1_UM
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=QRY31->B1_LOCPAD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=QRY31->B1_DESC
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=QTX1 //*VAL(QRY->ZK1_COLUNA)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=round(QTX1*aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})],2)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=xtes
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,xtes,1,1,Val(cCodX))
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+QRY31->B1_COD,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+xtes,"F4_SITTRIB")
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

				If !_cProgram$"S"
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,QTX1,0)
				Else
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
				EndIf

				QRY31->(DbSkip())

			End
			//**************************************************//
			//*************  ZK3   ****************************//
			//** KIT CADASTRADOS TABELAS PROVADORES        ** //
			//** MONTA O ACOLS DOS PROVADOES CADASTRADOS  ** //
			//**********************************************//
			//*********************************************//
		else


			cQuery3 := " SELECT B1_COD AS PRODUTO,SUBSTRING(B1_COD, 9, 3)AS COR,* FROM "  + RetSqlName("SB1")
			cQuery3 += " WHERE SUBSTRING(B1_COD, 9, 3) IN  (SELECT ZK3_COR FROM "+ RetSqlName("ZK3")+" WHERE ZK3_CODIGO='"+xCOD+"' AND ZK3_PROV='"+xprd+"' AND D_E_L_E_T_<>'*' ) "
			cQuery3 += "  AND SUBSTRING(B1_COD, 1, 5) LIKE '%"+xprd+"%' "
			cQuery3 += "  AND D_E_L_E_T_<>'*' "

			cQuery3 := ChangeQuery(cQuery3)

			If Select("QRY3") > 0
				QRY3->(dbCloseArea())
			EndIf

			dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery3), 'QRY3', .F., .T.)

			While QRY3->(!EOF())

				//n=n+1
				QTX1:=0
				if QRY->ZK1_AMOSTR='0'
					QTX1=xqtp*VAL(QRY->ZK1_LINHA)
				else
					QTX1=xqtp*VAL(QRY->ZK1_AMOSTR)
				endif

				cCodX=soma1(cCodX)
				cCodX=PadL(AllTrim(cCodX), 2, "0")

				_nEstoque := 0
				_cLotectl := ""
				_dDtValid := CTOD("  /  /  ")

				VERESTOQUE(QRY3->B1_COD,QRY3->B1_LOCPAD,QTX1)


				//dbSelectArea("SB2")
				//dbSetOrder(1)
				//dbSeek(xFilial("SB2")+QRY3->B1_COD+QRY3->B1_LOCPAD,.F.)

				aadd (aCols, aclone (aCols [1]))
				aCols[Len(aCols),Len(aHeader)+1]:=.F.
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_ITEM"})]:=cCodX
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_PRODUTO"})]:=QRY3->B1_COD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_UM"})]:=QRY3->B1_UM
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))=="C6_LOCAL"})]:=QRY3->B1_LOCPAD
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DESCRI"})]:=QRY3->B1_DESC
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDVEN"})]:=QTX1//*VAL(QRY->ZK1_COLUNA)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_VALOR"})]:=round(QTX1*aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCVEN"})],2)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_TES"})]:=xtes
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CF"})]:= fImpostos(cCodX,xtes,1,1,Val(cCodX))
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRCTAB"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PEDKIT"})]:=xpex
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_PRUNIT"})]:=round(upvx,5)
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_X_QTEST"})]:= SaldoSB2()
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_GRADE"})]:="N"
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_CLASFIS"})]:=Posicione("SB1",1,xFilial("SB1")+QRY3->B1_COD,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+xtes,"F4_SITTRIB")
				aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_KIT"})]:="S"

				If !_cProgram$"S"
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=Iif(_nEstoque>0,_cLotectl,"")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=Iif(_nEstoque>0,_dDtValid,CTOD("  /  /  "))
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=Iif(_nEstoque>0,QTX1,0)
				Else
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_LOTECTL"})]:=""
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_DTVALID"})]:=CTOD("  /  /  ")
					aCols[Len(aCols)][aScan(aHeader,{|x| Upper(Trim(x[2]))== "C6_QTDLIB"})]:=0
				EndIf

				QRY3->(DbSkip())
			End
		Endif
		cCodX=soma1(cCodX)
	Next

	oGetDad:Refresh()


return()


Static Function fImpostos(cProduto,cTes,nQtd,nValor,nLinha)

	Local _cCFOP := ""

	MaFisIni(M->C5_CLIENTE,;										// 01- Codigo Cliente/Fornecedor
		M->C5_LOJACLI,;										// 02- Loja do Cliente/Fornecedor
		"C",;											// 03- C: Cliente / F: Fornecedor
		"N",;											// 04- Tipo da NF
		M->C5_TIPOCLI,;										// 05- Tipo do Cliente/Fornecedor
		MaFisRelImp("MTR700",{"SC5","SC6"}),;			// 06- Relacao de Impostos que suportados no arquivo
		,;												// 07- Tipo de complemento
		,;												// 08- Permite incluir imp╣ostos no rodape (.T./.F.)
		"SB1",;										// 09- Alias do cadastro de Produtos - ("SBI" para Front Loja)
		"MTR700")										// 10- Nome da rotina que esta utilizando a funcao


	MaFisAdd(cProduto,cTes,nQtd,1,0,"","",,0,0,0,0,nValor,0)


	_cCFOP := MaFisRet(1,"IT_CF")

	MaFisEnd()

Return(_cCFOP)



Static Function VERESTOQUE(_cProduto,_cLocal,_nQtdLib)

	If Rastro(_cProduto)

		dbSelectArea("SB8")
		dbSetOrder(1)
		If dbSeek(xFilial("SB8")+_cProduto+_cLocal,.f.)

			While Eof() == .f. .And. SB8->(B8_PRODUTO+B8_LOCAL) == _cProduto+_cLocal

				If SB8->B8_SALDO == 0
					dbSelectArea("SB8")
					dbSkip()
					Loop
				EndIf

				If (SB8->B8_SALDO - SB8->B8_EMPENHO) >= _nQtdLib
					_nEstoque := _nQtdLib
					_cLotectl := SB8->B8_LOTECTL
					_dDtValid := SB8->B8_DTVALID
					Exit
				EndIf

				dbSelectArea("SB8")
				dbSkip()
			EndDo
		EndIf
	EndIf

Return()
