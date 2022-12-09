#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: IMP_MESTRE
Autor...............: luiz oliveira
====================================================================================
*/

User Function IMP_MESTRE() 

Local aMensagem := {}
Local aBotoes   := {}
Local bSair     := .T.
Local oButton1
Local oRadMenu1
Local oSay1
Static oDlg


Private cTitulo  := "Importa��o de Cadastros B�sicos"
Private nEscolha := 1

Aadd( aMensagem, OemToAnsi("Este programa tem como objetivo importar cadastros padr�es atrav�s de arquivos textos                              "))
Aadd( aMensagem, OemToAnsi("    "))
Aadd( aMensagem, OemToAnsi("Este arquivo dever� ser separado por ponto e virgulas(.CSV) e o primeiro registro conter� os  nomes dos campos a serem importados"))
Aadd( aMensagem, OemToAnsi("    "))
AAdd( aMensagem, OemToAnsi("Ser� questionado se dever� ser excluidos os registros das tabelas destinos antes da importa��o."))
AAdd( aBotoes, { 19, .T., { || FechaBatch(), bSair     := .F. } } )
AAdd( aBotoes, { 02, .T., { || FechaBatch(), bSair     := .T. } } )
FormBatch( cTitulo, aMensagem, aBotoes, , 260,700  )
IF !bSair
	
	
	DEFINE MSDIALOG oDlg TITLE "Importa��o de Cadastros" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Importar Mestre de Inventario" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
'
Local aTipoImp  := {}
Local cTipo     := ''
Local aMensagem :={}
Local nI        := 0

AAdd( aMensagem, OemToAnsi("Para alterar a tabela de Mestre de Inventario, o arquivo dever� conter campos da CBA"))
MsgAlert(aMensagem[nEscolha])

cArq := cGetFile("Todos os Arquivos|*.csv", OemToAnsi("Informe o diret�rio que est� o arquivo"), 0, "SERVIDOR\", .F., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

If !File(cArq)
	MsgStop("O arquivo " +cArq + " n�o foi encontrado. A importa��o ser� abortada!","ATENCAO")
	Return
EndIf

FT_FUSE(cArq)
FT_FGOTOP()
cLinha    := FT_FREADLN()
aTipoImp  := Separa(cLinha,";",.T.)
cTipo     := SUBSTR(aTipoImp[1],1,2)

IF !(cTIPO $('CBA'))
	MsgAlert('N�o � possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF


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
			
			Begin Transaction
				Reclock("CBA",.T.)
					CBA->CBA_FILIAL := aDados[nI,1] 
					CBA->CBA_CODINV := aDados[nI,2]
					CBA->CBA_DATA   := CTOD(aDados[nI,3])
					CBA->CBA_CONTS  := VAL(aDados[nI,4]) 
					CBA->CBA_LOCAL  := aDados[nI,5]
					CBA->CBA_TIPINV := aDados[nI,6]
					CBA->CBA_LOCALI := aDados[nI,7]
					CBA->CBA_STATUS := aDados[nI,8]
					CBA->CBA_CLASSA := "2"
					CBA->CBA_CLASSB := "2"
					CBA->CBA_CLASSC := "2"

				msUnlock()
	
			End Transaction

Next nI

msgAlert('Arquivo importado com sucesso !' )


FT_FUSE()

cFilAnt := cBKFilial

Return
