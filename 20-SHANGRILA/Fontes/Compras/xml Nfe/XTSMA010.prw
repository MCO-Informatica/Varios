#Include 'Protheus.ch'
#INCLUDE "FILEIO.CH"
#INCLUDE "AP5MAIL.CH"
#INCLUDE 'TOPConn.ch'

#DEFINE DIRXML  "XMLNFE\"
#DEFINE DIRALER "NEW\"
#DEFINE DIRLIDO "OLD\"
#DEFINE DIRERRO "ERR\" 
#DEFINE DIRSOLU "SOL\"
#DEFINE DIRNFE  "NFE\"
#DEFINE DIRNFSE "NFSE\"
#DEFINE DIRNFCO "NFCO\"
#DEFINE DIRCTEE "CTEE\"

#define STR0001 "Aguarde..."
#define STR0002 If( cPaisLoc $ "ANG|PTG", "A criar interface...", "Criando interface..." )
#define STR0003 If( cPaisLoc $ "ANG|PTG", "Desfazer amarração do artigo", "Desfazer amarração do produto" )
#define STR0004 "OK"
#define STR0005 "ATENÇÃO!"
#define STR0006 "..."
#define STR0007 If( cPaisLoc $ "ANG|PTG", "F-e Disponíveis", "NF-e Disponíveis" )
#define STR0008 "Legenda"
#define STR0009 "Vinc. Ped."
#define STR0010 "Visualizar"
#define STR0011 If( cPaisLoc $ "ANG|PTG", "Gerar doc.", "Gerar Docto" )
#define STR0012 If( cPaisLoc $ "ANG|PTG", "Apto a gerar Pré-Factura.", "Apto a gerar Pré-Nota." )
#define STR0013 "Documento gerado."
#define STR0014 If( cPaisLoc $ "ANG|PTG", "Seleccionar Pedido", "Selecionar Pedido" )
#define STR0015 If( cPaisLoc $ "ANG|PTG", "Factura: ", "Nota Fiscal: " )
#define STR0016 If( cPaisLoc $ "ANG|PTG", "Série: ", "Serie: " )
#define STR0017 "Fornecedor: "
#define STR0018 "Quantidade"
#define STR0019 "Aviso"
#define STR0020 "Não foi identificado nenhum pedido de compra referente ao item "
#define STR0021 If( cPaisLoc $ "ANG|PTG", " da factura ", " da nota fiscal " )
#define STR0022 "Pedido de Compra"
#define STR0023 "&Visualizar Pedido"
#define STR0024 If( cPaisLoc $ "ANG|PTG", "Aguarde, a geraro Pré-Factura de Entrada...", "Aguarde, gerando Pré-Nota de Entrada..." )
#define STR0025 If( cPaisLoc $ "ANG|PTG", "Pré-factura ou documento de entrada gerado com sucesso.", "Pré Nota ou Documento de Entrada gerado com SUCESSO." )
#define STR0026 If( cPaisLoc $ "ANG|PTG", "Dados da Fact-e", "Dados da NF-e" )
#define STR0027 If( cPaisLoc $ "ANG|PTG", "Liberado para pré-factura", "Liberado para pre-nota" )
#define STR0028 "Processada"
#define STR0029 If( cPaisLoc $ "ANG|PTG", "Aguarde... A seleccionar registos...", "Aguarde... Selecionando registros..." )
#define STR0030 If( cPaisLoc $ "ANG|PTG", "A verificar pedidos de compra...", "Verificando pedidos de compra..." )
#define STR0031 If( cPaisLoc $ "ANG|PTG", "Erro no pedido de compra. Seleccione pedido de compra novamente.", "Erro no pedido de compra. Selecione pedido de compra novamente." )
#define STR0032 If( cPaisLoc $ "ANG|PTG", "Estado: ", "Status: " )
#define STR0033 If( cPaisLoc $ "ANG|PTG", "Nome do ficheiro:", "Nome do arquivo:" )
#define STR0034 If( cPaisLoc $ "ANG|PTG", "Utilizador:", "Usuário:" )
#define STR0035 "Data:"
#define STR0036 "Hora:"
#define STR0037 If( cPaisLoc $ "ANG|PTG", "Essa opção náo é válida para Fact Devolução", "Essa opção náo é válida para NF Devolução" )
#define STR0038 If( cPaisLoc $ "ANG|PTG", "Tipo do documento de entrada não permite seleccionar pedido(s) de compra.", "Tipo do documento de entrada não permite selecionar pedido(s) de compra." )
#define STR0039 If( cPaisLoc $ "ANG|PTG", "Identificação de Artigo", "Identificação de Produto" )
#define STR0040 "Fornecedor"
#define STR0041 "Cliente"
#define STR0042 If( cPaisLoc $ "ANG|PTG", "Cód. Artigo", "Cod. Produto" )
#define STR0043 If( cPaisLoc $ "ANG|PTG", "Descrição Artigo", "Descrição Produto" )
#define STR0044 "Cod. "
#define STR0045 "Cli./Fornec.: "
#define STR0046 If( cPaisLoc $ "ANG|PTG", "Não foi identificado artigo correspondente para os listados abaixo.", "Não foi identificado produto correspondente para os listados abaixo." )
#define STR0047 If( cPaisLoc $ "ANG|PTG", "Seleccionar Artigo", "Selecionar Produto" )
#define STR0048 If( cPaisLoc $ "ANG|PTG", "Não é possivel gerar pré-factura. Ainda existem cód. artigo não identificados.", "Não é possivel gerar pré-nota. Ainda existem cod. produto não identificados." )
#define STR0049 If( cPaisLoc $ "ANG|PTG", "Tem certeza que deseja cancelar o processo de geração da pré-factura?", "Tem certeza que deseja cancelar o processo de geração da pré-nota?" )
#define STR0050 If( cPaisLoc $ "ANG|PTG", "Não foi encontrado o Cód. do artigo correspondente ao artigo", "Não foi encontrado o Cod. do produto correspondente ao produto" )
#define STR0051 If( cPaisLoc $ "ANG|PTG", "Deseja seleccioná-lo agora?", "Deseja seleciona-lo agora?" )
#define STR0052 If( cPaisLoc $ "ANG|PTG", "A procurar pedidos de compra relacionados...", "Procurando pedidos de compra relacionados..." )
#define STR0053 If( cPaisLoc $ "ANG|PTG", "A seleccionar Registos...", "Selecionando Registros..." )
#define STR0054 If( cPaisLoc $ "ANG|PTG", "Selecção dos Pedidos de Compra", "Seleção dos Pedidos de Compra" )
#define STR0055 "Pedido"
#define STR0056 "Item"
#define STR0057 "Data"
#define STR0058 "Qtd. Ped. Compra"
#define STR0059 "Qtd. a baixar"
#define STR0060 If( cPaisLoc $ "ANG|PTG", "Qtd. Factura: ", "Qtd. Nota Fiscal: " )
#define STR0061 "Qtd. sem Pedido de Compra: "
#define STR0062 If( cPaisLoc $ "ANG|PTG", "A carregar visualização do pedido", "Carregando visualização do pedido" )
#define STR0063 If( cPaisLoc $ "ANG|PTG", "A qtd. digitada deve ser menor ou ", "A Qtd. digitada deve ser menor ou " )
#define STR0064 If( cPaisLoc $ "ANG|PTG", "igual à Qtd. Factura ", "igual a Qtd. Nota Fiscal " )
#define STR0065 If( cPaisLoc $ "ANG|PTG", "Ao desfazer a amarração do artigo todas as amarrações com pedidos de compra serão desfeitas.", "Ao desfazer a amarração do produto todas as amarrações com pedidos de compra serão desfeitas." )
#define STR0066 "Tem certeza que deseja continuar?"
#define STR0067 "Sim"
#define STR0068 "Não"
#define STR0069 "Os campos quantidade, valor unitário ou valor total do item "
#define STR0070 If( cPaisLoc $ "ANG|PTG", " Da Factura  ", " da nota " )
#define STR0071 If( cPaisLoc $ "ANG|PTG", " estão em branco, portanto a pré-factura não será criada.", " estão em branco, portanto a pré-nota não será gerada." )
#define STR0072 "Apto a gerar Doc. Entrada (Bonificação)."
#define STR0073 If( cPaisLoc $ "ANG|PTG", "Aguarde, a gerar Documento de Entrada...", "Aguarde, gerando Documento de Entrada..." )
#define STR0074 If( cPaisLoc $ "ANG|PTG", "Este documento possui item(s) de bonificação e, por esse motivo, será gerado Documento de Entrada. Confirma geração?", "Este documento possui item(s) de bonificação e por esse motivo será gerado Doumento de Entrada. Confirma geração?" )
#define STR0075 If( cPaisLoc $ "ANG|PTG", "Este Tipo de Entrada não pode gerar duplicata, pois será utilizado em documentos de bonificação.", "Este Tipo de Entrada não pode gerar duplicata pois será utilizado em documentos de bonificação." )
#define STR0076 "Sair"
#define STR0077 If( cPaisLoc $ "ANG|PTG", "A crianr índice de trabalho", "Criando indíce de trabalho" )
#define STR0078 "Filtrar"
#define STR0079 "Remessa"
#define STR0080 "Excluir"
#define STR0081 If( cPaisLoc $ "ANG|PTG", "A importar dados do ficheiro XML...", "Importando dados do arquivo XML..." )
#define STR0082 "Erro"
#define STR0083 If( cPaisLoc $ "ANG|PTG", "Ficheiro ", "Arquivo " )
#define STR0084 " inexistente."
#define STR0085 If( cPaisLoc $ "ANG|PTG", "Este XML pertence a outra empresa/filial, e não podera ser processado na empresa/filial corrente.", "Este XML pertence a outra empresa/filial e não podera ser processado na empresa/filial corrente." )
#define STR0086 If( cPaisLoc $ "ANG|PTG", "ID de Fe ja registado na Factura ", "ID de NFe ja registrado na NF " )
#define STR0087 " do fornecedor "
#define STR0088 If( cPaisLoc $ "ANG|PTG", "Tag _InfNfe:_Det não localizada.", "Tag _InfNfe:_Det nao localizada." )
#define STR0089 "Tag _CNPJ/_CPF ausente."
#define STR0090 If( cPaisLoc $ "ANG|PTG", " de Nr.Cont. número ", " de CNPJ/CPF numero " )
#define STR0091 " inexistente na base."
#define STR0092 If( cPaisLoc $ "ANG|PTG", " sem registo de Artigo X ", " sem cadastro de Produto X " )
#define STR0093 " para o código "
#define STR0094 If( cPaisLoc $ "ANG|PTG", "Fe tipo devolução não pode ser processado por este procedimento.", "NFe tipo devolução não pode ser processado por esta rotina." )
#define STR0095 If( cPaisLoc $ "ANG|PTG", "Esta Fact-e gerou documento e não poderá ser excluída.", "Esta NF-e gerou documento e não poderá ser excluída." )
#define STR0096 If( cPaisLoc $ "ANG|PTG", "Doc. Entrada bonificação! Será necessário registar o Tp.Entr. para bonificação no procedimento de Artigos x Forncedores.", "Doc. Entrada Bonificação! Será necessário cadastrar o Tp.Entr. para Bonificação na rotina de Produtos x Forncedores." )
#define STR0097 If( cPaisLoc $ "ANG|PTG", "Para utilizar este procediemento, será necessário rodar o compatibilizador UPDCOM19", "Para utilizar esta rotina será necessário rodar o compatibilizador UPDCOM19" )
#define STR0098 If( cPaisLoc $ "ANG|PTG", "A quantidade e ou preço unitário do pedido seleccionado é divergente do item da F-e. Confirma a selecção?", "A quantidade e ou preço unitário do pedido selecionado é divergente do item da NFe. Confirma a seleção?" )
#define STR0099 If( cPaisLoc $ "ANG|PTG", "Ficheiro inexistente.", "Arquivo inexistente." )
#define STR0100 "Não se aplica."
#define STR0101 If( cPaisLoc $ "ANG|PTG", "Erro de sintaxe no ficheiro XML: ", "Erro de sintaxe no arquivo XML: " )
#define STR0102 If( cPaisLoc $ "ANG|PTG", "Entre em contacto com o emissor do documento e comunique a ocorrência.", "Entre em contato com o emissor do documento e comunique a ocorrência." )
#define STR0103 If( cPaisLoc $ "ANG|PTG", "Fact-e tipo devolução não pode ser processada por esta procedimento.", "NF-e tipo devolução não pode ser processada por esta rotina." )
#define STR0104 "Este documento deve ser incluído manualmente."
#define STR0105 If( cPaisLoc $ "ANG|PTG", "ID de Fact-e já registado na Factura ", "ID de NF-e já registrado na NF " )
#define STR0106 " do fornecedor "
#define STR0107 If( cPaisLoc $ "ANG|PTG", "Exclua o documento registado na ocorrência.", "Exclua o documento registrado na ocorrência." )
#define STR0108 "Fornecedor "
#define STR0109 "inexistente na base."
#define STR0110 If( cPaisLoc $ "ANG|PTG", "Gere registo para este fornecedor.", "Gere cadastro para este fornecedor." )
#define STR0111 If( cPaisLoc $ "ANG|PTG", " sem registo de Artigo X Fornecedor", " sem cadastro de Produto X Fornecedor" )
#define STR0112 " para o código "
#define STR0113 If( cPaisLoc $ "ANG|PTG", "Gere registo para esta relação.", "Gere cadastro para esta relação." )
#define STR0114 If( cPaisLoc $ "ANG|PTG", " sem registo de Artigo X Fornecedor", " sem cadastro de Produto X Fornecedor" )
#define STR0115 " para o código "
#define STR0116 If( cPaisLoc $ "ANG|PTG", "Não existem ficheiros com erros para serem reprocessados.", "Não existem arquivos com erros para serem reprocessados." )
#define STR0117 If( cPaisLoc $ "ANG|PTG", "Reprocessar Fact-e", "Reprocessar NF-e" )
#define STR0118 If( cPaisLoc $ "ANG|PTG", "Ficheiro", "Arquivo" )
#define STR0119 "Documento"
#define STR0120 If( cPaisLoc $ "ANG|PTG", "Série", "Serie" )
#define STR0121 "Razão Social"
#define STR0122 If( cPaisLoc $ "ANG|PTG", "Chave Fact-e:", "Chave NF-e:" )
#define STR0123 "Versão:"
#define STR0124 If( cPaisLoc $ "ANG|PTG", "Dados da importação", "Dados da Importação" )
#define STR0125 If( cPaisLoc $ "ANG|PTG", "Dados da geração", "Dados da Geração" )
#define STR0126 "Marca/Desmarca"
#define STR0127 "Reprocessar"
#define STR0128 If( cPaisLoc $ "ANG|PTG", "Remessa foi realizada com sucesso. Aguarde o retorno do ficheiro validado via TOTVS Colaboração.", "Remessa foi realizada com sucesso. Aguarde o retorno do arquivo validado via TOTVS Colaboracao." )
#define STR0129 "Pesquisar"
#define STR0130 If( cPaisLoc $ "ANG|PTG", "Aguarde, a estabelecer comunicação com TSS...", "Aguarde, estabelecendo comunicação com TSS..." )
#define STR0131 If( cPaisLoc $ "ANG|PTG", "A processar", "Processando" )
#define STR0132 If( cPaisLoc $ "ANG|PTG", "Não foi encontrado o código do artigo: ", "Não foi encontrado o código do produto: " )
#define STR0133 If( cPaisLoc $ "ANG|PTG", "na tabela de artigos", "na tabela de produtos" )
#define STR0134 If( cPaisLoc $ "ANG|PTG", "Gere registo para este artigo.", "Gere cadastro para este produto." )

                 
User Function XTSMA010( )
	Local alSize    	:= MsAdvSize() 
	Local alHdCps 		:= {}
	Local alHdSize      := {}    
	Local alCpos        := {}
	Local alItBx        := {}    
	Local alParam       := {}
	Local alCpHd        := MontHdr() 
	Local clLine        := "" 
	Local clFilBrw 		:= ""
	Local cTCFilterEX	:= "TCFilterEX"	
	Local nlTl1     	:= alSize[1]
	Local nlTl2    		:= alSize[2]
	Local nlTl3    		:= alSize[1]+550
	Local nlTl4     	:= alSize[2]+900
	Local nlCont        := 0  
	Local nlPosCFor     := 0
	Local nlPosLoja     := 0
	Local nlPosNum      := 0
	Local nlPosSer      := 0       
	Local nlPosCHNF		:= 0
	Local nlStatusNF	:= 0
	Local olLBox    	:= NIL  
	Local olBtLeg       := NIL  
	Local olBtFiltro    := NIL  
	Local olBtImpM		:= NIL  
	Local olBtReproc	:= NIL
	Local olBtParam		:= NIL	
	Local oOK 			:= LoadBitmap(GetResources(),'LBOK')
	Local oNO 			:= LoadBitmap(GetResources(),'LBNO')
	Local clPar     	:= "MTA140I"
	    	
	Private _opDlgPcp	:= NIL 
	Private opBtVis     := NIL   
	Private opBtImp     := NIL
	Private opBtPed     := NIL  
	Private olBtExc     := NIL
	Private aRotina		:= {{"Pesquisar","AxPesqui",0,1,0,.F.},{"Visualizar","AxVisual",0,2,0,.F.},{"Incuir","AxInclui",0,3,0,.F.},{"Alterar","AxAltera",0,4,0,.F.},{"Excluir","AxDeleta",0,5,0,.F.}}
	Private _cTpNFRot	:= ""
	Private _cTESNFRot	:= ""
	Private _cOPERNFRot	:= ""
	
	If AliasIndic("SDS")
	  	If !Pergunte(clPar,.T.)    
			Return()	
		EndIf
	Else 
		MsgStop("Para utlizar esta rotina serÃ¡ necessÃ¡rio rodar o compatibilizador UPDCOM19") 
	EndIf  

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Array alParam recebe parametros para filtro           Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™                                                                                                      
    aAdd(alParam,{1 , " " }) // 1 - Liberado para pre-nota      
    aAdd(alParam,{2 , "P" }) // 2 - Processada pelo Protheus  
   
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Monta o Header com os titulos do TWBrowse             Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 	
	//Coluna usada como MarkBrowse
	If SDS->(FieldPos("DS_VALMERC")) > 0
		AADD(alHdCps," ")  
		AADD(alHdSize,1) 
		AADD(alCpos,{".F.","DS_OK","L","R",""})
	EndIf
	dbSelectArea("SX3")
	dbSetOrder(2)
	For nlCont	:= 1 to Len(alCpHd) 
		If MsSeek(alCpHd[nlCont])   
			If alCpHd[nlCont] == "DS_STATUS"  
				AADD(alHdCps," ")  
				AADD(alHdSize,1)
			Else	
				AADD(alHdCps,AllTrim(X3Titulo()))  
				AADD(alHdSize,Iif(nlCont==1,200,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo())))
			EndIf	
			AADD(alCpos,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
		EndIf
	Next         

	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	ADHeadRec("SDS",alCpos)
	   
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Verifica as posicoes/ordens dos campos no array       Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
	nlPosNum  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_DOC"})  
	nlPosSer  := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_SERIE"})    
	nlPosCFor := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_FORNEC"})
	nlPosLoja := Ascan(alCpos,{|x|Alltrim(X[2])=="DS_LOJA"})  
	nlStatusNF:= Ascan(alCpos,{|x|AllTrim(X[2])=="DS_STATUS"})
	
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Colunas da ListBox/TWBrowse                                				Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™           	
	If SDS->(FieldPos("DS_VALMERC")) > 0
	 	clLine := "{|| {If(alItBx[olLBox:nAt,1],oOK,oNO),U_SelCor(alItBx[olLBox:nAt,2]), "
//	 	clLine := "{|| {If(alItBx[olLBox:nAt,1],oOK,oNO),alItBx[olLBox:nAt,2], "
		For nlCont:=3 To Len(alCpos)
			clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
		Next nlCont
		clLine += "}}"
	Else
		clLine := "{|| {U_SelCor(alItBx[olLBox:nAt,1],alItBx[olLBox:nAt,9]) ,"       
//		clLine := "{|| {alItBx[olLBox:nAt,1],alItBx[olLBox:nAt,9]  ,"       
		For nlCont:=2 To Len(alCpos)
			clLine += "alItBx[olLBox:nAt,"+AllTrim(Str(nlCont))+"]"+IIf(nlCont<Len(alCpos),",","")
		Next nlCont
		clLine += "}}"
	EndIf                                                                                                               
	DEFINE MSDIALOG _opDlgPcp TITLE "Importação XML" From alSize[7],0 to alSize[6],alSize[5] PIXEL 
	
	oPanelTop := tPanel():New(0,0,"",_opDlgPcp,,,,,,00,00) 
	oPanelTop:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPanelBottom := tPanel():New(0,0,"",_opDlgPcp,,,,,,00,030)
	oPanelBottom:Align := CONTROL_ALIGN_BOTTOM
	
   	// Visualizar
	opBtVis := TButton():New(nlTl1+203,alSize[2]+016,"&Visualizar",oPanelBottom,{|| ExecTela(2,;
																				alItBx[olLBox:nAt,nlPosCFor],;			// | Cod. Fornec./Cli.
																				alItBx[olLBox:nAt,nlPosLoja],;	  		// | Loja
																				alItBx[olLBox:nAt,nlPosNum],;	   		// | Num. Nota Fiscal
																				alItBx[olLBox:nAt,nlPosSer]  )};			// | Serie				
																				,035,014,,,,.T.)
	opBtVis:align:= CONTROL_ALIGN_LEFT

	// Item X PC																					
 	opBtPed := TButton():New(nlTl1+203,alSize[2]+051,"Vinc. &Docto",oPanelBottom,{|| ExecTela(IIF(alItBx[olLBox:nAt,nlStatusNF] $ "DC",6,4), ;	
 																					alItBx[olLBox:nAt,nlPosCFor] ,;			// | Cod. Fornecedor
 																			   		alItBx[olLBox:nAt,nlPosLoja] ,;			// | Loja
 																			   		alItBx[olLBox:nAt,nlPosNum ] ,;			// | Numero Doc.
 																			   		alItBx[olLBox:nAt,nlPosSer])} ;			// | Serie
 																					,041,014,,,,.T.  )
	opBtPed:align:= CONTROL_ALIGN_LEFT
	
	// Gerar Pre Nota
	opBtImp := TButton():New(nlTl1+203,alSize[2]+092,"&Gerar NF",oPanelBottom,{|| (ExecTela(	3,;									// | Opcao
																					alItBx[olLBox:nAt,nlPosCFor],;     		// | Cod. Fornec./Cli.
																				   	alItBx[olLBox:nAt,nlPosLoja],;   		// | Loja
																				   	alItBx[olLBox:nAt,nlPosNum],;    	   	// | Num. Nota Fiscal
																				   	alItBx[olLBox:nAt,nlPosSer],,alItBx,nlPosCFor,nlPosLoja,nlPosNum,nlPosSer),; // | Serie
																				   	(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
																				   	(olLBox:Refresh()),(olLBox:bGoTop),;
																				   	(IIf(!Empty(olLBox:aArray),AtuBtn(IF(SDS->(FieldPos("DS_VALMERC")) > 0,olLBox:aArray[olLBox:nAt,2],olLBox:aArray[olLBox:nAt,1])),)))};
																				   	,040,014,,,,.T.)
	opBtImp:align:= CONTROL_ALIGN_LEFT
	// Legenda
	olBtLeg := TButton():New(nlTl1+203,alSize[2]+141,"&Legenda",oPanelBottom, {|| U_AT140ILege()} ,035,014,,,,.T.  ) 
	olBtLeg:align:= CONTROL_ALIGN_LEFT  	
	// Filtro
	olBtFiltro := TButton():New(nlTl1+203,alSize[2]+176,"&Filtrar",oPanelBottom, {|| FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam, @clFilBrw),;
																			   	(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
																			   	(olLBox:Refresh()),(olLBox:bGoTop),;
																			   	(IIf(!Empty(olLBox:aArray),AtuBtn(IF(SDS->(FieldPos("DS_VALMERC")) > 0,olLBox:aArray[olLBox:nAt,2],olLBox:aArray[olLBox:nAt,1])),)),;
	 																			olLBox:Refresh() } ,035,014,,,,.T.)   //Filtro
	olBtFiltro:align:= CONTROL_ALIGN_LEFT
	// ImportaÃ§Ã£o manual	
	olBtImpM := TButton():New(nlTl1+203,alSize[2]+221,"&Importar XML",oPanelBottom, {|| ImpXML(),(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
																							(olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)),;
																							(olLBox:Refresh()),(olLBox:bGoTop),;
																							(IIf(!Empty(olLBox:aArray),AtuBtn(IF(SDS->(FieldPos("DS_VALMERC")) > 0,olLBox:aArray[olLBox:nAt,2],olLBox:aArray[olLBox:nAt,1])),))} ,035,014,,,,.T.  ) // Remessa
	olBtImpM:align:= CONTROL_ALIGN_LEFT    
   	// Excluir																				
   	olBtExc := TButton():New(nlTl1+203,alSize[2]+256,"&Excluir",oPanelBottom,{|| ExecTela(5,; 							// | Opcao
																			alItBx[olLBox:nAt,nlPosCFor],;			// | Cod. Fornec./Cli.
																			alItBx[olLBox:nAt,nlPosLoja],;	  		// | Loja
																			alItBx[olLBox:nAt,nlPosNum],;	   		// | Num. Nota Fiscal
																			alItBx[olLBox:nAt,nlPosSer],,alItBx,nlPosCFor,nlPosLoja,nlPosNum,nlPosSer),;// |Serie
																		    olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam) };
																		  ,035,014,,,,.T.)											
	olBtExc:align:= CONTROL_ALIGN_LEFT																											  


	//Parâmetros
	olBtParam := TButton():New(nlTl1+203,alSize[2]+301,"&Parâmetros",oPanelBottom, {|| Pergunte(clPar,.T.) , (olLBox:=AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)) } ,035,014,,,,.T.  )   //Reprocessar
	olBtParam:align:= CONTROL_ALIGN_LEFT

   	// Atualiza SA5
   	olBtSa5 := TButton():New(nlTl1+203,alSize[2]+2876,"&At. Prod. x Forn.",oPanelBottom,{|| AtuSA5(olLBox,alItBx,clLine,alCpos,alParam) };
																		  ,050,014,,,,.T.)											
	olBtSa5:align:= CONTROL_ALIGN_LEFT																											  


	// Erros
	//olBtReproc := TButton():New(nlTl1+203,alSize[2]+301,"Reprocessar",_opDlgPcp, {|| AT140IRepr()} ,035,014,,,,.T.  )   //Reprocessar
    // Sair / Fechar
	//@ (nlTl1+203),(alSize[2]+346) 	BUTTON "Fechar" SIZE 35,14 OF oPanelBottom PIXEL ACTION Eval({|| DbSelectArea("SDS"), &cTCFilterEX.("",1), _opDlgPcp:END()})
	olBtFechar := TButton():New(nlTl1+203,alSize[2]+346,"&Sair",oPanelBottom, {|| DbSelectArea("SDS"), &cTCFilterEX.("",1), _opDlgPcp:END()} ,035,014,,,,.T.  )   //Reprocessar
	olBtFechar:align:= CONTROL_ALIGN_LEFT
	
    &cTCFilterEX.("",1)
    olLBox := TwBrowse():New(nlTl1+10,nlTl2+7,nlTl3-67,nlTl4-605,,alHdCps,alHdSize,oPanelTop,,,,,{|| IIf(!Empty(olLBox:aArray),Eval(opBtVis:BACTION),) } ,,,,,,,.F.,,.T.,,.F.,,,) 
   	olLBox := AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
	If Len(olLBox:aArray) >0
  		olLBox:BChange:= IIf(!Empty(olLBox:aArray), {|| AtuBtn(IF(SDS->(FieldPos("DS_VALMERC")) > 0,olLBox:aArray[olLBox:nAt,2],olLBox:aArray[olLBox:nAt,1]))} , {|| olLBox:Refresh()})
	ENdIf
	olLBox:Align := CONTROL_ALIGN_ALLCLIENT
	//"Marca/Desmarca"
	If Len(alItBx) > 0 .And. SDS->(FieldPos("DS_VALMERC")) > 0
		oTButMarDe := TButton():New(alSize[1]+11, 8,,oPanelBottom,{|| U_AT140IMarc(@alItBx,@olLBox)},8,10,,,.F.,.T.,.F.,,.F.,,,.F.)
		oTButMarDe:align:= CONTROL_ALIGN_LEFT
	EndIf
	
    ACTIVATE DIALOG _opDlgPcp CENTERED

