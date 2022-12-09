#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0006 |Autor: |David Alves dos Santos |Data: |15/05/2018   |
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
User Function CFTU0006()
	
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
	AAdd( aRet, 'CFTU0006')
	AAdd( aRet, 'Criação campos na tabela AD9.')
	AAdd( aRet, '2018050810001683')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo: AD9_XEMAIL"},;
				 	{"Criação do campo: AD9_XFONE1"},;
				 	{"Criação do campo: AD9_XCARGO"},;
				 	{"Criação do campo: AD9_XEDEPT"},;
				 	{"Criação do campo: AD5_XDTFEC"};
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
	
	
	cOrdem := u_NxtOrdX3( "AD9" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd(aSX3, { 	"AD9",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD9_XEMAIL",;																					//-- Campo
						"C",;																							//-- Tipo
						60,;																							//-- Tamanho
						0,;																								//-- Decimal
						"E-mail      ",;																				//-- Titulo
						"E-mail      ",;																				//-- Titulo SPA
						"E-mail      ",;																				//-- Titulo ENG
						"E-mail                   ",;																	//-- Descricao
						"E-mail                   ",;																	//-- Descricao SPA
						"E-mail                   ",;																	//-- Descricao ENG
						"@x",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("SU5",1,xFilial("SU5")+AD9->AD9_CODCON,"U5_EMAIL" )),"")',;      //-- RELACAO
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

		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD9",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD9_XFONE1",;																					//-- Campo
						"C",;																							//-- Tipo
						15,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Telefone    ",;																				//-- Titulo
						"Telefone    ",;																				//-- Titulo SPA
						"Telefone    ",;																				//-- Titulo ENG
						"Telefone                 ",;																	//-- Descricao
						"Telefone                 ",;																	//-- Descricao SPA
						"Telefone                 ",;																	//-- Descricao ENG
						"@R 999999999999999",; 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("SU5",1,xFilial("SU5")+AD9->AD9_CODCON,"U5_FCOM1" )),"")',;      //-- RELACAO
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
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD9",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD9_XCARGO",;																					//-- Campo
						"C",;																							//-- Tipo
						50,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Cargo       ",;																				//-- Titulo
						"Cargo       ",;																				//-- Titulo SPA
						"Cargo       ",;																				//-- Titulo ENG
						"Cargo                    ",;																	//-- Descricao
						"Cargo                    ",;																	//-- Descricao SPA
						"Cargo                    ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("SU5",1,xFilial("SU5")+AD9->AD9_CODCON,"U5_XCARGO" )),"")',;     //-- RELACAO
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
						
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD9",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD9_XEDEPT",;																					//-- Campo
						"C",;																							//-- Tipo
						50,;																							//-- Tamanho
						0,;																								//-- Decimal
						"Departamento",;																				//-- Titulo
						"Departamento",;																				//-- Titulo SPA
						"Departamento",;																				//-- Titulo ENG
						"Departamento             ",;																	//-- Descricao
						"Departamento             ",;																	//-- Descricao SPA
						"Departamento             ",;																	//-- Descricao ENG
						"@!",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						'IIF(!INCLUI,AllTrim(Posicione("SU5",1,xFilial("SU5")+AD9->AD9_CODCON,"U5_XDEPTO" )),"")',;		//-- RELACAO
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
						

		cOrdem := u_NxtOrdX3( "AD5" )			
		AAdd(aSX3, { 	"AD5",;																							//-- Arquivo
						cOrdem,;																						//-- Ordem
						"AD5_XDTFEC",;																					//-- Campo
						"D",;																							//-- Tipo
						8,;																								//-- Tamanho
						0,;																								//-- Decimal
						"Dt. Fecham. ",;																				//-- Titulo
						"Dt. Fecham. ",;																				//-- Titulo SPA
						"Dt. Fecham. ",;																				//-- Titulo ENG
						"Data de Fechamento.      ",;																	//-- Descricao
						"Data de Fechamento.      ",;																	//-- Descricao SPA
						"Data de Fechamento.      ",;																	//-- Descricao ENG
						"",;                 																			//-- Picture
						"",;             																				//-- VALID
						X3_USADO,;		           																		//-- USADO
						"",;                       																		//-- RELACAO
						"",;                       																		//-- F3
						1,;                        																		//-- NIVEL
						X3_RESERV,;		          																		//-- RESERV
						"",;                       																		//-- CHECK
						"",;                       																		//-- TRIGGER
						"U",;                      																		//-- PROPRI
						"S",;                      																		//-- BROWSE
						"A",;                      																		//-- VISUAL
						"R",;                      																		//-- CONTEXT
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
//|Programa:    |UpdAtuSX7 |Autor: |David Alves dos Santos |Data: |15/05/2018   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX7                     |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX7()

	Local aSX7   := {}
	
	AAdd(aSX7, { 'AD9_CODCON',;																//-- X7_CAMPO
				 '002',;																	//-- X7_SEQUENC
				 'Posicione("SU5",1,xFilial("SU5")+FwFldGet("AD9_CODCON"),"U5_EMAIL" )',;	//-- X7_REGRA
				 'AD9_XEMAIL',;																//-- X7_CDOMIN
				 'P',;																		//-- X7_TIPO
				 'N',;																		//-- X7_SEEK
				 '',;																		//-- X7_ALIAS
				 0,;																		//-- X7_ORDEM
				 '',;																		//-- X7_CHAVE
				 'U',;																		//-- X7_PROPRI
				 ''})																		//-- X7_CONDIC

	AAdd(aSX7, { 'AD9_CODCON',;																//-- X7_CAMPO
				 '003',;																	//-- X7_SEQUENC
				 'Posicione("SU5",1,xFilial("SU5")+FwFldGet("AD9_CODCON"),"U5_FCOM1" )',;	//-- X7_REGRA
				 'AD9_XFONE1',;																//-- X7_CDOMIN
				 'P',;																		//-- X7_TIPO
				 'N',;																		//-- X7_SEEK
				 '',;																		//-- X7_ALIAS
				 0,;																		//-- X7_ORDEM
				 '',;																		//-- X7_CHAVE
				 'U',;																		//-- X7_PROPRI
				 ''})																		//-- X7_CONDIC
				 
	AAdd(aSX7, { 'AD9_CODCON',;																//-- X7_CAMPO
				 '004',;																	//-- X7_SEQUENC
				 'Posicione("SU5",1,xFilial("SU5")+FwFldGet("AD9_CODCON"),"U5_XCARGO" )',;	//-- X7_REGRA
				 'AD9_XCARGO',;																//-- X7_CDOMIN
				 'P',;																		//-- X7_TIPO
				 'N',;																		//-- X7_SEEK
				 '',;																		//-- X7_ALIAS
				 0,;																		//-- X7_ORDEM
				 '',;																		//-- X7_CHAVE
				 'U',;																		//-- X7_PROPRI
				 ''})																		//-- X7_CONDIC
				 
	AAdd(aSX7, { 'AD9_CODCON',;																//-- X7_CAMPO
				 '005',;																	//-- X7_SEQUENC
				 'Posicione("SU5",1,xFilial("SU5")+FwFldGet("AD9_CODCON"),"U5_XDEPTO" )',;	//-- X7_REGRA
				 'AD9_XEDEPT',;																//-- X7_CDOMIN
				 'P',;																		//-- X7_TIPO
				 'N',;																		//-- X7_SEEK
				 '',;																		//-- X7_ALIAS
				 0,;																		//-- X7_ORDEM
				 '',;																		//-- X7_CHAVE
				 'U',;																		//-- X7_PROPRI
				 ''})																		//-- X7_CONDIC

Return( aSX7 )