#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0002 |Autor: |David Alves dos Santos |Data: |04/04/2017   |
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
User Function CFTU0002()
	
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
	AAdd( aRet, 'CFTU0002')
	AAdd( aRet, 'Criação de campos para controle de prospect')
	AAdd( aRet, '2016122710001744')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo AD1_XQTDPR",;
				  	 "Criação do campo AD1_XLOGQP",;
				  	 "Criação do campo US_MSBLQL"};
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
	
	cOrdem := u_NxtOrdX3( "AD1" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		
		AAdd(aSX3, { 	"AD1",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"AD1_XQTDPR",;					//-- Campo
						"N",;								//-- Tipo
						3,;									//-- Tamanho
						0,;									//-- Decimal
						"Qtd. Propost",;					//-- Titulo
						"Qtd. Propost",;					//-- Titulo SPA
						"Qtd. Propost",;					//-- Titulo ENG
						"Quantidade de Propostas. ",;	//-- Descricao
						"Quantidade de Propostas. ",;	//-- Descricao SPA
						"Quantidade de Propostas. ",;	//-- Descricao ENG
						"999",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"",;                       		//-- PROPRI
						"N",;                      		//-- BROWSE
						"A",;                      		//-- VISUAL
						"R",;                      		//-- CONTEXT
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
						"N"})                      		//-- PYME

		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"AD1",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"AD1_XLOGQP",;					//-- Campo
						"M",;								//-- Tipo
						10,;								//-- Tamanho
						0,;									//-- Decimal
						"Log Qtd. Pro",;					//-- Titulo
						"Log Qtd. Pro",;					//-- Titulo SPA
						"Log Qtd. Pro",;					//-- Titulo ENG
						"Log de Qtd. de Proposta  ",;	//-- Descricao
						"Log de Qtd. de Proposta  ",;	//-- Descricao SPA
						"Log de Qtd. de Proposta  ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;           			//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						0,;                        		//-- NIVEL
						X3_RESERV,;  		        		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
						"S",;                      		//-- BROWSE
						"A",;                      		//-- VISUAL
						"R",;                      		//-- CONTEXT
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
						"N"})                      		//-- PYME
						
		
	EndIf
	
	cOrdem := u_NxtOrdX3( "SUS" )
	If !Empty(cOrdem)
		lRet := .T.
	EndIf
	
	If lRet
		AAdd(aSX3, { 	"SUS",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"US_MSBLQL",;						//-- Campo
						"C",;								//-- Tipo
						1,;									//-- Tamanho
						0,;									//-- Decimal
						"Bloqueado?  ",;					//-- Titulo
						"Bloqueado?  ",;					//-- Titulo SPA
						"Bloqueado?  ",;					//-- Titulo ENG
						"Registro bloqueado       ",;	//-- Descricao
						"Registro bloqueado       ",;	//-- Descricao SPA
						"Registro bloqueado       ",;	//-- Descricao ENG
						"",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;           			//-- USADO
						"'2'",;                    		//-- RELACAO
						"",;                       		//-- F3
						9,;                        		//-- NIVEL
						X3_RESERV,;  		        		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"L",;                      		//-- PROPRI
						"N",;                      		//-- BROWSE
						"A",;                      		//-- VISUAL
						"R",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"1=Sim;2=Nao",;           		//-- CBOX
						"1=Si;2=No",;             		//-- CBOX SPA
						"1=Yes;2=No",;             		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						"N"})                      		//-- PYME
	EndIf
	
	
Return( aSX3 )