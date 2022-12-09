#include "protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RPCP001  ºAutor  ³WILLIAM LUIZ ANTUNESº Data ³  21/03/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de monitoramento dos processos da fabrica 		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP COZIL EQUIPAMENTOS                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RPCP001()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local aArea   := GetArea()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Monitoramento dos pedidos pendentes"
Local cDesc1  := "Ao clicar em OK será emitido o relatório de monitoramento dos pedidos"
Local cDesc2  := ""
Local cDesc3  := ""    

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com descricao do programa para adicionar no FormBatch.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com botoes do FormBatch.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aButton, { 1, .T., {|| BUSCA_PED()            }} )
aAdd( aButton, { 2, .T., {|| nOpc := 2, FechaBatch() }} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que ativa o FormBatch.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( cTitulo, aSay, aButton )

If nOpc == 2 // cancelou a rotina
	RestArea( aArea )
	Return
Endif

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  |BUSCA_PED ºAutor  ³Microsiga           º Data ³  03/21/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function BUSCA_PED()      

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³DECLARACAO DAS VARIAVEIS³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Local 	aPedidos 	:= {} 	// VARIAVEL RESPONSAVEL POR COLETAR TODOS OS PEDIDOS EM ABERTO
	Local	aItens		:= {}
	Local 	aJoin		:= {} 	// VARIAVEL RESPONSAVEL POR COLETAR DADOS ATRAVES DO ARRAY (aPedidos)
	Local 	cXPCP		:= ""	                                                                                                        
	Local	nPedID		:= 1   	// VARIAVEL UTILIZADA PARA CONTAR OS PEDIDOS NO LOOGING DE ATRIBUICAO     
	Local 	nCont		:= 0   	// VARIAVEL UTILIZADA EM VARIOS PONTOS DO COD. COMO TEMPORARIA
	Local 	cLinha		:= ""   // VARIAVEL UTILIZADA PARA ARMAZENAMENTO DAS LINHAS DINAMICAS DO RELATORIO            
	Local 	cScript		:= ""	// VARIAVEL UTILIZADA PARA GERAR O CODIGO XML
	Local 	cPath	  	:= "c:\msiga\monitoramento_pedidos.xml"	
	Local	cComent1	:= ""	//Observacoes
	Local	cComent2	:= ""	//Observacoes	
	
   	#DEFINE REFRIG 	1    		// [INICIO] CONSTANTES UTILIZADAS PARA FACILITAR O ENTENDIMENTO DOS ARRAYS (aPedidos)		
	#DEFINE CALDEI 	2
	#DEFINE COCCAO 	3
	#DEFINE MOBILI 4
	#DEFINE NCLASS	6
	#DEFINE QTD		7
	#DEFINE	REVEND	8
	#DEFINE	PROJET	9
	#DEFINE APROVA	10
	#DEFINE DESENV	11
	#DEFINE PROGRA	12
	#DEFINE CPC		13
	#DEFINE MONTAG	14
	#DEFINE EXPEDI	15			
	#DEFINE LOGIST	16			
	#DEFINE PREFRIG	17
	#DEFINE PCALDEI	18          //OBS. O "P" NA FRENTE SIGNIFICA "PRONTO"
	#DEFINE PCOCCAO	19
	#DEFINE PMOBILI	20
	#DEFINE PTOTAL	21	 
	#DEFINE	DATAENT	22			// [ FIM ]  CONSTANTES UTILIZADAS PARA FACILITAR O ENTENDIMENTO DOS ARRAYS (aPedidos)
	                   
	#DEFINE NUMPEDIDO 	2
	#DEFINE CLIENTE	 	3
	#DEFINE EMISSAO		4
	#DEFINE COMENTS		5		
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³BUSCA OS PEDIDOS EM ABERTO E ARMAZENA NO ARRAY aPedidos ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGotop()                          
	nCont := 1
	While !Eof() .And. xFilial("SC5") == C5_FILIAL 
		If SC5->C5_NOTA == "         "// .Or. SC5->C5_NOTA != "         "   
			Aadd(aPedidos,	{	nCont					,; //ID 
								SC5->C5_NUM				,;
								SC5->C5_NOMCLI			,;
								SC5->C5_EMISSAO			,;
								SC5->C5_XHISTOR			})					
			nCont++
		EndIf
		dbSkip()
	Enddo
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³COM BASE NO ARRAY CRIADO ACIMA (aPedidos),   ³
//³EH FEITA UMA VARREDURA PELOS ITENS, CONTANTO ³ 
//³AS OCORRENCIAS DOS SETORES DA FABRICA        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    nPedID := 1   
    dbSelectArea("SC6")
	dbSetOrder(1)
	
	While nPedID <= Len(aPedidos)
		DbSeek(xFilial("SC6") + aPedidos[nPedID][2])		// PESQUISA PEDIDO
		Aadd(aJoin, {0, 0, 0, 0, SC6->C6_NUM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Date()})	  		// ADICIONA NOVA LINHA NO ARRAY
		aJoin[nPedID][DATAENT] := CToD("01/01/3001")																//INICIALIZA A VARIAVEL DE DATA DE ENTREGAF
		While !Eof() .And. xFilial("SC6") == C6_FILIAL .And. SC6->C6_NUM == aPedidos[nPedID][2]               	//PERCORRE TODOS OS ITENS DO PEDIDO
				
			aJoin[nPedID][QTD]++							// INCREMENTA O VALOR DA QTD
			
			cXPCP := Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_XPCP") //RESGATA VALOR DO CADASTRO DE PRODUTOS (SETOR DA FABRICA)
			  
			cXPCP := VAL(cXPCP) 							//PASSA O VALOR RESGATADO PARA NUMERICO
			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Registra o valor do campo data de entrega,   Pega o menor valor de entrega dentre os itens ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ 
            If aJoin[nPedID][DATAENT] > SC6->C6_ENTREG
            	aJoin[nPedID][DATAENT] := SC6->C6_ENTREG
            EndIf
			  
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ESTA ROTINA FAZ O ACUMULO DAS VARIAVEIS POR SETOR DA PRODUCAO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			Do Case
				Case cXPCP == REFRIG
					aJoin[nPedID][REFRIG]++
					If SC6->C6_XSTATUS == "7" .Or. SC6->C6_XSTATUS == "8" .Or. SC6->C6_XSTATUS == "9"
						aJoin[nPedID][PREFRIG]++
						aJoin[nPedID][PTOTAL]++
					EndIf
				Case cXPCP == CALDEI
					aJoin[nPedID][CALDEI]++
					If SC6->C6_XSTATUS == "7" .Or. SC6->C6_XSTATUS == "8" .Or. SC6->C6_XSTATUS == "9"
						aJoin[nPedID][PCALDEI]++
						aJoin[nPedID][PTOTAL]++
					EndIf
				Case cXPCP == COCCAO
					aJoin[nPedID][COCCAO]++ 
					If SC6->C6_XSTATUS == "7" .Or. SC6->C6_XSTATUS == "8" .Or. SC6->C6_XSTATUS == "9"
						aJoin[nPedID][PCOCCAO]++
						aJoin[nPedID][PTOTAL]++
					EndIf
				Case cXPCP == MOBILI                        
					aJoin[nPedID][MOBILI]++ 
					If SC6->C6_XSTATUS == "7" .Or. SC6->C6_XSTATUS == "8" .Or. SC6->C6_XSTATUS == "9"
						aJoin[nPedID][PMOBILI]++
						aJoin[nPedID][PTOTAL]++
					EndIf
				Case Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_TIPO") == "RV"
					aJoin[nPedID][REVEND]++											// NO CASO DE REVENDA
				OTHERWISE
					aJoin[nPedID][NCLASS]++     									// NO CASO DE NAO ESTAR PREENCHIDO E NEM SER REVENDA
			EndCase 			
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ESTA ROTINA FAZ UM RESUMO DO PAINEL DO PEDIDO³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
            Do Case
            	Case SC6->C6_XSTATUS == "1"
            		aJoin[nPedID][PROJET]++
            	Case SC6->C6_XSTATUS == "2"
            		aJoin[nPedID][APROVA]++  
            	Case SC6->C6_XSTATUS == "3"
            		aJoin[nPedID][DESENV]++
            	Case SC6->C6_XSTATUS == "4"
            		aJoin[nPedID][PROGRA]++
            	Case SC6->C6_XSTATUS == "5"
            		aJoin[nPedID][CPC]++
            	Case SC6->C6_XSTATUS == "6"
            		aJoin[nPedID][MONTAG]++
            	Case SC6->C6_XSTATUS == "7"
            		aJoin[nPedID][EXPEDI]++
            	Case SC6->C6_XSTATUS == "8"
            		aJoin[nPedID][LOGIST]++
            EndCase
			
			dbSkip() 								// PULA PARA O PROXIMO ITEM
		Enddo     
		nPedID++                               		// INCREMENTA O CONTROLE DE PEDIDO
	EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Adiciona TAGS de observacao³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	cComent1 := '<Comment	 ' + Chr(13) + Chr(10)
    cComent1 += '  ss:Author="Cozil"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><B><Font	 ' + Chr(13) + Chr(10)
    cComent1 += '     html:Face="Tahoma" html:Size="8" html:Color="#000000">Observacoes:</Font></B><Font	 ' + Chr(13) + Chr(10)
    cComent1 += '    html:Face="Tahoma" html:Size="8" html:Color="#000000">&#10;	 ' + Chr(13) + Chr(10)
    cComent2 := '</Font></ss:Data></Comment>'
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Faz varredura e prepara para impressao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  
	cLinha 	:= ""
	nCont 	:= 1	
	While nCont <= Len(aJoin) 
		cLinha +=  '	   <Row>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="String">' + Trim(aPedidos[nCont][NUMPEDIDO]) + '</Data></Cell>' + Chr(13) + Chr(10) // + cComent1 + Trim(aPedidos[nCont][COMENTS]) + cComent2 + '</Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="String">' + Trim(aPedidos[nCont][CLIENTE]) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][QTD])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s43"><Data ss:Type="DateTime">' + CONVERT_DT(Trim(DToC(aPedidos[nCont][EMISSAO]))) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s43"><Data ss:Type="DateTime">' + CONVERT_DT(Trim(DToC(aJoin[nCont][DATAENT]))) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s44" ss:Formula="=(RC[-1]-TODAY())"><Data ss:Type="Number"></Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][REVEND])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][REFRIG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][CALDEI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][COCCAO])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][MOBILI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s42"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][NCLASS])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PROJET])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][APROVA])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][DESENV])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PROGRA])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][CPC])) 	  + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][MONTAG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][EXPEDI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][LOGIST])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PREFRIG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PCALDEI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)		
		cLinha +=  '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PCOCCAO])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PMOBILI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PTOTAL])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha +=  '	   </Row>	 ' + Chr(13) + Chr(10) 
		
		nCont += 1
	EndDo	
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicia movimentação com os arquivos³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      

	If !Empty(cPath)
		cArqPesq := cPath
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Cria um arquivo do tipo *.xml para ser utilizado em FWRITE                        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nHandle := FCREATE(cArqPesq, 0)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If FERROR() != 0
			Alert("Não foi possível abrir ou criar o arquivo: " + cPath)
		Else
			
		cScript := '<?xml version="1.0"?>	 ' + Chr(13) + Chr(10)
		cScript += '<?mso-application progid="Excel.Sheet"?>	 ' + Chr(13) + Chr(10)
		cScript += '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13) + Chr(10)
		cScript += 'xmlns:o="urn:schemas-microsoft-com:office:office"	 ' + Chr(13) + Chr(10)
		cScript += 'xmlns:x="urn:schemas-microsoft-com:office:excel"	 ' + Chr(13) + Chr(10)
		cScript += 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13) + Chr(10)
		cScript += 'xmlns:html="http://www.w3.org/TR/REC-html40">	 ' + Chr(13) + Chr(10)
		cScript += '<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">	 ' + Chr(13) + Chr(10)
		cScript += '<Author>Cozil</Author>	 ' + Chr(13) + Chr(10)
		cScript += '<LastAuthor>Cozil</LastAuthor>	 ' + Chr(13) + Chr(10)
		cScript += '<LastPrinted>2011-03-21T15:08:04Z</LastPrinted>	 ' + Chr(13) + Chr(10)
		cScript += '<Created>2011-03-21T14:51:27Z</Created>	 ' + Chr(13) + Chr(10)
		cScript += '<LastSaved>2011-03-21T15:09:48Z</LastSaved>	 ' + Chr(13) + Chr(10)
		cScript += '<Company>Kille®Soft</Company>	 ' + Chr(13) + Chr(10)
		cScript += '<Version>11.9999</Version>	 ' + Chr(13) + Chr(10)
		cScript += '</DocumentProperties>	 ' + Chr(13) + Chr(10)
		cScript += '<ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '<WindowHeight>8700</WindowHeight>	 ' + Chr(13) + Chr(10)
		cScript += '<WindowWidth>19995</WindowWidth>	 ' + Chr(13) + Chr(10)
		cScript += '<WindowTopX>120</WindowTopX>	 ' + Chr(13) + Chr(10)
		cScript += '<WindowTopY>120</WindowTopY>	 ' + Chr(13) + Chr(10)
		cScript += '<ProtectStructure>False</ProtectStructure>	 ' + Chr(13) + Chr(10)
		cScript += '<ProtectWindows>False</ProtectWindows>	 ' + Chr(13) + Chr(10)
		cScript += '</ExcelWorkbook>	 ' + Chr(13) + Chr(10)
		cScript += '<Styles>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="Default" ss:Name="Normal">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders/>	 ' + Chr(13) + Chr(10)
		cScript += '<Font/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '<NumberFormat/>	 ' + Chr(13) + Chr(10)
		cScript += '<Protection/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="m157172600">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="m157172610">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="m157172640">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="m157172650">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="m157172660">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s21">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s28">	 ' + Chr(13) + Chr(10)
		cScript += '<Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s34">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Bottom" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s38">	 ' + Chr(13) + Chr(10)
		cScript += '<Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s39">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s41">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
   		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s42">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
   		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<Interior ss:Color="#99CCFF" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s43">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
   		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<NumberFormat ss:Format="Short Date"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '<Style ss:ID="s44">	 ' + Chr(13) + Chr(10)
		cScript += '<Borders>	 ' + Chr(13) + Chr(10)
   		cScript += '<Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Borders>	 ' + Chr(13) + Chr(10)
		cScript += '<NumberFormat ss:Format="0"/>	 ' + Chr(13) + Chr(10)
		cScript += '</Style>	 ' + Chr(13) + Chr(10)
		cScript += '</Styles>	 ' + Chr(13) + Chr(10)
		cScript += '<Worksheet ss:Name="Plan1">	 ' + Chr(13) + Chr(10)
		cScript += '<Table ss:ExpandedColumnCount="256" ss:ExpandedRowCount="' + AllTrim(Str(Len(aJoin) + 10)) + '" x:FullColumns="1"	 ' + Chr(13) + Chr(10)
		cScript += 'x:FullRows="1">	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="45"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="261"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="29.25"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="54"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="57"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="41.25"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:StyleID="s21" ss:Width="17.25" ss:Span="18"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Column ss:Index="26" ss:AutoFitWidth="0" ss:Width="39" ss:Span="230"/>	 ' + Chr(13) + Chr(10)
		cScript += '<Row ss:AutoFitHeight="0" ss:Height="15.75">	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:MergeAcross="24" ss:StyleID="m157172600"><Data ss:Type="String">MONITORAMENTO DOS PEDIDOS PENDENTES</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '</Row>	 ' + Chr(13) + Chr(10)
		cScript += '<Row ss:AutoFitHeight="0" ss:Height="33" ss:StyleID="s28">	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:MergeAcross="11" ss:StyleID="m157172610"><Data ss:Type="String">Dados inseridos no cadastro</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:MergeAcross="7" ss:StyleID="m157172650"><Data ss:Type="String">Liberacao dos Equipamentos</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:MergeAcross="3" ss:StyleID="m157172660"><Data ss:Type="String">Equipamentos Montados</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:MergeDown="1" ss:StyleID="m157172640"><Data ss:Type="String">Total Finalizado</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '</Row>	 ' + Chr(13) + Chr(10)
		cScript += '<Row ss:AutoFitHeight="0" ss:Height="51">	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Pedido</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Cliente</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Qtd.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Entrada</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Entrega</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s38"><Data ss:Type="String">Atraso</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Revenda</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Refrig.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Caldeiraria</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Coccao</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Mobiliario</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">N. Classif.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Projetos</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Aprovacao</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Desenv.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Prog.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Corte</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Montagem</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Expedicao</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Logistica</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Refrig.</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Caldeiraria</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Coccao</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '<Cell ss:StyleID="s34"><Data ss:Type="String">Mobiliario</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '</Row>	 ' + Chr(13) + Chr(10)

		cScript +=  cLinha
		
		cScript += '	  </Table>	 ' + Chr(13) + Chr(10)
		cScript += '	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <PageSetup>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Layout x:Orientation="Landscape"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Header x:Margin="0.49212598499999999"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Footer x:Margin="0.49212598499999999"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <PageMargins x:Bottom="0.984251969" x:Left="0.78740157499999996"	 ' + Chr(13) + Chr(10)
		cScript += '	     x:Right="0.78740157499999996" x:Top="0.984251969"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </PageSetup>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Print>	 ' + Chr(13) + Chr(10)
		cScript += '	    <ValidPrinterInfo/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Scale>75</Scale>	 ' + Chr(13) + Chr(10)
		cScript += '	    <HorizontalResolution>300</HorizontalResolution>	 ' + Chr(13) + Chr(10)
		cScript += '	    <VerticalResolution>0</VerticalResolution>	 ' + Chr(13) + Chr(10)
		cScript += '	    <NumberofCopies>0</NumberofCopies>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Print>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Selected/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Panes>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	     <Number>3</Number>	 ' + Chr(13) + Chr(10)
		cScript += '	     <ActiveRow>3</ActiveRow>	 ' + Chr(13) + Chr(10)
		cScript += '	     <ActiveCol>18</ActiveCol>	 ' + Chr(13) + Chr(10)
		cScript += '	    </Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Panes>	 ' + Chr(13) + Chr(10)
		cScript += '	   <ProtectObjects>False</ProtectObjects>	 ' + Chr(13) + Chr(10)
		cScript += '	   <ProtectScenarios>False</ProtectScenarios>	 ' + Chr(13) + Chr(10)
		cScript += '	  </WorksheetOptions>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
	   	cScript += '	  <Range>R4C6:R5000C6</Range>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  <Condition>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Qualifier>Greater</Qualifier>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Value1>7</Value1>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Format Style="background:#339966"/>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  </Condition>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  <Condition>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Qualifier>Between</Qualifier>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Value1>1</Value1>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Value2>7</Value2>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Format Style="background:#FFCC00"/>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  </Condition>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  <Condition>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Qualifier>LessOrEqual</Qualifier>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Value1>0</Value1>	 ' + Chr(13) + Chr(10)
	   	cScript += '	   <Format Style="font-weight:700;background:red"/>	 ' + Chr(13) + Chr(10)
	   	cScript += '	  </Condition>	 ' + Chr(13) + Chr(10)
	  	cScript += '	  </ConditionalFormatting>	 ' + Chr(13) + Chr(10)
		cScript += '	 </Worksheet>	 ' + Chr(13) + Chr(10)
		cScript += '	</Workbook>	 ' + Chr(13) + Chr(10)
		

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Descarrega a variavel cScript no Arquivo contifo em nHandle                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If( FWRITE(nHandle, cScript) == 0)
				Alert("Não foi possível gravar o arquivo!")  //"Não foi possível gravar o arquivo!"
			EndIf
			
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Fecha o arquivo gravado                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FCLOSE(nHandle)
			
			//SplitPath( alltrim(cArqPesq),,, @cFile, @cExten )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Abre a Planilha em Excel                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			
			ShellExecute( "Open", cPath,"",Substr(cPath,1,9), 1 )
			
			/*
			If nRet <= 32
				cCompl := ""
				If nRet == 31
					cCompl := " Nao existe aplicativo associado a este tipo de arquivo !"
				EndIf
				Aviso( "Atencao !", "Nao foi possivel abrir o objeto!" + cCompl, { "Ok" }, 2 ) 	 //#########
				lRet := .F.
			Else
				lRet := .T.
			EndIf
			*/
			
			
		Endif
	Else
		Alert("Diretório não Informado!, Não foi possível gravar o arquivo!")  //"Não foi possível gravar o arquivo!"
		lRet := .F.
	EndIf
Return()      


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CONVERT_DTºAutor  ³Microsiga           º Data ³  03/24/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function CONVERT_DT(cData)
	Local cDataRet
	cDataRet := "20"
	cDataRet += SubStr(cData, 7, 2)
	cDataRet += "-"
	cDataRet += SubStr(cData, 4, 2)	
	cDataRet += "-"            
	cDataRet += SubStr(cData, 1, 2)
	cDataRet += "T00:00:00.000"
Return(cDataRet)
