#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RMAT005  ºAutor  ³William L. Gurzoni  º Data ³  05/09/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio de Impressao de Estrutura de produtos em Excel   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COZIL EQUIPAMENTOS                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function RMAT005()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea   := GetArea()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Estrutura Completa de Produtos"
Local cDesc1  := "Este programa tem como objetivo a geração de uma planilha em Excel (.xml) "
Local cDesc2  := "contendo informações da Estrutura de Produtos conforme os parâmetros "
Local cDesc3  := "informados pelo usuário. "

Private cPerg	  := "RMAT05"

MsgAlert("Este relatório ainda está em fase de teste. Não utilize-o como forma principal para obtenção de dados.", "Atenção - Relatório alterado (v1.2)")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria perguntas no SX1.                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ mv_par01 - Num da OP manual: ?       ³
//³ mv_par02 - Arquivo XML 			 ³
//³ mv_par02 - Item		 			 ³
//³ mv_par02 - Sequencia	 			 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

CriaSx1_2(cPerg)
Pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com descricao do programa para adicionar no FormBatch.³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aSay, cDesc1 )
aAdd( aSay, cDesc2 )
aAdd( aSay, cDesc3 )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Criando array com botoes do FormBatch.                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aAdd( aButton, { 5, .T., {|| Pergunte(cPerg,.T.)     }} )
aAdd( aButton, { 1, .T., {|| FechaBatch()            }} )
aAdd( aButton, { 2, .T., {|| nOpc := 2, FechaBatch() }} )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Funcao que ativa o FormBatch.                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
FormBatch( cTitulo, aSay, aButton )

If nOpc == 2 // cancelou a rotina
	RestArea( aArea )
	Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Chama relatorio								                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

GeraRel()

