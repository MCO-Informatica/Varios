#INCLUDE "Protheus.ch" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH" 
#INCLUDE "TOPCONN.CH" 

#define CRLF chr(13) + chr(10)             

/*
===================================================================================
Programa............: IMP_SALDO
Autor...............: Marcelo Carneiro
Data................: 19/05/2015
Descricao / Objetivo: Importar arquivo de Saldos de Estoque, Produtos, Fornecedores,
Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
*/

User Function IMP_TAB()    

	Local aMensagem := {}
	Local aBotoes   := {}                      
	Local bSair     := .T.
	Local oButton1
	Local oRadMenu1
	Local oSay1
	Static oDlg


	Private cTitulo  := "Importação de Cadastros Básicos"
	Private nEscolha := 1

	Aadd( aMensagem, OemToAnsi("Este programa tem como objetivo importar cadastros padrões através de arquivos textos                              "))
	Aadd( aMensagem, OemToAnsi("    "))
	Aadd( aMensagem, OemToAnsi("Este arquivo deverá ser separado por ponto e virgulas(.CSV) e o primeiro registro conterá os  nomes dos campos a serem importados"))
	Aadd( aMensagem, OemToAnsi("    "))
	AAdd( aMensagem, OemToAnsi("Será questionado se deverá ser excluidos os registros das tabelas destinos antes da importação."))
	AAdd( aBotoes, { 19, .T., { || FechaBatch(), bSair     := .F. } } )
	AAdd( aBotoes, { 02, .T., { || FechaBatch(), bSair     := .T. } } )
	FormBatch( cTitulo, aMensagem, aBotoes, , 260,700  )
	IF !bSair


		DEFINE MSDIALOG oDlg TITLE "Importação de Cadastros" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

		@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes","Saldos de Estoque","Saldo a Pagar","Saldo a Receber","Lotes de Estoque","Tabela de preço" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
		@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
		oButton1 := TButton():New( 104, 141 ,'Importar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Importando...', .F. ),oDlg:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlg CENTERED

	ENDIF


	Return
	***********************************************************************************************************************
Static Function ImpSal_Exec()
	Local cArq	    := ""
	Local cLinha    := ''
	Local lPrim     := .T.    
	Local aCampos   := {}           
	Local aDados    := {} 
	Local cBKFilial := cFilAnt
	Local nCampos   := 0
	Local cSQL      := ''         
	Local aExecAuto := {}
	Local aTipoImp  := {}
	Local nTipoImp  := 0
	Local cTipo     := ''
	Local cTab      := ''
	Local aMensagem :={}       
	Local aCab      := {}
	Local aItem     := {}                                    
	Local nI        := 0 
	Local cPedido   := ''
	Local aSX3 	    :={}
	Local nX        := 0
	Private lMsErroAuto    := .F.            
	Private aTabExclui     := { {'B1',{"SB1"}} ,;
	{'B9',{"SB2","SB9"} },;
	{'A2',{"SA2"} },;
	{'A1',{"SA1"} },;
	{'E2',{"SE2"} },;
	{'E1',{"SE1"} },;
	{'DA0',{"DA0","DA1"} },;
	{'DA1',{"DA0","DA1"} },;
	{'D5',{"SD5"} } }




	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Produto, o arquivo deverá conter campos da SB1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Fornecedor o arquivo deverá conter campos da SA2"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Clientes, o arquivo deverá conter campos da SA1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo de Estoque, o arquivo deverá conter campos da SB9"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Pagar, o arquivo deverá conter campos da SE2"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Receber, o arquivo deverá conter campos da SE1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Lotes do Estoque, o arquivo deverá conter campos da SD5"))
	AAdd( aMensagem, OemToAnsi("Para importar a Tabela de Preços o arquivo deverá conter registros das tabelas DA0 e DA1"+CRLF+;
	"Sendo que o primeiro deverá conter os campos da DA0 e depois da DA1"+CRLF+;
	"Obrigatoriamente deverá conter o campo DA0_CODTAB"+CRLF+;
	"Quando mudar o NUMERO será entendido que será um novo pedido de venda"))
	MsgAlert(aMensagem[nEscolha])

	cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diretório que está o arquivo"), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha    := FT_FREADLN()
	aTipoImp  := Separa(cLinha,";",.T.)
	cTipo     := SUBSTR(aTipoImp[1],1,3)

	IF !(cTIPO $('B1 B9 A1 A2 E1 E2 D5 DA0'))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!') 
		Return
	ENDIF

	IF  (cTIPO=='B1'.And. nEscolha<> 1) .OR. ;
	(cTIPO=='A2'.And. nEscolha<> 2) .OR. ;
	(cTIPO=='A1'.And. nEscolha<> 3) .OR. ;
	(cTIPO=='B9'.And. nEscolha<> 4) .OR. ;
	(cTIPO=='E2'.And. nEscolha<> 5) .OR. ;
	(cTIPO=='E1'.And. nEscolha<> 6) .OR. ;
	(cTIPO=='D5'.And. nEscolha<> 7) .OR. ;
	(cTIPO=='DA0'.And. nEscolha<> 8) 
		MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!') 
		Return
	ENDIF

	cNewTipo := "S"+cTipo 

aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

