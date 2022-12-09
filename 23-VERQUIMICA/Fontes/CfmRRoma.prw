#INCLUDE "TOTVS.CH"
#INCLUDE "ap5mail.ch"                   
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2
#DEFINE IMP_PDF 6

/*
==============================================================================
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
||+----------------------+------------------------------+------------------+||
||| Programa: CfmRRoma   | Autor: McInfotec			    | Data: 2017	   |||
||+-----------+----------+------------------------------+------------------+||
||| Descricao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Alteracao |                                                            |||
||+-----------+------------------------------------------------------------+||
||| Uso       |                                                            |||
||+-----------+------------------------------------------------------------+||
||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
==============================================================================
*/

User Function CfmRRoma(lAutoZ13)

	Private cNumRoma 	:= ""
	Private OPrn
	Private nXLin		:= 0
	Private cLogo      	:= "Logo.bmp" //FisxLogo("1")
	Private nQbLin		:= 2270  //linha para quebra de pagina
	Private nQtdPg		:= 0  	  //qtd paginas	
	Private nPagina		:= 1

	Private oFont08 	:= TFont():New( "Arial",,-9.5,,.F.,,,,,.F.) 
	Private oFont10		:= TFont():New( "Arial",,-10,,.F.,,,,,.F.)
	Private oFont10B	:= TFont():New( "Arial",,-10,,.T.,,,,,.F.)
	Private oFont12		:= TFont():New( "Arial",,-12,,.F.,,,,,.F.)
	Private oFont12B	:= TFont():New( "Arial",,-12,,.T.,,,,,.F.)
	Private oFont13		:= TFont():New( "Arial",,-13,,.F.,,,,,.F.)   
	Private oFont13B	:= TFont():New( "Arial",,-13,,.T.,,,,,.F.)   
	Private oFont14		:= TFont():New( "Arial",,-14,,.F.,,,,,.F.)   
	Private oFont14B	:= TFont():New( "Arial",,-14,,.T.,,,,,.F.)   
	Private oFont16B	:= TFont():New( "Arial",,-16,,.T.,,,,,.F.)   
	Private oFont20B	:= TFont():New( "Arial",,-20,,.T.,,,,,.F.)   

	If MsgYesNo("Confirma impressão do Romaneio : "+Z13->Z13_NUMERO+" ?")       
   		cNumRoma := Z13->Z13_NUMERO
   		OkProc()
	EndIf


Return()



Static Function OkProc()

	Private cTipoFret	:= ""
	Private aRedespa	:= {}
	Private aCliente	:= {}
	Private nPesPrd		:= 0
	Private nD2Qtde 	:= 0
	Private nD2PeBr 	:= 0
	Private nD2VlBr 	:= 0
	Private cB1VqEm		:= ""
	Private cOrdemSe	:= ""
	Private cCodProd	:= ""
	Private cDescOnu	:= ""
	Private cCliAnt		:= ""
	Private cNumNota 	:= ""
	Private cNumPed		:= ""
	Private cNome		:= ""
	Private cMunic		:= ""
	Private cBairro		:= ""
	Private cProdut		:= ""
	Private cQtdKg		:= ""
	Private cPeso		:= "" 
	Private cVolume		:= ""                               
	Private cEmbalag	:= ""
	Private cLote		:= "" 

	DbSelectArea("SA1") ; DbSetOrder(1)
	DbSelectArea("SB1") ; DbSetOrder(1)
	DbSelectArea("SB5") ; DbSetOrder(1)
	DbSelectArea("SD2") ; DbSetOrder(3)
	DbSelectArea("SF2") ; DbSetOrder(1)
	DbSelectArea("SG1") ; DbSetOrder(1)
	DbSelectArea("Z13") ; DbSetOrder(1)
	DbSelectArea("Z14") ; DbSetOrder(2)
	DbSelectArea("CB8") ; DbSetOrder(9)

	RptStatus({|| RunReport()})


Return


Static Function RunReport()

	Local cFilePrinter			:= ALLTRIM(cNumRoma)
	Local lFormaTMSPRINTER 	:= .T.
	
	oPrn := FWMSPrinter() :New()(cFilePrinter,IMP_SPOOL,lFormaTMSPRINTER,,.T.)     
	
	oPrn:Setup() // para configurar impressora

	oPrn:SetResolution(78) //Tamanho estipulado para romaneio
	//oPrn:SetPortrait()
	oPrn:SetLandscape()
	oPrn:SetPaperSize(9)
	oPrn:SetMargin(60,60,60,60)

	oPrn:StartPage()                     

	ImpCab()  			//impressao do cabeçalho
	VerDados()				//Analisa os dados para impressao
	//ImpBoxDados()  		//box de dados
	ImpTotais()			//totais
	ImpAvalia()			//Avaliacoes
	ImpRespon()			//Responsaveis
	ImpRedes()			//Redespacho
	ImpObsCli()			//Obs Cliente
	ImpRodape()			//impressao rodape da pagina

	oPrn:EndPage()  
	oPrn:Print()    
	
	
