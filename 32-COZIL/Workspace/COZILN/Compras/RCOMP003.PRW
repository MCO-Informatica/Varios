#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RCOMP003 ºAutor  ³William L. Gurzoni  º Data ³  13/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ RELATORIO DE ITENS DE REVENDA 					    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ COZIL EQUIPAMENTOS                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
                                     

/*BEGINDOC
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Historico de versoes                                               ³
//³                                                                   ³
//³1.0 - Criacao do relatorio                                         ³
//³1.1 - Campos adicionados: End. Entrega, Fone, contato, data entrega³
//³1.2 - Inclusao do campo de pedido referenciado					³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ENDDOC*/


User Function RCOMP003()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis.                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local aArea   := GetArea()
Local aSay    := {}
Local aButton := {}
Local nOpc    := 0
Local cTitulo := "Itens de Revenda"
Local cDesc1  := "Este programa tem como objetivo a geração de uma planilha em Excel (.xml) "
Local cDesc2  := "contendo informações dos pedidos de venda"
Local cDesc3  := ""

Private cPerg	  := "RCOMP003"

//MsgAlert("Este relatório ainda está em fase de teste. Não utilize-o como forma principal para obtenção de dados.", "Atenção - Relatório alterado (v1.0)")

//CriaSx1_2(cPerg)
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


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GERAREL() ºAutor  ³William Luiz        º Data ³  13/03/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


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
Local 	cPath 		:= "c:\msiga\RCOMP003.xml"
Local	cLinha		:= ""			//Armazenara a string com os dados das linhas do relatorio
Local	cQuery		:= "" 
Local	nTppv		:= MV_PAR05 
Local	cTppv		:= ""
Local	cExibir		:= MV_PAR06
Local	cTppvFull		:= ""  
Local	cPedidoAtual	:= ""   
Local 	cItens		:= ""
Local	cDataTmp		:= ""  
Local	nQtdLinhas	:= 8 //Quantidade de linhas do relatorio 
Local	nHeight		:= 0
Local 	cEndEntrega	:= ""
Local 	cMensagem		:= ""

Private aCabec			:= {}  	//Variavel do cabecalho do relatorio
Private	nItens			:= 0		//Acumula o numero de itens para exportar para excel 
Private	cEmpresa			:= ""	//Empresa que se esta extraindo o relatorio      
Private	cUsuario			:= ""	//Usuario que esta fazendo a impressao
Private	cVersao			:= "1.2"	//Versao do relatorio (1.2) adcionado observacoes marco 2013	                 
    
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

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³TRATA O TIPO DE VENDA	(SETOR COMERCIAL)	 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	Do Case
		Case nTppv == 1
			cTppv := "L"
			cTppvFull := "Licitações"
		Case nTppv == 2
			cTppv := "N"    
			cTppvFull := "Nacional"
		Case nTppv == 3
			cTppv := "V"          
			cTppvFull := "Regional"
		Case nTppv == 4
			cTppv := "A"          
			cTppvFull := "Assistência Téc."
		Case nTppv == 5
			cTppv := "'L','N','V','A'"          
			cTppvFull := "Outros."
	End Case
	
	Do Case 
		Case cExibir == 1
			cExibir := "Todos"
		Case cExibir == 2
			cExibir := "Somente Liberados"
	End Case
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³FORMA QUERY 						 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		
	cQuery := "SELECT "
	cQuery += "C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_ENTREG, C6_QTDEMP, "	
	cQuery += "C5_NUM, C5_XPEDREL, C5_XTPPV, C5_EMISSAO, C5_NOTA, "
	cQuery += "A1_COD, A1_NOME, A1_DDD, A1_TEL, A1_CONTATO, A1_END, A1_EST, A1_MUN, A1_BAIRRO, A1_CEP, A1_ENDENT, A1_ESTE, A1_MUNE, A1_BAIRROE, A1_CEPE "
	cQuery += "FROM " + RetSqlName("SC6") + " SC6 "
	cQuery += "INNER JOIN " + RetSqlName("SC5") + " SC5 ON C6_NUM = C5_NUM "
	cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON C5_CLIENTE = A1_COD "
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON C6_PRODUTO = B1_COD "
	cQuery += "WHERE C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "
	cQuery += "C5_NUM BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' AND "	
	cQuery += "C5_EMISSAO BETWEEN '" + DtoS(MV_PAR03) + "' AND '" + DtoS(MV_PAR04) + "' AND "	
	If nTppv <> 5
		cQuery += "C5_XTPPV = '" + cTppv + "' AND "	
	Else
		cQuery += "C5_XTPPV NOT IN (" + cTppv + ") AND "
	Endif
	cQuery += "B1_TIPO = 'RV' AND "
	cQuery += "SC6.D_E_L_E_T_ != '*' "	  
	cQuery += "ORDER BY C5_NUM, C6_ITEM"	  	     

