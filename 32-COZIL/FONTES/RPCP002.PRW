#INCLUDE "protheus.ch"
#INCLUDE "TOPCONN.CH"

/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa    RPCP002  Autor  WILLIAM LUIZ ANTUNES  Data  21/03/2011	 	**
******************************************************************************
** Descricao   Relatorio de monitoramento dos processos da fabrica 	   	**
******************************************************************************
** Uso         AP COZIL EQUIPAMENTOS                                 	**
******************************************************************************
******************************************************************************
*****************************************************************************/

User Function RPCP002()

//***************************************************************************
//  Declaracao de variaveis.                                                 
//***************************************************************************

Local aArea   := GetArea()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Monitoramento dos pedidos pendentes"
Local cDesc1  := "Ao clicar em OK será emitido o relatório de monitoramento dos pedidos"
Local cDesc2  := ""
Local cDesc3  := ""    

//Mensagem

MsgAlert("Este relatório está sendo liberado em fase de testes. Não utilize-o como único meio de extração de dados.", "Atenção")

//***************************************************************************
//  Criando array com descricao do programa para adicionar no FormBatch. 
//***************************************************************************
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

//***************************************************************************
//  Criando array com botoes do FormBatch.                               
//***************************************************************************

aAdd( aButton, { 1, .T., {|| Processa( {|lEnd| BUSCA_PED()}, "Aguarde...", "Executando rotina.", .T.)            }} )
aAdd( aButton, { 2, .T., {|| nOpc := 2, FechaBatch() }} )

//***************************************************************************
//  Funcao que ativa o FormBatch.                                        
//***************************************************************************

FormBatch( cTitulo, aSay, aButton )

If nOpc == 2 				// cancelou a rotina
	RestArea( aArea )
	Return
Endif

RestArea( aArea )
Return()
/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa  |BUSCA_PED  Autor   William Gurzoni       Data    03/21/11	**
******************************************************************************
** Desc.                                                    	       **
**                                                        	       **
******************************************************************************
** Uso         AP                                                	**
******************************************************************************
*****************************************************************************/

Static Function BUSCA_PED()      

//***************************************************************************
// DECLARACAO DAS VARIAVEIS 
//***************************************************************************

	Local 	aPedidos 	:= {} 		// VARIAVEL RESPONSAVEL POR COLETAR TODOS OS PEDIDOS EM ABERTO
	Local	aItens		:= {}
	Local 	aJoin		:= {} 		// VARIAVEL RESPONSAVEL POR COLETAR DADOS ATRAVES DO ARRAY (aPedidos)
	Local 	cXPCP		:= ""	                                                                                                        
	Local	nPedID		:= 1   	// VARIAVEL UTILIZADA PARA CONTAR OS PEDIDOS NO LOOGING DE ATRIBUICAO     
	Local 	nCont		:= 0   	// VARIAVEL UTILIZADA EM VARIOS PONTOS DO COD. COMO TEMPORARIA
	Local 	cLinha		:= ""   	// VARIAVEL UTILIZADA PARA ARMAZENAMENTO DAS LINHAS DINAMICAS DO RELATORIO            
	Local 	cScript	:= ""		// VARIAVEL UTILIZADA PARA GERAR O CODIGO XML
	Local 	cPath		:= "c:\msiga\monitoramento_pedidos.xml"	
	Local	cComent1	:= ""		//Observacoes
	Local	cComent2	:= ""		//Observacoes	
	Local 	cTipoProd	:= ""		//Variavel utilizada para armazenar o tipo de produto lidado
	Local	cVersao	:= "1.4"	//1.4 - Marco - 2013
	Local	nCnt		:= 0
	Local	lSomLicit	:= .F.		//Imprime somente licitações?

	ProcRegua(nCnt)
	
// [INICIO] CONSTANTES UTILIZADAS PARA FACILITAR O ENTENDIMENTO DOS ARRAYS (aPedidos)
		
   	#DEFINE REFRIG 	1    		
	#DEFINE CALDEI 	2
	#DEFINE COCCAO 	3
	#DEFINE MOBILI 	4
	#DEFINE NCLASS	6
	#DEFINE QTD		7
	#DEFINE REVEND	8
	#DEFINE PROJET	9
	#DEFINE APROVA	10
	#DEFINE DESENV	11
	#DEFINE PROGRA	12
	#DEFINE CPC		13
	#DEFINE MONTAG	14
	#DEFINE EXPEDI	15			
	#DEFINE LOGIST	16			
	#DEFINE PREFRIG	17
	#DEFINE PCALDEI	18     	//OBS. O "P" NA FRENTE SIGNIFICA "PRONTO"
	#DEFINE PCOCCAO	19
	#DEFINE PMOBILI	20
	#DEFINE PTOTAL	21	 
	#DEFINE DATAENT	22	
	#DEFINE QTDACU	23			//QUANTIDADE ACUMULATIVA DOS PRODUTOS NO ITEM DO PEDIDO 
		
