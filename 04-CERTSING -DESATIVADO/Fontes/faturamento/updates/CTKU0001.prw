#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CTKU0001 |Autor: |David Alves dos Santos |Data: |08/03/2016   |
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
User Function CTKU0001()
	
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
	AAdd( aRet, 'CTKU0001')
	AAdd( aRet, 'Criação de campos para alerta via e-mail')
	AAdd( aRet, '2017022310002464')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo ZY_NUMPREG",;
				  	 "Criação do campo ZY_ORGGEST",;
				  	 "Criação do campo ZY_ANO",;
				  	 "Criação do campo ZY_CATEG"};
				  })
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX2 |Autor: |David Alves dos Santos |Data: |02/06/2016   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SX2 - Tabelas.          |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSX2()
	
	Local aSX2 := {}

	AAdd( aSX2,	{	"ZZY",;								//-- CHAVE 
						"",;									//-- PATH 
						"ZZY010  ",;							//-- ARQUIVO 
						"ALERTA DE AGENDAMENTO         ",;	//-- NOME 
						"ALERTA DE AGENDAMENTO         ",;	//-- NOMESPA 
						"ALERTA DE AGENDAMENTO         ",;	//-- NOMEENG 
						0,;										//-- DELET 
						"E",;									//-- MODO
               		"",;									//-- TTS 
               		"",;									//-- ROTINA 
               		"",;									//-- PYME 
               		"",;									//-- UNICO 
               		"E",;									//-- MODOEMP 
               		"E",;									//-- MODOUN 
               		0,;										//-- MODULO 
               		"",;									//-- SYSOBJ
               		""})									//-- USROBJ

Return( aSX2 )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSIX |Autor: |David Alves dos Santos |Data: |02/06/2016   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Função de processamento da gravação do SIX - Indices.          |
//|-------------+---------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                             |
//+-------------+---------------------------------------------------------------+
Static Function UpdAtuSIX()
	
	Local aSIX := {}
	
	AAdd(aSIX, 	{	"ZZY",;								//-- INDICE 
						"1",;									//-- ORDEM 
						"ZZY_FILIAL+ZZY_AGENDA",;			//-- CHAVE 
						"Agenda",;								//-- DESCRICAO 
						"Agenda",;								//-- DESCSPA 
						"Agenda",;								//-- DESCENG 
						"U",;									//-- PROPRI 
						"",;									//-- F3
               		"",;									//-- NICKNAME 
               		"S" })									//-- SHOWPESQ
               		
