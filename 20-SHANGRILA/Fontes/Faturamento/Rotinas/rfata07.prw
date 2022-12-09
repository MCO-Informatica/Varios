#Include "Protheus.Ch"
#INCLUDE "TOPCONN.CH"
/*
----------------------------------------------------------------
Funcao  : RFATA07							  Data  : 09/05/2020
Autor   : Ricardo Souza	                        UPduo Tecnologia
----------------------------------------------------------------
Objetivo: Selecao dos Pedidos 
----------------------------------------------------------------		  
*/                                             
User Function RFATA07()
	Local nOpca
	Local nSeqReg
	Local aSays := {}, aButtons := {}
	Private cTitulo := "PEDIDOS - Alteração Volumes"//"Alteracao dos Volumes e Transportadora na NF Gerada"
	Private cCadastro := OemToAnsi(cTitulo)
	Private cPerg  := Padr("RFAT07",Len(SX1->X1_GRUPO))
	Private cDesc1 := "Selecao dos Pedidos para alteração de dados"
	Private cDesc2 := "Volumes, Transportadora, Peso Liquido e Bruto, Mensagens"
	Private cDesc3 := ""
	Private cDesc4 := ""

	AADD(aSays,OemToAnsi(cDesc1))
	AADD(aSays,OemToAnsi(cDesc2))
	AADD(aSays,OemToAnsi(cDesc3))
	AADD(aSays,OemToAnsi(cDesc4))

	nOpca    := 0
//cCadastro:=OemToAnsi(cTitulo)
	RFATA07Perg(cPerg)

	AAdd(aButtons, { 5,.T.,{|| Pergunte(cPerg,.T.)}})
	AAdd(aButtons,{1,.T.,{|| nOpca := 1,FechaBatch()}})
	AAdd(aButtons,{2,.T.,{|| nOpca := 0,FechaBatch()}})

	FormBatch( cCadastro, aSays, aButtons )

	If nOpca == 1
		Processa({|lEnd| U_RFATA07Proc()}, "Selecionando Documentos")
	Endif

Return
/*
--------------------------------------------------------------------------
Programa : RFATA07Proc		Autor   : Gildesio Campos		Data: 24.04.07
Descricao: Gravacao do volume, peso liquido, peso bruto, transportadora
--------------------------------------------------------------------------
*/
User Function RFATA07Proc()
	Local   aIndices := {} , _cFiltro

	Private aCores := {}
	Private aRotina := {{ "Pesquisar"  ,"AxPesqui"    ,0,1},;	//"Pesquisar"
	{ "Visualizar" ,"U_RFATA07Vis",0,2},;	//"Visual"
	{ "Alterar"    ,"U_RFATA07Alt",0,4},;   //"Alterar"
	{ "Legenda"    ,"U_RFATA07Leg",0,2}}    //"Legenda"

	Private _aCpoSF2 := {"C5_NUM",,"C5_EMISSAO","C5_CLIENTE","C5_LOJA","C5_VOLUME1","C5_TRANSP",;
		"C5_PESOL","C5_PBRUTO","C5_ESPEC1","C5_X_BOX","C5_REDESP"}

	_cFiltro := "C5_NUM >= Mv_Par01 .And. C5_NUM <= Mv_Par02 .And. dtos(C5_XDATALI) >= dtos(Mv_Par03) .And. dtos(C5_XDATALI) <= dtos(Mv_Par04) " //.And. dtos(F2_EMISSAO) <= dtos(Mv_Par04)"
	bFilBrw	:=	{|| FilBrowse('SC5',@aIndices,_cFiltro)}
	Eval( bFilBrw )

	mBrowse( 6,1,22,75,"SC5",,,,,,aCores)
	EndFilBrw("SC5",aIndices)