// [ FIM ] CONSTANTES UTILIZADAS PARA FACILITAR O ENTENDIMENTO DOS ARRAYS (aPedidos) 
                 
	#DEFINE NUMPEDIDO	2
	#DEFINE CLIENTE	3
	#DEFINE EMISSAO	4
	#DEFINE COMENTS	5 
	#DEFINE EMCOMP	6			//EM PEDIDO DE COMPRAS (NAO ATENDIDO)
	#DEFINE COMPRA	7			//ITENS COMPRADOS		
	
	
// Verifica se imprime somente licitações

	lSomLicit := MSGYESNO("Imprime somente licitações")	
	
	
//***************************************************************************
// BUSCA OS PEDIDOS EM ABERTO E ARMAZENA NO ARRAY aPedidos  
//***************************************************************************	
	
	
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	dbGotop()                          
	nCont := 1
	While !Eof() .And. xFilial("SC5") == C5_FILIAL 
		IncProc("Agrupando pedidos em aberto")		
		If SC5->C5_NOTA == "         "	//Verifica se o pedido ainda esta em producao
			If lSomLicit
				If SC5->C5_TIPO == "N" .And. (SC5->C5_XTPPV = "B" .OR. SC5->C5_XTPPV = "L")	//Verifica se o pedido e normal (se nao se trata de um pedido com utilizacao de fornecedor, para remessa ou devolucao) , Verifica tambem se o pedido nao e da assistencia tecnica.
					Aadd(aPedidos,	{	nCont					,; //ID 
										SC5->C5_NUM				,;
										Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE,"A1_NOME") ,;
										SC5->C5_EMISSAO			,;
										SC5->C5_XHISTOR			,;
										0							,;
										0							})
									
					nCont++ 
				EndIf
			Else
				If SC5->C5_TIPO == "N" .And. (SC5->C5_XTPPV = "B" .OR. SC5->C5_XTPPV = "L" .OR. SC5->C5_XTPPV = "V" .OR. SC5->C5_XTPPV = "N")	//Verifica se o pedido e normal (se nao se trata de um pedido com utilizacao de fornecedor, para remessa ou devolucao) , Verifica tambem se o pedido nao e da assistencia tecnica.
					Aadd(aPedidos,	{	nCont					,; //ID 
										SC5->C5_NUM				,;
										Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE,"A1_NOME") ,;
										SC5->C5_EMISSAO			,;
										SC5->C5_XHISTOR			,;
										0							,;
										0							})
									
					nCont++ 
				EndIf
			EndIf
		EndIf
		dbSkip()
	Enddo

//***************************************************************************
// REALIZA NOVO FILTRO AOS PEDIDOS, VERIFICANDO SE OS PEDIDOS QUE FORAM 
// SELECIONADOS ACIMA (AQUELES QUE AINDA NAO TEM NOTA) SE ESTAO NO  
// PAINEL DE PEDIDOS					    
//***************************************************************************
	
	                        
	If Len(aPedidos) > 0 
		nCont := 1                               		
		While nCont < Len(aPedidos)
			If PED_FINALIZ(aPedidos[nCont][2])   	// Se o pedido nao tiver itens pendentes (xstatus = 9)
				aDel(aPedidos, nCont)				// Deleta pedido do array
				aSize(aPedidos, Len(aPedidos)-1)	// Ajusta tamanho do array
			Else
				nCont++
			EndIf		
		EndDo			
	Else
		Alert("Não foram encontrados pedidos em fabricação")
	EndIf
	                        	                        
