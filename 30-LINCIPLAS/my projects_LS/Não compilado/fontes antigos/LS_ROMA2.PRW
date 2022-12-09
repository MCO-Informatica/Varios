#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'rwmake.CH'
#include "colors.ch"
#include "sigawin.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLASP002   บAutor  ณFabio Jadao Caires  บ Data ณ  05/16/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Esta rotina tem por objetivo tratar a leitura de codigo de บฑฑ
ฑฑบ          ณ barras dos produtos gerando uma etiqueta de embalagem para บฑฑ
ฑฑบ          ณ quando da entrega nas filiais ou franquias, haja a possibi-บฑฑ
ฑฑบ          ณ lidade de executar a leitura das etiquetas e realizar a    บฑฑ
ฑฑบ          ณ entrada dos produtos referentes a embalagem.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva Bookstore                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿

ALTERAวีES:
ALEXANDRE DALPIAZ 

*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function LS_ROMA()
///////////////////////

Local nI 		:= 0
Local nCnt 		:= 0
Local cIndPA6 	:= " "
Local aCaixa 	:= {}
Local nSoma 	:= 0
Local cFilter	:= " "
Local bFilFilter := {}
Local aIndexPA6	:= {}
Local cAlias 	:= "PA6"
               
Private aRotina  	:= {}
Private lRefresh 	:= .T.
Private aCores 		:= {}
Private cCadastro 	:= "Manuten็ใo de Romaneios"
Private cNmFilial 	:= " "
Private cMarca		:= GetMark()
Private aCposBrw  	:= {}

Private oCont		:= LoadBitmap( GetResources(), "BR_AMARELO"  )	//NAO CONTATO
Private oDiverg		:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//CONTAGEM EM CURSO

_cNota  := ""
_cSerie := ""
cPerg   := "LS_ROMA"

If !Pergunte(cPerg,.T.)
	Return
Endif

_cStatus  := ''
_lFilOri  := .f.
_lNoPower := .t.
_lFilDes  := .f.  
_cChave   := ''      /// filial de destino + grupo de produtos.
   
_lSepara  := __cUserId $ GetMv('LS_ROMASEP') 								// usuario para separa็ใo de mercadoria
_lExpede  := __cUserId $ GetMv('LS_ROMAEXP') 								// usuario para expedi็ใo do romaneio
_lRecebe  := __cUserId $ GetMv('LS_ROMAREC')  								// usuario para recebimento do romaneio
_lEncerra := __cUserId $ GetMv('LS_ROMAENC')  								// usuario para encerramento do romaneio
_lSuper   := __cUserId $ GetMv('LS_ROMASUP') + '/' + GetMv('LA_PODER') 		// usuario supervisor ou administrador

aAdd( aRotina, {"Pesquisa"  	, "AxPesqui"	,0,1} )

If _lSepara .or. _lSuper
	aAdd( aRotina, {"Separa็ใo"  	, "u_LS_Separa(.T.)"	,0,2} ) //Saida
	_cStatus  += iif(empty(mv_par03),'01/03',mv_par03) + '/'
	_lFilOri  := .t.
	_lNoPower := .f.
EndIf
If _lExpede .or. _lSuper 
	aAdd( aRotina, {"Expedi็ใo"  	, "u_ls_Expede"   		,0,3} )
	_cStatus  += '02/'
	_lFilOri  := .t.
	_lNoPower := .f.
EndIf
If _lRecebe .or. _lSuper
	aAdd( aRotina, {"Recebimento"	, "u_ls_Separa(.F.)"	,0,4} ) //Entrada
	_cStatus  += '04/'
	_lFilDes  := .t.
	_lNoPower := .f.
EndIf
If _lEncerra .or. _lSuper
	_lNoPower := .f.
	_cStatus  += '05/'
	_lFilDes  := .t.
	aAdd( aRotina, {"Encerramento"	, "U_ls_Encerra"  		,0,3} )
EndIf
If _lSuper
	_cStatus  += '06/'
	_lFilOri  := .t.
	_lFilDes  := .f.
	_lNoPower := .f.
EndIf

_cQuery := "PA6_DTROM BETWEEN '" + dtos(mv_par01) + "' AND '" + dtos(mv_par02) + "'"
If '06' $ _cStatus .or. _lNoPower
	If !empty(mv_par03)
		_cQuery += _cEnter + " AND PA6_STATUS = '" + mv_par03 + "'"
	EndIf
	If !empty(mv_par04)
		_cQuery += _cEnter + " AND PA6_FILORI = '" + mv_par04 + "'"
	EndIf
	If !empty(mv_par05)
		_cQuery += _cEnter + " AND PA6_FILDES = '" + mv_par05 + "'"
	EndIf
Else
	_cQuery  += " AND PA6_STATUS IN " + FormatIn(_cStatus,'/')
EndIf

If !_lNoPower .or. '06' $ _cStatus
	AAdd(aCposBrw,{ 'PA6_OK',,'OK', '' })
EndIf

dbSelectArea("SX3")
DbSetOrder(1)
DbSeek('PA6')
Do While !eof() .and. SX3->X3_ARQUIVO == 'PA6'
	If SX3->X3_BROWSE == "S" .and. SX3->X3_CONTEXT <> 'V'
		AAdd(aCposBrw,{ SX3->X3_CAMPO,,SX3->X3_TITULO, RTrim(SX3->X3_PICTURE) })
	EndIf
	DbSkip()
EndDo

If _lFilOri
	_cQuery += " AND PA6_FILORI = '" + cFilAnt + "'"
EndIf
If _lFilDes
	_cQuery  += " AND PA6_FILDES = '" + cFilAnt + "'"
EndIf

_cUpdate := "UPDATE " + RetSqlName('PA6')
_cUpdate += _cEnter + "SET PA6_DESCST = CASE WHEN PA6_STATUS = '01' THEN 'Nใo separado', PA6_USERGA = '" + Embaralha(cUserName,2) + "'"
_cUpdate += _cEnter + "WHEN PA6_STATUS = '02' THEN 'Separa็ใo OK' "
_cUpdate += _cEnter + "WHEN PA6_STATUS = '03' THEN 'Separa็ใo Divergente' "
_cUpdate += _cEnter + "WHEN PA6_STATUS = '04' THEN 'Expedi็ใo OK' "
_cUpdate += _cEnter + "WHEN PA6_STATUS = '05' THEN 'Recebimento OK' "
_cUpdate += _cEnter + "ELSE 'Encerrado' END"
_cUpdate += _cEnter + "WHERE D_E_L_E_T_ = '' AND"
_cUpdate += _cEnter + _cQuery

