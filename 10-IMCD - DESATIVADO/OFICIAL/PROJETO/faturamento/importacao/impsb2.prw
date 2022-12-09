#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: IMPFORSF
Autor...............: Junior Carvalho
Data................: 27/11/2018
Descricao / Objetivo: Importar arquivo de Saldos de Estoque, Produtos, Fornecedores,
Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
*/


User Function IMPSB9()

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
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "PRODUTO X FORNECEDOR" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
Private lMsErroAuto    := .F.
Private aTabExclui     := { {'B9',{"SB9"}} }

AAdd( aMensagem, OemToAnsi("Para importar o arquivo deverá conter registros das tabelas SB9"))
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

IF !(cTIPO $('B9'))
	MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImp)
	IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .And. cTipo <> 'B9'
	ENDIF
Next nI

nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

cTab := ''
For nI := 1 To Len(aTabExclui[nTipoImp,2])
	cTab += aTabExclui[nTipoImp,2,nI]+' '
Next nI
cErro := ""

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
ProcRegua(Len(aDados))
For nI:=1 to  Len(aDados)
	IF nEscolha <> 8
		aExecAuto := {}
		IncProc("Importando arquivo...")
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
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	Alltrim(NoAcento(aDados[nI,nCampos])) 	,Nil})
				ENDIF
			ENDIF
		Next nCampos
		
		if !empty(aExecAuto)
			CADSB9(aExecAuto)
		endif
		
	EndIF
	
Next nI

IF !empty(cErro)
	AVISO("ARQUIVOS COM ERRO",cErro,{"OK"},3)
ENDIF

msgAlert('Arquivo importado com sucesso !!')


FT_FUSE()

cFilAnt := cBKFilial

Return

STATIC FUNCTION CADSB9(aExecAuto)

cPrd  := aExecAuto[1][2] + Space( (TamSX3("B9_COD")[1] - Len(aExecAuto[1][2])) )
cLocal := aExecAuto[2][2] + Space( (TamSX3("B9_LOCAL")[1] - Len(aExecAuto[2][2]) ) )

cChave := cPrd   + cLocal
DbSelectArea("SB9")
DbSetOrder(1) // B9_FILIAL, B9_DATA, B9_LOCAL

IF (msseek(xFilial("SB9")+cChave,.F.))
	Reclock("SB9",.F.)
	For nX:= 3 To Len(aExecAuto)
		if !(nPos == nX)
			if !Empty(aExecAuto[nX][2])
				cCampo  := "SB9->"+aExecAuto[nX][1]
				&cCampo := 	aExecAuto[nX][2]
			endif
		endif
	Next nX
	msUnlock()
ENDIF

RETURN()
