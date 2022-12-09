#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: IMPFARMA
Autor...............: luiz oliveira
Data................: 20/12/18
Descricao / Objetivo: Importar arquivo de Saldos de Estoque, Produtos, Fornecedores,
Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
*/

User Function IMPFARMA()

Local aMensagem := {}
Local aBotoes   := {}
Local bSair     := .T.
Local oButton1
Local oRadMenu1
Local oSay1
Static oDlg

Private cTitulo  := "Importação de Cadastros Básicos"
Private nEscolha := 1

IF CEMPANT <> '02'
	MsgStop("Importação somente para a empresa 02-!","ATENCAO")
	Return
endif
IF !(__CUSERID $ '000000|000014|000390')
	Alert("Usuário sem privilégios para acessar esta rotina")
	Return()
Endif


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
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes","Transportadora","Embalagem","Familia","NCM" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
Local aExecAuto := {}
Local aTipoImp  := {}
Local nTipoImp  := 0
Local cTipo     := ''
Local cTab      := ''
Local aMensagem :={}
Local nI        := 0
Local aSX3 	    :={}
Local nX        := 0
Private lMsErroAuto    := .F.
Private aTabExclui     := { {'B1',{"SB1"}} ,;
{'A2',{"SA2"} },;
{'A1',{"SA1"} },;
{'A4',{"SA4"} },;
{'Z2',{"SZ2"} },;
{'Z1',{"SZ1"} },;
{'YD',{"SYD"} }}



AAdd( aMensagem, OemToAnsi("Para importar a tabela de Produto, o arquivo deverá conter campos da SB1"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Fornecedor o arquivo deverá conter campos da SA2"))
AAdd( aMensagem, OemToAnsi("Para alterar a tabela de Clientes, o arquivo deverá conter campos da SA1"))
AAdd( aMensagem, OemToAnsi("Para alterar a tabela de Transportadora, o arquivo deverá conter campos da SA4"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de EMBALAGENS, o arquivo deverá conter campos da SZ2"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de FAMILIA, o arquivo deverá conter campos da SZ1"))
AAdd( aMensagem, OemToAnsi("Para importar/Atualizar a tabela de NCM, o arquivo deverá conter campos da SYD"))
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

IF !(cTIPO $('B1 A1 A2 A4 Z1 Z2 YD'))
	MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

IF  (cTIPO=='B1'.And. nEscolha<> 1) .OR. ;
	(cTIPO=='A2'.And. nEscolha<> 2) .OR. ;
	(cTIPO=='A1'.And. nEscolha<> 3) .OR. ;
	(cTIPO=='A4'.And. nEscolha<> 4) .OR. ;
	(cTIPO=='Z2'.And. nEscolha<> 5) .OR. ;
	(cTIPO=='Z1'.And. nEscolha<> 6) .OR. ;
	(cTIPO=='YD'.And. nEscolha<> 7)
	MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!')
	Return
ENDIF

cNewTipo := "S"+cTipo 

aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

For nI := 1 To Len(aSX3)
	for nX := 1 to Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nX],1,2) 
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
	cTab := aTabExclui[nTipoImp,2,nI]
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
cErro := ""
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
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	NoAcento(aDados[nI,nCampos]) 	,Nil})
				ENDIF
			ENDIF
		Next nCampos
		lMsErroAuto := .F.
		Begin Transaction
		IF cTipo == 'B1'       // Produto
			cCod := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_COD" } ) ,2]
			dbSelectArea("SB1")
			dbSetOrder(1)
			iF MsSeek(xFilial("SB1")+ cCod )
				CADSB1(aExecAuto)
			else
				//	MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3)// 3 - INCLUI /  4 - alteração
			Endif
		ELSEIF cTipo == 'A2'   // Fornecedor
			cCod := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_COD" } ) ,2]
			cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_LOJA" } ) ,2]
			dbSelectArea("SA2")
			dbSetOrder(1)
			iF !MsSeek(xFilial("SA2")+ cCod )
				//MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3)// 3 - INCLUI /  4 - alteração
			ELSE
				CADSA2(cCod,aExecAuto)
			ENDIF
			
		ELSEIF cTipo == 'A1'   //Cliente
			
			cCod := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_COD" } ) ,2]
			cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_LOJA" } ) ,2]
			dbSelectArea("SA1")
			dbSetOrder(1)
			iF MsSeek(xFilial("SA1")+ cCod )
				MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,4) // 3 - INCLUI /  4 - alteração
			else
				MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3) // 3 - INCLUI /  4 - alteração
			Endif
			
		ELSEIF cTipo == 'B9'   // Saldo de Estoque
			MSExecAuto({|x,y| MATA220(x,y)}, aExecAuto, 3)// 3 - INCLUI /  4 - alteração
		ELSEIF cTipo == 'Z2'   // Pagar
			CADSZ2(aExecAuto)
		ELSEIF cTipo == 'Z1'   // Receber
			CADSZ1(aExecAuto)
			
		ELSEIF cTipo == 'YD'       // NCM
			CADSYD(aExecAuto)
		ENDIF
		
		
		If lMsErroAuto
			DisarmTransaction()
			MostraErro()
			cFilAnt := cBKFilial
			cErro += "Linha "+Str(nI,4) +" - " +aExecAuto[1][2] + CRLF
			//Return
		EndIF
		End Transaction
	EndIF
	
	
Next nI

IF !empty(cErro)
	AVISO("ARQUIVOS COM ERRO",cErro,{"OK"},3)
ENDIF

msgAlert('Arquivo importado com sucesso !!')


FT_FUSE()

