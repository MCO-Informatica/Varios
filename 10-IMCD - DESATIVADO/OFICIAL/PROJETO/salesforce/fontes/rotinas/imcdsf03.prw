#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#define CRLF chr(13) + chr(10)

User Function IMCDSF03()

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
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Alterar Produtos","Alterar Fornecedor","Alterar Clientes","Pedidos de Venda"  SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
Private lMsErroAuto    := .F.
Private aTabExclui     := { {'B1',{"SB1"}} ,{'A2',{"SA2"} },{'A1',{"SA1"} },{'C6',{"SC6"} } }

AAdd( aMensagem, OemToAnsi("Para alterar Produtos, o arquivo deverá conter campos da SB1"))
AAdd( aMensagem, OemToAnsi("Para alterar Fornecedores o arquivo deverá conter campos da SA2"))
AAdd( aMensagem, OemToAnsi("Para alterar Clientes, o arquivo deverá conter campos da SA1"))
AAdd( aMensagem, OemToAnsi("Para alterar Pedidos de Venda o arquivo deverá conter campos da SC6"))

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

IF !(cTIPO $('B1 A1 A2 C6 '))
	MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

IF  (cTIPO=='B1'.And. nEscolha<> 1) .OR. ;
	(cTIPO=='A2'.And. nEscolha<> 2) .OR. ;
	(cTIPO=='A1'.And. nEscolha<> 3) .OR. ;
	(cTIPO=='C6'.And. nEscolha<> 4)
	
	MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!')
	
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImp)
	IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .And. cTipo <> 'C5'
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
		MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
		Return
	ENDIF
Next nI

nTipoImp  := aScan( aTabExclui, { |x| AllTrim( x[1] ) == cTipo } )

cTab := ''
For nI := 1 To Len(aTabExclui[nTipoImp,2])
	cTab += aTabExclui[nTipoImp,2,nI]
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
nRegGrav := 0
cChave := "zzzzz"
For nI:=1 to  Len(aDados)
	IncProc("Importando arquivo - "+ STR(nRegGrav))
	IF nEscolha < 5
		aExecAuto := {}
		For nCampos := 1 To Len(aCampos)
			IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
				IF !EMpty(aDados[nI,nCampos])
					cFilAnt := aDados[nI,nCampos]
				ENDIF
			Else
				IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='GARANT'
					If Empty(SB1->B1_GARANT)
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	'2' 	,Nil})
					else
						aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	SB1->B1_GARANT 	,Nil})
					endif
				ELSEIF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
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
			CADSB1(aExecAuto)
		ELSEIF cTipo == 'A2'   // Fornecedor
			CADSA2(aExecAuto)
		ELSEIF cTipo == 'A1'   //Cliente
			CADSA1(aExecAuto)
		ELSEIF cTipo == 'C6'   //PEDIDO
			CADSC6(aExecAuto)
		ENDIF
		nRegGrav++
		End Transaction
	EndIF
Next nI

msgAlert('Arquivo importado com sucesso ! Total '+ Alltrim(Str(nRegGrav))+" Registro"+iif(nRegGrav>1,"s.","." ) )


FT_FUSE()

cFilAnt := cBKFilial

Return


STATIC FUNCTION CADSB1(aExecAuto)

lRet := .T.
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_COD" } )
lAlt := .F.

cSFID := ""
cUSPRE := ""
cPRINC := ""
cBloq := ""

