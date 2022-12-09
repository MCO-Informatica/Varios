/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT001	ºAutor  William Luiz Antunes Gurzoni   03/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Faz a impressão do pedido de venda interno utilizando um    º±±
±±º          ³arquivo modelo (.dot)                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Copia do pedido de venda                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

#include "RWMAKE.CH"
#include "MSOLE.CH"          

User Function RFAT001()

	//Inicia variaveis locais
	Local aSays    := {}
	Local aButtons := {}
	Local nOpca    := {}
	Local aRegs    := {}
	Local cTitoDlg := "Impressão - Cópia do pedido de venda"
	Local cperg    := "FAT0002"
	Local I, J 
		
	aAdd( aSays, "Esta rotina tem como objetivo gerar a impressão de Pedidos de acordo" )
	aAdd( aSays, "com os paramentros informados pelo usuário. Utiliza documento .DOT como" )
	aAdd( aSays, "padrão." )
	
	aAdd( aButtons, {5, .T., { |o| Pergunte( cPerg, .T. ) } } )
	aAdd( aButtons, {1, .T., { |o| nOpca := 1, FechaBatch() } } )
	aAdd( aButtons, {2, .T., { |o| nOpca := 2, FechaBatch() } } )
    
	
	FormBatch( cTitoDlg, aSays, aButtons )
	If nOpca == 1
		Pergunte( cPerg, .F. )
		Processa( {|| RFAT001B( "Processando pedido. Aguarde..." ) } )
	EndIf
	Return()
	
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RFAT001B	ºAutor  William Luiz Antunes Gurzoni   03/05/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³    Gera o relatorio                                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Copia do pedido de venda                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	
Static Function RFAT001B()

//INICIALIZACAO DAS VARIAVEIS DO PEDIDO 
	Local	cVersao		:= "1.2"
	Local	cNum		:= ""  
	Local	cPedRef		:= ""	//NUMERO DE PEDIDO DE REFERENCIA/RELACIONADO (UTILIZADO NAS DUPLICACOES ENTRE EMPRESAS)
	Local	cXtppv		:= ""   //SETOR INTERNO QUE ESTA REALIZANDO A VENDA (LICITACAO, VENDA NACIONAL, ETC)      
	Local	dEmissao	:= ""
	Local	cTpFrete	:= ""	//CIF OU FOB
	Local	cFrete		:= ""	//VALOR DO FRETE
	Local	cXtpinst	:= ""	//INSTALACAO (CLIENTE OU COZIL)
	Local	cXtmono		:= ""	//TIPO DE TENSAO MONOFASICA DAS INSTALACOES DO CLIENTE
	Local	cXttrif		:= ""	//TIPO DE TENSAO TRIFASICA DAS INSTALACOES DO CLIENTE
	Local	cPlexec		:= ""	//SERA CRIADO PLANTA EXECUTIVA?
	Local	cXtpgas		:= ""	//TIPO DE GAS DAS INSTALACOES DO CLIENTE
	Local	cVend1		:= ""	//VENDEDOR 01   
	Local	cCliente	:= ""	//NUMERO DO CLIENTE
	Local	cLojacli	:= ""  	//LOJA DO CLIENTE
	Local	cXHistor	:= ""	//HISTORICO DE ALTERACOES (OBS)   
	Local 	cDoc		:= ""	//NOME DO DOCUMENTO QUE SERA UTILIZADO
	
//INICIALIZACAO DAS VARIAVEIS DO CLIENTE
    Local	cNome		:= ""
    Local	cEst		:= ""   //UF - ESTADO
    Local	cCgc		:= ""   //CPF
    Local	cEnd		:= ""
    Local	cMun		:= ""   //MUNICIPIO
    Local	cCep		:= ""
    Local	cBairro		:= ""
    Local	cDdd		:= ""
    Local	cTel		:= ""
    Local	cContato	:= ""
    Local	cEmail		:= ""   
    Local	cEndent		:= "" 	//ENDERECO DE ENTREGA 
    Local	cEste		:= ""	//ESTADO DE ENTREGA
    Local	cMune		:= ""	//MUNICIPIO DE ENTREGA
    Local	cBairroe	:= ""	//BAIRRO DE ENTREGA
    Local	cCepe		:= ""	//CEP ENTREGA
    Local	cPessoa		:= ""
                        
//INICIALIZACAO DAS VARIAVEIS VENDEDOR	
	Local	cVeNome		:= ""
		                     
