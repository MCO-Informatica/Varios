#Include "Protheus.ch"

#Define X3_USADO   "���������������"
#Define X3_RESERV  "��"
#Define X3_OBRIGAT "�"


//+-------------+---------+-------+-----------------------+------+-------------+
//|Programa:    |CFTU0011 |Autor: |David Alves dos Santos |Data: |16/07/2019   |
//|-------------+---------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun��o de update de dicion�rios para compatibiliza��o.        |
//|-------------+--------------------------------------------------------------|
//|Nomenclatura |C    = Certisign.                                             |
//|do codigo    |FT   = Modulo faturamento SIGAFAT.                            |
//|fonte.       |U    = Update.                                                |
//|             |9999 = Numero sequencial.                                     |
//|-------------+--------------------------------------------------------------|
//|Uso:         |Certisign - Certificadora Digital.                            |
//+-------------+--------------------------------------------------------------+
User Function CFTU0011()
	
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
	//-> aRet[10] - Array com as rotina p�s Update

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


//+-------------+-----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdGetInfo |Autor: |David Alves dos Santos |Data: |16/07/2019   |
//|-------------+-----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun��o para setar as informa��es do update.                     |
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
	AAdd( aRet, 'CFTU0011')
	AAdd( aRet, 'Cria��o de campo referente a integra��o com o PipeDrive.')
	AAdd( aRet, '2019061410000516')
	AAdd( aRet, 'David.Santos')
	AAdd( aRet, {;
					{"Cria��o do campo: AD1_XINTPD."};
				})
				
Return( aRet )


//+-------------+----------+-------+-----------------------+------+-------------+
//|Programa:    |UpdAtuSX3 |Autor: |David Alves dos Santos |Data: |16/07/2019   |
//|-------------+----------+-------+-----------------------+------+-------------|
//|Descricao:   |Fun��o de processamento da grava��o do SX3 - Campos.           |
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
		AAdd( aSX3, { 	"AD1",;										//-> Arquivo
						cOrdem,;									//-> Ordem
						"AD1_XINTPD",;								//-> Campo
						"C",;										//-> Tipo
						1,;											//-> Tamanho
						0,;											//-> Decimal
						"Int. PPDrive",;							//-> Titulo
						"Int. PPDrive",;							//-> Titulo SPA
						"Int. PPDrive",;							//-> Titulo ENG
						"Integra��o Pipedrive     ",;				//-> Descricao
						"Integra��o Pipedrive     ",;				//-> Descricao SPA
						"Integra��o Pipedrive     ",;				//-> Descricao ENG
						"@!",;                 						//-> Picture
						"",;										//-> VALID
						X3_USADO,;		           					//-> USADO
						"",; 										//-> RELACAO
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
						"S=Sim;N=Nao",;								//-> CBOX
						"S=Sim;N=Nao",;								//-> CBOX SPA
						"S=Sim;N=Nao",;								//-> CBOX ENG
						"",;                       					//-> PICTVAR
						"",;                       					//-> WHEN
						"",;                       					//-> INIBRW
						"",;                       					//-> SXG
						"",;                       					//-> FOLDER
						"S"})                      					//-> PYME

	EndIf	

Return( aSX3 )