#include "ap5mail.ch"
#INCLUDE 'FONT.CH'
#include "sigawin.ch"
#INCLUDE "rwmake.CH"
#INCLUDE "PROTHEUS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LASP002   ºAutor  ³Fabio Jadao Caires  º Data ³  05/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Esta rotina tem por objetivo tratar a leitura de codigo de º±±
±±º          ³ barras dos produtos gerando uma etiqueta de embalagem para º±±
±±º          ³ quando da entrega nas filiais ou franquias, haja a possibi-º±±
±±º          ³ lidade de executar a leitura das etiquetas e realizar a    º±±
±±º          ³ entrada dos produtos referentes a embalagem.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva Bookstore                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_PERDA()
///////////////////////

Local nI 			:= 0
Local nCnt 			:= 0
Local cIndFOR 		:= " "
Local aCaixa 		:= {}
Local nSoma 		:= 0
Local cFilter		:= " "
Local bFilFilter 	:= {}
Local aIndexFOR		:= {}
Local cAlias 		:= " "
Local aCposBrw 		:= {}
Private aCposFOR 	:= {}
Private aRotina  	:= {}
Private lRefresh 	:= .T.
Private cQuery 		:= " "
Private aCores 		:= {}
Private cCadastro 	:= "Perdas"
Private cPerg  		:= "Perdas"
Private cNmFilial 	:= " "

_cNota 				:= ""
_cSerie 			:= ""


DbSelectArea("FOR")
DbSetOrder(1)

cQuery := "SELECT * "

cQuery += " FROM " + RetSqlName("FOR") + " FORN (NOLOCK)"

cQuery += " INNER JOIN " + RetSqlName("FOI") + " FOI (NOLOCK) "
cQuery += " 									ON FOI_FILIAL=FOR_FILIAL "
cQuery += " 									AND FOI_NUM = FOR_NUM "
cQuery += " 									AND FOI_CODFOR=FOR_COD "
cQuery += " 									AND FOI_LOJA=FOR_LOJA AND FOI.D_E_L_E_T_='' "
cQuery += " WHERE FORN.FOR_FILIAL = '"+xFilial("FOR")+"'  "

cQuery += " ORDER BY FORN.FOR_NUM"

dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"FORTMP", .T., .T.)
TcSetField('FORTMP','FOR_EMISSA','D',0)
TcSetField('FORTMP','FOI_EMISSS','D',0)

dbSelectArea("SX3")
DbSetOrder(1)
aAreaSX3 := GetArea()
If dbSeek("FOR")
	While !Eof() .And. X3_ARQUIVO == "FOR"
		If Trim(X3_CAMPO) $ cQuery
			AAdd(aCposFOR,{Trim(X3_CAMPO), X3_TIPO, X3_TAMANHO, X3_DECIMAL})
			If X3_BROWSE == "S"
				AAdd(aCposBrw,{X3TITULO(X3_CAMPO), &("{|| "+aCposFOR[Len(aCposFOR),1]+"}"), X3_TIPO, X3_TAMANHO, X3_DECIMAL, RTrim(X3_PICTURE) })
			EndIf
		EndIf
		SX3->(dbSkip())
	EndDo
	AAdd(aCposFOR,{"R_E_C_N_O_","N",14,0})
Else
	Alert("Tabela FOR não cadastrada")
	Return
EndIf
RestArea(aAreaSX3)

For nI := 1 to Len(aCposFOR)
	If aCposFOR[nI,2] <> "C"
		TCSetField("FORTMP", aCposFOR[nI,1], aCposFOR[nI,2], aCposFOR[nI,3], aCposFOR[nI,4])
	Endif
Next

cArqTrab := CriaTrab( aCposFOR, .T. )
dbUseArea( .T., "DBFCDX", cArqTrab, "TRB", .T. ,.F. )

IndRegua( "TRB", cArqTrab, "FOR_NUM" )

cAlias := "TRB"
dbSelectArea('TRB')
dbSetOrder(1)

//MsAguarde( {|lEnd| GrvTrb(@lEnd)}, "Aguarde...","Processando", .T. )

aAdd( aRotina, {"Pesquisa"  	, "u_LS_Pesquisa(.T.)"	,0,2,0,.f.} )
aAdd( aRotina, {"Inclui"  	, "u_PERDAI(.T.)"	,0,2} ) //Saida
aAdd( aRotina, {"altera"  	, "u_PERDAA"   		,0,3} )
aAdd( aRotina, {"Gera Pedido"	, "u_GERA_PED"  		,0,3} )
aAdd( aRotina, {"Visualiza" 	, "U__perdav(2)" 		,0,2} )

aAdd(aCores, { "(TRB->FOR_STATUS == '1')", "BR_AMARELO"  	}) //Separacao divergente
aAdd(aCores, { "(TRB->FOR_STATUS == '2')", "BR_AZUL"     	}) //Expedicao Ok

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtro da MBrowse³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

mBrowse(  ,  ,  ,  ,'TRB',aCposBrw,,,,,aCores)

DbCloseArea()

dbSelectArea("FORTMP")
DbCloseArea()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvTrb    ºAutor  ³Deosdete P. Silva   º Data ³  04/04/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Alimentar arquivo temporario com os dados da Query         º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASP001                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvTrb(lEnd)
////////////////////////////
Local nCnt  := 0
Local nI    := 0
Local nSoma := 0



FORTMP->(dbGoTop())
ProcRegua(nCnt)

While !FORTMP->(Eof())
	MsProcTxt("Processando movimentos: " + DToC(FORTMP->FOR_EMISSA))
	ProcessMessage()
	
	If lEnd
		MsgInfo(cCancela,"Processo cancelado")
		Exit
	Endif
	
	RecLock('TRB', .T.,.F.)
	
	For nI := 1 To Len(aCposFOR) - 1
		&('TRB' + "->" + aCposFOR[nI,1]) := &("FORTMP->" + aCposFOR[nI,1])
		If nI == 3 // Descricao do status
			Do Case
				
				Case &("FORTMP->" +  aCposFOR[nI-1,1]) == "1"
					&('TRB' + "->" + aCposFOR[nI,1]) := "Incluído"
					
				Case &("FORTMP->" +  aCposFOR[nI-1,1]) == "2"
					&('TRB' + "->" + aCposFOR[nI,1]) := "Gerado Pedido"
					
			EndCase
		EndIf
	Next
	
	TRB->R_E_C_N_O_ := nCnt
	
	MsUnLock()
	
	FORTMP->(dbSkip())
	nCnt++
End

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ Separa   ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de separacao dos itens do romaneio                  º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASEA003                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function PERDAI (lSaida)
///////////////////////////////

u_LS_Pesquisa(.f.)

Private cGetProd := Space( Len( SB1->B1_CODBAR) )
Private oGetProd

Private nQtd	 := Space(5)

Private oDlg
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox1 := {}
Private oListBox1

Private aValid		:= {}

Private oOk     	:= LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oCont		:= LoadBitmap( GetResources(), "BR_AZUL" 	)	//Contagem em curso
Private oDiverg		:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente
Private oUltra		:= LoadBitmap( GetResources(), "BR_LARANJA" 	)	//Qtd Ultrapassada
Private oFora		:= LoadBitmap( GetResources(), "BR_PRETO" 	)	//Item fora do romaneio


If lSaida
	cTitulo := "Carga do Romaneio - Saida de Produtos"
Else
	cTitulo := "Carga do Romaneio - Entrada de Produtos"
	
	If _cPorta <> '7990' .and. alltrim(TRB->FOR_SERIE) == '8' .and. TRB->FOR_FILORI  <> 'BH' .and. TRB->FOR_FILORI  <>'RC'
		//Verifica status da NF-e enviada e aprovada
		_cQuery := "SELECT STATUS STATUSNFE, ID_ENT, NFE_ID"
		_cQuery += _cEnter + "FROM SPED050"
		_cQuery += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED('" + TRB->FOR_FILORI + "')"
		_cQuery += _cEnter + "AND NFE_ID = '" + TRB->FOR_SERIE + TRB->FOR_NFS + "'"
		_cQuery += _cEnter + "AND D_E_L_E_T_ = ''"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"SEFAZ", .T., .T.)
		_cStatus := SEFAZ->STATUSNFE
		DbCloseArea()
		
		If _cStatus = 0
			MsgBox('NF-e ainda não transmitida para a SEFAZ. Verifique com a Loja de origem!','ATENÇÃO!!!','ALERT')
			Return()
		ElseIf _cStatus <> 6
			MsgBox('NF-e não aprovada pela SEFAZ. Verifique com a Loja de origem se a nota já foi transmitida e aprovada na SEFAZ','ATENÇÃO!!!','ALERT')
			Return()
		EndIf
	EndIf
EndIf

Set Key VK_F11 to u_ls_Estorna()

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If !lSaida .And. TRB->FOR_FILDES != cFilAnt
	Alert("Este romaneio só poderá ser recebido na filial de destino.")
	Return
EndIf

If lSaida .And. TRB->FOR_FILORI != cFilAnt
	Alert("Este romaneio só poderá ser separado na filial de origem.")
	Return
EndIf

If TRB->FOR_STATUS == "01" .And. !lSaida//Ainda nao separado
	Alert("Este romaneio ainda nao foi separado." + _cEnter + "Antes de recebê-lo, o romaneio deve ser separado e expedido.")
	Return
EndIf

If !lSaida
	_cQuery := "UPDATE PA7"
	_cQuery += _cEnter + " SET PA7_QUANT = D2_QUANT"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK),"
	
	_cQuery += _cEnter + " (SELECT D2_DOC, D2_COD, D2_FILIAL, D2_LOJA, D2_PEDIDO, SUM(D2_QUANT) D2_QUANT"
	
	_cQuery += _cEnter + " FROM " + RetSqlName('FOR') + " FOR (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	_cQuery += _cEnter + " ON D2_FILIAL = FOR_FILORI"
	_cQuery += _cEnter + " AND D2_DOC = FOR_NFS"
	_cQuery += _cEnter + " AND D2_SERIE = FOR_SERIE"
	_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE FOR_NUMROM = '" + TRB->FOR_NUMROM + "'"
	_cQuery += _cEnter + " AND FOR_STATUS = '04'"
	_cQuery += _cEnter + " AND FOR.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " GROUP BY D2_DOC, D2_COD, D2_FILIAL, D2_LOJA, D2_PEDIDO) A"
	
	_cQuery += _cEnter + " WHERE PA7_NUMROM = '" + TRB->FOR_NUMROM + "'"
	_cQuery += _cEnter + " AND PA7_CODPRO = D2_COD"
	_cQuery += _cEnter + " AND PA7.D_E_L_E_T_ = ''"
	
	TcSqlExec(_cQuery)
	
EndIf

If TRB->FOR_STATUS == "02" .And. lSaida //Separacao Ok
	If lSaida
		
		If !MsgYesNo("Este romaneio ja esta com a separação Ok. Deseja refazer a separação?")
			Return(.T.)
		EndIf
	Else
		Alert("Este romaneio ja foi devidamente separado mas ainda nao foi expedido." + _cEnter + "Antes de recebê-lo, o romaneio deve ser expedido.")
		Return
	EndIf
EndIf

If TRB->FOR_STATUS == "03" .And. !lSaida //Separacao divergente
	Alert("Este romaneio nao foi devidamente separado. Corrija a separacao mas ainda nao foi expedido." + _cEnter + "Antes de recebê-lo, o romaneio deve ser expedido.")
	Return
EndIf