Return(.T.)
/*
-----------------------------------------------------------------------------
Funcao   : RFATA07Alt        
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Viabilizar a alteracao de campos determinados na NF gerada 
-----------------------------------------------------------------------------
*/
User Function RFATA07Alt(cAlias,nReg,nOpc)
	Local 	aCpoAlt := {"C5_VOLUME1", "C5_TRANSP","C5_PESOL","C5_PBRUTO","C5_X_BOX","C5_REDESP","C5_XVALFRR"}
	Private aTELA[0][0],aGETS[0]

	INCLUI := .F.
	ALTERA := .T.
	nOpcA  := 0

	nOpcA  :=AxAltera( cAlias, nReg, nOpc,_aCpoSF2,aCpoAlt,,)         //1-Ok 3-Cancela

	If nOpcA = 3  // Se cancelou
		Return
	EndIf

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFATA07Vis       
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Viabilizar a alteracao de campos determinados na NF gerada 
-----------------------------------------------------------------------------
*/
User Function RFATA07Vis(cAlias,nReg,nOpc)
	Local 	aCpoAlt := {"C5_VOLUME1", "C5_TRANSP","C5_PESOL","C5_PBRUTO","C5_X_BOX","C5_REDESP","C5_XVALFRR"}
	Private aTELA[0][0],aGETS[0]

	INCLUI := .F.
	ALTERA := .T.
	nOpcA  := 0

	nOpcA  :=AxVisual( cAlias, nReg, nOpc,_aCpoSF2/*,,,*/)         //1-Ok 3-Cancela

	If nOpcA = 3  // Se cancelou
		Return
	EndIf

Return
/*
-----------------------------------------------------------------------------
Funcao   : RFATA07Leg        
Autor    : Gildesio Campos                                    |Data: 24.04.07
-----------------------------------------------------------------------------
Descricao: Legenda
-----------------------------------------------------------------------------
*/
User Function RFATA07Leg()
	Private aCorDesc
	aCorDesc := {{"ENABLE" ,"Pedido Gerado"},;
		{"DISABLE","Pedido Impresso"}}

	BrwLegenda( "Pedidos","Legenda ", aCorDesc )

Return( .T. )

/*
-----------------------------------------------------------------------------
Funcao   : RFATA07Perg        
Autor    : Gildesio Campos                                    |Data: 18.03.07
-----------------------------------------------------------------------------
Descricao: Verifica as perguntas incluindo-as caso nao existam
-----------------------------------------------------------------------------
*/
Static Function RFATA07Perg(xPerg)
	_sAlias := Alias()
	dbSelectArea("SX1")
	dbSetOrder(1)
	cPerg := PADR(cPerg,10)
	aRegs:={}

	AADD(aRegs,{cPerg,"01","Pedido de    ?","","","mv_ch1" ,"C", 6,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","","SF2"})
	AADD(aRegs,{cPerg,"02","Pedido Ate   ?","","","mv_ch2" ,"C", 6,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","","SF2"})
	AADD(aRegs,{cPerg,"03","Data Liberacao ?","","","mv_ch3" ,"D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next
	dbSelectArea(_sAlias)
Return




User Function RFT07VLD()
	Local lRet := .T.

	If FunName() == "RFATA07" .OR. FunName() == "SHFATP01" .OR. FunName() == "RFATA02"

		If M->C5_VOLUME1 <= 0 .AND. SC5->C5_VOLUME1 > 0
			lRet := .F.
			M->C5_VOLUME1 := SC5->C5_VOLUME1
		ElseIf Empty(M->C5_TRANSP) .AND. !Empty(SC5->C5_TRANSP)
			lRet := .F.
			M->C5_TRANSP  := SC5->C5_TRANSP
		ElseIf M->C5_PESOL <= 0 .AND. SC5->C5_PESOL > 0
			lRet := .F.
			M->C5_PESOL   := SC5->C5_PESOL
		ElseIf M->C5_PBRUTO <= 0 .AND. SC5->C5_PBRUTO > 0
			lRet := .F.
			M->C5_PBRUTO  := SC5->C5_PBRUTO
		ElseIf Empty(M->C5_X_BOX) .AND. !Empty(SC5->C5_X_BOX)
			lRet := .F.
			M->C5_X_BOX   := SC5->C5_X_BOX
		ElseIf Empty(M->C5_REDESP) .AND. !Empty(SC5->C5_REDESP)
			lRet := .F.
			M->C5_REDESP  := SC5->C5_REDESP
		ElseIf M->C5_XVALFRR <= 0 .AND. SC5->C5_XVALFRR > 0
			lRet := .F.
			M->C5_XVALFRR := SC5->C5_XVALFRR
		Else
			lRet := .T.
		EndIf

		If !lRet
			MsgAlert("Não é permitido zerar os valores ou limpar os campos!","Atenção")
		EndIf

	Else
		Return .T.
	EndIf


Return lRet
