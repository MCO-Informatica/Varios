#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0004 |Autor: |David Alves dos Santos |Data: |02/03/2018   |
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
User Function CFTU0005()
	
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
//|Programa:    |UpdGetInfo |Autor: |David Alves dos Santos |Data: |02/03/2018   |
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
	AAdd( aRet, 'CFTU0005')
	AAdd( aRet, 'Criação de tabelas e campos referente a integração SAV e Performa.')
	AAdd( aRet, '2018040410003092')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação da tabela ZZA e seus respectivos campos."},;
				 	{"Criação da tabela ZZD e seus respectivos campos."},;
				 	{"Criação da tabela ZZH e seus respectivos campos."};
				  })
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX2 |Autor: |David Alves dos Santos |Data: |27/03/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Criação de tabelas dentro do SX2.                              |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX2()

	Local aSX2   := {}
	Local n1Cnt  := 0
	Local lRet   := .F.
	Local cOrdem := ''
	
	//-> Cabeçalho Ciclo
	AAdd( aSX2, { 	"ZZD",;								//-> X2_CHAVE
					"",;								//-> X2_PATH
					"ZZD010",;							//-> X2_ARQUIVO
					"Cabecalho de Ciclos           ",;	//-> X2_NOME
					"Cabecalho de Ciclos           ",;	//-> X2_NOMESPA
					"Cabecalho de Ciclos           ",;	//-> X2_NOMEENGs
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
					
	//-> Itens do Ciclo.
	AAdd( aSX2, { 	"ZZH",;								//-> X2_CHAVE
					"",;								//-> X2_PATH
					"ZZH010",;							//-> X2_ARQUIVO
					"Itens do Ciclo                ",;	//-> X2_NOME
					"Itens do Ciclo                ",;	//-> X2_NOMESPA
					"Itens do Ciclo                ",;	//-> X2_NOMEENGs
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
							
	//-> Acumulado Ciclos.
	AAdd( aSX2, { 	"ZZA",;								//-> X2_CHAVE
					"",;								//-> X2_PATH
					"ZZA010",;							//-> X2_ARQUIVO
					"Acumulado Ciclos              ",;	//-> X2_NOME
					"Acumulado Ciclos              ",;	//-> X2_NOMESPA
					"Acumulado Ciclos              ",;	//-> X2_NOMEENGs
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
//|Programa:    |UpdAtuSIX |Autor: |David Alves dos Santos |Data: |03/04/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Criação de indices nas tabelas.                                |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSIX()

	Local aSIX   := {}


	AAdd( aSIX, { 	"ZZD",;								//-> INDICE
					"1",;								//-> ORDEM
					"ZZD_FILIAL+ZZD_CDCICL",;			//-> CHAVE
					"Cod. Ciclo",;						//-> DESCRICAO
					"Cod. Ciclo",;						//-> DESCSPA
					"Cod. Ciclo",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
					
					
	AAdd( aSIX, { 	"ZZH",;								//-> INDICE
					"1",;								//-> ORDEM
					"ZZH_FILIAL+ZZH_CDCICL",;			//-> CHAVE
					"Cod. Ciclo",;						//-> DESCRICAO
					"Cod. Ciclo",;						//-> DESCSPA
					"Cod. Ciclo",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
					
	AAdd( aSIX, { 	"ZZH",;								//-> INDICE
					"2",;								//-> ORDEM
					"ZZH_FILIAL+ZZH_CDCICL+ZZH_ITEM",;	//-> CHAVE
					"Cod. Ciclo+Item",;					//-> DESCRICAO
					"Cod. Ciclo+Item",;					//-> DESCSPA
					"Cod. Ciclo+Item",;					//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
		
					
	AAdd( aSIX, { 	"ZZA",;								//-> INDICE
					"1",;								//-> ORDEM
					"ZZA_FILIAL+ZZA_CDCICL",;			//-> CHAVE
					"Cod. Ciclo",;						//-> DESCRICAO
					"Cod. Ciclo",;						//-> DESCSPA
					"Cod. Ciclo",;						//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
					
	AAdd( aSIX, { 	"ZZA",;								//-> INDICE
					"2",;								//-> ORDEM
					"ZZA_FILIAL+ZZA_CDCICL+ZZA_VEND",;	//-> CHAVE
					"Cod. Ciclo+Cod Vendedor",;			//-> DESCRICAO
					"Cod. Ciclo+Cod Vendedor",;			//-> DESCSPA
					"Cod. Ciclo+Cod Vendedor",;			//-> DESCENG
					"U",;								//-> PROPRI
					"",;								//-> F3
					"",;								//-> NICKNAME
					"S" })								//-> SHOWPESQ
					
	AAdd( aSIX, { 	"ZZA",;										//-> INDICE
					"3",;										//-> ORDEM
					"ZZA_FILIAL+ZZA_CDCICL+ZZA_VEND+ZZA_DTDE",;	//-> CHAVE
					"Cod. Ciclo+Cod Vendedor+Data de",;			//-> DESCRICAO
					"Cod. Ciclo+Cod Vendedor+Data de",;			//-> DESCSPA
					"Cod. Ciclo+Cod Vendedor+Data de",;			//-> DESCENG
					"U",;										//-> PROPRI
					"",;										//-> F3
					"",;										//-> NICKNAME
					"S" })										//-> SHOWPESQ
	
Return( aSIX )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX3 |Autor: |David Alves dos Santos |Data: |02/03/2018   |
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
		
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_FILIAL",;								//-> Campo
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
						"xFilial('ZZD')",;         					//-> RELACAO
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
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_CDCICL",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod. Ciclo  ",;							//-> Titulo
						"Cod. Ciclo  ",;							//-> Titulo SPA
						"Cod. Ciclo  ",;							//-> Titulo ENG
						"Codigo do Ciclo          ",;				//-> Descricao
						"Codigo do Ciclo          ",;				//-> Descricao SPA
						"Codigo do Ciclo          ",;				//-> Descricao ENG
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
						"S",;                      					//-> BROWSE
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
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_DSCICL",;								//-> Campo
						"C",;										//-> Tipo
						100,;										//-> Tamanho
						0,;											//-> Decimal
						"Descr. Ciclo",;							//-> Titulo
						"Descr. Ciclo",;							//-> Titulo SPA
						"Descr. Ciclo",;							//-> Titulo ENG
						"Descrição do Ciclo       ",;				//-> Descricao
						"Descrição do Ciclo       ",;				//-> Descricao SPA
						"Descrição do Ciclo       ",;				//-> Descricao ENG
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
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_STATUS",;								//-> Campo
						"C",;										//-> Tipo
						1,;											//-> Tamanho
						0,;											//-> Decimal
						"Status      ",;							//-> Titulo
						"Status      ",;							//-> Titulo SPA
						"Status      ",;							//-> Titulo ENG
						"Status do Ciclo          ",;				//-> Descricao
						"Status do Ciclo          ",;				//-> Descricao SPA
						"Status do Ciclo          ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"U_CSFTA01A()",;         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"0",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"1=Ativo;0=Inativo",;						//-> CBOX
						"1=Ativo;0=Inativo",;						//-> CBOX SPA
						"1=Ativo;0=Inativo",;						//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_DTINI",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Dt. Inicio  ",;							//-> Titulo
						"Dt. Inicio  ",;							//-> Titulo SPA
						"Dt. Inicio  ",;							//-> Titulo ENG
						"Data de Inicio do Ciclo  ",;				//-> Descricao
						"Data de Inicio do Ciclo  ",;				//-> Descricao SPA
						"Data de Inicio do Ciclo  ",;				//-> Descricao ENG
						"",;										//-> Picture
						"",; 			         					//-> VALID
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
		AAdd( aSX3, { 	"ZZD",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZD_DTFIM",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Dt. Fim     ",;							//-> Titulo
						"Dt. Fim     ",;							//-> Titulo SPA
						"Dt. Fim     ",;							//-> Titulo ENG
						"Data de Fim do Ciclo     ",;				//-> Descricao
						"Data de Fim do Ciclo     ",;				//-> Descricao SPA
						"Data de Fim do Ciclo     ",;				//-> Descricao ENG
						"",;										//-> Picture
						"",; 			         					//-> VALID
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
						
						
		cOrdem := "01"
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_FILIAL",;								//-> Campo
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
		
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_CDCICL",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod. Ciclo  ",;							//-> Titulo
						"Cod. Ciclo  ",;							//-> Titulo SPA
						"Cod. Ciclo  ",;							//-> Titulo ENG
						"Codigo do Ciclo          ",;				//-> Descricao
						"Codigo do Ciclo          ",;				//-> Descricao SPA
						"Codigo do Ciclo          ",;				//-> Descricao ENG
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
						
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_ITEM",;								//-> Campo
						"C",;										//-> Tipo
						4,;											//-> Tamanho
						0,;											//-> Decimal
						"Item        ",;							//-> Titulo
						"Item        ",;							//-> Titulo SPA
						"Item        ",;							//-> Titulo ENG
						"Item do Ciclo            ",;				//-> Descricao
						"Item do Ciclo            ",;				//-> Descricao SPA
						"Item do Ciclo            ",;				//-> Descricao ENG
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
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_ATIVO",;								//-> Campo
						"C",;										//-> Tipo
						1,;											//-> Tamanho
						0,;											//-> Decimal
						"Ativo       ",;							//-> Titulo
						"Ativo       ",;							//-> Titulo SPA
						"Ativo       ",;							//-> Titulo ENG
						"Periodo Ativo ?          ",;				//-> Descricao
						"Periodo Ativo ?          ",;				//-> Descricao SPA
						"Periodo Ativo ?          ",;				//-> Descricao ENG
						"",;										//-> Picture
						"U_CSFTA01B()",;         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
						"A",;   									//-> VISUAL
						"R",;               						//-> CONTEXT
						"",;                    					//-> OBRIGAT
						"",;                    					//-> VLDUSER
						"S=Sim;N=Nao",;								//-> CBOX
						"S=Sim;N=Nao",;								//-> CBOX SPA
						"S=Sim;N=Nao",;								//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;  										//-> INIBRW
						"",;    									//-> SXG
						"",;            							//-> FOLDER
						"S"})               						//-> PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_DTDE",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data de     ",;							//-> Titulo
						"Data de     ",;							//-> Titulo SPA
						"Data de     ",;							//-> Titulo ENG
						"Data de Inicio Mensal    ",;				//-> Descricao
						"Data de Inicio Mensal    ",;				//-> Descricao SPA
						"Data de Inicio Mensal    ",;				//-> Descricao ENG
						"",;										//-> Picture
						"U_CSFTA01C()",;         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
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
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_DTATE",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data ate    ",;							//-> Titulo
						"Data ate    ",;							//-> Titulo SPA
						"Data ate    ",;							//-> Titulo ENG
						"Data de Fim Mensal       ",;				//-> Descricao
						"Data de Fim Mensal       ",;				//-> Descricao SPA
						"Data de Fim Mensal       ",;				//-> Descricao ENG
						"",;										//-> Picture
						"U_CSFTA01C()",;          					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
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
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_USER",;								//-> Campo
						"C",;										//-> Tipo
						50,;										//-> Tamanho
						0,;											//-> Decimal
						"Usuario     ",;							//-> Titulo
						"Usuario     ",;							//-> Titulo SPA
						"Usuario     ",;							//-> Titulo ENG
						"Usuario que fez alteracao",;				//-> Descricao
						"Usuario que fez alteracao",;				//-> Descricao SPA
						"Usuario que fez alteracao",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"cUserName",;								//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
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
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_DTUALT",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data Ult Alt",;							//-> Titulo
						"Data Ult Alt",;							//-> Titulo SPA
						"Data Ult Alt",;							//-> Titulo ENG
						"Data da ultima alteracao ",;				//-> Descricao
						"Data da ultima alteracao ",;				//-> Descricao SPA
						"Data da ultima alteracao ",;				//-> Descricao ENG
						"",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"Date()",;									//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
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
		AAdd( aSX3, { 	"ZZH",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZH_HRUALT",;								//-> Campo
						"C",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Hora Ult Alt",;							//-> Titulo
						"Hora Ult Alt",;							//-> Titulo SPA
						"Hora Ult Alt",;							//-> Titulo ENG
						"Hora da ultima alteracao ",;				//-> Descricao
						"Hora da ultima alteracao ",;				//-> Descricao SPA
						"Hora da ultima alteracao ",;				//-> Descricao ENG
						"99:99:99",;								//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"Time()",;									//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
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
						
						
		

		cOrdem := "01"
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_FILIAL",;								//-> Campo
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


		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_CDCICL",;								//-> Campo
						"C",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Cod. Ciclo  ",;							//-> Titulo
						"Cod. Ciclo  ",;							//-> Titulo SPA
						"Cod. Ciclo  ",;							//-> Titulo ENG
						"Codigo do Ciclo          ",;				//-> Descricao
						"Codigo do Ciclo          ",;				//-> Descricao SPA
						"Codigo do Ciclo          ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;                       					//-> RELACAO
						"",;                     					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",;                       					//-> CHECK
						"",;                      					//-> TRIGGER
						"U",;                       					//-> PROPRI
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
						
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_VEND",;								//-> Campo
						"C",;										//-> Tipo
						6,;											//-> Tamanho
						0,;											//-> Decimal
						"Cod Vendedor",;							//-> Titulo
						"Cod Vendedor",;							//-> Titulo SPA
						"Cod Vendedor",;							//-> Titulo ENG
						"Codigo do Vendedor       ",;				//-> Descricao
						"Codigo do Vendedor       ",;				//-> Descricao SPA
						"Codigo do Vendedor       ",;				//-> Descricao ENG
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
						
						
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_UNEG",;								//-> Campo
						"C",;										//-> Tipo
						6,;											//-> Tamanho
						0,;											//-> Decimal
						"Unid. Neg.  ",;							//-> Titulo
						"Unid. Neg.  ",;							//-> Titulo SPA
						"Unid. Neg.  ",;							//-> Titulo ENG
						"Unidade de Negocio       ",;				//-> Descricao
						"Unidade de Negocio       ",;				//-> Descricao SPA
						"Unidade de Negocio       ",;				//-> Descricao ENG
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


		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_TOTAL",;								//-> Campo
						"N",;										//-> Tipo
						14,;											//-> Tamanho
						2,;											//-> Decimal
						"Acumulado   ",;							//-> Titulo
						"Acumulado   ",;							//-> Titulo SPA
						"Acumulado   ",;							//-> Titulo ENG
						"Valor Acumulado Faturado ",;				//-> Descricao
						"Valor Acumulado Faturado ",;				//-> Descricao SPA
						"Valor Acumulado Faturado ",;				//-> Descricao ENG
						"@E 99,999,999,999.99",;  					//-> Picture
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


		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_DTDE",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data de     ",;							//-> Titulo
						"Data de     ",;							//-> Titulo SPA
						"Data de     ",;							//-> Titulo ENG
						"Data de Inicio Mensal    ",;				//-> Descricao
						"Data de Inicio Mensal    ",;				//-> Descricao SPA
						"Data de Inicio Mensal    ",;				//-> Descricao ENG
						"",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
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
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_DTATE",;								//-> Campo
						"D",;										//-> Tipo
						8,;											//-> Tamanho
						0,;											//-> Decimal
						"Data ate    ",;							//-> Titulo
						"Data ate    ",;							//-> Titulo SPA
						"Data ate    ",;							//-> Titulo ENG
						"Data de Fim Mensal       ",;				//-> Descricao
						"Data de Fim Mensal       ",;				//-> Descricao SPA
						"Data de Fim Mensal       ",;				//-> Descricao ENG
						"",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
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
		AAdd( aSX3, { 	"ZZA",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"ZZA_LOG",;									//-> Campo
						"M",;										//-> Tipo
						10,;										//-> Tamanho
						0,;											//-> Decimal
						"Log         ",;							//-> Titulo
						"Log         ",;							//-> Titulo SPA
						"Log         ",;							//-> Titulo ENG
						"Log                      ",;				//-> Descricao
						"Log                      ",;				//-> Descricao SPA
						"Log                      ",;				//-> Descricao ENG
						"@!",;										//-> Picture
						"",; 			         					//-> VALID
						X3_USADO,;		           					//-> USADO
						"",;										//-> RELACAO
						"",;                       					//-> F3
						1,;                        					//-> NIVEL
						X3_RESERV,;		          					//-> RESERV
						"",; 										//-> CHECK
						"S",;										//-> TRIGGER
						"U",;      									//-> PROPRI
						"N",;										//-> BROWSE
						"V",;   									//-> VISUAL
						"V",;               						//-> CONTEXT
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
		
	EndIf	

Return( aSX3 )