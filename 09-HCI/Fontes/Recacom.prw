#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RECACOM   ºAutor  ³Robson Bueno ilva   º Data ³  01/10/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Recalculo de comissao geral                                 º±±
±±º          ³	 v                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
  
User Function Recacom()
Local aArea      := (GetArea())   
dbSelectArea("SC5")
dbSetOrder(1)
DO WHILE (!EOF())		
  dbSelectArea("SC6")
  DbSetOrder(1)
  MsSeek(xFilial("SC6")+SC5->C5_NUM)
  DO WHILE (!Eof() .And. SC5->C5_NUM==SC6->C6_NUM)
    Retcom("SC5",1)
    dbSkip()
  EndDo
  dbSelectArea("SC5")
  dbSkip()
ENDDO








Return (.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RetComis  ºAutor  ³Joao Tavares Junior º Data ³  03/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna o percentual de comissao                            º±±
±±º          ³	 v                                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function Retcom(cAlias,nTp)

Local aAreaAnt 	:= GetArea()
Local lRet 		:= .T.
Local nComis1 	:= 0
Local nComis2 	:= 0
Local nComis3 	:= 0
Local nComis4 	:= 0
Local nComis5 	:= 0
Local cComis	:= 0
Local nX		:= 0
Local cVend		:= ""
Local cVend1	:= ""
Local cProduto	:= ""
Local cCliente	:= ""
Local cPos1		:= 0
Local cPos2		:= 0
Local cPos3		:= 0
Local cPos4		:= 0
Local cPos5    	:= 0

DEFAULT nTp		 := 1

	dbSelectArea("SC5")
  	cVend 	 :=	"SC5->C5_VEND"
	cVend1 	 :=	"SC5->C5_VEND1"
	cCliente :=	"SC5->C5_CLIENTE+M->C5_LOJACLI"
	cPos1		:= FieldPos( "C5_VEND1" )
	cPos2		:= FieldPos( "C5_VEND2" )
	cPos3		:= FieldPos( "C5_VEND3" )
	cPos4		:= FieldPos( "C5_VEND4" )
	cPos5    	:= FieldPos( "C5_VEND5" )
	dbSelectArea("SC6")
	cProduto :=	SC6->C6_PRODUTO
	cComis	 :=	SC6->C6_COMIS
	

IF Cpos1>0 
  If !Empty(&(cVEND+"1"))
    nComis1 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
    nComis1 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND1),"A3_COMIS") == 0, nComis1,Posicione("SA3",1,xFilial("SA3") + &(cVEND1),"A3_COMIS"))
    nComis1 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis1,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
  endif
endif
If cPos2  > 0
	If !Empty(&(cVEND+"2"))
		nComis2 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis2 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"2"),"A3_COMIS") == 0, nComis2,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"2"),"A3_COMIS"))
		nComis2 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis2,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos3  > 0
	If !Empty(&(cVEND+"3"))
		nComis3 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis3 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"3"),"A3_COMIS") == 0, nComis3,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"3"),"A3_COMIS"))
		nComis3 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis3,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos4  > 0
	If !Empty(&(cVEND+"4"))
		nComis4 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis4 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"4"),"A3_COMIS") == 0, nComis4,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"4"),"A3_COMIS"))
		nComis4 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis4,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
If cPos5  > 0
	If !Empty(&(cVEND+"5"))
		nComis5 := Posicione("SB1",1,xFilial("SB1") + &(cProduto),"B1_COMIS")
		nComis5 := If(Posicione("SA3",1,xFilial("SA3") + &(cVEND+"5"),"A3_COMIS") == 0, nComis5,Posicione("SA3",1,xFilial("SA3") + &(cVEND+"5"),"A3_COMIS"))
		nComis5 := If(Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS") == 0, nComis5,Posicione("SA1",1,xFilial("SA1") + &(cCliente),"A1_COMIS"))
	EndIf
EndIf
RestArea(aAreaAnt)
If nTp == 1
	If cAlias == "SCJ"
		dbSelectArea("TMP1")
		&(cComis+"1") := nComis1
		&(cComis+"2") := nComis2
		&(cComis+"3") := nComis3
		&(cComis+"4") := nComis4
		&(cComis+"5") := nComis5
	else
		dbSelectArea("SC6")
		Reclock("SC6",.F.)
		SC6->C6_COMIS1:= nComis1
		SC6->C6_COMIS2:= nComis2
		SC6->C6_COMIS3:= nComis3
		SC6->C6_COMIS4:= nComis4
		SC6->C6_COMIS5:= nComis5
	    MsUnLock()
	endif

Else
	Return(nComis1+nComis2+nComis3+nComis4+nComis5)
EndIf

Return(lRet)