Return NIL

Static Function MontHdr()
Local alHdRet := {}

aAdd(alHdRet,"DS_STATUS")
dbSelectArea("SX3")
DbSetOrder(1)
dbGoTop()
SX3->(DbSeek("SDS"))

While !EOF() .AND. SX3->X3_ARQUIVO == "SDS"    
	If (SX3->X3_BROWSE=="S") .AND. (cNivel>=SX3->X3_NIVEL) .AND. (!(ALLTRIM(SX3->X3_CAMPO) $ "DS_FILIAL/DS_STATUS/DS_TIPO"))
		Aadd(alHdRet,SX3->X3_CAMPO)
	EndIf
	DbSkip()
EndDo  
	
Return alHdRet

Static Function AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)
Local oOK 	 := LoadBitmap(GetResources(),'LBOK')
Local oNO 	 := LoadBitmap(GetResources(),'LBNO')
       	
alItBx:=CarItens(alCpos, alParam)
olLBox:SetArray(alItBx)
olLBox:bLine := IIf(!Empty(alItBx),&clLine, {|| Array(Len(alCpos))})
// Marca a coluna no duplo click do mouse
If SDS->(FieldPos("DS_VALMERC")) > 0
	If !Empty(olLBox:aArray)
		olLBox:bLDblClick := {|| IF(alItBx[olLBox:nAt][2] <> "P", alItBx[olLBox:nAt][1] := !alItBx[olLBox:nAt][1],HELP("  ",1,"EXISTNF")), olLBox:DrawSelect()}
		olLBox:Refresh()
	Else
			olLBox:bLDblClick :={|| IIF(!EMPTY(OLLBOX:AARRAY),EVAL(OPBTVIS:BACTION),) }
	Endif	
EndIf
	    
If Empty(olLBox:aArray)
	opBtPed:Disable()
	opBtImp:Disable()
	olBtExc:Disable()
	opBtVis:Disable()
Else
	opBtPed:Enable()
	opBtImp:Enable()
	olBtExc:Enable()  
	opBtVis:Enable()
EndIf
Return olLBox

Static Function CarItens(alHdr,alParam)
            
Local alRet     := {}  
Local cArqInd   := ""	 
Local cChaveInd := ""
Local cQuery	:= ""
Local nlK       := 0    
Local nIndice	:= 0

Pergunte("MTA140I",.F.)
dbSelectArea("SDS")
dbSetOrder(1)

cArqInd   := CriaTrab(, .F.)
cChaveInd := IndexKey()		
cQuery := 'DS_FILIAL ="'+xFilial("SDS")+'" .And.'
cQuery += 'DS_DOC    >="'+mv_par01+'".And.DS_DOC   <="'+mv_par02+'".And.'
cQuery += 'DS_SERIE  >="'+mv_par03+'".And.DS_SERIE <="'+mv_par04+'".And.'
cQuery += 'DS_FORNEC >="'+mv_par05+'".And.DS_FORNEC <="'+mv_par06+'".And.'
cQuery += 'DS_STATUS <>"'+IIf(mv_par11 == 2,"P","Z")+'"'
cQuery += " .And. DToS(DS_EMISSA)>='"  +DToS(MV_PAR07)+"' .And. DTos(DS_EMISSA)<='"  +DTos(MV_PAR08)+"'"
cQuery += " .And. DToS(DS_DATAIMP)>='"  +DToS(MV_PAR09)+"' .And. DTos(DS_DATAIMP)<='"  +DTos(MV_PAR10)+"'"
cQuery += " .And. DS_TIPO != 'T' "
	
IndRegua("SDS", cArqInd, cChaveInd, , cQuery, "Criando indice de trabalho" ) 

nIndice := RetIndex("SDS") + 1
#IFNDEF TOP
	dbSetIndex(cArqInd + OrdBagExt())
#ENDIF
dbSetOrder(nIndice)
SDS->(MsSeek(xFilial("SDS")))

While SDS->(!EOF())
    AADD(alRet,Array(Len(alHdr)+1))
    For nlk:=1 to Len(alHdr)
    	If IsHeadRec(alHdr[nlk][2])
			alRet[Len(alRet),nlk] := SDS->(Recno())
		ElseIf IsHeadAlias(alHdr[nlk][2])
			alRet[Len(alRet),nlk] := "SDS"
    	ElseIf alHdr[nlk,4]=="V" 
    		alRet[Len(alRet),nlk]:=CriaVar(alHdr[nlk,2]) 	
    	ElseIf Alltrim(alHdr[nlk,2]) == "DS_CNPJ"
			alRet[Len(alRet),nlk] := Transform(FieldGet(FieldPos(alHdr[nlk,2])),"@R 99.999.999/9999-99")
    	ElseIf alHdr[nlk,2] == "DS_OK"
    		alRet[Len(alRet),nlk] := .F.
    	Else
    		alRet[Len(alRet),nlk] := FieldGet(FieldPos(alHdr[nlk,2]))
    	EndIf    
    Next nlk 
	SDS->(dbSKip())
End

SDS->(DbClearFil())
RetIndex("SDS")
Return alRet

Static Function FiltraBrw(olLBox,alItBx,clLine,alCpos,alParam,clFilBrw )               
Local cTCFilterEX 	:= "TCFilterEX"	
Local aArea			:= GetArea()
clFilBrw := BuildExpr("SDS",,clFilBrw)
    
DbSelectArea("SDS")
&cTCFilterEX.(clFilBrw,1)
    
AtuBrw(olLBox,alItBx,clLine,alCpos,alParam)	

RestArea(aArea)
Return Nil

Static Function ExecTela(nlOpc,clCodFor,clLoja,clNota,clSerie,olLBox,aColsGrid,nlPosCFor,nlPosLoja,nlPosNum,nlPosSer)
	Local nY			:= 0 
	Local nlUsado       := 0
	Local alDTVirt      := {}
	Local alDTVisu      := {}                             
	Local alRecDT       := {}   
	Local alSF1         := {}
	Local alSD1         := {}         
	Local alSize        := MsAdvSize(.T.)
	Local aErro			:= {}
	Local clKey         := ""
	Local clTab1	    := "SDS"  
	Local clTab2	    := "SDT"    
	Local clAwysT       := "AllwaysTrue"
	Local alCpoEnch     := {}  
	Local alHeaderDT    := {}  
	Local llPedCom      := .F.
	Local llD1Imp       := .F.
	Local lProcNFe		:= .F.
	Local aNotFields    := {"DT_FILIAL","DT_VALFRE","DT_SEGURO","DT_DESPESA"}
	Local cErroExAut    := ""
	Local lProc			:= .F.
	Local nX			:= 0
	Local aAreaSF1		:= SF1->(GetArea())
	
	Local nI		 	:= 0
	Local aSerAltern	:= {}
	Local cSerAltern	:= ""
	Local cTamSerie 	:= TamSX3("F1_SERIE")[1]
		
	Default aColsGrid   := {}
	Default nlPosCFor	:= 0
	Default nlPosLoja	:= 0
	Default nlPosNum	:= 0
	Default nlPosSer	:= 0
	
	Private lMsErroAuto := .F.
	Private aCols 	    := {}
	Private aHeader     := GdMontaHeader(	@nlUsado     	 ,; //01 -> Por Referencia contera o numero de campos em Uso
  									@alDTVirt                ,; //02 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Virtuais
  									@alDTVisu                ,; //03 -> Por Referencia contera os Campos do Cabecalho da GetDados que sao Visuais
  									clTab2                   ,; //04 -> Opcional, Alias do Arquivo Para Montagem do aHeader
  									{"DT_FILIAL"} 			 ,; //05 -> Opcional, Campos que nao Deverao constar no aHeader
  									.F.                      ,; //06 -> Opcional, Carregar Todos os Campos
  									.F.                      ,; //07 -> Nao Carrega os Campos Virtuais
  									.F.                      ,; //08 -> Carregar Coluna Fantasma e/ou BitMap ( Logico ou Array )
  									NIL                      ,; //09 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
  									.T.                      ,; //10 -> Verifica se Deve Checar se o campo eh usado  
  									.T.                      ,;
  									.F.                      ,;
  									.F.                      ,;
  									)       
	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	//Â³ Somente monta a tela se nao estiver gerando o docto.Â³
	//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	If (nlOpc <> 3 .And. nlOpc <> 5) .Or. !SDS->(FieldPos("DS_VALMERC")) > 0
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ Adiciona os campos de Alias e Recno ao aHeader para WalkThru.Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
		ADHeadRec("SDT",aHeader)
		
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ POSICIONA A TABELA SDS / CARREGA VARIAVEIS DE MEMORIA   Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
		dbSelectArea(clTab1)
		dbSetOrder(1)
		&(clTab1+"->(dbGoTop())")
		dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
	 	RegToMemory("SDS",.F.)	
	    
	    //ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ CAMPOS USADOS PARA ENCHOICE   Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
	    dbSelectArea("SX3") 
	    SX3->(dbSetOrder(1))
	    SX3->(dbGoTop())
		SX3->(dbSeek("SDS"))
		alCpoEnch:={}
		Do While !Eof().And.(SX3->X3_ARQUIVO=="SDS")     
			If X3USO(SX3->X3_USADO) .And. cNivel>=SX3->X3_NIVEL 
				If !AllTrim(SX3->X3_CAMPO)$ "DS_TRANSP#DS_PLACA#DS_PLIQUI#DS_PBRUTO#DS_ESPECI1#DS_ESPECI2#DS_ESPECI3#DS_ESPECI4#DS_VOLUME1#DS_VOLUME2#DS_VOLUME3#DS_VOLUME4#DS_TPFRETE#DS_FRETE#DS_SEGURO#DS_DESCONT#DS_DESPESA#DS_VALMERC" .And.;
					AllTrim(SX3->X3_CAMPO) <> "DS_DOCLOG"
					aAdd(alCpoEnch,ALLTRIM(X3_CAMPO))
				EndIf
			Endif
			DbSkip()                              
		EndDo               
	
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ MONTA ACOLS   Â³  
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™  
		dbSelectArea("SDT")
		SDT->(dbSetOrder(1))
		SDT->(dbGoTop())
		alRecDT := {}	
		alHeaderDT:=aClone(aHeader) 
		clKey := xFilial("SDS")+M->DS_CNPJ+clCodFor+clLoja+clNota+clSerie
		aCols := GdMontaCols(	@alHeaderDT		,; 	//01 -> Array com os Campos do Cabecalho da GetDados
			  	   				@nlUsado		,;	//02 -> Numero de Campos em Uso
			  	 				@alDTVirt		,;	//03 -> [@]Array com os Campos Virtuais
						  		@alDTVisu   	,;	//04 -> [@]Array com os Campos Visuais
				           		clTab2			,;	//05 -> Opcional, Alias do Arquivo Carga dos Itens do aCols
						  		{"DS_TIPO"}		,;	//06 -> Opcional, Campos que nao Deverao constar no aHeader
						  		@alRecDT		,;	//07 -> [@]Array unidimensional contendo os Recnos
						  		clTab1			,;	//08 -> Alias do Arquivo Pai
						  		clKey  			,;	//09 -> Chave para o Posicionamento no Alias Filho
				 			  	NIL				,;	//10 -> Bloco para condicao de Loop While
				 				NIL				,;	//11 -> Bloco para Skip no Loop While
				 				.F.				,;	//12 -> Se Havera o Elemento de Delecao no aCols
				 				.F.				,;	//13 -> Se cria variaveis Publicas
				 				.T.				,;	//14 -> Se Sera considerado o Inicializador Padrao
				 				NIL				,;	//15 -> Lado para o inicializador padrao
				 				NIL				,;	//16 -> Opcional, Carregar Todos os Campos
				 				.F.				,;	//17 -> Opcional, Nao Carregar os Campos Virtuais
				 				NIL				,;	//18 -> Opcional, Utilizacao de Query para Selecao de Dados
								NIL				,;	//19 -> Opcional, Se deve Executar bKey  ( Apenas Quando TOP )
				 				NIL				,;	//20 -> Opcional, Se deve Executar bSkip ( Apenas Quando TOP )
				 				.F.				,;	//21 -> Carregar Coluna Fantasma
								NIL				,;	//22 -> Inverte a Condicao de aNotFields carregando apenas os campos ai definidos
								.T.				,;	//23 -> Verifica se Deve Checar se o campo eh usado
								.T.				,;	//24 -> Verifica se Deve Checar o nivel do usuario
								NIL				,;	//25 -> Verifica se Deve Carregar o Elemento Vazio no aCols
								NIL				,;	//26 -> [@]Array que contera as chaves conforme recnos
								NIL				,;	//27 -> [@]Se devera efetuar o Lock dos Registros
								NIL				,;	//28 -> [@]Se devera obter a Exclusividade nas chaves dos registros
						        NIL				,;	//29 -> Numero maximo de Locks a ser efetuado
								.F.				,;	//30 -> Utiliza Numeracao na GhostCol				 				
							 	NIL				,;	//31
								4		    	 ;	//32 -> nOpc
							  	)
							  	
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ Caso tenha ocorrido erro durante a geracao da pre-nota ou doc. entrada.   Â³
		//Â³Verifica se eh nota de dev ou compl. preco    							  Â³  
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™  		
		If M->DS_STATUS == "E" .And. nlOpc == 4
			nlOpc := If(M->DS_TIPO $ "DC",6,4)
		EndIf 
	Else
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ Verifica se foi marcado pelo menos um documento   Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
		For nX := 1 To Len(aColsGrid)
			If (aColsGrid[nX][1])
				lProcNfe := .T.
				Exit
			EndIf
		Next nX	
		IF !lProcNfe
			If nlOpc == 3
				MsgStop("Nao ha documento(s) selecionado(s) para geração de documentos.")				
			ElseIf nlOpc == 5
				MsgStop("Nao ha documento(s) selecionado(s) para exclusão.")
			EndIf
		EndIf
	EndIf					  	
	
	If SDS->(FieldPos("DS_VALMERC")) >0
	   	If lProcNfe .And. nlOpc == 3
			//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
			//Â³ GERA A PRE-NOTA   Â³
			//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
			If MsgYesNo("Confirma a geração de Pré-Nota ou Documento de Entrada registros selecionados?","Aviso")    //"Confirma a geraÃ§Ã£o de PrÃ©-Nota ou Documento de Entrada (o segundo nos casos de BonificaÃ§Ã£o ou Complemento de PreÃ§o) para os documentos selecionados?"
				Begin Transaction            
				_cTpNFRot	:= ""
				_cTESNFRot	:= ""
				_cOPERNFRot	:= ""
				
				For nX := 1 To Len(aColsGrid)
					If (aColsGrid[nX][1])			   		
				   		SDS->(dbSetOrder(1))
						If SDS->(DbSeek(xFilial("SDS")+aColsGrid[nX][nlPosNum]+aColsGrid[nX][nlPosSer]+aColsGrid[nX][nlPosCFor]+aColsGrid[nX][nlPosLoja])) .And.;
							SDS->DS_STATUS <> "P"
							alSF1:=F1Imp(aColsGrid[nX][nlPosCFor],aColsGrid[nX][nlPosLoja],aColsGrid[nX][nlPosNum],aColsGrid[nX][nlPosSer],"SDS")
							MsgRun("Aguarde... Selecionando registros...",,{|| IIF(!Empty(alSD1:=D1Imp(aColsGrid[nX][nlPosCFor],aColsGrid[nX][nlPosLoja],aColsGrid[nX][nlPosNum],aColsGrid[nX][nlPosSer])),llD1Imp:=.T.,llD1Imp:=.F.)})
							If GerNf(@alSF1,@alSD1)
								If llD1Imp
									lMSErroAuto	:= .F.
									lAutoErrNoFile := .T.
									If SDS->DS_TIPO $ "OC" .or. _cTpNFRot == "N"
										MsgRun("Aguarde... Gerando nota fiscal de entrada...",,{|| MSExecAuto({|x,y,z| MATA103(x,y,z)},alSF1,alSD1,3)})
									Else
										MsgRun("Aguarde... Gerando Pré-nota fiscal de entrada...",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)},alSF1,alSD1,3)})
								   	EndIf
								   	lProcNFe := IIF((!lMsErroAuto .And. !lProcNFe),.T.,.F.)
								   	//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
									//Â³ APOS EXECUTADA A ROTINA AUTOMATICA                 Â³
									//Â³ ATUALIZA REGISTRO ( STATUS, DATA IMPORTACAO ...)   Â³
									//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
								   	dbSelectArea("SDS")
								   	dbSetOrder(1)
								   	If !lMsErroAuto
									   	lProcNFe := .T.
									   	If dbSeek(xFilial("SDS")+aColsGrid[nX][nlPosNum]+aColsGrid[nX][nlPosSer]+aColsGrid[nX][nlPosCFor]+aColsGrid[nX][nlPosLoja])
									   		RecLock("SDS",.F.)
									   		Replace DS_USERPRE  With cUserName
									   		Replace DS_DATAPRE  With dDataBase
									   		Replace DS_HORAPRE  With Time()
									   		Replace DS_STATUS   With 'P' // P = PROCESSADA PELO PROTHEUS    
									   		Replace DS_DOCLOG 	With '' 
									   		MsUnLock()
									   	EndIf		   	
									Else
										cErroExAut := ""
										aErro := GetAutoGRLog()
										For nY := 1 To Len(aErro)
											cErroExAut += aErro[nY] +CRLF
										Next nY
										If dbSeek(xFilial("SDS")+aColsGrid[nX][nlPosNum]+aColsGrid[nX][nlPosSer]+aColsGrid[nX][nlPosCFor]+aColsGrid[nX][nlPosLoja])
											RecLock("SDS",.F.)
											Replace DS_DOCLOG With cErroExAut
											Replace DS_STATUS With 'E'
											MsUnlock()
										EndIf
									EndIf
								EndIf
							Else   
								llD1Imp := .F.
							    Exit
							EndIf
						EndIf									   	
					EndIf
				Next nX
				If lProcNFe .And. llD1Imp
					Aviso("Aviso", "Pré-Nota gerada com SUCESSO." ,{"OK"})
				EndIf
				End Transaction
			EndIf
		ElseIf lProcNfe .And. nlOpc == 5
			If MsgYesNo("Confirma a exclusão de todos os documentos selecionados?","Aviso") 
				For nX := 1 To Len(aColsGrid)
					If (aColsGrid[nX][1])				   		
				   		SDS->(dbSetOrder(1))
						If SDS->(DbSeek(xFilial("SDS")+aColsGrid[nX][nlPosNum]+aColsGrid[nX][nlPosSer]+aColsGrid[nX][nlPosCFor]+aColsGrid[nX][nlPosLoja])) .And.;
							SDS->DS_STATUS <> "P"
							SDT->(DbSetOrder(1))
							If SDT->(DbSeek(xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
								Do While SDT->(!EOF()) .And. SDT->(DT_FILIAL+DT_CNPJ+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
									SDT->(RecLock("SDT",.F.))
									SDT->(DbDelete())
									SDT->(dbSkip())
								EndDo
							EndIf
							SDS->(FKCommit())
							SDS->(RecLock("SDS",.F.))
							SDS->(DbDelete())
						EndIf
					EndIf
				Next nX
			EndIf
		ElseIf (nlOpc == 2 .Or. nlOpc == 4 .Or. nlOpc == 6)
			//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
			//Â³ MONTA TELA MODELO 3   Â³
			//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
			Mod3XML(nlOpc,;               								  			// 01 -> Opcao 
					"NF-e - " + If((nlOpc == 4 .Or. nlOpc == 6),"Selec. &Pedido","&Visualizar"),; // 02 -> Titulo da Tela 
					clTab1,;                  						  		  		// 03 -> Tabela para Enchoice 
					clTab2,;               									 		// 04 -> Tabela para GetDados
					alCpoEnch,;                 							  		// 05 -> Campos Enchoice
					clAwysT,;                 								  		// 06 -> CampoOk
					clAwysT,;                  								 		// 07 -> LinhaOk
					nlOpc,;                 										// 08 -> Opcao Enchoice
					nlOpc,;                  										// 09 -> Opcao GetDados
					U_A140ITudOk(),;             										// 10 -> TdOk
					.T.,;                  											// 11 -> Se carrega Campos Virtuais
					alCpoEnch,;                  									// 12 -> Campos alterar
					GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1),;   			// 13 -> Array com as informacoes do Radape
					{clCodFor,clLoja,clNota,clSerie,SDS->DS_TIPO})   				// 14 -> Campos da Nota	
		EndIf
	Else
		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
		//Â³ MONTA TELA MODELO 3   Â³
		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
		If Mod3XML(nlOpc,;               								  			// 01 -> Opcao 
				"NF-e - " + If((nlOpc == 4 .Or. nlOpc == 6),"Selec. &Pedido",If(nlOpc == 3, "&Gerar nota",If(nlOpc == 2, "&Visualizar","&Excluir"))),; // 02 -> Titulo da Tela 
				clTab1,;                  						  		  		// 03 -> Tabela para Enchoice 
				clTab2,;               									 		// 04 -> Tabela para GetDados
				alCpoEnch,;                 							  		// 05 -> Campos Enchoice
				clAwysT,;                 								  		// 06 -> CampoOk
				clAwysT,;                  								 		// 07 -> LinhaOk
				nlOpc,;                 										// 08 -> Opcao Enchoice
				nlOpc,;                  										// 09 -> Opcao GetDados
				U_A140ITudOk(),;             										// 10 -> TdOk
				.T.,;                  											// 11 -> Se carrega Campos Virtuais
				alCpoEnch,;                  									// 12 -> Campos alterar
				GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1),;   			// 13 -> Array com as informacoes do Radape
				{clCodFor,clLoja,clNota,clSerie,SDS->DS_TIPO})   				// 14 -> Campos da Nota	
			//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	   		//Â³ ALIMENTA VETORES PARA A ROTINA AUTOMATICA (MSExecAuto)   Â³
	   		//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™  
		   	alSF1:=F1Imp(clCodFor,clLoja,clNota,clSerie,clTab1)
			MsgRun("Aguarde... Selecionando registros...",,{|| IIF(!Empty(alSD1:=D1Imp(clCodFor,clLoja,clNota,clSerie,SDS->DS_STATUS)),llD1Imp:=.T.,llD1Imp:=.F. )})
			If llD1Imp
				// Verifica se existe NF na base com mesmo nÃºmero e sÃ©rie
				DbSelectArea("SF1")
				DbSetOrder(1)
				If MsSeek(xFilial("SF1")+clNota+clSerie+clCodFor+clLoja)
					Help(" ",1,"EXISTNF")
					llD1Imp := .F.
				EndIf
			EndIf 
	
			//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
			//Â³ GERA A PRE-NOTA   Â³
			//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
			If llD1Imp
				Begin Transaction            
	
					lMsErroAuto := .F.
					If SDS->DS_STATUS == "O" .And. MsgYesNo("Deseja Continuar","Aviso")
						lProcNFe := .T.
						MsgRun("Aguarde... Gerando nota fiscal de entrada...",,{|| MSExecAuto({|x,y,z| MATA103(x,y,z)},alSF1,alSD1,3 )})
					ElseIf SDS->DS_STATUS # "O"
						lProcNFe := .T.
				   		MsgRun("Aguarde... Gerando Pré-nota fiscal de entrada...",,{|| MSExecAuto({|x,y,z| MATA140(x,y,z)},alSF1,alSD1,3 )})    
				   	EndIf
				   	
				   	If !lMsErroAuto .And. lProcNFe
				   		//ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
						//Â³ APOS EXECUTADA A ROTINA AUTOMATICA                 Â³
						//Â³ ATUALIZA REGISTRO ( STATUS, DATA IMPORTACAO ...)   Â³
						//Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
					   	dbSelectArea(clTab1)
					   	dbSetOrder(1)
					   	&(clTab1)->(dbGoTop())
					   	If dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja)
					   		If RecLock(clTab1,.F.)
					   			Replace DS_USERPRE  With cUserName
					   			Replace DS_DATAPRE  With dDataBase
					   			Replace DS_HORAPRE  With Time()
					   			Replace DS_STATUS   With 'P' // P = PROCESSADA PELO PROTHEUS
					   			&(clTab1)->(MsUnLock())
					   	  		Aviso("Aviso", "Pré-Nota gerada com SUCESSO." ,{"OK"})
					   		EndIf
					   	EndIf		   	
					ElseIf lProcNFe
						DisarmTransaction()
						lMsErroAuto := .F.
						MostraErro()
					EndIf
				End Transaction
			EndIf
		EndIf
	EndIf