If TRB->FOR_STATUS == "04" .And. lSaida //Em expedicao
	Alert("Este romaneio já está em Expedição e não pode mais ser separado." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "05" //Recebido Ok
	Alert("Este romaneio já foi devidamente recebido." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "06" //Encerrado
	Alert("Este romaneio já foi encerrado e não pode mais ser separado."+ _cEnter +	"Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

_cAviso  := ''
_cUltimo := ''
_oFont1  := TFont():New ("Arial Black", 8, 18)
_lToque  := .t.

oDlg:=MsDialog():New(0,0,500,800,cTitulo,,,,,CLR_BLACK,CLR_WHITE,,,.T.)
@ (009),(006) Say "Filial :" 						Size (018),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (009),(036) Say Alltrim(TRB->FOR_LOJA) 			Size (084),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (020),(006) Say "Romaneio : " 					Size (028),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (020),(036) Say Alltrim(TRB->FOR_NUMROM)			Size (029),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (030),(006) Say "Carga: " 						Size (019),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (030),(036) Say Alltrim(TRB->FOR_CARGA)			Size (066),(008) COLOR CLR_BLACK 	PIXEL OF oDlg

@ (003),(100) Get _oAviso  var _cAviso   MEMO		Size (280),(050) COLOR CLR_RED 		PIXEL OF oDlg when .f.
_oAviso:oFont := _oFont1

@ (055),(006) Say "Codigo do Produto:" 				Size (051),(008) COLOR CLR_BLACK 	PIXEL OF oDlg
@ (055),(100) Get oGetProd Var cGetProd          	Size (115),(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg  Valid ( LS03REFRES() .or. Empty( cGetProd ) ) when _lToque
@ (055),(075) Get oGetQtd  Var nQtd  				Size (020),(009) COLOR CLR_BLACK Picture "@E 99999" PIXEL OF oDlg  Valid VlnQtd() when _lToque
@ (230),(006) Say "[F11] Estorno"					Size (051),(008) COLOR CLR_BLACK PIXEL OF oDlg

@ (230),(050) Button "Tocar" 	    				Size (037),(012) 					PIXEL OF oDlg ACTION(FTocar())
@ (230),(220) Button "Ok" 							Size (037),(012) 					PIXEL OF oDlg ACTION(GrvRom(lSaida))
@ (230),(270) Button "Cancelar" 					Size (037),(012) 					PIXEL OF oDlg ACTION(oDlg:End())

fListBox1(lSaida)

oDlg:Activate(,,,.T.)

Set Key VK_F11 to

Return(.T.)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VlnQtd()
////////////////////////

_lRet := (( Val(nQtd) > 0) .and. !empty(cGetProd)) .or. empty(cGetProd)

If val(nQtd) < 0
	MsgBox('Quantidade não pode ser negativa!','ATENÇÃO!!!','ALERT')
	nQtd  := space(5)
	_lRet := .f.
	oGetQtd:Refresh()
EndIf

If _lRet
	_lToque := .t.
	oGetProd:SetFocus()
	oGetProd:Refresh()
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function FTocar()
////////////////////////
_cAviso := ''
_lToque := .t.
_oAviso:Refresh()
oGetQtd:Refresh()
oGetProd:SetFocus()
oGetProd:Refresh()

Return()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ Estorna  ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de estorno das quantidades da separacao.            º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASEA003                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ Expede   ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de expedicao dos itens do romaneio                  º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASEA003                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function PERDAA()
/////////////////////////

u_LS_Pesquisa(.f.)
//SC5->(DbSeek(right(TRB->FOR_NUMROM,2) + left(TRB->FOR_NUMROM,6),.f.))  /
dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(right(TRB->FOR_NUMROM,2) + left(TRB->FOR_NUMROM,6))

_cQuery := "SELECT SUM(C9_QTDLIB) QTDLIB, "
_cQuery += _cEnter + " (SELECT SUM(PA7_QUANT) PA7_QUANT"
_cQuery += _cEnter + " FROM " + RetSqlName('PA7') + " PA7 (NOLOCK)"
_cQuery += _cEnter + " WHERE PA7_NUMROM = '" + TRB->FOR_NUMROM + "'"
_cQuery += _cEnter + " AND PA7.D_E_L_E_T_ = '') QTDROM, "

_cQuery += _cEnter + " (SELECT SUM(C6_QTDVEN) C6_QTDVEN"
_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
_cQuery += _cEnter + " WHERE C6_NUM = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND C6_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND SC6.D_E_L_E_T_ = '') QTDPED"

_cQuery += _cEnter + " FROM " + RetSqlName('SC9') + " SC9 (NOLOCK)"

_cQuery += _cEnter + " WHERE C9_FILIAL = '" + SC5->C5_FILIAL + "'"
_cQuery += _cEnter + " AND C9_PEDIDO = '" + SC5->C5_NUM + "'"
_cQuery += _cEnter + " AND SC9.D_E_L_E_T_ = ''"

If Select("LIB") > 0
	DbSelectArea("LIB")
	DbCloseArea()
EndIf

DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"LIB", .T., .T.)
_lOkNF := (QTDPED == QTDROM .and. QTDLIB == QTDROM)
DbCloseArea()

If !_lOkNF
	MsgBox('Divergências nas quantidades liberadas X romaneio. Estorne a liberação do pedido e libere novamente.','ATENÇÃO!!!','ALERT')
	Return()
EndIf

Private cGetVol  	:= CRIAVAR("PA8_CODCOL")
Private oGetVol
Private oGetQtd1
Private nGetQtd1 	:= SC5->C5_VOLUME1
Private nGetPesoB 	:= SC5->C5_PBRUTO
Private nGetPesoL 	:= SC5->C5_PESOL
Private	cGetTrans 	:= SC5->C5_TRANSP
Private cGetNTran 	:= Posicione('SA4',1,xFilial('SA4') + cGetTrans,'A4_NOME')

Private oDlg3
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox2 := {}
Private oListBox2

Private aVolumes	:= {}

Private oVolOk  := LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oVolDiv	:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If TRB->FOR_FILORI <> cFilAnt
	If TRB->FOR_STATUS == "01"
		Alert("Este romaneio deve ser separado na filial "+TRB->FOR_FILORI)
		Return(.T.)
	ElseIf TRB->FOR_STATUS == "02"
		Alert("Este romaneio deve ser expedido na filial "+TRB->FOR_FILORI)
		Return(.T.)
	EndIf
EndIf

If TRB->FOR_STATUS == "01"
	Alert("Favor realizar a separação do romaneio!")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "03"  //Separacao divergente
	Alert("Ainda existem divergências na separação deste romaneio. Favor refazer a separação ou " + _cEnter + "solicite a aprovação da separação deste romaneio.")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "04" //Expedicao Ok
	Alert("Este romaneio ja foi separado e expedido.")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "05" //Recebimento Ok
	Alert("Este romaneio já foi expedido e recebido na filial de destino." + _cEnter + "Contate a filial de destino deste romaneio.")
	Return(.T.)
EndIf

If TRB->FOR_STATUS == "06" //Encerrado
	Alert("Este romaneio já foi encerrado." + _cEnter + "Nenhuma ação sobre este romaneio é permitida.")
	Return(.T.)
EndIf

If !xGetVol()
	Alert("Nenhum volume encontrado para a expedicao.")
	Return
EndIf
_lOk := .t.
If xFilial('SC5') <> 'C0'
	_lOk := .f.
	DEFINE MSDIALOG oDlg3 TITLE "Carga do Romaneio - Controle de Volumes" FROM C(178),C(181) TO C(600),C(662) PIXEL
	
	@ C(005),C(006) Say "Filial :" 					Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(005),C(025) Say Alltrim(TRB->FOR_LOJA) 		Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(006) Say "Romaneio : " 				Size C(028),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(036) Say Alltrim(TRB->FOR_NUMROM)	Size C(029),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(074) Say "Carga: " 					Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(015),C(094) Say Alltrim(TRB->FOR_CARGA)		Size C(066),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	
	@ C(025),C(006) Say "Volume:"            		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(025),C(040) MsGet oGetVol Var cGetVol  		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 Picture "@!" Valid ( Empty(cGetVol) .OR. VOLREFRES() )
	
	@ C(025),C(100) Say "Qtd Volumes:"         		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(025),C(150) MsGet oGetQtd1 Var nGetQtd1		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '999'
	
	@ C(040),C(006) Say "Peso Líquido:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(040),C(040) MsGet oGetPL  Var nGetPesoB		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99
	
	@ C(040),C(100) Say "Peso Bruto:"          		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(040),C(150) MsGet oGetPB   Var nGetPesoL	Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99
	
	@ C(055),C(006) Say "Transportadora:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
	@ C(055),C(040) MsGet oGetTra Var cGetTrans		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 F3 'SA4' Valid TrnpRefres()
	@ C(055),C(100) MsGet oGetTrb Var cGetNTran		Size C(100),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 when .f.
	
	fListBox2()
	
	@ C(190),C(151) Button "Ok" 		Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .t., oDlg3:End())
	@ C(190),C(195) Button "Cancelar" 	Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .f., oDlg3:End())
	
	ACTIVATE MSDIALOG oDlg3 CENTERED Valid ( !_lOk .or. VldDlg3() )
EndIf

If _lOk
	GeraNF()
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ Monitor  ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Rotina de monitoramento dos romaneios.                     º±±
±±º          |                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ LASEA003                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fListBox1() ³ Autor ³ Fabio Jadao Caires       ³ Data ³18/06/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox1(lSaida)
/////////////////////////////////


Local lOk			:= .F.
Local cCodBar   	:= ''
Local aArea     	:= GetArea()
Local aAreaSB1  	:= SB1->( GetArea() )

Private oBrowse, oDlgMain, oBtnItens
Private oMarca

Private nItens 		:= 0
Private nTotCheque	:= 0
Private nTotBorder	:= 0
Private nTotValor	:= 0.00
Private lInverte	:= .F.

Private oLbx
Private aLotes 		:= {}
Private aItens 		:= {}
Private aItensCor	:= {}
Private oLegenda

// Se for para recebimento mostrar a quantidade PA7_QUANT e nao mostrar mais a quantidade PA7_QTDORI. Criar PA7_QTDREC e apontar nesta quantida e comprarar.
If PA7->( DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ) )
	While !PA7->(EOF()) .AND. PA7->PA7_NUMROM == TRB->FOR_NUMROM
		
		SB1->( DbSetOrder(1) )
		If SB1->( DbSeek( xFilial('SB1') + PA7->PA7_CODPRO ) )
			cCodBar := SB1->B1_CODBAR
		EndIf
		
		If lSaida
			Do Case
				Case PA7->PA7_QUANT == 0  //< PA7->PA7_QTDORI //Qtd contada < Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
					aAdd(aListBox1,{oCont, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
				Case PA7->PA7_QUANT == PA7->PA7_QTDORI //Qtd contada = qtd romaneio
					aAdd(aListBox1,{oOk, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
				Otherwise //Qtd contada > qtd romaneio
					aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_QTDORI})
			EndCase
		Else
			Do Case
				Case PA7->PA7_QTDREC == 0 //< PA7->PA7_QUANT //Qtd contada < Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
					aAdd(aListBox1,{oCont, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
				Case PA7->PA7_QTDREC == PA7->PA7_QUANT //Qtd contada = qtd romaneio
					aAdd(aListBox1,{oOk, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
				Otherwise //Qtd contada > qtd romaneio
					aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, cCodBar, PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_QUANT})
			EndCase
		EndIf
		PA7->(DbSkip())
	EndDo
EndIf

@ (070),(004) LISTBOX oListBox1 FIELDS HEADER "","Codigo", "Cod. Barras", "Descricao", "Qtd contada"  SIZE (400),(150) Of oDlg Pixel	ColSizes 50,50,50,50

oListBox1:SetArray(aListBox1)

oListBox1:bLine 		:= {|| {	aListBox1[oListBox1:nAT,01],;
aListBox1[oListBox1:nAT,02],;
aListBox1[oListBox1:nAT,03],;
aListBox1[oListBox1:nAT,04],;
aListBox1[oListBox1:nAT,05],;
aListBox1[oListBox1:nAT,06] }}

RestArea( aArea )
RestArea( aAreaSB1 )
Return Nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fListBox2() ³ Autor ³ Fabio Jadao Caires    ³ Data ³18/06/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox2()
///////////////////////////


Local lOk			:= .F.
Local nX			:= 0

Private oBrowse, oDlgMain, oBtnItens
Private oMarca

Private nItens 		:= 0
Private nTotCheque	:= 0
Private nTotBorder	:= 0
Private nTotValor	:= 0.00
Private lInverte	:= .F.

Private oLbx
Private aLotes 		:= {}
Private aItens 		:= {}
Private aItensCor	:= {}
Private oLegenda

For nX := 1 to Len(aVolumes)
	Aadd(aListBox2,{ oVolDiv, aVolumes[nX,1], Space(Len(PA8->PA8_STATUS)) })
Next nX

If PA8->( DbSeek( xFilial("PA8")+TRB->FOR_NUMROM ) )
	While !PA8->(EOF()) .AND. PA8->PA8_NUMROM == TRB->FOR_NUMROM
		
		nX := aScan(aListBox2 ,{|x| x[2] == PA8->PA8_CODCOL })
		
		If nX > 0
			If PA8->PA8_CODST == "02"
				aListBox2[nX,1] := oVolOk
				aListBox2[nX,3] := "Volume Ok"
			Else
				aListBox2[nX,1] := oVolDiv
				aListBox2[nX,3] := " "
			EndIf
		EndIf
		
		PA8->(DbSkip())
		
	EndDo
EndIf

@ C(070),C(004) LISTBOX oListBox2 FIELDS HEADER "","Volume", "Status" SIZE C(200),C(070) Of oDlg3 Pixel	ColSizes 50,50,50

oListBox2:SetArray(aListBox2)

oListBox2:bLine 		:= {|| {	aListBox2[oListBox2:nAT,01],;
aListBox2[oListBox2:nAT,02],;
aListBox2[oListBox2:nAT,03]}}

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³fListBox5() ³ Autor ³ Fabio Jadao Caires    ³ Data ³26/06/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Montagem da ListBox do monitor                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox5()
///////////////////////////

Local nDiffSaida := 0
Local nDiffEntrada := 0

PA7->( DbSetOrder(1) )
PA7->( DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ) )

While !PA7->( EOF() ) .AND. PA7->PA7_NUMROM == TRB->FOR_NUMROM
	
	nDiffSaida   := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	nDiffEntrada := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	
	
	If nDiffSaida == 0 .Or. nDiffEntrada == 0
		Aadd( aListBox5,{oOk5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida > 0 .Or. nDiffEntrada > 0
		Aadd( aListBox5,{oDiv5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida < 0 .Or. nDiffEntrada < 0
		Aadd( aListBox5,{oCont5,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	PA7->(DbSkip())
	
EndDo

@ C(084),C(003) ListBox oListBox5 Fields ;
HEADER " ","Codigo","Descricao","Qtd original","Qtd Saida","Qtd Entrada", "Dif Saida","Dif Entrada"  Size C(389),C(157) Of oDlg5 Pixel;
ColSizes 50,50,50,50,50,50,50,50

oListBox5:SetArray(aListBox5)

oListBox5:bLine 		:= {|| {;
aListBox5[oListBox5:nAT,01],;
aListBox5[oListBox5:nAT,02],;
aListBox5[oListBox5:nAT,03],;
aListBox5[oListBox5:nAT,04],;
aListBox5[oListBox5:nAT,05],;
aListBox5[oListBox5:nAT,06],;
aListBox5[oListBox5:nAT,07],;
aListBox5[oListBox5:nAT,08]}}

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GeraNF    ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmacao da gravacao do volume do romaneio e geracao da  º±±
±±º          ³nota fiscal                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraNF()
////////////////////////

Local nI			:= 0
Local lDiverg   	:= .F.
Local lAchouFOR		:= .F.

cLockBy := 'GeraNF_' + GetMv('FS_LASSER ') + '_' + cEmpAnt + '_' + SM0->M0_CGC
_cSerie := padr(GetMv("FS_LASSER"),3,' ')
_lCont  := .f.
Do While !_lCont
	
	If !LockByName(cLockBy,.t.,.t.,.t.,.t.)
		If !(__cUserId $ GetMV('LA_PODER'))
			_lCont := .f.
			DbSelectArea('SX5')
			DbSeek(cFilAnt + '01' + _cSerie,.f.)
			If RecLock('SX5',.F.)
				_lCont := .t.
				MsUnLock()
			EndIf
			If !_lCont
				_cTexto := 'Outro usuário utilizando a rotina de geração de notas fiscais!!!' + _cEnter + _cEnter
				_cTexto += 'Tentar novamente?'
				If !MsgBox(_cTexto , 'Romaneios - Geração de Notas Fiscais','YESNO' )
					Return()
				EndIf
			Else
				MsgBox('Antes de prosseguir, certifique-se que não há nenhum outro usuário utilizando esta rotina para esta loja/filial (CNPJ).','ATENÇÃO!!!','ALERT')
			EndIf
			
		EndIf
	Else
		_lCont := .t.
	EndIf
EndDo

For nI := 1 to Len(aListBox2)
	If aListBox2[nI,1] <> oVolOk
		lDiverg := .T.
		Exit
	EndIf
Next nI

nI := 0

If lDiverg
	MsgAlert("Existem ainda volumes a serem confirmados. O processo não pode prosseguir " + _cEnter + "sem que o(s) volume(s) estante(s) seja(m) identificado(s).")
	
	cGetVol := CRIAVAR("PA8_CODCOL")
	oGetVol:Refresh()
	oGetVol:SetFocus()
	
	UnLockByName( cLockBy,.t.,.t.,.t.,.t.)
	Return
EndIf

// Chamada da funcao de geracao da NF devera ser neste PONTO !!!

MsAguarde({|| 	_cNota := GravaNFS()},"Aguarde...","Gerando Nota Fiscal de Saida",.T.)

For nI := 1 to Len(aListBox2)
	PA8->(DbSeek( xFilial("PA8")+TRB->FOR_NUMROM+aListBox2[nI,2] ))
	RecLock("PA8",.F.)
	If aListBox2[nI,1] == oVolOk
		PA8->PA8_CODST		:= "02" //Ok
		PA8->PA8_STATUS	:= "Expedição Ok"
	EndIf
	MsUnlock()
Next nI

_cSerie := iif(empty(_cSerie),left(GetMv('FS_LASSER') + '   ',3) , _cSerie)

DbSelectArea('SF2')
DbSetOrder(1)
If !DbSeek(right(TRB->FOR_NUMROM,2) + _cNota + _cSerie,.f.)
	MsgBox('Nota fiscal não foi gerada. Verifique!','ATENÇÃO!!!','ALERT')
Else
	DbSelectArea('SC5')
	DbOrderNickName('C5_NOTA')
	If !SC5->(DbSeek(right(TRB->FOR_NUMROM,2) + _cNota + _cSerie ,.f.))
		SC5->(DbSetOrder(1))
		If SC5->(DbSeek(right(TRB->FOR_NUMROM,2) + left(TRB->FOR_NUMROM,6) ,.f.))
			RecLock('SC5',.f.)
			SC5->C5_NOTA  := _cNota
			SC5->C5_SERIE := _cSerie
			MsUnLock()
		EndIf
	ElseIf SC5->C5_NUM + SC5->C5_FILIAL <> TRB->FOR_NUMROM
		MsgBox('Nota fiscal (' + _cNota + '/' + _cSerie + ') gravada no romaneio (' + SC5->C5_NUM + SC5->C5_FILIAL + '). Verifique!','ATENÇÃO!!!','ALERT')
	EndIf
	
	_cQuery := "UPDATE " + RetSqlName('SB2')
	_cQuery += _cEnter + " SET B2_QPEDVEN = B2_QPEDVEN - D2_QUANT"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD2') + " SD2 (NOLOCK)
	_cQuery += _cEnter + " WHERE SD2.D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND D2_DOC = '" + _cNota + "'"
	_cQuery += _cEnter + " AND D2_SERIE = '" + _cSerie + "'"
	_cQuery += _cEnter + " AND D2_FILIAL = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + " AND D2_COD = B2_COD"
	_cQuery += _cEnter + " AND " + RetSqlName('SB2') + ".D_E_L_E_T_ = ''"
	_cQuery += _cEnter + " AND B2_FILIAL = D2_FILIAL"
	TcSqlExec(_cQuery)
	
	RecLock("TRB",.F.)
	TRB->FOR_STATUS := "04"
	TRB->FOR_DESCST := "Expedicao Ok"
	TRB->FOR_NFS    := _cNota
	TRB->FOR_SERIE	:= _cSerie
	MsUnlock()
	
/*	FOR->(DbSetOrder(1))
	If FOR->(DbSeek( xFilial("FOR")+TRB->FOR_NUMROM ))
		RecLock("FOR",.F.)
		FOR->FOR_STATUS := "04"	//Expedicao Ok
		FOR->FOR_USER 	:= cUserName
		FOR->FOR_NFS    := _cNota
		FOR->FOR_SERIE	:= _cSerie
		Msunlock()
	EndIf
*/	
EndIf

UnLockByName( cLockBy,.t.,.t.,.t.,.t. )
Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GrvRom    ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Confirmacao da gravacao do romaneio e ajusta os status do   º±±
±±º          ³romaneio                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvRom(lSaida)
//////////////////////////////

Local nI		:= 0
Local lDiverg	:= .F.


For nI := 1 to Len(aListBox1)
	If aListBox1[nI,1] <> oOk
		lDiverg := .T.
		Exit
	EndIf
Next nI

nI := 0

If lDiverg
	If !MSgYesNo("Foram encontradas divergências entre os itens/quantidades do romaneio e separação." + _cEnter + "Deseja gravar esta separação e ajustá-la mais tarde?")
		Return
	EndIf
EndIf

Begin Transaction
PA7->(DbSetOrder(1))
For nI := 1 to Len(aListBox1)
	If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM+aListBox1[nI,2] ) )
		RecLock("PA7",.F.)
	Else
		RecLock("PA7",.T.)
	EndIf
	
	PA7->PA7_FILIAL	:= xFilial("PA7")
	PA7->PA7_NUMROM	:= TRB->FOR_NUMROM
	PA7->PA7_CODPRO	:= aListBox1[nI,2]
	PA7->PA7_DESCPR := aListBox1[nI,4]
	If lSaida
		PA7->PA7_QUANT	:= aListBox1[nI,5]
	Else
		PA7->PA7_QTDREC := aListBox1[nI,5]
	EndIf
	
	MsUnlock()
Next nI
//If lSaida
/*	For nI := 1 to Len(aListBox1)
If SB2->(DbSeek(TRB->FOR_FILDES + aListBox1[nI,2])) // ATUALIZA NO DESTINO
RecLock("SB2",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane d
e Oliveira 05/02/16            ³
//³Trocou o campo b2_salpedi por B2_XTRANSI³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//			SB2->B2_SALPEDI := SB2->B2_SALPEDI + aListBox1[nI,5] - aListBox1[nI,6] // TRANSITO PARA A LOJA
SB2->B2_XTRANSI := iif (SB2->B2_XTRANSI<0,0,SB2->B2_XTRANSI) + aListBox1[nI,5] - aListBox1[nI,6] // TRANSITO PARA A LOJA
MsUnlock()
EndIf
Next nI
//EndIf
*/
End Transaction

If (!lDiverg) .And. lSaida
	u_LS_InfVol()
EndIf

Reclock("TRB",.F.)

If lSaida
	If lDiverg
		TRB->FOR_STATUS := "03"	//Separacao divergente
		TRB->FOR_DESCST := "Separacao divergente"
	Else
		TRB->FOR_STATUS := "02"	//Separacao Ok
		TRB->FOR_DESCST := "Separacao Ok"
		TRB->FOR_CARGA	 := Alltrim(TRB->FOR_NUMROM)+StrZero(TRB->FOR_VOL,3)
		
		// Libera pedido de venda
		LibPV()
	EndIf
	
Else //Recebimento
	If !lDiverg
		TRB->FOR_STATUS := "05"	//Separacao divergente
		TRB->FOR_DESCST := "Recebimento Ok"
	EndIf
EndIf


MsUnlock()
//Gravou TRB (temporaria) agora grava FOR definitiva
/*FOR->(DbSetOrder(1))
If FOR->(DbSeek( xFilial("FOR")+TRB->FOR_NUMROM ))
	
	RecLock("FOR",.F.)
	If lSaida
		If lDiverg
			FOR->FOR_STATUS := "03"	//Separacao divergente
		Else
			FOR->FOR_STATUS := "02"	//Separacao Ok
			FOR->FOR_CARGA	 := Alltrim(FOR->FOR_NUMROM)+StrZero(FOR->FOR_VOL,3)
		EndIf
		FOR->FOR_USER   := cUserName
		FOR->FOR_TOQUED := date()
		FOR->FOR_TOQUEU := cUserName
		FOR->FOR_TOQUEH := left(time(),2) + substr(time(),4,2)
		
	Else //Recebimento
		
		If !lDiverg
			FOR->FOR_STATUS := "05"	//
			FOR->FOR_DESCST := "Recebimento Ok"
			FOR->FOR_USER   := cUserName
			//Gera Pre- Nota
		Else
			Alert("Não foi possivel receber. Existe diferença e o usuario não é autorizado")
		EndIf
		
	EndIf
	
	
	
	Msunlock()
	
EndIf*/




//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tatiane de Oliveira vai acrescentar o fonte abaixo³
//³para atualizar o status dos itens do romaneio     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


PA7->(DbSetOrder(1))
If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ))
	
	RecLock("PA7",.F.)
	If lSaida
		If lDiverg
			PA7->PA7_STATUS := "03"	//Separacao divergente
		Else
			PA7->PA7_STATUS := "02"	//Separacao Ok
		EndIf
	Else //Recebimento
		
		If !lDiverg
			PA7->PA7_STATUS := "05"	//
		EndIf
		
	EndIf
	
	
	
	Msunlock()
	
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FIM DO COMPLEMENTO DA TATIANE³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ



oDlg:End()

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LibPV     ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de liberacao dos itens dos pedidos de venda por cada º±±
±±º          ³romaneio no momento da separacao                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPV()
///////////////////////

Local nX		:= 0
Local cPedido	:= Left(TRB->FOR_NUMROM,Len(TRB->FOR_NUMROM)-2)

SC6->( DbSetOrder(2) ) //C6_FILIAL + C6_PRODUTO + C6_NUM + C6_ITEM
SC9->( DbSetOrder(1) ) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

For nX := 1 to Len(aListBox1)
	
	If aListBox1[nX,1] == oOk
		
		If SC6->( DbSeek( xFilial("SC6")+aListBox1[nX,2]+cPedido ),.f. )
			
			Reclock("SC6",.F.)
			SC6->C6_OP 		:= "02"
			SC6->C6_QTDEMP := SC6->C6_QTDVEN
			Msunlock()
			
			If SC9->( DbSeek( xFilial("SC9") + cPedido + SC6->C6_ITEM + "01" + SC6->C6_PRODUTO,.f. ) )
				Reclock("SC9",.F.)
			Else
				Reclock("SC9",.T.)
			EndIf
			_nQuant := SC9->C9_QTDLIB
			
			SC9->C9_FILIAL 		:= xFilial("SC9")
			SC9->C9_PEDIDO		:= SC6->C6_NUM
			SC9->C9_ITEM		:= SC6->C6_ITEM
			SC9->C9_CLIENTE		:= SC6->C6_CLI
			SC9->C9_LOJA		:= SC6->C6_LOJA
			SC9->C9_PRODUTO		:= SC6->C6_PRODUTO
			SC9->C9_QTDLIB		:= SC6->C6_QTDVEN
			SC9->C9_DATALIB		:= dDatabase
			SC9->C9_SEQUEN		:= "01"
			SC9->C9_PRCVEN		:= SC6->C6_PRCVEN
			SC9->C9_LOCAL		:= SC6->C6_LOCAL
			SC9->C9_TPCARGA		:= "2"
			Msunlock()
			
			DbSelectArea("SB2")
			If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
				//	If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
				RecLock("SB2",.F.)
				
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Tatiane de Oliveira 11/02/2016                        ³
				//³Trocou o campo b2_reserva por B2_XRESERV              ³
				//³ o valor de pedido não faturado para a filial destino ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
								SB2->B2_RESERVA := SB2->B2_RESERVA - _nQuant + SC9->C9_QTDLIB // RESERVA
				//SB2->B2_XRESERV := SB2->B2_XRESERV - SC9->C9_QTDLIB // RESERVA DESTINO
				MsUnLock()
			EndIf
			
			//			If DbSeek(xFilial("SB2") + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NA ORIGEM
			If DbSeek(SC9->C9_LOJA + SC9->C9_PRODUTO + SC9->C9_LOCAL,.f.) // ATUALIZA NO DESTINO
				RecLock("SB2",.F.)
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Tatiane de Oliveira 05/02/16            ³
				//³Trocou o campo b2_salpedi por B2_XTRANSI³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				
				//				SB2->B2_SALPEDI := SB2->B2_SALPEDI - _nQuant + SC9->C9_QTDLIB // TRANSITO
				if SB2->B2_XTRANSI < 0
					SB2->B2_XTRANSI:=0
				ELSE
					SB2->B2_XTRANSI:=SB2->B2_XTRANSI
				endif
				SB2->B2_XTRANSI := SB2->B2_XTRANSI - _nQuant + SC9->C9_QTDLIB // TRANSITO
				MsUnLock()
			EndIf
			
			
		EndIf
		
	EndIf
	
Next nX

SC5->( DbSetOrder(1) )
If SC5->( DbSeek( xFilial("SC5")+cPedido) )
	
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	Msunlock()
	
EndIf


Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGetItem  ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria um vetor auxiliar com os produtos e quantidades para   º±±
±±º          ³validar se a quantidade contada esta coerente com o romaneioº±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItem()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA7")
PA7->(DbSetOrder(1)) //PA7_FILIAL+PA7_NUMROM+PA7_CODPRO
If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ) )
	
	While !PA7->(EOF()) .AND. PA7->(PA7_FILIAL+PA7_NUMROM) = TRB->(FOR_FILIAL+FOR_NUMROM)
		
		Aadd( aValid,{PA7->PA7_CODPRO,PA7->PA7_QUANT,PA7->PA7_QTDORI} )
		
		PA7->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGetVol   ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria um vetor auxiliar com os volumes do romaneio para      º±±
±±º          ³validar se o volume esta ou nao no romaneio.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetVol()
/////////////////////////

Local lRet := .T.

DbSelectArea("PA8")
PA8->(DbSetOrder(1)) //PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
If PA8->(DbSeek( xFilial("PA8")+TRB->FOR_NUMROM ) )
	
	While !PA8->(EOF()) .AND. PA8->(PA8_FILIAL+PA8_NUMROM) = TRB->(FOR_FILIAL+FOR_NUMROM)
		
		Aadd( aVolumes,{PA8->PA8_CODCOL} )
		
		PA8->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet



/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGetItem2 ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria um vetor auxiliar com os volumes do romaneio para      º±±
±±º          ³validar se o volume esta ou nao no romaneio.                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItm2()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA8")
PA8->(DbSetOrder(1)) //PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
If PA8->(DbSeek( xFilial("PA8")+TRB->FOR_NUMROM ) )
	
	While !PA8->(EOF()) .AND. PA8->(PA8_FILIAL+PA8_NUMROM) = TRB->(FOR_FILIAL+FOR_NUMROM)
		
		Aadd( aVolumes,{PA8->PA8_CODCOL} )
		
		PA8->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LS03REFRESºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza o ListBox da MainWindow                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS03Refres()
////////////////////////////

Local nPos     	:= 0
Local lRet     	:= .T.
Local aArea    	:= GetArea()
Local aAreaSB1 	:= SB1->( GetArea() )
_cAviso 		:= ''
_oAviso:Refresh()
_lToque 		:= .t.

If lRet .and. !empty(cGetProd)
	//--Consiste o Produto informado - Prioriza o Codigo de Barras:
	SB1->( DbSetOrder(5) ) //--B1_FILIAL+B1_CODBAR
	If !SB1->( DbSeek( xFilial('SB1') + PadR( cGetProd, Len( SB1->B1_CODBAR ) ) ) )
		SB1->( DbSetOrder(1) ) //--B1_FILIAL+B1_COD
		If !SB1->( DbSeek( xFilial('SB1') + left( cGetProd, Len( SB1->B1_COD ) ) ) )
			u_ls_beep(3)
			_cAviso := "Produto " +Alltrim(cGetProd) + " não cadastrado. " + _cEnter + _cUltimo
			_lToque := .f.
			lRet    := .f.
		EndIf
	EndIf
	
	If lRet
		//--Verifica a expressao digitada X Codigo de barras
		nPos := AScan( aListBox1, {|x| PadR( x[3], Len(SB1->B1_CODBAR) ) == PadR( cGetProd, Len(SB1->B1_CODBAR) )} )
		If nPos == 0
			//--Verifica a expressao digitada X Codigo do Produto
			nPos := AScan( aListBox1, {|x| PadR( x[2], Len(SB1->B1_COD) ) == PadR( cGetProd, Len(SB1->B1_COD) )} )
			If nPos == 0
				u_ls_beep(4)
				_cAviso := "O produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + " não faz parte do romaneio. " + _cUltimo
				_lToque := .f.
				lRet    := .f.
			ElseIf aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)) > aListBox1[nPos,6]
				u_ls_beep(5)
				_cAviso := "Quantidade tocada maior que romaneio. Produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + _cEnter + _cUltimo
				_lToque := .f.
				lRet    := .f.
			Else
				u_ls_beep(6)
				_cAviso  := 'OK - ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC)
				_cUltimo := 'Último toque: ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC) + ' (' + alltrim(str(aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)))) + ')'
			EndIf
		ElseIf aListBox1[nPos,5]  + iif(empty(nQtd),1,val(nQtd)) > aListBox1[nPos,6]
			u_ls_beep(5)
			_cAviso := "Quantidade tocada maior que romaneio. Produto " +Alltrim(cGetProd) + ' ' + alltrim(SB1->B1_DESC) + _cEnter + _cUltimo
			_lToque := .f.
			lRet    := .f.
		Else
			u_ls_beep(6)
			_cAviso  := 'OK - ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC)
			_cUltimo := 'Último toque: ' + Alltrim(cGetProd) + ' - ' + alltrim(SB1->B1_DESC) + ' (' + alltrim(str(aListBox1[nPos,5] + iif(empty(nQtd),1,val(nQtd)))) + ')'
		EndIf
		
		If lRet .and. nPos > 0
			nQtdProd := aListBox1[nPos,5]
			
			If !Empty(nQtd)
				nQtdProd := Val(nQtd)
			Else
				nQtdProd++
			EndIf
			
			aListBox1[nPos,5] := nQtdProd
			
			If aListBox1[nPos,5] < aListBox1[nPos,6]
				aListBox1[nPos,1] := oDiverg
			EndIf
			
			If aListBox1[nPos,5] == aListBox1[nPos,6]
				aListBox1[nPos,1] := oOk
			EndIf
			
			If aListBox1[nPos,5] > aListBox1[nPos,6]
				aListBox1[nPos,1] := oDiverg
			EndIf
		EndIf
	EndIf
	
	cGetProd  := Space( Len( SB1->B1_CODBAR) )
	nQtd      := Space(5)
	
	//--Atualiza os objetos da tela
	_oAviso:Refresh()
	oGetProd:SetFocus()
	If !lRet
		oListBox1:SetFocus()
	EndIf
	oListBox1:Refresh()
EndIf

//--Restaura o ambiente
RestArea( aArea )
RestArea( aAreaSB1 )
Return( lRet )


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VOLREFRES ºAutor  ³ Fabio Jadao Caires º Data ³  18/06/2007 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza o ListBox da MainWindow                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VolRefres()
///////////////////////////

Local nPosVol 	:= 0 				// Posicao do vetor de contagem

nPosVol := aScan(aListBox2,{|x| x[2] == cGetVol })

If Empty(cGetVol)
	Alert("Informe o Volume!")
	cGetVol := CRIAVAR("PA8_CODCOL")
	oGetVol:SetFocus()
	Return .F.
EndIf

If nPosVol == 0
	Alert("O volume "+Alltrim(cGetVol)+" não pertence ao romaneio "+Alltrim(TRB->FOR_NUMROM)+" !!!")
	cGetVol :=CRIAVAR("PA8_CODCOL")
	oGetVol:SetFocus()
	Return .F.
EndIf

If nPosVol > 0
	aListBox2[nPosVol,1] := oVolOk
	aListBox2[nPosVol,3] := "Volume Ok"
EndIf

oListBox2:Refresh()

cGetVol := CRIAVAR("PA8_CODCOL")
oGetVol:Refresh()
oGetVol:SetFocus()

Return .T.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TrnpRefres()
////////////////////////////

//Local nPosVol    := 0

_lRet := (SA4->(DbSeek(xFilial('SA4') + cGetTrans,.f.)))

If Empty(cGetTrans)
	Alert("Favor informar o transporte!")
	Return .F.
EndIf
/*
If nPosVol == 0
Alert("Favor informar o transporte!")
Return .F.
EndIf
*/
If !_lRet
	cGetTrans := '      '
	cGetNTran := 'TRANSPORTADORA INVÁLIDA'
	oGetTrb:SetFocus()
Else
	cGetNTran := SA4->A4_NOME
EndIf

oGetTrb:Refresh()
oGetTra:Refresh()

Return(_lRet)


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VldDlg3()
///////////////////////////

If Empty(nGetQtd1)
	Alert("Informe a quantidade do Volume 1!")
	oGetQtd1:SetFocus()
	Return .F.
EndIf

SC5->(DbSetOrder(1))
If SC5->(DbSeek(right(TRB->FOR_NUMROM,2) + left(TRB->FOR_NUMROM,6),.f.))
	_aAlias := GetArea()
	RecLock('SC5',.f.)
	SC5->C5_VOLUME1 := nGetQtd1
	SC5->C5_ESPECI1 := iif(nGetQtd1 > 1,'VOLUMES','VOLUME')
	SC5->C5_PESOL   := nGetPesoL
	SC5->C5_PBRUTO  := nGetPesoB
	SC5->C5_TRANSP  := cGetTrans
	MsUnLock()
	RestArea(_aAlias)
EndIf

Return .T.

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FORLeg    ³Autor  ³ Fabio Jadao Caires    ³ Data ³15.06.2007 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Demonstra a legenda das cores da mbrowse                     ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina monta uma dialog com a descricao das cores da    ³±±
±±³          ³Mbrowse.                                                     ³±±
±±³          ³                                                             ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Laselva Bookstore                                           ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function perdLeg()
/////////////////////////

Local aCores := {}

aAdd(aCores, { "BR_VERMELHO" 	,	"Ainda nao separado"		}) //Ainda nao separado
aAdd(aCores, { "BR_BRANCO"   	,	"Separacao Ok"				}) //Separacao Ok
aAdd(aCores, { "BR_AMARELO"  	,	"Separacao divergente"	}) //Separacao divergente
aAdd(aCores, { "BR_AZUL"     	,	"Expedicao Ok"				}) //Expedicao Ok
aAdd(aCores, { "BR_VERDE"		,	"Recebimento Ok"			}) //Recebimento Ok
aAdd(aCores, { "BR_PRETO" 		,	"Encerrado"					}) //Recebimento Divergente


BrwLegenda("Romaneios","Legendas",aCores)

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa   ³   C()   ³ Autores ³ Norbert/Ernani/Mansano ³ Data ³10/05/2005³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao  ³ Funcao responsavel por manter o Layout independente da       ³±±
±±³           ³ resolucao horizontal do Monitor do Usuario.                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function C(nTam)
///////////////////////

Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor

If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)
	nTam *= 0.8
ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600
	nTam *= 1
