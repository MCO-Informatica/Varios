#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ CesGrvNf ³ Autor ³   Giorgi Medeiros     ³ Data ³ 03.11.03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Inclusao Automatica de Nota Fiscal de simples remessa	      |±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function FATP003(cNumPed)
                   
Local cSerie	:= GetMv("MV_SERDSC")
Local aPvlNfs 	:= {}
Local nPrcVen 	:= 0
nItemNf 		:= a460NumIt(cSerie)

DbSelectArea("SC5")
SC5->(DbSetOrder(1))
SC5->(MsSeek(xFilial("SC5") + cNumPed))

DbSelectArea("SC6")
SC6->(dbSetOrder(1))
SC6->(MsSeek(xFilial("SC6")+ cNumPed))

DbSelectArea("SC9")
SC9->(DbSetOrder(1))
DbSelectArea("SE4")
SE4->(DbSetOrder(1))
DbSelectArea("SB1")
SB1->(DbSetOrder(1))
DbSelectArea("SB2")
SB2->(DbSetOrder(1))
DbSelectArea("SF4")
SF4->(DbSetOrder(1))

While SC6->(!Eof() .And. C6_FILIAL == xFilial("SC6")) .And.;
	SC6->C6_NUM == cNumPed
	
	SC9->(MsSeek(xFilial("SC9")+SC6->(C6_NUM+C6_ITEM))) //FILIAL+NUMERO+ITEM
	
	SE4->(MsSeek(xFilial("SE4")+SC5->C5_CONDPAG) )  //FILIAL+CONDICAO PAGTO
	
	SB1->(MsSeek(xFilial("SB1")+SC6->C6_PRODUTO))    //FILIAL+PRODUTO
	
	SB2->(MsSeek(xFilial("SB2")+SC6->(C6_PRODUTO+C6_LOCAL))) //FILIAL+PRODUTO+LOCAL
	
	SF4->(MsSeek(xFilial("SF4")+SC6->C6_TES))   //FILIAL+TES
	
	nPrcVen := SC9->C9_PRCVEN
	If ( SC5->C5_MOEDA <> 1 )
		nPrcVen := xMoeda(nPrcVen,SC5->C5_MOEDA,1,dDataBase)
	EndIf
	
	Aadd(aPvlNfs,{ SC9->C9_PEDIDO,;
	SC9->C9_ITEM,;
	SC9->C9_SEQUEN,;
	SC9->C9_QTDLIB,;
	nPrcVen,;
	SC9->C9_PRODUTO,;
	.f.,;
	SC9->(RecNo()),;
	SC5->(RecNo()),;
	SC6->(RecNo()),;
	SE4->(RecNo()),;
	SB1->(RecNo()),;
	SB2->(RecNo()),;
	SF4->(RecNo())})
	
	If ( Len(aPvlNfs) >= nItemNf )
		cNota := MaPvlNfs(aPvlNfs,cserie , .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .T.  ,.F.,"")
		//cNota := MaPvlNfs(aPvlNfs,cSerie,lMostraCtb,lAglutCtb,lCtbOnLine,lCtbCusto,lReajusta,nCalAcrs,nArredPrcLis,lAtuSA7,lECF,cembexp)
		aPvlNfs := {}
	EndIf
	DbSelectArea("SC6")
	SC6->(DbSkip())
EndDo

cNota := MaPvlNfs(aPvlNfs,cserie, .F.    , .F.    , .F.     , .T.    , .F.    , 0      , 0          , .T.  ,.F.,"")

Return(.T.)  

User Function LibPedAuto(cNumPed)

Local nX		:= 0
Local lLiberOk  := .T.
Local lCredito  := .T.
Local lEstoque  := .T.
Local lLiber    := .T.
Local lTransf   := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³estorna itens liberados                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//DbSelectArea("SC9")
//DbSetOrder(1) //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
//If DbSeek(xFilial("SC9")+cNumPed)
	//While SC9->(!Eof()) .and. SC9->C9_PEDIDO==cNumPed
		//SC9->(a460Estorna(.T.))
		//SC9->(dbskip())
	//EndDo
//EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no SC5 e SC6                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+cNumPed)
	
	DbSelectArea("SC6")
	DbSetOrder(1)
	If  DbSeek(xFilial("SC6")+cNumPed)
		While SC6->(!Eof()) .and. SC6->C6_NUM==cNumPed
			MaLibDoFat(SC6->(RecNo()),SC6->C6_QTDVEN,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf)
			a450Grava(1,.T.,.T.)
			SC6->(dbskip())
		EndDo
		
	EndIf
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Atualiza do C5_LIBEROK e C5_STATUS                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//DbSelectArea("SC5")
	//RecLock("SC5",.F.)
	//SC5->C5_LIBEROK := "S"
	//MsUnlock()
	
EndIf

Return()