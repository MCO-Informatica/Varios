#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0003 |Autor: |David Alves dos Santos |Data: |06/02/2018   |
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
User Function CFTU0003()
	
	Local aRet := { {}, {}, {}, {}, {}, {}, {}, {}, {}, {} }

	//-- ESTRUTURA DO ARRAY aRET:
	//-- aRet[01] - Array com os dados SX2
	//-- aRet[02] - Array com os dados SIX
	//-- aRet[03] - Array com os dados SX3
	//-- aRet[04] - Array com os dados SX5
	//-- aRet[05] - Array com os dados SX7
	//-- aRet[06] - Array com os dados SX9
	//-- aRet[07] - Array com os dados SXA
	//-- aRet[08] - Array com os dados SXB
	//-- aRet[09] - Array com os dados SX6
	//-- aRet[10] - Array com as rotina pós Update

	//aRet[01] := UpdAtuSX2()
	//aRet[02] := UpdAtuSIX()
	
	  aRet[03] := UpdAtuSX3()
	
	//aRet[04] := UpdAtuSX5()
	//aRet[05] := UpdAtuSX7()
	//aRet[06] := UpdAtuSX9()
	//aRet[07] := UpdAtuSXA()
	//aRet[08] := UpdAtuSXB()
	//aRet[09] := UpdAtuSX6()
	//aRet[10] := UpdAtuRot()

Return( aRet )


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0001 |Autor: |David Alves dos Santos |Data: |08/03/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para setar as informações do update.                   |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
Static Function UpdGetInfo()
	
	Local aRet := {}

	//-- ESTRUTURA DO ARRAY aRET:
	//-- aRet[01] - (C) Nome da Function
	//-- aRet[02] - (C) Descritivo do Update
	//-- aRet[03] - (C) Numero do Chamado
	//-- aRet[04] - (C) Nome do autor
	//-- aRet[05] - (A) Array contendo o Help
	AAdd( aRet, 'CFTU0003')
	AAdd( aRet, 'Criação do campo Descrição Amigavel na tabela CNAE - CC3')
	AAdd( aRet, '2017081810002285')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo CC3_XCAMIG e CC3_XDAMIG"};
				  })
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX3 |Autor: |David Alves dos Santos |Data: |08/03/2016   |
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
	
	cOrdem := u_NxtOrdX3( "CC3" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd( aSX3, { 	"CC3",;										//-- Arquivo
						cOrdem,;									//-- Ordem
						"CC3_XCAMIG",;								//-- Campo
						"C",;										//-- Tipo
						2,;											//-- Tamanho
						0,;											//-- Decimal
						"Codigo Amig.",;							//-- Titulo
						"Codigo Amig.",;							//-- Titulo SPA
						"Codigo Amig.",;							//-- Titulo ENG
						"Codigo Amigavel          ",;				//-- Descricao
						"Codigo Amigavel          ",;				//-- Descricao SPA
						"Codigo Amigavel          ",;				//-- Descricao ENG
						"@!",;                 						//-- Picture
						"",;           								//-- VALID
						X3_USADO,;		           					//-- USADO
						"",;                       					//-- RELACAO
						"ZX",;                     					//-- F3
						1,;                        					//-- NIVEL
						X3_RESERV,;		          					//-- RESERV
						"",;                       					//-- CHECK
						"S",;                      					//-- TRIGGER
						"",;                       					//-- PROPRI
						"N",;                      					//-- BROWSE
						"A",;                      					//-- VISUAL
						"R",;                      					//-- CONTEXT
						"",;                       					//-- OBRIGAT
						"",;                       					//-- VLDUSER
						"",;										//-- CBOX
						"",;										//-- CBOX SPA
						"",;										//-- CBOX ENG
						"",;                       					//-- PICTVAR
						"",;                       					//-- WHEN
						"",;                       					//-- INIBRW
						"",;                       					//-- SXG
						"",;                       					//-- FOLDER
						"S"})                      					//-- PYME
		
		cOrdem := Soma1(cOrdem)
		AAdd( aSX3, { 	"CC3",;																					//-- Arquivo
						cOrdem,;																				//-- Ordem
						"CC3_XDAMIG",;																			//-- Campo
						"C",;																					//-- Tipo
						15,;																					//-- Tamanho
						0,;																						//-- Decimal
						"Desc. Amig. ",;																		//-- Titulo
						"Desc. Amig. ",;																		//-- Titulo SPA
						"Desc. Amig. ",;																		//-- Titulo ENG
						"Descricao Amigavel.      ",;															//-- Descricao
						"Descricao Amigavel.      ",;															//-- Descricao SPA
						"Descricao Amigavel.      ",;															//-- Descricao ENG
						"@!",;                 																	//-- Picture
						"",;           																			//-- VALID
						X3_USADO,;		           																//-- USADO
						'IF(!INCLUI,POSICIONE("SX5",1,XFILIAL("SX5")+"ZX"+M->CC3_XCAMIG,"X5_DESCRI"), "")',;	//-- RELACAO
						"",;                       																//-- F3
						1,;                        																//-- NIVEL
						X3_RESERV,;		          																//-- RESERV
						"",;                       																//-- CHECK
						"",;                       																//-- TRIGGER
						"",;                       																//-- PROPRI
						"N",;                      																//-- BROWSE
						"V",;                      																//-- VISUAL
						"V",;                      																//-- CONTEXT
						"",;                       																//-- OBRIGAT
						"",;                       																//-- VLDUSER
						"",;																					//-- CBOX
						"",;																					//-- CBOX SPA
						"",;																					//-- CBOX ENG
						"",;                       																//-- PICTVAR
						"",;                       																//-- WHEN
						"",;                       																//-- INIBRW
						"",;                       																//-- SXG
						"",;                       																//-- FOLDER
						"S"})                      																//-- PYME

	EndIf	
	
Return( aSX3 )