TcSqlExec(_cUpdate)

aAdd( aRotina, {"Monitor"		, "u_ls_Monitor" 		,0,6} )
aAdd( aRotina, {"Ped Venda"  	, "U_VisNFS(3)" 		,0,2} )
aAdd( aRotina, {"NF Saํda"   	, "U_VisNFS(1)" 		,0,2} )
aAdd( aRotina, {"NF Entrada" 	, "U_VisNFS(2)" 		,0,2} )
aAdd( aRotina, {"Legenda"		, "U_ls_PA6Leg"  		,0,7} )

aAdd(aCores, { "(PA6->PA6_STATUS == '01')", "BR_VERMELHO" 	}) //Ainda nao separado
aAdd(aCores, { "(PA6->PA6_STATUS == '02')", "BR_BRANCO"   	}) //Separacao Ok
aAdd(aCores, { "(PA6->PA6_STATUS == '03')", "BR_AMARELO"  	}) //Separacao divergente
aAdd(aCores, { "(PA6->PA6_STATUS == '04')", "BR_AZUL"     	}) //Expedicao Ok
aAdd(aCores, { "(PA6->PA6_STATUS == '05')", "BR_VERDE"		}) //Recebimento Ok
aAdd(aCores, { "(PA6->PA6_STATUS == '06')", "BR_PRETO" 		}) //Encerrado

DbSelectArea("PA6")
DbSetOrder(1)

DbGoTop()
If _lNoPower
	mBrowse( 7, 4,20,74,cAlias,,,,,,aCores,,,,,,,,_cQuery)
Else
	MarkBrow(cAlias,'PA6_OK',, aCposBrw,.F.,@cMarca,'U_MarkAll()',,,,'U_MarkRoma()',,_cQuery,,aCores)
EndIf

RetIndex()

_cUpdate := "UPDATE " + RetSqlName('PA6')
_cUpdate += _cEnter + "SET PA6_OK = '', PA6_USERGA = '" + Embaralha(cUserName,2) + "'"
_cUpdate += _cEnter + "WHERE D_E_L_E_T_ = '' AND"
_cUpdate += _cEnter + "PA6_OK = '" + cMarca + "' AND"
_cUpdate += _cEnter + _cQuery
TcSqlExec(_cUpdate)

Return
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MarkAll()
///////////////////////
_cMarca := cMarca        
_cChave := ''

_cUpdate := "UPDATE " + RetSqlName('PA6')
_cUpdate += _cEnter + "SET PA6_OK = '', PA6_USERGA = '" + Embaralha(cUserName,2) + "'"
_cUpdate += _cEnter + "WHERE D_E_L_E_T_ = '' AND"
_cUpdate += _cEnter + "PA6_OK = '" + cMarca + "'"
TcSqlExec(_cUpdate)

cMarca := _cMarca
MarkBRefresh()

Return()

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function MarkRoma()
////////////////////////

If PA6->PA6_STATUS == '06'
	Alert("Este romaneio jแ encontra-se encerrado, nใo pode sofrer altera็ใo.")
	Return()
EndIf

If PA6->PA6_STATUS $ "04/05"
	If PA6->PA6_FILDES <> cFilAnt
		Alert("O recebimento/encerramento pode ser feito apenas na filial de destino")
		Return()
	EndIf
	SF2->(DbSetOrder(1))
	SF2->(DbGoTop())
	If !SF2->(DbSeek(xFilial('PA6') + PA6->PA6_FILORI + PA6->PA6_NFS + PA6->PA6_SERIE))
		Alert("Nota fiscal " + PA6_NFS + " nใo encontrada na filial " + PA6_FILORI)
		Return()
	EndIf
EndIf

_lRec     := .f.

RecLock('PA6',.f.)
If PA6->PA6_OK == cMarca
	_cChave := substr(_cChave,7)
	PA6->PA6_OK := iif(PA6->PA6_OK == cMarca, '', cMarca)
Else
	If PA6->PA6_FILDES + PA6->PA6_GRUPO == left(_cChave,6) .or. empty(_cChave)
		_cChave += PA6->PA6_FILDES + PA6->PA6_GRUPO
		PA6->PA6_OK := iif(PA6->PA6_OK == cMarca, '', cMarca)
	Else
		MsgBox('Romaneio nใo pertence เ Filial ' + left(_cChave,2) + ' nem ao grupo de produtos ' + substr(_cChave,3,4),'ATENวรO!!!','ALERT')
	EndIf
EndIf
MsUnLock()

_cSelect := "SELECT *"
_cSelect += _cEnter + "FROM " + RetSqlName('PA6')
_cSelect += _cEnter + "WHERE D_E_L_E_T_ = '' AND"
_cSelect += _cEnter + "PA6_OK = '" + cMarca + "' AND"
_cSelect += _cEnter + "PA6_FILIAL = '" + xFilial('PA6') + "' AND"
_cSelect += _cEnter + "PA6_FILORI = '" + cFilAnt + "'"
If Select('TRB') > 0
	TRB->(DbCloseArea())
EndIF
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cSelect), 'TRB', .F., .T.)

DbSelectArea('PA6')
MarkBRefresh()

Return()

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Separa   บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de separacao dos itens do romaneio                  บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Separa(lSaida)
///////////////////////////////

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
          
Private nGetQtd1  := SC5->C5_VOLUME1
Private nGetPesoB := SC5->C5_PBRUTO
Private nGetPesoL := SC5->C5_PESOL
Private cGetTrans := SC5->C5_TRANSP
Private cGetNTran := Posicione('SA4',1,xFilial('SA4') + cGetTrans,'A4_NOME')
Private oGetQtd1
                       
If lSaida .and. PA6->PA6_FILORI <> cFilAnt	
	Alert("Este romaneio deve ser separado na filial de origem (" + PA6->PA6_FILORI + ")")
	Return(.T.)		
ElseIf !lSaida .and. PA6->PA6_FILDES <> cFilAnt
	Alert("Este romaneio deve ser recebido na filial de destino (" + PA6->PA6_FILDES + ")")
	Return(.T.)			
EndIf	

If lSaida            
	DbSelectArea('TRB')
	DbgoTop()
	If eof()
		MsgBox('Nenhum romaneio selecionado para separa็ใo','ATENวรO!!!','ALERT')
		Return()
	EndIf
	cTitulo := "Carga do Romaneio - Saida de Produtos"