//VARIAVEIS DOS ITENS
	Local	nCont		:= 0	//CONTA O NUMERO ATUAL DA LINHA   
	Local	nItens		:= 0	//ARMAZENA O NUMERO TOTAL DE ITENS
	Local	cOp			:= {}	//OP FORMADA PELO PEDIDO+ITEM
	Local	cProduto	:= {}
	Local	cXitcli		:= {}	//ITEM DO PEDIDO DO CLIENTE
	Local	cDescri		:= {}
	Local	cQtdven		:= {}	//QUANTIDADE
	Local	cXespec		:= {}	//ESPECIFICACAO - CAMPO MEMO
	Local	cEntreg		:= {}	//A DATA DE ENTREGA - EH POR PRODUTO

//VARIAVEIS DO DOCUMENTO
	Local oWord   	:= Nil
	Local nItens	:= 0
	Local cPatch	:= ""

//VERIFICA EMPRESA DE ORIGEM

	Do Case 
		Case xEmpresa() == "01"
			cDoc := "COPIA_PEDIDO_VENDA_EQUIPAMENTOS.DOT"
		Case xEmpresa() == "02"
			cDoc := "COPIA_PEDIDO_VENDA_COZINHAS.DOT"
		Case xEmpresa() == "03"
			cDoc := "COPIA_PEDIDO_VENDA_COZILANDIA.DOT"
	End Case
   	
//ATRIBUI LOCAL DO DOCUMENTO
	cPatch		:= "C:\msiga\modword\" + cDoc
	
//BUSCA PEDIDO
	DbSelectArea("SC5")
	DbSetOrder(1)
	If !DbSeek(xFilial() + mv_par01) 
		Aviso( "Erro", "Pedido não encontrado. Contate o administrador do sistema", { "Ok" }, 2 )
		Return
	EndIf  
	
//GERA DADOS DO CABECALHO DO PEDIDO
	cNum		:= SC5->C5_NUM    
	cPedRef		:= SC5->C5_XPEDREL
	cXtppv		:= SC5->C5_XTPPV
	dEmissao	:= SC5->C5_EMISSAO
	cTpFrete	:= SC5->C5_TPFRETE
	cFrete		:= SC5->C5_FRETE
	cXtpinst	:= SC5->C5_XTPINST
	cXtmono		:= SC5->C5_XTMONO
	cXttrif		:= SC5->C5_XTTRIF
	cPlexec		:= SC5->C5_PLEXEC
	cXtpgas		:= SC5->C5_XTPGAS               
	cVend1		:= SC5->C5_VEND1                
	cCliente	:= SC5->C5_CLIENTE
	cLojacli	:= SC5->C5_LOJACLI
	cXHistor	:= SC5->C5_XHISTOR

//BUSCA DADOS DO CLIENTE
	DbSelectArea("SA1")
	DbSetOrder(1)
	If !DbSeek( xFilial() + cCliente + cLojacli) 
		  alert("Cliente não Encontrado. Contate o administrador do sistema")
		  return()
	EndIf
	
	cNome		:= SA1->A1_NOME
	cEst		:= SA1->A1_EST
	cCgc		:= SA1->A1_CGC
	cEnd		:= SA1->A1_END
	cMun		:= SA1->A1_MUN
	cCep		:= SA1->A1_CEP
	cBairro		:= SA1->A1_BAIRRO
	cDdd		:= SA1->A1_DDD
	cTel		:= SA1->A1_TEL
	cContato	:= SA1->A1_CONTATO 
	cEmail		:= SA1->A1_EMAIL
	cEndent		:= SA1->A1_ENDENT
	cEste		:= SA1->A1_ESTE
	cMune		:= SA1->A1_MUNE
	cBairroe	:= SA1->A1_BAIRROE
	cCepe		:= SA1->A1_CEPE
	cPessoa		:= SA1->A1_PESSOA
	 	
//BUSCA DADOS DO VENDEDOR
 	DbSelectArea("SA3")
 	DbSetOrder(1)
 	If !DbSeek(xFilial() + cVend1)
 		Alert("Vendedor não encontrado. Comunique o adinistrador do sistema.")
 		return()
 	EndIf 
 	
	cVeNome		:= SA3->A3_NOME
		        	
//BUSCA DADOS DOS ITENS DO PEDIDO
	dbSelectArea("SC6")
	DbSetOrder(1)      
	If !DbSeek(xFilial() + mv_par01)
		Alert("Itens do pedido nao encontrados. Contate o administrador do sistema.")
		return()
	EndIf               
	
	nCont := 0
		