//***************************************************************************
// COM BASE NO ARRAY CRIADO ACIMA (aPedidos), E FEITA UMA VARREDURA PELOS 
// ITENS, CONTANDO AS OCORRENCIAS DOS SETORES DA FABRICA         
//***************************************************************************
    
    nPedID := 1       

	IncProc("Verificando Status de Fábrica, Pedidos de Compra e Notas de Entrada")
	
	While nPedID <= Len(aPedidos) 		
		dbSelectArea("SC6")
    	dbSetOrder(1)
		DbSeek(xFilial("SC6") + aPedidos[nPedID][2])				// PESQUISA PEDIDO
		Aadd(aJoin, {0, 0, 0, 0, SC6->C6_NUM, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Date(), 0})	  	//ADICIONA NOVA LINHA NO ARRAY
		aJoin[nPedID][DATAENT] := CToD("01/01/3001")																	//INICIALIZA A VARIAVEL DE DATA DE ENTREGA
		While !Eof() .And. xFilial("SC6") == C6_FILIAL .And. SC6->C6_NUM == aPedidos[nPedID][2]              	//PERCORRE TODOS OS ITENS DO PEDIDO
	    				
			cTipoProd := Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_TIPO")
				
			aJoin[nPedID][QTD]++										// INCREMENTA O VALOR DA QTD DE ITENS
			
			aJoin[nPedID][QTDACU] += SC6->C6_QTDVEN				// INCREMENTA A QUANTIDADE ACUMULADA DE CADA PEDIDO  
			
			cXPCP := Posicione("SB1",1,xFilial("SB1") + SC6->C6_PRODUTO,"B1_XPCP") //RESGATA VALOR DO CADASTRO DE PRODUTOS (SETOR DA FABRICA)
			  
			cXPCP := VAL(cXPCP) 										// PASSA O VALOR RESGATADO PARA NUMERICO

//***************************************************************************
// Acumula as quantidades das revendas											     
//*************************************************************************** 			
			
			If cTipoProd == "RV"
				aJoin[nPedID][REVEND] += SC6->C6_QTDVEN											
			EndIf
			
//***************************************************************************
// Registra o valor do campo data de entrega,   Pega o menor valor de entrega
// dentre os itens  
//*************************************************************************** 
            	
			If aJoin[nPedID][DATAENT] > SC6->C6_ENTREG
           	aJoin[nPedID][DATAENT] := SC6->C6_ENTREG
         	EndIf
			  
//***************************************************************************
// ESTA ROTINA FAZ O ACUMULO DAS VARIAVEIS POR SETOR DA PRODUCAO 
//***************************************************************************
			
			If cTipoProd == "PA" .OR. cTipoProd == "PI"
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
					OTHERWISE					
							aJoin[nPedID][NCLASS]++     									// NO CASO DE NAO ESTAR PREENCHIDO E NEM SER REVENDA
				EndCase
				 	    					
//***************************************************************************
// ESTA ROTINA FAZ UM RESUMO DO PAINEL DO PEDIDO 
//***************************************************************************
				
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
			EndIf								// Encerra validacao de PA / PI
					
			dbSkip() 							// PULA PARA O PROXIMO ITEM
		Enddo                    
				
		aPedidos[nPedID][EMCOMP] := EM_PED_COM(aPedidos[nPedID][NUMPEDIDO])	// FUNCAO QUE PERCORRE OS PEDIDOS DE COMPRA TENTANDO ACHAR ITENS RELACIONADOS
		aPedidos[nPedID][COMPRA] := EM_NF_COM(aPedidos[nPedID][NUMPEDIDO])		// FUNCAO QUE PERCORRE OS PEDIDOS DE COMPRA TENTANDO ACHAR ITENS RELACIONADOS								      							                    			
		
		nPedID++   																	// INCREMENTA O CONTROLE DE PEDIDO
		                            									
	EndDo

//***************************************************************************
// Adiciona TAGS de observacao 
//***************************************************************************

		cComent1 := '<Comment	 ' + Chr(13) + Chr(10)
    	cComent1 += '  ss:Author="Cozil"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><B><Font	 ' + Chr(13) + Chr(10)
    	cComent1 += '     html:Face="Tahoma" html:Size="8" html:Color="#000000">Observacoes:</Font></B><Font	 ' + Chr(13) + Chr(10)
    	cComent1 += '    html:Face="Tahoma" html:Size="8" html:Color="#000000">&#10;	 ' + Chr(13) + Chr(10)
    	cComent2 := '</Font></ss:Data></Comment>'
 