Return()


Static Function ImpCab()


	oPrn:Box( 0000,0005, 2340 ,3150) //box de folha 

	oPrn:SayBitmap( 005 , 015 , cLogo , 205 , 120 ) //Logo 

	oPrn:Say( 090, 300, "Romaneio :", oFont12B, 100)
	oPrn:Say( 100, 520, cNumRoma  , oFont20B , 100)

	oPrn:Say( 090, 1000, "Transportadora :  "+Posicione("SA4",1,xFilial("SA4")+Z13->Z13_TRANSP,"A4_NREDUZ")+"   Placa:   " + Z13->Z13_PLACA   , oFont12, 100)

	oPrn:Say( 060, 3010, "Emissão", oFont12B, 100)
	oPrn:Say( 100, 3000, dtoc(ddatabase), oFont12 , 100)


	oPrn:Line( 130, 015, 130, 3140 )  //linha

	nXLin := 165

Return()


Static Function ImpBoxDados()	

	Local nLinha 	:= 0
	Local nTxtCount	:= 0
	Local nLinTxt	:= 0
	Local cLinha		:= ""

	oPrn:Box( nXlin,015, nXlin+280 ,3140) 			//box de dados
	oPrn:Line( nXlin+60, 015, nXlin+60, 3140 )  	//linha

	oPrn:Line( nXlin, 140, nXlin+60, 140 )  	//linha
	oPrn:Line( nXlin, 240, nXlin+60, 240 )  	//linha
	oPrn:Line( nXlin, 890, nXlin+60, 890 )  	//linha
	oPrn:Line( nXlin, 1130, nXlin+60, 1130 )  	//linha
	oPrn:Line( nXlin, 1370, nXlin+280, 1370 )  	//linha
	oPrn:Line( nXlin, 1610, nXlin+60, 1610 )  	//linha
	oPrn:Line( nXlin, 1750, nXlin+280, 1750 )  	//linha
	oPrn:Line( nXlin, 1890, nXlin+60, 1890 )  	//linha
	oPrn:Line( nXlin, 1990, nXlin+60, 1990 )  	//linha
	oPrn:Line( nXlin, 2330, nXlin+280, 2330 )  	//linha
	oPrn:Line( nXlin, 2980, nXlin+60, 2980 )  	//linha

	oPrn:Say( nXlin+23, 020, "N.Fiscal", oFont08, 100)
	oPrn:Say( nXlin+50, 020, cNumNota, oFont08, 100)

	oPrn:Say( nXlin+23, 160, "Pedido", oFont08, 100)
	oPrn:Say( nXlin+50, 160, cNumPed, oFont08, 100)

	oPrn:Say( nXlin+23, 260, "Cliente", oFont08, 100)
	oPrn:Say( nXlin+50, 260, cNome, oFont08, 100)  //40

	oPrn:Say( nXlin+23, 910, "Municipio", oFont08, 100)
	oPrn:Say( nXlin+50, 910, cMunic, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 1150, "Bairro", oFont08, 100)
	oPrn:Say( nXlin+50, 1150, cBairro, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 1390, "Produto", oFont08, 100)
	oPrn:Say( nXlin+50, 1390, cProdut, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 1630, "Qtde. (KG)", oFont08, 100)
	oPrn:Say( nXlin+50, 1630, cQtdKg, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 1770, "Peso Bruto", oFont08, 100)
	oPrn:Say( nXlin+50, 1770, cPeso, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 1910, "Volume", oFont08, 100)
	oPrn:Say( nXlin+50, 1910, cVolume, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 2010, "Embalagem", oFont08, 100)
	oPrn:Say( nXlin+50, 2010, cEmbalag, oFont08, 100)  //15

	oPrn:Say( nXlin+23, 2350, "Tipo de Frete", oFont08, 100)
	oPrn:Say( nXlin+50, 2350, cTipoFret, oFont08, 100)  //25

	oPrn:Say( nXlin+23, 3000, "Lote", oFont08, 100)
	oPrn:Say( nXlin+50, 3000, cLote, oFont08, 100)  //15


	oPrn:Say( nXlin+90, 020, "Desc. Produto", oFont08, 100)

	cTxt := cDescOnu
	nTxtCount := MLCount(cTxt,75)
	If nTxtCount > 5
		nTxtCount := 5
	EndIf
	nLinTxt	:= nXlin+120	
	For nLinha := 1 to nTxtCount
    	cLinha := Memoline(cTxt, 75, nLinha)
		oPrn:Say( nLinTxt , 020, cLinha , oFont10, 100) 
		nLinTxt += 30
	Next nLinha

	oPrn:Say( nXlin+90,  1390, "No. Order Separação", oFont08, 100)
	oPrn:Say( nXlin+120, 1390, cOrdemSe, oFont08, 100)  //15

	oPrn:Say( nXlin+90,  1770, "Codigo Produto", oFont08, 100)
	oPrn:Say( nXlin+120, 1770, cCodProd, oFont08, 100)  //15

	If !Empty(cOrdemSe)
		oPrn:Code128C(nXLin+220,2400,cOrdemSe, 40 )
	EndIf
	
	nXLin += 310
	VerPg()