Else
	DbSelectArea('TRB')
	DbgoTop()
	If eof()
		MsgBox('Nenhum romaneio selecionado','ATENวรO!!!','ALERT')
		Return()
	EndIf
	cTitulo := "Carga do Romaneio - Entrada de Produtos"
EndIf

Set Key VK_F11 to U_LS_Estorna(lSaida)

If !lSaida .And. PA6->PA6_FILDES != cFilAnt
	Alert("Este romaneio s๓ poderแ ser recebido na filial de destino.")
	Return
EndIf

If lSaida .And. PA6->PA6_FILORI != cFilAnt
	Alert("Este romaneio s๓ poderแ ser separado na filial de origem.")
	Return
EndIf

If PA6->PA6_STATUS == "01" .And. !lSaida//Ainda nao separado
	Alert("Este romaneio ainda nใo foi separado." + _cEnter + ;
	"Antes de receb๊-lo, o romaneio deve ser separado e expedido.")
	Return
EndIf

If PA6->PA6_STATUS == "02" .and. lSaida //Separacao Ok
	If !MsgYesNo("Este romaneio jแ estแ com a separa็ใo Ok. Deseja refazer a separa็ใo?")
		Return(.T.)
	EndIf
EndIf

If PA6->PA6_STATUS == "03" .And. !lSaida //Separacao divergente
	Alert("Este romaneio nใo foi devidamente separado. Corrija a separa็ใo mas ainda nใo foi expedido." + _cEnter + "Antes de receb๊-lo, o romaneio deve ser expedido.")
	Return
EndIf