RestArea( aArea )
Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ VerificaComp	  ³ William L. Gurzoni º Data ³ 09/09/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a leitura dos niveis 1 a 3 das estruturas              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cozil                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function VerificaComp(nNivel)
	
	dbSelectArea("SG1")
	dbSetOrder(1)
	
	i := 1	
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o Nivel passado como parametro for 1				            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If nNivel = 1                
		While i <= Len(aEstrutura) 
			If MsSeek ( xFilial("SG1") + aEstrutura[i][3]) //componente  
				While !Eof() .And. G1_FILIAL + G1_COD = xFilial("SG1") + aEstrutura[i][3]
			          
					Aadd(	aEstrutura[i][4], {	SG1->G1_TRT											,;	// [01] SEQUENCIA
											SG1->G1_COD											,;	// [02] CODIGO DO PRODUTO
											SG1->G1_COMP											,;	// [03] COMPONENTE
											{}													,;	// [04] Array de componentes
											Alltrim(Str(SG1->G1_XQTDUNI * aCabec[1][5]))				,;	// [05] Quantidade Total
											AllTrim(SG1->G1_UMUNIT )									,;	// [06] Unidade de Medida Unitaria
											Alltrim(Str(SG1->G1_XQTDUNI * Val(aEstrutura[i][7])))			,;	// [07] Quantidade Unitaria
											SG1->G1_OBSERV											,;	// [08] Descricao
											Posicione("SB1", 1, xFilial("SB1") + SG1->G1_COMP, "B1_DESC")	,;	// [09] Desc. Produto
											AllTrim(Str(SG1->G1_DIMX))								,;	// [10] Dimensão X
											AllTrim(Str(SG1->G1_DIMY))								,;	// [11] Dimensão Y
											AllTrim(SG1->G1_XDESENH)									})	// [12] Criar Campo para Codigo do Desenho              
					dbSkip()
				EndDo
			EndIf                                                    
			i++             
		EndDo                                                       
		nNivel++			
		VerificaComp(nNivel)
	EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se o Nivel passado como parametro for 2				            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	  
	If nNivel = 2
	
		i := 1	                
		While i <= Len(aEstrutura) 
			j := 1
			While j <= Len(aEstrutura[i][4])
				If MsSeek ( xFilial("SG1") + aEstrutura[i][4][j][3]) //componente  
					While !Eof() .And. G1_FILIAL + G1_COD = xFilial("SG1") + aEstrutura[i][4][j][3]
					
						Aadd(	aEstrutura[i][4][j][4], {	SG1->G1_TRT											,;	// [01] SEQUENCIA
														SG1->G1_COD											,;	// [02] CODIGO DO PRODUTO
														SG1->G1_COMP											,;	// [03] COMPONENTE
														{}													,;	// [04] Array de componentes
														Alltrim(Str(SG1->G1_XQTDUNI * aCabec[1][5]))				,;	// [05] Quantidade Total
														AllTrim(SG1->G1_UMUNIT )									,;	// [06] Unidade de Medida Unitaria
														Alltrim(Str(SG1->G1_XQTDUNI * Val(aEstrutura[i][4][j][7])))	,;	// [07] Quantidade Unitaria
														SG1->G1_OBSERV											,;	// [08] Descricao
														Posicione("SB1", 1, xFilial("SB1") + SG1->G1_COMP, "B1_DESC")	,;	// [09] Desc. Produto
														AllTrim(Str(SG1->G1_DIMX))								,;	// [10] Dimensão X
														AllTrim(Str(SG1->G1_DIMY))								,;	// [11] Dimensão Y
														AllTrim(SG1->G1_XDESENH)									})	// [12] Criar Campo para Codigo do Desenho
						dbSkip()
					EndDo
				EndIf  
				j++ 
			EndDo   
			i++                                                           
		EndDo                                                       
		nNivel++			
		//VerificaComp(nNivel)  Ativar este codigo se necessitar de mais niveis
	EndIf                                                           
Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GeraEstrutura    ³ William L. Gurzoni º Data ³ 09/09/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Faz a leitura de toda estrutura do produto	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cozil                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraEstrutura(cProduto)
	
	While !Eof() .And. G1_FILIAL + G1_COD = xFilial("SG1") + cProdutoAtual
		
		Aadd(	aEstrutura, {	SG1->G1_TRT											,;	// [01] SEQUENCIA
							SG1->G1_COD											,;	// [02] CODIGO DO PRODUTO
							SG1->G1_COMP											,;	// [03] COMPONENTE
							{}													,;	// [04] Array de componentes
							Alltrim(Str(SG1->G1_XQTDUNI * aCabec[1][5]))				,;	// [05] Quantidade Total
							AllTrim(SG1->G1_UMUNIT )									,;	// [06] Unidade de Medida Unitaria
							Alltrim(Str(SG1->G1_XQTDUNI ))							,;	// [07] Quantidade Unitaria
							SG1->G1_OBSERV											,;	// [08] Descricao
							Posicione("SB1", 1, xFilial("SB1") + SG1->G1_COMP, "B1_DESC")	,;	// [09] Desc. Produto
							AllTrim(Str(SG1->G1_DIMX))								,;	// [10] Dimensão X
							AllTrim(Str(SG1->G1_DIMY))								,;	// [11] Dimensão Y
							AllTrim(SG1->G1_XDESENH)									})	// [12] Codigo do Desenho
		dbSkip()
	EndDo
	
	VerificaComp(1)
	
return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ GeraRel()	       ³ William L. Gurzoni º Data ³ 09/09/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Inicia a criacao do relatorio           	              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Especifico Cozil                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function GeraRel()

Local 	cFile
Local 	cExten
Local 	cCompl
Local 	nRet
Local 	lExec		:= .F.
Local 	lProc		:= .F.
Local	aArea		:= GetArea()
Local	nSel			:= ''
Local	cUser		:= cUserName
Local 	lRet			:= .F.
Local 	cArqPesq 		:= ""
Local 	nHandle		:= 0
Local 	cScript   	:= ""
Local 	cPath 		:= Alltrim(mv_par02)
Local	cLinha		:= ""			//Armazenara a string com os dados das linhas do relatorio

Private	cProdutoAtual		:= ""
Private	aEstrutura		:= {}
Private	i				:= 0 	//Contador temporario para os niveis
Private	j				:= 0 	//Contador temporario para os niveis
Private	k				:= 0 	//Contador temporario para os niveis
Private 	aCabec			:= {}  	//Variavel do cabecalho do relatorio
Private	nItens			:= 0		//Acumula o numero de itens para exportar para excel 
Private	cEmpresa			:= ""	//Empresa que se esta extraindo o relatorio      
Private	cUsuario			:= ""	//Usuario que esta fazendo a impressao
Private	cVersao			:= "1.3"	//Versao do relatorio	
    
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³RECEBE VARIAVEIS DE NOME DA EMPRESA E USUARIO 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cUsuario := UsrRetName( RetCodUsr() ) 
	
	Do Case 
		Case xEmpresa() == "01"
			cEmpresa := "COZIL EQUIPAMENTOS"
		Case xEmpresa() == "02"
			cEmpresa := "COZIL COZINHAS"
		Case xEmpresa() == "03"
			cEmpresa := "COZILANDIA EQUIPAMENTOS"
	End Case

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Preenche array com dados da Ordem de Producao                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