Return

Static Function ImpTotais()

	oPrn:Box( nXlin,015, nXlin+40 ,3140) 			//box de dados

	oPrn:Line( nXlin, 1370, nXlin+40, 1370 )  	//linha
	oPrn:Line( nXlin, 1610, nXlin+40, 1610 )  	//linha
	oPrn:Line( nXlin, 1750, nXlin+40, 1750 )  	//linha
	oPrn:Line( nXlin, 1890, nXlin+40, 1890 )  	//linha


	oPrn:Say( nXlin+27, 0020, "TOTAL DE ENTREGAS :  "+AllTrim(Str(Len(aCliente))), oFont08, 100)
	oPrn:Say( nXlin+27, 1390, "TOTAL"			, oFont08, 100)
	oPrn:Say( nXlin+27, 1630, Transform(nD2Qtde, "@E 999,999.99") 	, oFont08, 100)  //Qtd Kg
	oPrn:Say( nXlin+27, 1770, Transform(nD2PeBr, "@E 999,999.99")	, oFont08, 100)  //Peso
	oPrn:Say( nXlin+27, 2010, "TOTAL R$"		, oFont08, 100)  //
	oPrn:Say( nXlin+27, 2160, Transform(nD2VlBr, "@E 999,999.99")	, oFont08, 100)  //total valor

	nXLin += 100
	VerPg()


Return()

Static Function ImpAvalia()


	oPrn:Say( nXlin, 0020, "Avaliações :", oFont08, 100)
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "Lacração", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Lacrada todas as saídas de produtos", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "Etiquetas:", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Com nome de produtos e informações quantitativas", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "Quantidade:", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Idêntica a quantidade da Nota Fiscal", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "Produtos:", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Idênticos ao da Nota Fiscal", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "Embalagem:", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Sem amassados e vazamento", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

	oPrn:Say( nXlin, 0020, "NFs corretas:", oFont08, 100)
	oPrn:Say( nXlin, 0260, "Quantidade de volume, peso, nome, produto, NF com laudo", oFont08, 100)  //40
	oPrn:Say( nXlin, 1390, "(  ) Sim", oFont08, 100)  //15
	oPrn:Say( nXlin, 1630, "(  ) Não", oFont08, 100)  //15
	nXLin += 50
	VerPg()

Return()

Static Function ImpRespon()

	nXLin += 50
	oPrn:Say( nXlin, 0020, "Responsável Carregamento: _______________________________________________ ", oFont08, 100)
	nXLin += 100
	VerPg()
	oPrn:Say( nXlin, 0020, "Responsável Conferência:  _______________________________________________ ", oFont08, 100)
	nXLin += 50
	VerPg()

Return()

Static Function ImpRodape()

	Local oBrush1 := TBrush():New( , CLR_HGRAY )

	oPrn:FillRect( {2270, 015, 2330 ,3140 }, oBrush1 )
	oPrn:Say( 2310 , 1600, "Pag. " + Alltrim(Transform(nPagina,"@E 99")) , oFont12, 100) 


Return

