#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CTKU0002 |Autor: |David Alves dos Santos |Data: |14/08/2016   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de update de dicionários para compatibilização.        |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |C    = Certisign.                                             |
//|do codigo    |TK   = Modulo CallCenter SIGATMK.                             |
//|fonte.       |U    = Update.                                                |
//|             |9999 = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CTKU0002()
	
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
	
	aRet[03] := UpdAtuSX3()

	//aRet[01] := UpdAtuSX2()
	//aRet[02] := UpdAtuSIX()
	//aRet[04] := UpdAtuSX5()
	//aRet[05] := UpdAtuSX7()
	//aRet[06] := UpdAtuSX9()
	//aRet[07] := UpdAtuSXA()
	//aRet[08] := UpdAtuSXB()
	//aRet[09] := UpdAtuSX6()
	//aRet[10] := UpdAtuRot()

Return( aRet )


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdGetInfo |Autor: |David Alves dos Santos |Data: |08/03/2016   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função para setar as informações do update.                     |
//|-------------+----------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                              |
//+-------------+----------------------------------------------------------------+
Static Function UpdGetInfo()
	
	Local aRet := {}

	//-- ESTRUTURA DO ARRAY aRET:
	//-- aRet[01] - (C) Nome da Function
	//-- aRet[02] - (C) Descritivo do Update
	//-- aRet[03] - (C) Numero do Chamado
	//-- aRet[04] - (C) Nome do autor
	//-- aRet[05] - (A) Array contendo o Help
	AAdd( aRet, 'CTKU0002')
	AAdd( aRet, 'Criação de campos para controlar tempo de atendimento (Contatar até geração de proposta).')
	AAdd( aRet, '2017081110010145')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo UC_XDIPROP",;
				  	 "Criação do campo UC_XHIPROP",;
				  	 "Criação do campo UC_XDFPROP",;
				  	 "Criação do campo UC_XHFPROP"};
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
	Local lRet   := .T.
	Local cOrdem := '00'

	DbSelectArea('SX3')
	
	If lRet
		
		
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("SUC"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SUC"
			cOrdem := Soma1(SX3->X3_ORDEM)
			SX3->(DbSkip())	
		EndDo
		
		//+----------------------------------+
		//| Criação de campos na tabela ZZY. |
		//+----------------------------------+
		AAdd(aSX3, { 	"SUC",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"UC_XDIPROP",;					//-- Campo
						"D",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Dt. Ini. Pr.",;					//-- Titulo
						"Dt. Ini. Pr.",;					//-- Titulo SPA
						"Dt. Ini. Pr.",;					//-- Titulo ENG
						"Data inicio proposta     ",;	//-- Descricao
						"Data inicio proposta     ",;	//-- Descricao SPA
						"Data inicio proposta     ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
						"N",;                      		//-- BROWSE
						"",;                      		//-- VISUAL
						"",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"",;                       		//-- CBOX
						"",;                       		//-- CBOX SPA
						"",;                       		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						""})                      		//-- PYME

		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"SUC",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"UC_XHIPROP",;					//-- Campo
						"C",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Hr. Ini. Pr.",;					//-- Titulo
						"Hr. Ini. Pr.",;					//-- Titulo SPA
						"Hr. Ini. Pr.",;					//-- Titulo ENG
						"Hora inicio proposta     ",;	//-- Descricao
						"Hora inicio proposta     ",;	//-- Descricao SPA
						"Hora inicio proposta     ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
						"N",;                      		//-- BROWSE
						"",;                      		//-- VISUAL
						"",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"",;                       		//-- CBOX
						"",;                       		//-- CBOX SPA
						"",;                       		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						""})                      		//-- PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"SUC",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"UC_XDFPROP",;					//-- Campo
						"D",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Dt. Fim. Pr.",;					//-- Titulo
						"Dt. Fim. Pr.",;					//-- Titulo SPA
						"Dt. Fim. Pr.",;					//-- Titulo ENG
						"Data Fim proposta        ",;	//-- Descricao
						"Data Fim proposta        ",;	//-- Descricao SPA
						"Data Fim proposta        ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
						"N",;                      		//-- BROWSE
						"",;                      		//-- VISUAL
						"",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"",;                       		//-- CBOX
						"",;                       		//-- CBOX SPA
						"",;                       		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						""})                      		//-- PYME

		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"SUC",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"UC_XHFPROP",;					//-- Campo
						"C",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Hr. Fim. Pr.",;					//-- Titulo
						"Hr. Fim. Pr.",;					//-- Titulo SPA
						"Hr. Fim. Pr.",;					//-- Titulo ENG
						"Hora Fim proposta        ",;	//-- Descricao
						"Hora Fim proposta        ",;	//-- Descricao SPA
						"Hora Fim proposta        ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
						"N",;                      		//-- BROWSE
						"",;                      		//-- VISUAL
						"",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"",;                       		//-- CBOX
						"",;                       		//-- CBOX SPA
						"",;                       		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						""})                      		//-- PYME
											
	EndIf

Return( aSX3 )