Else	// Resolucao 1024x768 e acima
	nTam *= 1.28
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para tema "Flat"³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ GravaNFS ºAutor  ³ Fabio Jadao Caires º Data ³  29/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Gravacao da nota fiscal de venda a partir dos registros do º±±
±±º          | SC9 - Itens liberados dos pedidos de venda.                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva Bookstore                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GravaNFS()
//////////////////////////

Local aAreaAnt	 	:= GetArea()
Local aAreaSC5	 	:= SC5->( GetArea() )
Local aAreaSC6	 	:= SC6->( GetArea() )
Local aAreaSC9	 	:= SC9->( GetArea() )
Local aAreaSE4	 	:= SE4->( GetArea() )
Local aAreaSB1	 	:= SB1->( GetArea() )
Local aAreaSB2	 	:= SB2->( GetArea() )
Local aAreaSF4	 	:= SF4->( GetArea() )

Local aPvlNfs	 	:= {}
//Local _cSeek      := ''
Local _nPrcVen    := 0
Local _nRegDAK   	:= 0
Local lMostraCtb 	:= .F.
Local lAglutCtb  	:= .F.
Local lCtbOnLine 	:= .F.
Local lCtbCusto  	:= .F.
Local lReajuste  	:= .F.
Local lAtuSA7    	:= .F.
Local lECF       	:= .F.
Local nCalAcrs   	:= 1
Local nArredPrcLis 	:= 1
Local cRot       	:= ProcName()
Local cPedido := Left(TRB->FOR_NUMROM,Len(TRB->FOR_NUMROM)-2)

