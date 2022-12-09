#Include 'Protheus.ch'

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0008 |Autor: |David Alves dos Santos |Data: |16/08/2018   |
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
User Function CFTU0008()
		
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

	//aRet[01] := UpdAtuSX2()
	//aRet[02] := UpdAtuSIX()
	  aRet[03] := UpdAtuSX3()
	//aRet[04] := UpdAtuSX5()
	  aRet[05] := UpdAtuSX7()
	//aRet[06] := UpdAtuSX9()
	  aRet[07] := UpdAtuSXA()
	//aRet[08] := UpdAtuSXB()
	//aRet[09] := UpdAtuSX6()
	//aRet[10] := UpdAtuRot()
		
Return( aRet )


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdGetInfo |Autor: |David Alves dos Santos |Data: |15/05/2018   |
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
	AAdd( aRet, 'CFTU0008')
	AAdd( aRet, 'Criação de campos na tabela AD5.')
	AAdd( aRet, '2018070410002033')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet,	{;
					{"Criação do campo: AD5_FCS"},;
					{"Criação do campo: AD5_DESFCS"},;
					{"Criação do campo: AD5_FCI"},;
					{"Criação do campo: AD5_DESFCI"},;
				 	{"Criação do campo: AD5_MTVENC"};
				})
				  
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX3 |Autor: |David Alves dos Santos |Data: |15/05/2018   |
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
	
	
	cOrdem := u_NxtOrdX3( "AD5" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_FCS",;																						//-- Campo
						"C",;																							//-- Tipo
						6,;																								//-- Tamanho
						0,;																								//-- Decimal
						"Mot. Sucesso",;																				//-- Titulo
						"F.C.E.      ",;																				//-- Titulo SPA
						"C.S.F.      ",;																				//-- Titulo ENG
						"Fator Critico de Sucesso ",;																	//-- Descricao
						"Factor Critico de Exito  ",;																	//-- Descricao SPA
						"Critical Success Factor  ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						'Vazio() .Or. ExistCpo("SX5","A6"+FwFldGet("AD5_FCS"))',;										//-- VALID
						X3_USADO,;		           																		//-- USADO
						"",;     																						//-- RELACAO
						"A6",;                     																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"S",;                      																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"N",;                      																		//-- BROWSE
						"A",;                      																		//-- VISUAL
						"R",;                      																		//-- CONTEXT
						"",;                       																		//-- OBRIGAT
						"",;                       																		//-- VLDUSER
						"",;                       																		//-- CBOX
						"",;                       																		//-- CBOX SPA
						"",;                       																		//-- CBOX ENG
						"",;                       																		//-- PICTVAR
						'Empty(FwFldGet("AD5_FCI"))',; 																	//-- WHEN
						"",;                       																		//-- INIBRW
						"",;                       																		//-- SXG
						"",;                       																		//-- FOLDER
						"S"})                      																		//-- PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_DESFCS",;																					//-- Campo
						"C",;																							//-- Tipo
						30,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Descricao   ",;																				//-- Titulo
						"Descripcion ",;																				//-- Titulo SPA
						"Description ",;																				//-- Titulo ENG
						"Descricao do Fator       ",;																	//-- Descricao
						"Descripcion del Factor   ",;																	//-- Descricao SPA
						"Factor Description       ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,Left( Posicione("SX5",1,xFilial("SX5")+"A6"+AD5->AD5_FCS,"X5_DESCRI"),30),"")',; 	//-- RELACAO
						"",;                       																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                       																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"N",;                      																		//-- BROWSE
						"V",;                      																		//-- VISUAL
						"V",;                      																		//-- CONTEXT
						"",;                       																		//-- OBRIGAT
						"",;                       																		//-- VLDUSER
						"",;                       																		//-- CBOX
						"",;                       																		//-- CBOX SPA
						"",;                       																		//-- CBOX ENG
						"",;                       																		//-- PICTVAR
						"",;                       																		//-- WHEN
						"",;                       																		//-- INIBRW
						"",;                       																		//-- SXG
						"",;                       																		//-- FOLDER
						"S"})                      																		//-- PYME
		
		cOrdem := Soma1(cOrdem)				
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_FCI",;																						//-- Campo
						"C",;																							//-- Tipo
						6,;																								//-- Tamanho
						0,;																								//-- Decimal
						"Motivo Perda",;																				//-- Titulo
						"F.C.E.      ",;																				//-- Titulo SPA
						"C.F.F.      ",;																				//-- Titulo ENG
						"Fator Critico Insucesso  ",;																	//-- Descricao
						"Factor Critico Exito     ",;																	//-- Descricao SPA
						"Critical Failure Factor  ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						'Vazio() .Or.ExistCpo("SX5","ZQ"+FwFldGet("AD5_FCI"))',;										//-- VALID
						X3_USADO,;		           																		//-- USADO
						"",;  																					   		//-- RELACAO
						"SX5_ZQ",;                 																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"S",;                      																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"N",;                      																		//-- BROWSE
						"A",;                      																		//-- VISUAL
						"R",;                      																		//-- CONTEXT
						"",;                       																		//-- OBRIGAT
						"",;                       																		//-- VLDUSER
						"",;                       																		//-- CBOX
						"",;                       																		//-- CBOX SPA
						"",;                       																		//-- CBOX ENG
						"",;                       																		//-- PICTVAR
						'Empty(FwFldGet("AD5_FCS"))',;																	//-- WHEN
						"",;                       																		//-- INIBRW
						"",;                       																		//-- SXG
						"",;                       																		//-- FOLDER
						"S"})                      																		//-- PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_DESFCI",;																					//-- Campo
						"C",;																							//-- Tipo
						30,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Descricao   ",;																				//-- Titulo
						"Descripcion ",;																				//-- Titulo SPA
						"Description ",;																				//-- Titulo ENG
						"Descricao do Fator       ",;																	//-- Descricao
						"Descripcion del Factor   ",;																	//-- Descricao SPA
						"Factor Description       ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,Left( Posicione("SX5",1,xFilial("SX5")+"A6"+AD5->AD5_FCI,"X5_DESCRI"),30),"")',; 	//-- RELACAO
						"",;                       																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                       																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"N",;                      																		//-- BROWSE
						"V",;                      																		//-- VISUAL
						"V",;                      																		//-- CONTEXT
						"",;                       																		//-- OBRIGAT
						"",;                       																		//-- VLDUSER
						"",;                       																		//-- CBOX
						"",;                       																		//-- CBOX SPA
						"",;                       																		//-- CBOX ENG
						"",;                       																		//-- PICTVAR
						"",;                       																		//-- WHEN
						"",;                       																		//-- INIBRW
						"",;                       																		//-- SXG
						"",;                       																		//-- FOLDER
						"S"})                      																		//-- PYME
		
		cOrdem := Soma1(cOrdem)				
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_MTVENC",;																					//-- Campo
						"M",;																							//-- Tipo
						10,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Descr. Motiv",;																				//-- Titulo
						"Descr. Motiv",;																				//-- Titulo SPA
						"Descr. Motiv",;																				//-- Titulo ENG
						"Motivo do Encerramento   ",;																	//-- Descricao
						"Motivo de Finalizacion   ",;																	//-- Descricao SPA
						"Closing Reason           ",;																	//-- Descricao ENG
						"",;                 																			//-- Picture
						"",;																							//-- VALID
						X3_USADO,;		           																		//-- USADO
						"",;																				     		//-- RELACAO
						"",;	                 																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                      																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"N",;                      																		//-- BROWSE
						"A",;                      																		//-- VISUAL
						"R",;                      																		//-- CONTEXT
						"",;                       																		//-- OBRIGAT
						"",;                       																		//-- VLDUSER
						"",;                       																		//-- CBOX
						"",;                       																		//-- CBOX SPA
						"",;                       																		//-- CBOX ENG
						"",;                       																		//-- PICTVAR
						'!Empty(FwFldGet("AD5_FCS")).Or.!Empty(FwFldGet("AD5_FCI"))',;									//-- WHEN
						"",;                       																		//-- INIBRW
						"",;                       																		//-- SXG
						"",;                       																		//-- FOLDER
						"S"})                      																		//-- PYME
	
	EndIf
	
