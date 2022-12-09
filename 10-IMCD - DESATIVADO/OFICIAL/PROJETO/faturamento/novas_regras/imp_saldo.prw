#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
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

User Function IMP_GERAL()    // U_IMP_SALDO()

	Local aMensagem := {}
	Local aBotoes   := {}
	Local bSair     := .T.
	Local oButton1
	Local oRadMenu1
	Local oSay1
	Static oDlg


	Private cTitulo  := "Importação de Cadastros Básicos"
	Private nEscolha := 1

	RpcSetType ( 3 )
	PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01'
	__cUserId := '000390'
	iF !(__cUserId $ '000000|000390|000315')
		MsgStop("função bloqueada contate o ADM","ATENCAO")
		lRet := .F.
		RETURN()
	endif

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

		@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Saldos de Estoque SB9","Saldos de Estoque SBK","Saldos de Estoque SBJ" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
		@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
		oButton1 := TButton():New( 104, 141 ,'Importar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Importando...', .F. ),oDLG:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

		ACTIVATE MSDIALOG oDlg CENTERED

	ENDIF

	RESET ENVIRONMENT

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
	Local aSX3      := {}
	Local nX        := 0
	Private lMsErroAuto    := .F.
	Private aTabExclui     := { {'B9',{"SB9"} },;
		{'BK',{"SBF"} },;
		{'BJ',{"SB8"} }}




	AAdd( aMensagem, OemToAnsi("Para importar a tabela SB9, o arquivo deverá conter campos da SB9"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela SBK, o arquivo deverá conter campos da SBK"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela SBJ, o arquivo deverá conter campos da SBJ"))
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
	cTipo     := SUBSTR(aTipoImp[1],1,2)

	IF !(cTIPO $('B9 BK BJ'))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
		Return
	ENDIF

	IF  (cTIPO=='B9'.And. nEscolha<> 1) .OR. ;
			(cTIPO=='BK'.And. nEscolha<> 2) .OR. ;
			(cTIPO=='BJ'.And. nEscolha<> 3)
		MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!')
		Return
	ENDIF

	cNewTipo := "S"+cTipo
	aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

	For nX := 1 to len(aSX3)
		For nI := 1 To Len(aTipoImp)
			IF Ascan(aSx3, aTipoImp[nI]) == 0
				MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
				Return
			ELSEIF (GetSx3Cache(aSX3[Ascan(aSx3, aTipoImp[nI])],"X3_VISUAL") $ ('V') ) .OR. (GetSx3Cache(aSX3[Ascan(aSx3, aTipoImp[nI])],"X3_CONTEXT") == "V"  )
				MsgAlert('Campo marcado na tabela como visual :'+aTipoImp[nI]+' !!')
				Return
			ENDIF
		Next nI
	next nX
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


	For nCampos := 1 To Len(aCampos)
		IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
			IF !EMpty(aDados[1,nCampos])
				cFilAnt := aDados[1,nCampos]
			ENDIF
		Else
			IF SUBSTR(Upper(aCampos[nCampos]),1,2)='C5'
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


		Begin Transaction
			IF cTipo == 'B9'

				Reclock("SB9",.T.)
				B9_FILIAL := aDados[nI,1]
				B9_COD := aDados[nI,2]
				B9_LOCAL := aDados[nI,3]
				B9_DATA	:= CTOD(aDados[nI,4])
				B9_QINI	:= VAL(aDados[nI,5])
				B9_VINI1 := VAL(aDados[nI,6])
				B9_VINI2 := VAL(aDados[nI,7])
				B9_VINI3 := VAL(aDados[nI,8])
				B9_VINI4 := VAL(aDados[nI,9])
				B9_VINI5 := VAL(aDados[nI,10])
				B9_CUSTD := VAL(aDados[nI,11])
				B9_MCUSTD := aDados[nI,12]
				B9_CM1 := VAL(aDados[nI,13])
				B9_CM2 := VAL(aDados[nI,14])
				B9_CM3 := VAL(aDados[nI,15])
				B9_CM4 := VAL(aDados[nI,16])
				B9_CM5 := VAL(aDados[nI,17])

				MsUnlock()

			ELSEIF cTipo == 'BK'

				Reclock("SBK",.T.)
				BK_FILIAL := aDados[nI,1]
				BK_COD := aDados[nI,2]
				BK_LOCAL := aDados[nI,3]
				BK_DATA	:= CTOD(aDados[nI,4])
				BK_QINI	:= VAL(aDados[nI,5])
				BK_LOTECTL := aDados[nI,6]
				BK_LOCALIZ := aDados[nI,7]
				MsUnlock()

			ELSEIF cTipo == 'BJ'

				Reclock("SBJ",.T.)
				BJ_FILIAL:= aDados[nI,1]
				BJ_COD:= aDados[nI,2]
				BJ_LOCAL:= aDados[nI,3]
				BJ_DATA:= CTOD(aDados[nI,4])
				BJ_QINI:= VAL(aDados[nI,5])
				BJ_LOTECTL:= aDados[nI,6]
				BJ_DFABRIC:= CTOD(aDados[nI,7])
				BJ_DTVALID:= CTOD(aDados[nI,8])

				MsUnlock()
			ENDIF

		End Transaction

	Next nI

	msgAlert('Arquivo importado com sucesso !!')


	FT_FUSE()

	cFilAnt := cBKFilial

Return