// PREPARANDO A NOTA FISCAL
MV_PAR01 := 2           // Mostra Lan‡.Contab ?  Sim/Nao
MV_PAR02 := 2           // Aglut. Lan‡amentos ?  Sim/Nao
MV_PAR03 := 2           // Lan‡.Contab.On-Line?  Sim/Nao
MV_PAR04 := 2           // Contb.Custo On-Line?  Sim/Nao
MV_PAR05 := 1           // Reaj. na mesma N.F.?  Sim/Nao
MV_PAR06 := 0           // Taxa deflacao ICMS ?  Numerico
MV_PAR07 := 3           // Metodo calc.acr.fin?  Taxa defl/Dif.lista/% Acrs.ped
MV_PAR08 := 3           // Arred.prc unit vist?  Sempre/Nunca/Consumid.final
MV_PAR09 := Space( 04 ) // Agreg. liberac. de ?  Caracter
MV_PAR10 := Space( 04 ) // Agreg. liberac. ate?  Caracter
MV_PAR11 := 2           // Aglut.Ped. Iguais  ?  Sim/Nao
MV_PAR12 := 0           // Valor Minimo p/fatu?
MV_PAR13 := Space( 06 ) // Transportadora de  ?
MV_PAR14 := 'ZZZZZZ'    // Transportadora ate ?
MV_PAR15 := 2           // Atualiza Cli.X Prod?  Sim/Nao
MV_PAR16 := 1           // Emitir             ?  Nota/Cupom Fiscal

