#INCLUDE "PROTHEUS.CH"
#include "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณACOM016   บAutor  ณAlexandre Sousa     บ Data ณ  11/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBrowser de aprovacao de pedidos de compra de faturamento    บฑฑ
ฑฑบ          ณdireto                                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณEspecifico LISONDA.                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOM016(nFuncao, lWhenGet)

	DEFAULT nFuncao    := 1
	DEFAULT lWhenGet   := .F.
	
	PRIVATE aBackSC7   := {}
	PRIVATE aAutoCab   := xAutoCab := nil
	PRIVATE aAutoItens := xAutoItens := nil
	PRIVATE bFiltraBrw := {|| Nil }
	PRIVATE nTipoPed   := nFuncao // 1 - Ped. Compra 2 - Aut. Entrega
	PRIVATE l120Auto   := ValType(xAutoCab)=="A" .And. ValType(xAutoItens) == "A"
	PRIVATE lPedido    := .T.
	PRIVATE lGatilha   := .T.                          // Para preencher aCols em funcoes chamadas da validacao (X3_VALID)
	PRIVATE lVldHead   := GetNewPar( "MV_VLDHEAD",.T. )// O parametro MV_VLDHEAD e' usado para validar ou nao o aCols (uma linha ou todo), a partir das validacoes do aHeader -> VldHead()

	Private aRotina			:= {}
	Private cCadastro		:= "Aprova็ใo de Pedidos de Compra"
	Private a_RotImp		:= {}
	Private a_RotLib		:= {}
	Private a_Rotmail		:= {}
	Private a_RotCon		:= {}
	Private a_RotVr		:= {}
	Private l_INCLUI		:= .F.
	Private l_ALTERA		:= .F.
	Private l_EXCLUI		:= .F.
	Private l_TERMO		:= .F.
	Private l_CANCEL		:= .F.
	Private c_EOL			:= chr(13)+chr(10)
	Private c_Recurso		:= ''
	Private cIndex	
	Private c_supos			:= '' //GetMv("MV_XSUPOS")

	AAdd(aRotina, {"Pesquisar"	, "AxPesqui"  	, 0, 1})
	AAdd(aRotina, {"Visualizar"	, "U_ACOM016a"	, 0, 2})
	AAdd(aRotina, {"Aprovar"	, "U_ACOM016c"	, 0, 3})
	AAdd(aRotina, {"Estornar Aprov.", "U_ACOM016d"	, 0, 4})
	AAdd(aRotina, {"Legenda"	, "U_ACOM016b"	, 0, 7})
	
	aCores     :={		{"C7_XSTATFI =  'L'" , "BR_VERMELHO"	},;
						{"C7_XSTATFI =  'P'" , "BR_VERDE"		}}

	dbSelectArea("SC7")
	DbSetOrder (1)

	cArqSZ2 := CriaTrab(,.F.)
	cKeySZ2 := IndexKey() //"F2_FILIAL+Z2_RECURSO"
	cQuery  := "AllTrim(C7_XSTATFI) $ 'P/L'"
	
	IndRegua("SC7",cArqSZ2,cKeySZ2,,cQuery, "Selecionando Registros...")
	nOrdSZ2 := RetIndex("SC7")
	#IFNDEF TOP
		dbSetIndex(cArqSZ2+OrdBagExt())
	#ENDIF
	dbSetOrder(nOrdSZ2+1)
	cAlias := "SC7"

	mBrowse( 6, 1,22,75,"SC7",,"C7_XSTATFI"	,,,2, aCores)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAGCS701a  บAutor  ณAlexandre Sousa     บ Data ณ  26/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณChamada das funcoes responsaveis.                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ACOM016b(cAlias, nRecno, nOpc)
		Legenda()	
Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLegenda   บAutor  ณAlexandre Sousa     บ Data ณ  27/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณMostra a legenda do processo.                               บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Legenda()

	BrwLegenda(cCadastro,"Aprova็ใo de Pedidos", {	{"BR_VERMELHO"	,"Aprovada"},;  
	                                                {"BR_VERDE"   	,"Pendente"}})
Return .T.

User Function ACOM016a(cAlias, nRecno, nOpc)

	A120Pedido(cAlias, nRecno, nOpc)

	dbSelectArea("SC7")
	DbSetOrder (1)

	cArqSZ2 := CriaTrab(,.F.)
	cKeySZ2 := IndexKey() //"F2_FILIAL+Z2_RECURSO"
	cQuery  := "AllTrim(C7_XSTATFI) $ 'P/L'"
	
	IndRegua("SC7",cArqSZ2,cKeySZ2,,cQuery, "Selecionando Registros...")
	nOrdSZ2 := RetIndex("SC7")
	#IFNDEF TOP
		dbSetIndex(cArqSZ2+OrdBagExt())
	#ENDIF
	dbSetOrder(nOrdSZ2+1)
	cAlias := "SC7"
	
