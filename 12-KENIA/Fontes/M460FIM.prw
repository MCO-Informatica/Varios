#include "protheus.ch"
#include "RWMAKE.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ M460FIM  ³ Autor ³ Ricardo Correa de Souza ³ Data ³ 30/08/2010 ³±±
±±³          ³          ³       ³     MVG Consultoria     ³      ³            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Grava o Financeiro e a Comissao do Vendedor                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Observacao³ Papeleta O                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Kenia Industrias Texteis Ltda                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³             ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador   ³  Data  ³              Motivo da Alteracao                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function M460FIM()

Private nValTitulo	:= 0
Private cVend1		:= SF2->F2_VEND1
Private nValComis1	:= 0
Private cPedido		:= " "
Private cPrefixo	:= " "
Private nValorImp   := 0    
Private nTotImp     := 0
Private cNCM        := ""   

dbSelectArea("SF2")

If Empty(SF2->F2_COND)
	Return()
EndIf

dbSelectArea("SD2")
dbSetOrder(3)
dbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE)

dbSelectArea("SC5")
dbSetOrder(1)
dbSeek(xFilial("SC5")+SD2->D2_PEDIDO)

If SC5->C5_PAPELET$"O"
	
	cPrefixo := IIF(SF2->F2_SERIE$"UNI","12 ","21 ")
	
	nValTitulo += SF2->F2_VALBRUT * 3
	
	If nValTitulo > 0
		
		//GravaTitulo()
		
	EndIf
	
EndIf 

DbSelectArea("SB1")
DbSetOrder(1)

DbSelectArea("SYD")
DbSetOrder(1)

DbSelectArea("SD2")
DbSetOrder(3)
If SD2->(DbSeek(xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SD2->(!EOF()) .And. SD2->D2_DOC == SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE .And. SD2->D2_CLIENTE == SF2->F2_CLIENTE .And. SD2->D2_LOJA == SF2->F2_LOJA
		If Alltrim(SD2->D2_CF) $ "5902/6902/5925/6925/5124/6124" .And. !SD2->D2_TES $ "600"					
			SD2->(DbSkip())
			Loop
		EndIf
	    If SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
		 	cNCM := SB1->B1_POSIPI
		 	If SYD->(DbSeek(xFilial("SYD")+cNCM))
		     	nValorImp := SD2->D2_TOTAL * (SYD->YD_ALIQIMP / 100)
		     	RecLock("SD2",.F.)
		     		SD2->D2_TOTIMP := nValorImp
		     	MsUnlock()                                          
		     	nTotImp := nTotImp + nValorImp
		    EndIf
		EndIf  
	     
		SD2->(DbSkip())
	EndDo
	
	RecLock("SF2",.F.)
		SF2->F2_TOTIMP := nTotImp
	MsUnlock()
EndIf    

Return()

Static Function GravaTitulo()

Local aDupl		:= {}
Local cParcela	:= " "

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA)

aDupl	:= Condicao(nValTitulo,SF2->F2_COND,,dDataBase)

If Len(aDupl) > 1
	cParcela := "1"
EndIf

For I := 1 To Len(aDupl)
	
	dbSelectArea("SE1")
	dbSetOrder(1)
	If !DbSeek(xFilial("SE1") + cPrefixo + SF2->F2_DOC + cPARCELA)
		RecLock("SE1",.T.)
		SE1->E1_Filial := xFilial("SE1")
		SE1->E1_PREFIXO:= cPrefixo
		SE1->E1_CLIENTE:= SF2->F2_CLIENTE
		SE1->E1_LOJA   := SF2->F2_LOJA
		SE1->E1_NOMCLI := SA1->A1_NREDUZ
		SE1->E1_NUM    := SF2->F2_DOC
		SE1->E1_PARCELA:= cParcela
		SE1->E1_TIPO   := "NF"
		SE1->E1_EMISSAO:= dDataBase
		SE1->E1_VEND1  := cVend1
		SE1->E1_VENCTO := aDupl[i,1]
		SE1->E1_VENCORI:= aDupl[i,1]
		SE1->E1_VENCREA:= DataValida(SE1->E1_VENCTO)
	Else
		RecLock("SE1",.F.)
	EndIf
	
	IF !found() .or. (found() .and. empty(SE1->E1_DATABOR);
		.AND. SE1->E1_SITUACA == "0" .AND. EMPTY(SE1->E1_BAIXA))
		
		SE1->E1_LA     := "S"
		SE1->E1_FLUXO  := "S"
		SE1->E1_VALOR  := aDupl[i,2]
		SE1->E1_SALDO  := SE1->E1_VALOR
		SE1->E1_VLCRUZ := SE1->E1_VALOR
		SE1->E1_MOEDA  := 1
		SE1->E1_HIST   := " "
		SE1->E1_NATUREZ:= SA1->A1_NATUREZ
		SE1->E1_SITUACA:= "0"
		SE1->E1_OCORREN:= "01"
		SE1->E1_EMIS1  := dDataBase
		SE1->E1_BASCOM1:= SE1->E1_VALOR
		SE1->E1_PEDIDO := POSICIONE("SD2",3,XFILIAL("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA,"D2_PEDIDO")
		SE1->E1_STATUS := "A"
		SE1->E1_FILORIG:= SE1->E1_FILIAL
		SE1->E1_FRETISS:="1"
		SE1->E1_APLVLMN:="1"
		
	Endif
	
	MSUnlock()
	
	cParcela := Soma1(cParcela)
	
Next

Return()