If PA6->PA6_STATUS == "04" .And. lSaida //Em expedicao
	Alert("Este romaneio jแ foi Expedido e nใo pode mais ser separado." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If PA6->PA6_STATUS == "05" //Recebido Ok
	Alert("Este romaneio jแ foi devidamente recebido." + _cEnter + 	"Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

If PA6->PA6_STATUS == "06" //Encerrado
	Alert("Este romaneio jแ foi encerrado e nใo pode mais ser separado." + _cEnter + "Contate a filial de origem deste romaneio.")
	Return(.T.)
EndIf

_cRomas := 'Romaneio:'
_cProd  := ''

DEFINE FONT oFont   NAME 'Arial Black' SIZE 14, 15 Bold

DEFINE MSDIALOG oDlg TITLE cTitulo FROM C(178),C(181) TO C(538),C(800) PIXEL 

@ C(005),C(006) Say "Filial :" 							Size C(018),C(008) COLOR CLR_BLACK  PIXEL OF oDlg
@ C(005),C(025) Say Alltrim(PA6->PA6_LOJA) 				Size C(084),C(008) COLOR CLR_BLACK  PIXEL OF oDlg
@ C(012),C(006) Say _cRomas	Font oFont     				Size C(320),C(017) COLOR CLR_HRED   PIXEL OF oDlg

@ C(030),C(006) Say "Produto:" Font oFont				Size C(051),C(008) COLOR CLR_HRED   PIXEL OF oDlg
@ C(030),C(075) MsGet oGetProd Var cGetProd F3 "SB1" 	Size C(115),C(009) COLOR CLR_BLACK  Picture "@!" PIXEL OF oDlg  Valid ( Empty( cGetProd ) .Or. LS03REFRES(lSaida) )
@ C(030),C(50)  MsGet oGetQtd  Var nQtd  			 	Size C(20),C(009)  COLOR CLR_BLACK  Picture "@E 99999" PIXEL OF oDlg  Valid (( Val(nQtd) > 0) .and. !empty(cGetProd)) .or. empty(cGetProd)

@ C(043),C(006) Say _cProd 	Font oFont      			Size C(320),C(017) COLOR CLR_HBLUE    PIXEL OF oDlg

@ C(150),C(006) Say "[F11] Estorno"						Size C(051),C(008) COLOR CLR_BLACK  PIXEL OF oDlg
@ C(150),C(220) Button "Ok" 							Size C(037),C(012) 					PIXEL OF oDlg ACTION(GrvRom(lSaida))

fListBox1(lSaida)

ACTIVATE MSDIALOG oDlg CENTERED
Set Key VK_F11 to

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Estorna  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de estorno das quantidades da separacao.            บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Estorna(_lSaida)
//////////////////////////

Local nPosCont := 0

nPosCont 	:= oListBox1:nAt

If nPosCont <= 0
	Alert("Posicione sobre o produto para o estorno!")
	cGetProd := Space( Len( SB1->B1_CODBAR) )
	oGetProd:Refresh()
	oGetProd:SetFocus()	
	Return
EndIf

If MsgBox('Confirma estorno da contagem do produto ' + aListBox1[nPosCont,2] + ' - ' + aListBox1[nPosCont,3],'Estornar???','YESNO')
	aListBox1[nPosCont,5] := 0
	aListBox1[nPosCont,1] := oCont
	DbSelectArea('PA7')
	If DbSeek(xFilial('PA7') + aListBox1[nPosCont,6] + aListBox1[nPosCont,2],.f.)
		RecLock('PA7',.f.)
		If _lSaida
			PA7->PA7_QUANT  := 0
		Else
			PA7->PA7_QTDREC := 0
		EndIf
		MsUnLock()
	EndIf
EndIf

oListBox1:Refresh()
cGetProd := Space( Len( SB1->B1_CODBAR) )
oGetProd:Refresh()
oGetProd:SetFocus()
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Expede   บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de expedicao dos itens do romaneio                  บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Expede()
/////////////////////////

SC5->(DbSeek(right(PA6->PA6_NUMROM,2) + left(PA6->PA6_NUMROM,6),.f.))

Private nGetQtd1  := SC5->C5_VOLUME1
Private nGetPesoB := SC5->C5_PBRUTO
Private nGetPesoL := SC5->C5_PESOL
Private cGetTrans := SC5->C5_TRANSP
Private cGetNTran := Posicione('SA4',1,xFilial('SA4') + cGetTrans,'A4_NOME')

Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox2 := {}
Private oListBox2

Private aVolumes	:= {}

Private oVolOk  := LoadBitmap( GetResources(), "BR_VERDE" 	)	//Qtd Ok
Private oVolDiv	:= LoadBitmap( GetResources(), "BR_VERMELHO" )	//Qtd Divergente

DbSelectArea('TRB')
DbgoTop()
If eof()
	Alert('Nenhum romaneio selecionado')
	Return
EndIf

If PA6->PA6_FILORI <> cFilAnt	
	If PA6->PA6_STATUS == "01"
		Alert("Este romaneio deve ser separado na filial "+PA6->PA6_FILORI)
		Return(.T.)		
	ElseIf PA6->PA6_STATUS == "02"
		Alert("Este romaneio deve ser expedido na filial "+PA6->PA6_FILORI)
		Return(.T.)			
	EndIf	
EndIf

_lOk := .f.
DEFINE MSDIALOG oDlg3 TITLE "Carga do Romaneio - Controle de Volumes" FROM C(178),C(181) TO C(600),C(662) PIXEL

@ C(005),C(006) Say "Filial :" 					Size C(018),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(005),C(025) Say Alltrim(TRB->PA6_LOJA) 		Size C(084),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(015),C(006) Say "Romaneio : " 				Size C(028),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(015),C(036) Say Alltrim(TRB->PA6_NUMROM)	Size C(029),C(008) COLOR CLR_BLACK PIXEL OF oDlg3

@ C(025),C(006) Say "Qtd Volumes:"         		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(025),C(040) MsGet oGetQtd1 Var nGetQtd1		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '999'

@ C(040),C(006) Say "Peso Lํquido:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(040),C(040) MsGet oGetPL  Var nGetPesoB		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99

@ C(040),C(100) Say "Peso Bruto:"          		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(040),C(150) MsGet oGetPB   Var nGetPesoL	Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 PICTURE '@E 999,999.99

@ C(055),C(006) Say "Transportadora:"      		Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg3
@ C(055),C(040) MsGet oGetTra Var cGetTrans		Size C(040),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 F3 'SA4' Valid TrnpRefres() 
@ C(055),C(100) MsGet oGetTrb Var cGetNTran		Size C(100),C(009) COLOR CLR_BLACK PIXEL OF oDlg3 when .f.


@ C(080),C(040) Button "Ok" 		Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .t., oDlg3:End())
@ C(080),C(110) Button "Calcelar" 	Size C(037),C(012) PIXEL OF oDlg3 ACTION(_lOk := .f., oDlg3:End())

ACTIVATE MSDIALOG oDlg3 CENTERED Valid ( !_lOk .or. VldDlg3() )

If _lOk
	GeraNF()
EndIf

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณ Monitor  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina de monitoramento dos romaneios.                     บฑฑ
ฑฑบ          |                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ LASEA003                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_Monitor()
//////////////////////////

Local aButtons	:= {}

Local cFilOri	:= ""
Local cFilDes	:= ""

Private oDlg5				// Dialog Principal

Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.

Private aListBox5 := {}
Private oListBox5

dbSelectArea("SM0")
SM0->(dbSetOrder(1))
If SM0->( dbSeek(cEmpAnt + Trim(PA6->PA6_FILORI)) )
	cFilOri := Trim(SM0->M0_CODFIL)+" - "+Trim(SM0->M0_FILIAL)
EndIf

cFilDes := PA6->PA6_FILDES+" - "+ GetAdvFVal("SM0","M0_FILIAL",cEmpAnt + PA6->PA6_FILDES,1)


DEFINE MSDIALOG oDlg5 TITLE "Romaneios - Monitor" FROM C(178),C(181) TO C(665),C(967) PIXEL

@ C(004),C(003) TO C(080),C(392) LABEL "" PIXEL OF oDlg5

@ C(013),C(008) Say "Romaneio : " 									Size C(031),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(039) Say Alltrim(PA6->PA6_NUMROM)						Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(215) Say "Nota Fiscal de saํda        :" 				Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(013),C(284) Say Alltrim(PA6->PA6_NFS) + ' - (' + dtoc(PA6->PA6_DATNFS) + ')' 	Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(023),C(008) Say "Loja  :" 										Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(027) Say Alltrim(PA6->PA6_LOJA)				  			Size C(063),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(101) Say "Nro. Volumes :" 								Size C(037),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(140) Say StrZero(PA6->PA6_VOL,3)	 				   		Size C(024),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(215) Say "Data NFiscal de entrada     :" 				Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(023),C(284) Say PA6->PA6_DATNFE 								Size C(050),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(033),C(008) Say "Data : " 										Size C(019),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(027) Say DTOC(PA6->PA6_DTROM)	 						Size C(041),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(101) Say "Status do romaneio : " 						Size C(051),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(153) Say Alltrim(PA6->PA6_DESCST) 			  			Size C(057),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(215) Say "ฺltima a็ใo realizada por :" 		  			Size C(070),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(033),C(284) Say Alltrim(Embaralha(PA6->PA6_USER,1)) 		 	Size C(080),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(053),C(008) Say "Filial de Origem :" 							Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(053),C(053) Say cFilOri			 								Size C(130),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

@ C(063),C(008) Say "Filial de Destino :" 				   			Size C(042),C(008) COLOR CLR_BLACK PIXEL OF oDlg5
@ C(063),C(053) Say cFilDes				 							Size C(130),C(008) COLOR CLR_BLACK PIXEL OF oDlg5

fListBox5()

ACTIVATE MSDIALOG oDlg5 CENTERED  ON INIT EnchoiceBar(oDlg5, {||oDlg5:End()},{||oDlg5:End()},,aButtons)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfListBox1() ณ Autor ณ Fabio Jadao Caires       ณ Data ณ18/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da ListBox                                          ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox1(lSaida)
/////////////////////////////////

Private oMarca
Private lInverte	:= .F.
Private aItens 		:= {}

_cSelect := "SELECT *"
_cSelect += _cEnter + "FROM " + RetSqlName('PA6')
_cSelect += _cEnter + "WHERE D_E_L_E_T_ = '' AND"
_cSelect += _cEnter + "PA6_OK = '" + cMarca + "' AND"
_cSelect += _cEnter + "PA6_FILIAL = '" + xFilial('PA6') + "' AND" 
_cSelect += _cEnter + "PA6_FILORI = '" + cFilAnt + "'"
If Select('TRB') > 0
	TRB->(DbCloseArea())
EndIf
DbUseArea(.T., "TOPCONN", TCGenQry(,,_cSelect), 'TRB', .F., .T.)

 _cRomas := ''
// Se for para recebimento mostrar a quantidade PA7_QUANT e nao mostrar mais a quantidade PA7_QTDORI. Criar PA7_QTDREC e apontar nesta quantida e comprarar.
DbSelectArea('TRB')
DbgoTop()
Do While !eof()

	If !(TRB->PA6_NUMROM $ _cRomas)
		_cRomas += TRB->PA6_NUMROM + ', '
	EndIf
	
	DbSelectArea('PA7')
	DbSeek( xFilial("PA7") + TRB->PA6_NUMROM ,.f.)
	Do While !EOF() .AND. PA7->PA7_NUMROM == TRB->PA6_NUMROM
		
		If lSaida
			If PA7->PA7_QUANT <> PA7->PA7_QTDORI //Qtd contada <> Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
				aAdd(aListBox1,{iif(PA7->PA7_QUANT == 0,oDiverg,oCont),   PA7->PA7_CODPRO, Posicione('SB1',1, xFilial('SB1') + PA7->PA7_CODPRO,'B1_CODBAR'), PA7->PA7_DESCPR,              0, PA7->PA7_NUMROM})
			Else
				aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, Posicione('SB1',1, xFilial('SB1') + PA7->PA7_CODPRO,'B1_CODBAR'), PA7->PA7_DESCPR, PA7->PA7_QUANT, PA7->PA7_NUMROM})
			EndIf
		Else
			If PA7->PA7_QTDREC <> PA7->PA7_QUANT //Qtd contada <> Qtd Romaneio ou nao contado ( Qtd Contada = 0 )
				aAdd(aListBox1,{oCont  , PA7->PA7_CODPRO, Posicione('SB1',1, xFilial('SB1') + PA7->PA7_CODPRO,'B1_CODBAR'), PA7->PA7_DESCPR,               0, PA7->PA7_NUMROM})
			Else
				aAdd(aListBox1,{oDiverg, PA7->PA7_CODPRO, Posicione('SB1',1, xFilial('SB1') + PA7->PA7_CODPRO,'B1_CODBAR'), PA7->PA7_DESCPR, PA7->PA7_QTDREC, PA7->PA7_NUMROM})
			EndIf
		EndIf
		PA7->(DbSkip())
	EndDo
	DbSelectArea('TRB')
	DbSkip()
