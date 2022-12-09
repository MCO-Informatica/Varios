#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "JPEG.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"

#DEFINE  ENTER CHR(13)+CHR(10)

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑบPrograma  |SFATA003   บAutor  ณFelipe Valenca      บ Data ณ  05/04/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Tela cotendo resumo de metas por regiao...                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Shangri-la                                                     บฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
*---------------------*
User Function SHFAT002(cCodigo,cAno,nTotal)
*---------------------*

Local aArea 	:= GetArea()
Local aAlias	:= {}

Local cCadastro := "Rateio de Metas - Previsใo"
Local nDeleted2 := 0

Private nRateTot  := Round(nTotal,2)
Private oDlg
Private _oBrowse1
Private _aBrowse1 := {}

DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD
Private nOpcx := 0

Private	cGetReg	  := " "

Private _aBrwREG  := {}
Private _oBrwREG

Private _aBrwVEN  := {}
Private _oBrwVEN

Private _aBrwGRP  := {}
Private _oBrwGRP

Private _aBrwMET  := {}
Private _oBrwMET

Private _aBrwCUM  := {}
Private _oBrwCUM

Private _cQryZ5 := ''
Private _aVend := {}
Private _aRegiao	:= {}

Private _cRegiao	:= ""
Private _cVend		:= ""
Private _nTotPrd 	:= 0
Private _TotPrev	:= 0

Private oOK := LoadBitmap(GetResources(),'br_verde')
Private oNO := LoadBitmap(GetResources(),'br_vermelho')

Private lTotReg := .T.


DEFINE FONT oFont5 NAME "Verdana" SIZE 10,20 BOLD

/* MONTA ESTRUTRA DA TELA */
DEFINE MSDIALOG oDlg FROM 09,00 TO 042,136 TITLE cCadastro OF oMainWnd


@ 006,006 TO 250, 537 OF oDlg	PIXEL /** BOX 1 **/
@ 007,240 SAY OemToAnsi("Rateio Previsใo") FONT oFont5 OF oDlg PIXEL COLOR CLR_HBLUE
@ 017,006 TO 027.5, 537 OF oDlg	PIXEL /** Linha Cabec **/

If Len(_aBrwVEN) <= 0
	SZA->(DbSetORder(1))
	For nX:= 1 to 12
		If SZA->(DbSeek(xFilial('SZA') + cCodigo + cAno + cValToChar(StrZero(nX,2)) ))
			aADD(_aBrwVEN,{.T.,cCodigo,cAno,cValToChar(StrZero(nX,2)),SZA->ZA_PERC,SZA->ZA_VALOR})
		Else
			aADD(_aBrwVEN,{.T.,cCodigo,cAno,cValToChar(StrZero(nX,2)),0,0})
		EndIf
	Next nX
	aADD(_aBrwVEN,{.F.,'Total','','',0,0})
Endif

&& Cria Browser
_oBrwVEN := TCBrowse():New(033,012,518,180,,{'',"C๓digo","Ano","Mes","Percentual","Valor"},{20,40,40,40,40,40},	,,,,,{||},,,,,,,.F.,,.T.,,.F.,,, )

&& Seta vetor para a browse
_oBrwVEN:SetArray(_aBrwVEN)

_oBrwVEN:bLine := {||{If(_aBrwVEN[_oBrwVEN:nAt,01],oOK,oNO),_aBrwVEN[_oBrwVEN:nAt,02],_aBrwVEN[_oBrwVEN:nAt,03],_aBrwVEN[_oBrwVEN:nAt,04],Transform(_aBrwVEN[_oBrwVEN:nAt,05],"@E 999.99"),Transform(_aBrwVEN[_oBrwVEN:nAt,06],"@E 999,999,999.99")}}

&& Evento de duploclick
_oBrwVEN:bLDblClick   := {|| xDuplVEN(_oBrwVEN:ColPos)}


ACTIVATE MSDIALOG oDlg  CENTERED ON INIT EnchoiceBar(oDlg,{|| BotOk()},{|| oDlg:End()})

Return(.T.)

&&ROTINA PARA VALIDAR O DUPLO CLICK DO PERCENTUAL
Static Function xDuplVEN(_xColuna)
Local lRet := .T.
Local cData:= _aBrwVEN[_oBrwVEN:nAt][3]+_aBrwVEN[_oBrwVEN:nAt][4]+'01'
Local lMesAnt := SuperGetMv('ZZ_ALTRAT',.F.,.T.)

If _xColuna == 5
	If STOD(cData) >= FirstDay(Date()) .Or. lMesAnt
		xSemaOkVEN(lEditCell( @_aBrwVEN, _oBrwVEN,"@E 999.99", _oBrwVEN:ColPos,,,))
	EndIF
Endif

Return lRet

Static Function xSemaOkVEN()
Local lRet := .T.

_nSomaMet := 0

For _nY := 1 to Len(_aBrwVEN)-1
	If _aBrwVEN[_nY,01] == .T.
		_nSomaMet += _aBrwVEN[_nY][5]
		_aBrwVEN[_nY][6] := Round((nRateTot * _aBrwVEN[_nY][5])/100,1)
	Endif
Next

lRet := ValidVend()