Return( aSX3 )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSXA |Autor: |David Alves dos Santos |Data: |17/08/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX7                     |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSXA()

	Local aSXA   := {}
	
	AAdd(aSXA, { 'AD5',;								//-- XA_ALIAS
				 '1',;									//-- XA_ORDEM
				 'Resumo                        ',;		//-- XA_DESCRIC
				 'Resumo                        ',;		//-- XA_DESCSPA
				 'Resumo                        ',;		//-- XA_DESCENG
				 'U',;									//-- XA_PROPRI
				 'RES',;								//-- XA_AGRUP
				 '2'})									//-- XA_TIPO
				 
	AAdd(aSXA, { 'AD5',;								//-- XA_ALIAS
				 '2',;									//-- XA_ORDEM
				 'Informacoes de Fechamento     ',;		//-- XA_DESCRIC
				 'Informacoes de Fechamento     ',;		//-- XA_DESCSPA
				 'Informacoes de Fechamento     ',;		//-- XA_DESCENG
				 'U',;									//-- XA_PROPRI
				 'FCH',;								//-- XA_AGRUP
				 '2'})									//-- XA_TIPO
				 
Return( aSXA )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX7 |Autor: |David Alves dos Santos |Data: |22/08/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX7                     |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX7()

	Local aSX7   := {}
	
	AAdd(aSX7, { 'AD5_FCI',;										//-- X7_CAMPO
				 '001',;											//-- X7_SEQUENC
				 'SX5->X5_DESCRI',;									//-- X7_REGRA
				 'AD5_DESFCI',;										//-- X7_CDOMIN
				 'P',;												//-- X7_TIPO
				 'S',;												//-- X7_SEEK
				 'SX5',;											//-- X7_ALIAS
				 1,;												//-- X7_ORDEM
				 'xFilial("SX5")+"ZQ"+FWFldGet("AD5_FCI")',;		//-- X7_CHAVE
				 'U',;												//-- X7_PROPRI
				 ''})												//-- X7_CONDIC

	AAdd(aSX7, { 'AD5_FCS',;										//-- X7_CAMPO
				 '001',;											//-- X7_SEQUENC
				 'SX5->X5_DESCRI',;									//-- X7_REGRA
				 'AD5_DESFCS',;										//-- X7_CDOMIN
				 'P',;												//-- X7_TIPO
				 'S',;												//-- X7_SEEK
				 'SX5',;											//-- X7_ALIAS
				 1,;												//-- X7_ORDEM
				 'xFilial("SX5")+"A6"+FWFldGet("AD5_FCS")',;		//-- X7_CHAVE
				 'U',;												//-- X7_PROPRI
				 ''})												//-- X7_CONDIC
	
Return( aSX7 )