Static Function ImpRedes()

	Local oBrush1 := TBrush():New( , CLR_HGRAY )
	Local xl	:= 0

	If !Empty(aRedespa)

		oPrn:Say( nXlin, 0020, "DADOS PARA REDESPACHO"	, oFont08, 100)
		nXLin += 10
		VerPg()

		oPrn:FillRect( {nXLin, 015, nXLin+40 ,3140 }, oBrush1 )

		oPrn:Say( nXlin+23, 0020, "N.Fiscal"	, oFont08, 100)
		oPrn:Say( nXlin+23, 0160, "Pedido"		, oFont08, 100)
		oPrn:Say( nXlin+23, 0260, "Transportadora", oFont08, 100)
		oPrn:Say( nXlin+23, 0910, "Endereço", oFont08, 100)
		oPrn:Say( nXlin+23, 1770, "Bairro", oFont08, 100)
		oPrn:Say( nXlin+23, 2010, "Cidade", oFont08, 100)
		oPrn:Say( nXlin+23, 3000, "Cep", oFont08, 100)
		nXLin += 70
		VerPg()

		For xl := 1 to len(aRedespa)
			oPrn:Say( nXlin, 0020, aRedespa[xl][1], oFont08, 100)
			oPrn:Say( nXlin, 0160, aRedespa[xl][2], oFont08, 100)
			oPrn:Say( nXlin, 0260, AllTrim(Posicione("SA4",1,xFilial("SA4")+aRedespa[xl][3],"A4_NOME")), oFont08, 100)  //40
			oPrn:Say( nXlin, 0910, AllTrim(Posicione("SA4",1,xFilial("SA4")+aRedespa[xl][3],"A4_END")), oFont08, 100)  //15
			oPrn:Say( nXlin, 1770, AllTrim(Posicione("SA4",1,xFilial("SA4")+aRedespa[xl][3],"A4_BAIRRO")), oFont08, 100)  //15
			oPrn:Say( nXlin, 2010, AllTrim(Posicione("SA4",1,xFilial("SA4")+aRedespa[xl][3],"A4_MUN")), oFont08, 100)  //15
			oPrn:Say( nXlin, 3000, AllTrim(Posicione("SA4",1,xFilial("SA4")+aRedespa[xl][3],"A4_CEP")), oFont08, 100)  //15
			nXLin += 40
			VerPg()
		Next xl	

		nXLin += 50
		VerPg()

	EndIf

Return()
	
Static Function ImpObsCli()	

	Local oBrush1 := TBrush():New( , CLR_HGRAY )
	Local xl	:= 0
	Local nLinha 	:= 0
	Local nTxtCount	:= 0
	Local nLinTxt	:= 0
	Local cLinha		:= ""

	If !Empty(aCliente)

		oPrn:Say( nXlin, 0020, "OBSERVAÇÕES DOS CLIENTES"	, oFont08, 100)
		nXLin += 10
		VerPg()

		oPrn:FillRect( {nXLin, 015, nXLin+40 ,3140 }, oBrush1 )

		oPrn:Say( nXlin+23, 0020, "N.Fiscal"	, oFont08, 100)
		oPrn:Say( nXlin+23, 0260, "Cliente"		, oFont08, 100)
		oPrn:Say( nXlin+23, 1150, "Observação"	, oFont08, 100)
		nXLin += 70
		VerPg()
	
		For xl := 1 to Len(aCliente)
			oPrn:Say( nXlin, 0020, aCliente[xl][1], oFont08, 100)
			oPrn:Say( nXlin, 0260, AllTrim(aCliente[xl][2]), oFont08, 100)  //40

			cTxt := Posicione("SA1",1,xFilial("SA1")+aCliente[xl][3]+aCliente[xl][4],"A1_VQ_OBSO")
			If !Empty(cTxt)	
				nTxtCount := MLCount(cTxt,150)
				For nLinha := 1 to nTxtCount
					cLinha := Memoline(cTxt, 150, nLinha)
					oPrn:Say( nXlin , 1150, cLinha , oFont08, 100) 
					nXlin += 40
					VerPg()
				Next nLinha
			 Else		
				nXlin += 40
				VerPg()
			EndIf	
		Next xl

	EndIf
		
Return()	

Static Function VerPg()

   If nXLin > nQbLin
   	 ImpRodape()		// impressao rodape da pagina
   	 oPrn:EndPage() 
   	 oPrn:StartPage()                     
   	 ImpCab()    		
   	 nPagina ++
   EndIf

Return()	


