#Include "Protheus.ch"

#Define X3_USADO   "€€€€€€€€€€€€€€ "
#Define X3_RESERV  "þÀ"
#Define X3_OBRIGAT "€"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0001 |Autor: |David Alves dos Santos |Data: |08/03/2016   |
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
User Function CFTU0001()
	
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
	AAdd( aRet, 'CFTU0001')
	AAdd( aRet, 'Criação de campos para rotina de Licitação')
	AAdd( aRet, '2017022210001261')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
				 	{"Criação do campo ZY_NUMPREG",;
				  	 "Criação do campo ZY_ORGGEST",;
				  	 "Criação do campo ZY_ANO",;
				  	 "Criação do campo ZY_CATEG"};
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
	Local cOrdem := '00'

	lRet := .F.
	DbSelectArea('SX3')
	
	//-- Criacao de novos campos em uma tabela nova, verificando ordem
	SX3->(DbSetOrder(1))
	SX3->(DbSeek("SZY"))
	While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == "SZY"
		cOrdem  := Soma1(SX3->X3_ORDEM)
		lRet := .T.
		SX3->(DbSkip())	
	EndDo
	
	If lRet
		
		AAdd(aSX3, { 	"SZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZY_NUMPREG",;					//-- Campo
						"C",;								//-- Tipo
						15,;								//-- Tamanho
						0,;									//-- Decimal
						"Num. Pregao ",;					//-- Titulo
						"Num. Pregao ",;					//-- Titulo SPA
						"Num. Pregao ",;					//-- Titulo ENG
						"Numero do Pregao         ",;	//-- Descricao
						"Numero do Pregao         ",;	//-- Descricao SPA
						"Numero do Pregao         ",;	//-- Descricao ENG
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
		AAdd(aSX3, { 	"SZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZY_ORGGEST",;					//-- Campo
						"C",;								//-- Tipo
						150,;								//-- Tamanho
						0,;									//-- Decimal
						"Orgao Gest. ",;					//-- Titulo
						"Orgao Gest. ",;					//-- Titulo SPA
						"Orgao Gest. ",;					//-- Titulo ENG
						"Orgao Gestor             ",;	//-- Descricao
						"Orgao Gestor             ",;	//-- Descricao SPA
						"Orgao Gestor             ",;	//-- Descricao ENG
						"@!",;                 			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;           			//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;  		        		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"",;                       		//-- PROPRI
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
						
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"SZY",;							//-- Arquivo
						cOrdem,;							//-- Ordem
						"ZY_ANO",;							//-- Campo
						"C",;								//-- Tipo
						4,;									//-- Tamanho
						0,;									//-- Decimal
						"Ano         ",;					//-- Titulo
						"Ano         ",;					//-- Titulo SPA
						"Ano         ",;					//-- Titulo ENG
						"Ano                      ",;	//-- Descricao
						"Ano                      ",;	//-- Descricao SPA
						"Ano                      ",;	//-- Descricao ENG
						"9999",;                			//-- Picture
						"",;             					//-- VALID
						X3_USADO,;      		     		//-- USADO
						"",;                       		//-- RELACAO
						"",;                       		//-- F3
						1,;                        		//-- NIVEL
						X3_RESERV,;   	       		//-- RESERV
						"",;                       		//-- CHECK
						"",;                       		//-- TRIGGER
						"",;                       		//-- PROPRI
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
	
		cOrdem := Soma1(cOrdem)
		AAdd(aSX3, { 	"SZY",;										//-- Arquivo
						cOrdem,;										//-- Ordem
						"ZY_CATEG",;									//-- Campo
						"C",;											//-- Tipo
						1,;												//-- Tamanho
						0,;												//-- Decimal
						"Categoria   ",;								//-- Titulo
						"Categoria   ",;								//-- Titulo SPA
						"Categoria   ",;								//-- Titulo ENG
						"Categoria                ",;				//-- Descricao
						"Categoria                ",;				//-- Descricao SPA
						"Categoria                ",;				//-- Descricao ENG
						"@!",;                						//-- Picture
						"",;             								//-- VALID
						X3_USADO,;        		   					//-- USADO
						"",;                       					//-- RELACAO
						"",;                       					//-- F3
						1,;                        					//-- NIVEL
						X3_RESERV,;     		     					//-- RESERV
						"",;                       					//-- CHECK
						"",;                       					//-- TRIGGER
						"",;                       					//-- PROPRI
						"N",;                      					//-- BROWSE
						"A",;                      					//-- VISUAL
						"R",;                      					//-- CONTEXT
						"",;                       					//-- OBRIGAT
						"",;                       					//-- VLDUSER
						"G=Gestor;P=Participante;A=Aderente",;		//-- CBOX
						"G=Gestor;P=Participante;A=Aderente",;    //-- CBOX SPA
						"G=Gestor;P=Participante;A=Aderente",;   	//-- CBOX ENG
						"",;                       					//-- PICTVAR
						"",;                       					//-- WHEN
						"",;                       					//-- INIBRW
						"",;                       					//-- SXG
						"",;                       					//-- FOLDER
						"N"})                      					//-- PYME	
	EndIf

Return( aSX3 )