//EECVIEW(cQuery,"Consulta")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³EXECUTA QUERY 						 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		
	cQuery := ChangeQuery(cQuery)                            
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.T.,.T.)
	
	dbSelectArea("TMP")
	TMP->(DbGotop())           	
		

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³VERIFICA SE RETORNA ALGUM RESULTADO		 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	                   
	If TMP->(Eof())
	   MsgInfo("Nao existem registros com o filtro escolhido! Verifique os parâmetros.")
	   TMP->(DbCloseArea())
	   Return
	EndIf       
 	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³LOOPING NOS ITENS DO PEDIDOS			 		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	    	
     	                       	
	While TMP->(!EOF())
		
		If cPedidoAtual != TMP->C5_NUM 
			
			//FORMATA DATA DE EMISSAO			
			cDataTmp := Substr(TMP->C5_EMISSAO, 7, 2)+ "/" + Substr(TMP->C5_EMISSAO, 5, 2) + "/" + Substr(TMP->C5_EMISSAO, 1, 4)            
			        
			//VERIFICA ENDERECO DE ENTREGA
			If AllTrim(TMP->A1_ENDENT) != ""
				cEndEntrega := AllTrim(TMP->A1_ENDENT) + " - " + AllTrim(A1_BAIRROE) + " " + AllTrim(A1_MUNE) + "/" + AllTrim(A1_ESTE) 
			Else
				cEndEntrega := AllTrim(TMP->A1_END) + " - " + AllTrim(A1_BAIRRO) + " " + AllTrim(A1_MUN) + "/" + AllTrim(A1_EST)				
			EndIf
			        			             
			nQtdLinhas += 9
			
			cItens += "	   <Row ss:AutoFitHeight='0' ss:Height='4.5'>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:MergeAcross='5' ss:StyleID='s31'/>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)			
			cItens += "	   <Row>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s49'><Data ss:Type='String'>Pedido:</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:MergeAcross='4' ss:StyleID='m60426956'><Data ss:Type='String'> " + TMP->C5_NUM + " - " + cDataTmp
			
			If AllTrim(TMP->C5_XPEDREL) != ""
			  	cItens += " (PEDIDO RELACIONADO: " + TMP->C5_XPEDREL + ") "
			EndIf
			
			If AllTrim(TMP->C5_NOTA) != ""
				cItens += " (PEDIDO FINALIZADO) "
			EndIf
			
			cItens += "	    </Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
			cItens += "	   <Row>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s49'><Data ss:Type='String'>Cliente:</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:MergeAcross='4' ss:StyleID='m60426956'><Data ss:Type='String'> " + TMP->A1_COD + " - " + TMP->A1_NOME + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
			
			cItens += "	   <Row>	" + Chr(13)+Chr(10)			
			cItens += "	    <Cell ss:StyleID='s49'><Data ss:Type='String'>Contato:</Data></Cell>	" + Chr(13)+Chr(10)			
			cItens += "	    <Cell ss:MergeAcross='4' ss:StyleID='m60426956'><Data ss:Type='String'> Tel: (" + TMP->A1_DDD + ") " + TMP->A1_TEL + "  Contato: " + TMP->A1_CONTATO + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
			
			cItens += "	   <Row>	" + Chr(13)+Chr(10)	
			cItens += "	    <Cell ss:StyleID='s58'><Data ss:Type='String'>Entrega: </Data></Cell>	" + Chr(13)+Chr(10)					
			cItens += "	    <Cell ss:MergeAcross='4' ss:StyleID='m60426936'><Data ss:Type='String'> " + cEndEntrega + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
			
			cItens += "	   <Row ss:Height='50'>	" + Chr(13)+Chr(10)	
			cItens += "	    <Cell ss:StyleID='s58'><Data ss:Type='String'>Obs.: </Data></Cell>	" + Chr(13)+Chr(10)					
			cItens += "	    <Cell ss:MergeAcross='4' ss:StyleID='s59'><Data ss:Type='String'>" + AllTrim(Posicione("SC5",1,xFilial("SC5")+TMP->C5_NUM,"C5_XHISTOR")) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
						
			cItens += "	   <Row ss:AutoFitHeight='0' ss:Height='4.5'>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:MergeAcross='5' ss:StyleID='s31'/>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
			cItens += "	   <Row ss:AutoFitHeight='0' ss:Height='15.75'>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Cod. Produto</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Descrição / Especificação</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Data Entrega</Data></Cell>	" + Chr(13)+Chr(10)
			
			If MV_PAR06 = 1	//Visualizar todos os registros independente de liberacao
				cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Quant.</Data></Cell>	" + Chr(13)+Chr(10)
			Else				//Visualizar apenas pedido empenhados
				cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Qtd. Lib.</Data></Cell>	" + Chr(13)+Chr(10)
			End If
			
			cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Valor Unitário</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s65'><Data ss:Type='String'>Valor Total</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
					    	
		    	cPedidoAtual := TMP->C5_NUM
		    	
		Else                
			
			nQtdLinhas += 1
			
			cDataTmp := Substr(TMP->C6_ENTREG, 1, 4) + "-" + Substr(TMP->C6_ENTREG, 5, 2) + "-" + Substr(TMP->C6_ENTREG, 7, 2)
		     
		   	//Calcula altura da linha do excel              
			cHeight	:= Len(TMP->C6_DESCRI)
			cHeight	+= Len(Posicione("SB1",1,xFilial("SB1")+TMP->C6_PRODUTO,"B1_XESPEC"))
			cHeight	:= cHeight / 3.5
			If cHeight > 1000
				cHeight := 1000
				cMensagem	:= "ooooo DESCRICAO MUITO GRANDE. VEJA O EDITAL. ooooo "
			EndIf
		
			cItens += "	   <Row ss:AutoFitHeight='0' ss:Height='" + AllTrim(Str(Round(cHeight, 0))) + "'>	" + Chr(13)+Chr(10) 
			cItens += "	    <Cell ss:StyleID='s66'><Data ss:Type='String'>" + TMP->C6_PRODUTO + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s67'><Data ss:Type='String'>" + cMensagem + AllTrim(TMP->C6_DESCRI) + ": " + AllTrim(Posicione("SB1",1,xFilial("SB1")+TMP->C6_PRODUTO,"B1_XESPEC")) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s68'><Data ss:Type='DateTime'>" + AllTrim(cDataTmp) + "T00:00:00.000</Data></Cell>	" + Chr(13)+Chr(10)
			
			If MV_PAR06 = 1 	//Visualizar todos os registros independente de liberacao
			
				cItens += "	    <Cell ss:StyleID='s69'><Data ss:Type='Number'>" + AllTrim(Str(TMP->C6_QTDVEN)) + "</Data></Cell>	" + Chr(13)+Chr(10)
			Else           	//Visualizar apenas pedido empenhados
			
				cItens += "	    <Cell ss:StyleID='s69'><Data ss:Type='Number'>" + AllTrim(Str(TMP->C6_QTDEMP)) + "</Data></Cell>	" + Chr(13)+Chr(10)			
			End If
			
			cItens += "	    <Cell ss:StyleID='s71'><Data ss:Type='Number'>" + AllTrim(Str(TMP->C6_PRCVEN))  + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	    <Cell ss:StyleID='s71'><Data ss:Type='Number'>" + AllTrim(Str(TMP->C6_VALOR))  + "</Data></Cell>	" + Chr(13)+Chr(10)
			cItens += "	   </Row>	" + Chr(13)+Chr(10)
          	
          	TMP->(DbSkip())
          	
		End If     
	
	End Do



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
			cScript	:= ""
			        
			cScript += "	<?xml version='1.0'?>	" + Chr(13)+Chr(10)
			cScript += "	<?mso-application progid='Excel.Sheet'?>	" + Chr(13)+Chr(10)
			cScript += "	<Workbook xmlns='urn:schemas-microsoft-com:office:spreadsheet'	" + Chr(13)+Chr(10)
			cScript += "	 xmlns:o='urn:schemas-microsoft-com:office:office'	" + Chr(13)+Chr(10)
			cScript += "	 xmlns:x='urn:schemas-microsoft-com:office:excel'	" + Chr(13)+Chr(10)
			cScript += "	 xmlns:ss='urn:schemas-microsoft-com:office:spreadsheet'	" + Chr(13)+Chr(10)
			cScript += "	 xmlns:html='http://www.w3.org/TR/REC-html40'>	" + Chr(13)+Chr(10)
			cScript += "	 <DocumentProperties xmlns='urn:schemas-microsoft-com:office:office'>	" + Chr(13)+Chr(10)
			cScript += "	  <Author>william</Author>	" + Chr(13)+Chr(10)
			cScript += "	  <LastAuthor>william</LastAuthor>	" + Chr(13)+Chr(10)
			cScript += "	  <LastPrinted>2011-11-23T13:29:08Z</LastPrinted>	" + Chr(13)+Chr(10)
			cScript += "	  <Created>2011-11-23T11:52:58Z</Created>	" + Chr(13)+Chr(10)
			cScript += "	  <LastSaved>2011-11-23T13:02:45Z</LastSaved>	" + Chr(13)+Chr(10)
			cScript += "	  <Company>Kille®Soft</Company>	" + Chr(13)+Chr(10)
			cScript += "	  <Version>11.9999</Version>	" + Chr(13)+Chr(10)
			cScript += "	 </DocumentProperties>	" + Chr(13)+Chr(10)
			cScript += "	 <ExcelWorkbook xmlns='urn:schemas-microsoft-com:office:excel'>	" + Chr(13)+Chr(10)
			cScript += "	  <WindowHeight>8760</WindowHeight>	" + Chr(13)+Chr(10)
			cScript += "	  <WindowWidth>16275</WindowWidth>	" + Chr(13)+Chr(10)
			cScript += "	  <WindowTopX>480</WindowTopX>	" + Chr(13)+Chr(10)
			cScript += "	  <WindowTopY>105</WindowTopY>	" + Chr(13)+Chr(10)
			cScript += "	  <ProtectStructure>False</ProtectStructure>	" + Chr(13)+Chr(10)
			cScript += "	  <ProtectWindows>False</ProtectWindows>	" + Chr(13)+Chr(10)
			cScript += "	 </ExcelWorkbook>	" + Chr(13)+Chr(10)
			cScript += "	 <Styles>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='Default' ss:Name='Normal'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders/>	" + Chr(13)+Chr(10)
			cScript += "	   <Font/>	" + Chr(13)+Chr(10)
			cScript += "	   <Interior/>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat/>	" + Chr(13)+Chr(10)
			cScript += "	   <Protection/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s18' ss:Name='Moeda'>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat	" + Chr(13)+Chr(10)
			cScript += "	    ss:Format='_-&quot;R$&quot;\ * #,##0.00_-;\-&quot;R$&quot;\ * #,##0.00_-;_-&quot;R$&quot;\ * &quot;-&quot;??_-;_-@_-'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60441756'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60441776'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom' ss:WrapText='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426936'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			//cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426956'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom' ss:WrapText='1'/>	" + Chr(13)+Chr(10)
			/*
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			*/                                               
			cScript += "	   <Borders/>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426764'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat ss:Format='Short Date'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426774'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat ss:Format='Short Date'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426784'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat ss:Format='Short Date'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60426804'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat ss:Format='Short Date'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60437340'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='16' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='m60437360'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s28'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s30'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s31'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Bottom'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s39'>	" + Chr(13)+Chr(10)
			
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			
			//cScript += "<Borders/>"
			cScript += "	   <Font x:Family='Swiss' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s40'>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s49'>	" + Chr(13)+Chr(10)
			/*
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			*/
			cScript += "<Borders/>"
			cScript += "	   <Font x:Family='Swiss' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s58'>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			//cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s59'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Top' ss:WrapText='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)					
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s65'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Center'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='9' ss:Bold='1'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s66'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Center' ss:ShrinkToFit='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='9'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s67'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Left' ss:Vertical='Top' ss:WrapText='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='9'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s68'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Center' ss:ShrinkToFit='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='8'/>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat ss:Format='Short Date'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s69'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Center' ss:ShrinkToFit='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='8'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s71' ss:Parent='s18'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Horizontal='Center' ss:Vertical='Center' ss:ShrinkToFit='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='8'/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	  <Style ss:ID='s72'>	" + Chr(13)+Chr(10)
			cScript += "	   <Alignment ss:Vertical='Bottom' ss:WrapText='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Borders>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Bottom' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Left' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Right' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Border ss:Position='Top' ss:LineStyle='Continuous' ss:Weight='1'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Borders>	" + Chr(13)+Chr(10)
			cScript += "	   <Font x:Family='Swiss' ss:Size='9'/>	" + Chr(13)+Chr(10)
			cScript += "	   <NumberFormat/>	" + Chr(13)+Chr(10)
			cScript += "	  </Style>	" + Chr(13)+Chr(10)
			cScript += "	 </Styles>	" + Chr(13)+Chr(10)
			cScript += "	 <Worksheet ss:Name='Plan2'>	" + Chr(13)+Chr(10)
			cScript += "	  <Table ss:ExpandedColumnCount='10' ss:ExpandedRowCount='" + AllTrim(Str(nQtdLinhas)) + "' x:FullColumns='1'	" + Chr(13)+Chr(10)
			cScript += "	   x:FullRows='1'>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:Width='59.25'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:AutoFitWidth='0' ss:Width='221.25'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:Width='63'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:Width='33'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:Width='71.25'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Column ss:Width='75'/>	" + Chr(13)+Chr(10)
			cScript += "	   <Row ss:AutoFitHeight='0' ss:Height='20.25'>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='5' ss:StyleID='m60437340'><Data ss:Type='String'>Relatório de itens de revenda (RELATÓRIO EM TESTE)</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='5' ss:StyleID='s30'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='5' ss:StyleID='m60437360'><Data ss:Type='String'>Parâmetros do relatório</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s28'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row ss:AutoFitHeight='0' ss:Height='5.25'>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='5' ss:StyleID='s30'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Pedido de :</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s40'><Data ss:Type='String'>" + AllTrim(MV_PAR01) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Emissão de:</Data></Cell>	" + Chr(13)+Chr(10)

			cDataTmp := Substr(DtoS(MV_PAR03), 1, 4) + "-" + Substr(DtoS(MV_PAR03), 5, 2) + "-" + Substr(DtoS(MV_PAR03), 7, 2)

			cScript += "	    <Cell ss:MergeAcross='2' ss:StyleID='m60426764'><Data ss:Type='DateTime'>" + cDataTmp + "T00:00:00.000</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Pedido até:</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s40'><Data ss:Type='String'>" + AllTrim(MV_PAR02) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Emissão até:</Data></Cell>	" + Chr(13)+Chr(10)
			
			cDataTmp := Substr(DtoS(MV_PAR04), 1, 4) + "-" + Substr(DtoS(MV_PAR04), 5, 2) + "-" + Substr(DtoS(MV_PAR04), 7, 2)
			
			cScript += "	    <Cell ss:MergeAcross='2' ss:StyleID='m60426774'><Data ss:Type='DateTime'>" + cDataTmp + "T00:00:00.000</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Empresa:</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s40'><Data ss:Type='String'>" + AllTrim(cEmpresa) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Impressão:</Data></Cell>	" + Chr(13)+Chr(10)
			
			cDataTmp := Substr(DtoS(Date()), 1, 4) + "-" + Substr(DtoS(Date()), 5, 2) + "-" + Substr(DtoS(Date()), 7, 2)
			
			cScript += "	    <Cell ss:MergeAcross='2' ss:StyleID='m60426784'><Data ss:Type='DateTime'>" + cDataTmp + "T00:00:00.000</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Setor Com.:</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s40'><Data ss:Type='String'>" + Alltrim(cTppvFull) + "</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:StyleID='s39'><Data ss:Type='String'>Exibir:</Data></Cell>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='2' ss:StyleID='m60426784'><Data ss:Type='String'>" + Alltrim(cExibir) + "</Data></Cell>
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			cScript += "	   <Row>	" + Chr(13)+Chr(10)
			cScript += "	    <Cell ss:MergeAcross='5' ss:StyleID='s31'/>	" + Chr(13)+Chr(10)
			cScript += "	   </Row>	" + Chr(13)+Chr(10)
			
			cScript += cItens
			
			cScript += "	  </Table>	" + Chr(13)+Chr(10)
			cScript += "	  <WorksheetOptions xmlns='urn:schemas-microsoft-com:office:excel'>	" + Chr(13)+Chr(10)
			cScript += "	   <PageSetup>	" + Chr(13)+Chr(10)
			cScript += "	    <Header x:Margin='0.49212598499999999'/>	" + Chr(13)+Chr(10)
			cScript += "	    <Footer x:Margin='0.49212598499999999'/>	" + Chr(13)+Chr(10)
			cScript += "	    <PageMargins x:Bottom='0.57' x:Left='0.39' x:Right='0.46' x:Top='0.6'/>	" + Chr(13)+Chr(10)
			cScript += "	   </PageSetup>	" + Chr(13)+Chr(10)
			cScript += "	   <Print>	" + Chr(13)+Chr(10)
			cScript += "	    <ValidPrinterInfo/>	" + Chr(13)+Chr(10)
			cScript += "	    <HorizontalResolution>300</HorizontalResolution>	" + Chr(13)+Chr(10)
			cScript += "	    <VerticalResolution>0</VerticalResolution>	" + Chr(13)+Chr(10)
			cScript += "	    <NumberofCopies>0</NumberofCopies>	" + Chr(13)+Chr(10)
			cScript += "	   </Print>	" + Chr(13)+Chr(10)
			cScript += "	   <Zoom>115</Zoom>	" + Chr(13)+Chr(10)
			cScript += "	   <Selected/>	" + Chr(13)+Chr(10)
			cScript += "	   <Panes>	" + Chr(13)+Chr(10)
			cScript += "	    <Pane>	" + Chr(13)+Chr(10)
			cScript += "	     <Number>3</Number>	" + Chr(13)+Chr(10)
			cScript += "	     <ActiveRow>19</ActiveRow>	" + Chr(13)+Chr(10)
			cScript += "	     <ActiveCol>1</ActiveCol>	" + Chr(13)+Chr(10)
			cScript += "	    </Pane>	" + Chr(13)+Chr(10)
			cScript += "	   </Panes>	" + Chr(13)+Chr(10)
			cScript += "	   <ProtectObjects>False</ProtectObjects>	" + Chr(13)+Chr(10)
			cScript += "	   <ProtectScenarios>False</ProtectScenarios>	" + Chr(13)+Chr(10)
			cScript += "	  </WorksheetOptions>	" + Chr(13)+Chr(10)
			cScript += "	 </Worksheet>	" + Chr(13)+Chr(10)
			cScript += "	</Workbook>	" + Chr(13)+Chr(10)
			
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