Static Function VerDados()

	If Z13->(DbSeek(xFilial("Z13")+cNumRoma))
		If Z14->(DbSeek(xFilial("Z14")+cNumRoma))
			While !Z14->(Eof()) .And. Z14->(Z14_FILIAL+Z14_NUMERO) == xFilial("Z14")+cNumRoma
			
				If SF2->(DbSeek(xFilial("SF2")+Z14->(Z14_NOTA+Z14_SERIE)))
				
					SA1->(DbSeek(xFilial("SA1")+Z14->(Z14_CLIENT+Z14_LOJA)))
				
					If SD2->(DbSeek(xFilial("SD2")+SF2->(F2_DOC+F2_SERIE)))
					
						While !SD2->(Eof()) .And. Z14->(Z14_NOTA+Z14_SERIE) = SD2->(D2_DOC+D2_SERIE)
						
							SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
							SB5->(DbSeek(xFilial("SB5")+SD2->D2_COD))
						
							cTipoFret := ""
							If SF2->F2_VQ_FRET == "V"
								If SF2->F2_VQ_FVER == "N" // Normal
									cTipoFret := "VER Normal"
								ElseIf SF2->F2_VQ_FVER == "R" //Negociado/Retira
									cTipoFret := "VER Negociado/Retira"
								ElseIf SF2->F2_VQ_FVER == "D" //Negociado/Redespacho
									cTipoFret := "VER Negociado/Redespacho"
									aaDD(aRedespa, {SD2->D2_DOC, SD2->D2_PEDIDO, SF2->F2_TRANSP})
								EndIf
							Else
								If SF2->F2_VQ_FCLI == "R" //Retira
									cTipoFret := "CLI Retira"
								ElseIf SF2->F2_VQ_FCLI == "D" //Redespacho
									cTipoFret := "CLI Redespacho"
									aaDD(aRedespa, {SD2->D2_DOC, SD2->D2_PEDIDO, SF2->F2_TRANSP})
								EndIf
							EndIf
						
							SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
							cB1VqEm := SB1->B1_VQ_EM
							SB1->(DbSeek(xFilial("SB1")+cB1VqEm))
							nPesPrd := SB1->B1_PESO

							//Voltar o posicionamento
							SB1->(DbSeek(xFilial("SB1")+SD2->D2_COD))
							SG1->(DbSeek(xFilial("SG1")+SB1->(B1_COD+B1_VQ_MP)))
						
							nD2Qtde += SD2->D2_QUANT
							nD2PeBr += ((SD2->D2_QUANT/SG1->G1_QUANT*nPesPrd)+SD2->D2_QUANT)
							nD2VlBr += SD2->D2_VALBRUT
						
							cNumNota 	:= Z14->Z14_NOTA
							cNumPed	:= SD2->D2_PEDIDO
							cNome		:= SA1->A1_NOME
							cMunic		:= SubStr(SA1->A1_MUN,1,15)
							cBairro	:= SubStr(SA1->A1_BAIRRO,1,15)
							cProdut	:= SB1->B1_VQ_COD
							cQtdKg		:= Transform(SD2->D2_QUANT,"@E 999,999.99")
							cPeso		:= Transform(((SD2->D2_QUANT/SG1->G1_QUANT)*nPesPrd)+SD2->D2_QUANT,"@E 999,999.99") 
							cVolume	:= Transform(SD2->D2_QUANT/SG1->G1_QUANT,"@E 999,999")                               
							cEmbalag	:= Posicione("SB1",1,xFilial("SB1")+SB1->B1_VQ_EM,"B1_VQ_COD")
							cLote		:= SD2->D2_LOTECTL 
						
							If DY3->(DbSeek(xFilial("DY3")+SB5->B5_ONU)) .Or. Empty(SB5->B5_ONU)
								cDescOnu := "ONU "+AllTrim(DY3->DY3_ONU)+", "+AllTrim(DY3->DY3_DESCRI)+", "+AllTrim(DY3->DY3_CLASSE)+", "+AllTrim(DY3->DY3_NRISCO)+", "+AllTrim(DY3->DY3_GRPEMB)+". "
								cOrdemSe := ""
								cCodProd := SD2->D2_COD
      						
      							If CB8->(DbSeek(xFilial("CB8")+SD2->(D2_DOC+D2_SERIE+D2_COD))) //DANILO BUSSO 22/12/2015
							  		cOrdemSe:= CB8->CB8_ORDSEP
                          EndIf   
       
						   	EndIf
						
							ImpBoxDados()
						
							DbSelectArea("SD2")
							DbSkip()
					
						EndDo
					
					EndIf
				EndIf
			
			
				If cCliAnt <> Z14->Z14_CLIENT+Z14->Z14_LOJA
					aaDD(aCliente, {Z14->Z14_NOTA, SA1->A1_NOME, SA1->A1_COD, SA1->A1_LOJA})
				EndIf
			
				cCliAnt := Z14->Z14_CLIENT+Z14->Z14_LOJA
			
				Z14->(DbSkip())

			EndDo

		EndIf

	EndIf

Return()