Return


User Function ACOM016c()

	Local a_area := SC7->(GetArea())
	Local c_nump := SC7->C7_NUM
	n_TotalPed := 0 					//[Incluido por - TOBIAS PENICHE - Actual Trend - 21082013]
	
	If !msgYesNo('Tem certeza que deseja aprovar o pedido de compras?', "ATENวรO")
		Return
	EndIf

	SC7->(DbGotop())
	
	While SC7->(!EOF())
		If SC7->C7_NUM = c_nump
			RecLock('SC7', .F.)
			SC7->C7_XSTATFI := 'L'
			SC7->C7_XDTAPRF	:= dDataBase
			SC7->C7_XUSRFIN	:= cusername
			MsUnLock()
			
			n_Item := SC7->C7_TOTAL			//[Incluido por - TOBIAS PENICHE - Actual Trend - 21082013]
			n_TotalPed += n_Item				//[Incluido por - TOBIAS PENICHE - Actual Trend - 21082013]
			
		EndIf
		SC7->(DbSkip())
	EndDo

	RestArea(a_area)

	EnviaEmail()

Return


User Function ACOM016d()

	Local a_area := SC7->(GetArea())
	Local c_nump := SC7->C7_NUM

	If !msgYesNo('Tem certeza que deseja ESTORNAR a aprova็ใo do pedido de compras?', "ATENวรO")
		Return
	EndIf

	SC7->(DbGotop())
	
	While SC7->(!EOF())
		If SC7->C7_NUM = c_nump
			RecLock('SC7', .F.)
			SC7->C7_XSTATFI := 'P'
			SC7->C7_XDTAPRF	:= dDataBase
			SC7->C7_XUSRFIN	:= cusername
			MsUnLock()
		EndIf
		SC7->(DbSkip())
	EndDo

	RestArea(a_area)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTK260ROT  บAutor  ณMicrosiga           บ Data ณ  08/23/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณEnvia o email para os responsaveis.                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function EnviaEmail()

	Local l_Continua	:= .T.
	
	Private c_texto 	:= ''
	Private c_msgerro	:= ''
	Private c_FileOrig	:= "\HTML\ACOM016.htm"
	Private c_FileDest	:= "C:\siga.html"
	Private c_para		:= GetMV("MV_XMAILCF") 
	Private c_CodProj   := ''
	Private c_CodEdt    := ''  
	Private c_ccusto    := ''
	Private c_ValObra   := '' 
	
    cNome_user := Busca_nome(__cuserid)
    DbSelectArea('CTT')
    DbSetOrder(1)
    DbSeek(xFilial('CTT')+SC7->C7_XCCFTD)
    
	fArq(c_FileOrig, c_FileDest)
	
    	If !U_FGEN010(c_para,"Aprova็ใo de pedido de compras para faturamento direto. Usuario: "+cnome_user+" ",c_texto,,.t.)	
			Return c_msgerro
	EndIf           
	                                                                                                                        
       	If !U_FGEN010("decio@playpiso.com.br","Aprova็ใo de pedido de compras para faturamento direto. Usuario: "+cnome_user+" ",c_texto,,.t.)
      		Return c_msgerro                       //[Alterado acima - TOBIAS PENICHE - Actualtrend - 20130905]
   		EndIf    
   
Return ""

Static Function fArq(c_FileOrig, c_FileDest)

	Local l_Ret 	:= .T.
	Local c_Buffer	:= ""
	Local n_Posicao	:= 0
	Local n_QtdReg	:= 0
	Local n_RegAtu	:= 0

	If !File(c_FileOrig)
		l_Ret := .F.
		MsgStop("Arquivo [ "+c_FileOrig+" ] nใo localizado.", "Nใo localizou")
	Else
		
		Ft_fuse( c_FileOrig ) 		// Abre o arquivo
		Ft_FGoTop()
		n_QtdReg := Ft_fLastRec()
		
		nHandle	:= MSFCREATE( c_FileDest )

		///////////////////////////////////
		// Carregar o array com os itens //
		///////////////////////////////////
		While !ft_fEof() .And. l_Ret
			
			c_Buffer := ft_fReadln()
			
			FWrite(nHandle, &("'" + c_Buffer + "'"))
			c_texto += &("'" + c_Buffer + "'")
			ft_fSkip()
			
		Enddo
		
		FClose(nHandle)

	Endif
	
Return l_Ret

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณBusca_NomeบAutor  ณJean Cavalcante     บ Data ณ  09/08/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca o Nome do Usuแrio Logado.				              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function Busca_Nome(c_User) 

	c_user := Iif(c_User=Nil, __CUSERID, c_user)

	_aUser := {}
	psworder(1)
	pswseek(c_user)
	_aUser := PSWRET()

	_cnome		:= Substr(_aUser[1,4],1,50)

Return(_cnome) 