lMostraCtb  := MV_PAR01 == 1
lAglutCtb   := MV_PAR02 == 1
lCtbOnLine  := MV_PAR03 == 1
lCtbCusto   := MV_PAR04 == 1
lReajuste   := MV_PAR05 == 1

LAtuSA7lECF := .F.
lFaturado   := .F.

// Verifica se o pedido ja foi faturado
IF lFaturado
	Aviso( cRot, 'Pedido ja faturado anteriormente !!!', {'&Abandonar'} )
	Return( .F. )
Endif

// Gera nota.
SC5->( dbSetOrder( 1 ) ) //C5_FILIAL + C5_NUM
If SC5->( MsSeek( xFilial( 'SC5' ) + cPedido, .F. ) )
	
	SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
	
	SC9->( DbSetOrder(1) ) //C9_FILIAL + C9_PEDIDO + C9_ITEM + C9_SEQUEN + C9_PRODUTO
	
	If SC9->( DbSeek( xFilial("SC9")+cPedido ) )
		
		Do While !SC9->(EOF()) .AND. SC9->C9_PEDIDO == cPedido .and. SC9->C9_FILIAL == xFilial('SC9')
			
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				
				SE4->( dbSetOrder( 1 ) )
				SE4->( MsSeek( xFilial( 'SE4' ) + SC5->C5_CONDPAG, .F. ) )
				
				// Posiciona no produto
				SB1->( dbSetOrder( 1 ) )
				SB1->( MsSeek( xFilial( 'SB1' ) + SC6->C6_PRODUTO, .F. ) )
				
				// Posiciona no saldo em estoque
				SB2->( dbSetOrder( 1 ) )
				SB2->( MsSeek( xFilial( 'SB2' ) + SC6->C6_PRODUTO + SC6->C6_LOCAL, .F. ) )
				
				// Posiciona no TES
				cTes := SC6->C6_TES
				SF4->( dbSetOrder( 1 ) )
				SF4->( MsSeek( xFilial( 'SF4' ) + cTes, .F. ) )
				
				// Converte o valor unitario em Reais quando pedido em outra moeda
				_nPrcVen := SC9->C9_PRCVEN
				If ( SC5->C5_MOEDA <> 1 )
					dbSelectArea( 'SM2' )
					dbSetOrder( 1 )
					If dbSeek( DTOS( dDataBase ) )
						_nPrcVen := SC9->C9_PRCVEN * SM2->M2_MOEDA2
					Else
						_nPrcVen := xMoeda( _nPrcVen, SC5->C5_MOEDA, 1, dDataBase )
					EndIf
					
				EndIf
				
				// Monta array para gerar a nota fiscal
				Aadd( aPvlNfs, { SC9->C9_PEDIDO, ;
				SC9->C9_ITEM, ;
				SC9->C9_SEQUEN, ;
				SC9->C9_QTDLIB, ;
				_nPrcVen, ;
				SC9->C9_PRODUTO, ;
				.F., ;
				SC9->( RecNo() ), ;
				SC5->( RecNo() ), ;
				SC6->( RecNo() ), ;
				SE4->( RecNo() ), ;
				SB1->( RecNo() ), ;
				SB2->( RecNo() ), ;
				SF4->( RecNo() ), ;
				SC6->C6_LOCAL, ;
				_nRegDAK, ;
				SC9->C9_QTDLIB2} )
				
			Else
				
				MsgBox('Pedido de vendas não liberado','ATENÇÃO!!!','ALERT')
				aPvlNfs := {}
				Exit
				
			EndIf
			
			SC6->( DbSetOrder(1) ) //C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
			If SC6->( DbSeek( xFilial("SC6") + SC9->C9_PEDIDO + SC9->C9_ITEM + SC9->C9_PRODUTO ) )
				While !SC6->( EOF() ) .AND. SC6->C6_NUM == SC9->C9_PEDIDO  .and. SC6->C6_ITEM ==SC9->C9_ITEM  .AND. SC6->C6_PRODUTO==SC9->C9_PRODUTO
					_cQuery := "UPDATE " + RetSqlName('SB2')
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Tatiane de Oliveira 05/02/16            ³
					//³Trocou o campo b2_salpedi por B2_XTRANSI³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
					
					_cQuery += _cEnter + " SET B2_XTRANSI =B2_XTRANSI +  "+CVALTOCHAR(SC6->C6_QTDVEN)+ ", "
					_cQuery += _cEnter + " B2_XRESERV =B2_XRESERV  - 	"+CVALTOCHAR(SC6->C6_QTDVEN)+ "  "
					_cQuery += _cEnter + " FROM " + RetSqlName('SC6') + " SC6 (NOLOCK)"
					
					_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SF4') + " SF4 (NOLOCK)"
					_cQuery += _cEnter + " ON SF4.D_E_L_E_T_ 			= ''"
					_cQuery += _cEnter + " AND F4_CODIGO 				= '"+SC6->C6_TES+"'"
					_cQuery += _cEnter + " AND F4_ESTOQUE 				= 'S'"
					
					_cQuery += _cEnter + " WHERE SC6.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND C6_FILIAL 				= '" + SC5->C5_FILIAL + "'"
					_cQuery += _cEnter + " AND C6_NUM 					= '" + SC5->C5_NUM + "'"
					_cQuery += _cEnter + " AND C6_CLI 					< '000009'"
					_cQuery += _cEnter + " AND SB2010.D_E_L_E_T_ 		= ''"
					_cQuery += _cEnter + " AND B2_FILIAL 				= '"+SC6->C6_LOJA+"'"
					_cQuery += _cEnter + " AND B2_COD 					= '"+SC6->C6_PRODUTO+"'"
					_cQuery += _cEnter + " AND B2_LOCAL 				='"+SC6->C6_LOCAL+"'"
					nValSQL := TcSqlExec(_cQuery)
					
					if nValSQL < 0
						alert("Erro na execução do SQL - M410STTS - terceira")
					endif
					SC6->( DbSkip() )
				EndDo
			ENDIF
			
			
			SC9->( DbSkip() )
			
		EndDo
		
	Else
		
		MsgBox('Pedido de vendas não liberado','ATENÇÃO!!!','ALERT')
		
	EndIf
	