//LOOPING DE ATRIBUICAO DOS ITENS (PREENCHE O ARRAY DOS ITENS)
	While !Eof() .and. SC6->C6_NUM == cNum            
	
		AADD(cOp 		,SC6->C6_NUM + SC6->C6_ITEM		)	//OP FORMADA PELO PEDIDO+ITEM
		AADD(cProduto	,SC6->C6_PRODUTO				)
		AADD(cXitcli	,SC6->C6_XITCLI					)	//ITEM DO PEDIDO DO CLIENTE
		AADD(cDescri	,SC6->C6_DESCRI					)
		AADD(cQtdven	,SC6->C6_QTDVEN					)	//QUANTIDADE
		AADD(cXespec	,SC6->C6_XESPEC					)	//ESPECIFICACAO - CAMPO MEMO
		AADD(cEntreg	,SC6->C6_ENTREG					)	//A DATA DE ENTREGA - EH POR PRODUTO 

		nCont++
		dbSkip()
	Enddo  
	
//ARMAZENA O NUMERO TOTAL DE ITENS
	nItens		:= nCont	 	
  
//MONTA DIRETORIO DE TRABALHO
	MontaDir( "C:\MSIGA\MODWORD\" ) 
	'nCont := Str(nCont) 
	__CopyFile( "\SYSTEM\WORD\" + cDoc , cPatch )  	//Copia o arquivo para o diretorio local 
	
//CRIA CONEXAO COM WORD	
	OLE_CloseLink()
	oWord := OLE_CreateLink()
	OLE_NewFile( oWord, cPatch )                                        
	
//VERIFICA TIPO DE FRETE UTILIZADO 
	Do Case
		Case cTpFrete == "C"
			cTpFrete := "CIF"
		Case cTpFrete == "F"
			cTpFrete := "FOB"
		Case cTpFrete == "T"
			cTpFrete := "TERCEIRO"
		Case cTpFrete == "S"
			cTpFrete := "SEM FRETE"
	EndCase			


//CRIA MASCARA PARA CPF / CNPJ DO CLIENTE
	If (cPessoa == 'F')	
		cCgc 	:=  SUBSTR(cCgc, 1, 3) + "." + SUBSTR(cCgc, 4, 3) + "." + SUBSTR(cCgc, 7, 3) + "-" + SUBSTR(cCgc, 10, 2)  
	Else      
	   	cCgc 	:=  SUBSTR(cCgc, 1, 2) + "." + SUBSTR(cCgc, 3, 3) + "." + SUBSTR(cCgc, 6, 3) + "/" + SUBSTR(cCgc, 9, 4) + "-" +  SUBSTR(cCgc, 13, 2)
	End If	

//CLASSIFICA O TIPO DE VENDA (SETOR DE VENDA)	
	Do Case
		Case cXtppv == "V"
			cXtppv := "VENDA ESTADUAL"
		Case cXtppv == "N"
			cXtppv := "VENDA NACIONAL"
		Case cXtppv == "L"
			cXtppv := "LICITACOES"
		Case cXtppv == "D"
			cXtppv := "DOACAO" 
		Case cXtppv == "A"
			cXtppv := "ASSISTENCIA TEC."
		Case cXtppv == "S"
			cXtppv := "S/P"
		Case cXtppv == "F"
			cXtppv := "FRANQUIAS"
		Case cXtppv == "R"
			cXtppv := "REMESSA"
		Case cXtppv == "O"
			cXtppv := "DEVOLUÇÃO"
		Case cXtppv == "B"
			cXtppv := "OBRA"
		Case cXtppv == "C"
			cXtppv := "COZILANDIA"
		Case cXtppv == "E"
			cXtppv := "EXPORTAÇÃO"
	EndCase       
	
//FORMATA CEP
	cCep	:= SUBSTR(cCep, 1, 5) + "-" + SUBSTR(cCep, 6, 3)		
	cCepe	:= SUBSTR(cCepe, 1, 5) + "-" + SUBSTR(cCepe, 6, 3)   
	
//FORMATA TELEFONE                 
	cTel	:= SUBSTR(cTel, 1, 4) + "-" + SUBSTR(cTel, 5, 4)	
                                                         
//FORMATA PEDIDO REFERENCIAL / RELACIONADO
	If AllTrim(cPedRef) != ""
		cNum := cNum + " / " + cPedRef
	EndIf

//ENVIA O CABECALHO PARA O WORD 
	OLE_SetDocumentVar( oWord, "cVersao"  		, cVersao 	   					)                                         
	OLE_SetDocumentVar( oWord, "cNum"	  		, cNum	 	   					)
	OLE_SetDocumentVar( oWord, "nItens"  		, nItens 	   		   		   		)
	OLE_SetDocumentVar( oWord, "cXtppv"  		, cXtppv 	   						)
	OLE_SetDocumentVar( oWord, "dEmissao"  		, dEmissao 	   		  			)
	OLE_SetDocumentVar( oWord, "cTpFrete"  		, cTpFrete + " - R$ " + transform(cFrete, "@E 9999,999.99") 	)
	OLE_SetDocumentVar( oWord, "cXtpinst"  		, UPPER(cXtpinst) 	   			)
	OLE_SetDocumentVar( oWord, "cXtmono"  		, cXtmono + " V"	   			)
	OLE_SetDocumentVar( oWord, "cXttrif"  		, cXttrif + " V"				)
	OLE_SetDocumentVar( oWord, "cPlexec"  		, UPPER(cPlexec) 	   			)
	OLE_SetDocumentVar( oWord, "cXtpgas"  		, UPPER(cXtpgas) 	   			)
	OLE_SetDocumentVar( oWord, "cVend1"  		, cVend1 	   		   			)
	OLE_SetDocumentVar( oWord, "cXHistor"  		, cXHistor 	   					)
	OLE_SetDocumentVar( oWord, "cNome"  		, cNome	 	 		  			)
	OLE_SetDocumentVar( oWord, "cCgc"  	   		, cCgc							)
	OLE_SetDocumentVar( oWord, "cEnd"  			, cEnd	 	   					)
	OLE_SetDocumentVar( oWord, "cMun"  	   		, cMun + " - " + cEst			)
	OLE_SetDocumentVar( oWord, "cCep"  	 		, transform(cCep, "99999-999")	)
	OLE_SetDocumentVar( oWord, "cBairro"  		, cBairro 	   					)
	OLE_SetDocumentVar( oWord, "cTel"  	 		, "(" + TRIM(cDdd) + ") " + transform(cTel, "9999-9999")	 	   			)
	OLE_SetDocumentVar( oWord, "cContato"  		, cContato 	   					)
	OLE_SetDocumentVar( oWord, "cEmail"  		, UPPER(cEmail)					)
	OLE_SetDocumentVar( oWord, "cEndent"  		, cEndent 	   					)
	OLE_SetDocumentVar( oWord, "cMunEste"  		, cMune + " - " + cEste			)
	OLE_SetDocumentVar( oWord, "cBairroe"  		, cBairroe 	   					)
	OLE_SetDocumentVar( oWord, "cCepe"  		, transform(cCepe, "99999-999")	)
	OLE_SetDocumentVar( oWord, "cVeNome"  		, cVeNome 	   					)			
	
//FAZ UPDATE NAS VARIAVEIS DO WORD    	
 	OLE_UpDateFields(oWord )
 
//OBS - OS ITENS SAO ENVIADOS POR ULTIMO DEVIDO A GANHO DE PERFORMANCE 
//		POIS NAO EH NECESSARIO FAZER A ATUALIZACAO (OLE_UPDATEFIELDS) NOS MESMOS
//		DEVIDO A CRIACAO DINAMICA DAS VARIAVEIS NO WORD (MACRO)
 
//ENVIA ITENS AO WORD
	For nCont := 1 to nItens
		OLE_SetDocumentVar( oWord, "cOp" 	  		+ 	AllTrim(Str(nCont))		, cOp[nCont]	 	 		)
		OLE_SetDocumentVar( oWord, "cProduto" 		+ 	AllTrim(Str(nCont))		, cProduto[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cXitcli" 		+ 	AllTrim(Str(nCont))		, cXitcli[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cDescri" 		+ 	AllTrim(Str(nCont))		, cDescri[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cQtdven" 		+ 	AllTrim(Str(nCont))		, cQtdven[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cXespec" 		+ 	AllTrim(Str(nCont))		, cXespec[nCont]	 		)
		OLE_SetDocumentVar( oWord, "cEntreg" 		+ 	AllTrim(Str(nCont))		, cEntreg[nCont]	 		)
	Next		
		
//EXECUTA MACRO (CRIA LINHAS DOS ITENS)
	OLE_ExecuteMacro(oWord,"tabItensCopiaPed") 			
							
//OPCOES DO WORD
	//OLE_UpDateFields(oWord )
	//OLE_SetProperty	(oWord, '208', .T.)
	//OLE_PrintFile	(oWord ,"ALL",,,0)
	//OLE_PrintFile	(oWord)
	//OLE_SaveFile 	(oWord, "\system\COPIA_PEDIDO_VENDA.Doc")
	//OLE_CloseLink	(oWord )

Return