dbSelectArea("SC2")
dbSetOrder(1)
dbGotop()
MsSeek ( xFilial("SC2") + mv_par01 + mv_par03 + mv_par04) 			//AQUI O SISTEMA APONTA PARA A OP
If Eof()  												//VERIFICA SE OP + ITEM + SEQ. EXISTEM
	Alert("OP, Item ou Sequencia não localizada!")
	return()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona ao Array os dados do Cabecalho do Relatorio				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

If mv_par01 == C2_NUM
Aadd(	aCabec, {	""									,;						// [01] Usuario
				SC2->C2_PRODUTO						,;						// [02] Codigo Produto
				Posicione("SB1", 1, xFilial("SB1") + SC2->C2_PRODUTO, "B1_DESC")	,;	// [03] Descricao
				" - - - - "							,;						// [04] Revisao
		    		SC2->C2_QUANT							,;						// [05] Quantidade Base
				SC2->C2_NUM							,;						// [06] Ordem de Producao
				SC2->C2_ITEM							,;						// [07] Item OP
				"OP Manual"							,;						// [08] Cliente
				" - "								,;						// [09] Loja
				"Obs.: " + SC2->C2_OBS					,;						// [10] Nome do Cliente
				SC2->C2_DATPRI							,;						// [11] Emissao PV
				SC2->C2_DATPRF							,;						// [12] Previsao de Entrega
				SC2->C2_PEDIDO							,;						// [13] Pedido de venda
				SC2->C2_ITEMPV							,;						// [14] Item Pedido de venda
				SC2->C2_SEQUEN							})						// [15] Sequencia da OP				
EndIf 				

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recolhe dados do pedido de venda (se existir) |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SC5")
dbSetOrder(1)
dbGotop()
MsSeek ( xFilial("SC2") + SC2->C2_PEDIDO) 							//AQUI O SISTEMA APONTA PARA O PEDIDO
If Eof()  												//VERIFICA SE O PEDIDO EXISTE
	//Alert("NAO ENCONTROU O PEDIDO")
Else          
	aCabec[1][8] 	:= Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_COD")
	aCabec[1][9] 	:= Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_LOJA")
	aCabec[1][10] 	:= Posicione("SA1", 1, xFilial("SA1") + SC5->C5_CLIENTE, "A1_NOME")   
	aCabec[1][13] 	:= SC2->C2_PEDIDO
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recolhe dados dos itens do pedido de venda (se existir)   |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	dbGotop()
	MsSeek ( xFilial("SC2") + SC2->C2_PEDIDO + SC2->C2_ITEMPV + SC2->C2_PRODUTO) 			//AQUI O SISTEMA APONTA PARA O ITEM DO PEDIDO
	If Eof()  															//VERIFICA SE O ITEM DO PEDIDO EXISTE
		//Alert("NAO ENCONTROU O ITEM DO PEDIDO")
	Else     
		aCabec[1][11] 	:= SC6->C6_XDTDES
		aCabec[1][12]	:= SC6->C6_ENTREG
	EndIf 

EndIf 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se existe estrutura cadastrada para o produto ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SG1")
dbSetOrder(1)

If MsSeek ( xFilial("SG1") + aCabec[1][2])
	cProdutoAtual 		:= SG1->G1_COD
	GeraEstrutura(cProdutoAtual)
Else
	alert("Estrutura não encontrada")
	return()
EndIf
                                                              
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Faz leitura do array de itens e adiciona a variavel cLinha 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//Inicializa contadores dos niveis
i := j := k := 1
                                                                   