Else
	
	MsgBox('Pedido de vendas não encontrado','ATENÇÃO!!!','ALERT')
	
EndIf

If !Empty( aPvlNfs )
	
	LimpaMoeda()
	
	//////////////////////////////////////////////////////////////////////
	/////	ponto de entrada para verificação da numeração da nota fiscal
	//////////////////////////////////////////////////////////////////////
	// ATUALIZA A TABELA DE NOTAS FISCAIS PARA CNPJs QUE TEM MAIS DE UMA FILIAL
	
	DbSelectArea('SM0')
	_cCnpj := SM0->M0_CGC
	Set Filter to  SM0->M0_CGC == _cCnpj .and. SM0->M0_CODIGO == cEmpAnt
	_cFiliais := ''
	_cQueryF  := ''
	DbGotop()
	Do While _cCnpj == SM0->M0_CGC .AND. !eof()
		_cQueryF += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(NFE_ID)),9))+1)),9) NOTA"
		_cQueryF += _cEnter + "FROM SPED050 (NOLOCK)"
		_cQueryF += _cEnter + "WHERE ID_ENT = dbo.FN_GETIDSPED" +" ('" + SM0->M0_CODFIL + "')"
		_cQueryF += _cEnter + "AND LEFT(NFE_ID,1) = '" + GetMv('FS_LASSER') +"'"
		_cQueryF += _cEnter + "AND D_E_L_E_T_ = ''"
		_cQueryF += _cEnter + "AND LEN(RTRIM(NFE_ID))>9"
		_cQueryF += _cEnter + "AND DATE_NFE > '201303'"
		If SM0->M0_CODFIL == 'GE'
			_cQueryF += _cEnter + " AND NFE_ID < '8  000045000' "
		EndIf
		_cQueryF += _cEnter + "UNION"
		_cFiliais += SM0->M0_CODFIL + ','
		DbSkip()
	EndDo
	Set Filter To
	DbSeek(cEmpAnt+cFilAnt)
	
	_cFiliais := FormatIn(left(_cFiliais,len(_cFiliais)-1),',')
	
	_cQuery2 := _cEnter + "SELECT ISNULL(MAX(NOTA),'') NOTA"
	_cQuery2 += _cEnter + "FROM"
	_cQuery2 += _cEnter + "("
	_cQuery2 += _cQueryF
	_cQuery2 += _cEnter + "SELECT RIGHT(RTRIM('000000000' + CONVERT(CHAR,CONVERT(INT,RIGHT(RTRIM(MAX(F2_DOC)),9))+1)),9) NOTA"
	_cQuery2 += _cEnter + "FROM SF2010"
	_cQuery2 += _cEnter + "WHERE F2_FILIAL IN " + _cfiliais
	_cQuery2 += _cEnter + "AND F2_SERIE = '" + GetMv('FS_LASSER') + "'"
	_cQuery2 += _cEnter + "AND F2_EMISSAO > '201303'"
	If SM0->M0_CODFIL == 'GE'
		_cQuery2 += _cEnter + " AND F2_DOC < '000045000'"
	EndIf
	_cQuery2 += _cEnter + "AND F2_PDV = ''"
	_cQuery2 += _cEnter + "AND D_E_L_E_T_ = ''"
	_cQuery2 += _cEnter + ") A"
	
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery2),"_NF", .T., .T.)
	_cNota := _NF->NOTA
	DbCloseArea()
	_cNota := iif(empty(_cNota),'000000001',_cNota)
	
	_cQuery := "UPDATE " + RetSqlName('SX5')
	_cQuery += _cEnter   + "SET X5_DESCRI = '" + _cNota + "', X5_DESCSPA ='" + _cNota + "', X5_DESCENG ='" + _cNota + "'"
	_cQuery += _cEnter   + "WHERE X5_TABELA = '01'"
	_cQuery += _cEnter   + "AND X5_CHAVE = '" + GetMv('FS_LASSER') + "'"
	_cQuery += _cEnter   + "AND D_E_L_E_T_ = ''"
	_cQuery += _cEnter   + "AND X5_FILIAL IN " + _cFiliais
	
	TcSqlExec(_cQuery)
	
	_aAlias := GetArea()
	
	_cSerie     := left(alltrim(_cSerie) + '    ',3)
	_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			Do While !RecLock('SX5',.f.)
			EndDo
		EndIf
	Next
	cNumero := _cNumNFX5F
	
	_cFiltro   := "F1_FILIAL == '" + cFilAnt + "' .and. F1_SERIE == '" + _cSerie + "' .and. F1_FORMUL == 'S'"
	DbSelectArea('SF1')
	IndRegua("SF1",CriaTrab(,.f.),SF1->(IndexKey(1)),,,"Selecionando Registros...")
	Do While SF1->(DbSeek(xFilial('SF1') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	RetIndex()
	
	SF2->(DbSetOrder(1))
	Do While SF2->(DbSeek(xFilial('SF2') + padr(_cNumNFX5F,9,' ') + _cSerie,.f.))
		_cNumNFX5F := Soma1(_cNumNFX5F)
	EndDo
	
	DbSelectArea('SX5')
	_xFilial := strtran(strtran(strtran(strtran(_cFiliais,"'",""),"(",""),")",""),",","")
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			MsUnLock()
		EndIf
	Next
	For _nI := 1 to len(_xFilial) step 2
		If DbSeek(substr(_xFilial,_nI,2) + '01' + _cSerie,.f.)
			RecLock('SX5',.f.)
			SX5->X5_DESCRI  := _cNumNFX5F
			SX5->X5_DESCSPA := _cNumNFX5F
			SX5->X5_DESCENG := _cNumNFX5F
			MsUnLock()
		EndIf
	Next
	
	RestArea(_aAlias)
	//////////////////////////////////////////////////////////////////////
	_cNota := MaPvlNfs(aPvlNfs,;
	_cSerie,;
	lMostraCtb,;
	lAglutCtb,;
	lCtbOnLine,;
	lCtbCusto,;
	lReajuste,;
	nCalAcrs,;
	nArredPrcLis,;
	lAtuSA7,;
	lECF,;
	'',;
	,;
	NIL )
	
	_cNota := PadR(_cNota,9,' ')
	
	//IIF( TRAB->UA5_VLRDES >0, NIL, { || CompleNFS() } ) )
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Destrava o controle de numeracao                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//			SX5->( MsRUnLock() )
	//	EndIf
	
EndIf
//Atualiza a tabela


// Retorna as areas originais
RestArea( aAreaSF4 )
RestArea( aAreaSB2 )
RestArea( aAreaSB1 )
RestArea( aAreaSE4 )
RestArea( aAreaSC9 )
RestArea( aAreaSC6 )
RestArea( aAreaSC5 )
RestArea( aAreaAnt )




Return( _cNota )



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºRotina    ³ Encerra  ºAutor  ³ Deosdete P. Silva  º Data ³  05/07/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Encerramento da distribuição, classificando a pre-nota e   º±±
±±º          | integrando estoque e financeiro                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Laselva Bookstore                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function GER_PED()
//////////////////////////

Local cFornecedor := ""
Local cLoja       := ""
Local aAreaSC6    := SC6->( GetArea() )
Local _ITEMori	  :=""
u_LS_Pesquisa(.f.)

Private aCab        :=  {}
Private aItens      :=  {}
Private aLinha      := 	{}
Private lMsErroAuto := .F.

If TRB->(EOF())
	Alert("Arquivo Vazio")
	Return
EndIf

If TRB->FOR_FILDES != cFilAnt
	Alert("O encerramento pode ser feito apenas na filial de destino")
	Return
EndIf

_cCNPJOrigem := SM0->M0_CGC
_cEstOrigem  := SM0->M0_ESTENT

SM0->(dbSetOrder(1))
SM0->( dbSeek(cEmpAnt + TRB->FOR_FILORI))

//cFornecedor := GetAdvFVal("SA2","A2_COD",xFilial("SA2")+SM0->M0_CGC,3)

_cQuery := "SELECT A2_COD"
_cQuery += " FROM " + RetSqlName('SA2') + " (NOLOCK)"
_cQuery += " WHERE A2_COD < '000009'"
_cQuery += " AND A2_CGC = '"  + SM0->M0_CGC + "'"
_cQuery += " AND A2_MSBLQL = '2'"
DbUseArea( .T., "TOPCONN", TcGenQry(,,_cQuery),"CNPJ", .T., .T.)
cFornecedor := CNPJ->A2_COD
DbCloseArea()

cLoja		:= SM0->M0_CODFIL
cFornec     := SM0->M0_CGC
cEstado 	:= SM0->M0_ESTENT

If Empty(cFornecedor) .or. Empty(cLoja)
	Alert("A filial " + SM0->M0_FILIAL+ " não esta cadastrada como fornecedor")
	Return
EndIf

//Verifica status atual
If TRB->FOR_STATUS == "05"  //Recebido
	If SF1->(DbSeek(xFilial('SF1') + TRB->FOR_NFS + TRB->FOR_SERIE + cFornecedor + cLoja,.F.))
		RecLock('TRB',.f.)
		TRB->FOR_NFE    := TRB->FOR_NFS
		TRB->FOR_STATUS := '06'
		TRB->FOR_DESCST := 'ENCERRADO'
		MsUnLock()
		
/*		FOR->(DbSetOrder(1))
		If FOR->(DbSeek( xFilial("FOR")+TRB->FOR_NUMROM ))
			RecLock("FOR",.F.)
			FOR->FOR_STATUS := "06"	//Encerrado
			FOR->FOR_NFE    := TRB->FOR_NFS
			Msunlock()
		EndIf
  */		
		PA7->(DbSetOrder(1))
		If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ))
			RecLock("PA7",.F.)
			PA7->PA7_STATUS := "06"	//Encerrado
			Msunlock()
		EndIf
		
		Alert("Romaneio encerrado. Nota fiscal de entrada gerada ")
		Return(.t.)
	EndIf
	