//***************************************************************************
// Faz varredura e prepara para impressao  
//***************************************************************************

	cLinha 	:= ""
	nCont 		:= 1	
	
	IncProc("Agrupando itens para impressão")
	
	While nCont <= Len(aJoin) 
		
		cLinha += '	   <Row>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell><Data ss:Type="String">' + Trim(aPedidos[nCont][NUMPEDIDO]) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:Formula="=IF(RC[28]&lt;&gt;0,IF(RC[3]&gt;RC[28],&quot;M&quot;,&quot;R&quot;),&quot;F&quot;)"><Data ss:Type="String">M</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell><Data ss:Type="String">' + Trim(aPedidos[nCont][CLIENTE]) + '</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">' + Trim(aPedidos[nCont][COMENTS]) + '</Font></ss:Data></Comment></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][QTD])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][QTDACU])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s61"><Data ss:Type="DateTime">' + CONVERT_DT(Trim(DToC(aPedidos[nCont][EMISSAO]))) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s61"><Data ss:Type="DateTime">' + CONVERT_DT(Trim(DToC(aJoin[nCont][DATAENT]))) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s62" ss:Formula="=(RC[-1]-TODAY())"><Data ss:Type="Number">-196</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][REFRIG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][CALDEI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][COCCAO])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][MOBILI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][NCLASS])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PROJET])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][APROVA])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][DESENV])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PROGRA])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][CPC])) 	+ '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][MONTAG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][EXPEDI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][LOGIST])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PREFRIG])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PCALDEI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PCOCCAO])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][PMOBILI])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41" ss:Formula="=RC[-17]-RC[-4]"><Data ss:Type="Number">2</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41" ss:Formula="=RC[-17]-RC[-4]"><Data ss:Type="Number">0</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41" ss:Formula="=RC[-17]-RC[-4]"><Data ss:Type="Number">0</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s41" ss:Formula="=RC[-17]-RC[-4]"><Data ss:Type="Number">3</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aJoin[nCont][REVEND])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aPedidos[nCont][EMCOMP])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63"><Data ss:Type="Number">' + AllTrim(Str(aPedidos[nCont][COMPRA])) + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63" ss:Formula="=IF(RC[-3]=RC[-1],&quot;OK&quot;,&quot;F&quot;)"><Data ss:Type="String">F</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s63" ss:Formula="=IF((RC[-25]+RC[-24]+RC[-23]+RC[-22])=(RC[-12]+RC[-11]+RC[-10]+RC[-9]),&quot;OK&quot;,&quot;F&quot;)"><Data ss:Type="String">F</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	    <Cell ss:StyleID="s64" ><Data ss:Type="Number">0</Data></Cell>	 ' + Chr(13) + Chr(10)
		cLinha += '	   </Row>	 ' + Chr(13) + Chr(10)
				
		nCont += 1
	EndDo	
    
