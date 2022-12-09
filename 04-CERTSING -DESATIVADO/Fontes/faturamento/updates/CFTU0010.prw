#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0010 |Autor: |David Alves dos Santos |Data: |22/05/2019   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de update de dicionários para compatibilização.        |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |C    = Certisign.                                             |
//|do codigo    |FT   = Modulo faturamento SIGAFAT.                            |
//|fonte.       |U    = Update.                                                |
//|             |9999 = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CFTU0010()
	
	Local aRet := { {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }

	//-> ESTRUTURA DO ARRAY aRET:
	//-> aRet[01] - Array com os dados SX2
	//-> aRet[02] - Array com os dados SIX
	//-> aRet[03] - Array com os dados SX3
	//-> aRet[04] - Array com os dados SX5
	//-> aRet[05] - Array com os dados SX7
	//-> aRet[06] - Array com os dados SX9
	//-> aRet[07] - Array com os dados SXA
	//-> aRet[08] - Array com os dados SXB
	//-> aRet[09] - Array com os dados SX6
	//-> aRet[10] - Array com as rotina pós Update

	aRet[01] := UpdAtuSX2()
	aRet[02] := UpdAtuSIX()
	aRet[03] := UpdAtuSX3()
	
	//aRet[04] := UpdAtuSX5()
	//aRet[05] := UpdAtuSX7()
	//aRet[06] := UpdAtuSX9()
	//aRet[07] := UpdAtuSXA()
	//aRet[08] := UpdAtuSXB()
	//aRet[09] := UpdAtuSX6()
	//aRet[10] := UpdAtuRot()

Return( aRet )


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdGetInfo |Autor: |David Alves dos Santos |Data: |22/05/2019   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para setar as informações do update.                     |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function UpdGetInfo()
	
	Local aRet := {}

	//-> ESTRUTURA DO ARRAY aRET:
	//-> aRet[01] - (C) Nome da Function
	//-> aRet[02] - (C) Descritivo do Update
	//-> aRet[03] - (C) Numero do Chamado
	//-> aRet[04] - (C) Nome do autor
	//-> aRet[05] - (A) Array contendo o Help
	AAdd( aRet, 'CFTU0010')
	AAdd( aRet, 'Criação de tabelas e campos referente a integração com o PipeDrive.')
	AAdd( aRet, '2019050610002451')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
					{"Criação das tabelas PBW, PBX e seus respectivos campos."};
				})
				
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX2 |Autor: |David Alves dos Santos |Data: |22/05/2019   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Criação de tabelas dentro do SX2.                              |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX2()

	Local aSX2   := {}
	Local lRet   := .F.
	
	//-> Cabeçalho Ciclo
	AAdd( aSX2, { 	"PBW",;								//-> X2_CHAVE
					"",;								//-> X2_PATH
					"PBW010",;							//-> X2_ARQUIVO
					"Configuracao Pipedrive        ",;	//-> X2_NOME
					"Configuracao Pipedrive        ",;	//-> X2_NOMESPA
					"Configuracao Pipedrive        ",;	//-> X2_NOMEENGs
					0,;									//-> X2_DELET
					"E",;								//-> X2_MODO
					"",;								//-> X2_TTS
					"",;								//-> X2_ROTINA
					"N",;								//-> X2_PYME
					"",;								//-> X2_UNICO
					"E",;								//-> X2_MODOEMP
					"E",;								//-> X2_MODOUN
					0,;									//-> X2_MODULO
					"",;								//-> X2_SYSOBJ
					"" })								//-> X2_USROBJ
					
	//-> Cabeçalho Ciclo
	AAdd( aSX2, { 	"PBX",;								//-> X2_CHAVE
					"",;								//-> X2_PATH
					"PBX010",;							//-> X2_ARQUIVO
					"Estagios do Pipeline          ",;	//-> X2_NOME
					"Estagios do Pipeline          ",;	//-> X2_NOMESPA
					"Estagios do Pipeline          ",;	//-> X2_NOMEENGs
					0,;									//-> X2_DELET
					"E",;								//-> X2_MODO
					"",;								//-> X2_TTS
					"",;								//-> X2_ROTINA
					"N",;								//-> X2_PYME
					"",;								//-> X2_UNICO
					"E",;								//-> X2_MODOEMP
					"E",;								//-> X2_MODOUN
					0,;									//-> X2_MODULO
					"",;								//-> X2_SYSOBJ
					"" })								//-> X2_USROBJ