While i <= Len(aEstrutura) 
	cLinha += '	   <Row ss:AutoFitHeight="0" ss:Height="24" ss:StyleID="s107">	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="Number">' + AllTrim(Str(++nItens)) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="String">- Selecione o Processo -</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s108" ss:Formula="=RC[2]*R5C1"><Data ss:Type="Number"></Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="String">' + aEstrutura[i][6] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="Number">' + aEstrutura[i][7] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s110"><Data ss:Type="String">002</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + aEstrutura[i][8] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + aEstrutura[i][9] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s112"><Data ss:Type="Number">' + aEstrutura[i][10] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s113"><Data ss:Type="String">X</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s114"><Data ss:Type="Number">' + aEstrutura[i][11] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s115"><Data ss:Type="String">' + aEstrutura[i][12] + '' 
	If AllTrim(aEstrutura[i][12]) != AllTrim(aEstrutura[i][3])
		cLinha += ' / ' + aEstrutura[i][3] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	Else
		cLinha += '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)		
	EndIf
	cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
	cLinha += '	   </Row>	 ' + Chr(13)+Chr(10)     

	While j <= Len(aEstrutura[i][4]) 
		cLinha += '	   <Row ss:AutoFitHeight="0" ss:Height="24" ss:StyleID="s107">	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="Number">' + AllTrim(Str(++nItens)) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="String">- Selecione o Processo -</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s108" ss:Formula="=RC[2]*R5C1"><Data ss:Type="Number"></Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="String">' + aEstrutura[i][4][j][6] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="Number">' + aEstrutura[i][4][j][7] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s110"><Data ss:Type="String">003</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + Chr(187) + Chr(187) + aEstrutura[i][4][j][8] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + aEstrutura[i][4][j][9] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s112"><Data ss:Type="Number">' + aEstrutura[i][4][j][10] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s113"><Data ss:Type="String">X</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s114"><Data ss:Type="Number">' + aEstrutura[i][4][j][11] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s115"><Data ss:Type="String">' + aEstrutura[i][4][j][12] + ' / ' + aEstrutura[i][4][j][3] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
		cLinha += '	   </Row>	 ' + Chr(13)+Chr(10)

		While k < Len(aEstrutura[i][4][j][4])
			cLinha += '	   <Row ss:AutoFitHeight="0" ss:Height="24" ss:StyleID="s107">	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="Number">' + AllTrim(Str(++nItens)) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s107"><Data ss:Type="String">- Selecione o Processo -</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s108" ss:Formula="=RC[2]*R5C1"><Data ss:Type="Number"></Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="String">' + aEstrutura[i][4][j][4][k][6] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s109"><Data ss:Type="Number">' + aEstrutura[i][4][j][4][k][7] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s110"><Data ss:Type="String">004</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + Chr(187) + Chr(187) + Chr(187) + Chr(187) + aEstrutura[i][4][j][4][k][8] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s111"><Data ss:Type="String">' + aEstrutura[i][4][j][4][k][9] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s112"><Data ss:Type="Number">' + aEstrutura[i][4][j][4][k][10] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s113"><Data ss:Type="String">X</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s114"><Data ss:Type="Number">' + aEstrutura[i][4][j][4][k][11] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s115"><Data ss:Type="String">' + aEstrutura[i][4][j][4][k][12] + ' / ' + aEstrutura[i][4][j][4][k][3] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	    <Cell ss:StyleID="s107"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cLinha += '	   </Row>	 ' + Chr(13)+Chr(10)
		     k++
		EndDo
		k := 1
		j++
	EndDo      
	j := 1
	i++
