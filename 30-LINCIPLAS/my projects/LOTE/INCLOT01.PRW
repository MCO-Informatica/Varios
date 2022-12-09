#Include "Protheus.Ch"

User Function INCLOT01()
//
//+--------------------------------------------------------------------------------- 
//| Declaração das Variaveis                                                        
//+---------------------------------------------------------------------------------
Local   _aIndexSC9 := {}
Local   _cCondicao := 'C9_BLEST <> "10" .And. C9_BLCRED <> "10" '
Private cAlias     := "SC9"
Private cCadastro  := "Pedido de Venda Liberado"
Private aRotina    := {}

aAdd( aRotina, {"Pesquisar" ,"axPesqui"  ,0,1})
aAdd( aRotina, {"Visualizar","AxVisual"  ,0,2})
aAdd( aRotina, {"Altera"    ,"U_IncLot02",0,4})
aAdd( aRotina, {"Excluir"   ,"U_ExcLot02",0,4})

dbSelectArea(cAlias)
dbSetOrder(01)
dbGotop()

_bFiltraBrw := {|| FilBrowse("SC9",@_aIndexSC9,@_cCondicao) }
Eval(_bFiltraBrw)

mBrowse(,,,,calias)

EndFilBrw("SC9",_aIndexSC9)

Return
//
//+-----------------------------------------------------------------------
//| Função: IncLot02()
//|         Tem como Alterar a data de entrega do Pedido
//+-----------------------------------------------------------------------
User Function IncLot02(cAlias,nRecno,nopcx)

Local _lContinua  := .T.

Private oDlg      := Nil

Private _cNumPed  := SC9->C9_PEDIDO
Private _cItemPV  := SC9->C9_ITEM
Private _cProduto := SC9->C9_PRODUTO
Private _cNomCli  := GetAdvFVal("SA1","A1_NOME",xFilial("SA1")+SC9->C9_CLIENTE+SC9->C9_LOJA,1,Space(40))
Private _cDescPro := GetAdvFVal("SB1","B1_DESC",xFilial("SB1")+_cProduto,1,Space(50))

Private _cX01Lote := Space(06)
Private _cX02Lote := Space(06)
Private _cX03Lote := Space(06)
Private _cX04Lote := Space(06)

Private _cXOP01   := Space(13)
Private _cXOP02   := Space(13)
Private _cXOP03   := Space(13)
Private _cXOP04   := Space(13)
//+-----------------------------------------------------------------------
//| Valida se Pedido Faturado
//+-----------------------------------------------------------------------
If SC9->C9_BLEST == "10" .And. SC9->C9_BLCRED == "10"
	_lContinua := .F.
Endif

If !_lContinua
	MsgAlert("Esse Item do Pedido de Venda Ja Foi Faturado.... As alteracoes nao serao processadas...")
	Return
EndIf

If !Empty(SC9->C9_XLOTE01) .Or. !Empty(SC9->C9_XLOTE02) .Or. !Empty(SC9->C9_XLOTE03) .Or. !Empty(SC9->C9_XLOTE04)
	_lContinua := .F.
Endif

If !_lContinua
	MsgAlert("Pedido Ja Possui Amarração com Lotes... Exclua a amarração para poder refazer...")
	Return
EndIf
//
//+--------------------------------------------------------------------
//| Definição da Janela 
//+--------------------------------------------------------------------
//Define msDialog oDlg Title "Atualiza Data de entrega dos PV" from 0,0 to 220,552 of oDlg Pixel
Define msDialog oDlg Title "Atualiza Lote dos PVs Liberados" from 0,0 to 400,850 of oDlg Pixel

@ 006,006 To 065,410 Label "  DADOS DO PEDIDO  " of oDlg Pixel

@ 017,015 Say "Num. / Item PV"           Size 045,010 Pixel of oDlg
@ 017,065 Say _cNumPed+" / "+_cItemPV    Size 060,010 Pixel of oDlg

@ 032,015 Say "Cliente"         Size 045,010 Pixel of oDlg
@ 032,065 Say _cNomCli          Size 200,010 Pixel of oDlg

@ 047,015 Say "Produto"         Size 045,010 Pixel of oDlg
@ 047,065 Say _cProduto         Size 040,010 Pixel of oDlg
@ 047,100 Say _cDescPro         Size 200,010 Pixel of oDlg

@ 075,006 To 160,410 Label "  INFORME OS LOTES  " of oDlg Pixel

@ 090,015 Say "Lote 01"         Size 045,010 Pixel of oDlg
@ 105,015 Say "Lote 02"         Size 045,010 Pixel of oDlg
@ 120,015 Say "Lote 03"         Size 045,010 Pixel of oDlg
@ 135,015 Say "Lote 04"         Size 045,010 Pixel of oDlg