RestArea(aAreaSF1)

Return Nil

Static Function ImpXml()
Local cPathR	:= ""
Local cFile		:= ""
Local cXML		:= ""
Local nHandle	:= 0
Local nLength	:= 0
Local aParam	:= {}
Local nSel		:= 0
Local aProc		:= {}
Local aErros	:= {}

cQuery := "Select R_E_C_N_O_ AS NREG From "+RetSqlName("ZZS")
cQuery += " Where D_E_L_E_T_ = '' AND "
cQuery += "  ZZS_FILIAL = '" + xFilial("ZZS") + "' AND "
cQuery += "  ZZS_ESPECI <> 'CTE' "
cQuery += " AND  ZZS_STATUS <> '6' " // Gerado // ('0','1','5')"
//cQuery += " AND   ZZS_CGC = '20147617002276'"
//35120642934489000208570020000344371008144330-cte
cQuery := ChangeQuery( cQuery )
xx:= "1"
If Select("TRB1") > 0
	TRB1->(DbCloseArea())
EndIf

dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "TRB1", .T., .T. )
xx:= "1"
DbSelectArea("TRB1")
If ! TRB1->(Eof())
	TRB1->(DbGoTop())
	While ! TRB1->(Eof())
		n_Reg := TRB1->NREG
		DbSelectArea("ZZS")
		DbGoTo(n_Reg)
		cXMLFile   := ZZS->ZZS_XML
		cFile      := ZZS->ZZS_CHAVE
		l_Retorno := ImpXML_NFe(cXMLFile,cFile) // (cFile,.F.,@aProc,@aErros,nil,nil,nil,cXml,{})
		
		DbSelectArea("ZZS")
		DbGoTo(n_Reg)
		If l_Retorno
			RecLock("ZZS",.F.)
			ZZS->ZZS_STATUS := "6"
			MsUnlock()
		Else
			RecLock("ZZS",.F.)
			ZZS->ZZS_STATUS := "3"
			MsUnlock()
		EndIf
		TRB1->(DbSkip())
	EndDO
EndIf
/*
If !ExistDir(DIRXML)
MakeDir(DIRXML)
MakeDir(DIRXML +DIRALER)
MakeDir(DIRXML +DIRLIDO)
MakeDir(DIRXML +DIRERRO)
EndIf

If ParamBox( { { 3 ,"Selecione o Tipo NF" ,1 ,{"NF-e","NFS-e","NF Comp.","CT-e Embarcador"}	 ,50  ,".T."    ,.T. ,".T." } }, "Parãmetros" ,@aParam )

nSel	:= aParam[1]
cPathR	:= cGetFile("*.xml","XML File",1,"C:\",.T.,GETF_LOCALHARD,.F.,.T.)
cFile	:= cPathR

If !Empty(cPathR) .and. File(cPathR)
While At("\",cFile) > 0
cFile := Substr(cFile,At("\",cFile)+1)
End
//Prepara o arquivo XML
nHandle := FOpen(cPathR)
nLength := FSeek(nHandle,0,FS_END)
FSeek(nHandle,0)
If nHandle > 0
FRead(nHandle, cXML, nLength)
FClose(nHandle)
EndIf

Copy File &(cPathR) To &(DIRXML+DIRALER+cFile)

If File(DIRXML+DIRALER+cFile)
If nSel == 1
ImpXML_NFe(cFile,.F.,@aProc,@aErros,nil,nil,nil,cXml,{})
ElseIf nSel == 2
ImpXML_NFs(cFile,.F.,@aProc,@aErros)
ElseIf nSel == 3
ImpXML_Ave(cFile,.F.,@aProc,@aErros)
ElseIf nSel == 4
ImpXML_Cte(cFile,.F.,@aProc,@aErros)
Endif
Else
MsgStop("Não Foi possível Copiar Arquivo para Servidor")
EndIF
Else
MsgStop("Path local não é válido")
EndIf

EndIf
*/
Return( Nil )

Static Function F1Imp(clCodFor,clLoja,clNota,clSerie,clTab)
Local alCabec	 := {} 
Local cCondPagto := "" 
Local aAreaSDS 	 := SDS->(GetArea())