EndDo    


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se teclou no botão confirma ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lExec .Or. ( !lProc .And. !lExec )
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
			Alert("Não foi possível abrir ou criar o arquivo XML")
		Else
			cScript := ""
			cScript += '	<?xml version="1.0"?>	 ' + Chr(13)+Chr(10)
			cScript += '	<?mso-application progid="Excel.Sheet"?>	 ' + Chr(13)+Chr(10)
			cScript += '	<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13)+Chr(10)
			cScript += '	 xmlns:o="urn:schemas-microsoft-com:office:office"	 ' + Chr(13)+Chr(10)
			cScript += '	 xmlns:x="urn:schemas-microsoft-com:office:excel"	 ' + Chr(13)+Chr(10)
			cScript += '	 xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"	 ' + Chr(13)+Chr(10)
			cScript += '	 xmlns:html="http://www.w3.org/TR/REC-html40">	 ' + Chr(13)+Chr(10)
			cScript += '	 <DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">	 ' + Chr(13)+Chr(10)
			cScript += '	  <Author>william</Author>	 ' + Chr(13)+Chr(10)
			cScript += '	  <LastAuthor>william</LastAuthor>	 ' + Chr(13)+Chr(10)
			cScript += '	  <LastPrinted>2011-09-05T15:17:42Z</LastPrinted>	 ' + Chr(13)+Chr(10)
			cScript += '	  <Created>2011-09-05T12:15:31Z</Created>	 ' + Chr(13)+Chr(10)
			cScript += '	  <LastSaved>2011-09-05T12:34:54Z</LastSaved>	 ' + Chr(13)+Chr(10)
			cScript += '	  <Version>11.9999</Version>	 ' + Chr(13)+Chr(10)
			cScript += '	 </DocumentProperties>	 ' + Chr(13)+Chr(10)
			cScript += '	 <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13)+Chr(10)
			cScript += '	  <WindowHeight>7995</WindowHeight>	 ' + Chr(13)+Chr(10)
			cScript += '	  <WindowWidth>20115</WindowWidth>	 ' + Chr(13)+Chr(10)
			cScript += '	  <WindowTopX>120</WindowTopX>	 ' + Chr(13)+Chr(10)
			cScript += '	  <WindowTopY>120</WindowTopY>	 ' + Chr(13)+Chr(10)
			cScript += '	  <ProtectStructure>False</ProtectStructure>	 ' + Chr(13)+Chr(10)
			cScript += '	  <ProtectWindows>False</ProtectWindows>	 ' + Chr(13)+Chr(10)
			cScript += '	 </ExcelWorkbook>	 ' + Chr(13)+Chr(10)
			cScript += '	<Styles>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="Default" ss:Name="Normal">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Protection/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60441976">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426740">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426750">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426760">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="16" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426770">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426780">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426790">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="d/m/yy;@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426800">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426810">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="18" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="d/m/yy;@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426588">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426598">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426608">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60426618">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="9" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437600">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="14" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437610">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437620">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437630">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437640">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437650">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="m60437660">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s28">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s35">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s49">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:ShrinkToFit="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s95">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="7" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s96">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="7" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s104">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="8" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s105">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:ShrinkToFit="1" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="7" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior ss:Color="#C0C0C0" ss:Pattern="Solid"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s106">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s107">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s108">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="12" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s109">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="14" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s110">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="14" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s111">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Left" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="9" ss:Color="#000000"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s112">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s113">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s114">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Interior/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <NumberFormat ss:Format="@"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s115">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Borders>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s116">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000" ss:Bold="1"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s117">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Alignment ss:Horizontal="Center" ss:Vertical="Bottom"/>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	  <Style ss:ID="s118">	 ' + Chr(13) + Chr(10)
			cScript += '	   <Font x:Family="Swiss"/>	 ' + Chr(13) + Chr(10)
			cScript += '	  </Style>	 ' + Chr(13) + Chr(10)
			cScript += '	 </Styles>	 ' + Chr(13) + Chr(10)
			cScript += '	 <Names>	 ' + Chr(13)+Chr(10)
			cScript += '	  <NamedRange ss:Name="Processos" ss:RefersTo="=dados!R1C1:R50C1"/>	 ' + Chr(13)+Chr(10)
			cScript += '	 </Names>	 ' + Chr(13)+Chr(10)
			cScript += '	 <Worksheet ss:Name="Modelo">	 ' + Chr(13)+Chr(10)
			cScript += '	  <Names>	 ' + Chr(13)+Chr(10)
			cScript += '	   <NamedRange ss:Name="_FilterDatabase" ss:RefersTo="=Modelo!R7C1:R7C8" ss:Hidden="1"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <NamedRange ss:Name="Print_Area" ss:RefersTo="=Modelo!C1:C15"/>	 ' + Chr(13)+Chr(10)
			cScript += '	  </Names>	 ' + Chr(13)+Chr(10)
			cScript += '	  <Table ss:ExpandedColumnCount="15" ss:ExpandedRowCount="500" x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="21.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="252.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="33"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="35.25" ss:Span="2"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:Index="7" ss:AutoFitWidth="0" ss:Width="160.5"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="225.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="32.25"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="14.25"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="34.5"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="84.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:AutoFitWidth="0" ss:Width="30" ss:Span="2"/>	 ' + Chr(13)+Chr(10)
			cScript += '      <Row ss:AutoFitHeight="0" ss:Height="21">	 ' + Chr(13) + Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:MergeDown="1" ss:StyleID="m60437600"><Data ss:Type="String">' + cEmpresa + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Cell ss:MergeAcross="5" ss:StyleID="m60437610"><Data ss:Type="String">PRODUTO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60437620"><Data ss:Type="String">CODIGO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Cell ss:StyleID="s35"><Data ss:Type="String">VERSÃO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13) + Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60437630"><Data ss:Type="String">IMPRESSO POR</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13) + Chr(10)
			cScript += '	   </Row>	 ' + Chr(13) + Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="19.5">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:Index="3" ss:MergeAcross="5" ss:StyleID="m60437640"><Data ss:Type="String">' + aCabec[1][3] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60437650"><Data ss:Type="String">' + aCabec[1][2] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s49"><Data ss:Type="String">' + cVersao + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60437660"><Data ss:Type="String">' + cUsuario + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="3.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m60426588"><Data ss:Type="String">QUANTIDADE DE PRODUCAO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426598"><Data ss:Type="String">PEDIDO / ITEM</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426608"><Data ss:Type="String">CODIGO / LOJA - NOME DO CLIENTE</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m60426618"><Data ss:Type="String">EMISSAO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m60426740"><Data ss:Type="String">OP . ITEM . SEQUENCIA</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426750"><Data ss:Type="String">PRAZO DE ENTREGA</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="21.75">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m60426760"><Data ss:Type="Number">' + AllTrim(Str(aCabec[1][5])) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426770"><Data ss:Type="String">' + aCabec[1][13] + ' / ' + aCabec[1][14] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426780"><Data ss:Type="String">' + aCabec[1][8] + ' / ' + aCabec[1][9] + ' - ' + aCabec[1][10] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="m60426790"><Data ss:Type="String">' + DToC(aCabec[1][11]) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="1" ss:StyleID="s109"><Data ss:Type="String">' + aCabec[1][6] + '.' + aCabec[1][7] + '.' + aCabec[1][15] + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60426810"><Data ss:Type="String">' + DToC(aCabec[1][12]) + '</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="3.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0" ss:Height="21">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s95"><Data ss:Type="String">SEQ.</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s28"><Data ss:Type="String">PROCESSO</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s96"><Data ss:Type="String">QTD. TOTAL</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s28"><Data ss:Type="String">UNID.</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s96"><Data ss:Type="String">QTD. UNIT.</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s96"><Data ss:Type="String">NIVEL</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s28"><Data ss:Type="String">DESCRICAO</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s28"><Data ss:Type="String">MATERIAL</Data><NamedCell ss:Name="_FilterDatabase"/><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:MergeAcross="2" ss:StyleID="m60441976"><Data ss:Type="String">DIMENSAO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s105"><Data ss:Type="String">DESENHO / CODIGO</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s106"><Data ss:Type="String">OK (visto)</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s106"><Data ss:Type="String">OK (visto)</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s106"><Data ss:Type="String">OK (visto)</Data><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			
			cScript += cLinha
			
			cScript += '	   <Row ss:AutoFitHeight="0"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:Index="7" ss:StyleID="s117"><NamedCell ss:Name="Print_Area"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	  </Table>	 ' + Chr(13)+Chr(10)
			cScript += '	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13)+Chr(10)
			cScript += '	   <PageSetup>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Layout x:Orientation="Landscape"/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Header x:Margin="0.31496062000000002"/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Footer x:Margin="0.31496062000000002"/>	 ' + Chr(13)+Chr(10)
			//cScript += '	    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024" x:Right="0.511811024" x:Top="0.78740157499999996"/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <PageMargins x:Bottom="0.35" x:Left="0.44" x:Right="0.511811024" x:Top="0.48"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   </PageSetup>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Unsynced/>	 ' + Chr(13)+Chr(10)
			//cScript += '	   <FitToPage/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Print>	 ' + Chr(13)+Chr(10)
			cScript += '	    <ValidPrinterInfo/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Scale>65</Scale>	 ' + Chr(13)+Chr(10)
			cScript += '	    <HorizontalResolution>300</HorizontalResolution>	 ' + Chr(13)+Chr(10)
			cScript += '	    <VerticalResolution>0</VerticalResolution>	 ' + Chr(13)+Chr(10)
			cScript += '	    <NumberofCopies>0</NumberofCopies>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Print>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Selected/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Panes>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Pane>	 ' + Chr(13)+Chr(10)
			cScript += '	     <Number>3</Number>	 ' + Chr(13)+Chr(10)
			cScript += '	     <ActiveRow>7</ActiveRow>	 ' + Chr(13)+Chr(10)
			cScript += '	     <ActiveCol>2</ActiveCol>	 ' + Chr(13)+Chr(10)
			cScript += '	    </Pane>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Panes>	 ' + Chr(13)+Chr(10)
			cScript += '	   <ProtectObjects>False</ProtectObjects>	 ' + Chr(13)+Chr(10)
			cScript += '	   <ProtectScenarios>False</ProtectScenarios>	 ' + Chr(13)+Chr(10)
			cScript += '	  </WorksheetOptions>	 ' + Chr(13)+Chr(10)
			cScript += '	  <DataValidation xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13)+Chr(10)
			cScript += '	   <Range>R8C2:R' + AllTrim(Str(nItens + 8)) + 'C2</Range>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Type>List</Type>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Value>Processos</Value>	 ' + Chr(13)+Chr(10)
			cScript += '	  </DataValidation>	 ' + Chr(13)+Chr(10)
			cScript += '	 </Worksheet>	 ' + Chr(13)+Chr(10)
			cScript += '	 <Worksheet ss:Name="dados">	 ' + Chr(13)+Chr(10)
			cScript += '	  <Table ss:ExpandedColumnCount="1" ss:ExpandedRowCount="200" x:FullColumns="1" x:FullRows="1" ss:DefaultRowHeight="15">	 ' + Chr(13)+Chr(10)
			cScript += '	   <Column ss:Width="222.75"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Processos</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Funilária</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Dobra / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Dobra / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Dobra / Funilária</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Puncionadeira / Dobra / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Puncionadeira / Dobra / Funilária</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Puncionadeira / Dobra / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Dobra / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Guilhotina / Puncionadeira / Dobra / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Funilária</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Dobra / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Dobra / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Dobra / Funilária</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Dobra / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Laser / Puncionadeira / Dobra / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Policorte / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Policorte / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Policorte / Funilaria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Policorte / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Almoxarifado / Cocção</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Almoxarifado / Refrigeração</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Almoxarifado / Funilaria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><Data ss:Type="String">Almoxarifado / Caldeiraria</Data><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Row ss:AutoFitHeight="0">	 ' + Chr(13)+Chr(10)
			cScript += '	    <Cell ss:StyleID="s118"><NamedCell ss:Name="Processos"/></Cell>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Row>	 ' + Chr(13)+Chr(10)
			cScript += '	  </Table>	 ' + Chr(13)+Chr(10)
			cScript += '	  <WorksheetOptions xmlns="urn:schemas-microsoft-com:office:excel">	 ' + Chr(13)+Chr(10)
			cScript += '	   <PageSetup>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Header x:Margin="0.31496062000000002"/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Footer x:Margin="0.31496062000000002"/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <PageMargins x:Bottom="0.78740157499999996" x:Left="0.511811024" x:Right="0.511811024" x:Top="0.78740157499999996"/>	 ' + Chr(13)+Chr(10)
			cScript += '	   </PageSetup>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Unsynced/>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Print>	 ' + Chr(13)+Chr(10)
			cScript += '	    <ValidPrinterInfo/>	 ' + Chr(13)+Chr(10)
			cScript += '	    <HorizontalResolution>300</HorizontalResolution>	 ' + Chr(13)+Chr(10)
			cScript += '	    <VerticalResolution>0</VerticalResolution>	 ' + Chr(13)+Chr(10)
			cScript += '	    <NumberofCopies>0</NumberofCopies>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Print>	 ' + Chr(13)+Chr(10)
			cScript += '	   <Panes>	 ' + Chr(13)+Chr(10)
			cScript += '	    <Pane>	 ' + Chr(13)+Chr(10)
			cScript += '	     <Number>3</Number>	 ' + Chr(13)+Chr(10)
			cScript += '	     <RangeSelection>R1C1:R50C1</RangeSelection>	 ' + Chr(13)+Chr(10)
			cScript += '	    </Pane>	 ' + Chr(13)+Chr(10)
			cScript += '	   </Panes>	 ' + Chr(13)+Chr(10)
			cScript += '	   <ProtectObjects>False</ProtectObjects>	 ' + Chr(13)+Chr(10)
			cScript += '	   <ProtectScenarios>False</ProtectScenarios>	 ' + Chr(13)+Chr(10)
			cScript += '	  </WorksheetOptions>	 ' + Chr(13)+Chr(10)
			cScript += '	 </Worksheet>	 ' + Chr(13)+Chr(10)
			cScript += '	</Workbook>	 '
               
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Codifica a string cString para UTF-8						                    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			cScript := EncodeUTF8(cScript) 
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Descarrega a variavel cScript no Arquivo contido em nHandle                       ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			
			If( FWRITE(nHandle, cScript) == 0)
				Alert("Não foi possível gravar o arquivo!") 
			EndIf
			
			cScript	:= ""
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Fecha o arquivo gravado                                                           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			FCLOSE(nHandle)
			
			SplitPath( alltrim(cArqPesq),,, @cFile, @cExten )
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Abre a Planilha em Excel                                                         ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRet := ShellExecute( "Open", cPath,"",Substr(cPath,1,9), 1 )
			
			If nRet <= 32
				cCompl := ""
				If nRet == 31
					cCompl := " Nao existe aplicativo associado a este tipo de arquivo !"
				EndIf
				Aviso( "Atencao !", "Nao foi possivel abrir o objeto '" + AllTrim(cFile) + "'!" + cCompl, { "Ok" }, 2 ) 	 //#########
				lRet := .F.
			Else
				lRet := .T.
			EndIf
		Endif
	Else
		Alert("Diretório não Informado!, Não foi possível gravar o arquivo!")  //"Não foi possível gravar o arquivo!"
		lRet := .F.
	EndIf
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se o botao cancelar foi acionado              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	RestArea(aArea)
	Return()
