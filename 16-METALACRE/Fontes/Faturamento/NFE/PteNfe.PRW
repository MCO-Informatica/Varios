#include 'protheus.ch'
#include 'tbiconn.ch'
#include 'topconn.ch'
#include 'fileio.ch'
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ PE01NFESEFAZ() ºAutor  ³ Luiz Alberto º Data ³  03/06/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de Entrada para Tratamento NFESEFAZ XML              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#define aPROD 1 //-> aProd
#define cMENSCLI 2 //-> cMensCli
#define cMENSFIS 3 //-> cMensFis
#define aDEST 4 //-> aDest
#define aNOTA 5 //-> aNota
#define aINFOITEM 6 //-> aInfoItem
#define aDUPL 7 //-> aDupl
#define aTRANSP 8 //-> aTransp
#define aENTREGA 9 //-> aEntrega
#define aRETIRADA 10 //-> aRetirada
#define aVEICULO 11 //-> aVeiculo
#define aREBOQUE 12 //-> aReboque
#define aNfVincRur 13
#define aEspVol 14
#define aNfVinc 15
#define aDetPag 16
#define aObsCont 17
#define nPedCom 18

#define PRODUTO 2
#define DESCR 4

#define PEDIDO 1
#define ITEMPV 2
#define TES 3
#define ITEM 4

 // aRetorno[1] -> aProd
 // aRetorno[2] -> cMensCli
 // aRetorno[3] -> cMensFis
 // aRetorno[4] -> aDest
 // aRetorno[5] -> aNota
 // aRetorno[6] -> aInfoItem
 // aRetorno[7] -> aDupl
 // aRetorno[8] -> aTransp
 // aRetorno[9] -> aEntrega
 // aRetorno[10] -> aRetirada
 // aRetorno[11] -> aVeiculo
 // aRetorno[12] -> aReboque
 // aRetorno[13] -> aNfVincRur
 // aRetorno[14] -> aEspVol
 // aRetorno[15] -> aNfVinc
 // aRetorno[16] -> aDetPag
 // aRetorno[17] -> aObsCont
 // aRetorno[18] -> aPedCom

USER FUNCTION PE01NFESEFAZ()        
Local aParam := PARAMIXB
Local aArea	 := GetArea()