dbSelectArea(clTab)
dbSetOrder(1)
&(clTab)->(dbGoTop())    
If dbSeek(xFilial(clTab)+clNota+clSerie+clCodFor+clLoja)   
	aAdd(alCabec,{"F1_FILIAL"      ,SDS->DS_FILIAL         ,Nil})
	aAdd(alCabec,{"F1_TIPO"        ,IIF(SDS->DS_TIPO=="O","N",SDS->DS_TIPO),Nil})
	aAdd(alCabec,{"F1_FORMUL"      ,SDS->DS_FORMUL         ,Nil})
	aAdd(alCabec,{"F1_DOC"         ,SDS->DS_DOC            ,Nil})
	aAdd(alCabec,{"F1_SERIE"       ,SDS->DS_SERIE          ,Nil})
	aAdd(alCabec,{"F1_EMISSAO"     ,SDS->DS_EMISSA		 	,Nil})	
	aAdd(alCabec,{"F1_FORNECE"     ,SDS->DS_FORNEC         ,Nil})
	aAdd(alCabec,{"F1_LOJA"        ,SDS->DS_LOJA           ,Nil})
	aAdd(alCabec,{"F1_ESPECIE"     ,SDS->DS_ESPECI         ,Nil})
	aAdd(alCabec,{"F1_DTDIGIT"     ,SDS->DS_DATAIMP			,Nil})
	aAdd(alCabec,{"F1_EST"         ,SDS->DS_EST				,Nil})
	aAdd(alCabec,{"F1_HORA"        ,SubStr(Time(),1,5)		,Nil})   
	aAdd(alCabec,{"F1_CHVNFE"      ,SDS->DS_CHAVENF			,Nil})
	If SDS->(FieldPos("DS_VALMERC")) > 0 
		aAdd(alCabec,{"F1_VALMERC"     ,SDS->DS_VALMERC		 	,Nil})	
		aAdd(alCabec,{"F1_FRETE"       ,SDS->DS_FRETE          ,Nil})
		aAdd(alCabec,{"F1_DESPESA"     ,SDS->DS_DESPESA		    ,Nil})
		aAdd(alCabec,{"F1_DESCONT"     ,SDS->DS_DESCONT		 	,Nil})
		aAdd(alCabec,{"F1_SEGURO"      ,SDS->DS_SEGURO			,Nil})
		aAdd(alCabec,{"F1_VALBRUT"     ,SDS->(DS_VALMERC-DS_DESCONT+DS_SEGURO+DS_DESPESA+DS_FRETE),Nil})	
	EndIf
	If SDS->(FieldPos("DS_TRANSP")) > 0 .And. !SDS->DS_TIPO $ "CO"
		aAdd(alCabec,{"F1_TRANSP"      ,SDS->DS_TRANSP		 	,Nil})		
		aAdd(alCabec,{"F1_PLACA"       ,SDS->DS_PLACA		 	,Nil})	
		aAdd(alCabec,{"F1_PLIQUI"      ,SDS->DS_PLIQUI		 	,Nil})
		aAdd(alCabec,{"F1_PBRUTO"      ,SDS->DS_PBRUTO		 	,Nil})
		aAdd(alCabec,{"F1_ESPECI1"     ,SDS->DS_ESPECI1	 		,Nil})		
		aAdd(alCabec,{"F1_VOLUME1"     ,SDS->DS_VOLUME1	 		,Nil})
		aAdd(alCabec,{"F1_ESPECI2"     ,SDS->DS_ESPECI2	 		,Nil})
		aAdd(alCabec,{"F1_VOLUME2"     ,SDS->DS_VOLUME2	 		,Nil})
		aAdd(alCabec,{"F1_ESPECI3"     ,SDS->DS_ESPECI3	 		,Nil})
		aAdd(alCabec,{"F1_VOLUME3"     ,SDS->DS_VOLUME3	 		,Nil})
		aAdd(alCabec,{"F1_ESPECI4"     ,SDS->DS_ESPECI4	 		,Nil})
		aAdd(alCabec,{"F1_VOLUME4"     ,SDS->DS_VOLUME4	 		,Nil})
		aAdd(alCabec,{"F1_TPFRETE"     ,SDS->DS_TPFRETE		 	,Nil})
	EndIf
							
	If SDS->(FieldPos("DS_VALMERC")) > 0 .And. SDS->DS_TIPO == "C"
		//-- Ponto de entrada para cutomizacao da condicao de pagamento
			SDT->(dbSetOrder(2))
			If SDT->(dbSeek(xFilial("SF1")+	SDS->(DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
				SF1->(dbSetOrder(1))
				If SF1->(dbSeek(xFilial("SF1")+SDT->(DT_NFORI+DT_SERIORI+DT_FORNEC+DT_LOJA)))
					cCondPagto := AllTrim(SF1->F1_COND)
				EndIf
			EndIf
		aAdd(alCabec,{"F1_COND", cCondPagto, Nil})
	EndIf
EndIf  

If clTab <> "SDS"
	&(clTab)->(dbCloseArea())
EndIf

//-- Flag colab para tratamentos especificos
aAdd(alCabec,{"COLAB","S",NIL})

RestArea(aAreaSDS)
Return alCabec

Static Function D1Imp(clCodFor,clLoja,clNota,clSerie)
Local aAreaSDS	 := SDS->(GetArea())
Local aArea		 := GetArea()
Local alItens	 := {} 
Local alRet      := {}   
Local clStatNF	 := ""
Local lPCNFE	 := (SuperGetMv("MV_PCNFE",.F.,.F.) == .T.)
Local cTesPcNf	 := SuperGetMv("MV_TESPCNF",.F.,"")

// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
// Â³ Busca o tipo da NF 	  Â³
// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
SDS->(dbSetOrder(1))
If SDS->(dbSeek(xFilial("SDS")+clNota+clSerie+clCodFor+clLoja))
	clStatNF := SDS->DS_TIPO
EndIf

SDT->(dbSetOrder(2)	)
SDT->(dbGoTop())
If SDT->(dbSeek(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie))
	While SDT->(!EOF()) .AND. SDT->(DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDT")+clCodFor+clLoja+clNota+clSerie
		alItens:={}
		aAdd(alItens,{"D1_ITEM", SDT->DT_ITEM ,NIL})
		aAdd(alItens,{"D1_COD" ,  SDT->DT_COD ,NIL})
		If clStatNF == "C" .And. SDT->(FieldPos("DT_NFORI")) > 0
			aAdd(alItens,{"D1_VUNIT", SDT->DT_VUNIT, NIL})
			aAdd(alItens,{"D1_TOTAL", SDT->DT_VUNIT	, NIL})
			SA5->(DbSetOrder(1))
			If SA5->(DbSeek(xFilial("SA5")+SDT->DT_FORNEC+SDT->DT_LOJA+SDT->DT_COD)) .And. SA5->(FieldPos("A5_TESCP")) > 0
				If Empty(SA5->A5_TESCP)
					If SDS->(FieldPos("DS_VALMERC")) > 0
						SDS->(RecLock("SDS",.F.))
						Replace SDS->DS_DOCLOG With "Doc. Entrada Compl. Preço! Será necessário cadastrar o Tp.Entr. para nota Compl. Preço na rotina de Produto x Fornecedor."
						Replace SDS->DS_STATUS With 'E'
						SDS->(MsUnlock())
					Else
						Aviso("Aviso","Doc. Entrada Compl. Preço! Será necessário cadastrar o Tp.Entr. para nota Compl. Preço na rotina de Produto x Fornecedor.",{"OK"},2)  //"Doc. Entrada Compl. PreÃ§o! SerÃ¡ necessÃ¡rio cadastrar o Tp.Entr. para nota Compl. PreÃ§o na rotina de Produto x Fornecedor."
					EndIf
					alRet := {}
					Exit
				Else
					aAdd(alItens,{"D1_TES", SA5->A5_TESCP, NIL})
				EndIf
			EndIf
			If Empty(SDT->DT_NFORI)
				If SDS->(FieldPos("DS_VALMERC")) > 0
					SDS->(RecLock("SDS",.F.))
					Replace SDS->DS_DOCLOG With "Por se tratar de uma Nota Fiscal de Compl. Preçoo, é obrigatório o vinculo da Nota Fiscal de Origem/Série. Para vincular o documento de origem utilize o botÃã Vinc. Docto, na sequÃência acione o botÃã NF Original na barra superior da tela." //
					Replace SDS->DS_STATUS With 'E'
					SDS->(MsUnlock())
				Else
					Aviso("Aviso","Por se tratar de uma Nota Fiscal de Compl. Preço, é obrigatório o vinculo da Nota Fiscal de Origem/Série. Para vincular o documento de origem utilize o botão Vinc. Docto, na sequÃêcia acione o botÃã NF Original na barra superior da tela.",{"OK"},2) 
				EndIf			
				alRet := {}
				Exit			
			EndIf
			If !Empty(SDT->DT_PEDIDO)
				aAdd(alItens,{"D1_PEDIDO", SDT->DT_PEDIDO, NIL})
				aAdd(alItens,{"D1_ITEMPC", SDT->DT_ITEMPC, NIL})
			EndIf
			aAdd(alItens,{"D1_NFORI", 	 SDT->DT_NFORI, 	 NIL})
			aAdd(alItens,{"D1_SERIORI",  SDT->DT_SERIORI, 	 NIL})
			aAdd(alItens,{"D1_ITEMORI",  SDT->DT_ITEMORI, 	 NIL})
			aAdd(alItens,{"D1_VALDESC",  SDT->DT_VALDESC,   NIL})			
			aAdd(alItens,{"D1_VALFRE", 	 SDT->DT_VALFRE,	 NIL})
			aAdd(alItens,{"D1_SEGURO", 	 SDT->DT_SEGURO,  	 NIL})			
			aAdd(alItens,{"D1_DESPESA",	 SDT->DT_DESPESA,  	 NIL})
		ElseIf clStatNF == "O"
			aAdd(alItens,{"D1_QUANT", SDT->DT_QUANT,		 NIL}) 
			aAdd(alItens,{"D1_VUNIT", SDT->DT_VUNIT,		 NIL})
			aAdd(alItens,{"D1_TOTAL", Round(SDT->DT_VUNIT * SDT->DT_QUANT,TamSX3("D1_TOTAL")[2]), NIL})
			SA5->(DbSetOrder(1))
			If SA5->(DbSeek(xFilial("SA5")+SDT->DT_FORNEC+SDT->DT_LOJA+SDT->DT_COD)) .And. SA5->(FieldPos("A5_TESBP")) > 0
				If Empty(SA5->A5_TESBP)
					If SDS->(FieldPos("DS_VALMERC")) > 0
						SDS->(RecLock("SDS",.F.))
						Replace SDS->DS_DOCLOG With "Doc. Entrada Bonificação! Será necessário cadastrar o Tp.Entr. para Bonificação na rotina de Produtos x Forncedores." 
						Replace SDS->DS_STATUS With 'E'
						SDS->(MsUnlock())
					Else
						Aviso("Aviso","Doc. Entrada Bonificação! Será necessário cadastrar o Tp.Entr. para Bonificação na rotina de Produtos x Forncedores.",{"OK"},2)  //"Doc. Entrada BonificaÃ§Ã£o! SerÃ¡ necessÃ¡rio cadastrar o Tp.Entr. para BonificaÃ§Ã£o na rotina de Produtos x Forncedores."
					EndIf
					alRet := {}
					Exit
				Else
					aAdd(alItens,{"D1_TES", SA5->A5_TESBP,  NIL})
				EndIf
			EndIf
			If !Empty(SDT->DT_PEDIDO)
				aAdd(alItens,{"D1_PEDIDO", SDT->DT_PEDIDO,	 NIL})
				aAdd(alItens,{"D1_ITEMPC", SDT->DT_ITEMPC,	 NIL})
			EndIf
			If SDS->(FieldPos("DS_VALMERC")) > 0
				aAdd(alItens,{"D1_VALDESC", SDT->DT_VALDESC,	 NIL})			
				aAdd(alItens,{"D1_VALFRE", SDT->DT_VALFRE,		 NIL})
				aAdd(alItens,{"D1_SEGURO", SDT->DT_SEGURO,		 NIL})
				aAdd(alItens,{"D1_DESPESA",	 SDT->DT_DESPESA,  	 NIL})
			EndIf
			// Verifica se a TES de bonificaÃ§Ã£o foi informada no caso de MV_PCNFE estar habilitado ou se o pedido de compras estÃ¡ preenchido
			If lPCNFE .And. !(SA5->A5_TESBP $ cTesPcNf) .And. Empty(SDT->DT_PEDIDO)				
				If SDS->(FieldPos("DS_VALMERC")) > 0
					SDS->(RecLock("SDS",.F.))
					Replace SDS->DS_DOCLOG With "Parâmetro MV_PCNFE habilitado! Vincule o Docto de Entrada à um Pedido de Compra." //
					Replace SDS->DS_STATUS With 'E'
					SDS->(MsUnlock())
				Else
					Aviso("Aviso","Parâmetro MV_PCNFE habilitado! Vincule o Docto de Entrada há um Pedido de Compra.",{"OK"},2)  //"ParÃ¢metro MV_PCNFE habilitado! Vincule o Docto de Entrada hÃ¡ um Pedido de Compra.
				EndIf
				alRet := {}
				Exit
			EndIf
		Else	
			If !Empty(SDT->DT_PEDIDO)
				aAdd(alItens,{"D1_PEDIDO", SDT->DT_PEDIDO,	 NIL})
				aAdd(alItens,{"D1_ITEMPC", SDT->DT_ITEMPC,	 NIL})
			EndIf
			aAdd(alItens,{"D1_QUANT", SDT->DT_QUANT,		 NIL})
			aAdd(alItens,{"D1_VUNIT", SDT->DT_VUNIT,		 NIL})
			aAdd(alItens,{"D1_TOTAL", Round(SDT->DT_VUNIT * SDT->DT_QUANT,TamSX3("D1_TOTAL")[2]),NIL})
			If SDS->(FieldPos("DS_VALMERC")) > 0
				If clStatNF == "D"	.And. SDT->(FieldPos("DT_NFORI")) > 0 .And. !Empty(SDT->DT_NFORI)
					aAdd(alItens,{"D1_NFORI", SDT->DT_NFORI,	 NIL})
					aAdd(alItens,{"D1_SERIORI", SDT->DT_SERIORI	,NIL})
					aAdd(alItens,{"D1_ITEMORI", SDT->DT_ITEMORI	,NIL})			
				EndIf			
				aAdd(alItens,{"D1_VALDESC", SDT->DT_VALDESC,	 NIL})
				aAdd(alItens,{"D1_VALFRE", SDT->DT_VALFRE,		 NIL})
				aAdd(alItens,{"D1_SEGURO", SDT->DT_SEGURO,		 NIL})
				aAdd(alItens,{"D1_DESPESA",	 SDT->DT_DESPESA,  	 NIL})
			EndIf
		EndIf		
   		aAdd(alRet,alItens)
   		SDT->(dbSkip())	
	EndDo
EndIf

RestArea(aAreaSDS)
RestArea(aArea)
Return alRet

Static Function Mod3XML(nlOpc,clTitle,clTab1,clTab2,alCpoEnch,clAwysT,clAwysT,nlOpc1,nlOpc2,lRet,llVirtual,alAltEnch,alInfRod,aCposNFe) 
	Local alAdvSz    := MsAdvSize(,.F.,400)
	Local alRNfe     := alInfRod
	Local olFld      := NIL
	Local lConfirma  := .F.  
	Local olFont     := TFont ():New(,,-11,.T.,.F.,5,.T.,5,.F.,.F.)
	Local olFont2    := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)   
	Local clPicture  := "@E 999,999,999.99"
	Local cChave     := ""
	Local olEnch     := NIL    
	Local olGetDd    := NIL  
	Local clGStatus  := IIf( Empty(Upper(alRNfe[1])),"Liberado para pre-nota","Processada")
	Local nPosDesc	 := 0 
	Local nPosProd	 := 0   
	Local cDescProd	 := ""
	Local aButtons	 := {}
	Local alItens    := {} 
	Local alCabec    := {"DT_ITEM","DT_COD","DT_PRODFOR","B1_DESC","DT_COD","DT_QUANT","DT_VUNIT","DT_TOTAL"}
	Local nLoop
	Local nLoops
	Local lPedDoc	:= .F.
	Local oPanelH
	Local cCombo	:= ""
	Local oCombo
	Local aCpos1   	:= {"DT_NFORI","DT_SERIORI","DT_ITEMORI","DT_COD","DT_PEDIDO","DT_ITEMPC","DT_QUANT","DT_VUNIT","DT_TOTAL"}
	Local aBackRot  := aClone(aRotina)
	Local aColsAnt := aClone(aCols)
	
	Private aTrocaF3  := {}        
	Private _opMoD3lg := NIL     
	Default aCposNFe  := {}
	                         
	DEFINE MSDIALOG _opMoD3lg FROM alAdvSz[7]+45,0 TO alAdvSz[6],alAdvSz[5] TITLE clTitle Of oMainWnd PIXEL
	
	oPanelH := tPanel():New(0,0,"",_opMoD3lg,,,,,,0,0)
	
	oPanelE := tPanel():New(0,0,"",oPanelH,,,,,,0,110)	
	oPanelF := tPanel():New(0,0,"",oPanelH,,,,,,0,80) 
	oPanelG := tPanel():New(0,0,"",oPanelH,,,,,,0,0)

	
	oPanelH:Align := CONTROL_ALIGN_ALLCLIENT
	
	oPanelE:Align := CONTROL_ALIGN_TOP
	oPanelF:Align := CONTROL_ALIGN_BOTTOM
	oPanelG:Align := CONTROL_ALIGN_ALLCLIENT
	
	If SDS->(FieldPos("DS_VALMERC")) > 0	
		olFld := TFolder():New(0,0,{"Dados da Importação","Dados da Geração","Nota Fiscal Eletrônica","Dados da Importação","Dados da Geração","Ocorrência"},{},oPanelF,,,,.T.,.F.,0,0) //"Dados da ImportaÃ§Ã£o"#"Dados da GeraÃ§Ã£o"#"OcorrÃªncia"
	Else
		olFld := TFolder():New(0,0,{"Nota Fiscal EletrÃ´nica","Dados da ImportaÃ§Ã£o","Dados da GeraÃ§Ã£o"},{},oPanelF,,,,.T.,.F.,0,0)
	EndIf		
	olFld:Align := CONTROL_ALIGN_ALLCLIENT
	
	// AJUSTA TELA PARA TEMA P10
  	If (Alltrim(GetTheme()) == "TEMAP10") .Or. SetMdiChild()
		_opMoD3lg:nHeight+=025
	EndIf
	
	// Muda Consulta padrao do cmapo DS_FORNEC para tabela de Clientes - SA1
  	IF AllTrim(SDS->DS_TIPO)<>"N"
  		Aadd(aTrocaF3,{"DS_FORNEC", "SA1"} )
  	EndIf 
	
	 // ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	 // Â³ Monta enchoice e getDados 			  				  Â³
	 // Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
	RegToMemory(clTab1,.F.)
	olEnch := Msmget():New(clTab1,&(clTab1)->(Recno()),2,,,,alCpoEnch,,,3,,,,oPanelE,,.T.,,,,,,,,.T.)
	olEnch:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	
	If (nlOpc == 4 .Or. nlOpc == 6)
		DbSelectArea("SDT")
	    SDT->(dbSetOrder(3))
	    If SDT->(dbSeek(xFilial("SDT")+aCposNFe[1]+aCposNFe[2]+aCposNFe[3]+aCposNFe[4]))
	    	DbSelectArea("SB1")
	    	SB1->(dbSetOrder(1))
	    	While SDT->(!EOF()) .AND. (SDT->DT_FORNEC==aCposNFe[1]) .AND. (SDT->DT_LOJA==aCposNFe[2]) .AND. (SDT->DT_DOC==aCposNFe[3]) .AND. (SDT->DT_SERIE==aCposNFe[4])
	    		clDescProd:= Iif(!Empty(SDT->DT_COD),Posicione("SB1",1,(xFilial("SB1")+PadR(SDT->DT_COD,TamSX3("B1_COD")[1])),"B1_DESC"),SDT->DT_DESCFOR)
	    	    aAdd(alItens,{SDT->DT_ITEM , SDT->DT_COD, SDT->DT_PRODFOR ,clDescProd })
	    	    clDescProd:=""
	    		SDT->(dbSkip())
		   	EndDo
	  	EndIf 		
	  	
	  	SetKey(VK_F5,{|| ProcPCxNFe(aCposNFe[1],aCposNFe[2],aCposNFe[3],aCposNFe[4],nlOpc, .F.) })
	  	
		AADD( aButtons, {"PEDIDO", {|| ProcPCxNFe(aCposNFe[1],aCposNFe[2],aCposNFe[3],aCposNFe[4],nlOpc, .F.),}, IIF(nlOpc == 4,"Pedido","Nota Original"),IIF(nlOpc == 4,"Pedido","Nota Original")}) //Pedido de Compra Item#Nota Original
//		If nlOpc == 4 .And. SDS->(FieldPos("DS_VALMERC")) > 0
//			AADD( aButtons, {"SOLICITA", {|| ProcPCxNFe(aCposNFe[1],aCposNFe[2],aCposNFe[3],aCposNFe[4],nlOpc,lPedDoc := .T.),},"Pedido de Doc","Pedido de Doc"}) //Pedido de Doc
//		EndIf
	EndIf
	
	If !(Type("aHeader") == "U") .AND. !(Type("aCols") == "U") .AND. ((nPosDesc := GDFieldPos("DT_DESC", aHeader))>0) .AND. ((nPosProd := GDFieldPos("DT_COD", aHeader))>0)
		nLoops := Len( aCols  )
		For nLoop := 1 To nLoops
			cDescProd := Posicione("SB1",1,xFilial("SB1")+aCols[nLoop][nPosProd],"B1_DESC")
			GdFieldPut( "DT_DESC" , cDescProd , nLoop , aHeader , aCols )
		Next nLoop
	EndIf       
	
	 // ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	 // Â³ Linha adicionada para permitir a digitaÃ§Ã£o do campos NF Origem Â³
	 // Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™		 
	If SDS->DS_TIPO $ "CD"
		aRotina := {{"Visualizar","AxVisual",0,6,0,.F.},{"Visualizar","AxVisual",0,6,0,.F.}}
	EndIf
	olGetDd := MsGetDados():New(0,0,0,0,3,,,"",.T.,aCpos1,,,,,,,,oPanelG)
	olGetDd:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT	
	
	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿
	// Â³ Monta Rodape         Â³
	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™	
	If SDS->(FieldPos("DS_VALMERC")) > 0
		// Totais
	 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Valor Mercadoria" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Mercadoria
	 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+050),{|u| If(PCount()>0,alRNfe[11]:=u,alRNfe[11])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[11]")
	 	
	 	@(alAdvSz[1]+027),(alAdvSz[2]+5) Say "Valor Frete" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Frete
	 	TGet():New((alAdvSz[1]+25),(alAdvSz[2]+050),{|u| If(PCount()>0,alRNfe[13]:=u,alRNfe[13])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[13]")
	 	
	 	@(alAdvSz[1]+044),(alAdvSz[2]+5) Say "Valor Descontos" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Descontos
	 	TGet():New((alAdvSz[1]+42),(alAdvSz[2]+050),{|u| If(PCount()>0,alRNfe[15]:=u,alRNfe[15])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[15]")
	
	 	@(alAdvSz[1]+010),(alAdvSz[2]+250) Say "Valor Seguro" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Seguro
	 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+310),{|u| If(PCount()>0,alRNfe[14]:=u,alRNfe[14])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[14]")
	 	
	 	@(alAdvSz[1]+027),(alAdvSz[2]+250) Say "Valor Despesas" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Despesas
	 	TGet():New((alAdvSz[1]+25),(alAdvSz[2]+310),{|u| If(PCount()>0,alRNfe[12]:=u,alRNfe[12])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[12]") 	
	 	
	 	@(alAdvSz[1]+049),(alAdvSz[2]+250) Say "Valor Bruto" Font olFont Pixel Of olFld:aDialogs[1]  //Valor Bruto
	 	TGet():New((alAdvSz[1]+48),(alAdvSz[2]+310),{|u| If(PCount()>0,alRNfe[16]:=u,alRNfe[16])}, olFld:aDialogs[1] ,60,10,"@E 999,999,999.99",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[16]") 	 	 	
	 	
	 	//Dados da DANFE
	 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Cod.Transp" Font olFont Pixel Of olFld:aDialogs[2]  //Cod.Transp
	 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+040),{|u| If(PCount()>0,alRNfe[18]:=u,alRNfe[18])}, olFld:aDialogs[2] ,35,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[18]")

	 	//Dados da DANFE
	 	@(alAdvSz[1]+010),(alAdvSz[2]+450) Say "Tipo do Frete" Font olFont Pixel Of olFld:aDialogs[2]  //Tipo do Frete
	 	Do Case
			Case AllTrim(alRNfe[30]) == "C"
	 			cCombo := "C-CIF"			//"C-CIF"
			Case AllTrim(alRNfe[30]) == "F"	
	 			cCombo := "F-FOB"			//"F-FOB"
	 		Case AllTrim(alRNfe[30]) == "T"	
	 			cCombo := "F-Por Conta Terceiros" 			//"F-Por Conta Terceiros"
	 		Case AllTrim(alRNfe[30]) == "S"		 		
	 			cCombo := "S-Sem Frete"		//"S-Sem Frete"
	 	End	Case	 	
		oCombo:= TComboBox():New((alAdvSz[1]+08),(alAdvSz[2]+490),{|u|if(PCount()>0,alRNfe[30]:=u,alRNfe[30])},{cCombo},085,20,olFld:aDialogs[2],,,,,,.T.,,,,,,,,,"alRNfe[30]")
		oCombo:BWHEN := {||.F.}
	 	
	 	@(alAdvSz[1]+25),(alAdvSz[2]+5) Say "Placa" Font olFont Pixel Of olFld:aDialogs[2]  //Placa
	 	TGet():New((alAdvSz[1]+22),(alAdvSz[2]+040),{|u| If(PCount()>0,alRNfe[29]:=u,alRNfe[29])}, olFld:aDialogs[2] ,35,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[29]")
	 		 		 	
	 	@(alAdvSz[1]+41),(alAdvSz[2]+5) Say "Peso Liquido" Font olFont Pixel Of olFld:aDialogs[2]  //Peso Liquido
	 	TGet():New((alAdvSz[1]+37),(alAdvSz[2]+040),{|u| If(PCount()>0,alRNfe[20]:=u,alRNfe[20])}, olFld:aDialogs[2] ,50,10,"@E 999,999.9999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[20]")
	 	
	 	@(alAdvSz[1]+057),(alAdvSz[2]+5) Say "Peso Bruto" Font olFont Pixel Of olFld:aDialogs[2]  //Peso Bruto
	 	TGet():New((alAdvSz[1]+53),(alAdvSz[2]+040),{|u| If(PCount()>0,alRNfe[19]:=u,alRNfe[19])}, olFld:aDialogs[2] ,50,10,"@E 999,999.9999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[19]")
	 	
	 	@(alAdvSz[1]+011),(alAdvSz[2]+200) Say "Especie1" Font olFont Pixel Of olFld:aDialogs[2]  //Especie1
	 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+230),{|u| If(PCount()>0,alRNfe[21]:=u,alRNfe[21])}, olFld:aDialogs[2] ,55,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[21]")
	 	
	 	@(alAdvSz[1]+024),(alAdvSz[2]+200) Say "Especie2" Font olFont Pixel Of olFld:aDialogs[2]  //Especie2
	 	TGet():New((alAdvSz[1]+22),(alAdvSz[2]+230),{|u| If(PCount()>0,alRNfe[22]:=u,alRNfe[22])}, olFld:aDialogs[2] ,55,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[22]")

	 	@(alAdvSz[1]+038),(alAdvSz[2]+200) Say "Especie3" Font olFont Pixel Of olFld:aDialogs[2]  //Especie3
	 	TGet():New((alAdvSz[1]+36),(alAdvSz[2]+230),{|u| If(PCount()>0,alRNfe[23]:=u,alRNfe[23])}, olFld:aDialogs[2] ,55,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[23]")	 	
	 	
	 	@(alAdvSz[1]+052),(alAdvSz[2]+200) Say "Especie4" Font olFont Pixel Of olFld:aDialogs[2]  //Especie4
	 	TGet():New((alAdvSz[1]+50),(alAdvSz[2]+230),{|u| If(PCount()>0,alRNfe[24]:=u,alRNfe[24])}, olFld:aDialogs[2] ,55,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[24]")
	 		 	
	 	@(alAdvSz[1]+011),(alAdvSz[2]+300) Say "Volume 1" Font olFont Pixel Of olFld:aDialogs[2]  //Volume 1
	 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+330),{|u| If(PCount()>0,alRNfe[25]:=u,alRNfe[25])}, olFld:aDialogs[2] ,55,10,"@E 999999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[25]")
	 	
	 	@(alAdvSz[1]+024),(alAdvSz[2]+300) Say "Volume 2" Font olFont Pixel Of olFld:aDialogs[2]  //Volume 2
	 	TGet():New((alAdvSz[1]+22),(alAdvSz[2]+330),{|u| If(PCount()>0,alRNfe[26]:=u,alRNfe[26])}, olFld:aDialogs[2] ,55,10,"@E 999999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[26]")

	 	@(alAdvSz[1]+038),(alAdvSz[2]+300) Say "Volume 3" Font olFont Pixel Of olFld:aDialogs[2]  //Volume 3
	 	TGet():New((alAdvSz[1]+36),(alAdvSz[2]+330),{|u| If(PCount()>0,alRNfe[27]:=u,alRNfe[27])}, olFld:aDialogs[2] ,55,10,"@E 999999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[27]")	 	
	 	
	 	@(alAdvSz[1]+052),(alAdvSz[2]+300) Say "Volume 4" Font olFont Pixel Of olFld:aDialogs[2]  //Volume 4
	 	TGet():New((alAdvSz[1]+50),(alAdvSz[2]+330),{|u| If(PCount()>0,alRNfe[28]:=u,alRNfe[28])}, olFld:aDialogs[2] ,55,10,"@E 999999",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[28]")	 	
	 	
	 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Log de Ocorrencia" Font olFont Pixel Of olFld:aDialogs[6]  //Log de Ocorrencia	 	
	 	oTMultiGet := TMultiget():New((alAdvSz[1]+08),(alAdvSz[2]+060),{|u| if(Pcount()>0, alRNfe[17]:=u,alRNfe[17])}, olFld:aDialogs[6],340,55,,,,,,.T.,,,,,,.T.)
 	EndIf
	// Chave NF-e 
 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Chave NF-e" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1])
 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[6]:=u,alRNfe[6])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1]),170,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[6]")
 	
	// Status 
 	@(alAdvSz[1]+025),(alAdvSz[2]+5) Say "Status: " Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1])
 	TGet():New((alAdvSz[1]+23),(alAdvSz[2]+050),{|u| if(PCount()>0,clGStatus:=u,clGStatus)}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1]),170,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"clGStatus")
 	// Arquivo
 	@(alAdvSz[1]+040),(alAdvSz[2]+5) Say "Nome Arquivo:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1])
 	TGet():New((alAdvSz[1]+38),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[2]:=u,alRNfe[2])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1]),170,10,"@!",,,,,,,.T.,,,,,,,.T.,,,"alRNfe[2]")
 	// Versao
 	@(alAdvSz[1]+010),(alAdvSz[2]+280) Say "Versao" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1])
 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+310),{|u| if(PCount()>0,alRNfe[7]:=u,alRNfe[7])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[3],olFld:aDialogs[1]),70,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[7]")

 	// Usuario
 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Usuario Importação:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2])
 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[3]:=u,alRNfe[3])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2]), 100,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[3]")
 	// Data
 	@(alAdvSz[1]+025),(alAdvSz[2]+5) Say "Data Importação:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2])
   	TGet():New((alAdvSz[1]+23),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[4]:=u,alRNfe[4])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2]) ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[4]")
 	// Hora
 	@(alAdvSz[1]+040),(alAdvSz[2]+5) Say  "Hora Importação" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2])
   	TGet():New((alAdvSz[1]+38),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[5]:=u,alRNfe[5])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[4],olFld:aDialogs[2]) ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[5]")
   	
   	// Usuario
 	@(alAdvSz[1]+010),(alAdvSz[2]+5) Say "Usuario Importação:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3])
 	TGet():New((alAdvSz[1]+08),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[8]:=u,alRNfe[8])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3]) ,100,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[8]")
 	// Data
 	@(alAdvSz[1]+025),(alAdvSz[2]+5) Say "Data Importação:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3])
   	TGet():New((alAdvSz[1]+23),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[9]:=u,alRNfe[9])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3]) ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[9]")
 	// Hora
 	@(alAdvSz[1]+040),(alAdvSz[2]+5) Say  "Hora Importação:" Font olFont Pixel Of IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3])
   	TGet():New((alAdvSz[1]+38),(alAdvSz[2]+050),{|u| if(PCount()>0,alRNfe[10]:=u,alRNfe[10])}, IIf(SDS->(FieldPos("DS_VALMERC")) > 0,olFld:aDialogs[5],olFld:aDialogs[3]) ,50,10,,,,,,,,.T.,,,,,,,.T.,,,"alRNfe[10]")

	ACTIVATE MSDIALOG _opMoD3lg ON INIT(EnchoiceBar(_opMoD3lg,{|| (If(nlOpc > 2,lConfirma := IIF(nlOpc == 3,If(SDS->(FieldPos("DS_VALMERC")) > 0, A140IVlNFO(@alRNfe[11]),.T.),.T.),_opMoD3lg),IIF(IIF(SDS->DS_TIPO=="D",A140ITudoOk(),.T.),_opMoD3lg:End(),)) } , {|| IIF(SDS->DS_TIPO=="D",A140IGetAnt(aColsAnt),),_opMoD3lg:End()},,aButtons))
	If lConfirma
		If nlOpc == 4 .Or. nlOpc == 6
			SDT->(dbSetOrder(3))  // DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_COD
			SDT->(dbSetOrder(2))  // DT_FILIAL+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE+DT_PRODFOR
			For nLoop := 1 To Len(aCols)
				SDT->(dbSeek(xFilial("SDT")+aCposNFe[1]+aCposNFe[2]+aCposNFe[3]+aCposNFe[4]+aCols[nLoop,GDFieldPos("DT_PRODFOR")]))
				RecLock("SDT",.F.)
				If nlOpc == 4 
					SDT->DT_COD    := aCols[nLoop,GDFieldPos("DT_COD")]
					SDT->DT_PEDIDO := aCols[nLoop,GDFieldPos("DT_PEDIDO")]
					SDT->DT_ITEMPC := aCols[nLoop,GDFieldPos("DT_ITEMPC")]
					// Salva Quant. Original
					// SDT->DT_QUANTOR  := SDT->DT_QUANT
					// SDT->DT_VUNITOR  := SDT->DT_VUNIT
					SDT->DT_QUANT  := aCols[nLoop,GDFieldPos("DT_QUANT")]
					SDT->DT_VUNIT  := aCols[nLoop,GDFieldPos("DT_VUNIT")]
					SDT->DT_TOTAL  := (SDT->DT_QUANT * SDT->DT_VUNIT )
					

				ElseIF nlOpc == 6
					SDT->DT_NFORI := aCols[nLoop,GDFieldPos("DT_NFORI")]
					SDT->DT_SERIORI := aCols[nLoop,GDFieldPos("DT_SERIORI")]
					SDT->DT_ITEMORI := aCols[nLoop,GDFieldPos("DT_ITEMORI")]
				EndIf
				SDT->(MsUnLock())
			Next nLoop
		ElseIf !SDS->(FieldPos("DS_VALMERC")) >0 .And. nlOpc == 5
			SDS->(DbSetOrder(2))	
			If SDS->(DbSeek(xFilial("SDS")+SDS->DS_CHAVENF))
				If SDS->DS_STATUS == "P"
					Aviso("Aviso","Processado",{"OK"})		
				Else
					SDT->(DbSetOrder(1))
					If SDT->(DbSeek(xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)))
						Do While SDT->(!EOF()) .And. SDT->(DT_FILIAL+DT_CNPJ+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDT")+SDS->(DS_CNPJ+DS_FORNEC+DS_LOJA+DS_DOC+DS_SERIE)
							RecLock("SDT")
							SDT->(DbDelete())
							SDT->(dbSkip())
						EndDo
					EndIf
					SDS->(FKCommit())
					SDS->(RecLock("SDS"))
					SDS->(DbDelete())
				EndIf
			EndIf
		EndIf
	EndIf

aRotina := aClone(aBackRot)

SetKey(VK_F5, NIL )

Return lConfirma .And. nlOpc == 3

Static Function GetRodape(clCodFor,clLoja,clNota,clSerie,clTab1)
Local alNFe 	:= {}

dbSelectArea(clTab1)  
dbSetOrder(1)
&(clTab1)->(dbGoTop())
If dbSeek(xFilial(clTab1)+clNota+clSerie+clCodFor+clLoja) 
	aAdd(alNFe, &(clTab1+"->DS_STATUS"  ))	//1
    aAdd(alNFe, &(clTab1+"->DS_ARQUIVO" ))	//2
    aAdd(alNFe, &(clTab1+"->DS_USERIMP" ))	//3
    aAdd(alNFe, &(clTab1+"->DS_DATAIMP" ))	//4
    aAdd(alNFe, &(clTab1+"->DS_HORAIMP" ))	//5
    aAdd(alNFe, &(clTab1+"->DS_CHAVENF" ))	//6
    aAdd(alNFe, &(clTab1+"->DS_VERSAO" ))	//7
    aAdd(alNFe, &(clTab1+"->DS_USERPRE" ))	//8
    aAdd(alNFe, &(clTab1+"->DS_DATAPRE" ))	//9
    aAdd(alNFe, &(clTab1+"->DS_HORAPRE" ))	//10
    If SDS->(FieldPos("DS_VALMERC")) > 0
    	aAdd(alNFe, &(clTab1+"->DS_VALMERC" ))	//11
    	aAdd(alNFe, &(clTab1+"->DS_DESPESA" ))	//12
    	aAdd(alNFe, &(clTab1+"->DS_FRETE"   ))	//13
    	aAdd(alNFe, &(clTab1+"->DS_SEGURO"  ))	//14
    	aAdd(alNFe, &(clTab1+"->DS_DESCONT" ))	//15
    	aAdd(alNFe, &(clTab1+"->(DS_VALMERC+DS_DESPESA+DS_FRETE+DS_SEGURO-DS_DESCONT)"))//16
    	aAdd(alNFe, &(clTab1+"->DS_DOCLOG"  ))	//17
    	aAdd(alNFe, &(clTab1+"->DS_TRANSP"  ))	//18
    	aAdd(alNFe, &(clTab1+"->DS_PBRUTO"  ))	//19
    	aAdd(alNFe, &(clTab1+"->DS_PLIQUI"  ))	//20
    	aAdd(alNFe, &(clTab1+"->DS_ESPECI1"))	//21
    	aAdd(alNFe, &(clTab1+"->DS_ESPECI2"))	//22
    	aAdd(alNFe, &(clTab1+"->DS_ESPECI3"))	//23
    	aAdd(alNFe, &(clTab1+"->DS_ESPECI4"))	//24
    	aAdd(alNFe, &(clTab1+"->DS_VOLUME1"))	//25
    	aAdd(alNFe, &(clTab1+"->DS_VOLUME2"))	//26
    	aAdd(alNFe, &(clTab1+"->DS_VOLUME3"))	//27
    	aAdd(alNFe, &(clTab1+"->DS_VOLUME4"))	//28
    	aAdd(alNFe, &(clTab1+"->DS_PLACA"  ))	//29
    	aAdd(alNFe, &(clTab1+"->DS_TPFRETE"))	//30
    EndIf
EndIf

Return alNFe

Static Function AtuBtn(clStatus)  
If SDS->(FieldPos("DS_VALMERC")) > 0
	If (clStatus$"P")
		opBtPed:Disable()
	ElseIf (clStatus$"B") 
		opBtPed:Disable()
	Else
		opBtPed:Enable()
	EndIf
Else
	If (clStatus$"P")
		opBtPed:Disable()  
		opBtImp:Disable()      
		olBtExc:Disable()      
	ElseIf (clStatus$"B") 
		opBtPed:Disable()
		opBtImp:Enable() 
		olBtExc:Enable()
	Else
		opBtPed:Enable()
		opBtImp:Enable() 
		olBtExc:Enable()
	EndIf
EndIf
Return Nil

Static Function ProcPCxNFe(clCodFor,clLoja,clNota,clSerie,nlOpc,lPedDoc)
Local clArqSQL    := GetNextAlias()
Local aAreaSB1    := SB1->(GetArea())
Local clQuery 	  := ""
Local nRecSDT	  := 0
Local lRet		  := .F.
Local aCampos	  := {}
Local nX		  := 0
Local lConsLoja	:= .f.	// Considera loja na pesquisa de pedidos

Default lPedDoc	  := .F.

If nlOpc == 4
	If !lPedDoc
		#IFDEF TOP            	
			// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
			// |  MONTA QUERY   |	
		    // Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™         
			clQuery := " SELECT C7_NUM, C7_ITEM, C7_PRODUTO, C7_DESCRI, C7_QUANT, C7_PRECO, C7_TOTAL, C7_QTDACLA, C7_EMISSAO, C7_CONAPRO,C7_DATPRF "
			clQuery += " FROM " + RetSqlName("SC7") + " SC7 "
			clQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND D_E_L_E_T_ <> '*' "
			clQuery += " AND C7_FORNECE = '" + clCodFor + "'" 
			If lConsLoja
				clQuery += " AND C7_LOJA = '" + clLoja + "'" 
			EndIf
			// clQuery += " AND C7_PRODUTO = '" + aCols[n,GDFieldPos("DT_COD")] + "' " 
			// clQuery += " AND (C7_QUANT - C7_QUJE - C7_QTDACLA) > 0"
			clQuery += " AND C7_ENCER = ' ' AND C7_RESIDUO <> 'S'"
			clQuery := ChangeQuery(clQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,clQuery),clArqSQL, .T., .T.)
		#ELSE
			aStruSC7 := {}
			AADD(aStruSC7,{ "C7_NUM",     "C",   6, 0})
			AADD(aStruSC7,{ "C7_ITEM",    "C",   4, 0})
			AADD(aStruSC7,{ "C7_PRODUTO",   "C",  15, 0})
			AADD(aStruSC7,{ "C7_DESCRI",   "C",  40, 0})
			AADD(aStruSC7,{ "C7_QUANT",   "N",  12, 2})
			AADD(aStruSC7,{ "C7_TOTAL",	   "N",  14, 2})
			AADD(aStruSC7,{ "C7_QTDACLA", "N",  12, 2})
			AADD(aStruSC7,{ "C7_EMISSAO", "C",   8, 0})
			AADD(aStruSC7,{ "C7_CONAPRO", "C", TamSx3("C7_CONAPRO")[1],0})
			
			clArqSQL := CriaTrab(aStruSC7, .T.)			
			DbUseArea(.T.,,clArqSQL,clArqSQL,.F.,.F.)
			dbSelectArea(clArqSQL)
			
			SC7->(DbSetOrder(2))
			If SC7->(dbSeek(xFilial("SC7")+aCols[n,GDFieldPos("DT_COD")]+clCodFor+clLoja))
				While SC7->(!EOF()) .And. SC7->(C7_FILIAL+C7_PRODUTO+C7_FORNECE+C7_LOJA) == xFilial("SC7")+aCols[n,GDFieldPos("DT_COD")]+clCodFor+clLoja
				    If (SC7->C7_QUANT - SC7->C7_QUJE - SC7->C7_QTDACLA) > 0 .And. SC7->C7_RESIDUO <> 'S' .And. Empty(SC7->C7_ENCER)
				   		RecLock(clArqSQL,.T.)
						(clArqSQL)->C7_NUM    	 := SC7->C7_NUM
			  			(clArqSQL)->C7_ITEM   	 := SC7->C7_ITEM
			  			(clArqSQL)->C7_QUANT  	 := SC7->C7_QUANT
						(clArqSQL)->C7_TOTAL 	 := SC7->C7_TOTAL
				  		(clArqSQL)->C7_QTDACLA	 := SC7->C7_QTDACLA
				  		(clArqSQL)->C7_EMISSAO	 := DTOS(SC7->C7_EMISSAO)
				  		(clArqSQL)->C7_PRECO	 := SC7->C7_PRECO 
				  		(clArqSQL)->C7_CONAPRO	 := SC7->C7_CONAPRO
						(clArqSQL)->(MsUnLock())
					EndIf
					SC7->(DbSkip())
				End				
			EndIf	  	
		#ENDIF
	Else
		#IFDEF TOP            	
			// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
			// |  MONTA QUERY   |	
		    // Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™         
			clQuery += " SELECT DISTINCT C7_NUM, C7_EMISSAO, C7_CONAPRO"
			clQuery += " FROM " + RetSqlName("SC7") + " SC7 "
			clQuery += " WHERE C7_FILIAL = '" + xFilial("SC7") + "' AND D_E_L_E_T_ <> '*' "
			clQuery += " AND C7_FORNECE = '" + clCodFor + "'"
			If lConsLoja
				clQuery += " AND C7_LOJA = '" + clLoja + "'" 
			EndIf
			clQuery += " AND C7_ENCER = ' ' AND C7_RESIDUO <> 'S'"
			clQuery += " AND (C7_QUANT - C7_QUJE - C7_QTDACLA) > 0"
			clQuery += " ORDER BY C7_EMISSAO"
			clQuery := ChangeQuery(clQuery)
			dbUseArea(.T., "TOPCONN", TCGenQry(,,clQuery),clArqSQL, .T., .T.)
		#ELSE
			aStruSC7 := {}
			AADD(aStruSC7,{ "C7_NUM",     "C",   6, 0})
			AADD(aStruSC7,{ "C7_EMISSAO", "C",   8, 0})
			AADD(aStruSC7,{ "C7_CONAPRO", "C", TamSx3("C7_CONAPRO")[1],0})
		
			clArqSQL := CriaTrab(aStruSC7, .T.)			
			DbUseArea(.T.,,clArqSQL,clArqSQL,.F.,.F.)
			dbSelectArea(clArqSQL)
			
			SC7->(DbSetOrder(3))
			If SC7->(dbSeek(xFilial("SC7")+clCodFor+clLoja))
				While SC7->(!EOF()) .And. SC7->(C7_FILIAL+C7_FORNECE+C7_LOJA) == xFilial("SC7")+clCodFor+clLoja
				    If SC7->C7_RESIDUO <> 'S' .And. Empty(SC7->C7_ENCER)
				   		RecLock(clArqSQL,.T.)
						(clArqSQL)->C7_NUM    	 := SC7->C7_NUM
				  		(clArqSQL)->C7_EMISSAO	 := DTOS(SC7->C7_EMISSAO)
				  		(clArqSQL)->C7_CONAPRO	 := SC7->C7_CONAPRO
						(clArqSQL)->(MsUnLock())
					EndIf
					SC7->(DbSkip())
				End				
			EndIf	  	
		#ENDIF	
	EndIf
	
	dbSelectArea(clArqSQL)
	(clArqSQL)->(dbGoTop())
	
	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
	// |  VERIFICA SE ECONTROU PEDIDOS    |
	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™    
	If (clArqSQL)->(!EOF()) // -> ENCONTROU PEDIDOS
		MarkBrwPC(clArqSQL,clCodFor,clLoja,clNota,clSerie,lPedDoc)
	Else
		Aviso("Aviso",("NÃ£o foi identificado nenhum pedido de compra referente ao item "+aCols[n,GDFieldPos("DT_ITEM")]+ " da nota fiscal "+clNota),{"OK"})
	EndIf
	(clArqSQL)->(dbCloseArea())