if nPos > 0
	cCod := aExecAuto[nPos,2]
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_X_SFID" } )
	if nPos > 0
		cSFID := aExecAuto[ nPos,2]
	endif
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_USPRE" } )
	if nPos > 0
		cUSPRE := aExecAuto[ nPos,2]
	endif
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_X_PRINC" } )
	if nPos > 0
		cPRINC := aExecAuto[ nPos,2]
	endif
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_MSBLQL" } )
	if nPos > 0
		cBloq := aExecAuto[ nPos,2]
	endif

	dbSelectArea("SB1")
	dbSetOrder(1)
	IF MsSeek(xFilial("SB1")+ cCod )
		
		Reclock("SB1",.F.)
		
		IF !eMPTY(cSFID)
			SB1->B1_X_SFID	:=   cSFID
			lAlt := .T.
		ENDIF
		IF !eMPTY(cUSPRE)  //.and. SB1->B1_USPRE <> cUSPRE
			SB1->B1_USPRE	:=   cUSPRE
			lAlt := .T.
		ENDIF
		IF !EMPTY(cPRINC)
			SB1->B1_X_PRINC	:=   cPRINC
			lAlt := .T.
		ENDIF

		IF !EMPTY(cBloq)
			SB1->B1_MSBLQL	:= cBloq
			lAlt := .T.
		ENDIF
				
		if lAlt
			SB1->B1_MSEXP	:=  DTOS(dDatabase)
		endif
		
		msUnlock()
	Endif
Endif

RETURN()

STATIC FUNCTION CADSA1(aExecAuto)

lRet := .T.

nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_COD" } )

if nPos > 0
	cSFID:= ''
	cVend := ''
	
	cCod := aExecAuto[nPos,2]
	
	nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_LOJA" } )
	if nPos > 1
		cCod += aExecAuto[nPos,2]
	endif
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_X_SFID" } )
	if nPos > 1
		cSFID := aExecAuto[nPos,2]
	endif
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_VEND" } )
	if nPos > 1
		cVend := aExecAuto[nPos,2]
	endif
	
	
	nPos := aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_MSBLQL" } )
	if nPos > 1
		cBLOQ := aExecAuto[nPos,2]
	endif
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	if MsSeek(xFilial("SA1")+ cCod )
		
		Reclock("SA1",.F.)
		
		IF !EMPTY(cSFID)
			SA1->A1_X_SFID	:=  cSFID
			lAlt := .T.
		ENDIF
		
		IF !EMPTY(cVend)
			SA1->A1_VEND	:=  cVend
			lAlt := .T.
		ENDIF
		
		if lAlt
			SA1->A1_MSEXP	:=   DTOS(dDatabase)
		endif
		
		msUnlock()
	Endif
Endif

RETURN()

STATIC FUNCTION CADSA2(aExecAuto)

lRet := .T.
nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_COD" } )

if nPos > 0
	cCod := aExecAuto[nPos,2]
	cSFID := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_X_SFID" } ) ,2]
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	If (MsSeek(xFilial("SA2")+ cCod ))
		
		Reclock("SA2",.F.)
		
		IF !EMPTY(cSFID)
			SA2->A2_X_SFID	:=   cSFID
			lAlt := .T.
		ENDIF
		
		if lAlt
			SA2->A2_MSEXP	:=   DTOS(dDatabase)
		endif
		
		msUnlock()
	Endif
	
Endif

RETURN()

STATIC FUNCTION CADSC6(aExecAuto)

nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "C6_NUM" } )
cNumPed := aExecAuto[nPos,2]

nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "C6_ITEM" } )
cItem := aExecAuto[nPos,2]

nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "C6_PRODUTO" } )
cProduto := aExecAuto[nPos,2]


if !EMPTY(cNumPed)
	
	dbSelectArea("SC5")
	dbSetOrder(1)
	If (MsSeek( xFilial("SC5") + cNumPed ))
		Reclock("SC5",.F.)
		SC5->C5_MSEXP :=  DTOS(dDatabase)
		msUnlock()
	Endif
	
	dbSelectArea("SC6")
	dbSetOrder(1)
	If (MsSeek(XFilial("SC6") + cNumPed + cItem + cProduto ))
		Reclock("SC6",.F.)
		SC6->C6_MSEXP :=  DTOS(dDatabase)
		msUnlock()
	Endif
Endif

RETURN()