If _nSomaMet <> 100
	_aBrwVEN[Len(_aBrwVEN),01] := .F.
Else
	_aBrwVEN[Len(_aBrwVEN),01] := .T.
Endif
_oBrwVEN:Refresh()

Return lRet

Static Function ValidVend()

Local _nSomaMet := 0
Local _nSomaTot := 0
Local _lRet := .T.
Local nPerc   := 0

_oBrwVEN:Refresh()

For _nY := 1 to Len(_aBrwVEN)-1
	_nSomaMet += _aBrwVEN[_nY][5]
	_nSomaTot += _aBrwVEN[_nY][6]
Next

_aBrwVEN[Len(_aBrwVEN)][5] := _nSomaMet
_aBrwVEN[Len(_aBrwVEN)][6] := _nSomaTot
_oBrwVEN:Refresh()

If _nSomaMet > 100
	Alert("Aten็ใo! Porcentagem superior a 100%")
	_lRet := .F.
Endif


Return _lRet

Static Function BotOK()
Local lRet := .T.
Local aPrevisao := {}

lRet := ValidVend()

If lRet
	oDlg:End()
	Processa({|lEnd| U_SHGRMETA()})
EndIf

Return

User Function SHGRMETA()
Local lRet := .T.
Local aMata700 := {}
Local nX := 0
Local nOpc   := 3
Local nQtd   := 0
Private lMsErroAuto := .F.
Private lMsHelpAuto := .T.

SZ6->(DbSetOrder(1))
ProcRegua(Len(_aBrwVEN)-1)

For nX := 1 to Len(_aBrwVEN)-1
	SZA->(DbSetORder(1))
	If SZA->(DbSeek(xFilial('SZA') + _aBrwVEN[nX,2] + _aBrwVEN[nX,3] + _aBrwVEN[nX,4]))
		lReclock := .F.
	Else
		lReclock := .T.
	EndIf
	If Reclock('SZA',lReclock)
		SZA->ZA_CODIGO := _aBrwVEN[nX,2]
		SZA->ZA_ANO    := _aBrwVEN[nX,3]
		SZA->ZA_MES    := _aBrwVEN[nX,4]
		SZA->ZA_PERC   := _aBrwVEN[nX,5]
		SZA->ZA_VALOR  := _aBrwVEN[nX,6]
		MsUnlock()
	EndIf
	
	If SZ6->(DbSeek(xFilial('SZ6') + _aBrwVEN[nX,2]))
		
		Do While !SZ6->(Eof()) .And. Alltrim(SZ6->Z6_CODIGO) == Alltrim(_aBrwVEN[nX,2])
			
			If _aBrwVEN[nX][5] > 0
				aMata700 := {}
				
				IncProc("Processando Rateio M๊s: " + _aBrwVEN[nX,4] )
				
				SC4->(DbSetOrder(1))
				If !SC4->(DbSeek(xFilial('SC4') + PADR(Alltrim(SZ6->Z6_PRODUTO),TAMSX3("C4_PRODUTO")[1]) + _aBrwVEN[nX,3] + _aBrwVEN[nX,4]+'01'))
					nOpc := 3
					aadd(aMata700,{"C4_FILIAL"   , '01'          	       						   , Nil})
				Else
					nOpc := 4
				EndIf
				SB1->(DbSetOrder(1))
				SB1->(DbSeek(xFilial('SB1') + SZ6->Z6_PRODUTO))
				
				nQtd := Round((SZ6->Z6_QUANT * _aBrwVEN[nX][5])/100,2)
				
				If nQtd <= 0.5
					nQtd := 1
				EndIf
				
				nValor := Round((SZ6->Z6_VALOR * _aBrwVEN[nX][5])/100,2)
				
				If nValor <= 0.5
					nValor := 1
				EndIf
				
				aadd(aMata700,{"C4_PRODUTO"  , SZ6->Z6_PRODUTO	     						   , Nil})
				aadd(aMata700,{"C4_LOCAL"    , SB1->B1_LOCPAD       				   		   , Nil})
				aadd(aMata700,{"C4_DATA"     , STOD(_aBrwVEN[nX,3] + _aBrwVEN[nX,4]+'01') 	   , Nil})
				aadd(aMata700,{"C4_OBS"      , 'RATEIO META ANO ' + Alltrim(_aBrwVEN[nX][3])   , Nil})
				aadd(aMata700,{"C4_QUANT"    , nQtd											   , Nil})
				aadd(aMata700,{"C4_VALOR"    , nValor  , Nil})
				aadd(aMata700,{"C4_VLRBUDG"  , Round((SZ6->Z6_VALOR * _aBrwVEN[nX][5])/100,2)  , Nil})
				aadd(aMata700,{"C4_QTDBUDG"  , Round((SZ6->Z6_QUANT * _aBrwVEN[nX][5])/100,2)  , Nil})
				aadd(aMata700,{"C4_PMVBUDG"  , Round(SZ6->Z6_VLRPMV,2)  					   , Nil})
				
				&&MSExecAuto({|x,y|MATA700(x,y)}, aMata700, 3)
				MATA700(aMata700,nOpc)
				
				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
					lRet := .F.
				EndIf
			EndIf
			SZ6->(DbSkip())
		EndDo
	EndIf
Next

Return lRet
