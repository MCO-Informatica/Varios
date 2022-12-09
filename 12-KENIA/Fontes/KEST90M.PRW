#INCLUDE "rwmake.ch"
#INCLUDE "TOTVS.CH"
#INCLUDE "PROTHEUS.CH"

User Function KEST90M()

Private oDlg
Private cProduto	:= Space(15)
Private cDescricao	:= Space(40)
Private cRastro		:= Space(1)

DEFINE MSDIALOG oDlg TITLE 'Zera Inventário por Produto' FROM 8,0 TO 18, 80 of oDlg

@ 30, 010 SAY "Produto" SIZE 70, 15 PIXEL OF oDlg
@ 28, 050 MSGET cProduto F3 "SB1" VALID ExisPrd(cProduto, @cDescricao) SIZE 060,10 PIXEL OF oDlg
@ 28, 140 MSGET cDescricao WHEN .F. SIZE 160,10 PIXEL OF oDlg

ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || (Processa( {|| cBuscaB8()},"Gerando Inventário Zerado..."  ),oDlg:End())}, {||oDlg:End()},,) CENTERED


Return

Static Function cBuscaB8()

//VERIFICA SE TEM CONTROLE DE LOTE
If cRastro$"SL"
	_cQuery := "Select B8_PRODUTO,B8_LOCAL,B8_LOTECTL,B8_DTVALID from "+RetSqlName("SB8")+" B8 "
	_cQuery += "Where B8_SALDO > 0 AND B8.D_E_L_E_T_ = ' ' "
	_cQuery += "AND B8_PRODUTO = '"+cProduto+"' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)
	DbSelectArea("TRB")
	
	TcSetField("TRB","B8_DTVALID","D",TamSX3("B8_DTVALID")[1],TamSX3("B8_DTVALID")[2])

	dbGoTop()
	
	Do While !TRB->(Eof()) .And. cProduto == TRB->B8_PRODUTO
		
		dbSelectArea("SB7")
		RecLock("SB7",.T.)
		SB7->B7_FILIAL				:= xFilial("SB7")
		SB7->B7_COD					:= TRB->B8_PRODUTO
		SB7->B7_LOCAL           	:= TRB->B8_LOCAL
		SB7->B7_TIPO              	:= Posicione("SB1",1,xFilial("SB1")+TRB->B8_PRODUTO,"B1_TIPO")
		SB7->B7_DOC               	:= "INVENT"
		SB7->B7_QUANT        		:= 0
		SB7->B7_DATA            	:= dDataBase
		SB7->B7_LOTECTL       		:= TRB->B8_LOTECTL
		SB7->B7_DTVALID				:= TRB->B8_DTVALID
		MsUnlock()
		TRB->(dbSkip())
	EndDo
Else
	_cQuery := "Select B2_COD,B2_LOCAL FROM "+RetSqlName("SB2")+" B2 "
	_cQuery += "Where B2_QATU <> 0 AND B2.D_E_L_E_T_ = ' ' "
	_cQuery += "AND B2_COD = '"+cProduto+"' "
	
	If Select("TRB") > 0
		TRB->(DbCloseArea())
	EndIf
	
	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),"TRB",.F.,.T.)
	DbSelectArea("TRB")
	dbGoTop()
	
	Do While !TRB->(Eof()) .And. cProduto == TRB->B2_COD
		
		dbSelectArea("SB7")
		RecLock("SB7",.T.)
		SB7->B7_FILIAL				:= xFilial("SB7")
		SB7->B7_COD					:= TRB->B2_COD
		SB7->B7_LOCAL           	:= TRB->B2_LOCAL
		SB7->B7_TIPO              	:= Posicione("SB1",1,xFilial("SB1")+TRB->B2_COD,"B1_TIPO")
		SB7->B7_DOC               	:= "INVENT"
		SB7->B7_QUANT        		:= 0
		SB7->B7_DATA            	:= dDataBase
		MsUnlock()
		TRB->(dbSkip())
	EndDo
	
EndIf

Return

Static Function ExisPrd()

Local lRet := .F.

dbSelectArea("SB1")
dbSetOrder(1)
If !dbSeek(xFilial("SB1")+cProduto)
	Alert("Produto não existe. Aperte F3 e consulte o produto.")
	lRet := .F.
Else
	cDescricao 	:= SB1->B1_DESC
	cRastro 	:= SB1->B1_RASTRO
	lRet 		:= .T.
Endif

Return (lRet)