Endif


Return()

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fOpen_Excel2Autorº Autor ³ Microsiga   º Data ³  12/06/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function fOpen_Excel2()

Local cSvAlias		:= Alias()
Local lAchou		:= .F.
Local cTipo			:= "Planilha Excel (*.XML)  |*.XML | "
Local cNewPathArq	:= cGetFile( cTipo , "Selecione o arquivo *.XML" )

IF !Empty( cNewPathArq )
	IF Upper( Subst( AllTrim( cNewPathArq), - 3 ) ) == Upper( AllTrim( "XML" ) )
		Aviso( "Arquivo Selecionado" , cNewPathArq , { "OK" } )
	Else
		MsgAlert( "Arquivo Invalido " )
		Return
	EndIF
Else
	Aviso("Cancelada a Selecao!","Voce cancelou  a selecao do arquivo." ,{ "OK" } )
	Return
EndIF

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³Limpa o parametro para a Carga do Novo Arquivo                         ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
dbSelectArea("SX1")
IF lAchou := ( SX1->( dbSeek( cPerg + "02" , .T. ) ) )
	RecLock("SX1",.F.,.T.)
	SX1->X1_CNT01 := Space( Len( SX1->X1_CNT01 ) )
	mv_par0 := cNewPathArq
	MsUnLock()