cFilAnt := cBKFilial

Return


STATIC FUNCTION CADSZ2(aExecAuto)
lRet := .T.
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z2_COD" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
//	cDesc := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z2_DESC" } ) ,2]
	//cDesres := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z2_DESCRES" } ) ,2]
	nPeso := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z2_PESOEMB" } ) ,2]
	
	DbSelectArea("SZ2")
	DbSetOrder(1)
	IF (DbSeek(xFilial("SZ2")+cCod,.f.))

	Reclock("SZ2",.F.)
	
	SZ2->Z2_PESOEMB	:=	nPeso
	
	msUnlock()
	
Endif
Endif

rETURN

STATIC FUNCTION CADSZ1(aExecAuto)

lRet := .T.
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z1_COD" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
	cDesc := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "Z1_DESC" } ) ,2]
	
	DbSelectArea("SZ1")
	DbSetOrder(1)
	
	lRet := !(DbSeek(xFilial("SZ1")+cCod,.f.))
	
	Reclock("SZ1",lRet)
	
	SZ1->Z1_COD		:= cCod
	SZ1->Z1_DESC	:=   cDesc
	
	msUnlock()
Endif

RETURN()


STATIC FUNCTION CADSB1(aExecAuto)
Local nX := 0
lRet := .T.
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_COD" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
	//	cOrig := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_DCB" } ) ,2]
	
	DbSelectArea("SB1")
	DbSetOrder(1)
	
	IF (DbSeek(xFilial("SB1")+cCod,.F.))
		Reclock("SB1",.F.)
		For nX:= 1 To Len(aExecAuto)
			if !(nPos == nX)
				if !Empty(aExecAuto[nX][2])
					//	SB1->B1_DCB	:=   cOrig
					cCampo  := "SB1->"+aExecAuto[nX][1]
					&cCampo := 	aExecAuto[nX][2]
				endif
			endif
		Next nX
		msUnlock()
	ENDIF
Endif

RETURN()

STATIC FUNCTION CADSA2(cCod,aExecAuto)
Local nX := 0 
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_COD" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
	cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_LOJA" } ) ,2]
	
	DbSelectArea("SA2")
	DbSetOrder(1)
	
	IF (DbSeek(xFilial("SA2")+cCod,.F.))
		Reclock("SA2",.F.)
		For nX:= 1 To Len(aExecAuto)
			if !(nPos == nX)
				if !Empty(aExecAuto[nX][2])
					cCampo  := "SA2->"+aExecAuto[nX][1]
					&cCampo := 	aExecAuto[nX][2]
				endif
			endif
		Next nX
		msUnlock()
	ENDIF
Endif

RETURN()

static FUNCTION NoAcento(cString)
Local cChar  := ""
Local nX     := 0
Local nY     := 0
Local cVogal := "aeiouAEIOU"
Local cAgudo := "áéíóú"+"ÁÉÍÓÚ"
Local cCircu := "âêîôû"+"ÂÊÎÔÛ"
Local cTrema := "äëïöü"+"ÄËÏÖÜ"
Local cCrase := "àèìòù"+"ÀÈÌÒÙ"
Local cTio   := "ãõÃÕ"
Local cCecid := "çÇ"
Local cMaior := "&lt;"
Local cMenor := "&gt;"

For nX:= 1 To Len(cString)
	cChar:=SubStr(cString, nX, 1)
	IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
		nY:= At(cChar,cAgudo)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCircu)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTrema)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cCrase)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
		EndIf
		nY:= At(cChar,cTio)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
		EndIf
		nY:= At(cChar,cCecid)
		If nY > 0
			cString := StrTran(cString,cChar,SubStr("cC",nY,1))
		EndIf
	Endif
Next

If cMaior$ cString
	cString := strTran( cString, cMaior, "" )
EndIf
If cMenor$ cString
	cString := strTran( cString, cMenor, "" )
EndIf

cString := StrTran( cString, CRLF, " " )

Return cString

STATIC FUNCTION CADSYD(aExecAuto)
Local nX := 0 
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "YD_TEC" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
	cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "YD_EX_NCM" } ) ,2] 	
	DbSelectArea("SYD")
	DbSetOrder(3)
	
	lRet := !(MSSeek(xFilial("SYD")+cCod,.F.)) 

	Reclock("SYD", lRet )
	For nX:= 1 To Len(aExecAuto)
			if !Empty(aExecAuto[nX][2])
				cCampo  := "SYD->"+aExecAuto[nX][1]
				&cCampo := 	aExecAuto[nX][2]
			endif
	Next nX
	msUnlock()
Endif

RETURN()


STATIC FUNCTION CADSBJ(aExecAuto)
Local nX := 0 
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "BJ_COD" } )
if nPos > 0
	cCod := aExecAuto[nPos,2]
	cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "BJ_LOCAL" } ) ,2]
	cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "BJ_LOTECTL" } ) ,2]
	cCod += DTOS(aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "BJ_DATA" } ) ,2] )
	
	DbSelectArea("SBJ")
	DbSetOrder(2) //BJ_COD;BJ_LOCAL;BJ_LOTECTL;BJ_DATA;
	
	IF (MSSeek(xFilial("SBJ")+cCod,.F.))
		
		Reclock("SBJ", .F. )
		For nX:= 5 To Len(aExecAuto)
			if !Empty(aExecAuto[nX][2])
				cCampo  := "SBJ->"+aExecAuto[nX][1]
				&cCampo := 	aExecAuto[nX][2]
			endif
		Next nX
		
		msUnlock()
		
	ENDIF
Endif

RETURN()