//***************************************************************************
// Inicia movimentação com os arquivos 
//***************************************************************************

	If !Empty(cPath)
		cArqPesq := cPath
		
		//***************************************************************************
		// Cria um arquivo do tipo *.xml para ser utilizado em FWRITE                         
		//***************************************************************************
		
		nHandle := FCREATE(cArqPesq, 0)
		
		//***************************************************************************
		// Verifica se o arquivo pode ser criado, caso contrario um alerta sera exibido       
		//***************************************************************************
		
		If FERROR() != 0
			Alert("Não foi possível abrir ou criar o arquivo: " + cPath)
		Else
			
		cScript := '	<?xml version="1.0"?>	 ' + Chr(13) + Chr(10)
		cScript += '	<?mso-application progid="Excel.Sheet"?>	 ' + Chr(13) + Chr(10)
		cScript += '	<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13) + Chr(10)
		cScript += '	 xmlns:o="urn:schemas-microsoft-com:office:office"	 ' + Chr(13) + Chr(10)
		cScript += '	 xmlns:x="urn:schemas-microsoft-com:office:excel"	 ' + Chr(13) + Chr(10)
		cScript += '	 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13) + Chr(10)
		cScript += '	 xmlns:html="http://www.w3.org/TR/REC-html40">	 ' + Chr(13) + Chr(10)
		cScript += '	 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">	 ' + Chr(13) + Chr(10)
		cScript += '	  <Author>Cozil</Author>	 ' + Chr(13) + Chr(10)
		cScript += '	  <LastAuthor>william</LastAuthor>	 ' + Chr(13) + Chr(10)
		cScript += '	  <LastPrinted>2011-10-24T11:01:58Z</LastPrinted>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Created>2011-03-21T14:51:27Z</Created>	 ' + Chr(13) + Chr(10)
		cScript += '	  <LastSaved>2011-10-24T14:14:12Z</LastSaved>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Company>KilleSoft</Company>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Version>11.9999</Version>	 ' + Chr(13) + Chr(10)
		cScript += '	 </DocumentProperties>	 ' + Chr(13) + Chr(10)
		cScript += '	 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	  <WindowHeight>8700</WindowHeight>	 ' + Chr(13) + Chr(10)
		cScript += '	  <WindowWidth>19995</WindowWidth>	 ' + Chr(13) + Chr(10)
		cScript += '	  <WindowTopX>120</WindowTopX>	 ' + Chr(13) + Chr(10)
		cScript += '	  <WindowTopY>120</WindowTopY>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ProtectStructure>False</ProtectStructure>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ProtectWindows>False</ProtectWindows>	 ' + Chr(13) + Chr(10)
		cScript += '	 </ExcelWorkbook>	 ' + Chr(13) + Chr(10)
		cScript += '	 <Styles>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="Default" ss:Name="Normal">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NumberFormat/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Protection/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656480">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656500">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="11" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656510">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656520">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656530">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656540">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="m28656560">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s21">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s22">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s31">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s32">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s33">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s35">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="11" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s40">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#969696" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s41">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s43">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s50">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss" ss:Size="8"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s53">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Bottom" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s54">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s55">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s56">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:Rotate="90"	 ' + Chr(13) + Chr(10)
		cScript += '	    ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s57">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Top" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s58">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Top" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s59">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Top" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s60">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Top" ss:Rotate="90"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s61">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NumberFormat ss:Format="Short Date"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s62">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NumberFormat ss:Format="0"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s63">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#99CCFF" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s64">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#FFFF99" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s65">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s66">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NumberFormat ss:Format="Short Date"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s67">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NumberFormat ss:Format="0"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s68">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior ss:Color="#99CCFF" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s69">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s75">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s76">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s77">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s78">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s79">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s80">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Bottom" ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Style ss:ID="s81">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Alignment ss:Vertical="Bottom" ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="2"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
		cScript += '	 </Styles>	 ' + Chr(13) + Chr(10)
		cScript += '	 <Worksheet ss:Name="Plan1">	 ' + Chr(13) + Chr(10)
		cScript += '	  <Names>	 ' + Chr(13) + Chr(10)
		cScript += '	   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=Plan1!R4C1:R4C35"	 ' + Chr(13) + Chr(10)
		cScript += '	    ss:Hidden="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	  </Names>	 ' + Chr(13) + Chr(10)
		cScript += '	  <Table ss:ExpandedColumnCount="256" ss:ExpandedRowCount="' + AllTrim(Str(Len(aJoin) + 10)) + '" x:FullColumns="1"	 ' + Chr(13) + Chr(10)
		cScript += '	   x:FullRows="1">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="45"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s22" ss:AutoFitWidth="0" ss:Width="16.5"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="261"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="25.5"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="26.25"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:Width="53.25" ss:Span="1"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:Index="8" ss:StyleID="s21" ss:Width="33.75"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:Width="17.25" ss:Span="11"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:Index="21" ss:StyleID="s21" ss:AutoFitWidth="0" ss:Width="18"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:StyleID="s21" ss:Width="17.25" ss:Span="13"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Column ss:Index="36" ss:AutoFitWidth="0" ss:Width="39" ss:Span="220"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="15.75">	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="34" ss:StyleID="m28656480"><Data ss:Type="String">MONITORAMENTO DOS PEDIDOS PENDENTES - Versão ' + cVersao + '</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Row>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="15.75">	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s31"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s32"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="7" ss:StyleID="s35"><Data ss:Type="String">Por setor administrativo</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="7" ss:StyleID="m28656500"><Data ss:Type="String">Por setor de fabricação</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s33"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s40"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Row>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="33" ss:StyleID="s43">	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="12" ss:StyleID="m28656510"><Data ss:Type="String">Dados inseridos no cadastro</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="7" ss:StyleID="m28656520"><Data ss:Type="String">Painel de pedidos - Itens pendentes em cada setor</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Esta parte do relat&#xF3;rio &#xE9; alimentada atrav&#xE9;s do painel de pedidos. Apresenta a quantidade de itens pendentes por setor.</Font></ss:Data></Comment></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="3" ss:StyleID="m28656530"><Data ss:Type="String">Equipamentos Montados</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Apresenta os itens j&#xE1; montados de acordo com a classifica&#xE7;&#xE3;o do produto.</Font></ss:Data></Comment></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="3" ss:StyleID="m28656540"><Data ss:Type="String">Equipamentos Pendentes</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="s50"><Data ss:Type="String">Revenda</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:Family="Swiss" html:Size="9" html:Color="#000000">Apresenta os itens de revenda. As quantidades apresentadas s&#xE3;o quantidades de produtos f&#xED;sicos (item x quantidade informada nos pedidos).</Font></ss:Data></Comment></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m28656560"><Data ss:Type="String">Status Final</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s53"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Row>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="68.25">	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s54"><Data ss:Type="String">Pedido</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">N&#xFA;mero do pedido de venda.</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s55"><Data ss:Type="String">Conteudo</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Conte&#xFA;do do pedido de venda em rela&#xE7;&#xE3;o ao tipo de produto.F=Cont&#xE9;m somente itens de fabrica&#xE7;&#xE3;o. R=Cont&#xE9;m somente itens de revenda. M=Pedido misto. </Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s54"><Data ss:Type="String">Cliente</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Raz&#xE3;o social do cliente</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s56"><Data ss:Type="String">Qtd. Itens</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><B><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Quantidade de itens diferentes no pedido, cada item gerar&#xE1; uma OP, em caso de ser Produto Acabado (PA) e n&#xE3;o haver estoque.	 ' + Chr(13) + Chr(10)
		cScript += '			Em caso de ser Revenda (RV) ser&#xE1; apresentado nos relat&#xF3;rios dos respons&#xE1;veis pela compra.</Font></B></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s56"><Data ss:Type="String">Qtd. Produtos</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Totaliza os itens que devem ser produzidos / comprados.</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s54"><Data ss:Type="String">Entrada</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Data de entrada do pedido</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s54"><Data ss:Type="String">Entrega</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Data da primeira entrega a ser realizada. No sistema &#xE9; poss&#xED;vel uma data de entrega para cada item do pedido.</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s54"><Data ss:Type="String">Atraso</Data><Comment ss:Author="william"><ss:Data xmlns="http://www.w3.org/TR/REC-html40"><Font html:Face="Tahoma" x:CharSet="1" html:Size="9" html:Color="#000000">Atraso em rela&#xE7;&#xE3;o ao dia de hoje.</Font></ss:Data></Comment><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Refrig.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Caldeiraria</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Coccao</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Mobiliario</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">N. Classif.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Projetos</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Aprovacao</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Desenv.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Prog.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Corte</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Montagem</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Expedicao</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Logistica</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Refrig.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Caldeiraria</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Coccao</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Mobiliario</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Refrig.</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Caldeiraria</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Coccao</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Mobiliario</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Em PV</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s58"><Data ss:Type="String">Em PC</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s59"><Data ss:Type="String">Recebido</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s57"><Data ss:Type="String">Rer. OK</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s58"><Data ss:Type="String">Fab. OK</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s60"><Data ss:Type="String">Finalizado</Data><NamedCell ss:Name="_FilterDatabase"/></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Row>	 ' + Chr(13) + Chr(10)
		
		cScript +=  cLinha
		     
		/* campos de somatoria  - verificar o range a utilizar no excel.
		cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="13.5">	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s77"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s78"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79" ss:Formula="=SUM(R[- ' + Trim(Str(Len(aPedidos))) + ']C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">2544</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">2562</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s79"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">135</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">26</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">150</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">650</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">19</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">11</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">15</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">9</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">72</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">51</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">156</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">195</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">216</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">62</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">9</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">99</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">450</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">62</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">15</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">99</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">450</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">146</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">650</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">19</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">0</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s80" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">0</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Cell ss:StyleID="s81" ss:Formula="=SUM(R[-121]C:R[-1]C)"><Data	 ' + Chr(13) + Chr(10)
		cScript += '	      ss:Type="Number">639</Data></Cell>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Row>	 ' + Chr(13) + Chr(10)                 
		*/
		cScript += '	  </Table>	 ' + Chr(13) + Chr(10)
		cScript += '	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <PageSetup>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Layout x:Orientation="Landscape"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Header x:Margin="0.49212598499999999"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Footer x:Margin="0.49212598499999999"/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <PageMargins x:Bottom="0.984251969" x:Left="0.43" x:Right="0.32"	 ' + Chr(13) + Chr(10)
		cScript += '	     x:Top="0.984251969"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </PageSetup>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Print>	 ' + Chr(13) + Chr(10)
		cScript += '	    <ValidPrinterInfo/>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Scale>75</Scale>	 ' + Chr(13) + Chr(10)
		cScript += '	    <HorizontalResolution>300</HorizontalResolution>	 ' + Chr(13) + Chr(10)
		cScript += '	    <VerticalResolution>0</VerticalResolution>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Print>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Selected/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <FreezePanes/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <FrozenNoSplit/>	 ' + Chr(13) + Chr(10)
		cScript += '	   <SplitHorizontal>4</SplitHorizontal>	 ' + Chr(13) + Chr(10)
		cScript += '	   <TopRowBottomPane>4</TopRowBottomPane>	 ' + Chr(13) + Chr(10)
		cScript += '	   <ActivePane>2</ActivePane>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Panes>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	     <Number>3</Number>	 ' + Chr(13) + Chr(10)
		cScript += '	    </Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	     <Number>2</Number>	 ' + Chr(13) + Chr(10)
		cScript += '	     <ActiveRow>133</ActiveRow>	 ' + Chr(13) + Chr(10)
		cScript += '	     <ActiveCol>6</ActiveCol>	 ' + Chr(13) + Chr(10)
		cScript += '	    </Pane>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Panes>	 ' + Chr(13) + Chr(10)
		cScript += '	   <ProtectObjects>False</ProtectObjects>	 ' + Chr(13) + Chr(10)
		cScript += '	   <ProtectScenarios>False</ProtectScenarios>	 ' + Chr(13) + Chr(10)
		cScript += '	  </WorksheetOptions>	 ' + Chr(13) + Chr(10)
		cScript += '	  <AutoFilter x:Range="R4C1:R4C35"	 ' + Chr(13) + Chr(10)
		cScript += '	   xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	  </AutoFilter>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Range>R5C8:R125C8,R127C8:R4999C8</Range>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Greater</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>7</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:#339966"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Between</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>1</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value2>7</Value2>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:#FFCC00"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>LessOrEqual</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>0</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="font-weight:700;background:red"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	  </ConditionalFormatting>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Range>C33:C34</Range>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Equal</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>&quot;F&quot;</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:red"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Equal</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>&quot;OK&quot;</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:green"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	  </ConditionalFormatting>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Range>R5C35:R125C35</Range>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>RC35=RC4</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:green"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>RC35&lt;&gt;RC4</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:red"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	  </ConditionalFormatting>	 ' + Chr(13) + Chr(10)
		cScript += '	  <ConditionalFormatting xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13) + Chr(10)
		cScript += '	   <Range>C2</Range>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Equal</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>&quot;R&quot;</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:green"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Equal</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>&quot;F&quot;</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:red"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	   <Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Qualifier>Equal</Qualifier>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Value1>&quot;M&quot;</Value1>	 ' + Chr(13) + Chr(10)
		cScript += '	    <Format Style="background:yellow"/>	 ' + Chr(13) + Chr(10)
		cScript += '	   </Condition>	 ' + Chr(13) + Chr(10)
		cScript += '	  </ConditionalFormatting>	 ' + Chr(13) + Chr(10)
		cScript += '	 </Worksheet>	 ' + Chr(13) + Chr(10)
		cScript += '	</Workbook>	 ' + Chr(13) + Chr(10)
		
		cScript := EncodeUTF8(cScript) 

			//***************************************************************************
			// Descarrega a variavel cScript no Arquivo contifo em nHandle                        
			//***************************************************************************
			
			If( FWRITE(nHandle, cScript) == 0)
				Alert("Não foi poss*vel gravar o arquivo!")  //"Não foi poss*vel gravar o arquivo!"
			EndIf			
			
			//***************************************************************************
			// Fecha o arquivo gravado                                                            
			//***************************************************************************
			
			FCLOSE(nHandle)
			
			//SplitPath( alltrim(cArqPesq),,, @cFile, @cExten )
			
			//***************************************************************************
			//  Abre a Planilha em Excel                                                          
			//***************************************************************************
			
			
			ShellExecute( "Open", cPath,"",Substr(cPath,1,9), 1 )							
			
		Endif
	Else
		Alert("Diretório não Informado!, Não foi possível gravar o arquivo!")  
		lRet := .F.
	EndIf 	
	