@ 090,065 MsGet _cX01Lote       Picture "@!" F3 "SZC002"  Valid ValXOP01(_cX01Lote) Size 040,010 Pixel of oDlg
@ 105,065 MsGet _cX02Lote       Picture "@!" F3 "SZC002"  Valid ValXOP02(_cX02Lote) Size 040,010 Pixel of oDlg
@ 120,065 MsGet _cX03Lote       Picture "@!" F3 "SZC002"  Valid ValXOP03(_cX03Lote) Size 040,010 Pixel of oDlg
@ 135,065 MsGet _cX04Lote       Picture "@!" F3 "SZC002"  Valid ValXOP04(_cX04Lote) Size 040,010 Pixel of oDlg

//+--------------------------------------------------------------------
//| Botoes da msDialog
//+--------------------------------------------------------------------
@ 170,285 Button "&OK"       Size 36,16 Pixel of oDlg Action (nOpc:=ValOk(),If(nOpc,oDlg:End(),Nil))	//(nOpc:=Processa({|| OkProc()}),If(nOpc,oDlg:End(),Nil))
@ 170,335 Button "&Cancelar" Size 36,16 Pixel of oDlg Action oDlg:End()

Activate msDialog oDlg Center

Return

//+-----------------------------------------------------------------------
//| Função: ValOk()
//|         Tem como objetivo Validar Confirmação
//+-----------------------------------------------------------------------
Static Function ValOk()
//
//If Empty(_dDatEnt)
//	Return(.F.)
//Endif	
//
//Processa({|| OkProc()})
//
RecLock("SC9",.F.)
SC9->C9_XLOTE01 := _cX01Lote
SC9->C9_XLOTE02 := _cX02Lote
SC9->C9_XLOTE03 := _cX03Lote
SC9->C9_XLOTE04 := _cX04Lote

SC9->C9_XOP01   := _cXOP01
SC9->C9_XOP02   := _cXOP02
SC9->C9_XOP03   := _cXOP03
SC9->C9_XOP04   := _cXOP04
MsUnlock()

If !(Empty(_cX01Lote))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+_cX01Lote+_cXOP01)
    Do While !Eof() .And. AllTrim(_cX01Lote) == SZC->ZC_LOTEOP .And. AllTrim(_cXOP01) == SZC->ZC_OP
        If SZC->ZC_STATUS == "05"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := SC9->C9_PEDIDO
            SZC->ZC_ITEMPV := SC9->C9_ITEM
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV + SC9->C9_QTDLIB
            SZC->ZC_STATUS := "06"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo
EndIf

If !(Empty(_cX02Lote))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+_cX02Lote+_cXOP01)
    Do While !Eof() .And. AllTrim(_cX02Lote) == SZC->ZC_LOTEOP .And. AllTrim(_cXOP01) == SZC->ZC_OP
        If SZC->ZC_STATUS == "05"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := SC9->C9_PEDIDO
            SZC->ZC_ITEMPV := SC9->C9_ITEM
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV + SC9->C9_QTDLIB
            SZC->ZC_STATUS := "06"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo
EndIf

If !(Empty(_cX03Lote))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+_cX03Lote+_cXOP01)
    Do While !Eof() .And. AllTrim(_cX03Lote) == SZC->ZC_LOTEOP .And. AllTrim(_cXOP01) == SZC->ZC_OP
        If SZC->ZC_STATUS == "05"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := SC9->C9_PEDIDO
            SZC->ZC_ITEMPV := SC9->C9_ITEM
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV + SC9->C9_QTDLIB
            SZC->ZC_STATUS := "06"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo
EndIf

If !(Empty(_cX04Lote))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+_cX04Lote+_cXOP01)
    Do While !Eof() .And. AllTrim(_cX04Lote) == SZC->ZC_LOTEOP .And. AllTrim(_cXOP01) == SZC->ZC_OP
        If SZC->ZC_STATUS == "05"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := SC9->C9_PEDIDO
            SZC->ZC_ITEMPV := SC9->C9_ITEM
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV + SC9->C9_QTDLIB
            SZC->ZC_STATUS := "06"
            MsUnlock()
        EndIf
        dbSkip()
    EndDo
EndIf

MsgAlert("Alteracoes Processadas com Sucesso...")

Return(.T.)
//
//
Static Function ValXOP01(_cX01Lote)
Local   _lRet     := .T.
Private _cNumLote := _cX01Lote
Private _aArea    := GetArea()
Private _aAreaZC  := {}

_cXOP01 := Space(13)

dbSelectArea("SZC")
_aAreaZC := GetArea()
dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
If dbSeek(xFilial("SZC")+_cNumLote,.T.)
    _cXOP01 := SZC->ZC_OP
Else
    Alert("Lote Não Encontrado...")
    _lRet := .F.
EndIf

Return(_lRet)
//
//
Static Function ValXOP02(_cX02Lote)
Local   _lRet     := .T.
Private _cNumLote := _cX02Lote
Private _aArea    := GetArea()
Private _aAreaZC  := {}