ElseIf TRB->FOR_STATUS == "06"  //Encerrado
	
	If SF1->(DbSeek(xFilial('SF1') + TRB->FOR_NFS + TRB->FOR_SERIE + cFornecedor + cLoja,.F.))
		RecLock('TRB',.f.)
		TRB->FOR_NFE    := TRB->FOR_NFS
		TRB->FOR_STATUS := '06'
		TRB->FOR_DESCST := 'Encerrado'
		MsUnLock()
		
/*		FOR->(DbSetOrder(1))
		If FOR->(DbSeek( xFilial("FOR")+TRB->FOR_NUMROM ))
			RecLock("FOR",.F.)
			FOR->FOR_STATUS := "06"	//Encerrado
			FOR->FOR_NFE    := TRB->FOR_NFS
			Msunlock()
		EndIf
 */		
		PA7->(DbSetOrder(1))
		If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM ))
			RecLock("PA7",.F.)
			PA7->PA7_STATUS := "06"	//Encerrado
			Msunlock()
		EndIf
		
		
		Alert("Romaneio encerrado. Nota fiscal de entrada gerada ")
	Else
		Alert("Este romaneio já foi encerrado.")
	EndIf
	Return(.T.)
EndIf

If TRB->FOR_STATUS <> "05"  //Recebimento Ok
	Alert("Este romaneio ainda não foi recebido. Não pode ser encerrado.")
	Return(.T.)
EndIf

SF2->(DbSetOrder(1))
SF2->(DbGoTop())
If !SF2->(DbSeek(TRB->FOR_FILORI + TRB->FOR_NFS + TRB->FOR_SERIE))
	Alert("Nota fiscal " + TRB->FOR_NFS + " não encontrada na filial " + TRB->FOR_FILORI)
	Return
EndIf

// *******************************************

If AllTrim(SM0->M0_CODFIL) $ "01/55"
	cTipoEmp := "M"
ElseIf Substr(SM0->M0_CGC,1,8) $ GetMv("MV_LSVCNPJ").or. left(SM0->M0_CGC,8) == left(cFornec,8)
	cTipoEmp := "F"
Else
	cTipoEmp := "C"
EndIf

//SM0->( dbSeek(cEmpAnt + cFilAnt))

// *******************************************

_cPedCom := ''

If cFilAnt $ '01/55' .and. cLoja == 'C0'
	_cPedCom := Posicione('SC5',1,TRB->FOR_FILORI + left(TRB->FOR_NUMROM,6),'C5_COTACAO')
EndIf