Return()      


/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa   CONVERT_DT Autor   Microsiga             Data    03/24/11 	**
******************************************************************************
** Desc.                                                           	**
**                                                               	**
******************************************************************************
** Uso         AP                                                  	**
******************************************************************************
******************************************************************************
*****************************************************************************/

Static Function CONVERT_DT(cData)
	Local cDataRet
	cDataRet := ""
	cDataRet += SubStr(cData, 7, 4)
	cDataRet += "-"
	cDataRet += SubStr(cData, 4, 2)	
	cDataRet += "-"            
	cDataRet += SubStr(cData, 1, 2)
	cDataRet += "T00:00:00.000"
Return(cDataRet)   

/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa   EM_PED_COM		   WILLIAM LUIZ          Data    21/10/11	**
******************************************************************************
** Desc.       VERIFICA A EXISTENCIA DE PEDIDOS DE COMPRA PARA O ITEM    **
******************************************************************************
** Uso         AP                                                  	**
******************************************************************************
******************************************************************************
*****************************************************************************/                             

Static Function EM_PED_COM(cPedido, lEnd)
	Local nQTD 	:= 0    
	Local cQuery 	:= ""	               
		               
	cQuery := ""
	cQuery += "SELECT "
	cQuery += "SUM(C7_QUANT) AS C7_QUANT"
	cQuery += "FROM SC7" + xEmpresa() + "0 "
	cQuery += "INNER JOIN SB1010 ON B1_COD = C7_PRODUTO "
	cQuery += "WHERE "
	cQuery += "C7_XVENDA = '" + cPedido + "' AND "   
	cQuery += "B1_TIPO = 'RV' AND "   	
	cQuery += "SC7" + xEmpresa() + "0.D_E_L_E_T_ != '*'"
	
	cQuery := ChangeQuery(cQuery)
	  
	TCQUERY cQuery NEW ALIAS "TMP" 
	
	TMP->(DbGotop())

	If TMP->(Eof())
		TMP->(DbCloseArea())
		Return(0)
	Else
		nQTD := TMP->C7_QUANT
		TMP->(DbCloseArea())		
	EndIf	
	
