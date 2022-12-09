#include "RWMAKE.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ ACDHCI02 ³ Autor ³ Luiz Enrique          ³ Data ³ 05/11/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de impressao de etiquetas de produtos no momento da ³±±
±±³          ³ confirmacao da Pre-Nota de Entrada						  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico cliente HCI			                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Retorno  ³      						                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function ACDHCI02()  

Local nQtde,nQe 
Local nResto   	:= 0
Local nContEti	:= 0
Local ncopEti	:= 1

Local aArea    := GetArea()
Local aAreaSF1 := SF1->(GetArea("SF1"))
Local aAreaSD1 := SD1->(GetArea("SD1"))
Local aAreaSB1 := SB1->(GetArea("SB1"))
Local aAreaSB5 := SB5->(GetArea("SB5"))

IF !CB5SetImp(CBRLocImp("MV_IACD02"),IsTelNet())
	CBAlert('Local de impressao invalido')
	Return
Endif

If !CBYesNo("Confirma a Impressao de Etiquetas","Aviso")
	Return
Endif

SZK->(dbsetOrder(2))	//Especifica
SD1->(dbsetOrder(1))
SB1->(dbsetOrder(1))
SB5->(dbsetOrder(1))
SF4->(dbsetOrder(1))
SD1->(dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)) 

While 	SD1->(!EOF()) .and.	xFilial('SD1')  == SD1->D1_FILIAL .and. SD1->D1_DOC == SF1->F1_DOC .and. ;
   		SD1->D1_SERIE   == SF1->F1_SERIE  .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA    == SF1->F1_LOJA 
   		 
	//Posiciona Produto             
	SB1->(dbSeek(xFilial("SB1")+SD1->D1_COD))
	
	//Posiciona na Tabela Especifica SZK             
	SZK->(dbSeek(xFilial("SZK")+SD1->D1_COD))

	If ! Empty(SD1->D1_TES)
		SF4->(DbSeek(xFilial()+SD1->D1_TES))
		If SF4->F4_ESTOQUE <> 'S'
			SD1->(dbSkip()	)
			Loop
		EndIf
	EndIf	

	If ! CBImpEti(SB1->B1_COD)  //Verfica se imprime etiqueta do produto (SB5 B5_IMPETI)
		SD1->(dbSkip()	)
		Loop
	EndIf 

    nQE    := IF(Empty(RetFldProd(SB1->B1_COD,"B1_QE")),1,RetFldProd(SB1->B1_COD,"B1_QE"))
	nQtde  := Int(SD1->D1_QUANT/nQE)
	nResto := SD1->D1_QUANT%nQE  
	
	If nResto >0
		nQtde++
	EndIf
	
	//SD1->D1_QTDETI - Campo criado especificamente para informar numero de copias da Etiqueta
	ncopEti:= If (Empty(SD1->D1_QTDETI),1,SD1->D1_QTDETI)
	
	If ExistBlock('IMG01')
		ExecBlock('IMG01',,,{nQtde,,,ncopEti,,,,,,,,,,,,,,,,,,0,.F.})
		nContEti+=SD1->D1_QTDETI
	EndIf
	MSCBCLOSEPRINTER() 
	
	SD1->(dbSkip())                         
		
Enddo

RestArea(aArea)
RestArea(aAreaSF1)
RestArea(aAreaSD1)
RestArea(aAreaSB1)
RestArea(aAreaSB5) 

If nContEti > 0 
	If nContEti > 1
		CBAlert("Foram geradas " + Strzero(nContEti,3) + " Etiquetas de Produtos.")
	Else
		CBAlert("Foi gerada a Etiqueta do Produto.")
	Endif
Endif

Return

