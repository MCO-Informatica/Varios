#Include 'Protheus.ch'

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"

//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0007 |Autor: |David Alves dos Santos |Data: |06/08/2018   |
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
User Function CFTU0007()
		
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
	//aRet[07] := UpdAtuSXA()
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
	AAdd( aRet, 'CFTU0007')
	AAdd( aRet, 'Criação campos nas tabelas SC5 e SC6.')
	AAdd( aRet, '2018080210002151')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet,	{;
					{"Criação do campo: C5_XDUNEG"},;
				 	{"Criação do campo: C6_XDUNEG"};
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
	
	
	cOrdem := u_NxtOrdX3( "SC5" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd(aSX3, { 	"SC5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"C5_XDUNEG",;																					//-- Campo
						"C",;																							//-- Tipo
						30,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Descricao   ",;																				//-- Titulo
						"Descricao   ",;																				//-- Titulo SPA
						"Descricao   ",;																				//-- Titulo ENG
						"Descricao Unid. Negocio  ",;																	//-- Descricao
						"Descricao Unid. Negocio  ",;																	//-- Descricao SPA
						"Descricao Unid. Negocio  ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("ACU",1,xFilial("ACU")+M->C5_UNEG,"ACU_DESC" )),"")',;     		//-- RELACAO
						"",;                       																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                       																		//-- TRIGGER
						"",;                       																		//-- PROPRI
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
						"N"})                      																		//-- PYME
						
	EndIf
	
	
	cOrdem := u_NxtOrdX3( "SC6" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd(aSX3, { 	"SC6",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"C6_XDUNEG",;																					//-- Campo
						"C",;																							//-- Tipo
						30,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Descricao   ",;																				//-- Titulo
						"Descricao   ",;																				//-- Titulo SPA
						"Descricao   ",;																				//-- Titulo ENG
						"Descricao Unid. Negocio  ",;																	//-- Descricao
						"Descricao Unid. Negocio  ",;																	//-- Descricao SPA
						"Descricao Unid. Negocio  ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("ACU",1,xFilial("ACU")+M->C6_UNEG,"ACU_DESC" )),"")',;     		//-- RELACAO
						"",;                       																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                       																		//-- TRIGGER
						"",;                       																		//-- PROPRI
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
						"N"})                      																		//-- PYME
						
	EndIf

Return( aSX3 )



//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX7 |Autor: |David Alves dos Santos |Data: |17/08/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX7                     |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX7()

	Local aSX7   := {}
	
	AAdd(aSX7, { 'C6_PRODUTO',;																						//-- X7_CAMPO
				 '012',;																							//-- X7_SEQUENC
				 "Iif(Empty(C5_UNEG),Posicione('ACV',5,xfilial('ACV')+M->C6_PRODUTO, 'ACV_CATEGO'),M->C5_UNEG)",;	//-- X7_REGRA
				 'C6_UNEG',;																						//-- X7_CDOMIN
				 'P',;																								//-- X7_TIPO
				 'N',;																								//-- X7_SEEK
				 '',;																								//-- X7_ALIAS
				 0,;																								//-- X7_ORDEM
				 '',;																								//-- X7_CHAVE
				 'U',;																								//-- X7_PROPRI
				 ''})																								//-- X7_CONDIC

Return( aSX7 )