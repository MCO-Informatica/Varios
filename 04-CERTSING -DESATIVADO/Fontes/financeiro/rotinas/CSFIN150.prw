#Include "totvs.ch"

//Renato Ruy - 12/01/17
//Geracao de numero da nota e descricao produto CNAB Itau
User Function CSFIN150()
/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Declaracao de Variaveis e Valida em qual tipo de registro estamos   ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/ 
Local cMensFor	:= ""
Local cProduto	:= ""

SF2->(DbSetOrder(1)) //F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA  
If SF2->(DbSeek(xFilial("SF2")+SE1->E1_NUM))

	While !SF2->(EOF()) .And. SE1->E1_NUM == SF2->F2_DOC .And. (SF2->F2_PREFIXO != SE1->E1_PREFIXO .Or. SE1->E1_CLIENTE != SF2->F2_CLIENTE) 
		SF2->(DbSkip())	
	Enddo
	
	SD2->(DbSetOrder(3)) //D2_FILIAL, D2_DOC, D2_SERIE, D2_CLIENTE
	If SD2->(DbSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE))
	
		While !SD2->(EOF()) .And. SD2->D2_DOC== SF2->F2_DOC .And. SD2->D2_SERIE == SF2->F2_SERIE
			cProduto := Iif(Empty(cProduto),"",SubStr(cProduto,1,9))+Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_DESC")
			SD2->(DbSkip())	
		Enddo  
	
		cMensFor := SubStr("NF"+Iif(!Empty(SF2->F2_NFELETR),Padl(AllTrim(SF2->F2_NFELETR),9,"0"),SF2->F2_DOC)+Space(1)+cProduto,1,30)

	EndIf

Endif

Return(cMensFor)