#Include 'Protheus.ch'
#include "rwmake.ch"

User Function zFilInv()

	Local aGetArea := GetArea()
	Local oBrowCons
	Local aMat:={}
	Local lOpc:=.F.
	Local aInd:={}


	if EMPTY(_cRetorno)
		_cRetorno := M->ZZC_PEDIDO
	endif

	dbSelectArea("ZZC")
	dbSelectArea("SC6")
	dbSelectArea("SB1")
	//cRetorno :=  AScan(aHeader,{|x| Trim(x[2])=="ZZC_PEDIDO"})

	//msginfo ( _cRetorno )

	if Empty(_cRetorno)
		SB1->(DbClearFilter())

		Aadd(aMat,{"B1_COD" 	, "Produto" 	, "@!" , "C", 30, 0})
		Aadd(aMat,{"B1_DESC" 	, "Descricao" 	, "@!" , "C", 80, 0})

		cCondicao:= "SB1->B1_COD >= '' .and. SB1->B1_COD <= 'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ'  "

		bFiltraBrw := {|| FilBrowse("SB1",@aInd,@cCondicao) }
		Eval(bFiltraBrw)

		@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Produtos / Itens de Pedido  "

		@ 006, 005 TO 190, 370 BROWSE "SB1" FIELDS aMat OBJECT oBrowCons

	else

		SC6->(DbClearFilter())

		Aadd(aMat,{"C6_PRODUTO" , "Produto" 	, "@!" , "C", 30, 0})
		Aadd(aMat,{"C6_DESCRI" 	, "Descricao" 	, "@!" , "C", 80, 0})

		cCondicao:= "SC6->C6_NUM == _cRetorno  "

		bFiltraBrw := {|| FilBrowse("SC6",@aInd,@cCondicao) }
		Eval(bFiltraBrw)

		@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Produtos / Itens de Pedido  "

		@ 006, 005 TO 190, 370 BROWSE "SC6" FIELDS aMat OBJECT oBrowCons
	endif

	//@ 050, 004 TO 500, 750 DIALOG oDlgPrd TITLE "Consulta Produtos / Itens de Pedido  "

	//if Empty(_cRetorno)
		//@ 006, 005 TO 190, 370 BROWSE "SB1" FIELDS aMat OBJECT oBrowCons
	//else
		//@ 006, 005 TO 190, 370 BROWSE "SC6" FIELDS aMat OBJECT oBrowCons
	//endif


	@ 200, 120 BUTTON "_Pesq Pedido de Venda" SIZE 60, 13 ACTION PesqCodSC6()
	@ 200, 190 BUTTON "_Pesq Codigo Produto" SIZE 60, 13 ACTION PesqProd()
	@ 200, 260 BUTTON "_Ok" SIZE 40, 13 ACTION (Close(oDlgPrd), lOpc:=.T.)
	@ 200, 310 BUTTON "_Sair" SIZE 40, 13 ACTION Close(oDlgPrd)

	oDlgPrd:lCentered := .t.
	oDlgPrd:Activate()

	//alert('Produto escolhido: '+SB1->B1_DESC)

	//_cRetorno := ""

	SC6->(DbClearFilter())
	SB1->(DbClearFilter())

	_cRetorno := ""

Return lOpc


Static Function PesqCodSC6()

		Local cCondicao:=''
		Local cGet:=Space(06)
		Local aInd:={}

		DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa por Pedido:" PIXEL OF oMainWnd
		@ 8,11 TO 71,122
		@ 13,15 SAY "Expressão: "
		@ 13,50 GET cGet picture "@!" SIZE 60,30
		@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

		Activate MsDialog oDlgPesq Centered

		If !Empty(cGet)
			SC6->(dbSetOrder(2))
			SC6->(dbSeek(xFilial("SC6")+cGet))
		endif

Return


Static Function PesqProd()

		Local cGet:=Space(30)

		DEFINE MSDIALOG oDlgPesq FROM 96,42 TO 250,305 TITLE "Pesquisa Codigo Produto" PIXEL OF oMainWnd
		@ 8,11 TO 71,122
		@ 13,15 SAY "Expressão: "
		@ 13,50 GET cGet picture "@!" SIZE 60,30
		@ 40,55 BMPBUTTON TYPE 01 ACTION oDlgPesq:End()

		Activate MsDialog oDlgPesq Centered

		if !Empty(_cRetorno)
			If !Empty(cGet)
			SC6->(dbSetOrder(2))
			SC6->(dbSeek(xFilial("SC6")+cGet))
			endif
		else
			If !Empty(cGet)
			SB1->(dbSetOrder(1))
			SB1->(dbSeek(xFilial("SB1")+cGet))
			endif
		Endif

Return