EndIF
dbSelectArea( cSvAlias )
Return( .T. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CriaSx1_2 ºAutor  ³Carlos E. Saturnino º Data ³  03/12/10   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cozil                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CriaSx1_2(cPerg)
Local aArea   := GetArea()
Local aHelp	  := {}

cPerg   := PADR(cPerg,6)

aAdd(aHelp,{"Informe o numero da OP manual."})
aAdd(aHelp,{"Informe o Nome do Arquivo XLS para ser gerado."})
aAdd(aHelp,{"Informe o Numero do Item da OP."})
aAdd(aHelp,{"Informe o Numero da sequencia da OP."})

PutSx1(cPerg, 	"01","Num da OP:","","","mv_ch1","C",06,0,0,"G" ,"","SC2","","","mv_par01","","","","","","","","","","","","","","","","",aHelp[1] ,aHelp[1],aHelp[1])
PutSx1(cPerg,	"02","Arquivo XML:","","","mv_ch2","C",99,0,0,"G","","","","","mv_par02","","","","","","","","","","","","","","","","",aHelp[2] ,aHelp[2],aHelp[2])
PutSx1(cPerg,	"03","Item:","","","mv_ch3","C",02,0,0,"G","","","","","mv_par03","","","","01","","","","","","","","","","","","",aHelp[3] ,aHelp[3],aHelp[3])
PutSx1(cPerg,	"04","Sequencia:","","","mv_ch4","C",03,0,0,"G","","","","","mv_par04","","","","001","","","","","","","","","","","","",aHelp[4] ,aHelp[4],aHelp[4])

RestArea(aArea)
Return()