_cXOP02 := Space(13)

dbSelectArea("SZC")
_aAreaZC := GetArea()
dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
If dbSeek(xFilial("SZC")+_cNumLote,.T.)
    _cXOP02 := SZC->ZC_OP
Else
    Alert("Lote Não Encontrado...")
    _lRet := .F.
EndIf

Return(_lRet)
//
//
Static Function ValXOP03(_cX03Lote)
Local   _lRet     := .T.
Private _cNumLote := _cX03Lote
Private _aArea    := GetArea()
Private _aAreaZC  := {}

_cXOP03 := Space(13)

dbSelectArea("SZC")
_aAreaZC := GetArea()
dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
If dbSeek(xFilial("SZC")+_cNumLote,.T.)
    _cXOP03 := SZC->ZC_OP
Else
    Alert("Lote Não Encontrado...")
    _lRet := .F.
EndIf

Return(_lRet)
//
//
Static Function ValXOP04(_cX04Lote)
Local   _lRet     := .T.
Private _cNumLote := _cX04Lote
Private _aArea    := GetArea()
Private _aAreaZC  := {}

_cXOP04 := Space(13)

dbSelectArea("SZC")
_aAreaZC := GetArea()
dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
If dbSeek(xFilial("SZC")+_cNumLote,.T.)
    _cXOP04 := SZC->ZC_OP
Else
    Alert("Lote Não Encontrado...")
    _lRet := .F.
EndIf

Return(_lRet)
//
//
User Function ExcLot02(cAlias,nRecno,nopcx)
If !(Empty(SC9->C9_XLOTE01))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+SC9->C9_XLOTE01+SC9->C9_XOP01)
    Do While !Eof() .And. AllTrim(SC9->C9_XLOTE01) == AllTrim(SZC->ZC_LOTEOP) .And. AllTrim(SC9->C9_XOP01) == SZC->ZC_OP
        If SZC->ZC_STATUS == "06"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := Space(06)
            SZC->ZC_ITEMPV := Space(02)
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV - SC9->C9_QTDLIB
            SZC->ZC_STATUS := "05"
            MsUnlock()
        EndIf
    EndDo
EndIf

If !(Empty(SC9->C9_XLOTE02))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+SC9->C9_XLOTE02+SC9->C9_XOP02)
    Do While !Eof() .And. AllTrim(SC9->C9_XLOTE02) == AllTrim(SZC->ZC_LOTEOP) .And. AllTrim(SC9->C9_XOP02) == SZC->ZC_OP
        If SZC->ZC_STATUS == "06"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := Space(06)
            SZC->ZC_ITEMPV := Space(02)
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV - SC9->C9_QTDLIB
            SZC->ZC_STATUS := "05"
            MsUnlock()
        EndIf
    EndDo
EndIf

If !(Empty(SC9->C9_XLOTE03))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+SC9->C9_XLOTE03+SC9->C9_XOP03)
    Do While !Eof() .And. AllTrim(SC9->C9_XLOTE03) == AllTrim(SZC->ZC_LOTEOP) .And. AllTrim(SC9->C9_XOP03) == SZC->ZC_OP
        If SZC->ZC_STATUS == "06"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := Space(06)
            SZC->ZC_ITEMPV := Space(02)
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV - SC9->C9_QTDLIB
            SZC->ZC_STATUS := "05"
            MsUnlock()
        EndIf
    EndDo
EndIf

If !(Empty(SC9->C9_XLOTE04))
    dbSelectArea("SZC")
    dbSetOrder(9)           // ZC_FILIAL+ZC_LOTEOP+ZC_OP
    dbSeek(xFilial("SZC")+SC9->C9_XLOTE04+SC9->C9_XOP04)
    Do While !Eof() .And. AllTrim(SC9->C9_XLOTE04) == AllTrim(SZC->ZC_LOTEOP) .And. AllTrim(SC9->C9_XOP04) == SZC->ZC_OP
        If SZC->ZC_STATUS == "06"
            RecLock("SZC",.F.)
            SZC->ZC_NUMPV  := Space(06)
            SZC->ZC_ITEMPV := Space(02)
            SZC->ZC_QTDPV  := SZC->ZC_QTDPV - SC9->C9_QTDLIB
            SZC->ZC_STATUS := "05"
            MsUnlock()
        EndIf
    EndDo
EndIf

RecLock("SC9",.F.)
SC9->C9_XLOTE01 := Space(06)
SC9->C9_XLOTE02 := Space(06)
SC9->C9_XLOTE03 := Space(06)
SC9->C9_XLOTE04 := Space(06)

SC9->C9_XOP01   := Space(13)
SC9->C9_XOP02   := Space(13)
SC9->C9_XOP03   := Space(13)
SC9->C9_XOP04   := Space(13)
MsUnlock()

MsgAlert("Exclusão Processada com Sucesso...")

Return(.T.)