Return( aSIX )


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
		
		//+----------------------------------+
		//| Criação de campos na tabela ZZY. |
		//+----------------------------------+
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_FILIAL",;					//-- Campo
						"C",;								//-- Tipo
						2,;									//-- Tamanho
						0,;									//-- Decimal
						"Filial      ",;					//-- Titulo
						"Sucursal    ",;					//-- Titulo SPA
						"Branch      ",;					//-- Titulo ENG
						"Filial do Sistema        ",;	//-- Descricao
						"Sucursal                 ",;	//-- Descricao SPA
						"Branch of the System     ",;	//-- Descricao ENG
						"@!",;                 			//-- Picture
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_STATUS",;					//-- Campo
						"C",;								//-- Tipo
						1,;									//-- Tamanho
						0,;									//-- Decimal
						"Status Env. ",;					//-- Titulo
						"Status Env. ",;					//-- Titulo SPA
						"Status Env. ",;					//-- Titulo ENG
						"Status de envio do e-mail",;	//-- Descricao
						"Status de envio do e-mail",;	//-- Descricao SPA
						"Status de envio do e-mail",;	//-- Descricao ENG
						"@!",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;           			//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						0,;                        		//-- NIVEL
						X3_RESERV,;  		        		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
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
						""})                      		//-- PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_DATAG ",;					//-- Campo
						"D",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Data Ag.    ",;					//-- Titulo
						"Data Ag.    ",;					//-- Titulo SPA
						"Data Ag.    ",;					//-- Titulo ENG
						"Data do agendamento      ",;	//-- Descricao
						"Data do agendamento      ",;	//-- Descricao SPA
						"Data do agendamento      ",;	//-- Descricao ENG
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
						""})                      		//-- PYME

		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_HORAG ",;					//-- Campo
						"C",;								//-- Tipo
						8,;									//-- Tamanho
						0,;									//-- Decimal
						"Hora Ag.    ",;					//-- Titulo
						"Hora Ag.    ",;					//-- Titulo SPA
						"Hora Ag.    ",;					//-- Titulo ENG
						"Hora de agedamento       ",;	//-- Descricao
						"Hora de agedamento       ",;	//-- Descricao SPA
						"Hora de agedamento       ",;	//-- Descricao ENG
						"@!",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;           			//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						0,;                        		//-- NIVEL
						X3_RESERV,;  		        		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"U",;                      		//-- PROPRI
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
						""})                      		//-- PYME
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_AGENDA",;					//-- Campo
						"C",;								//-- Tipo
						6,;									//-- Tamanho
						0,;									//-- Decimal
						"Agenda      ",;					//-- Titulo
						"Agenda      ",;					//-- Titulo SPA
						"Agenda      ",;					//-- Titulo ENG
						"Numero da agenda         ",;	//-- Descricao
						"Numero da agenda         ",;	//-- Descricao SPA
						"Numero da agenda         ",;	//-- Descricao ENG
						"999999",;              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_OPERAD",;					//-- Campo
						"C",;								//-- Tipo
						6,;									//-- Tamanho
						0,;									//-- Decimal
						"Operador    ",;					//-- Titulo
						"Operador    ",;					//-- Titulo SPA
						"Operador    ",;					//-- Titulo ENG
						"Codigo do Operador       ",;	//-- Descricao
						"Codigo do Operador       ",;	//-- Descricao SPA
						"Codigo do Operador       ",;	//-- Descricao ENG
						"999999",;              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_MAILOP",;					//-- Campo
						"C",;								//-- Tipo
						100,;								//-- Tamanho
						0,;									//-- Decimal
						"E-mail Oper.",;					//-- Titulo
						"E-mail Oper.",;					//-- Titulo SPA
						"E-mail Oper.",;					//-- Titulo ENG
						"E-mail do operador       ",;	//-- Descricao
						"E-mail do operador       ",;	//-- Descricao SPA
						"E-mail do operador       ",;	//-- Descricao ENG
						"@!",;	              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_CONTAT",;					//-- Campo
						"C",;								//-- Tipo
						30,;								//-- Tamanho
						0,;									//-- Decimal
						"Nome        ",;					//-- Titulo
						"Nome        ",;					//-- Titulo SPA
						"Nome        ",;					//-- Titulo ENG
						"Nome do Contato          ",;	//-- Descricao
						"Nome do Contato          ",;	//-- Descricao SPA
						"Nome do Contato          ",;	//-- Descricao ENG
						"@!",;	              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_EMPRES",;					//-- Campo
						"C",;								//-- Tipo
						60,;								//-- Tamanho
						0,;									//-- Decimal
						"Empresa     ",;					//-- Titulo
						"Empresa     ",;					//-- Titulo SPA
						"Empresa     ",;					//-- Titulo ENG
						"Nome da Empresa          ",;	//-- Descricao
						"Nome da Empresa          ",;	//-- Descricao SPA
						"Nome da Empresa          ",;	//-- Descricao ENG
						"@!",;	              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
		AAdd(aSX3, { 	"ZZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZZY_LOG   ",;					//-- Campo
						"M",;								//-- Tipo
						10,;								//-- Tamanho
						0,;									//-- Decimal
						"Log de envio",;					//-- Titulo
						"Log de envio",;					//-- Titulo SPA
						"Log de envio",;					//-- Titulo ENG
						"Log de envio de email    ",;	//-- Descricao
						"Log de envio de email    ",;	//-- Descricao SPA
						"Log de envio de email    ",;	//-- Descricao ENG
						"",;	              			//-- Picture
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
						"R",;                      		//-- VISUAL
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
					
		
		//+----------------------------------+
		//| Criação de campos na tabela SUC. |
		//+----------------------------------+
		cOrdem := ""
		SX3->(DbSetOrder(1))
		SX3->(DbSeek("SUC"))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SUC"
			cOrdem  := Soma1(SX3->X3_ORDEM)
			SX3->(DbSkip())	
		EndDo	
		AAdd(aSX3, { 	"SUC",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"UC_XLEMBR",;						//-- Campo
						"C",;								//-- Tipo
						1,;									//-- Tamanho
						0,;									//-- Decimal
						"Lembrete    ",;					//-- Titulo
						"Lembrete    ",;					//-- Titulo SPA
						"Lembrete    ",;					//-- Titulo ENG
						"Lembrete envio de email  ",;	//-- Descricao
						"Lembrete envio de email  ",;	//-- Descricao SPA
						"Lembrete envio de email  ",;	//-- Descricao ENG
						"@!",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;		           		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;		          		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"",;                       		//-- PROPRI
						"S",;                      		//-- BROWSE
						"A",;                      		//-- VISUAL
						"R",;                      		//-- CONTEXT
						"",;                       		//-- OBRIGAT
						"",;                       		//-- VLDUSER
						"S=Sim;N=Não",;           		//-- CBOX
						"S=Sim;N=Não",;            		//-- CBOX SPA
						"S=Sim;N=Não",;           		//-- CBOX ENG
						"",;                       		//-- PICTVAR
						"",;                       		//-- WHEN
						"",;                       		//-- INIBRW
						"",;                       		//-- SXG
						"",;                       		//-- FOLDER
						"N"})                      		//-- PYME
							
	EndIf

Return( aSX3 )