aAdd(aCab,{"F1_TIPO",			SF2->F2_TIPO		 		, 	Nil		})
aAdd(aCab,{"F1_FORMUL",      	"N" 						, 	Nil		})
aAdd(aCab,{"F1_DOC",         	strzero(val(SF2->F2_DOC),9)	, 	Nil		})
aAdd(aCab,{"F1_SERIE",      	SF2->F2_SERIE				, 	Nil		})
aAdd(aCab,{"F1_EMISSAO",     	SF2->F2_EMISSAO				, 	Nil		})
aAdd(aCab,{"F1_FORNECE",     	cFornecedor					, 	Nil		})
aAdd(aCab,{"F1_LOJA",        	cLoja						, 	Nil		})
aAdd(aCab,{"F1_ESPECIE",     	SF2->F2_ESPECIE				, 	Nil		})
aAdd(aCab,{"F1_COND",			"001"						, 	Nil		})
aAdd(aCab,{"F1_CHVNFE",	SF2->F2_CHVNFE		, Nil })
//aAdd(aCab,{"F1_DESCONT",		SF2->F2_DESCONT				, 	Nil		})
//Localizar item da NF
//Indice 3 -D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
SD2->(DbSetOrder(3))
If !SD2->(DbSeek(TRB->FOR_FILORI+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	Alert("Nota fiscal " + F2_DOC + " não tem item ")
	Return
EndIf
_lNaoTemTes := .f.
_cNaoTemTes := ''

_aBloq := {}
Do While !SD2->(Eof()) .And. (SD2->D2_FILIAL   	== TRB->FOR_FILORI;
	.And. SD2->D2_DOC   	== SF2->F2_DOC;
	.And. SD2->D2_SERIE     == SF2->F2_SERIE;
	.And. SD2->D2_CLIENTE   == SF2->F2_CLIENTE;
	.And. SD2->D2_LOJA      == SF2->F2_LOJA)
	
	nRecno := SD2->( Recno() )
	If Posicione('SB1',1,xFilial('SB1') + SD2->D2_COD,'B1_MSBLQL') == '1'
		aAdd(_aBloq,SB1->B1_COD)
		RecLock('SB1',.f.)
		SB1->B1_MSBLQL := '2'
		MsUnLock()
		DbSelectArea('SD2')
	EndIf
	
	// *********************************************************************   //1000302
	If left(cFornec,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(cFornec,8)
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TE')
	ElseIf left(cFornec,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp == "M"
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TEC')
	Else
		_cTes := Posicione('SBZ',1,xFilial('SBZ') + SD2->D2_COD,'BZ_TE_FORN')
	EndIf
	
	If empty(_cTes)
		If left(cFornec,8) $ GetMv("MV_LSVCNPJ") .or. left(SM0->M0_CGC,8) == left(cFornec,8)
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_TE')
		ElseIf left(cFornec,8) $ GetMv("MV_CNPJLSV") .AND. cTipoEmp == "M"
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_TEC')
		Else
			_cTes := Posicione('SZQ',1,xFilial('SZQ') + SB1->B1_GRUPO+cTipoEmp,'ZQ_FORN')
		EndIf
	EndIf
	// *************************************************************************
	
	//	If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
	aAdd(aLinha,{"D1_ITEM",		strzero(len(aItens)+1,4), 	Nil	})
	//	else
	//		aAdd(aLinha,{"D1_ITEM",		SD2->D2_ITEM, 	Nil	})
	//	endif
	
	aAdd(aLinha,{"D1_COD", 		SD2->D2_COD, 	Nil	})
	aAdd(aLinha,{"D1_UM", 		SD2->D2_UM, 	Nil	})
	
	
	aAdd(aLinha,{"D1_QUANT",	SD2->D2_QUANT, 	Nil	})
	
	//If SD2->D2_DESCON + SD2->D2_DESC > 0 .and. SD2->D2_PRUNIT == SD2->D2_PRCVEN
	_nPrUnit := ROUND((SD2->D2_DESCON + SD2->D2_TOTAL) / SD2->D2_QUANT,2)
	_nDescont := round(SD2->D2_DESCON * 100 / (SD2->D2_DESCON + SD2->D2_TOTAL),2)
	aAdd(aLinha,{"D1_VUNIT",	_nPrUnit,	Nil	})
	aAdd(aLinha,{"D1_TOTAL",	SD2->D2_QUANT * _nPrUnit, 	Nil	})
	aAdd(aLinha,{"D1_DESC",		round(SD2->D2_DESCON * 100 / (SD2->D2_DESCON + SD2->D2_TOTAL),0), 	Nil	})
	aAdd(aLinha,{"D1_VALDESC",	SD2->D2_DESCON,	Nil	})
	/*
	Else
	aAdd(aLinha,{"D1_VUNIT",	SD2->D2_PRUNIT,	Nil	})
	aAdd(aLinha,{"D1_TOTAL",	SD2->D2_QUANT * SD2->D2_PRUNIT, 	Nil	})
	aAdd(aLinha,{"D1_DESC",		SD2->D2_DESC, 	Nil	})
	EndIf
	*/
	If empty(_cTes)
		_lNaoTemTes := .t.
		_cNaoTemTes +=  'Item: ' + strzero(len(aItens)+1,4) + '  Produto: ' + SD2->D2_COD + _cEnter
	EndIf
	
	
	If !(xFilial('SF1') $ '01/55')
		aAdd(aLinha,{"D1_TES",   	_cTes		,  	Nil	})
	EndIf
	
	
	aAdd(aLinha,{"D1_LOCAL",	SD2->D2_LOCAL	, 	Nil	})
	aAdd(aLinha,{"D1_PESO",		SD2->D2_PESO	, 	Nil	})
	aAdd(aLinha,{"D1_TP",		SD2->D2_TP		, 	Nil	})
	aAdd(aLinha,{"D1_TIPO_NF",	" "				,	Nil	})
	
	
	If !empty(SD2->D2_NFORI)
		
		DbSelectArea("SA1")
		SA1->( DbSetOrder(10) )  						// SA1->( DbSetOrder(9) ) - ALTERADO EM 26/05/15 - ILIDIO
		SA1->( DbSeek(SM0->M0_CGC+SM0->M0_CODFIL) )
		
		aAdd(aLinha,{"D1_NFORI",	SD2->D2_NFORI,	 			Nil	})
		aAdd(aLinha,{"D1_SERIORI",	SD2->D2_SERIORI, 			Nil	})
		_ITEMori:=SD2->D2_ITEMORI
		_cIdentB6 := Posicione("SD2",3,SF2->F2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI+SA1->A1_COD+SA1->A1_LOJA+SD2->D2_COD+RIGHT(_ITEMori,2),"D2_IDENTB6")
		
		If !empty(_cIdentB6)
			aAdd(aLinha,{"D1_IDENTB6",	_cIdentB6, Nil	})
			aAdd(aLinha,{"D1_ITEMORI",	RIGHT(_ITEMori,2), 			Nil	})
		else
			_cIdentB6 := Posicione("SD2",3,SF2->F2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI+SA1->A1_COD+SA1->A1_LOJA+SD2->D2_COD+_ITEMori,"D2_IDENTB6")
			If !empty(_cIdentB6)
				aAdd(aLinha,{"D1_IDENTB6",	_cIdentB6, Nil	}) 
				aAdd(aLinha,{"D1_ITEMORI",	_ITEMori, 			Nil	})
			ELSE   
			if SF2->F2_TIPO=='D'
			aAdd(aLinha,{"D1_ITEMORI",	RIGHT(_ITEMori,2), 			Nil	}) 
			else
			
			aAdd(aLinha,{"D1_ITEMORI",	_ITEMori, 			Nil	})
			endif
			endif
		EndIf
		
		
		
		If !empty(_cPedCom)
			_nLenItem := len(alltrim(Posicione('SC7',1,xFilial('SC7')+_cPedCom,'C7_ITEM')))
			
			// Bloco para verificar qual a numeração correta para lançamento do DOC.ENTRADA para classificação
			// Tratamento necessário para quando PV tiver mais que 99 itens
			// Thiago Queiroz - 27/11/13
			_nItemPV 		:= "0099" //SD2->D2_ITEMPV
			_nItemPvCont	:= 0 //99
			_nItemPC		:= VAL(Posicione('SC7',4,xFilial('SC7')+SD2->D2_COD+_cPedCom,'C7_ITEM'))
			
			dbSelectArea("SC7")
			dbSetOrder(4)
			dbSeek(xFilial("SC7")+SD2->D2_COD+_cPedCom)
			WHILE SC7->C7_NUM == _cPedCom .AND. SC7->C7_PRODUTO == SD2->D2_COD
				_nPosArray		:= aScan(aItens ,{|x| x[14][2] == SC7->C7_ITEM })
				
				IF LEN(aItens) == 0
					_nItemPC := val(SC7->C7_ITEM)
				ELSE
					IF _nPosArray == 0 .AND. SD2->D2_QUANT == SC7->C7_QUANT
						_nItemPC := val(SC7->C7_ITEM)
						Exit
					ENDIF
				ENDIF
				dbSelectArea("SC7")
				dbSkip()
			ENDDO
			
			IF ( SD2->D2_ITEMPV > "0099" ) .OR. ( _nItemPC > 99 )
				WHILE _nItemPvCont != _nItemPC //( _nItemPV != SD2->D2_ITEMPV ) .AND. ( _nItemPvCont != _nItemPC )
					_nItemPV 		:= SOMA1(_nItemPV)
					_nItemPvCont	:= _nItemPvCont	+ 1
				ENDDO
			ENDIF
			// Fim do bloco de tratamento
			
			aAdd(aLinha,{"D1_PEDIDO",	_cPedCom									,	Nil	})
			// Se o PV tiver mais que 99 itens, utiliza o _nItemPvCont, caso contrario utiliza o SD2->D2_ITEMPV
			//		IF _nItemPvCont <= 99
			//			aAdd(aLinha,{"D1_ITEMPC",	strzero(val(SD2->D2_ITEMPV),_nLenItem)	, 	Nil	})
			//		ELSE
			aAdd(aLinha,{"D1_ITEMPC",	strzero(_nItemPvCont,_nLenItem)			, 	Nil	})
			//		ENDIF
		EndIf
		
		
		SD2->( DbGoTo(nRecno) )
		
	EndIf
	
	SD2->(DbSkip())
	aAdd( aItens, aLinha )
	aLinha := {}
EndDo

_cPerg     := cPerg
_cCadastro := cCadastro
_aRotina   := aClone(aRotina)
_aCores    := aClone(aCores)

If _lNaoTemTes
	MsgBox('Itens com TES indefinidas (será gerada uma pré-nota):' + _cEnter + _cEnter + _cNaoTemTes,'ATENÇÃO!!!','ALERT')
EndIf
If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
	MsAguarde({|| MSExecAuto({|x,y,z|Mata140(x,y,z)},aCab,aItens,3)},"Aguarde...","Gerando pré-nota de entrada",.T.)
	_cQuery := "UPDATE SD1"
	_cQuery += _cEnter + " SET 	D1_VUNIT = D2_PRUNIT, D1_TOTAL = D1_QUANT * D2_PRUNIT, D1_DESC = round(D2_DESCON * 100 / (D2_DESCON + D2_TOTAL),0), D1_VALDESC = D2_DESCON"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SD2') + " SD2 (NOLOCK)"
	_cQuery += _cEnter + " ON D2_FILIAL = D1_LOJA"
	_cQuery += _cEnter + " AND D2_LOJA = D1_FILIAL"
	_cQuery += _cEnter + " AND D2_COD = D1_COD"
	_cQuery += _cEnter + " AND D2_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND D2_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D2_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD2.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND D1_LOJA = '" + SF2->F2_FILIAL + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Nota Fiscal')
	
Else
	MsAguarde({|| MSExecAuto({|x,y,z|Mata103(x,y,z)},aCab,aItens,3)},"Aguarde...","Gerando nota de entrada",.T.)
EndIf

If lMsErroAuto
	MostraErro()
EndIf


If .F. //!empty(_cPedCom)
	_cQuery := "UPDATE SD1"
	_cQuery += _cEnter + " SET D1_PEDIDO = C7_NUM, D1_ITEMPC = C7_ITEM"
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " ON C7_FILIAL = D1_FILIAL"
	_cQuery += _cEnter + " AND C7_LOJA = D1_LOJA"
	_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
	_cQuery += _cEnter + " AND C7_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND C7_QUJE + C7_QTDACLA = 0"
	_cQuery += _cEnter + " AND C7_NUM = '" + _cPedCom + "'"
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Nota Fiscal')
	
	_cQuery := "UPDATE SC7"
	If xFilial('SF1') $ '01/55'
		_cQuery += _cEnter + " SET C7_QTDACLA = D1_QUANT, C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM"
	Else
		_cQuery += _cEnter + " SET C7_QUJE = D1_QUANT, C7_NFISCAL = D1_DOC + D1_SERIE, C7_ITEMNF = D1_ITEM, C7_ENCER = 'E'"
	EndIf
	_cQuery += _cEnter + " FROM " + RetSqlName('SD1') + " SD1 (NOLOCK)"
	
	_cQuery += _cEnter + " INNER JOIN " + RetSqlName('SC7') + " SC7 (NOLOCK)"
	_cQuery += _cEnter + " ON C7_FILIAL = D1_FILIAL"
	_cQuery += _cEnter + " AND C7_LOJA = D1_LOJA"
	_cQuery += _cEnter + " AND C7_PRODUTO = D1_COD"
	_cQuery += _cEnter + " AND C7_QUANT = D1_QUANT"
	_cQuery += _cEnter + " AND C7_QUJE = 0"
	_cQuery += _cEnter + " AND C7_NUM = '" + _cPedCom + "'"
	_cQuery += _cEnter + " AND SC7.D_E_L_E_T_ = ''"
	
	_cQuery += _cEnter + " WHERE D1_FILIAL = '" + xFilial('SD1') + "'"
	_cQuery += _cEnter + " AND D1_DOC = '" + SF2->F2_DOC + "'"
	_cQuery += _cEnter + " AND D1_SERIE = '" + SF2->F2_SERIE + "'"
	_cQuery += _cEnter + " AND SD1.D_E_L_E_T_ = ''"
	MsAguarde({|| TcSqlExec(_cQuery)},'Ajustando Pedido de Compras')
	
EndIf


DbSelectArea('SB1')
For _nI := 1 to len(_aBloq)
	If DbSeek(xFilial('SB1') + _aBloq[_nI],.f.)
		RecLock('SB1',.f.)
		SB1->B1_MSBLQL := '1'
		MsUnLock()
	EndIf
Next

aRotina   := aClone(_aRotina)
aCores    := aClone(_aCores)
cCadastro := _cCadastro
cPerg     := _cPerg
Pergunte(cPerg,.f.)

/*FOR->(DbSetOrder(1))
If FOR->(DbSeek( xFilial("FOR")+TRB->FOR_NUMROM )) .and. !lMsErroAuto
	
	Reclock("TRB",.F.)
	TRB->FOR_STATUS := "06"	//Encerrado
	TRB->FOR_NFE    := 	TRB->FOR_NFS
	MsUnlock()
	
	RecLock("FOR",.F.)
	FOR->FOR_STATUS := "06"	//Encerrado
	FOR->FOR_NFE    := 	TRB->FOR_NFS
	Msunlock()
	
	
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³TATIANE DE OLIVEIRA VAI COMPLEMENTAR O FONTE³
	//³ABAIXO PARA TROCAR O STATUS DOS ITENS DO    ³
	//³ROMANEIO                                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	PA7->(DbSetOrder(1))
	If PA7->(DbSeek( xFilial("PA7")+TRB->FOR_NUMROM )) .and. !lMsErroAuto
		
		RecLock("PA7",.F.)
		PA7->PA7_STATUS := "06"	//Encerrado
		Msunlock()
		
	ENDIF
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³FIM DO COMPLEMENTO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	
	DbSelectArea('TRB')
	DbgoTop()
	
	If xFilial('SF1') $ '01/55' .or. _lNaoTemTes
		MsgBox('Romaneio encerrado com sucesso.' + _cEnter + 'Classificar a Nota Fiscal de entrada','ATENÇÃO!!!','INFO')
	Else
		MsgBox('Romaneio encerrado e nota fiscal de entrada gerada com sucesso.' + _cEnter + 'Já está classificada','ATENÇÃO!!!','INFO')
	EndIf
	
	Return(.t.)
	
Else
	
	MostraErro()
	DbSelectArea('TRB')
	Return
	
Endif
*/
	Return(.t.)
//1018281317414 - 1814320118147
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VLCODBAR()
/////////////////////////
Local _lRet := .t.

_nDv     := 0
_cCodBar := Embaralha(_cRom,0)
_cDv1    := right(_cCodBar,1)
_cCodBar := left(_cCodBar,12)

For _nI := 1 to 12
	_nDv += val(substr(_cCodBar,_nI,1))
Next
Do While _nDv > 10
	_cDv := strzero(_nDv,3)
	_nDv := 0
	For _nI := 1 to 3
		_nDv += val(substr(_cDv,_nI,1))
	Next
EndDo
If _cDv1 == iif(_nDv == 10,'0',str(_nDv,1))
	_lOk := .t.
	_oDlgPsq:End()
	_cRom := left(_cCodBar,8)
Else
	_lRet := .f.
	_lOk  := .f.
	_cRom := space(13)
	MsgBox('Código de barras inválido','ATENÇÃO!!!','ALERT')
EndIf

Return(_lRet)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function _perdav(_xPar)
///////////////////////
u_LS_Pesquisa(.f.)
_cFilAnt := cFilAnt
If _xPar == 1   // nota fiscal de saida
	
	If empty(TRB->FOR_NFS)
		MsgStop('Nota fiscal de entrada ainda não foi gerada','ATENÇÃO!!!')
		Return()
	EndIf
	
	cFilAnt   := right(TRB->FOR_NUMROM,2)
	_cCliente := Posicione('SC6',1, cFilAnt + left(TRB->FOR_NUMROM,6),'C6_CLI') + SC6->C6_LOJA
	DbSelectArea('SF2')
	DbSetOrder(1)
	If !DbSeek(cFilAnt + TRB->FOR_NFS + TRB->FOR_SERIE + _cCliente, .F.)
		MsgStop('Nota Fiscal não localizada. Contate o administrador do sistema','ATENÇÃO!!!')
		DbSelectArea('FOR')
		cFilAnt  := _cFilAnt
		Return()
	EndIf
	
	NAUTOADT := 0
	MC090Visual()
	
ElseIf _xPar == 2	// nota fiscal de entrada
	
	If empty(TRB->FOR_NFE)
		MsgAlert('Nota fiscal de entrada ainda não foi gerada','ATENÇÃO!!!')
		Return()
	EndIf
	
	cFilAnt   := TRB->FOR_FILDES
	
	_cQuery := "SELECT A1_COD"
	_cQuery += _cEnter + "FROM " + RetSqlName('SA1') + " SA1 (NOLOCK)"
	_cQuery += _cEnter + "WHERE A1_LOJA = '" + TRB->FOR_FILORI + "'"
	_cQuery += _cEnter + "AND A1_COD < '000009'"
	_cQuery += _cEnter + "AND A1_MSBLQL = '2'"
	_cQuery += _cEnter + "AND SA1.D_E_L_E_T_ = ''"
	dbUseArea( .T., "TOPCONN", TCGENQRY(,,_cQuery),"FORNECE", .T., .T.)
	_cFornece := FORNECE->A1_COD
	DbCloseArea()
	
	cLoja		:= right(TRB->FOR_NUMROM,2)
	
	DbSelectArea('SF1')
	DbSetOrder(1)
	If !DbSeek(cFilAnt + TRB->FOR_NFE + TRB->FOR_SERIE + _cFornece + cLoja, .F.)
		MsgAlert('Nota Fiscal não localizada. Contate o administrador do sistema','ATENÇÃO!!!')
		DbSelectArea('TRB')
		cFilAnt  := _cFilAnt
		Return()
	EndIf
	
	A103NFiscal('TRB',,2)
	
Else	//	pedido de vendas
	
//	cFilAnt  := right(FOR->FOR_NUMROM,2)
	NAUTOADT := 0
	DbSelectArea('SC5')
//	DbSeek(right(FOR->FOR_NUMROM,2) + left(FOR->FOR_NUMROM,6),.f.)
	A410Visual(alias(),recno(),2)
	
EndIf

cFilAnt  := _cFilAnt
DbSelectArea('TRB')

Return()