Return( aSX2 )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSIX |Autor: |David Alves dos Santos |Data: |22/05/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Criação de indices nas tabelas.                                |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSIX()

	Local aSIX   := {}

	AAdd( aSIX, { 	"PBW",;								//-> INDICE
					"1",;								//-> ORDEM
					"PBW_FILIAL+PBW_COD",;				//-> CHAVE
					"Codigo    ",;						//-> DESCRICAO
					"Codigo    ",;						//-> DESCSPA
					"Codigo    ",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ

	AAdd( aSIX, { 	"PBX",;								//-> INDICE
					"1",;								//-> ORDEM
					"PBX_FILIAL+PBX_COD",;				//-> CHAVE
					"Codigo    ",;						//-> DESCRICAO
					"Codigo    ",;						//-> DESCSPA
					"Codigo    ",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
					
	AAdd( aSIX, { 	"PBX",;								//-> INDICE
					"2",;								//-> ORDEM
					"PBX_FILIAL+PBX_COD+PBX_ITEM",;		//-> CHAVE
					"Codigo+Item",;						//-> DESCRICAO
					"Codigo+Item",;						//-> DESCSPA
					"Codigo+Item",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ

Return( aSIX )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX3 |Autor: |David Alves dos Santos |Data: |24/05/2019   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX3 - Campos.           |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX3()

	Local aSX3   := {}
	Local n1Cnt  := 0
	Local lRet   := .F.
	Local cOrdem := ''

	lRet := .F.
	DbSelectArea('SX3')
	
	cOrdem := "01"
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		//-> Tabela PBW - Cadastro de Pipeline
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_FILIAL",;								//-> Campo
						"C",;										//-> Tipo
						2,;											//-> Tamanho
						0,;											//-> Decimal
						"Filial      ",;							//-> Titulo
						"Sucursal    ",;							//-> Titulo SPA
						"Branch      ",;							//-> Titulo ENG
						"Filial do Sistema        ",;				//-> Descricao
						"Sucursal                 ",;				//-> Descricao SPA
						"Branch of the System     ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"xFilial('PBW')",;         					//-> RELACAO
						"",;                     					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",;                       					//-> CHECK
						"",;                      					//-> TRIGGER
						"U",;                      					//-> PROPRI
						"N",;                      					//-> BROWSE
						"V",;                      					//-> VISUAL
						"R",;                      					//-> CONTEXT
						"",;                       					//-> OBRIGAT
						"",;                       					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;                       					//-> INIBRW
						"",;                       					//-> SXG
						"",;                       					//-> FOLDER
						"S"})                      					//-> PYME


		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_COD",;									//-> Campo
						"C",;										//-> Tipo
						6,;											//-> Tamanho
						0,;											//-> Decimal
						"Codigo      ",;							//-> Titulo
						"Codigo      ",;							//-> Titulo SPA
						"Codigo      ",;							//-> Titulo ENG
						"Codigo                   ",;				//-> Descricao
						"Codigo                   ",;				//-> Descricao SPA
						"Codigo                   ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"GetSXENum('PBW','PBW_COD')",; 				//-> RELACAO
						"",;                     					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",;                       					//-> CHECK
						"",;                      					//-> TRIGGER
						"U",;                      					//-> PROPRI
						"S",;                      					//-> BROWSE
						"V",;                      					//-> VISUAL
						"R",;                      					//-> CONTEXT
						"",;                       					//-> OBRIGAT
						"",;                       					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;                       					//-> INIBRW
						"",;                       					//-> SXG
						"",;                       					//-> FOLDER
						"S"})                      					//-> PYME
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_CODPPL",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod Pipeline",;							//-> Titulo
						"Cod Pipeline",;							//-> Titulo SPA
						"Cod Pipeline",;							//-> Titulo ENG
						"Codigo Pipeline          ",;				//-> Descricao
						"Codigo Pipeline          ",;				//-> Descricao SPA
						"Codigo Pipeline          ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_DESPPL",;								//-> Campo
						"C",;										//-> Tipo
						200,;										//-> Tamanho
						0,;											//-> Decimal
						"Dsc Pipeline",;							//-> Titulo
						"Dsc Pipeline",;							//-> Titulo SPA
						"Dsc Pipeline",;							//-> Titulo ENG
						"Descricao Pipeline       ",;				//-> Descricao
						"Descricao Pipeline       ",;				//-> Descricao SPA
						"Descricao Pipeline       ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
	
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_CODMST",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod. Mestre ",;							//-> Titulo
						"Cod. Mestre ",;							//-> Titulo SPA
						"Cod. Mestre ",;							//-> Titulo ENG
						"Cod. Mestre do Pipeline  ",;				//-> Descricao
						"Cod. Mestre do Pipeline  ",;				//-> Descricao SPA
						"Cod. Mestre do Pipeline  ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_USRMST",;								//-> Campo
						"C",;										//-> Tipo
						200,;										//-> Tamanho
						0,;											//-> Decimal
						"Usr. Mestre ",;							//-> Titulo
						"Usr. Mestre ",;							//-> Titulo SPA
						"Usr. Mestre ",;							//-> Titulo ENG
						"Usr. Mestre do Pipeline  ",;				//-> Descricao
						"Usr. Mestre do Pipeline  ",;				//-> Descricao SPA
						"Usr. Mestre do Pipeline  ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_CDSTIN",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod Est Ini.",;							//-> Titulo
						"Cod Est Ini.",;							//-> Titulo SPA
						"Cod Est Ini.",;							//-> Titulo ENG
						"Codigo do Estagio Inicial",;				//-> Descricao
						"Codigo do Estagio Inicial",;				//-> Descricao SPA
						"Codigo do Estagio Inicial",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_STGINI",;								//-> Campo
						"C",;										//-> Tipo
						200,;										//-> Tamanho
						0,;											//-> Decimal
						"Estagio Ini.",;							//-> Titulo
						"Estagio Ini.",;							//-> Titulo SPA
						"Estagio Ini.",;							//-> Titulo ENG
						"Estagio Inicial          ",;				//-> Descricao
						"Estagio Inicial          ",;				//-> Descricao SPA
						"Estagio Inicial          ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBW",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBW_DTINI",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data Inicial",;							//-> Titulo
						"Data Inicial",;							//-> Titulo SPA
						"Data Inicial",;							//-> Titulo ENG
						"Data Inicial             ",;				//-> Descricao
						"Data Inicial             ",;				//-> Descricao SPA
						"Data Inicial             ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		
		//-> Tabela PBX - Cadastro de Estagio.
		cOrdem := "01"
		AAdd( aSX3, { 	"PBX",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBX_FILIAL",;								//-> Campo
						"C",;										//-> Tipo
						2,;											//-> Tamanho
						0,;											//-> Decimal
						"Filial      ",;							//-> Titulo
						"Sucursal    ",;							//-> Titulo SPA
						"Branch      ",;							//-> Titulo ENG
						"Filial do Sistema        ",;				//-> Descricao
						"Sucursal                 ",;				//-> Descricao SPA
						"Branch of the System     ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"xFilial('PBX')",;         					//-> RELACAO
						"",;                     					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",;                       					//-> CHECK
						"",;                      					//-> TRIGGER
						"U",;                      					//-> PROPRI
						"N",;                      					//-> BROWSE
						"V",;                      					//-> VISUAL
						"R",;                      					//-> CONTEXT
						"",;                       					//-> OBRIGAT
						"",;                       					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;                       					//-> INIBRW
						"",;                       					//-> SXG
						"",;                       					//-> FOLDER
						"S"})                      					//-> PYME
		
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBX",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBX_ITEM",;								//-> Campo
						"C",;										//-> Tipo
						4,;											//-> Tamanho
						0,;											//-> Decimal
						"Item        ",;							//-> Titulo
						"Item        ",;							//-> Titulo SPA
						"Item        ",;							//-> Titulo ENG
						"Item do Estagio          ",;				//-> Descricao
						"Item do Estagio          ",;				//-> Descricao SPA
						"Item do Estagio          ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
						"V",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
			
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBX",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBX_IDSTG",;								//-> Campo
						"C",;										//-> Tipo
						6,;											//-> Tamanho
						0,;											//-> Decimal
						"ID. Estagio ",;							//-> Titulo
						"ID. Estagio ",;							//-> Titulo SPA
						"ID. Estagio ",;							//-> Titulo ENG
						"ID do Estagio            ",;				//-> Descricao
						"ID do Estagio            ",;				//-> Descricao SPA
						"ID do Estagio            ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBX",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBX_DSCSTG",;								//-> Campo
						"C",;										//-> Tipo
						150,;										//-> Tamanho
						0,;											//-> Decimal
						"Des. Estag. ",;							//-> Titulo
						"Des. Estag. ",;							//-> Titulo SPA
						"Des. Estag. ",;							//-> Titulo ENG
						"Descricao do Estagio     ",;				//-> Descricao
						"Descricao do Estagio     ",;				//-> Descricao SPA
						"Descricao do Estagio     ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"NaoVazio()",; 	         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"S",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"PBX",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"PBX_COD",;									//-> Campo
						"C",;										//-> Tipo
						6,;											//-> Tamanho
						0,;											//-> Decimal
						"Codigo      ",;							//-> Titulo
						"Codigo      ",;							//-> Titulo SPA
						"Codigo      ",;							//-> Titulo ENG
						"Codigo                   ",;				//-> Descricao
						"Codigo                   ",;				//-> Descricao SPA
						"Codigo                   ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;                       					//-> RELACAO
						"",;                     					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",;                       					//-> CHECK
						"",;                      					//-> TRIGGER
						"U",;                      					//-> PROPRI
						"N",;                      					//-> BROWSE
						"A",;                      					//-> VISUAL
						"R",;                      					//-> CONTEXT
						"",;                       					//-> OBRIGAT
						"",;                       					//-> VLDUSER
						"",;										//-> CBOX
						"",;										//-> CBOX SPA
						"",;										//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;                       					//-> INIBRW
						"",;                       					//-> SXG
						"",;                       					//-> FOLDER
						"S"})                      					//-> PYME
		
		
	EndIf	

Return( aSX3 )