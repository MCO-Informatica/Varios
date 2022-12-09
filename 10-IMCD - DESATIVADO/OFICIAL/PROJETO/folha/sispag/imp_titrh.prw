#INCLUDE "Protheus.ch" 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"     
#define CRLF chr(13) + chr(10)             

/*
===================================================================================
Programa............: IMP_TITRH
Autor...............: luiz oliveira
Data................: 20/12/18
Descricao / Objetivo: Importar de planilha do RH para financeiro
Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
*/

User Function IMP_TITRH()    // U_IMP_TITRH()

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


		DEFINE MSDIALOG oDlg TITLE "Importação de Titulo RH - Financeiro" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

		@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "RH Importação Financeira" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
		@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro a importar :" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
		oButton1 := TButton():New( 104, 141 ,'Importar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Importando...', .F. ),oDLG:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

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

	AAdd( aMensagem, OemToAnsi("Para importar a planilha, o arquivo deverá conter campos da SE2"))
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

	IF !(cTIPO $('E2'))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!') 
		Return
	ENDIF

	cNewTipo := "S"+cTipo 

aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

For nI := 1 To Len(aSX3)
	for nX := 1 to Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nX],1,2) .And. cTipo <> 'E2'
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
	ProcRegua(Len(aDados))      
	For nI:=1 to  Len(aDados)
		IncProc("Importando arquivo...")   
				aExecAuto := {}  
				
				For nCampos := 1 To Len(aCampos)
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
						ENDIF 

				Next nCampos 
				
				lMsErroAuto := .F.     

				Begin Transaction

						MsExecAuto( { |x,y,z| FINA050(x,y,z)}, aExecAuto,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

					If lMsErroAuto
						DisarmTransaction()
						MostraErro()
						cFilAnt := cBKFilial
					EndIF
				End Transaction
	Next nI

	msgAlert('Arquivo importado com sucesso !!')

	cFilAnt := cBKFilial

Return