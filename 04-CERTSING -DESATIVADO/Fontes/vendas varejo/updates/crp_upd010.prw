//------------------------------------------------------------------
// Rotina | CRP_UPD010()   | Autor | Tatiana Pontes | Data | 20/05/13
//------------------------------------------------------------------
// Descr. | Rotina de update para criar as estruturas no dicionário
//        | de dados.
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function CRP_UPD010()

	Local cModulo := "FAT"
	Local bPrepar := {|| U_U010Ini() }
	Local nVersao := 01

	NGCriaUpd(cModulo,bPrepar,nVersao)

Return

//------------------------------------------------------------------
// Rotina | U010Ini    | Autor | Tatiana Pontes | Data | 27/04/13
//------------------------------------------------------------------
// Descr. | Estrutura de dados para criar o dicionário de dados.
//        | 
//------------------------------------------------------------------
// Uso    | Certisign
//------------------------------------------------------------------
User Function U010Ini()
	/*
	[1] Chave
	[2] Path
	[3] Arquivo
	[4] Nome
	[5] Nome espanhol
	[6] Nome inglês
	[7] Modo
	[8] Chave único
	[9] Número do módulo
	[a] Modo unidade
	[b] Modo empresa
	*/

	aSX2 := {}
	AADD(aSX2,{"PA8",NIL,"DE-PARA PROD. BPAG X PROTHEUS"	,"DE-PARA PROD. BPAG X PROTHEUS"	,"DE-PARA PROD. BPAG X PROTHEUS"	,"E",""})	
	AADD(aSX2,{"SZ3",NIL,"CADASTRO DE ENTIDADES"			,"CADASTRO DE ENTIDADES"			,"CADASTRO DE ENTIDADES"			,"C",""})
	AADD(aSX2,{"SZ4",NIL,"ITENS DAS ENTIDADES"				,"ITENS DAS ENTIDADES"				,"ITENS DAS ENTIDADES"				,"C",""})
	AADD(aSX2,{"SZ5",NIL,"DADOS PARA FTURAMENTO GAR"		,"DADOS PARA FTURAMENTO GAR"		,"DADOS PARA FTURAMENTO GAR"		,"C",""})
	AADD(aSX2,{"SZ6",NIL,"MOVIMENTOS DE COMISSAO"			,"MOVIMENTOS DE COMISSAO"			,"MOVIMENTOS DE COMISSAO"			,"C",""})
	AADD(aSX2,{"SZA",NIL,"CLASSIFICACAO DE ENTIDADE"		,"CLASSIFICACAO DE ENTIDADE"		,"CLASSIFICACAO DE ENTIDADE"		,"C",""})
	AADD(aSX2,{"SZV",NIL,"SALDO MENSAL CERT. VERIFICADOS"	,"SALDO MENSAL CERT. VERIFICADOS"	,"SALDO MENSAL CERT. VERIFICADOS"	,"C","ZV_FILIAL+ZV_CODENT+ZV_SALANO"})

	/*
	[1]  X3_ARQUIVO
	[2]  X3_ORDEM  
	[3]  X3_CAMPO  
	[4]  X3_TIPO   
	[5]  X3_TAMANHO
	[6]  X3_DECIMAL
	[7]  X3_TITULO 
	[8]  X3_TITSPA 
	[9]  X3_TITENG 
	[10] X3_DESCRIC
	[11] X3_DESCSPA
	[12] X3_DESCENG
	[13] X3_PICTURE
	[14] X3_VALID  
	[15] X3_USADO  
	[16] X3_RELACAO
	[17] X3_F3     
	[17] X3_NIVEL  
	[19] X3_RESERV 
	[20] X3_CHECK  
	[21] X3_TRIGGER
	[22] X3_PROPRI 
	[23] X3_BROWSE 
	[24] X3_VISUAL 
	[25] X3_CONTEXT
	[26] X3_OBRIGAT
	[27] X3_VLDUSER
	[28] X3_CBOX   
	[29] X3_CBOXSPA
	[30] X3_CBOXENG
	[31] X3_PICTVAR
	[32] X3_WHEN   
	[33] X3_INIBRW 
	[34] X3_GRPSXG 
	[35] X3_FOLDER 
	[36] X3_PYME   
	[37] X3_CONDSQL
	[38] X3_CHKSQL 
	[39] X3_IDXSRV
	[40] X3_IDXFLD
	[41] X3_ORTOGA
	*/

	aSX3 := {}

	AADD(aSX3,{"PA8","01","PA8_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","02","PA8_CODBPG","C",32,00,"CodigoGAR","CodigoGAR","CodigoGAR","CodigoGAR","CodigoGAR","CodigoGAR","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","03","PA8_DESBPG","C",128,00,"Descri.GAR","Descri.GAR","Descri.GAR","Descri.GAR","Descri.GAR","Descri.GAR","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","04","PA8_CODMP8","C",15,00,"CodigoTOTVS","CodigoTOTVS","CodigoTOTVS","CodigoTOTVS","CodigoTOTVS","CodigoTOTVS","","","€€€€€€€€€€€€€€ ","","SB1",00,"þÀ","","S","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","05","PA8_DESMP8","C",105,00,"DescriTOTVS","DescriTOTVS","DescriTOTVS","DescriTOTVS","DescriTOTVS","DescriTOTVS","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","06","PA8_USERGI","C",17,00,"LogdeInclu","LogdeInclu","LogdeInclu","LogdeInclusao","LogdeInclusao","LogdeInclusao","","","€€€€€€€€€€€€€€€","","",09,"þÀ","","","L","N","V","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","07","PA8_USERGA","C",17,00,"LogdeAlter","LogdeAlter","LogdeAlter","LogdeAlteracao","LogdeAlteracao","LogdeAlteracao","","","€€€€€€€€€€€€€€€","","",09,"þÀ","","","L","N","V","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","08","PA8_CLAPRO","C",03,00,"Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","Classificac.","@!","","€€€€€€€€€€€€€€ ","","SZA_01",00,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","09","PA8_CATPRO","C",02,00,"CatRemProd","CatRemProd","CatRemProd","CategoriaRem.Produto","CategoriaRem.Produto","CategoriaRem.Produto","","","€€€€€€€€€€€€€€ ","","ZY",00,"þÀ","","","U","N","A","R","","EXISTCPO('SX5','ZY'+M->PA8_CATPRO).OR.Vazio()","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","10","PA8_CONCER","C",01,00,"Contagem?","Contagem?","Contagem?","RealizaContagem?","RealizaContagem?","RealizaContagem?","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","1=Sim;2=Nao","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"PA8","11","PA8_LINKPR","C",250,00,"Linkprod.","Linkprod.","Linkprod.","Linkdoproduto","Linkdoproduto","Linkdoproduto","@!","","€€€€€€€€€€€€€€ ","","",01,"þA","","","U","N","A","R","","","","","","","","","","","N","","","N","N","N","","","N","N","N"})
	
	AADD(aSX3,{"SZ3","01","Z3_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","02","Z3_CODENT","C",06,00,"CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","CodEntidade","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","03","Z3_DESENT","C",100,00,"DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","DescrEntid.","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","04","Z3_TIPENT","C",01,00,"TipoEntidad","TipoEntidad","TipoEntidad","TipoEntidade","TipoEntidade","TipoEntidade","9","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","1=Canal;2=AC;3=AR;4=Posto;5=Grupo","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","","INCLUI","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","05","Z3_TIPCOM","C",01,00,"CalculaRem.","CalculaRem.","CalculaRem.","CalculaRemuneracao","CalculaRemuneracao","CalculaRemuneracao","","","€€€€€€€€€€€€€€ ","'1'","",00,"þÀ","","","U","N","A","R","€","","1=Sim;2=Nao","1=Sim;2=Nao","1=Sim;2=Nao","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","06","Z3_CLASSI","C",03,00,"Grupo/Rede","Grupo/Rede","Grupo/Rede","Grupo/RededaEntidade","Grupo/RededaEntidade","Grupo/RededaEntidade","@!","","€€€€€€€€€€€€€€ ","","SZA_01",00,"þÀ","","","U","N","A","R","€","ExistCpo('SZA',M->Z3_CLASSI)","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","07","Z3_CODGAR","C",32,00,"EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","EntnoGAR","@X","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","INCLUI","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","08","Z3_CODFED","C",06,00,"Federacao","Federacao","Federacao","CodigoFederecao","CodigoFederecao","CodigoFederecao","@!","","€€€€€€€€€€€€€€ ","","SZ3",00,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","09","Z3_DESFED","C",100,00,"Desc.Feder.","Desc.Feder.","Desc.Feder.","Desc.Federacao","Desc.Federacao","Desc.Federacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","2","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","10","Z3_CODCAN","C",06,00,"Canal","Canal","Canal","CodigoCanal","CodigoCanal","CodigoCanal","@!","","€€€€€€€€€€€€€€ ","","SZ3_01",00,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","11","Z3_DESCAN","C",100,00,"DescCanal","DescCanal","DescCanal","DescricaoCanal","DescricaoCanal","DescricaoCanal","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","12","Z3_CODAC","C",06,00,"AC","AC","AC","CodigoAC","CodigoAC","CodigoAC","@!","","€€€€€€€€€€€€€€ ","","SZ3_02",00,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","13","Z3_DESAC","C",100,00,"DescrAC","DescrAC","DescrAC","DescricaodaAC","DescricaodaAC","DescricaodaAC","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","14","Z3_CODAR","C",06,00,"AR","AR","AR","CodigoAR","CodigoAR","CodigoAR","@!","","€€€€€€€€€€€€€€ ","","SZ3_03",00,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","15","Z3_DESAR","C",100,00,"DescAR","DescAR","DescAR","DescricaoAR","DescricaoAR","DescricaoAR","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","16","Z3_CODFOR","C",06,00,"CodFornec.","CodFornec.","CodFornec.","CodigodoFornecedor","CodigodoFornecedor","CodigodoFornecedor","@!","","€€€€€€€€€€€€€€ ","","SA2",00,"þÀ","","S","U","N","A","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","17","Z3_LOJA","C",02,00,"Loja","Loja","Loja","Loja","Loja","Loja","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","18","Z3_DESFOR","C",60,00,"NomeFornec","NomeFornec","NomeFornec","NomeFornecedor","NomeFornecedor","NomeFornecedor","@!","","€€€€€€€€€€€€€€ ","IIF(!INCLUI,POSICIONE('SA2',1,XFILIAL('SA2')+SZ3->Z3_CODFOR,'A2_NOME'),'')","",00,"þÀ","","","U","N","V","V","","","","","","","","","","2","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","19","Z3_DEVLAR","C",01,00,"DescoComAR","DescoComAR","DescoComAR","DescontaValComissaoAR","DescontaValComissaoAR","DescontaValComissaoAR","9","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","0=Nao;1=Sim","0=Nao;1=Sim","0=Nao;1=Sim","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","20","Z3_PONDIS","C",06,00,"PontoDistr.","PontoDistr.","PontoDistr.","Pontodedistribuicao","Pontodedistribuicao","Pontodedistribuicao","999999","","€€€€€€€€€€€€€€ ","","SZ8_01",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","21","Z3_CEP","C",08,00,"CEP","CEP","CEP","CEP","CEP","CEP","@R99999-999","!Empty(M->Z3_CEP).AND.ExistCpo('PA7')","€€€€€€€€€€€€€€ ","","PA7",00,"þÀ","","S","U","N","A","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","22","Z3_LOGRAD","C",60,00,"Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","Logradouro","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","23","Z3_NUMLOG","C",10,00,"NumLograd.","NumLograd.","NumLograd.","NumerodoLogradouro","NumerodoLogradouro","NumerodoLogradouro","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","24","Z3_COMPLE","C",30,00,"Complemento","Complemento","Complemento","Complemento","Complemento","Complemento","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","25","Z3_BAIRRO","C",30,00,"Bairro","Bairro","Bairro","Bairro","Bairro","Bairro","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","26","Z3_CODMUN","C",05,00,"CodMunicip.","CodMunicip.","CodMunicip.","CodMunicipio","CodMunicipio","CodMunicipio","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","27","Z3_MUNICI","C",35,00,"Municipio","Municipio","Municipio","Municipio","Municipio","Municipio","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","28","Z3_ESTADO","C",02,00,"Estado","Estado","Estado","Estado","Estado","Estado","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","€","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","29","Z3_REGIAO","C",01,00,"RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","RegiaoPais","9","","€€€€€€€€€€€€€€ ","'4'","",00,"þÀ","","","U","N","A","R","€","","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","1=Norte;2=Nordeste;3=Sul;4=Sudeste;5=CentroOeste","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","30","Z3_BANCO","C",03,00,"Banco","Banco","Banco","Banco","Banco","Banco","999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","31","Z3_AGENCIA","C",05,00,"Agencia","Agencia","Agencia","Agencia","Agencia","Agencia","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","32","Z3_CONTA","C",10,00,"ContaCorren","ContaCorren","ContaCorren","ContaCorrente","ContaCorrente","ContaCorrente","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","1","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","33","Z3_DDD","C",03,00,"DDD","DDD","DDD","CodigoDDD","CodigoDDD","CodigoDDD","999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","34","Z3_TEL","C",15,00,"Telefone","Telefone","Telefone","TelefonedoPosto","TelefonedoPosto","TelefonedoPosto","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","35","Z3_CGC","C",14,00,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJ/CPFdoposto","CNPJ/CPFdoposto","CNPJ/CPFdoposto","@R99.999.999/9999-99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","Vazio().Or.CGC(M->Z3_CGC)","","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","36","Z3_CLIENTE","C",06,00,"Cliente","Cliente","Cliente","ClienteSimplesRemessa","ClienteSimplesRemessa","ClienteSimplesRemessa","@!","","€€€€€€€€€€€€€€ ","","SA1",00,"þÀ","","","U","S","A","R","","ExistCpo('SA1',M->Z3_CLIENTE,,,,.F.)","","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","37","Z3_LOJACLI","C",02,00,"LojaCliente","LojaCliente","LojaCliente","Ljclientsimplesremessa","Ljclientsimplesremessa","Ljclientsimplesremessa","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","38","Z3_ATENDIM","C",01,00,"Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","Atendimento","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","39","Z3_ATIVO","C",01,00,"Ativo","Ativo","Ativo","Ativo","Ativo","Ativo","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","40","Z3_VISIBIL","C",01,00,"Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","Visibilidade","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","41","Z3_ENTREGA","C",01,00,"Entrega","Entrega","Entrega","Entrega","Entrega","Entrega","@!","","€€€€€€€€€€€€€€ ","'N'","",00,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","3","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","42","Z3_CODTAB","C",200,00,"Cod.Tab.Pr","Cod.Tab.Pr","Cod.Tab.Pr","CodigodaTabeladePreco","CodigodaTabeladePreco","CodigodaTabeladePreco","@!","","€€€€€€€€€€€€€€ ","","DA0",00,"þÀ","","","U","N","A","R","","","","","","","M->Z3_TIPENT$'2,5'","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","43","Z3_CODPRO","C",15,00,"CodProd","CodProd","CodProd","CodigodoProduto","CodigodoProduto","CodigodoProduto","@!","","€€€€€€€€€€€€€€ ","","SB1",00,"þÀ","","","U","N","A","R","","","","","","","M->Z3_TIPENT$'2,5'","","030","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","44","Z3_ENVSITE","C",01,00,"Env.Site","Env.Site","Env.Site","EnviadoparaoSite","EnviadoparaoSite","EnvidadoparaoSite","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","45","Z3_REDE","C",72,00,"Rede","Rede","Rede","Rede","Rede","Rede","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","46","Z3_AGRUPRO","C",128,00,"AgrupProd","AgrupProd","AgrupProd","AgrupamentoProdutos","AgrupamentoProdutos","AgrupamentoProdutos","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","2","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","47","Z3_CCRCOM","C",200,00,"ARComissao","ARComissao","ARComissao","CCRARComissao","CCRARComissao","CCRARComissao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","48","Z3_NMFANT","C",50,00,"NomeFantasi","NomeFantasi","NomeFantasi","NomeFantasi","NomeFantasi","NomeFantasi","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ3","49","Z3_RAZSOC","C",50,00,"RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocial","","","€€€€€€€€€€€€€€ ","","",00,"þA","","","U","N","A","R","","","","","","","","","","1","","","","","N","N","","","N","N","N"})
	
	AADD(aSX3,{"SZ4","01","Z4_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","02","Z4_CODENT","C",06,00,"CodEntidade","CodEntidade","CodEntidade","Codigodaentidade","Codigodaentidade","Codigodaentidade","@!","","€€€€€€€€€€€€€€€","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","03","Z4_CATPROD","C",02,00,"CatRemProd","CatRemProd","CatRemProd","CategoriaRem.Produto","CategoriaRem.Produto","CategoriaRem.Produto","","","€€€€€€€€€€€€€€ ","","ZY",00,"þÀ","","S","U","N","A","R","","EXISTCPO('SX5','ZY'+M->Z4_CATPROD)","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","04","Z4_CATDESC","C",55,00,"Descr.Cat.","Descr.Cat.","Descr.Cat.","Descr.CategoriaRem.","Descr.CategoriaRem.","Descr.CategoriaRem.","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","05","Z4_PORSOFT","N",06,02,"%Software","%Software","%Software","%RemuneracaoSoftware","%RemuneracaoSoftware","%RemuneracaoSoftware","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","U_COM010When('Z4_PORSOFT')","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","06","Z4_IMPSOFT","N",06,02,"%Imp.Soft.","%Imp.Soft.","%Imp.Soft.","%ImpostosSoftware","%ImpostosSoftware","%ImpostosSoftware","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","07","Z4_PORHARD","N",06,02,"%Hardware","%Hardware","%Hardware","%RemuneracaoHardware","%RemuneracaoHardware","%RemuneracaoHardware","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","U_COM010When('Z4_PORHARD')","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","08","Z4_IMPHARD","N",06,02,"%Imp.Hard.","%Imp.Hard.","%Imp.Hard.","%ImpostosHardware","%ImpostosHardware","%ImpostosHardware","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","09","Z4_PARSW","N",06,02,"%CCSW","%CCSW","%CCSW","%SoftwareCamp.Contador","%SoftwareCamp.Contador","%SoftwareCamp.Contador","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","10","Z4_PARHW","N",06,02,"%CCHW","%CCHW","%CCHW","%HardwareCamp.Contador","%HardwareCamp.Contador","%HardwareCamp.Contador","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","11","Z4_VENCC","N",06,02,"%VendaCC","%VendaCC","%VendaCC","%VendaCamp.Contador","%VendaCamp.Contador","%VendaCamp.Contador","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","12","Z4_PORIR","N",06,02,"%IR","%IR","%IR","%IR","%IR","%IR","@E999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","13","Z4_VALSOFT","N",12,02,"VlFixoSoft","VlFixoSoft","VlFixoSoft","ValorFixoRem.Software","ValorFixoRem.Software","ValorFixoRem.Software","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","U_COM010When('Z4_VALSOFT')","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","14","Z4_VALHARD","N",12,02,"VlFixoHard","VlFixoHard","VlFixoHard","ValorFixoRem.Hardware","ValorFixoRem.Hardware","ValorFixoRem.Hardware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","U_COM010When('Z4_VALHARD')","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","15","Z4_QTDMIN","N",06,00,"Qtd.Minima","Qtd.Minima","Qtd.Minima","Qtd.MinimaVendida","Qtd.MinimaVendida","Qtd.MinimaVendida","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ4","16","Z4_QTDMAX","N",06,00,"Qtd.Maxima","Qtd.Maxima","Qtd.Maxima","Qtd.MaximaVendida","Qtd.MaximaVendida","Qtd.MaximaVendida","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
		
	AADD(aSX3,{"SZ5","01","Z5_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","02","Z5_PEDGAR","C",07,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","03","Z5_DATPED","D",08,00,"DataPedGAR","DataPedGAR","DataPedGAR","DatapedidoGAR","DatapedidoGAR","DatapedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","04","Z5_EMISSAO","D",08,00,"DtEmissao","DtEmissao","DtEmissao","DatadeEmissao","DatadeEmissao","DatadeEmissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","05","Z5_RENOVA","D",08,00,"DtRenovacao","DtRenovacao","DtRenovacao","DatadaRenovacao","DatadaRenovacao","DatadaRenovacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","06","Z5_REVOGA","D",08,00,"DtRevogacao","DtRevogacao","DtRevogacao","DatadeRevogacao","DatadeRevogacao","DatadeRevogacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","07","Z5_DATVAL","D",08,00,"DtValidacao","DtValidacao","DtValidacao","DatadeValidacao","DatadeValidacao","DatadeValidacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","08","Z5_HORVAL","C",05,00,"HrValidacao","HrValidacao","HrValidacao","HoraValidacao","HoraValidacao","HoraValidacao","99:99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","09","Z5_CNPJ","C",14,00,"CNPJ/CPF","CNPJ/CPF","CNPJ/CPF","CNPJdoCertificado","CNPJdoCertificado","CNPJdoCertificado","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","10","Z5_CNPJCER","C",14,00,"CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCer","CNPJ/CPFCertificado","CNPJ/CPFCertificado","CNPJ/CPFCertificado","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","11","Z5_CNPJV","N",14,00,"CNPJValida","CNPJValida","CNPJValida","CNPJdaValidacao","CNPJdaValidacao","CNPJdaValidacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","12","Z5_NOMREC","C",100,00,"NomeCert.","NomeCert.","NomeCert.","NomeCertificado","NomeCertificado","NomeCertificado","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","13","Z5_RSVALID","C",100,00,"RazaoSocial","RazaoSocial","RazaoSocial","RazaoSocialdoCertifica","RazaoSocialdoCertifica","RazaoSocialdoCertifica","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","14","Z5_DATPAG","D",08,00,"DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","DataPagto","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","15","Z5_VALORSW","N",12,02,"ValorSW","ValorSW","ValorSW","ValordoSoftware","ValordoSoftware","ValordoSoftware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","S","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","16","Z5_VALORHW","N",12,02,"ValorHW","ValorHW","ValorHW","ValordoHardware","ValordoHardware","ValordoHardware","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","S","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","17","Z5_VALOR","N",12,02,"ValorTotal","ValorTotal","ValorTotal","ValorTotal","ValorTotal","ValorTotal","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","18","Z5_TIPMOV","C",01,00,"FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","FormaPagto","9","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","1=Boleto;2=CartaoCredito;3=CartaoDebito;4=DA;5=DDA;6=Voucher","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","19","Z5_STATUS","C",01,00,"Status","Status","Status","Status","Status","Status","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","1=Validacao;2=Renovacao;3=Verificacao;4=Emissao","1=Validacao;2=Renovacao;3=Verificacao;4=Emissao","1=Validacao;2=Renovacao;3=Verificacao;4=Emissao","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","20","Z5_GARANT","C",10,00,"PedGARAnt.","PedGARAnt.","PedGARAnt.","Ped.GARAnterior","Ped.GARAnterior","Ped.GARAnterior","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","21","Z5_NTITULA","C",100,00,"NomeTitular","NomeTitular","NomeTitular","NomedoTitularCert.","NomedoTitularCert.","NomedoTitularCert.","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","22","Z5_CODAR","C",20,00,"Cod.ARVal.","Cod.ARVal.","Cod.ARVal.","CodigoARValidacao","CodigoARValidacao","CodigoARValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","23","Z5_DESCAR","C",100,00,"Desc.ARVal","Desc.ARVal","Desc.ARVal","Desc.ARValidacao","Desc.ARValidacao","Desc.ARValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","24","Z5_CODPOS","C",20,00,"CodigoPosto","CodigoPosto","CodigoPosto","CodigoPostoValidacao","CodigoPostoValidacao","CodigoPostoValidacao","@!","","€€€€€€€€€€€€€€ ","","SZ3_05",00,"þÀ","","S","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","25","Z5_DESPOS","C",100,00,"Desc.Posto","Desc.Posto","Desc.Posto","DescricaodoPosto","DescricaodoPosto","DescricaodoPosto","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","26","Z5_CODAGE","C",20,00,"Cod.Agente","Cod.Agente","Cod.Agente","CodigodoAgente","CodigodoAgente","CodigodoAgente","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","27","Z5_NOMAGE","C",100,00,"NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","28","Z5_CPFAGE","C",14,00,"CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","29","Z5_CERTIF","C",20,00,"Certificado","Certificado","Certificado","Certificado","Certificado","Certificado","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","30","Z5_PRODGAR","C",20,00,"ProdutoGAR","ProdutoGAR","ProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","CodigoProdutoGAR","","","€€€€€€€€€€€€€€ ","","PA8",00,"þÀ","","S","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","31","Z5_PRODUTO","C",20,00,"ProdutoERP","ProdutoERP","ProdutoERP","ProdutoERP","ProdutoERP","ProdutoERP","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","32","Z5_DESPRO","C",100,00,"Desc.Prod.","Desc.Prod.","Desc.Prod.","DescricaoProduto","DescricaoProduto","DescricaoProduto","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","33","Z5_GRUPO","C",20,00,"Grupo","Grupo","Grupo","Grupo","Grupo","Grupo","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","34","Z5_DESGRU","C",100,00,"Desc.Grupo","Desc.Grupo","Desc.Grupo","DescricaoGrupo","DescricaoGrupo","DescricaoGrupo","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","35","Z5_CODAC","C",20,00,"CodAC","CodAC","CodAC","CoddaACdePedido","CoddaACdePedido","CoddaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","36","Z5_DESCAC","C",100,00,"Desc.AC","Desc.AC","Desc.AC","DescdaACdePedido","DescdaACdePedido","DescdaACdePedido","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","37","Z5_COMISS","C",01,00,"Comissao","Comissao","Comissao","ControledeComissao","ControledeComissao","ControledeComissao","","PERTENCE('1')","€€€€€€€€€€€€€€ ","'1'","",00,"þÀ","","","U","N","A","R","","","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","1=AGerar;2=Gerado;3=Pago","","M->Z5_COMISS<>'3'","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","38","Z5_TIPO","C",06,00,"TipComissao","TipComissao","TipComissao","TipoMov.Comissao","TipoMov.Comissao","TipoMov.Comissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","VALIDA=Validacao;VERIFI=Verificacao;EMISSA=Emissao;RENOVA=Renovacao;CLUBRE=Revendedor;CAMPCO=Contador;HWAVUL=Hard.Avulso","VALIDA=Validacao;VERIFI=Verificacao;EMISSA=Emissao;RENOVA=Renovacao;CLUBRE=Revendedor;CAMPCO=Contador;HWAVUL=Hard.Avulso","VALIDA=Validacao;VERIFI=Verificacao;EMISSA=Emissao;RENOVA=Renovacao;CLUBRE=Revendedor;CAMPCO=Contador;HWAVUL=Hard.Avulso","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","39","Z5_OBSCOM","C",100,00,"ObsComissao","ObsComissao","ObsComissao","FalhaGeracaoComissao","FalhaGeracaoComissao","FalhaGeracaoComissao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","40","Z5_CODARP","C",20,00,"CodARPed","CodARPed","CodARPed","CoddaARdoPedido","CoddaARdoPedido","CoddaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","41","Z5_CODVOU","C",20,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","CodigoVoucher","CodigoVoucher","CodigoVoucher","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","42","Z5_TIPVOU","C",09,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","43","Z5_DESCARP","C",100,00,"DescARPed","DescARPed","DescARPed","DescdaARdoPedido","DescdaARdoPedido","DescdaARdoPedido","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","44","Z5_REDE","C",100,00,"Rede","Rede","Rede","NomedaRededeValidacao","NomedaRededeValidacao","NomedaRededeValidacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","45","Z5_NOMECLI","C",100,00,"NomeCliente","NomeCliente","NomeCliente","NomeClientedaFatura","NomeClientedaFatura","NomeClientedaFatura","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","46","Z5_CNPJFAT","C",14,00,"CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFFAT","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","CNPJ/CPFdaFatura","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","47","Z5_EMAIL","C",50,00,"EmailTit.","EmailTit.","EmailTit.","EmailTitular","EmailTitular","EmailTitular","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","48","Z5_CODVEND","C",20,00,"Cod.Revend.","Cod.Revend.","Cod.Revend.","CoddoRevendedor","CoddoRevendedor","CoddoRevendedor","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","49","Z5_NOMVEND","C",100,00,"NomeRevend.","NomeRevend.","NomeRevend.","NomedoRevendedor","NomedoRevendedor","NomedoRevendedor","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","50","Z5_COMSW","N",07,04,"%ComSW","%ComSW","%ComSW","%ComissaoSoftware","%ComissaoSoftware","%ComissaoSoftware","@999.9999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","51","Z5_COMHW","N",06,04,"%ComHW","%ComHW","%ComHW","%ComissaoHardware","%ComissaoHardware","%ComissaoHardware","@999.9999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","52","Z5_FLAGA","C",01,00,"FlagAtualiz","FlagAtualiz","FlagAtualiz","FlagdeAtualizacao","FlagdeAtualizacao","FlagdeAtualizacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","53","Z5_CPFT","C",11,00,"CPFTitular","CPFTitular","CPFTitular","CPFTitularCertificado","CPFTitularCertificado","CPFTitularCertificado","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","54","Z5_DESCST","C",20,00,"DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","DescStatus","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","55","Z5_PEDIDO","C",06,00,"PedidoVenda","PedidoVenda","PedidoVenda","PedidoVendaProtheus","PedidoVendaProtheus","PedidoVendaProtheus","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","56","Z5_CODPAR","C",20,00,"CodParceiro","CodParceiro","CodParceiro","CodigodoParceiro","CodigodoParceiro","CodigodoParceiro","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","57","Z5_NOMPAR","C",60,00,"NomeParceir","NomeParceir","NomeParceir","NomeParceir","NomedoParceiro","NomedoParceiro","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","58","Z5_ITEMPV","C",02,00,"ItemPV","ItemPV","ItemPV","ItemdoPedidodeVenda","ItemdoPedidodeVenda","ItemdoPedidodeVenda","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","59","Z5_TIPODES","C",30,00,"DescTipo","DescTipo","DescTipo","DescTipodeMovRP","DescTipodeMovRP","DescTipodeMovRP","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","60","Z5_PEDGANT","C",07,00,"PedGarAnt.","PedGarAnt.","PedGarAnt.","PedidoGARAnterior","PedidoGARAnterior","PedidoGARAnterior","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","61","Z5_ROTINA","C",10,00,"Rotina","Rotina","Rotina","Rotinadeorigem","Rotinadeorigem","Rotinadeorigem","@!","","€€€€€€€€€€€€€€ ","IF(INCLUI,'GARA050',SZ5->Z5_ROTINA)","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","62","Z5_PROCRET","C",01,00,"Processado","Processado","Processado","","","","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","63","Z5_DATVER","D",08,00,"DtVerifica","DtVerifica","DtVerifica","DataVerificacao","DataVerificacao","DataVerificacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","64","Z5_HORVER","C",05,00,"HrVerifica","HrVerifica","HrVerifica","HoraVerificacao","HoraVerificacao","HoraVerificacao","99:99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","65","Z5_POSVER","C",20,00,"PostoVerifi","PostoVerifi","PostoVerifi","CodigoPostoVerificacao","CodigoPostoVerificacao","CodigoPostoVerificacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","66","Z5_AGVER","C",14,00,"CPFAgVerif","CPFAgVerif","CPFAgVerif","CPFAgentedeVerificacao","CPFAgentedeVerificacao","CPFAgentedeVerificacao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","67","Z5_NOAGVER","C",100,00,"NomeAgVeri","NomeAgVeri","NomeAgVeri","NomeAgenteVerificacao","NomeAgenteVerificacao","NomeAgenteVerificacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","68","Z5_DATEMIS","D",08,00,"DtEmissao","DtEmissao","DtEmissao","DataEmissao","DataEmissao","DataEmissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","69","Z5_HOREMIS","C",05,00,"HoraEmissao","HoraEmissao","HoraEmissao","HoraEmissao","HoraEmissao","HoraEmissao","99.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","70","Z5_POSEMIS","C",20,00,"PostoEmissa","PostoEmissa","PostoEmissa","CodigoPostodaEmissao","CodigoPostodaEmissao","CodigoPostodaEmissao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","71","Z5_AGEMIS","C",14,00,"CPFAgEmiss","CPFAgEmiss","CPFAgEmiss","CPFAgenteEmissao","CPFAgenteEmissao","CPFAgenteEmissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","72","Z5_NOAGEMI","C",100,00,"NomeAgEmis","NomeAgEmis","NomeAgEmis","NomeAgenteEmissao","NomeAgenteEmissao","NomeAgenteEmissao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","73","Z5_ORIEMIS","C",01,00,"OrigemEmiss","OrigemEmiss","OrigemEmiss","OrigemEmissao","OrigemEmissao","OrigemEmissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","74","Z5_UFDOCTI","C",02,00,"UFDocTittu","UFDocTittu","UFDocTittu","UFDocTitularCertificad","UFDocTitularCertificad","UFDocTitularCertificad","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","75","Z5_VLDCERT","D",08,00,"ValidCertif","ValidCertif","ValidCertif","ValidadedoCertificado","ValidadedoCertificado","ValidadedoCertificado","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","76","Z5_TELTIT","C",15,00,"TelTitCert","TelTitCert","TelTitCert","TelefoneTitularCertific","TelefoneTitularCertific","TelefoneTitularCertific","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","77","Z5_NOMCTO","C",100,00,"NomeContato","NomeContato","NomeContato","NomeContatoTitCertific","NomeContatoTitCertific","NomeContatoTitCertific","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","78","Z5_TELCTO","C",15,00,"TelContato","TelContato","TelContato","TelContatoTitCertifica","TelContatoTitCertifica","TelContatoTitCertifica","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","79","Z5_MAICTO","C",50,00,"EmailContat","EmailContat","EmailContat","EmailContatoTitCertifi","EmailContatoTitCertifi","EmailContatoTitCertifi","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","80","Z5_TABELA","C",03,00,"Tab.Preco","Tab.Preco","Tab.Preco","TabeladePreco","TabeladePreco","TabeladePreco","@!","","€€€€€€€€€€€€€€ ","","DA0",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","81","Z5_VENATV","C",01,00,"Vend.Ativo","Vend.Ativo","Vend.Ativo","VendedorAtivo","VendedorAtivo","VendedorAtivo","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","Pertence('SN')","S=Sim;N=Nao","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ5","82","Z5_TIPOPAR","C",01,00,"TpParceiro","TpParceiro","TpParceiro","TipodeParceiro","TipodeParceiro","TipodeParceiro","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})	
	
	AADD(aSX3,{"SZ6","01","Z6_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","033","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","02","Z6_PEDGAR","C",07,00,"PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","PedidoGAR","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","03","Z6_CODENT","C",06,00,"Cod.Entidade","Cod.Entidade","Cod.Entidade","CodigoEntidade","CodigoEntidade","CodigoEntidade","","","€€€€€€€€€€€€€€ ","","SZ3_04",00,"þÀ","","S","U","S","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","04","Z6_DESENT","C",100,00,"NomeEntidad","NomeEntidad","NomeEntidad","NomeEntidade","NomeEntidade","NomeEntidade","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","V","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","05","Z6_TPENTID","C",02,00,"TpEntidade","TpEntidade","TpEntidade","TipoEntidade","TipoEntidade","TipoEntidade","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","€","PERTENCE('1,2,3,4')","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","1=Canal;2=AC;3=AR;4=Posto","","","U_COM020BRW(SZ6->Z6_TPENTID)","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","06","Z6_REGCOM","C",100,00,"RegrasCom.","RegrasCom.","RegrasCom.","RegrasComissao","RegrasComissao","RegrasComissao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","07","Z6_PRODUTO","C",20,00,"Cod.Produto","Cod.Produto","Cod.Produto","Cod.ProdutoProtheus","Cod.ProdutoProtheus","Cod.ProdutoProtheus","","","€€€€€€€€€€€€€€ ","","PA8",00,"þÀ","","S","U","S","A","R","€","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","08","Z6_CATPROD","C",01,00,"Categ.Produt","Categ.Produt","Categ.Produt","CategoriaProduto","CategoriaProduto","CategoriaProduto","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","1=Hardware;2=Software","1=Hardware;2=Software","1=Hardware;2=Software","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","09","Z6_DESCRPR","C",100,00,"Descr.Produt","Descr.Produt","Descr.Produt","DescricaoProduto","DescricaoProduto","DescricaoProduto","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","10","Z6_VLRPROD","N",12,02,"VlrProduto","VlrProduto","VlrProduto","VlrProduto","VlrProduto","VlrProduto","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","11","Z6_BASECOM","N",12,02,"VlrBaseCom","VlrBaseCom","VlrBaseCom","ValorBaseComissao","ValorBaseComissao","ValorBaseComissao","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","12","Z6_VALCOM","N",12,02,"VlrComissao","VlrComissao","VlrComissao","Valordacomissaoapagar","Valordacomissaoapagar","Valordacomissaoapagar","@E999,999,999.99","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","13","Z6_DTPEDI","D",08,00,"DataPedido","DataPedido","DataPedido","DataPedido","DataPedido","DataPedido","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","14","Z6_CPFAGEN","C",14,00,"CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","CPFAgente","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","15","Z6_DTEMISS","D",08,00,"DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","DataEmissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","16","Z6_NOMAGEN","C",100,00,"NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","NomeAgente","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","17","Z6_NCLIENT","C",100,00,"NomeCliente","NomeCliente","NomeCliente","NomeCliente","NomeCliente","NomeCliente","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","18","Z6_TPVOU","C",01,00,"TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","TipoVoucher","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","1=Corporativo;2=SuporteGarantia;3=SACSubstituicao;4=Cortesia;5=Funcionario;6=Teste","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","19","Z6_CODVOU","C",20,00,"Cod.Voucher","Cod.Voucher","Cod.Voucher","Cod.Voucher","Cod.Voucher","Cod.Voucher","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","20","Z6_DESCVOU","C",100,00,"Desc.Voucher","Desc.Voucher","Desc.Voucher","DescricaodoVoucher","DescricaodoVoucher","DescricaodoVoucher","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","21","Z6_PRFNFS","C",03,00,"SerieNF","SerieNF","SerieNF","SerieNF","SerieNF","SerieNF","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","22","Z6_NUMNFS","C",09,00,"NumNFSaida","NumNFSaida","NumNFSaida","NumeroNFSaida","NumeroNFSaida","NumeroNFSaida","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","23","Z6_ITEMNFS","C",03,00,"ItNFSaida","ItNFSaida","ItNFSaida","ItemNFSaida","ItemNFSaida","ItemNFSaida","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","24","Z6_DTPGTO","D",08,00,"DtaPgtoCom","DtaPgtoCom","DtaPgtoCom","DataPagtoComissao","DataPagtoComissao","DataPagtoComissao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","25","Z6_PRFSE2","C",03,00,"Prefixo","Prefixo","Prefixo","PrefixodoC.pagar","PrefixodoC.pagar","PrefixodoC.pagar","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","26","Z6_NUMSE2","C",09,00,"Num.Titulo","Num.Titulo","Num.Titulo","Num.TituloContasPagar","Num.TituloContasPagar","Num.TituloContasPagar","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","27","Z6_PARSE2","C",03,00,"Parcela","Parcela","Parcela","Parcela","Parcela","Parcela","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","28","Z6_TPSE2","C",03,00,"TipoTitulo","TipoTitulo","TipoTitulo","TipoTitulo","TipoTitulo","TipoTitulo","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","29","Z6_FORNSE2","C",06,00,"Fornecedor","Fornecedor","Fornecedor","Fornecedor","Fornecedor","Fornecedor","","","€€€€€€€€€€€€€€ ","","SA2",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","30","Z6_LJFORN","C",02,00,"LojaFornec","LojaFornec","LojaFornec","LojaFornecedor","LojaFornecedor","LojaFornecedor","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","31","Z6_DTALTER","D",08,00,"DtAlteracao","DtAlteracao","DtAlteracao","DataAlteracao","DataAlteracao","DataAlteracao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(INCLUI,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","32","Z6_USUARIO","C",60,00,"Usuario","Usuario","Usuario","Usuarioquealterou","Usuarioquealterou","Usuarioquealterou","","","€€€€€€€€€€€€€€ ","cUserName+''+DtoC(dDataBase)+''+Time()+'INCLUIDO'","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","33","Z6_MOTALT","C",100,00,"Mot.Altera","Mot.Altera","Mot.Altera","MotivodeAlteracao","MotivodeAlteracao","MotivodeAlteracao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(INCLUI,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","34","Z6_CODCAN","C",06,00,"Canal","Canal","Canal","Canal","Canal","Canal","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","35","Z6_CODAC","C",06,00,"A.C.","A.C.","A.C.","A.C.","A.C.","A.C.","@!","","€€€€€€€€€€€€€€ ","","",01,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","36","Z6_CODAR","C",06,00,"A.R.","A.R.","A.R.","A.R.","A.R.","A.R.","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","37","Z6_CODPOS","C",06,00,"Posto","Posto","Posto","Posto","Posto","Posto","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	AADD(aSX3,{"SZ6","38","Z6_TIPO","C",06,00,"TipoMovRem","TipoMovRem","TipoMovRem","TipoMov.deRemuneracao","TipoMov.deRemuneracao","TipoMov.deRemuneracao","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","","","","","","","IF(ALTERA,.F.,.T.)","","","","","","","N","N","N","","","N","N","N"})
	
	AADD(aSX3,{"SZA","01","ZA_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","","","","","","","","","","","","","","","","","","","","N","N","N"})
	AADD(aSX3,{"SZA","02","ZA_CODCLA","C",03,00,"CodClassif.","CodClassif.","CodClassif.","CodigodaClassificacao","CodigodaClassificacao","CodigodaClassificacao","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","ExistChav('SZA',M->ZA_CODCLA)","","","","","INCLUI","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZA","03","ZA_DESCLA","C",60,00,"DescClassif","DescClassif","DescClassif","DescricaodaClassificac","DescricaodaClassificac","DescricaodaClassificac","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZA","04","ZA_TIPENT","C",01,00,"Tipoclassif","Tipoclassif","Tipoclassif","Tipodaclassificacao","Tipodaclassificacao","Tipodaclassificacao","@1","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","PERTENCE('12')","1=Interna;2=Externa","1=Interna;2=Externa","1=Interna;2=Externa","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZA","05","ZA_REDATE","C",15,00,"RedeAtendim","RedeAtendim","RedeAtendim","RedeAtendimento","RedeAtendimento","RedeAtendimento","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","A","R","€","","","","","","","","","","","","","","N","N","","N","N","N"})
	
	AADD(aSX3,{"SZV","01","ZV_FILIAL","C",02,00,"Filial","Sucursal","Branch","FilialdoSistema","Sucursal","BranchoftheSystem","@!","","€€€€€€€€€€€€€€€","","",01,"þÀ","","","U","N","A","R","","","","","","","","","033","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","02","ZV_CODENT","C",06,00,"CodEntidade","CodEntidade","CodEntidade","CodigodaEntidade","CodigodaEntidade","CodigodaEntidade","@!","","€€€€€€€€€€€€€€ ","","SZ3",00,"þÀ","","S","U","S","A","R","€","Existcpo('SZ3',M->ZV_CODENT)","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","03","ZV_DESENT","C",100,00,"DescrEntid.","DescrEntid.","DescrEntid.","DescricaodaEntidade","DescricaodaEntidade","DescricaodaEntidade","@!","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","04","ZV_QTDJAN","N",06,00,"Janeiro","Janeiro","Janeiro","QuantidadeJaneiro","QuantidadeJaneiro","QuantidadeJaneiro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","05","ZV_QTDFEV","N",06,00,"Fevereiro","Fevereiro","Fevereiro","QuantidadeFevereiro","QuantidadeFevereiro","QuantidadeFevereiro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","06","ZV_QTDMAR","N",06,00,"Marco","Marco","Marco","QuantidadeMarco","QuantidadeMarco","QuantidadeMarco","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","07","ZV_QTDABR","N",06,00,"Abril","Abril","Abril","QuantidadeAbril","QuantidadeAbril","QuantidadeAbril","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","08","ZV_QTDMAI","N",06,00,"Maio","Maio","Maio","QuantidadeMaio","QuantidadeMaio","QuantidadeMaio","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","09","ZV_QTDJUN","N",06,00,"Junho","Junho","Junho","QuantidadeJunho","QuantidadeJunho","QuantidadeJunho","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","10","ZV_QTDJUL","N",06,00,"Julho","Julho","Julho","QuantidadeJulho","QuantidadeJulho","QuantidadeJulho","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","11","ZV_QTDAGO","N",06,00,"Agosto","Agosto","Agosto","QuantidadeAgosto","QuantidadeAgosto","QuantidadeAgosto","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","12","ZV_QTDSET","N",06,00,"Setembro","Setembro","Setembro","QuantidadeSetembro","QuantidadeSetembro","QuantidadeSetembro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","13","ZV_QTDOUT","N",06,00,"Outubro","Outubro","Outubro","QuantidadeOutubro","QuantidadeOutubro","QuantidadeOutubro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","14","ZV_QTDNOV","N",06,00,"Novembro","Novembro","Novembro","QuantidadeNovembro","QuantidadeNovembro","QuantidadeNovembro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","15","ZV_QTDDEZ","N",06,00,"Dezembro","Dezembro","Dezembro","QuantidadeDezembro","QuantidadeDezembro","QuantidadeDezembro","@E999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","u_C04SAcum()","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","16","ZV_SALACU","N",08,00,"SaldoAcum.","SaldoAcum.","SaldoAcum.","SaldoAcumulado","SaldoAcumulado","SaldoAcumulado","@E99,999,999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","V","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","17","ZV_SALANO","N",04,00,"Ano","Ano","Ano","Ano","Ano","Ano","@E9999","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","","N","N","","N","N","N"})
	AADD(aSX3,{"SZV","18","ZV_CATPROD","C",02,00,"CatRemProd","CatRemProd","CatRemProd","CategoriaRem.Produto","CategoriaRem.Produto","CategoriaRem.Produto","","","€€€€€€€€€€€€€€ ","","ZY",00,"þÀ","","S","U","N","A","R","","EXISTCPO('SX5','ZY'+M->ZV_CATPROD).OR.Vazio()","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZV","19","ZV_CATDESC","C",55,00,"Descr.Cat.","Descr.Cat.","Descr.Cat.","Descr.CategoriaRem.","Descr.CategoriaRem.","Descr.CategoriaRem.","","","€€€€€€€€€€€€€€ ","","",00,"þÀ","","","U","N","V","R","","","","","","","","","","","","","","","N","N","","","N","N","N"})
	AADD(aSX3,{"SZV","20","ZV_LOGALT","C",60,00,"LogAltera","LogAltera","LogAltera","LogAlteracao","LogAlteracao","LogAlteracao","","","€€€€€€€€€€€€€€ ","ALLTRIM(CUSERNAME)+'-'+DTOC(DDATABASE)+'-'+TIME()+'-INCLUIDO'","",00,"þÀ","","","U","S","A","R","","","","","","","","","","","","","","N","N","N","","","N","N","N"})

	/*
	[1]Indice
	[2]Ordem
	[3]Chave
	[4]Descrição
	[5]Descriçãoespanhol
	[6]Descriçãoinglês
	[7]Proprietário
	[8]Showpesquisa
	*/

	aSIX:={}

	AADD(aSIX,{"PA8","1","PA8_FILIAL+PA8_CODBPG","CodigodeProdutoBpag","CodigodeProdutoBpag","CodigodeProdutoBpag","U","","PA8_01",""})
	AADD(aSIX,{"PA8","2","PA8_FILIAL+PA8_CODMP8","CodigodeProdutoProtheus","CodigodeProdutoProtheus","CodigodeProdutoProtheus","U","","PA8_02",""})

	AADD(aSIX,{"SZ3","1","Z3_FILIAL+Z3_CODENT","CodEntidade","CodEntidade","CodEntidade","U","","","S"})
	AADD(aSIX,{"SZ3","2","Z3_FILIAL+Z3_DESENT","DescrEntid.","DescrEntid.","DescrEntid.","U","","","S"})
	AADD(aSIX,{"SZ3","3","Z3_FILIAL+Z3_CODFOR","CodFornec.","CodFornec.","CodFornec.","U","","","S"})
	AADD(aSIX,{"SZ3","4","Z3_FILIAL+Z3_CODGAR","EntnoGAR","EntnoGAR","EntnoGAR","U","","COD.GAR.","S"})
	AADD(aSIX,{"SZ3","5","Z3_FILIAL+Z3_PONDIS","PontoDistr.","PontoDistr.","PontoDistr.","U","","PONDISTRIB","S"})

	AADD(aSIX,{"SZ4","1","Z4_FILIAL+Z4_CODENT+Z4_CATPROD","CodEntidade+CatRemProd","CodEntidade+CatRemProd","CodEntidade+CatRemProd","U","","","N"})

	AADD(aSIX,{"SZ5","1","Z5_FILIAL+Z5_PEDGAR+Z5_TIPO","PedidoGAR+TipodeRem","PedidoGAR+TipodeRem","PedidoGAR+TipodeRem","U","","","S"})
	AADD(aSIX,{"SZ5","2","Z5_FILIAL+Z5_FLAGA","FlagAtualiza","FlagAtualiza","FlagAtualiza","U","","","N"})
	AADD(aSIX,{"SZ5","3","Z5_FILIAL+Z5_PEDIDO+Z5_ITEMPV","Pedido+item","Pedido+item","Pedido+item","U","","","N"})

	AADD(aSIX,{"SZ6","1","Z6_FILIAL+Z6_PEDGAR+Z6_CODENT","PedidoGAR+Cod.Entidade","PedidoGAR+Cod.Entidade","PedidoGAR+Cod.Entidade","U","","","S"})
	AADD(aSIX,{"SZ6","2","Z6_FILIAL+Z6_CODENT+Z6_PEDGAR","Cod.Entidade+PedidoGAR","Cod.Entidade+PedidoGAR","Cod.Entidade+PedidoGAR","U","","","S"})
	AADD(aSIX,{"SZ6","3","Z6_FILIAL+Z6_PEDGAR+Z6_TIPO","PedidoGAR+TipoMovRem","PedidoGAR+TipoMovRem","PedidoGAR+TipoMovRem","U","","","N"})

	AADD(aSIX,{"SZA","1","ZA_FILIAL+ZA_CODCLA","CodClassif.","CodClassif.","CodClassif.","U","","","S"})
	AADD(aSIX,{"SZA","2","ZA_FILIAL+ZA_DESCLA","DescClassif","DescClassif","DescClassif","U","","","S"})

	AADD(aSIX,{"SZV","1","ZV_FILIAL+ZV_CODENT+ZV_SALANO","CodEntidade+Cod.Faixa","CodEntidade+Cod.Faixa","CodEntidade+Cod.Faixa","U","","","N"})
	
	FA010CanUse()	
	
Return         

//-------------------------------------------------------------------
// Rotina | FA010CanUse | Autor | Tatiana Pontes  | Dt | 16/05/12
//-------------------------------------------------------------------
// Descr. | Rotina para verificar se a infra-estrurura da rotina foi
//        | criada.
//-------------------------------------------------------------------
// Uso    | Certisign
//-------------------------------------------------------------------
Static Function FA010CanUse()

	Local nI := 0
	Local aCpoSXB := {}
	Local aSXB := {}
	Local cTamSXB := 0

	//--------------------------------------------------------
	// Verificar se existe o parâmetro com os tipos de listas.
	//--------------------------------------------------------
	If !ExisteSX6( "MV_REMMES" )
		CriarSX6( "MV_REMMES", 'C', 'Ano e mes de competencia para calculo de remuneracao de parceiros - CRPA020.prw', '201208' )
	Endif

	If !ExisteSX6( "MV_TIPGAR"  )
		CriarSX6( "MV_TIPGAR" , 'C', 'Tipos de processos Gar - CRPA020.prw', 'VALIDA;HWAVUL;ENTMID;CAMPCO;CLUBRE' )
	Endif

	If !ExisteSX6( 'MV_TIPCONT' )
		CriarSX6( 'MV_TIPCONT', 'C', 'Define quais sao os tipos de processos do Gar que serao considerados na contagem de certificados verificados para compor saldo mensal - CRPA050.prw', 'CAMPCO;VALIDA' )
	Endif


	//-------------------------------
	// Verificar se existe o gatilho.
	//-------------------------------

	SX7->(dbSetOrder(1))
	If ! SX7->(dbSeek('Z6_PRODUTO'+'001'))
		SX7->(RecLock('SX7',.T.))
		SX7->X7_CAMPO   := 'Z6_PRODUTO'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'PA8->PA8_DESBPG'
		SX7->X7_CDOMIN  := 'Z6_DESCRPR'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'N'
		SX7->X7_ALIAS   := 'PA8'
		SX7->X7_ORDEM   := 1
		SX7->X7_CHAVE   := 'XFILIAL("PA8")+M->Z6_PRODUTO'
		SX7->X7_CONDIC  := ''
		SX7->X7_PROPRI  := 'U'
		SX7->(MsUnLock())
	Endif

	SX7->(dbSetOrder(1))
	If ! SX7->(dbSeek('ZV_CODENT'+'001'))
		SX7->(RecLock('SX7',.T.))
		SX7->X7_CAMPO   := 'ZV_CODENT'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'SZ3->Z3_DESENT'
		SX7->X7_CDOMIN  := 'ZV_DESENT'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'S'
		SX7->X7_ALIAS   := 'SZ3'
		SX7->X7_ORDEM   := 1
		SX7->X7_CHAVE   := 'XFILIAL("SZV")+M->ZV_CODENT'
		SX7->X7_CONDIC  := ''
		SX7->X7_PROPRI  := 'U'
		SX7->(MsUnLock())
	Endif

	SX7->(dbSetOrder(1))
	If ! SX7->(dbSeek('Z4_CATPROD'+'001'))
		SX7->(RecLock('SX7',.T.))
		SX7->X7_CAMPO   := 'Z4_CATPROD'
		SX7->X7_SEQUENC := '001'
		SX7->X7_REGRA   := 'X5DESCRI()'
		SX7->X7_CDOMIN  := 'Z4_CATDESC'
		SX7->X7_TIPO    := 'P'
		SX7->X7_SEEK    := 'S'
		SX7->X7_ALIAS   := 'SX5'
		SX7->X7_ORDEM   := 1
		SX7->X7_CHAVE   := 'xFilial("SX5") + "ZY" + M->Z4_CATPROD'
		SX7->X7_CONDIC  := ''
		SX7->X7_PROPRI  := 'U'
		SX7->(MsUnLock())
	Endif

	//--------------------------
	// Existe a consulta padrão.
	//--------------------------

	SXB->( dbSetOrder( 1 ) )
	If ! SXB->( dbSeek( 'SZ3' ) )
 
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		AADD(aSXB,{"SZ3","1","01","DB","Consulta de Entidade","Consulta de Entidade","Consulta de Entidade","SZ3",""})
		AADD(aSXB,{"SZ3","2","01","01","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","",""})
		AADD(aSXB,{"SZ3","2","02","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","",""})
		AADD(aSXB,{"SZ3","3","01","01","Cadastra Novo       ","Incluye Nuevo       ","Add New             ","01",""})
		AADD(aSXB,{"SZ3","4","01","01","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","Z3_CODENT",""})
		AADD(aSXB,{"SZ3","4","01","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","Z3_DESENT",""})
		AADD(aSXB,{"SZ3","4","02","01","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","Z3_DESENT",""})
		AADD(aSXB,{"SZ3","4","02","02","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","Z3_CODENT",""})
		AADD(aSXB,{"SZ3","5","01","  ","                    ","                    ","                    ","SZ3->Z3_CODENT",""})
 
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI

	Endif
	
	SXB->( dbSetOrder( 1 ) )

	If ! SXB->( dbSeek( 'SZ3_05' ) )
 
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		AADD(aSXB,{"SZ3_05","1","01","DB","Entidade por Cod Gar","Entidade por Cod Gar","Entidade por Cod Gar","SZ3                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","2","01","04","Ent No Gar          ","Ent No Gar          ","Ent No Gar          ","COD. GAR.                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","2","02","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","2","03","01","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","01","01","Ent no GAR          ","Ent no GAR          ","Ent no GAR          ","Z3_CODGAR                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","01","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","Z3_DESENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","01","03","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","Z3_CODENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","02","01","Ent no GAR          ","Ent no GAR          ","Ent no GAR          ","Z3_CODGAR                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","02","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","Z3_DESENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","02","03","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","Z3_CODENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","03","01","Ent no GAR          ","Ent no GAR          ","Ent no GAR          ","Z3_CODGAR                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","03","02","Descr Entid.        ","Descr Entid.        ","Descr Entid.        ","Z3_DESENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","4","03","03","Cod Entidade        ","Cod Entidade        ","Cod Entidade        ","Z3_CODENT                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZ3_05","5","01","  ","                    ","                    ","                    ","SZ3->Z3_CODGAR                                                                                                                                                                                                                                            ","                                                                                                                                                                                                                                                          "})
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI

	Endif

	SXB->( dbSetOrder( 1 ) )

	If ! SXB->( dbSeek( 'SZA_01' ) )
 
		nTamSXB := Len( SXB->XB_ALIAS )
		aCpoSXB := { "XB_ALIAS","XB_TIPO","XB_SEQ","XB_COLUNA","XB_DESCRI","XB_DESCSPA","XB_DESCENG","XB_CONTEM","XB_WCONTEM" }
		
		AADD(aSXB,{"SZA_01","1","01","DB","Classifica Ent/Prod ","Classifica Ent/Prod ","Classifica Ent/Prod ","SZA                                                                                                                                                                                                                                                       ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","2","01","01","Cod Classif.        ","Cod Classif.        ","Cod Classif.        ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","2","02","02","Desc Classif        ","Desc Classif        ","Desc Classif        ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","3","01","01","Cadastra Novo       ","Incluye Nuevo       ","Add New             ","01                                                                                                                                                                                                                                                        ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","4","01","01","Cod Classif.        ","Cod Classif.        ","Cod Classif.        ","ZA_CODCLA                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","4","01","02","Desc Classif        ","Desc Classif        ","Desc Classif        ","ZA_DESCLA                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","4","02","01","Desc Classif        ","Desc Classif        ","Desc Classif        ","ZA_DESCLA                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","4","02","02","Cod Classif.        ","Cod Classif.        ","Cod Classif.        ","ZA_CODCLA                                                                                                                                                                                                                                                 ","                                                                                                                                                                                                                                                          "})
		AADD(aSXB,{"SZA_01","5","01","  ","                    ","                    ","                    ","SZA->ZA_CODCLA                                                                                                                                                                                                                                            ","                                                                                                                                                                                                                                                          "})
		
		SXB->( dbSetOrder( 1 ) )
		For nI := 1 To Len( aSXB )
			If ! SXB->( dbSeek( PadR( aSXB[ nI, 1 ], nTamSXB ) + aSXB[ nI,2 ] + aSXB[ nI, 3 ] + aSXB[ nI, 4 ] ) )
				SXB->( RecLock( 'SXB', .T. )) 
				For nJ := 1 To Len( aCpoSXB )
					SXB->( FieldPut( FieldPos( aCpoSXB[ nJ ] ), aSXB[ nI, nJ ] ) )
				Next nJ
				SXB->( MsUnLock() )
			Endif
		Next nI

	Endif
		
Return(.T.)