EndDo
    
_cRomas := left(_cRomas,len(_cRomas)-2)
_cRomas := 'Romaneio' + iif(len(_cRomas) > 8 ,'s','') + ': ' + _cRomas
oDlg:Refresh()

@ C(057),C(004) LISTBOX oListBox1 FIELDS HEADER "","Codigo", "Cod. Barras", "Descricao", "Qtd contada", "Nr Romaneio"  SIZE C(300),C(086) Of oDlg Pixel	ColSizes 50,50,50,50

oListBox1:SetArray(aListBox1)

oListBox1:bLine 		:= {|| {	aListBox1[oListBox1:nAT,01],;
aListBox1[oListBox1:nAT,02],;
aListBox1[oListBox1:nAT,03],;
aListBox1[oListBox1:nAT,04],;
0,;//aListBox1[oListBox1:nAT,05],;
aListBox1[oListBox1:nAT,06] }}
       
DbSelectArea('PA6')
DbSetOrder(1)
Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณfListBox5() ณ Autor ณ Fabio Jadao Caires    ณ Data ณ26/06/2007ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Montagem da ListBox do monitor                               ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function fListBox5()
///////////////////////////

Local nDiffSaida := 0
Local nDiffEntrada := 0

PA7->( DbSetOrder(1) )
PA7->( DbSeek( xFilial("PA7")+PA6->PA6_NUMROM ) )