For nI := 1 To Len(aSX3)
	for nX := 1 to Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nX],1,2) .And. cTipo <> 'DA0'
			MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
			Return
		ENDIF
		if Ascan(aSx3, aTipoImp[nX]) == 0
			MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
			Return
		ELSE
			IF (GetSx3Cache(aSX3[Ascan(aSx3, aTipoImp[nX])],"X3_VISUAL") $ ('V') ) .OR. (GetSx3Cache(aSX3[Ascan(aSx3, aTipoImp[nX])],"X3_CONTEXT") == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Endif		
	next nX				
Next nI

	nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

	cTab := ''
	For nI := 1 To Len(aTabExclui[nTipoImp,2])
		cTab += aTabExclui[nTipoImp,2,nI]+' '
	Next nI

	If MsgYesNo("Deseja excluir os dados da(s) tabela(s):"+cTab+"antes da importação ? ")
		For nI := 1 To Len(aTabExclui[nTipoImp,2])
			cSQL := "delete from "+RetSqlName(aTabExclui[nTipoImp,2,nI])
			If (TCSQLExec(cSQL) < 0)
				Return MsgStop("TCSQLError() " + TCSQLError())
			EndIf
		Next nI
	EndIf	

	ProcRegua(FT_FLASTREC())
	FT_FGOTOP()
	While !FT_FEOF()
		IncProc("Lendo arquivo texto...")
		cLinha := FT_FREADLN()
		If lPrim
			aCampos := Separa(cLinha,";",.T.)
			lPrim := .F.
		Else
			AADD(aDados,Separa(cLinha,";",.T.))
		EndIf
		FT_FSKIP()
	EndDo                
	aCab    := {}
	cPedido := aDados[01,01] 
	For nCampos := 1 To Len(aCampos)
		IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
			IF !EMpty(aDados[1,nCampos])
				cFilAnt := aDados[1,nCampos]
			ENDIF
		Else
			IF SUBSTR(Upper(aCampos[nCampos]),1,3)='DA0'
				IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	VAL(aDados[1,nCampos] )	,Nil})
				ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
					aAdd(aCab ,{Upper(aCampos[nCampos]),  CTOD(aDados[1,nCampos] )	,Nil})
				ELSE
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	aDados[1,nCampos] 	,Nil})
				ENDIF
			EndIF
		ENDIF
	Next nCampos
	aItem := {}
	ProcRegua(Len(aDados))      
	For nI:=1 to  Len(aDados)
		IncProc("Importando arquivo...")
		IF nEscolha <> 8
			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
					ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
					ELSE
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
					ENDIF
				ENDIF
			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				IF cTipo == 'B1'       // Produto
					MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3)
				ELSEIF cTipo == 'A2'   // Fornecedor
					MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3)
				ELSEIF cTipo == 'A1'   //Cliente
					MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3)
				ELSEIF cTipo == 'B9'   // Saldo de Estoque
					MSExecAuto({|x,y| MATA220(x,y)}, aExecAuto, 3)
				ELSEIF cTipo == 'E2'   // Pagar
					MSExecAuto({|x,y| FINA050(x,y)},aExecAuto,3)
				ELSEIF cTipo == 'E1'   // Receber
					MSExecAuto({|x,y| FINA040(x,y)},aExecAuto,3)
				ELSEIF cTipo == 'D5'   // Lotes Saldo
					MSExecAuto({|x,y| Mata390(x,y)},aExecAuto,3)
				ENDIF
				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
					cFilAnt := cBKFilial
				EndIF
			End Transaction
		Else
			aExecAuto :={}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
					IF !EMpty(aDados[nI,nCampos])
						cFilAnt := aDados[nI,nCampos]
					ENDIF
				Else
					IF SUBSTR(Upper(aCampos[nCampos]),1,3)=='DA1'
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
						ENDIF
					EndIF
				ENDIF
			Next nCampos
			IF cPedido == aDados[nI,01]
				aAdd(aItem,aExecAuto)
			Else
				lMsErroAuto := .F.
				Begin Transaction
					Omsa010(aCab,aItem,3)
					If lMsErroAuto
						DisarmTransaction()
						MostraErro()
						cFilAnt := cBKFilial
					EndIF
				End Transaction
				cPedido :=  aDados[nI,01]
				aCab      := {}
				aItem     := {}
				For nCampos := 1 To Len(aCampos)
					IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
						IF !EMpty(aDados[nI,nCampos])
							cFilAnt := aDados[nI,nCampos]
						ENDIF
					Else
						IF SUBSTR(Upper(aCampos[nCampos]),1,2)='DA0'
							IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
								aAdd(aCab ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
							ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
								aAdd(aCab ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
							ELSE
								aAdd(aCab ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
							ENDIF
						EndIF
					ENDIF

				Next nCampos
				aAdd(aItem,aExecAuto)
			EndIF
			IF nI == Len(aDados)
				lMsErroAuto := .F.
				Begin Transaction
					Omsa010(aCab,aItem,3)
					If lMsErroAuto
						DisarmTransaction()
						MostraErro()
						cFilAnt := cBKFilial
					EndIF
				End Transaction

			EndIF
		EndIF
	Next nI

	u_Ajustab()

	msgAlert('Arquivo importado com sucesso !!')  


	cFilAnt := cBKFilial

Return