If SFT->FT_TIPOMOV == "S" // Se For Nota Fiscal de Saida Entao Efetua Tratamento dos Itens
	cMensCli	:= aParam[cMENSCLI] // Mensagem da Nota Fiscal
	aProd		:= aParam[aPROD] // Itens da Nota Fiscal
	aInfoItem 	:= aParam[aINFOITEM] // Informaçao dos Itens do Pedido de Venda 
									 // aAdd(aInfoItem,{(cAliasSD2)->D2_PEDIDO,(cAliasSD2)->D2_ITEMPV,(cAliasSD2)->D2_TES,(cAliasSD2)->D2_ITEM})
	aDupl		:= aParam[aDUPL]						  		  
	aVol		:= aParam[aEspVol]
	aPedCom		:= {} //aParam[nPedCom]


	// Tratamento de Nome do Vendedor na Mensagem da Nota e Mensagem Fixa para Notas de Faturamento Referente Politica de Devolução
	
	SC5->(dbSetOrder(1), dbSeek(xFilial("SC5")+aInfoItem[1,PEDIDO]))
	If ! ' No. Pedido Venda: ' + SC5->C5_NUM$cMensCli
		cMensCli += ' No. Pedido Venda: ' + SC5->C5_NUM
	Endif
	If !Empty(Len(aDupl)) .And. SF2->F2_TIPO == "N" .And. cEmpAnt <> '04'
		If SC5->(FieldPos("C5_PEDWEB")) > 0 
			If Empty(SC5->C5_PEDWEB)
				If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SF2->F2_VEND1))
					If ! ' Vendedor(a): ' + AllTrim(SA3->A3_COD) + ' - ' + AllTrim(SA3->A3_NOME)$cMensCli
						cMensCli += ' Vendedor(a): ' + AllTrim(SA3->A3_COD) + ' - ' + AllTrim(SA3->A3_NOME)
					Endif
				Endif    
			Endif
		Else
			If SA3->(dbSetOrder(1), dbSeek(xFilial("SA3")+SF2->F2_VEND1))
				If ! ' Vendedor(a): ' + AllTrim(SA3->A3_COD) + ' - ' + AllTrim(SA3->A3_NOME)$cMensCli
					cMensCli += ' Vendedor(a): ' + AllTrim(SA3->A3_COD) + ' - ' + AllTrim(SA3->A3_NOME)
				Endif
			Endif    
		Endif
	Endif
	
	nRecSC6 := SC6->(Recno())
	For nI := 1 To Len(aProd)
		If nI == 1
			axQuant := {}   
		Endif
		cxBarra := ''
		If SC6->(dbSetOrder(1), dbSeek(xFilial("SC6")+aInfoItem[nI,PEDIDO]+aInfoItem[nI,ITEMPV]+aProd[nI,PRODUTO]))
			cDescr := AllTrim(aProd[nI,DESCR])
			
			If cEmpAnt $ '01*04'
				dbSelectArea("Z00")
				dbSetOrder(3)
				MsSeek(xFilial("Z00")+SC6->C6_XLACRE)
						
						
				SD2->(dbSetOrder(8), dbSeek(xFilial("SD2")+aInfoItem[1,PEDIDO]+aInfoItem[nI,ITEMPV]))
						
				dbSelectArea("Z01")
				dbSetOrder(1)
				MsSeek(xFilial("Z01")+Z00->Z00_COD+SD2->D2_PEDIDO+SD2->D2_ITEMPV)                                                                                                                       

				
				&& Quantidade/ Qtd Itens-emb	/ Peso unit/ PESO Emb/ caixas
				&& Luiz Alberto - 03-08-2012 Acumular axQuant
				nPos := Ascan(axQuant,{|x| AllTrim(x[1]) == AllTrim(SC5->C5_ESPECI1)})
				If Empty(nPos)
					AADD(axQuant,{SC5->C5_ESPECI1,SD2->D2_QUANT,Z06->Z06_QTDMAX,SC6->C6_XPLITEM,SC6->C6_XPBITEM,SC6->C6_XVOLITE})
				Else 
					axQuant[nPos,4] +=SC6->C6_XPLITEM
					axQuant[nPos,5] +=SC6->C6_XPBITEM
					axQuant[nPos,6] +=SC6->C6_XVOLITE
				Endif

				&&Codigo de Barras na Personalização
				cxBarra:=IIf(Z00->Z00_BARRAS$'12',"COD BARRAS","")

				If !Empty(Alltrim(SubStr(SC6->C6_OPC,3)))
					cDescr += " Comp: " + Alltrim(SubStr(SC6->C6_OPC,4,5))+" M"
				Endif
				
				If !Empty(Alltrim(Z00->Z00_DESC))
					cDescr += " Pers.: "+Alltrim(Z00->Z00_DESC)+" "
				Endif           
				
				If !Empty(SC6->C6_XINIC)
					cDescr += "Num. "+cValtochar(SC6->C6_XINIC)+"/" +cValToChar(SC6->C6_XFIM)+" "+cxBarra
				Endif           
			Endif

			aProd[nI,DESCR] := 	AllTrim(cDescr)

			// Tratamento de Numero de Pedido do Cliente

			If !Empty(SC6->C6_PEDCLI) .And. !AllTrim(SC6->C6_PEDCLI)$cMensCli
				If !' Pedido(s) Cliente: '$cMensCli
					cMensCli += ' Pedido(s) Cliente: '
				Endif
				cMensCli += ' '+AllTrim(SC6->C6_PEDCLI) + " "
			Endif
			
			_cOpcao:= SC6->C6_OPC				
				
			dbSelectArea("SA7")
			dbSetOrder(1)
			If MsSeek(xFilial("SA7")+SF2->F2_CLIENTE+SF2->F2_LOJA+SC6->C6_PRODUTO+_cOpcao) // Alterado o tamanho do campo na SA7 p/ posicionar corretamente.	
				If !Empty(SC6->C6_XCODCLI)
					cTxt := " " + " Cod. Cliente: "+SC6->C6_XCODCLI             // O tamanho do campo xOPC da SA7 tem o mesmo tamanho do C6_OPC
					cTxt += " " + IIF(!EMPTY(SA7->A7_CODCLI)," Cod. Fornecedor: "+SA7->A7_CODFORN,"")
				Else
					cTxt := " " + IIF(!EMPTY(SA7->A7_CODCLI)," Cod. Cliente: "+SA7->A7_CODCLI,"")             // O tamanho do campo xOPC da SA7 tem o mesmo tamanho do C6_OPC
					cTxt += " " + IIF(!EMPTY(SA7->A7_CODCLI)," Cod. Fornecedor: "+SA7->A7_CODFORN,"")
				Endif
				
				If ! cTxt $ cMensCli
					cMensCli += cTxt
				Endif
			Endif

//			cMensCli += iif(!Empty(Alltrim(SC6->C6_NUMOP))," Numero da OP: " + Alltrim(SC6->C6_NUMOP)+''+Alltrim(SC6->C6_ITEMOP),"")  &&inclusão de informações na Mensagem

			&& Bruno Abrigo em 17-04-12 campo com dados complementares do cliente				
			If SC5->(FieldPos("C5_XOBSCPL")) > 0 .And. !Empty(Alltrim(SC5->C5_XOBSCPL))
				If !Alltrim(SC5->C5_XOBSCPL)$cMensCli
			   		cMensCli+=Alltrim(SC5->C5_XOBSCPL)
			 	Endif
			Endif		                           

			// Tags xPed e nItemPed (controle de B2B) para nota de saída  WILLIAM P. ALVES
			If SC6->(FieldPos("C6_PEDCLI")) > 0 .And. SC6->(FieldPos("C6_ITEMCLI")) > 0
				If !Empty(SC6->C6_PEDCLI) .And. !Empty(SC6->C6_ITEMCLI) 
					aadd(aPedCom,{SC6->C6_PEDCLI,SC6->C6_ITEMCLI})
				Else
					aadd(aPedCom,{})
				EndIf
			Else
				aadd(aPedCom,{})
			EndIf               
		Endif
	Next
	SC6->(dbGoTo(nRecSC6))
	
	// Tratamento de Volumes e Especie

	If SC5->(FieldPos("C5_PEDWEB")) > 0 .And. Empty(SC5->C5_PEDWEB) // Apenas para pedidos diferente da web
		If cEmpAnt == '01' .And. SC5->C5_TIPO == 'N'	
			If Len(axQuant) > 0
				aVol := {}
				For nX := 1 To Len(axQuant)	
					AAdd(aVol,{axQuant[nX][01],axQuant[nX][06],axQuant[nX][04],axQuant[nX][05]})
				Next nX                  
				aParam[aEspVol] := aVol
			Endif
		Endif
	Endif

	aParam[nPedCom] 	:= aPedCom
	aParam[aPROD] 		:= aProd
	aParam[cMENSCLI] 	:= cMensCli
Endif
RestArea(aArea)		
Return aParam