While !PA7->( EOF() ) .AND. PA7->PA7_NUMROM == PA6->PA6_NUMROM
	
	nDiffSaida   := PA7->PA7_QTDORIG - PA7->PA7_QUANT
	nDiffEntrada := PA7->PA7_QTDORIG - PA7->PA7_QUANT	
	
	If nDiffSaida == 0 .Or. nDiffEntrada == 0
		Aadd( aListBox5,{oCont,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
	EndIf
	
	If nDiffSaida > 0 .Or. nDiffEntrada > 0
		Aadd( aListBox5,{oCont,PA7->PA7_CODPRO,PA7->PA7_DESCPR,PA7->PA7_QTDORIG,PA7->PA7_QUANT,PA7->PA7_QTDREC,nDiffSaida, nDiffEntrada} )
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraNF    บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao da gravacao do volume do romaneio e geracao da  บฑฑ
ฑฑบ          ณnota fiscal                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GeraNF()
////////////////////////

Local nI			:= 0
Local lAchouPa6		:= .F.

cLockBy := 'GeraNF_' + GetMv('FS_LASSER ') + '_' + cEmpAnt + '_' + SM0->M0_CGC 
_cSerie := padr(GetMv("FS_LASSER"),3,' ')
_lCont  := .f.
Do While !_lCont
	
	If LockByName(cLockBy,.t.,.t.,.t.,.t.)
		_lCont       := .t.                  
		RecLock('_LOCK',.t.)
		_LOCK->LCK_USER   := cUserName
		_LOCK->LCK_DTLOCK := date()
		_LOCK->LCK_HRLOCK := left(Time(),2) + substr(Time(),4,2)
		_LOCK->LCK_DTUNLK := ctod('')
		_LOCK->LCK_HRUNLK := ''
		_LOCK->LCK_CHAVE  := cLockBy
		_LOCK->LCD_ROTINA := FunName()		
		MsUnLock()
	Else
		If __cUserId $ '***' //GetMV('LA_PODER')
			_cTexto := 'Outro usuแrio utilizando a rotina de gera็ใo de notas fiscais!!!' + _cEnter + _cEnter
			_cTexto += 'Tentar novamente?'
			_lCont := MsgBox(_cTexto , 'Romaneios - Gera็ใo de Notas Fiscais','YESNO' )
			RecLock('_LOCK',.t.)
			_LOCK->LCK_USER   := cUserName
			_LOCK->LCK_DTLOCK := date()
			_LOCK->LCK_HRLOCK := left(Time(),2) + substr(Time(),4,2)
			_LOCK->LCK_DTUNLK := ctod('')
			_LOCK->LCK_HRUNLK := ''
			_LOCK->LCK_CHAVE  := cLockBy + ' - FORCEPS' 
			_LOCK->LCD_ROTINA := FunName()		
			MsUnLock()
		Else                 
			_lCont := .f.
			DbSelectArea('SX5')
			DbSeek(cFilAnt + '01' + _cSerie,.f.)
			If RecLock('SX5',.F.)
				_lCont := .t.
				MsUnLock()
			EndIf
			If !_lCont
				_cTexto := 'Outro usuแrio utilizando a rotina de gera็ใo de notas fiscais!!!' + _cEnter + _cEnter
				_cTexto += 'Tentar novamente?'
				If !MsgBox(_cTexto , 'Romaneios - Gera็ใo de Notas Fiscais','YESNO' )
					Return()
				EndIf
			Else
				MsgBox('Antes de prosseguir, certifique-se que nใo hแ nenhum outro usuแrio utilizando esta rotina para esta loja/filial (CNPJ).','ATENวรO!!!','ALERT')
			EndIf

		EndIf
	EndIf
EndDo

// Chamada da funcao de geracao da NF devera ser neste PONTO !!!
//
_cNumNFX5F := alltrim(Posicione('SX5',1,cFilAnt + '01' + _cSerie,'X5_DESCRI'))
MsAguarde({|| 	_cNota := GravaNFS()},"Aguarde...","Gerando Nota Fiscal de Saida",.T.)
_cNota := PadR(_cNota,9,' ')

DbSelectArea('SF2')
DbSetOrder(1)
If !DbSeek(xFilial('SF2') + _cNota + _cSerie,.f.)
	MsgBox('Nota fiscal nใo foi gerada. Verifique!','ATENวรO!!!','ALERT')
Else
	SC5->(DbSetOrder(1))
	If SC5->(DbSeek(right(TRB->PA6_NUMROM,2) + left(TRB->PA6_NUMROM,6) ,.f.))
		RecLock('SC5',.f.)
		SC5->C5_NOTA  := _cNota
		SC5->C5_SERIE := _cSerie
		MsUnLock()
	EndIf	

	DbSelectArea('TRB')
	DbGoTop()
	Do While !eof()
		
		DbSelectArea('PA6')                                     
		DbSetOrder(1)

		If DbSeek(xFilial('PA6') + TRB->PA6_FILDES + TRB->PA6_GRUPO + TRB->PA6_NUMROM,.f.)  
			RecLock("PA6",.F.)
			PA6->PA6_STATUS := "04" //Expedicao OK
			PA6->PA6_DESCST := "Expedicao Ok"
			PA6->PA6_NFS    := _cNota
			PA6->PA6_SERIE	:= _cSerie
			PA6->PA6_USER 	:= Embaralha( Substr(cUsuario,7,15),0 )
			Msunlock()
		EndIf
		
		DbSelectArea('TRB')
		DbSkip()
		
	EndDo
	
EndIf

UnLockByName( cLockBy,.t.,.t.,.t.,.t. )
DbSelectArea('_LOCK')
If DbSeek(padr(FunName(),20) + padr(alltrim(cLockBy),30) + dtos(date()),.f.)
	RecLock('_LOCK',.F.)
	_LOCK->LCK_DTUNLK := date()
	_LOCK->LCK_HRUNLK := left(Time(),2) + substr(Time(),4,2)
	DbDelete()
	MsUnLock()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGrvRom    บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfirmacao da gravacao do romaneio e ajusta os status do   บฑฑ
ฑฑบ          ณromaneio                                                    บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function GrvRom(lSaida)
//////////////////////////////

_cSelect :="SELECT SUM(ORIG) ORIG, SUM(DIVERG) DIVERG, SUM(OK) OK, PA6_NUMROM"
_cSelect += _cEnter + "FROM ("

_cSelect += _cEnter + "SELECT 0 ORIG, COUNT(*) DIVERG, 0 OK, PA6_NUMROM "
_cSelect += _cEnter + "FROM " + RetSqlName('PA6') + " PA6 (NOLOCK) "
_cSelect += _cEnter + "INNER JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK) "
_cSelect += _cEnter + "ON PA7.D_E_L_E_T_ = '' "
_cSelect += _cEnter + "AND PA7_QUANT <> " + iif(lSaida, "PA7_QTDORI ", "PA7_QTDREC")
_cSelect += _cEnter + "AND PA7_QUANT <> 0 "
_cSelect += _cEnter + "AND PA7_NUMROM = PA6_NUMROM "
_cSelect += _cEnter + "WHERE PA6.D_E_L_E_T_ = '' "
_cSelect += _cEnter + "AND PA6_OK = '" + cMarca + "' "               
_cSelect += _cEnter + "GROUP BY PA6_NUMROM"
_cSelect += _cEnter + "UNION ALL"

_cSelect += _cEnter + "SELECT COUNT(*) ORIG, 0 DIVERG, 0 OK, PA6_NUMROM "
_cSelect += _cEnter + "FROM " + RetSqlName('PA6') + " PA6 (NOLOCK) "
_cSelect += _cEnter + "INNER JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK) "
_cSelect += _cEnter + "ON PA7.D_E_L_E_T_ = '' "
_cSelect += _cEnter + "AND PA7_QUANT = 0"
_cSelect += _cEnter + "AND PA7_NUMROM = PA6_NUMROM "
_cSelect += _cEnter + "WHERE PA6.D_E_L_E_T_ = '' "
_cSelect += _cEnter + "AND PA6_OK = '" + cMarca + "' "               
_cSelect += _cEnter + "GROUP BY PA6_NUMROM"
_cSelect += _cEnter + "UNION ALL"

_cSelect += _cEnter + "SELECT 0 ORIG, 0 DIVERG, COUNT(*) OK, PA6_NUMROM "
_cSelect += _cEnter + "FROM " + RetSqlName('PA6') + " PA6 (NOLOCK) "
_cSelect += _cEnter + "INNER JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK) "
_cSelect += _cEnter + "ON PA7.D_E_L_E_T_ = ''"
_cSelect += _cEnter + "AND PA7_QUANT = " + iif(lSaida, "PA7_QTDORI ", "PA7_QTDREC")
_cSelect += _cEnter + "AND PA7_NUMROM = PA6_NUMROM "
_cSelect += _cEnter + "WHERE PA6.D_E_L_E_T_ = '' "
_cSelect += _cEnter + "AND PA6_OK = '" + cMarca + "' "
_cSelect += _cEnter + "GROUP BY PA6_NUMROM"
_cSelect += _cEnter + ") A"
_cSelect += _cEnter + "GROUP BY PA6_NUMROM"
_cSelect += _cEnter + "ORDER BY PA6_NUMROM"

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cSelect), 'TRB1', .F., .T.)