ElseIf nlOpc == 6
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	MsSeek(xFilial("SB1")+aCols[n,GDFieldPos("DT_COD")])
	
	If SDS->DS_TIPO == "D"
		lRet := F4NFORI(,,"M->DT_NFORI",clCodFor,clLoja,aCols[n,GDFieldPos("DT_COD")],"A140I",,@nRecSDT) .And. nRecSDT<>0
	ElseIf SDS->DS_TIPO == "C"
		lRet := F4COMPL(,,,clCodFor,clLoja,aCols[n,GDFieldPos("DT_COD")],"A140I",@nRecSDT,"M->DT_NFORI") .And. nRecSDT<>0
	EndIf
EndIf	

RestArea(aAreaSB1)
Return

Static Function MarkBrwPC(clArqSQL,clCodFor,clLoja,clNota,clSerie,lPedDoc)   
    Local clQZ4         := 0
	Local olFont        := TFont ():New(,,-11,.T.,.T.,5,.T.,5,.F.,.F.)
	Local alSize    	:= MsAdvSize() 
	Local nlTl1     	:= alSize[1]
	Local nlTl2    		:= alSize[2]
	Local nlTl3    		:= alSize[1]+300
	Local nlTl4     	:= alSize[2]+680
	Local clPed         := ""
	Local clItmPC       := ""   
	Local alEstru       := {}  
	Local llInvert      := .F.  
	Local alCampos      := {} 
	Local clTabTmp      := ""   
	Local clTMPMark     := ""
	Local clTMPQtd      := 0      
	Local olSayQtd      := NIL   
	Local olMsSel01     := NIL  
	Local clMarca       := GetMark() // Essa variÃ¡vel nÃ£o pode ter outro conteudo
	Local nOpca			:= 1
	Local nLinhaSel		:= n
	Local nX			:= 0
	Local aCampos		:= {}
	Local nY			:= 0
	Local cCampoUsr		:= ""
	Local nPosCpo		:= 0
	Local lInforma		:= .F.
	Private opDlgMPed   := NIL 
	
	// Foi necessario criar essas variaveis para que fosse possivel usar a funcao padrao do sistema A120Pedido()
	Private INCLUI      := .F.
	Private ALTERA      := .F.
	Private nTipoPed    := 1  
	Private cCadastro   := "Pedido de Compra"  
	Private l120Auto    := .F.  	                                   
	
	If !lPedDoc
		// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
		// |  ESTRUTURA PARA TABELA TEMPORARIA  |	
	   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
		alEstru := {}   
		aadd(alEstru,{"MMARK",     "C",  LEn(clMarca),           0                     })
		aadd(alEstru,{"PED ",      "C",  TamSx3("C7_NUM")[1],    0                     })
		aadd(alEstru,{"ITEM",      "C",  TamSx3("C7_ITEM")[1],   0                     })
		aadd(alEstru,{"PRODUTO",   "C",  TamSx3("C7_PRODUTO")[1],   0                     })
		aadd(alEstru,{"DESCRI",    "C",  TamSx3("C7_DESCRI")[1],   0                     })
		aadd(alEstru,{"DDATA",     "D",  8                   ,   0                     })
		aadd(alEstru,{"QTDDISP" ,  "N",  TamSx3("C7_QUANT")[1],  TamSx3("C7_QUANT")[2] })  
		aadd(alEstru,{"PRECO" 	,  "N",  TamSx3("C7_PRECO")[1],  TamSx3("C7_PRECO")[2] })  
		aadd(alEstru,{"DENTREGA",     "D",  8                   ,   0                     })
		aadd(alEstru,{"MMARKOLD",   "C",  LEn(clMarca),           0                     })  
		aadd(alEstru,{"CONAPRO",    "C",  TamSx3("C7_CONAPRO")[1],  0                   })
		
		// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
		// |  CAMPOS PARA MSSELECT  |	
	   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
		alCampos := {}   
		aAdd(alCampos,{"MMARK"    , , ""   	       ,""                      	})
		aAdd(alCampos,{"PED"      , , "Pedido"      ,PesqPict("SC7","C7_NUM")  	})
		aAdd(alCampos,{"ITEM"     , , "Item"      ,PesqPict("SC7","C7_ITEM")   }) 
		aAdd(alCampos,{"PRODUTO"  , , "Produto"      ,PesqPict("SC7","C7_PRODUTO")   }) 
		aAdd(alCampos,{"DESCRI"   , , "Descricao"  ,PesqPict("SC7","C7_DESCRI")   }) 
		aAdd(alCampos,{"DDATA"    , , "Data"      ,                            })   
		aAdd(alCampos,{"QTDDISP"  , , "Qtd. Ped. Compra"      ,PesqPict("SC7","C7_QUANT")  })  
		aAdd(alCampos,{"PRECO"    , , "Unitario"       ,PesqPict("SC7","C7_PRECO")  })  
		aAdd(alCampos,{"DENTREGA" , , "Entrega"      ,                            })   
		aAdd(alCampos,{"QTDDISP"  , , "Qtd. Ped. Compra"      ,PesqPict("SC7","C7_QUANT")  })  

	Else
		// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
		// |  ESTRUTURA PARA TABELA TEMPORARIA  |	
	   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
		alEstru := {}   
		aadd(alEstru,{"MMARK",     "C",  Len(clMarca),            0                     })
		aadd(alEstru,{"PED ",      "C",  TamSx3("C7_NUM")[1],     0                     })
		aadd(alEstru,{"DDATA",     "D",  8                   ,    0                     })
		aadd(alEstru,{"MMARKOLD",   "C",  LEn(clMarca),           0                     })  
		aadd(alEstru,{"CONAPRO",    "C",  TamSx3("C7_CONAPRO")[1],  0                   })
				
		// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
		// |  CAMPOS PARA MSSELECT  |	
	   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
		alCampos := {}   
		aAdd(alCampos,{"MMARK"    , , ""   	       ,""                      	})
		aAdd(alCampos,{"PED"      , , "Pedido"      ,PesqPict("SC7","C7_NUM")  	})
		aAdd(alCampos,{"DDATA"    , , "Data"      ,                            })   
	EndIf	
	// Cria e seleciona a tabela temporÃ¡ria
	clTabTmp := CriaTrab(alEstru,.T.)
	dbUseArea(.T.,,clTabTmp,"TMP",.F.,.F.)
	dbSelectArea("TMP")

	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿ 	 
	// |  TRANSFERE OS DADOS PARA A TABELA TEMPORARIA  |	
   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
	If !lPedDoc
		dbSelectArea(clArqSql)
		&(clArqSql+"->(dbGoTop())")   
		While &(clArqSql+"->(!EOF())")    
	 		clPed 			:= &(clArqSql+"->C7_NUM") 
	  		clItmPc 		:= &(clArqSql+"->C7_ITEM")
	  		clTMPMark       := ""
	  		clTMPQtd        := 0    
			
			DbSelectArea("TMP")
	   		If RecLock("TMP",.T.)       
				TMP->PED     	:= clPed
	  			TMP->ITEM    	:= clItmPc    
	  			TMP->PRODUTO   	:= &(clArqSql+"->C7_PRODUTO")
	  			TMP->DESCRI    	:= &(clArqSql+"->C7_DESCRI")
	  			TMP->DDATA  	:= StoD(&(clArqSql+"->C7_EMISSAO"))
				TMP->QTDDISP 	:= (&(clArqSql+"->C7_QUANT") - (&(clArqSql+"->C7_QTDACLA")+ clQZ4))
		  		TMP->MMARK   	:= clTMPMark
		  		TMP->PRECO      := (&(clArqSql+"->C7_PRECO")) 
		  		TMP->CONAPRO    := (&(clArqSql+"->C7_CONAPRO"))
	  			TMP->DENTREGA  	:= StoD(&(clArqSql+"->C7_DATPRF"))

	            //Marca o registro como jÃ¡ utilizado //
	            If nLinhaSel>0 .And. !Empty(aCols[nLinhaSel,GDFieldPos("DT_PEDIDO")])
					If aCols[nLinhaSel,GDFieldPos("DT_PEDIDO")]==clPed .And. aCols[nLinhaSel,GDFieldPos("DT_ITEMPC")]==clItmPc
						TMP->MMARK   :=clMarca
						TMP->MMARKOLD:=clMarca
					EndIf
				EndIf
				TMP->(MsUnLock())
			EndIf 
			
			DbSelectArea(clArqSql)
			&(clArqSql)->(dbSkip())
		EndDo 
	Else
		dbSelectArea(clArqSql)
		&(clArqSql+"->(dbGoTop())")   
		While &(clArqSql+"->(!EOF())")    
	 		clPed 			:= &(clArqSql+"->C7_NUM") 
	  		clTMPMark       := ""	  		
	  					
			DbSelectArea("TMP")
	   		If RecLock("TMP"	,.T.)       
				TMP->PED     	:= clPed
	  			TMP->DDATA  	:= StoD(&(clArqSql+"->C7_EMISSAO"))
		  		TMP->MMARK   	:= clTMPMark
		  		TMP->CONAPRO    := (&(clArqSql+"->C7_CONAPRO"))
				TMP->(MsUnLock())
				SC7->(dbSetOrder(2))
				For nX := 1 To Len(aCols)
					If !Empty(aCols[nX,GDFieldPos("DT_PEDIDO")]) .And. aCols[nX,GDFieldPos("DT_PEDIDO")]==clPed 
						TMP->MMARK   :=clMarca
						TMP->MMARKOLD:=clMarca
					EndIf
				Next nX
			EndIf 
			
			DbSelectArea(clArqSql)
			&(clArqSql)->(dbSkip())
		EndDo 	
	EndIf	                                       
	TMP->(dbGoTop())                                                                
	                  
	DEFINE MSDIALOG opDlgMPed TITLE "Seleção dos Pedidos de Compra" From nlTl1,nlTl2 to nlTl3,nlTl4+100 PIXEL     

	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
	// |  CABECALHO DA TELA  |	
   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™ 
	// @(nlTl1+10),nlTl2+5 to (nlTl1+23),(nlTl2+240) PIXEL OF opDlgMPed
	// oPanelPc := tPanel():New(0,0,"",opDlgMPed,,,,,,0,0)
	oPanelCabec := TPanel():New(0,0,"",opDlgMPed,NIL,.T.,.F.,NIL,NIL,0,25,.T.,.F.)
	oPanelCabec:Align := CONTROL_ALIGN_TOP

	oPanelRodape := TPanel():New(0,0,"",opDlgMPed,NIL,.T.,.F.,NIL,NIL,0,15,.T.,.F.)
	oPanelRodape:Align := CONTROL_ALIGN_BOTTOM


	IF !lPedDoc

 		@ 07,05 Say "NF: " + clNota + " - Item: " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_ITEM")]) + " / " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_PRODFOR")]) + " - " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_DESCFOR")])   Font olFont Pixel Of oPanelCabec
		@ 17,05 Say "Fornecedor: " + clCodFor + "/" + clLoja + " - " + Posicione("SA2",1,xFilial("SA2")+clCodFor+clLoja,"A2_NOME") Font olFont Pixel Of oPanelCabec

// 		@(nlTl1+10),(nlTl2+010) Say "NF: " + clNota + " - Item: " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_ITEM")]) + " / " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_PRODFOR")]) + " - " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_DESCFOR")])   Font olFont Pixel Of oPanelPc
//		@(nlTl1+20),(nlTl2+010) Say "NF: " + clNota + " - Fornecedor: " + clCodFor + "/" + clLoja + " - " + Posicione("SA2",1,xFilial("SA2")+clCodFor+clLoja,"A2_NOME") Font olFont Pixel Of oPanelPc
// 		@(nlTl1+14),(nlTl2+010) Say "NF: " + clNota + " - Item: " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_ITEM")]) + " / " + AllTrim(aCols[nLinhaSel,GDFieldPos("DT_COD")]) + " - " + Posicione("SB1",1,(xFilial("SB1")+PadR(aCols[nLinhaSel,GDFieldPos("DT_COD")],TamSX3("B1_COD")[1])),"B1_DESC")   Font olFont Pixel Of opDlgMPed
	Else
		@(nlTl1+14),(nlTl2+010) Say "NF: " + clNota + " - Fornecedor: " + clCodFor + "/" + clLoja + " - " + Posicione("SA2",1,xFilial("SA2")+clCodFor+clLoja,"A2_NOME") Font olFont Pixel Of oPanelPc
	EndIf 		

	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
	// |  MARKBROWSE / MSSELECT |	
   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™   	
	olMsSel01 :=  MsSelect():New('TMP','MMARK',"",alCampos,@llInvert,@clMarca,{(nlTl1+30),(nlTl2+5),(nlTl3-175),(nlTl4-50)},,opDlgMPed)	
	olMsSel01:oBrowse:lColDrag    := .T.
	olMsSel01:bMark := {|| (MarcaReg(clMarca,lPedDoc), olMsSel01:oBrowse:Refresh(), opDlgMPed:Refresh())}
	olMsSel01:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT	
	
	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
	// |  BOTOES    |	
   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™