Return(nQTD)  

/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa   EM_NF_COM		   WILLIAM LUIZ          Data    21/10/11    **
******************************************************************************
** Desc.       VERIFICA SE O ITEM JA FOI RECEBIDO PELO ALMOXARIFADO     	**
******************************************************************************
** Uso         AP                                                	**
******************************************************************************
******************************************************************************
*****************************************************************************/                             

Static Function EM_NF_COM(cPedido)
	Local nQTD 	:= 0    
	Local cQuery 	:= ""		    
	               
	cQuery := ""
	cQuery += "SELECT "
	cQuery += "SUM(C7_QUJE) AS C7_QUJE"
	cQuery += "FROM SC7" + xEmpresa() + "0 "
	cQuery += "INNER JOIN SB1010 ON B1_COD = C7_PRODUTO "
	cQuery += "WHERE "
	cQuery += "C7_XVENDA = '" + cPedido + "' AND "
	cQuery += "B1_TIPO = 'RV' AND "
	cQuery += "SC7" + xEmpresa() + "0.D_E_L_E_T_ != '*'"	
	
	cQuery := ChangeQuery(cQuery)
	  
	TCQUERY cQuery NEW ALIAS "TMP1" 
		
	TMP1->(DbGotop())

	If TMP1->(Eof())
		TMP1->(DbCloseArea())
		Return(0)
	Else
		nQTD := TMP1->C7_QUJE
		TMP1->(DbCloseArea())		
	EndIf
     