_cDiverg := ''
Do While !eof()
	
	DbSelectArea('TRB')
	DbGoTop()
	Do While !eof()
		
		If TRB1->PA6_NUMROM	<> TRB->PA6_NUMROM
			DbSkip()
			loop
		EndIf 
		
		DbSelectArea('PA6')
		If DbSeek(xFilial('PA6') + TRB->PA6_FILDES + TRB->PA6_GRUPO + TRB->PA6_NUMROM,.f.)
			Reclock("PA6",.F.)
			
			If lSaida			// SEPARACAO                  
			
				If TRB1->ORIG > 0		// pedido nใo separado
					PA6->PA6_STATUS := '01'
					PA6->PA6_DESCST := "Nใo separado"
				ElseIf TRB1->DIVERG == 0		// Libera pedido de venda
					PA6->PA6_STATUS := '02'
					PA6->PA6_DESCST := "Separa็ใo Ok"
					PA6->PA6_TOQUED := date()
					PA6->PA6_TOQUEU := cUserName
					PA6->PA6_TOQUEH := left(time(),2) + substr(time(),4,2)
					LibPV()
				Else
					PA6->PA6_STATUS := '03'
					PA6->PA6_DESCST := "Separa็ใo Divergente
					PA6->PA6_TOQUED := date()
					PA6->PA6_TOQUEU := cUserName
					PA6->PA6_TOQUEH := left(time(),2) + substr(time(),4,2)
					_cDiverg += PA6->PA6_NUMROM + ' /'
				EndIf
				
			Else 				//Recebimento
			
				If TRB1->DIVERG == 0
					PA6->PA6_STATUS := "05"	
					PA6->PA6_DESCST := "Recebimento Ok"
				EndIf
			
			EndIf
			
			MsUnlock()
		EndIf
		
		DbSelectArea('TRB')
		DbSkip()
		
	EndDo
	
	DbSelectArea('TRB1')
	DbSkip()
	
EndDo

DbCloseArea()

If !empty(_cDiverg)                                                                                 
	_cDiverg := "Foram encontradas diverg๊ncias entre os itens/quantidades do(s) romaneio(s) e separa็ใo." + _cEnter + _cEnter + "Romaneio(s): " + left(_cDiverg,len(_cDiverg)-2)
	MsgBox(_cDiverg,'ATENวรO!!!!','ALERT' )
EndIf

oDlg:End()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLibPV     บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de liberacao dos itens dos pedidos de venda por cada บฑฑ
ฑฑบ          ณromaneio no momento da separacao                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LibPV()
///////////////////////

Local nX      := 0
Local cPedido := Left(PA6->PA6_NUMROM,Len(PA6->PA6_NUMROM)-2)

SC6->( DbSetOrder(2) ) //C6_FILIAL + C6_PRODUTO + C6_NUM + C6_ITEM
SC9->( DbSetOrder(1) ) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO

_cSelect := "SELECT *"
_cSelect += _cEnter + " FROM " + RetSqlName('PA6') + " PA6 (NOLOCK)"
_cSelect += _cEnter + " INNER JOIN " + RetSqlName('PA7') + " PA7 (NOLOCK)"
_cSelect += _cEnter + " ON PA7.D_E_L_E_T_ = '' "
_cSelect += _cEnter + " AND PA7_NUMROM = PA6_NUMROM"
_cSelect += _cEnter + " WHERE PA6.D_E_L_E_T_ = '' AND"
_cSelect += _cEnter + " PA6_OK = '" + cMarca + "'"           

DbUseArea(.T., "TOPCONN", TCGenQry(,,_cSelect), 'LIBPV', .F., .T.)

Do While !eof()                                                                                                                   

	If LIBPV->PA7_QUANT == LIBPV->PA7_QTDORI .and. SC6->( DbSeek( LIBPV->PA6_FILDES + left(LIBPV->PA6_NUMROM,6),.f. ) )

		Reclock("SC6",.F.)
		SC6->C6_OP 	   := "02"
		SC6->C6_QTDEMP := SC6->C6_QTDVEN
		Msunlock()
		
		Reclock("SC9",!SC9->( DbSeek( xFilial("SC9") + SC6->C6_NUM + SC6->C6_ITEM + "01" + SC6->C6_PRODUTO,.f. ) ))
		
		SC9->C9_FILIAL 	:= xFilial("SC9")
		SC9->C9_PEDIDO	:= SC6->C6_NUM
		SC9->C9_ITEM	:= SC6->C6_ITEM
		SC9->C9_CLIENTE	:= SC6->C6_CLI
		SC9->C9_LOJA	:= SC6->C6_LOJA
		SC9->C9_PRODUTO	:= SC6->C6_PRODUTO
		SC9->C9_QTDLIB	:= SC6->C6_QTDVEN
		SC9->C9_DATALIB	:= dDatabase
		SC9->C9_SEQUEN	:= "01"
		SC9->C9_PRCVEN	:= SC6->C6_PRCVEN
		SC9->C9_LOCAL	:= "01"
		SC9->C9_TPCARGA	:= "2"
		
		Msunlock()
	
	EndIf
	
	DbSelectArea('LIBPV')
	DbSkip()
		
EndDo

DbCloseArea()

SC5->( DbSetOrder(1) )
If SC5->( DbSeek( xFilial("SC5")+cPedido,.F.) )
	
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "S"
	Msunlock()
	
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetItem  บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um vetor auxiliar com os produtos e quantidades para   บฑฑ
ฑฑบ          ณvalidar se a quantidade contada esta coerente com o romaneioบฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItem()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA7")
PA7->(DbSetOrder(1)) //PA7_FILIAL+PA7_NUMROM+PA7_CODPRO
If PA7->(DbSeek( xFilial("PA7")+PA6->PA6_NUMROM ) )
	
	While !PA7->(EOF()) .AND. PA7->(PA7_FILIAL+PA7_NUMROM) = PA6->(PA6_FILIAL+PA6_NUMROM)
		
		Aadd( aValid,{PA7->PA7_CODPRO,PA7->PA7_QUANT,PA7->PA7_QTDORI} )
		
		PA7->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxGetItem2 บAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria um vetor auxiliar com os volumes do romaneio para      บฑฑ
ฑฑบ          ณvalidar se o volume esta ou nao no romaneio.                บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function xGetItm2()
//////////////////////////

Local lRet := .T.