// 	obTVisPe := TButton():New(nlTl1+132,nlTl2+6, "&Visualizar Pedido",oPanelRodape,{|| MsgRun("Carregando visualizaÃ§Ã£o do pedido"+Space(1)+TMP->PED+"...","Aguarde...", {|| A120Pedido("SC7",PosSC7(TMP->PED),2)})   } ,055,012,,,,.T.)
//	DEFINE SBUTTON FROM nlTl1+134,nlTl2+178 TYPE 1 ACTION(eVal( {|| If(At140IVlPd(clCodFor,clLoja,clNota,clSerie,aCols[nLinhaSel,GDFieldPos("DT_COD")],lPedDoc),(nOpca:=2, opDlgMPed:End()),)})) ENABLE Of oPanelRodape
//	DEFINE SBUTTON FROM nlTl1+134,nlTl2+212 TYPE 2 ACTION opDlgMPed:End() ENABLE Of oPanelRodape

	oBtn1 := TButton():New(0,0, "&Visualizar Pedido",oPanelRodape,{|| MsgRun("Carregando visualizaÃ§Ã£o do pedido"+Space(1)+TMP->PED+"...","Aguarde...", {|| A120Pedido("SC7",PosSC7(TMP->PED),2)})   } ,055,012,,,,.T.)
 	oBtn1:Align := CONTROL_ALIGN_RIGHT

	oBtn2 := TButton():New(0,0,"&Ok ",oPanelRodape,{|| nopca:=2,opDlgMPed:End() },50,11,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
 	oBtn2:Align := CONTROL_ALIGN_RIGHT

	oBtn3 := TButton():New(0,0,"&Sair ",oPanelRodape,{|| nopca:=1,opDlgMPed:End() },50,11,,,.F.,.T.,.F.,,.F.,{||.T.},,.F.)
 	oBtn3:Align := CONTROL_ALIGN_RIGHT
 	
 	ACTIVATE DIALOG opDlgMPed CENTERED
	          
	// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
	// | FECHA E DELETA ARQ. TAB. TEMP.     |		
   	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™   
   	If nOpca == 2	
		If At140IVlPd(clCodFor,clLoja,clNota,clSerie,aCols[nLinhaSel,GDFieldPos("DT_COD")],lPedDoc)
	   		TMP->(dbGoTop())
			While TMP->(!EOF())
				// ÃšÃ„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Â¿	 
				// | GRAVA O NUMERO DO PEDIDO DE COMPRA NO ACOLS  |	
			 	// Ã€Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã„Ã™		 	
				If !Empty(TMP->MMARK) .And. !Empty(TMP->PED)
					If !lPedDoc
						aCols[nLinhaSel,GDFieldPos("DT_COD")]    := TMP->PRODUTO
						aCols[nLinhaSel,GDFieldPos("DT_PEDIDO")] := TMP->PED
						aCols[nLinhaSel,GDFieldPos("DT_ITEMPC")] := TMP->ITEM
						aCols[nLinhaSel,GDFieldPos("DT_QUANT")]  := TMP->QTDDISP
						aCols[nLinhaSel,GDFieldPos("DT_VUNIT")]  := TMP->PRECO	
						aCols[nLinhaSel,GDFieldPos("DT_TOTAL")]  := ( TMP->QTDDISP * TMP->PRECO )
						Exit
					Else				   
						SC7->(dbSetOrder(2))
					    For nX := 1 To Len(aCols)
							If SC7->(dbSeek(xFilial("SC7")+aCols[nX,GDFieldPos("DT_COD")]+clCodFor+clLoja+TMP->PED))
								If aCols[nX,GDFieldPos("DT_QUANT")] <= SC7->C7_QUANT
									aCols[nX,GDFieldPos("DT_PEDIDO")] := SC7->C7_NUM
									aCols[nX,GDFieldPos("DT_ITEMPC")] := SC7->C7_ITEM
								Else
									If !lInforma
										AVISO("Aviso","Para os itens do pedido com quantidade inferior aos itens correspondentes da nota utilize a opÃ§Ã£o de vÃ­nculo por Item.",{"OK"})
										lInforma := .T.
									EndIf	
								EndIf
							EndIf
					    Next nX
					EndIf
				Else
					If lPedDoc 
						If !Empty(TMP->MMARKOLD)
							SC7->(dbSetOrder(2))
							For nX := 1 To Len(aCols)
								If SC7->(dbSeek(xFilial("SC7")+aCols[nX,GDFieldPos("DT_COD")]+clCodFor+clLoja+TMP->PED))
									aCols[nX,GDFieldPos("DT_PEDIDO")] := ""
									aCols[nX,GDFieldPos("DT_ITEMPC")] := ""
								EndIf
							Next nX
						EndIf
					Else
						If !Empty(TMP->MMARKOLD) .And. 	aCols[nLinhaSel,GDFieldPos("DT_PEDIDO")] ==  TMP->PED .And. aCols[nLinhaSel,GDFieldPos("DT_ITEMPC")] == TMP->ITEM
							aCols[nLinhaSel,GDFieldPos("DT_PEDIDO")] := ""
							aCols[nLinhaSel,GDFieldPos("DT_ITEMPC")] := ""
						EndIf
					EndIf
				EndIf
				TMP->(DbSkip())
			EndDo
		EndIf
	EndIf
		
	TMP->(dbCloseArea())       
	If File( AllTrim(clTabTmp)+GetDBExtension())         
		Ferase(AllTrim(clTabTmp)+GetDBExtension())       
	EndIf  
Return Nil 

User Function tsma010J( )
Local aFiles 	:= {}
Local nV,nX	 	:= 0
Local aProc  	:= {}
Local aErros 	:= {}
Local cAccount	:= ""
Local cPassword	:= ""
Local cServer	:= ""
Local cFrom		:= ""
Local cEmail	:= ""
Local aMail		:= {}
Local cAssunto	:= ""
Local cMensagem	:= ""
Local cAttach	:= "" 
Local lJob 		:= (Select('SX6')==0)
Local cEmp      := GetSrvProfString("JOBEMP","")
Local cFil		:= GetSrvProfString("JOBFIL","")

If lJob 
	If Empty(cEmp) .or. Empty(cFil)
		conout("[TSMA010] Não foi informada empresa e filial [JOBEMP] e [JOBFIL] no appserver.ini ")
		Return()
	endif

	RpcSetType(3)
	RpcSetEnv(aParam[1],aParam[2],,,"COM") 
Endif

cAccount	:= GetMv("MV_RELACNT")
cPassword	:= GetMV("MV_RELAPSW")
cServer		:= GetMV("MV_RELSERV")
cFrom		:= GetMV("MV_RELFROM")
cEmail		:= GetMv("MV_TSM010E")
aMail		:= StrTokArr(cEmail,";")
cAssunto	:= "[TSMA010] Log de Importação de Arquivos XML"
cMensagem	:= ""
cAttach		:= ""

If !ExistDir(DIRXML)
	MakeDir(DIRXML)
	MakeDir(DIRXML +DIRALER)
	MakeDir(DIRXML +DIRLIDO)
	MakeDir(DIRXML +DIRERRO)
	MakeDir(DIRXML +DIRNFE)
	MakeDir(DIRXML +DIRNFSE)
	MakeDir(DIRXML +DIRNFCO)
	MakeDir(DIRXML +DIRCTEE)
EndIf

For nV:=1 to 4
	aProc	:= {}
	aErros	:= {}
	cProc	:= ""
	cErro	:= ""
		
	If nSel == 1
		aFiles	:= Directory("\" +DIRXML +DIRNFE +"*.xml")
		cXML	:= ""
		For nX := 1 To Len(aFiles)
			//Prepara o arquivo XML 
			nHandle := FOpen(aFiles[nX,1])
			nLength := FSeek(nHandle,0,FS_END)
			FSeek(nHandle,0)
			If nHandle > 0
				FRead(nHandle, cXML, nLength)
				FClose(nHandle)
			EndIf
			ImpXML_NFe(aFiles[nX,1],.F.,@aProc,@aErros,nil,nil,nil,cXml,{})
		Next nX
		cAssunto:= "[TSMA010] Log de Importação de Arquivos XML NFE"
	ElseIf nSel == 2
		aFiles := Directory("\" +DIRXML +DIRNFSE +"*.xml")
		For nX := 1 To Len(aFiles)
			ImpXML_NFs(aFiles[nX,1],.F.,@aProc,@aErros)
		Next nX
		cAssunto:= "[TSMA010] Log de Importação de Arquivos XML NFSE"
	ElseIf nSel == 3
		aFiles := Directory("\" +DIRXML +DIRNFCO +"*.xml")
		For nX := 1 To Len(aFiles)
			ImpXML_Ave(aFiles[nX,1],.F.,@aProc,@aErros)
		Next nX	
		cAssunto:= "[TSMA010] Log de Importação de Arquivos XML NF COMPLEMENTO"
	ElseIf nSel == 4
		aFiles := Directory("\" +DIRXML +DIRCTEE +"*.xml")
		For nX := 1 To Len(aFiles)
			ImpXML_Cte(aFiles[nX,1],.F.,@aProc,@aErros)                      
		Next nX		                                                          
		cAssunto:= "[TSMA010] Log de Importação de Arquivos XML NF CTE EMBARCADOR"
	EndIf
	cProc 	:= varinfo( "" , aProc , nil , nil , .f. ) 
	cErro 	:= varinfo( "" , aErros , nil , nil , .f. )  

	If !empty(cProc) .or. !empty(cErro)
		cMensagem := "Log de Processamento:"+CRLF+cProc+CRLF+"Log de Erro"+cErro
		
		tsma010e(	cAccount	,cPassword	,cServer	,cFrom,;
		  				cEmail		,cAssunto	,cMensagem	,cAttach)
	Endif			

Next nV

Return

Static Function tsma010e(	cAccount,		cPassword,		cServer,		cFrom,;
							cEmailTo,		cAssunto,		cMensagem,		cAttach,;
							cEmailBcc)

Local lResult		:= .F.							// Se a conexao com o SMPT esta ok
Local lRet			:= .F.							// Se tem autorizacao para o envio de e-mail
Local cError		:= ""							// String de erro
Local lRelauth		:= SuperGetMv("MV_RELAUTH")		// Parametro que indica se existe autenticacao no e-mail
Local cContaAuth	:= SuperGetMv("MV_RELAUSR")		// Usuario para autenticacao do e-mail
Local cSenhaAuth	:= SuperGetMv("MV_RELAPSW")		// Senha para autenticacao do e-mail
Local cConta		:= ALLTRIM(cAccount)			// Conta de acesso 
Local cMySenha		:= ALLTRIM(cPassword)	        // Senha de acesso
Local nVezes		:= 5			  				// Numero de tentativas de conexao e envio o e-mail
Local nDaley		:= 1							// Tempo de espera entre as tentativas
Local nTenta		:= 0

Default cMensagem	:= ""
Default cAssunto	:= ""
Default cEmailBcc	:= ""
Default cAttach		:= ""


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Envia o mail para a lista selecionada. Envia como BCC para que a pessoa pense³
//³que somente ela recebeu aquele email, tornando o email mais personalizado.   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

While !lResult .AND. nTenta <= nVezes
	CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cMySenha RESULT lResult
	nTenta++
	If !lResult
		Sleep(nDaley)
	Endif
End

// Se a conexao com o SMPT esta ok
If lResult
	
	// Se existe autenticacao para envio valida pela funcao MAILAUTH
	nTenta := 0
	While !lRet .AND. nTenta <= nVezes
		If lRelauth
			lRet := Mailauth(cContaAuth,cSenhaAuth)	
		Else
			lRet := .T.	
	    Endif    
		nTenta++
		If !lRet
			Sleep(nDaley)
		Endif
	End
	
	If lRet
		nTenta		:= 0
		lResult	:= .F.
		While !lResult .AND. nTenta <= nVezes
			SEND MAIL	FROM		cFrom;
						TO			cEmailTo;
						BCC			cEmailBcc;
						SUBJECT		cAssunto;
						BODY		cMensagem;
						ATTACHMENT	cAttach;
						RESULT		lResult
			nTenta++
			If !lResult
				Sleep(nDaley)
			Endif
		End
		
		If !lResult
			If !IsBlind()
				//Erro no envio do email
				GET MAIL ERROR cError
				Help(" ",1,"Atenção",,cError+ " " + cEmailTo,4,5)
			Endif
		Endif

	Else
		If !IsBlind()
			GET MAIL ERROR cError
			Help(" ",1,"Autenticação",,cError,4,5)
			MsgStop("Erro de autenticação","Verifique a conta e a senha para envio")
		Endif
	Endif
		
	DISCONNECT SMTP SERVER
Else
	If !IsBlind()
		//Erro na conexao com o SMTP Server
		GET MAIL ERROR cError
		Help(" ",1,"Atenção",,cError,4,5)
	Endif
Endif

Return(lResult)

Static Function GerNf(alSF1,alSD1)
	Local lRet 		:= .F.
	Local aParam	:= {}
	Local nI		:= 0
		
	If( Empty(_cTpNFRot) )
		If ParamBox( {; 
						{ 3 ,"Tipo de Documento" ,1 ,{"Pré-Nota","Documento Entrada"}	 ,100  ,".T."    ,.T. ,".T." },; 
						{ 1 ,"TES" ,Space(TamSX3("D1_TES")[1]) , "@9", "Vazio() .or. ExistCpo('SF4')" ,"SF4" ,".T." , 50 , .F.  },;
						{ 1 ,"Operação" ,Space(TamSX3("D1_OPER")[1]) , "", "Vazio() .or. ExistCpo('SX5','DJ'+MV_PAR03)" ,"DJ" ,"MV_PAR01 = 2" , 50 , .F.  },;
						{ 9 ,"[ATENÇÃO] Todos os registros selecionados irão utilizar estes parâmetros", 180, 180, .T. };
					 }, "Parâmetros Geração de NF" ,@aParam )
		
			_cTpNFRot 	:= Iif(aParam[1] == 1, "P", "N")				 
			_cTESNFRot	:= aParam[2]
			_cOPERNFRot := aParam[3]
			lRet		:= .T.
		Else
			lRet := .F.
		Endif			
	EndIf
	
	If !Empty(_cTESNFRot) .or. ( _cTpNFRot == "N" .AND. !Empty(_cOPERNFRot) )
		For nI:=1 to Len(alSD1)
			If !Empty(_cTESNFRot)
				aAdd(alSD1[nI],{"D1_TES", _cTESNFRot ,NIL})
			Endif
			
			If _cTpNFRot == "N" .AND. !Empty(_cOPERNFRot) 
				aAdd(alSD1[nI],{"D1_OPER", _cOPERNFRot ,NIL})
			EndIf
		Next
	Endif
		
Return(lRet)



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ImpXML_NFeºAutor  ³Demetrio Fontes 	 º Data ³  14/03/11   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Funcao para leitura de XMLs de NFe no diretorio de downloadº±±
±±º			 ³ e geracao da pre-nota de entrada.						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ GENERICO			                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ImpXML_NFe(cXMLOri,cFile)  // (cFile,lJob,aProc,aErros,lNFeTransp,oFullXML)
Local cXML       := ""
Local cError     := ""
Local cWarning   := ""
Local cCGC	     := ""
Local cTipoNF    := ""
Local cTabEmit   := ""
Local cDoc	     := ""
Local cSerie     := ""
Local cCodigo    := ""
Local cLoja	     := ""
Local cNomeFor   := ""
Local cCampo1    := ""
Local cCampo2    := ""
Local cCampo3    := ""
Local cCampo4    := ""
Local cCampo5    := ""
Local cQuery     := ""
Local cNFECFAP   := SuperGetMV("MV_XMLCFPC",.F.,"")
Local cNFECFBN   := SuperGetMV("MV_XMLCFBN",.F.,"")
Local cNFECFDV   := SuperGetMV("MV_XMLCFDV",.F.,"")
Local lFound     := .F.
Local lProces    := .T.
Local lCFOPEsp   := .T.
Local lDelFile   := .T.
Local nX		 := 0
Local nY		 := 0
Local oAuxXML    := NIL
Local oXML	     := NIL
Local aItens     := {}
Local aTotal     := {}
Local aHeadSDS   := {}
Local aItemSDT   := {}
Local lProdFor	 := .F.
Local cProduto	 := ""
Local lMensExib  := .F.
Local nQuant	 := 0
Local nPrecUni	 := 0
Local nVrCalc	 := 0
Local cCNPJTran  := ""
Local cCodTransp := ""
Local cPlacaTran := ""
Local nPesoLiq   := 0
Local nPesoBruto := 0
Local cTipoFrete := ""
Local aQtdVol	 := {} 
Local aEspVol	 := {} 
// Local cXMLOri	 := ""
Local nHandle	 := 0
Local nLength	 := 0

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
//³Variáveis SIGATMS  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
Local cCGCDes	 	 := ""
Local cQueryDUL	 := ""
Local lIncluiDUL	 := .T.
Local cInsc	 	 	 := ""
Local cInsDes	 	 := ""
Local cMotivo	 	 := ""                                             
Local cSeqEnd	 	 := ""
Local cAliasDUL	 := "" 
Local cChvNfe		 := "" 
Local cDetalhe		 := ""
Local nNumDet		 := 0
Local cPulaLinha	 := CHR(13) + CHR(10)
Local aSm0			 := FWLoadSM0()
Local cStrXML		 := ""
Local aProdutos	 := {}       
Local cUmNfe		 := ''

Private lMsErroAuto := .F.
 lJob   	 := .F.
 aProc  	 := {}
 aErros 	 := {}
 lNFeTransp  := .F.
 oFullXML    := NIL
/*
If !File(DIRXML +DIRALER +cFile)
	If lJob
		aAdd(aErros,{cFile,"Arquivo inexistente.","Não se aplica."}) //#
	Else
		Aviso("Erro","Arquivo " +cFile +" inexistente ",{"OK"},2,"ImpXML_NFe") //##" inexistente."#
	EndIf
	lProces := .F.
Else
	nHandle := FOpen(DIRXML +DIRALER +cFile)
	nLength := FSeek(nHandle,0,FS_END)
	FSeek(nHandle,0)
	If nHandle > 0
		FRead(nHandle, cXMLOri, nLength)
		FClose(nHandle)
		If !Empty(cXMLOri)
			If SubStr(cXMLOri,1,1) != "<"
				nPosPesq := At("<",cXMLOri)
				cXMLOri  := SubStr(cXMLOri,nPosPesq,Len(cXMLOri))		// Remove caracteres estranhos antes da abertura da tag inicial do arquivo
			EndIf
		EndIf         
*/		
		
		cXML := EncodeUtf8(cXMLOri)
		
		// Verifica se o encode ocorreu com sucesso, pois alguns caracteres especiais provocam erro na funcao de encode, neste caso e feito o tratamento pela funcao A140IRemASC
		If Empty(cXML)
			cStrXML := cXMLOri
			cXMLOri := A140IRemASC(cStrXML)
			cXML := EncodeUtf8(cXMLOri)
			If Empty(cXML)
				lProces := .F.
			EndIf
		EndIf
/*
	Else
		aAdd(aErros,{cFile,"Arquivo inexistente.","Não se aplica."}) //#
		lProces := .F.
	EndIf
*/
	//-- Nao processa conhecimentos de transporte
	If !("</NFE>" $ Upper(cXML))
		lProces := .F.
	EndIf
	If lProces
		oFullXML := XmlParser(cXML,"_",@cError,@cWarning)
		//-- Erro na sintaxe do XML
		If Empty(oFullXML) .Or. !Empty(cError)
			If lJob
				aAdd(aErros,{cFile,"Erro de sintaxe no arquivo XML: "+cError," Entre em contato com o emissor do documento e comunique a ocorrência."}) //"Erro de sintaxe no arquivo XML: "#"Entre em contato com o emissor do documento e comunique a ocorrência."
			Else
				Aviso("Erro",cError,{"OK"},2,"ImpXML_NFe") //#
			EndIf			
			lProces := .F.
		Else			
			oXML    := oFullXML
			oAuxXML := oXML			
			//-- Resgata o no inicial da NF-e
			While !lFound
				oAuxXML := XmlChildEx(oAuxXML,"_NFE")
				If !(lFound := oAuxXML # NIL)
					For nX := 1 To XmlChildCount(oXML)
						oAuxXML  := XmlChildEx(XmlGetchild(oXML,nX),"_NFE")
						lFound := oAuxXML:_InfNfe# Nil
						If lFound
							oXML := oAuxXML
							Exit
						EndIf
					Next nX
				EndIf				
				If lFound
					oXML := oAuxXML
					Exit
				EndIf
			EndDo			
			oAuxXml := XmlChildEx(oXml,"_INFNFE")
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Emitente				   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ				
			If XmlChildEx(oAuxXml:_EMIT,"_CNPJ") # NIL
				cCGC := oAuxXml:_EMIT:_CNPJ:TEXT
			Else
				cCGC := oAuxXml:_EMIT:_CPF:TEXT
			EndIf	
			If XmlChildEx(oAuxXml:_EMIT,"_IE") # NIL
				cInsc := oAuxXml:_EMIT:_IE:TEXT
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Destinatario			   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If XmlChildEx(oAuxXml:_DEST,"_CNPJ") # NIL
				cCGCDes := oAuxXml:_DEST:_CNPJ:TEXT
			Else
				cCGCDes := oAuxXml:_DEST:_CPF:TEXT
			EndIf
			If XmlChildEx(oAuxXml:_DEST,"_IE") # NIL
				cInsDes := oAuxXml:_DEST:_IE:TEXT					
			EndIf
	 		If !lNFeTransp
		 		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ04¿
				//³VARRE O NÓ DO XML PARA OBTER INFORMAÇÕES DO REMETENTE E DESTINATARIO ³ 
				//³E VALIDAR SE A NF SERÁ UTILIZADO NO COMPRAS OU NO TMS				³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ04Ù											
		 		cXml:= cCGC+cCGCDes+cInsc+cInsDes
				If !(SM0->M0_CGC $ cCGCDes)					//CONSULTA SE O CNPJ DA FILIAL FAZ PARTE DO DESTINATARIO
					If !(AllTrim(SM0->M0_INSC) $ cInsDes)	//CONSULTA SE A INSC.ESTADUAL DA FILIAL FAZ PARTE DO DESTINATARIO
						//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
						//³ Ponto de entrada para validar se o arquivo deve ser importado   ³
						//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
						If ExistBlock("A140IIMP")
							If !ExecBlock("A140IIMP",.F.,.F.,{oFullXML})
								lProces  := .F.
								lDelFile := .F.
							EndIf
						Else
							//Nao processa XML de outra empresa/filial
							If !lJob
								Aviso("OK","Este XML pertence a outra empresa/filial e não podera ser processado na empresa/filial corrente.",{"Erro"},2,"ImpXML_NFe") //#"" "#
							Else
								lDelFile := .F.
							EndIf
							lProces := .F.
						EndIf
					EndIf
				EndIf
	 		ElseIf AliasIndic("DEV")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¤[¿
				//³IMPORTACAO VIA TMS	³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¤[Ù
				//Se nao existe a tag TRANSPORTA nao fara a importacao e nao movera o arquivo
				If XmlChildEx(oAuxXml:_TRANSP,"_TRANSPORTA") # NIL 
					If XmlChildEx(oAuxXml:_TRANSP:_Transporta,"_CNPJ") # NIL
						cCGCTransp := oAuxXml:_TRANSP:_Transporta:_CNPJ:TEXT
					ElseIf XmlChildEx(oAuxXml:_TRANSP:_Transporta,"_CPF") # NIL
						cCGCTransp := oAuxXml:_TRANSP:_Transporta:_CPF:TEXT					
					EndIf 	                                      
					//Se o Cnpj do Transportor no XML for diferente da filial atual varremos o SM0 para saber de 
					If AllTrim(SM0->M0_CGC) <> AllTrim(cCGCTransp)
						If (nFilImp := (ASCan(aSm0,{|x| x[SM0_CGC] == cCGCTransp })) )>0
							If cEmpAnt == aSm0[nFilImp,SM0_GRPEMP]						
								cFilAnt := 	aSm0[nFilImp,SM0_CODFIL]
							Else
								lProces := lDelFile	:= .F.
							EndIf	   						                  
						Else
							lProces := lDelFile	:= .F.
						EndIf
					EndIf					
				Else
					lProces := lDelFile := .F.				
				EndIf
			Else
				lProces := lDelFile := .F.									
			EndIf
		EndIf
	EndIf
// EndIf
If lProces
	//-- Se tag _InfNfe:_Det valida
	//-- Extrai CGC do fornecedor/cliente
	aItens := IIF(ValType(oXML:_InfNfe:_Det) == "O",{oXML:_InfNfe:_Det},oXML:_InfNfe:_Det)			
	If AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "1"		
		//-- Valida o tipo da nf
		cTipoNF := "N"
		For nX := 1 To Len(aItens)
			If aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFAP
				cTipoNF := "O"
			ElseIf aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFBN
				cTipoNF := "B"
			ElseIf aItens[nX]:_PROD:_CFOP:TEXT $ cNFECFDV
				cTipoNF := "D"
			EndIf
			If cTipoNF <> "N"
				Exit
			EndIf
		Next nX
	ElseIf AllTrim(oXML:_InfNfe:_Ide:_finNFe:Text) == "2" .And. SDS->(FieldPos("DS_VALMERC")) > 0
		cTipoNF := "C"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Verifica se a NF eh compl. de preco ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
		 If Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VPROD:Text) == 0  .And.;
		 	(Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VICMS:Text) > 0 .Or. Val(oXML:_InfNFe:_TOTAL:_ICMSTOT:_VIPI:Text) > 0)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Apaga arquivo XML de Compl. de Preco ICMS/IPI ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			aAdd(aErros,{cFile,"Documento complemento de preço icms/ipi não é tratado.","Gere o documento complementeo de preço icms/ipi de forma manual através da rotina documento de entrada."}) //#"
			lProces	:= .F.
		 EndIf
	Else
		aAdd(aErros,{cFile,"Tipo NF-e de ajustes não será tratado por esta rotina.","Gere o documento de ajustes de forma manual através da rotina documento de entrada."}) //#
		lProces	:= .F.
	EndIf

	//-- Verifica se este ID ja foi processado	
	If !lNFeTransp
		DbSelectArea("SDS")
		SDS->(DbSetOrder(2))
		lFound := SDS->(DbSeek(xFilial("SDS")+Right(AllTrim(oXML:_InfNfe:_Id:Text),44))) // Filial + Chave de acesso
	Else
		DbSelectArea("DEV")
		DEV->(DbSetOrder(1))
		lFound := DEV->(DbSeek(xFilial("DEV")+Right(AllTrim(oXML:_InfNfe:_Id:Text),44))) .And. DEV->DEV_STATUS == '1' // Filial + Chave de acesso
	EndIf
	If lFound
		If lJob .And. !lNFeTransp
			aAdd(aErros,{cFile,"ID de NF-e já registrado na NF " +SDS->(DS_DOC+"/"+DS_SERIE); //"ID de NF-e já registrado na NF "
			+" do fornecedor " +Posicione("SA2",1,xFilial("SA2")+SDS->(DS_FORNEC+DS_LOJA),"A2_NOME"); //" do fornecedor "
			+" (" +SDS->(DS_FORNEC +"/" +DS_LOJA)+ ").","Exclua o documento registrado na ocorrência."}) //"Exclua o documento registrado na ocorrência."
		ElseIf lJob                                                
			cChvNfe	:= Right(AllTrim(oAuxXml:_ID:TEXT),44)
			cMotivo  := "ID de NF-e já registrado na NF "
			nNumDet  += 1
			cDetalhe += Str(nNumDet,1)+("º " + "ID de NF-e já registrado na NF " +DEV->(DEV_DOC+"/"+DEV_SERIE) +". CNPJ :" + " (" +DEV->DEV_CGCREM+ ")." )+ cPulaLinha //--"Erro: "//--"O Cliente Emitente não está cadastrado.//-- Favor cadastrá-lo!"
			aAdd(aErros,{cFile,"ID de NF-e já registrado na NF " +DEV->(DEV_DOC+"/"+DEV_SERIE); //"ID de NF-e já registrado na NF "
			+" o CNPJ :" + " (" +DEV->DEV_CGCREM+ ").","Exclua o documento registrado na ocorrência."})//"Do Cliente # //"Exclua o documento registrado na ocorrência."			
		Else
			Aviso("Erro",'Documento: ' +SDS->(DS_DOC+"/"+DS_SERIE);
			+ ' do Fornecedor' +SDS->(DS_FORNEC+"/"+DS_LOJA) +".",{"OK"},2,"ImpXML_NFe")
			lMensExib := .T.
		EndIf
		lProces	:= .F.
	EndIf	
	
	cDoc     := StrZero(Val(AllTrim(oXML:_InfNfe:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
	cSerie   := PadR(oXML:_InfNfe:_Ide:_Serie:Text,TamSX3("F1_SERIE")[1])
	
	If !lNFeTransp .And. lProces
		//-- Se tag CGC valida
		//-- Busca fornecedor/cliente na base
		cTabEmit := If (Empty(cTabEmit),If(cTipoNF $ "DB","SA1","SA2"),cTabEmit)
		(cTabEmit)->(dbSetOrder(3)) 	
		If (cTabEmit)->(dbSeek(xFilial(cTabEmit)+cCGC))
			cCodigo := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_COD")
			cLoja   := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_LOJA")
			cNomeFor := (cTabEmit)->&(Substr(cTabEmit,2,2)+"_NOME")
		Else
			If !(XFunInc(oAuxXml,1,,,@cMotivo,@nNumDet,@cDetalhe))	//Inclui o Cliente - Destinatario
				aAdd(aErros,{cFile,"Não foi possível incluir o destinatário.","Inclua-o  manualmente."})
				lProces := .F.
			EndIf

			If lJob
				aAdd(aErros,{cFile,IIF(cTipoNF $ "DB", "Fonecedor/Cliente" +oXML:_INFNFE:_EMIT:_XNOME:Text, "inexistente na base." +oXML:_INFNFE:_EMIT:_XNOME:Text) +" [" + Transform(cCGC,"@R 99.999.999/9999-99") +"] "+ IIF(cTipoNF $ "DB","Gere cadastro para este fornecedor/cliente.",STR0109),STR0110}) //##
			ElseIf !lMensExib
				Aviso("Erro",If(cTipoNF $ "DB","Fonecedor/Cliente","inexistente na base.") + ' CNPJ ' + Transform(cCGC,"@R 99.999.999/9999-99") +STR0091,{'OK'},2,"ImpXML_NFe")
				lMensExib := .T.				
			EndIf
			lProces := .F.
		EndIf
	ElseIf lProces
		cChvNfe	:= Right(AllTrim(oAuxXml:_ID:TEXT),44)
		SA1->(dbSetOrder(3))             			
		//--Verifica se o Emitente está cadastrado como Cliente caso não esteja a importação não ocorrerá
		If !SA1->(dbSeek(xFilial('SA1')+AllTrim(cCGC)))
			cMotivo  := "Cliente Emitente"
			nNumDet  += 1
			cDetalhe += Str(nNumDet,1)+("º " + "Erro: " + '"O Cliente Emitente não está cadastrado.' + "Favor cadastrá-lo!") + cPulaLinha //--//--//-- 
			aAdd(aErros,{cFile, "O Cliente Emitente não está cadastrado: "+ ": " + oXML:_INFNFE:_EMIT:_XNOME:Text +" [" + Transform(cCGC,"@R 99.999.999/9999-99") +"] ", "Inclua-o Emitente manualmente."})  //-- //--
			lProces := .F.
		Else		
			cCodigo 	:= ("SA1")->&(Substr("SA1",2,2)+"_COD")
			cLoja   	:= ("SA1")->&(Substr("SA1",2,2)+"_LOJA")
			cNomeFor := ("SA1")->&(Substr("SA1",2,2)+"_NOME")	
	   EndIf	   	   	   
   		//--Verifica se o Destinatário está cadastrado como Cliente caso não esteja cadastraremos
		If !SA1->(dbSeek(xFilial('SA1')+AllTrim(cCGCDes)))
			If !(XFunInc(oAuxXml,1,,,@cMotivo,@nNumDet,@cDetalhe))	//Inclui o Cliente - Destinatario
				aAdd(aErros,{cFile,"Não foi possível incluir o destinatário.","Inclua-o  manualmente."}) // //"#
				lProces := .F.
			EndIf
		EndIf		
		//Se existir TAG ENTREGA
		If XmlChildEx(oAuxXml,"_ENTREGA") # NIL
			DUL->(dbSetOrder(2))
			SA1->(dbSeek(xFilial('SA1')+AllTrim(cCGC)))
			If !(DUL->(dbSeek(xFilial("DUL")+SA1->(A1_COD+A1_LOJA))))
				If !(XFunInc(oAuxXml,2,,,@cMotivo,@nNumDet,@cDetalhe))
					aAdd(aErros,{cFile,"Não foi possível incluir o local de entrega","Inclua-o  manualmente."}) //#//
					lProces := .F.					
				EndIf
			Else
				//SE EXISTIR DUL VERIFICAREMOS SE O ENDERECO ESTA ATUALIZADO
				cAliasDUL := GetNextAlias()
				cQueryDUL := "SELECT DUL_END,DUL_BAIRRO, DUL_MUN, DUL_EST, DUL_SEQEND "
				cQueryDUL += " FROM " + RetSqlName("DUL")+ " DUL "
				cQueryDUL += " WHERE "
				cQueryDUL += " DUL_FILIAL = '"+xFilial("DUL")+"' AND "
				cQueryDUL += " DUL_CODCLI = '"+SA1->A1_COD+"' AND "
				cQueryDUL += " DUL_LOJCLI = '"+SA1->A1_LOJA+"' AND "
				cQueryDUL += " DUL.D_E_L_E_T_ = ' ' "
				
				cQueryDUL := ChangeQuery(cQueryDUL)
				DbUseArea(.T., "TOPCONN", TCGenQry(,,cQueryDUL),cAliasDUL, .T., .T.)

				(cAliasDUL)->(DbGoTop())
				While (cAliasDUL)->(!Eof()) // (01)//While !cAliasDUL->(EOF())
					If AllTrim(oAuxXml:_ENTREGA:_XLGR:TEXT) $ AllTrim((cAliasDUL)->DUL_END)
						lIncluiDUL := .F.
						Exit
					EndIf
					(cAliasDUL)->(dbSkip())
				End
				//CASO O ENDEREÇO NÃO ESTEJA ATUALIZADO CRIAREMOS UM NOVO DUL
				If lIncluiDUL
					If !(XFunInc(oAuxXml,2,,,@cMotivo,@nNumDet,@cDetalhe,@cSeqEnd))
						aAdd(aErros,{cFile,"Não foi possível atualizar o local de entrega","Atualize-o manualmente."}) //#
						lProces := .F.
					EndIf
				Else
					cSeqEnd := 	(cAliasDUL)->DUL_SEQEND
				EndIf
				(cAliasDUL)->(dbCloseArea())
			EndIf
		EndIf	
   EndIf
	/* ----------------------------------------------------------------------
	SE FOR PARA O EDI TEREMOS QUE AMARRAR COM O CLIENTE  OU COM EMBARCADOR
	------------------------------------------------------------------------*/
	If cTipoNF $ "DB" .Or. lNFeTransp
		cCampo1 := "A7_PRODUTO"
		cCampo2 := "A7_FILIAL"
		cCampo3 := "A7_CLIENTE"
		cCampo4 := "A7_LOJA"
		cCampo5 := "A7_CODCLI"
		If lNFeTransp
			cCampo6 := "DE7_CODPRO"
			cCampo7 := "DE7_FILIAL"
			cCampo8 := "DE7_CODCLI"
			cCampo9 := "DE7_LOJCLI"
			cCampo10:= "DE7_PRDEMB"
		EndIf				
	Else                                        
		//-- Processa cabeçalho e itens
		cCampo1 := "A5_PRODUTO"
		cCampo2 := "A5_FILIAL"
		cCampo3 := "A5_FORNECE"
		cCampo4 := "A5_LOJA"
		cCampo5 := "A5_CODPRF"
	EndIf	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o tipo do frete ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	Do Case 
		Case AllTrim(oXML:_InfNfe:_Transp:_ModFrete:Text) == "0"
			cTipoFrete := "C"
		Case AllTrim(oXML:_InfNfe:_Transp:_ModFrete:Text) == "1"
			cTipoFrete := "F"
		Case AllTrim(oXML:_InfNfe:_Transp:_ModFrete:Text) == "2"
			cTipoFrete := "T"			
		Case AllTrim(oXML:_InfNfe:_Transp:_ModFrete:Text) == "3"
			cTipoFrete := "S"
	End Case
	If !lNFeTransp .And. lProces
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os Dados da DANFE ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cCNPJTran  := ""
		cCodTransp := ""
		cPlacaTran := ""
		nVolume    := 0
		cEspecie   := ""
		nPesoLiq   := 0
		nPesoBruto := 0
					
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Prepara o Array aEspVol para gravar os campos Vol/Esp ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aAdd(aEspVol,{"DS_ESPECI1",""})
		aAdd(aEspVol,{"DS_ESPECI2",""})
		aAdd(aEspVol,{"DS_ESPECI3",""})
		aAdd(aEspVol,{"DS_ESPECI4",""})
		aAdd(aEspVol,{"DS_VOLUME1",0})
		aAdd(aEspVol,{"DS_VOLUME2",0})
		aAdd(aEspVol,{"DS_VOLUME3",0})
		aAdd(aEspVol,{"DS_VOLUME4",0})				
		If ValType(XmlChildEx(oXML:_InfNFe,"_TRANSP")) == "O" 			
			If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_TRANSPORTA")) == "O"
				If ValType(XmlChildEx(oXML:_InfNFe:_Transp:_Transporta,"_CPF")) == "O"
					cCNPJTran := oXML:_InfNfe:_Transp:_Transporta:_CPF:Text	
				ElseIf ValType(XmlChildEx(oXML:_InfNFe:_Transp:_Transporta,"_CNPJ")) == "O"
					cCNPJTran := oXML:_InfNfe:_Transp:_Transporta:_CNPJ:Text
				EndIf
				SA4->(dbSetOrder(3))
				If SA4->(dbSeek(xFilial("SA4")+cCNPJTran))
					cCodTransp := SA4->A4_COD
				EndIf
			EndIf
			If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VEICTRANSP")) == "O"
				If ValType(XmlChildEx(oXML:_InfNFe:_Transp:_VeicTransp,"_PLACA")) == "O"
					cPlacaTran := oXML:_InfNFe:_Transp:_VeicTransp:_Placa:Text
				EndIf
			EndIf
			If ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VOL")) == "O"
				aQtdVol := {oXML:_InfNfe:_Transp:_Vol}
			ElseIf ValType(XmlChildEx(oXML:_InfNFe:_Transp,"_VOL")) == "A"
				aQtdVol := oXML:_InfNfe:_Transp:_Vol
			EndIf
			For nX := 1 To Len(aQtdVol)
				If ValType(XmlChildEx(aQtdVol[nX],"_PESOB")) == "O"
					nPesoBruto += Val(aQtdVol[nX]:_PESOB:TEXT)
				EndIf
				If ValType(XmlChildEx(aQtdVol[nX],"_PESOL")) == "O"
					nPesoLiq += Val(aQtdVol[nX]:_PESOL:TEXT)
				EndIf
				If nX <= 4
					If ValType(XmlChildEx(aQtdVol[nX],"_ESP")) == "O"
						aEspVol[nX][2] := aQtdVol[nX]:_Esp:TEXT
					EndIf
					If ValType(XmlChildEx(aQtdVol[nX],"_QVOL")) == "O"
						aEspVol[nX+4][2] := Val(aQtdVol[nX]:_QVol:TEXT)
					EndIf
				EndIf
			Next nX
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava os Dados do Cabecalho - SDS  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("SDS")
		 AADD(aHeadSDS,{{"DS_FILIAL"	,xFilial("SDS")																	    },; //Filial
						    {"DS_CNPJ"		,cCGC																			},; //CGC
						    {"DS_DOC"		,cDoc 																			},; //Numero do Documento
						    {"DS_SERIE"		,cSerie 																		},; //Serie
						    {"DS_FORNEC"	,cCodigo																		},; //Fornecedor
						    {"DS_LOJA"		,cLoja 																			},; //Loja do Fornecedor
						    {"DS_NOMEFOR"	,cNomeFor																		},; //Nome do Fornecedor
						    {"DS_EMISSA"	,StoD(StrTran(AllTrim(oXML:_InfNfe:_Ide:_DHEMI:Text),"-",""))			   		},; //Data de Emissão
						    {"DS_EST"		,oXML:_INFNFE:_EMIT:_ENDEREMIT:_UF:TEXT											},; //Estado de emissao da NF
						    {"DS_TIPO"		,cTipoNF													 					},; //Tipo da Nota
						    {"DS_FORMUL"	,"N" 																		 	},; //Formulario proprio
						    {"DS_ESPECI"	,"SPED"																		  	},; //Especie
						    {"DS_ARQUIVO"	,AllTrim(cFile)																   	},; //Arquivo importado
						    {"DS_STATUS"	,If(cTipoNF <> "N",cTipoNF," ")													},; //Status
						    {"DS_CHAVENF"	,Right(AllTrim(oXML:_InfNfe:_Id:Text),44)										},; //Chave de Acesso da NF
						    {"DS_VERSAO"	,oXML:_InfNfe:_versao:text 														},; //Versão
						    {"DS_USERIMP"	,IIf(!lJob,cUserName,'JOB')  													},; //Usuario na importacao
						    {"DS_DATAIMP"	,dDataBase																		},; //Data importacao do XML
						    {"DS_HORAIMP"	,SubStr(Time(),1,5)																},; //Hora importacao XML
						    {"DS_FRETE"		,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vFrete:TEXT)									},; //Valor Frete
						    {"DS_SEGURO"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vSeg:TEXT)									},; //Valor Seguro
						    {"DS_DESPESA"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vOutro:TEXT)									},; // Valor Desconto
						    {"DS_DESCONTO"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vDesc:TEXT)									},; // Valor Desconto
						    {"DS_VALMERC"	,Val(oXML:_INFNFE:_TOTAL:_ICMSTOT:_vProd:TEXT)									},; // Valor Mercadoria
						    {"DS_TPFRETE"	,cTipoFrete																		},; // Tipo de Frete
						    {"DS_TRANSP"	,cCodTransp																		},; // Codigo da Transportadora
						    {"DS_PLACA"		,cPlacaTran																		},; // Placa
						    {"DS_PLIQUI"	,nPesoLiq																		},; // Peso Liquido
						    {"DS_PBRUTO"	,nPesoBruto																		},; // Peso Bruto
						    {"DS_ESPECI1"	,cValToChar(aEspVol[1][2])														},; // Especie1
							{"DS_VOLUME1"	,aEspVol[5][2]																	},; // Volume1
							{"DS_ESPECI2"	,cValToChar(aEspVol[2][2])														},; // Especie2
							{"DS_VOLUME2"	,aEspVol[6][2]																	},; // Volume2
							{"DS_ESPECI3"	,cValToChar(aEspVol[3][2])														},; // Especie3
							{"DS_VOLUME3"	,aEspVol[7][2]																	},; // Volume3
						   {"DS_ESPECI4"	,cValToChar(aEspVol[4][2])														},; // Especie4
							{"DS_VOLUME4"	,aEspVol[8][2]																	}}) // Volume4
			
	EndIf
	If lProces
		IIF(cTipoNF $ "DB",SA7->(DbSetOrder(1)),SA5->(DbSetOrder(1)))
		For nX := 1 To Len(aItens)
			//-- Ponto de entrada para cutomizacao da identificacao do produto
			If ExistBlock("A140IPRD")
				cProduto := ExecBlock("A140IPRD",.F.,.F.,{cCodigo,cLoja,AllTrim(aItens[nX]:_Prod:_cProd:Text),aItens[nX],IIf(cTipoNF $ "DB","SA7","SA5")})
				SB1->(DbSetOrder(1))
				If ValType(cProduto) # "C" .Or. !SB1->(dbSeek(xFilial("SB1")+cProduto))
					cProduto := ""
				EndIf
			EndIf
			If Empty(cProduto)			
				#IFDEF TOP
				
					If lNFeTransp //--Se for importacao do SIGATMS verifica primeiro a tabela DE7 (Produto x Embarcador)
						cQuery := "SELECT " +cCampo6 + " FROM " +RetSqlName("DE7")
						cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
						cQuery += cCampo7 +" = '" +xFilial("DE7") +"' AND "
						cQuery += cCampo8 +" = '" +cCodigo +"' AND "
						cQuery += cCampo9+" = '" +cLoja +"' AND "
						cQuery += cCampo10+" = '" +AllTrim(UPPER(aItens[nX]:_Prod:_cProd:Text)) +"' AND "
						cQuery += cCampo6 +" <> ' '"					
						
						If Select("TRB") > 0
							TRB->(dbCloseArea())
						EndIf        					
						TcQuery cQuery new Alias "TRB"            
					   If !TRB->(EOF())
							cProduto := TRB->(&cCampo6)
						EndIf
					EndIf
					If !lNFeTransp .Or. Empty(cProduto)
						cQuery := "SELECT " +cCampo1 + " FROM " +RetSqlName(If(cTipoNF $ "DB" .Or. lNFeTransp,"SA7","SA5"))
						cQuery += " WHERE D_E_L_E_T_ <> '*' AND "
						cQuery += cCampo2 +" = '" +xFilial(If(cTipoNF $ "DB","SA7","SA5")) +"' AND "
						cQuery += cCampo3 +" = '" +cCodigo +"' AND "
						cQuery += cCampo4 +" = '" +cLoja +"' AND "
						cQuery += cCampo5 +" = '" +AllTrim(UPPER(aItens[nX]:_Prod:_cProd:Text)) +"' AND "
						cQuery += cCampo1 +" <> ' '"
						
						//		cCampo1 := "A5_PRODUTO"
						//		cCampo2 := "A5_FILIAL"
						//		cCampo3 := "A5_FORNECE"
						//		cCampo4 := "A5_LOJA"
						//		cCampo5 := "A5_CODPRF"
					    					
						If Select("TRB") > 0
							TRB->(dbCloseArea())
						EndIf        
						
						TcQuery cQuery new Alias "TRB"
					             
					   If !TRB->(EOF())
							cProduto := TRB->(&cCampo1)
						ElseIf !lNfeTransp 
							If lJob
								aAdd(aErros,{cFile,IIF(cTipoNF $ "DB","Fornecedor ",'Cliente') + oXML:_INFNFE:_EMIT:_XNOME:Text +" [" +Transform(cCGC,"@R 99.999.999/9999-99")+"]"; //
												+IIF(cTipoNF $ "DB"," sem cadastro de Produto X Fornecedor",STR0111); //
												+" para o código " +AllTrim(aItens[nX]:_Prod:_cProd:Text) +".","Gere cadastro para esta relação."}) //#
							Else
								If !lMensExib
									/*
									Aviso("Erro",IIF(cTipoNF $ "DB","Fornecedor",'Cliente') + oXML:_INFNFE:_EMIT:_XNOME:Text +" [" +Transform(cCGC,"@R 99.999.999/9999-99")+"]" ; //#
															+IIF(cTipoNF $ "DB"," sem cadastro de Produto X Fornecedor",STR0111); //
															+" para o código " +AllTrim(aItens[nX]:_Prod:_cProd:Text) +".",{"OK"},2,"ImpXML_NFe") //
									lMensExib := .T.
									*/
								EndIf
							EndIf											
							lProces := .T.
							cProduto := ""
						EndIf
					EndIf	
				#ELSE
					aStruTRB := {}
					AADD(aStruTRB,{ "PRODUTO","C",15,0})
		
					clArqSQL := CriaTrab(aStruTRB, .T.)			
					DbUseArea(.T.,,clArqSQL,"TRB",.F.,.F.)
					dbSelectArea("TRB")
	
					lProdFor := .F.									
					While SA5->(!EOF()) .AND. SA5->(A5_FILIAL+A5_FORNECE+A5_LOJA) == xFilial("SA5")+cCodigo+cLoja
						If SA5->A5_CODPRF == AllTrim(aItens[nX]:_Prod:_cProd:Text)
							lProdFor := .T.	
							Exit
						EndIf
						SA5->(DbSkip())
					EndDo
	                    
	    			If lProdFor
						TRB->(MsUnLock())
					ElseIf !lNfeTransp
						If lJob
							aAdd(aErros,{cFile,IIF(cTipoNF $ "DB","Fornecedor ",'Cliente') + oXML:_INFNFE:_EMIT:_XNOME:Text +" [" +Transform(cCGC,"@R 99.999.999/9999-99")+"]"; //
													+IIF(cTipoNF $ "DB"," sem cadastro de Produto X Fornecedor",STR0111); //
													+ " para o código " +AllTrim(aItens[nX]:_Prod:_cProd:Text) +".","Gere cadastro para esta relação."}) //"#						
						ElseIf !lMensExib
							/*
							Aviso("Erro",IIF(cTipoNF $ "DB","Fornecedor",'Cliente') + oXML:_INFNFE:_EMIT:_XNOME:Text +" [" +Transform(cCGC,"@R 99.999.999/9999-99")+"]";//"Erro"#
													+IIF(cTipoNF $ "DB"," sem cadastro de Produto X Fornecedor",STR0111); //
													+" para o código " +AllTrim(aItens[nX]:_Prod:_cProd:Text) +".",{"OK"},2,"ImpXML_NFe") //
							lMensExib := .T.
							*/
						EndIf
						lProces := .F.
					EndIf				
				#ENDIF				
				TRB->(dbCloseArea())
			EndIf
			nQuant := Val(aItens[nX]:_Prod:_qCom:Text)
			nPrecUni := Val(aItens[nX]:_Prod:_vUnCom:Text)
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se Unid. Medida foi preenchida na relacao Prod. x Forn. ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					
			If !lNFeTransp .And. lProces
				If cTipoNF == "N"
					If SA5->(DbSeek(xFilial("SA5")+cCodigo+cLoja+cProduto)) .And. SA5->A5_UMNFE == "2"
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek(xFilial("SB1")+cProduto))
							nPrecUni := If(SB1->B1_TIPCONV == "M", (nPrecUni*SB1->B1_CONV), (nPrecUni/SB1->B1_CONV))
						EndIf
					EndIf
				ElseIf cTipoNF == "D"
					If SA7->(DbSeek(xFilial("SA7")+cCodigo+cLoja+cProduto)) .And. SA7->A7_UMNFE == "2"
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
						SB1->(dbSetOrder(1))
						If SB1->(dbSeek(xFilial("SB1")+cProduto))
							nPrecUni := If(SB1->B1_TIPCONV == "M", (nPrecUni*SB1->B1_CONV), (nPrecUni/SB1->B1_CONV))
						EndIf
					EndIf	
				EndIf							
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe a Tag para os valores de frete/seguro/despesa³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nFretItem  := 0
				nDespItem  := 0
				nSegItem   := 0    
				nDescItem  := 0
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VFRETE")) == "O"
					nFretItem := Val(aItens[nX]:_Prod:_vFrete:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VOUTRO")) == "O"
					nDespItem := Val(aItens[nX]:_Prod:_vOutro:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VSEG")) == "O"
					nSegItem := Val(aItens[nX]:_Prod:_vSeg:Text)
				EndIf
				If ValType(XmlChildEx(aItens[nX]:_Prod,"_VDESC")) == "O"
					nDescItem := Val(aItens[nX]:_Prod:_vDesc:Text)
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Dados dos Itens - SDT	   ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				DbSelectArea("SDT")
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³  DADOS DO PRODUTO      ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                                     
		    	     aAdd(aItemSDT,{{"DT_FILIAL" 	,xFilial("SDT")														},; //Filial
									{"DT_CNPJ"		,cCGC																},; //CGC
						 			{"DT_COD"		,cProduto															},; //Codigo do produto
						 			{"DT_PRODFOR"	,aItens[nX]:_PROD:_CPROD:TEXT										},; //Cdgo do pduto do Fornecedor
					 				{"DT_DESCFOR"	,aItens[nX]:_PROD:_XPROD:TEXT										},; //Dcao do pduto do Fornecedor
					 				{"DT_ITEM"   	,PadL(aItens[nX]:_nItem:Text,TamSX3("D1_ITEM")[1],"0")				},; //Item
					 				{"DT_QUANT"  	,IIF(cTipoNF == "C",0,nQuant)										},; //Qtde
						 			{"DT_VUNIT"		,IIF(cTipoNF == "C",Val(aItens[nX]:_Prod:_vProd:Text),nPrecUni)	},; //Vlor Unitário
						 			{"DT_FORNEC"	,cCodigo															},; //Forncedor
						 			{"DT_LOJA"   	,cLoja																},; //Lja
							 		{"DT_DOC"    	,cDoc																},; //DocmTo
					 				{"DT_SERIE"		,cSerie							   									},; //Serie
					 				{"DT_VALFRE"	,nFretItem															},; //Valor Frete
					 				{"DT_DESPESA"	,nDespItem							   								},; //Valor Despesa
					 				{"DT_SEGURO"	,nSegItem								  							},; //Valor Seguro
					 				{"DT_VALDESC"	,nDescItem															},; //Valor Desconto
					 				{"DT_TOTAL"		,IIF(cTipoNF == "C",Val(aItens[nX]:_Prod:_vProd:Text),(nQuant * nPrecUni))}}) //Vlor Total
				 			 				
	  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	  		//³ LIMPA O CODIGO DO PRODUTO PARA QUE SEJA CARREGADO PELA QUERY ³
	   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProduto := ""
			ElseIf lProces						
				SA7->(DbSetOrder(1))
				DE7->(DbSetOrder(1))
				If SA7->(DbSeek(xFilial("SA7")+cCodigo+cLoja+cProduto))
					cUmNfe := SA7->A7_UMNFE 
					If SA7->A7_UMNFE == "2"
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
					EndIf	
				ElseIf DE7->(DbSeek(xFilial("DE7")+cCodigo+cLoja+cProduto)) .And. DE7->DE7_UMNFE == "2"
					cUmNfe := DE7->DE7_UMNFE 
					If DE7-DE7_UMNFE == "2" 
						nQuant := ConvUM(cProduto,Val(aItens[nX]:_Prod:_qCom:Text),Val(aItens[nX]:_Prod:_qCom:Text),1)
					EndIf	
				EndIf	                                                      				
				AAdd(aProdutos,{cProduto,aItens[nX]:_Prod:_uCom:Text,nQuant,Val(oXML:_InfNfe:_Det[nX]:_PROD:_vPROD:Text),cUmNfe})
		  		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		  		//³ LIMPA O CODIGO DO PRODUTO PARA QUE SEJA CARREGADO PELA QUERY ³
	   		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				cProduto := ""
			EndIf    
		Next nX 
		If lNFeTransp .And. lProces
			If !(XFunInc(oXml,3,aProdutos,aItens[1]:_PROD:_CFOP:TEXT,@cMotivo,@nNumDet,@cDetalhe,cSeqEnd))
				lProces := .F.
				aAdd(aErros,{cFile,cDetalhe,"Verifique as informações da Nf-e."}) //
			EndIf	
		EndIf	
    EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Grava os dados do cabeçalho e itens da nota importada do XML³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lProces  .And. !lNFeTransp
		Begin Transaction
		
		aHeadSDS:=aHeadSDS[1]
		//--Grava cabeçalho
		RecLock("SDS",.T.)
		For nX:=1	To Len(aHeadSDS)
			SDS->&(aHeadSDS[nX][1]):= aHeadSDS[nX][2]
		Next
		dbCommit()
		MsUnlock()
		//--Grava Itens
		For nX:=1 To Len(aItemSDT)
			RecLock("SDT",.T.)
			For nY:=1 To Len(aItemSDT[nX])
				SDT->&(aItemSDT[nX][nY][1]):= aItemSDT[nX][nY][2]
			Next
			dbCommit()
			MsUnlock()
		Next
	
		//-- Move arquivo para pasta dos processados	
		//Copy File &(DIRXML+DIRALER+cFile) To &(DIRXML+DIRLIDO+cFile)
		//FErase(DIRXML+DIRALER+cFile)	
		aAdd(aProc,{cDoc,cSerie,cNomeFor})
		
		End Transaction
	ElseIf lProces
		//-- Move arquivo para pasta dos processados	pelo SIGATMS
		//Copy File &(DIRXML+DIRALER+cFile) To &(DIRXML+DIRLIDO+cFile)
		//FErase(DIRXML+DIRALER+cFile)
	
		aAdd(aProc,{cDoc,cSerie,Posicione("SA1",1,xFilial("SA1")+cCodigo+cLoja,"A1_NOME")})		
	EndIf

	//-- Ponto de entrada para ajustes apos a inclusao dos dados na tabela SDS e SDT.
	If ExistBlock("A140IGRV")
		ExecBlock("A140IGRV",.F.,.F.,{cDoc,cSerie,cCodigo,cLoja})
	EndIf   
EndIf	

If lNFeTransp .And. !Empty(cDetalhe)
	TMSAE80GRV(cFile,cChvNfe,cDoc,cSerie,cCGC,cMotivo,cDetalhe)
EndIf

If !lProces .And. lDelFile
	//-- Move arquivo para pasta dos erros
	//Copy File &(DIRXML+DIRALER+cFile) To &(DIRXML+DIRERRO+cFile)
	//FErase(DIRXML+DIRALER+cFile)
EndIf

Return lProces

User FuncTIon A140IIMP
Local l_Ret := .T.

Return(l_Ret)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AT140ILege³Autor  ³Rodrigo Toledo	Silva   ³ Data ³11.07.2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Esta rotina monta uma dialog com a descricao das cores da   ³±±
±±³          ³ Mbrowse.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ AT140ILege()                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nil														   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MATA140I                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function AT140ILege()     
Local aCores 	 := {}
Local aA140ILege := {}

aAdd(aCores,{"BR_VERDE"	,STR0012})
aAdd(aCores,{"BR_AZUl",	STR0072})
If SDS->(FieldPos("DS_VALMERC")) > 0
	aAdd(aCores,{"BR_AMARELO" ,'Status D'})
	aAdd(aCores,{"BR_CINZA"   ,'Status B'})
	aAdd(aCores,{"BR_PINK"    ,'Status C'}) 
	aAdd(aCores,{"BR_VERMELHO",STR0013})
	aAdd(aCores,{"BR_PRETO"   ,'Nao Gerada'})   
EndIf

If ExistBlock("A140ILeg")
	aA140ILege:=ExecBlock("A140ILeg",.F.,.F.,{aCores})
	If ValType(aA140ILege) == "A"
		aEval(aA140ILege,{|x| aAdd(aCores,x)})
	EndIf
EndIf

BrwLegenda(STR0007,STR0008,aCores)
												   	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ AT140IMarc ³ Autor ³Rodrigo Toledo		³ Data ³19.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Marca todas as linhas com evento de clique no cabeçalho da ³±±
±±³			 ³ browse.											     	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ AT140IMarc()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ NIL														  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA140I                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function AT140IMarc(aArquivo,oBrowse)

If aScan(aArquivo, {|x| !x[1] .And. x[2] <> "P"}) > 0	
	aEval(@aArquivo, {|x| IF(x[2] <> "P", x[1] := .T., x[1] := .F.)})
Else
	aEval(@aArquivo, {|x| x[1] := .F.})
EndIf

oBrowse:Refresh()

Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    | SelCor     ³Autor  ³Francisco Godinho      ³Data  ³19/10/09      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o |Funcao retorna objeto com cor do farol                            ³±± 
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³clStatus = Status do registro (SDT->DT_STATUS)                    ³±±  
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±        
±±³Retorno   ³olCor = LoadBitmap(GetResources(),'COR')                          ³±±    
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±       
±±³ Uso      ³	MontaBrw                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±       
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±      
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ*/  
User Function SelCor(clStatus,nRecno)
Local olCor  := NIL	
Local cCor	 := ""
Default nRecno := 0

If clStatus == 'P'
 	olCor:=LoadBitmap(GetResources(),'BR_VERMELHO')
ElseiF clStatus == 'O'
	olCor:=LoadBitmap(GetResources(),'BR_AZUL')
ElseiF clStatus == 'D'
	olCor:=LoadBitmap(GetResources(),'BR_AMARELO')
ElseiF clStatus == 'B'
	olCor:=LoadBitmap(GetResources(),'BR_CINZA')	
ElseiF clStatus == 'C'
	olCor:=LoadBitmap(GetResources(),'BR_PINK')
ElseiF clStatus == 'E'
	olCor:=LoadBitmap(GetResources(),'BR_PRETO')
Else
	olCor:=LoadBitmap(GetResources(),'BR_VERDE')	
EndIf

If ExistBlock("A140ICor")
	SDS->(DbGoTo(nRecno))	
	cCor:=ExecBlock("A140ICor",.F.,.F.)
	If ValType(aCor) == "C"
		olCor:=LoadBitmap(GetResources(),cCor)
	EndIf
EndIf
	
Return olCor


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ A140ITudOk ³ Autor ³Francisco Godinho    ³ Data ³11.07.2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Validacao dos arquivos de retornos recebidos do NeoGrid    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ A140ITudOk()		                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ False caso ocorra algum problema na Valida‡„o, True C.C.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATA140I                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function A140ITudOk(nlOpc)
Local lRet  := .T.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Execblock A140ITudOk para validacao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If lRet
	If ExistBlock("A140ITOk")
		lRet:=ExecBlock("A140ITOk",.F.,.F.)
	EndIf
EndIf

Return lRet


//------------------------------------------------------------
/*	Monta Array e chama a ExecAuto de Cliente e NotaFiscal-EDi
{Protheus.doc} XFunInc
@author  	Francisco Godinho
@version 	P11 R1.7                                  

@param 		oXml		Objeto com o Parser do XML da NF do Cliente
@param		nTipo 	Tipo de Cliente que sera cadastrado:
							1 - Destinatário
							2 - Local de Entrega
							3 - EDI Nota Fiscal do Cliente
@param		aProdutos 1ªPosicao : Codigo Produtoo
							 2ªPosicao : Codigo Embalagem (Unidade de Medida)
							 3ªPosicao : Quantidade Volume (Quantidade Produto)
							 4ªPosicao : Valor do Produto
							 5ªPosicao : Unidade de medida utilizada no Produto
@param		cCFoP   	CFOP do Primeiro Produto 
@param		cMotivo 	Motivo do Erro na Importacao da NFe
@param		cSerie   Numero do Detalhe do Erro
@param		cProduto Detalhe do Erro na Importacao da NFe

@build		7.00.111010P
@since 		15/06/2012
@return 	Nil										  	  				*/
//----------------------------------------------------------
Static Function XFunInc(oXml,nTipo,aProdutos,cCFOP,cMotivo,nNumDet,cDetalhe,cSeqEnd)

Local aArea			:= GetArea()
Local nCount  		:= 0		
Local aHeadSA1		:= {}   
Local aHeadDUL 	:= {}                      
Local aHeadDE5 	:= {}    
Local cEndereco	:= ""
Local lRet			:= .T.
Local oXmlDes		:= Nil   
Local oXmlRem		:= Nil   
Local cCGCRem		:= ""
Local cCGCDes		:= ""
Local oAuxXML		:= Nil  
Local cCdrDes		:= ""      
Local cTpFrete 	:= ""
Local aColsDE5 	:= {}
Local aItemDE5		:= {}
Local nOpcx			:= 3                     
Local nX		   	:= 0
Local nTamProd 	:= 0
Local cCGCDev  	:= ""
Local cCliDev  	:= ""
Local cLojDev		:= ""                                   
Local aItContrat 	:= ''                         
Local cProGen		:= SuperGetMV('MV_PROGEN',.F.,"")
Local cCodPro		:= ''
Local	cCodEmb 		:= ''
Local	nQtdVol 		:= 0
Local nPosPro		:= 0					
Local nVlrPrd		:= 0

Private lAutoErrNoFile	:= .T.
Private lMsErroAuto		:= .F.

Default oXml 		:= Nil
Default nTipo 		:= 1
Default cCFOP 		:= ""
Default cMOtivo	:= ""
Default cDetalhe	:= ""                  
Default cSeqEnd	:= ""
Default nNumDet	:= 0
Default aProdutos := {}

If nTipo == 1                                      
	oXml 		:= XmlChildEx(oXml,"_DEST")	
	oAuxXml 	:= XmlChildEx(oXml,"_ENDERDEST")  
ElseIf nTipo == 2                         
	oAuxXml	:= XmlChildEx(oXml,"_EMIT")
	oXml		:= XmlChildEx(oXml,"_ENTREGA")
ElseIf nTipo == 3                       
	oAuxXml	:= XmlChildEx(oXml,"_INFNFE")
	oXmlRem	:= XmlChildEx(oAuxXml,"_EMIT")
	oXmlDes	:= XmlChildEx(oAuxXml,"_DEST")
EndIf	

If nTipo == 1
	cCdrDes := Posicione("DUY",6,xFilial("DUY")+oAuxXml:_UF:Text+SubsTr(oAuxXml:_cMun:Text,3,5),"DUY_GRPVEN")
	Aadd(aHeadSA1,{"A1_NOME"	, oXml:_xNome:Text													, Nil })
	Aadd(aHeadSA1,{"A1_NREDUZ" , SubStr(oXML:_xNome:Text,1,20) 										, Nil })
	Aadd(aHeadSA1,{"A1_CGC" 	, If(XmlChildEx(oXml,"_CNPJ") # NIL,oXml:_CNPJ:TEXT,oXml:_CPF:TEXT)	, Nil })
	Aadd(aHeadSA1,{"A1_END"  	, oAuxXml:_xLgr:Text + ", " + oAuxXml:_Nro:Text						, Nil })
	Aadd(aHeadSA1,{"A1_EST"  	, oAuxXml:_UF:Text						 							, Nil })
	Aadd(aHeadSA1,{"A1_MUN"  	, oAuxXml:_xMun:Text												, Nil })
	Aadd(aHeadSA1,{"A1_COD_MUN", SubsTr(oAuxXml:_cMun:Text,3,5)				  						, Nil })
	Aadd(aHeadSA1,{"A1_TIPO"  	, If(XmlChildEx(oXml,"_CNPJ") # NIL,"R","F")						, Nil })   
	Aadd(aHeadSA1,{"A1_PESSOA"	, If(XmlChildEx(oXml,"_CNPJ") # NIL,"J","F")						, Nil })   
	Aadd(aHeadSA1,{"A1_CEP"  	, oAuxXml:_Cep:Text													, Nil })   
	Aadd(aHeadSA1,{"A1_BAIRRO" , oAuxXml:_xBairro:Text												, Nil })   
	Aadd(aHeadSA1,{"A1_PAIS"  	, SubsTr(oAuxXml:_cPais:Text,1,3)							  		, Nil })   			
	Aadd(aHeadSA1,{"A1_DDD"  	, '999'                          							  		, Nil })   			
	Aadd(aHeadSA1,{"A1_TEL"  	, '99999999'                     							  		, Nil })   				                                                                                    	
	Aadd(aHeadSA1,{"A1_CDRDES" , cCdrDes	                     							  		, Nil })   				                                                                                    	
	
	Begin Transaction
		MSExecAuto({|x,y| MATA030(x,y)},aHeadSA1,3)
	End Transaction	

	If lMsErroAuto
		nNumDet 	+= 1
		cDetalhe += Str(nNumDet,1)+"º Erro"
		aErroAuto 	:= GetAutoGRLog()
		For nCount 	:= 1 To Len(aErroAuto)
			cDetalhe += StrTran(StrTran(aErroAuto[nCount],"<",""),"-","") + (" ")
		Next nCount	
		cDetalhe += Chr(13)+Chr(10)
		cMotivo := "Cliente Destinatário"
		lRet := .F. 
	EndIf	

ElseIf nTipo == 2
	SA1->(dbSetOrder(3))
	If SA1->(dbSeek(xFilial("SA1")+If(XmlChildEx(oAuxXml,"_CNPJ") # NIL,oAuxXml:_CNPJ:TEXT,oAuxXml:_CPF:TEXT)))
		Aadd(aHeadDUL,{"DUL_CODCLI", SA1->A1_COD				 		 		, Nil })
		Aadd(aHeadDUL,{"DUL_LOJCLI", SA1->A1_LOJA						 		, Nil })
		Aadd(aHeadDUL,{"DUL_NOME" 	, SA1->A1_NOME    				 			, Nil })
		Aadd(aHeadDUL,{"DUL_END"	, oXml:_xLgr:Text + ', ' + oXMl:_nro:Text   , Nil })
		Aadd(aHeadDUL,{"DUL_BAIRRO", oXml:_xBairro:Text							, Nil })   
		Aadd(aHeadDUL,{"DUL_MUN"	, oXml:_xMun:Text							, Nil })   
		Aadd(aHeadDUL,{"DUL_CODMUN", oXml:_cMun:Text							, Nil })   		
   
      Begin Transaction
			MSExecAuto({|x,y| TMSA450(x,y)},aHeadDUL,3)
		End Transaction
		
		If lMsErroAuto                    
			nNumDet 	+= 1
			cDetalhe += Str(nNumDet,1)+ "º Erro: "
			aErroAuto := GetAutoGRLog()
			For nCount := 1 To Len(aErroAuto)
				cDetalhe += StrTran(StrTran(aErroAuto[nCount],"<",""),"-","") + (" ")
			Next nCount	
			cDetalhe += Chr(13)+Chr(10)
			cMotivo := " Sequência de Endereço"
			lRet := .F. 
		Else
			cSeqEnd := DUL->DUL_SEQEND
		EndIf	
		
	EndIf
ElseIf nTipo == 3
                                              
 	cCgcRem	 := If(XmlChildEx(oXmlRem,"_CNPJ") # NIL,oXmlRem:_CNPJ:TEXT,oXmlRem:_CPF:TEXT)	
	cCgcDes	 := If(XmlChildEx(oXmlDes,"_CNPJ") # NIL,oXmlDes:_CNPJ:TEXT,oXmlDes:_CPF:TEXT)	
	cDoc     := StrZero(Val(AllTrim(oAuxXml:_Ide:_nNF:Text)),TamSx3("F1_DOC")[1])
	cSerie   := AllTrim(oAuxXml:_Ide:_Serie:Text)
	cTpFrete := AllTrim(oAuxXml:_TRANSP:_modFrete:Text)
	cCGCDev  := IIf(cTpFrete =='0' ,cCgcRem,If(cTpFrete=='1',cCgcDes,""))
	cCliDev  := Posicione('SA1',3,xFilial('SA1')+cCGCDev,'A1_COD')
	cLojDev  := SA1->A1_LOJA
	
	//----------------------------------------------------------------------------------
	//³Pesquisa O Serviço e tipo de transporte contratado pelo Tomador do Serviço
	//----------------------------------------------------------------------------------	
	TMSPesqServ('DE5', cCliDev, cLojDev, ,	, @aItContrat, .F.,,.T.)   	
	If !Empty(@aItContrat)       
		cSerVic := aItContrat[1,3]
		cSerTms := Posicione ('DC5',1,xFilial('DC5')+aItContrat[1,3],'DC5_SERTMS')
		cTipTra := DC5->DC5_TIPTRA
	Else	
		nNumDet 	+= 1                                         
		cDetalhe += Str(nNumDet,1)+"º Erro:"
		cDetalhe += "CNPJ "  + cCGCDev
		cMotivo :=  "Gravacao EDI"
		lRet := .F.
	EndIf
	If lRet
		//-----------------------------------------
		//³Monta Array e chama ExecAuto do TMSAE55³
		//-----------------------------------------
		Aadd(aHeadDE5,{"DE5_CGCREM" ,cCGCRem												    , Nil})  //CGC Remetente
		Aadd(aHeadDE5,{"DE5_DTAEMB"	,dDataBase													, Nil})  //Data Embarque
		Aadd(aHeadDE5,{"DE5_CGCDES"	,cCGCDes													, Nil})  //CGC Destinatário
		Aadd(aHeadDE5,{"DE5_CGCDEV"	,cCGCDev													, Nil})  //CGC Devedor
		Aadd(aHeadDE5,{"DE5_TIPFRE"	,IIf(cTpFrete == "0","1"	 ,If(cTpFrete=='1',"2",""))		, Nil})  //Tipo de Frete (1=CIF,2=FOB)
		Aadd(aHeadDE5,{"DE5_DOC"	,cDoc													    , Nil})  //Numero da Nf-e
		Aadd(aHeadDE5,{"DE5_SERIE"	,cSerie													    , Nil})  //Serie da NF
		Aadd(aHeadDE5,{"DE5_EMINFC"	,StoD(StrTran(AllTrim(oXML:_InfNfe:_Ide:_DEmi:Text),"-","")), Nil})  //Emissão Nota Fiscal do Cliente
		Aadd(aHeadDE5,{"DE5_NFEID"	,Right(AllTrim(oXML:_InfNfe:_Id:Text),44)				    , Nil})  //CHAVE DA NF-E
		Aadd(aHeadDE5,{"DE5_CFOPNF"	,AllTrim(cCFOP)	 											, Nil})  //CFOP DO PRODUT*/
		Aadd(aHeadDE5,{"DE5_SEQEND"	,cSeqEnd													, Nil})	 //Sequencia de Endereco
		Aadd(aHeadDE5,{"DE5_TIPTRA"	,cTipTra         											, Nil})	 //Tipo de Transporte
		Aadd(aHeadDE5,{"DE5_SERTMS"	,cSerTms         											, Nil})	 //Servico de Transporte
		Aadd(aHeadDE5,{"DE5_SERVIC"	,cSerVic         											, Nil})	 //Servico de Transporte
	
		nTamProd := Len(aProdutos)
		
		If !SuperGetMV ('MV_PRDDIV',.F.,.F.) .And. nTamProd > 1	//--Se o MV_PRDDIV estiver ativo importa todos os produtos da NF-e, caso contrario importa apenas o primeiro Produto		
			aItemDE5 := {}                			
			Aadd( aItemDE5, {"DE5_CODPRO"	,cProgen																												, Nil	} )  //Produto   
			Aadd( aItemDE5, {"DE5_CODEMB"	,Posicione('SB1',1,xFilial('SB1')+cProgen,IIf (aProdutos[1,5] == '2','B1_SEGUM','B1_UM'))	, Nil	} )  //Embalagem do Primeiro Produto
			Aadd( aItemDE5, {"DE5_VALOR"	,Val(oXML:_InfNfe:_Total:_IcmsTot:_vNF:Text)															 	, Nil	} )  //Valor da NF-e
			Aadd(aColsDE5,aClone(aItemDE5))
		Else //--Se o parametro nao estiver desabilitado ou existir apenas um produto pega os dados de todos os produtos existentes no XML
			For nX := 1 To nTamProd				
				aItemDE5 := {}       								
				If (Empty(aProdutos[nX,1]))
					cCodPro := cProGen
					cCodEmb := Posicione('SB1',1,xFilial('SB1')+cProgen,IIf (aProdutos[1,5] == '2','B1_SEGUM','B1_UM'))
					nVlrPrd :=  Val(oXML:_InfNfe:_Det[nX]:_PROD:_vPROD:Text)
				Else
					cCodPro := aProdutos[nx,1]
					cCodEmb := aProdutos[nx,2]
					nVlrPrd := aProdutos[nx,4]
				EndIf
				nPosPro := Ascan(aColsDE5,{|x|Alltrim(x[1,2])==cCodPro})				
				If nPosPro > 0
					aColsDE5[nPosPro,4,2] += nVlrPrd				
				Else	
					Aadd( aItemDE5, {"DE5_CODPRO"	,cCodPro, Nil} )  //Produto   
					Aadd( aItemDE5, {"DE5_CODEMB"	,cCodemb	, Nil} )  //Cod.Embalagem   
					Aadd( aItemDE5, {"DE5_VALOR"	,nVlrPrd , Nil} )  //Valor da NF-e
					Aadd(aColsDE5,aClone(aItemDE5))                             
				EndIf	
				
			Next nX								
		EndIf							
	
		Begin Transaction
			MSExecAuto({|x,y,z| TMSAE55(x,y,z)},aHeadDE5,nOpcx,aColsDE5)
		End Transaction
		
		If lMsErroAuto
			nNumDet 	+= 1
			cDetalhe += Str(nNumDet,1)+"º Erro:"
			aErroAuto := GetAutoGRLog()
			For nCount := 1 To Len(aErroAuto)
				cDetalhe += StrTran(StrTran(aErroAuto[nCount],"<",""),"-","") + (" ")
			Next nCount         		
			cMotivo := "Gravacao EDI"
			lRet := .F. 
		EndIf
	EndIf
EndIf	
RestArea(aArea)
Return ( lRet )


Static FuncTion PosSC7(c_NumPc)

DbSelectArea("SC7")
DbSetOrder(1)
DbSeek(xFilial("SC7") + c_NumPc )

Return(SC7->(Recno()) )
                   

Static Function At140IVlPd(clCodFor,clLoja,clNota,clSerie,cCodProd,lPedDoc)
Local aAreaSDT	:= SDT->(GetArea())
Local lRetorno := .T.
Local nRecSDT  := SDT->(Recno())

If !lPedDoc 
	// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// | VERIFICA SE A QTDE E VALORES SAO DIVERGENTES DA NOTA  |
	// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SDT->(DbSetOrder(3))
	If !Empty(TMP->MMARK) .And. !Empty(TMP->PED)
	    If SDT->(DbSeek(xFilial("SDT")+clCodFor+clLoja+clNota+clSerie+cCodProd))
	    	If (SDT->DT_QUANT <> TMP->QTDDISP) .Or. (SDT->DT_VUNIT <> TMP->PRECO)
				If !MsgYesNo("A quantidade e ou preco unitario do pedido selecionado é divergente do item da NFe. Confirma a seleção?","ATENÇÃO!")  
					lRetorno := .F.
				EndIf
			EndIf					
	    EndIf			
	EndIF
EndIf

SDT->(dbGoTo(nRecSDT))
RestArea(aAreaSDT)
Return lRetorno      

Static Function MarcaReg(clMarca,lPedDoc)
Local nRecno := TMP->(Recno())

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | Verifica se o Pedido está Bloqueado e se o parametro  |
// | MV_RESTNFE permite vinculo com a NFE                  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If SuperGetMV("MV_RESTNFE")=="S" .And. TMP->CONAPRO=="B"
	RecLock("TMP",.F.)
	TMP->MMARK := ""
	TMP->(MsUnLock())
	Aviso("A140RESTNFE","Pedido Bloqueado",{"Atenção"})
	Return Nil
EndIf

// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
// | VERIFICA SE O VALOR E ZERO. SE SIM DESMARCA REGISTRO  |
// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !lPedDoc
	TMP->(dbGoTop())
	While TMP->(!EOF())
		If !Empty(TMP->MMARK) .And. nRecno <> TMP->(Recno())
			RecLock("TMP",.F.)
			TMP->MMARK := ""
			TMP->(MsUnLock())
			Exit
		EndIF
		TMP->(DBSKIP())
	EndDo
EndIf

TMP->(dbGoTo(nRecno))
Return Nil      

Static FuncTion AtuSA5(olLBox,alItBx,clLine,alCpos,alParam)   

 Processa({|| xProcSA5(olLBox,alItBx,clLine,alCpos,alParam)},"Produto x Fornecedor","Atualizando, aguarde...")

Return

Static FuncTion xProcSA5( olLBox,alItBx,clLine,alCpos,alParam)

a_Notas := olLBox:AARRAY    
ProcRegua(Len(a_Notas))
For nN := 1 To Len(a_Notas)
	c_Fornece := a_Notas[nN][5]
   	c_Loja    := a_Notas[nN][6]  
   	c_Doc     := a_Notas[nN][3]  
   	c_Serie   := a_Notas[nN][2] 
   	c_CNPJ    := StrTran(a_Notas[nN][8],".","")
   	c_CNPJ    := StrTran(a_Notas[nN][8],"/","")
   	c_CNPJ    := StrTran(a_Notas[nN][8],"-","")
   	c_ChvSDT  := c_CNPJ + c_Fornece + c_Loja + c_Doc + c_Serie

	IncProc("N.Fiscal: " + c_Doc + " Fornec.: " + c_Fornece )
   	
	DbSelectArea("SDT")
	SDT->(DbSetOrder(1))
	If SDT->(DbSeek(xFilial("SDT") + c_ChvSDT ))
		Do While SDT->(!EOF()) .And. SDT->(DT_FILIAL+DT_CNPJ+DT_FORNEC+DT_LOJA+DT_DOC+DT_SERIE) == xFilial("SDT")+c_ChvSDT
            If ! EmpTy(SDT->DT_PRODFOR)
            	c_ProdFor := SDT->DT_PRODFOR
				DbSelectArea("SA5")      
				DbSetOrder(2) // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
				If DbSeek(xFilial("SA5") + SDT->(DT_COD + DT_FORNEC + DT_LOJA) )
					SA5->(RecLock("SA5",.F.))
						SA5->A5_CODPRF  := c_ProdFor
						SA5->A5_PRODUTO	:= SDT->DT_COD
					MsUnLock()
				Else     
					SA5->(RecLock("SA5",.T.))
						SA5->A5_FILIAL  := xFilial("SA5")
						SA5->A5_FORNECE	:= SDT->DT_FORNEC
						SA5->A5_LOJA	:= SDT->DT_LOJA
						SA5->A5_PRODUTO	:= SDT->DT_COD
						SA5->A5_NOMPROD	:= Posicione("SB1",1,xFilial("SB1") + SDT->DT_COD,"B1_DESC")
						SA5->A5_CODPRF := c_ProdFor
						SA5->A5_NOMEFOR	:= SDT->DT_DESCFOR
					MsUnLock()
				EndIf	
			EndIf      
			DbSelectArea("SDT")
			SDT->(dbSkip()) 
		EndDo
	EndIf
Next
Return