Return(nQTD)

/*****************************************************************************
******************************************************************************
******************************************************************************
** Programa  PED_FINALIZ		   WILLIAM LUIZ          Data    25/10/11	**
******************************************************************************
** Desc.       VERIFICA SE O PEDIDO JA FOI FINALIZADO NO PAINEL, 	     	**
** 		     CASO AFIRMATIVO RETORNA .T.					 	     		**
******************************************************************************
** Uso         AP                                                 	**
******************************************************************************
******************************************************************************
*****************************************************************************/                             

Static Function PED_FINALIZ(cPedido)
	Local cQuery 	:= ""		
	               
	cQuery := ""
	cQuery += "SELECT "
	cQuery += "C6_NUM "
	cQuery += "FROM SC6" + xEmpresa() + "0 "
	cQuery += "INNER JOIN SB1010 "
	cQuery += "ON C6_PRODUTO = B1_COD "
	cQuery += "WHERE "
	cQuery += "C6_NUM = '" + cPedido + "' AND "   
	cQuery += "C6_XSTATUS != '9' AND "   	
	//cQuery += "B1_TIPO IN ('PA','PI') AND "    -- Esta linha estava eliminando os pedidos somente revenda
	cQuery += "SC6" + xEmpresa() + "0.D_E_L_E_T_ != '*'" 
	
	cQuery := ChangeQuery(cQuery)
	  
	TCQUERY cQuery NEW ALIAS "TMP2" 
		
	TMP2->(DbGotop())

	If TMP2->(Eof())
		TMP2->(DbCloseArea())
		Return(.T.)
	Else
		TMP2->(DbCloseArea())		
		Return(.F.)
	EndIf
     
Return(.F.)