DbSelectArea("PA8")
PA8->(DbSetOrder(1)) //PA8_FILIAL+PA8_NUMROM+PA8_CODCOL
If PA8->(DbSeek( xFilial("PA8")+PA6->PA6_NUMROM ) )
	
	While !PA8->(EOF()) .AND. PA8->(PA8_FILIAL+PA8_NUMROM) = PA6->(PA6_FILIAL+PA6_NUMROM)
		
		Aadd( aVolumes,{PA8->PA8_CODCOL} )
		
		PA8->(DbSkip())
	EndDo
	
Else
	lRet := .F.
EndIf

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLS03REFRESบAutor  ณ Fabio Jadao Caires บ Data ณ  18/06/2007 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza o ListBox da MainWindow                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Laselva                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function LS03Refres(_lSaida)
///////////////////////////////////

Local nPos     := 0
Local lRet     := .T.
Local aArea    := GetArea()
Local aAreaSB1 := SB1->( GetArea() )

//--Consiste o Produto informado - Prioriza o Codigo de Barras:
SB1->( DbSetOrder(5) ) //--B1_FILIAL+B1_CODBAR
If !SB1->( DbSeek( xFilial('SB1') + PadR( cGetProd, Len( SB1->B1_CODBAR ) ) ) )
	SB1->( DbSetOrder(1) ) //--B1_FILIAL+B1_COD
	If !SB1->( DbSeek( xFilial('SB1') + PadR( cGetProd, Len( SB1->B1_COD ) ) ) )
		lRet := .F.
		Help( ' ', 1, 'REGNOIS',,'=> '+cGetProd, 5, 0 )
	EndIf
EndIf

If lRet
	//--Verifica a expressao digitada X Codigo de barras
	nPos := AScan( aListBox1, {|x| PadR( x[3], Len(SB1->B1_CODBAR) ) == PadR( cGetProd, Len(SB1->B1_CODBAR) )} )
	If nPos == 0
		//--Verifica a expressao digitada X Codigo do Produto
		nPos := AScan( aListBox1, {|x| PadR( x[2], Len(SB1->B1_COD) ) == PadR( cGetProd, Len(SB1->B1_COD) )} )
		If nPos == 0
			Alert("O produto "+Alltrim(cGetProd)+" nใo faz parte do romaneio.")
			lRet := .F.
		EndIf
	EndIf
	
	nQtdProd := 0
	If nPos > 0 .and. lRet
		nQtdProd := aListBox1[nPos,5]
		
		If !Empty(nQtd)
			nQtdProd := Val(nQtd)
		Else
			nQtdProd++
		EndIf
		
		aListBox1[nPos,5] := nQtdProd
		aListBox1[nPos,1] := oCont
		
		DbSelectArea('PA6')
		DbSetOrder(2)
		If DbSeek(xfilial('PA6') + aListBox1[nPos,6],.f.)
			RecLock('PA6',.f.)
			If _lSaida
				PA6->PA6_STATUS := iif(nQtdProd == PA7->PA7_QTDORIG .and. PA6->PA6_STATUS == '02', '02','03')
				PA6->PA6_DESCST := iif(PA6->PA6_STATUS == '02', 'Separa็ใo OK','Separa็ใo Divergente')
			Else
				PA7->PA7_QTDREC := aListBox1[nPos,5]
			EndIf
			MsUnLock()
		EndIf
		
		DbSelectArea('PA7')
		If DbSeek(xfilial('PA7') + aListBox1[nPos,6] + aListBox1[nPos,2],.f.)
			RecLock('PA7',.f.)
			If _lSaida
				PA7->PA7_QUANT  := aListBox1[nPos,5]
			Else
				PA7->PA7_QTDREC := aListBox1[nPos,5]
			EndIf
			MsUnLock()
		EndIf
	EndIf

	_cProd := alltrim(SB1->B1_DESC) + ' - ' + alltrim(nQtdProd)
	oDlg:Refresh()
	
EndIf

cGetProd  := Space( Len( SB1->B1_CODBAR) )
nQtd      := Space(5)

//--Atualiza os objetos da tela
oGetQtd:Refresh()
oGetProd:Refresh()
oListBox1:Refresh()
oGetProd:SetFocus()

//--Restaura o ambiente
RestArea( aArea )
Return( lRet )



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function VldDlg3()
///////////////////////////
Local _lRet := .t.
If nGetQtd1 <= 0
	Alert("Informe a quantidade do volumes da nota fiscal!")
	oGetQtd1:SetFocus()
	_lRet := .f.
EndIf

SC5->(DbSetOrder(1))
If _lRet .and. SC5->(DbSeek(right(PA6->PA6_NUMROM,2) + left(PA6->PA6_NUMROM,6),.f.))
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

Return(_lRet)

/*/
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณFuno    ณPA6Leg    ณAutor  ณ Fabio Jadao Caires    ณ Data ณ15.06.2007 ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณ          ณDemonstra a legenda das cores da mbrowse                     ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณParametrosณNenhum                                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณRetorno   ณNenhum                                                       ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescrio ณEsta rotina monta uma dialog com a descricao das cores da    ณฑฑ
ฑฑณ          ณMbrowse.                                                     ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑณ          ณ                                                             ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณUso       ณ Laselva Bookstore                                           ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
User Function ls_PA6Leg()
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
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑฺฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฟฑฑ
ฑฑณPrograma   ณ   C()   ณ Autores ณ Norbert/Ernani/Mansano ณ Data ณ10/05/2005ณฑฑ
ฑฑรฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤดฑฑ
ฑฑณDescricao  ณ Funcao responsavel por manter o Layout independente da       ณฑฑ
ฑฑณ           ณ resolucao horizontal do Monitor do Usuario.                  ณฑฑ
ฑฑภฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤูฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณTratamento para tema "Flat"ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If "MP8" $ oApp:cVersion
	If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()
		nTam *= 0.90
	EndIf
EndIf

Return Int(nTam)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Static Function TrnpRefres()
////////////////////////////

_lRet := (SA4->(DbSeek(xFilial('SA4') + cGetTrans,.f.)))

If !_lRet
	cGetTrans := '      '
	cGetNTran := 'TRANSPORTADORA INVมLIDA'
	oGetTrb:SetFocus()
Else
	cGetNTran := SA4->A4_NOME
EndIf
	
oGetTrb:Refresh()
oGetTra:Refresh()

Return(_lRet)
