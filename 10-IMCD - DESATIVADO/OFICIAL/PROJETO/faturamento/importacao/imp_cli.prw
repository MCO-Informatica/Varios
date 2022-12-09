#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: IMP_SALDO
Autor...............: luiz oliveira
Data................: 20/12/18
Descricao / Objetivo: Importar arquivo de Saldos de Estoque, Produtos, Fornecedores,
Clientes, Saldo a Pagar e Saldo a Receber
====================================================================================
*/

User Function IMP_CLI()    // U_IMP_SALDO()

Local aMensagem := {}
Local aBotoes   := {}
Local bSair     := .T.
Local oButton1
Local oRadMenu1
Local oSay1
Static oDlg


Private cTitulo  := "Importa��o de Cadastros B�sicos"
Private nEscolha := 1

	RpcSetType ( 3 )
	PREPARE ENVIRONMENT EMPRESA '04' FILIAL '01' MODULO "FIS"
	__cUserId := '000390'
	iF !(__cUserId $ '000000|000390|000315')
		MsgStop("fun��o bloqueada contate o ADM","ATENCAO")
		lRet := .F.
		RETURN()
	endif

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
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes","Saldos de Estoque","Saldo a Pagar","Saldo a Receber","Lotes de Estoque","Pedidos de Venda em Aberto" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
Local aSX3 	    :={}
Local nX        := 0
Private lMsErroAuto    := .F.
Private aTabExclui     := { {'B1',{"SB1"}} ,;
{'B9',{"SB2","SB9"} },;
{'A2',{"SA2"} },;
{'A1',{"SA1"} },;
{'E2',{"SE2"} },;
{'E1',{"SE1"} },;
{'C5',{"SC5","SC6"} },;
{'C6',{"SC5","SC6"} },;
{'D5',{"SD5"} } }


AAdd( aMensagem, OemToAnsi("Para importar a tabela de Produto, o arquivo dever� conter campos da SB1"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Fornecedor o arquivo dever� conter campos da SA2"))
AAdd( aMensagem, OemToAnsi("Para alterar a tabela de Clientes, o arquivo dever� conter campos da SA1"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo de Estoque, o arquivo dever� conter campos da SB9"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Pagar, o arquivo dever� conter campos da SE2"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Receber, o arquivo dever� conter campos da SE1"))
AAdd( aMensagem, OemToAnsi("Para importar a tabela de Lotes do Estoque, o arquivo dever� conter campos da SD5"))
AAdd( aMensagem, OemToAnsi("Para importar a Pedidos de Venda o arquivo dever� conter registros das tabelas SC5 e SC6"+CRLF+;
"Sendo que o primeiro dever� conter os campos da SC5 e depois da SC6"+CRLF+;
"Obrigatoriamente dever� conter o campo C5_NUM"+CRLF+;
"Quando mudar o C5_NUM ser� entendido que ser� um novo pedido de venda"))
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

IF !(cTIPO $('B1 B9 A1 A2 E1 E2 D5 C5'))
	MsgAlert('N�o � possivel importar a tabela: '+cTipo+ '  !!')
	Return
ENDIF

IF  (cTIPO=='B1'.And. nEscolha<> 1) .OR. ;
	(cTIPO=='A2'.And. nEscolha<> 2) .OR. ;
	(cTIPO=='A1'.And. nEscolha<> 3) .OR. ;
	(cTIPO=='B9'.And. nEscolha<> 4) .OR. ;
	(cTIPO=='E2'.And. nEscolha<> 5) .OR. ;
	(cTIPO=='E1'.And. nEscolha<> 6) .OR. ;
	(cTIPO=='D5'.And. nEscolha<> 7) .OR. ;
	(cTIPO=='C5'.And. nEscolha<> 8)
	MsgAlert('Escolha � diferente do Arquivo Texto'+cTipo+ '  !!')
	Return
ENDIF

cNewTipo := "S"+cTipo 

aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

For nI := 1 To Len(aSX3)
	for nX := 1 to Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nX],1,2) .And. cTipo <> 'C5'
			MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
			Return
		ENDIF
		if Ascan(aSx3, aTipoImp[nX]) == 0
			MsgAlert('Campo n�o encontrado na tabela :'+aTipoImp[nI]+' !!')
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
	dbSelectArea("SA1")
	dbSetOrder(1)
	//	iF MsSeek(xFilial("SA1")+aDados[nI,1]+aDados[nI,2])   //retirado para usar op��o INCLUIR
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
			MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,3) //incluir
		ELSEIF cTipo == 'A2'   // Fornecedor
			MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,3)
		ELSEIF cTipo == 'A1'   //Cliente
			dbSelectArea("SA1")
			dbSetOrder(1)
			iF !MsSeek(xFilial("SA1")+aExecAuto[1,2]+aExecAuto[2,2])
				
				MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3) //incluir 
				
			ENDIF
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
	EndIF
	
	//Endif
Next nI

msgAlert('Arquivo importado com sucesso !!')


FT_FUSE()

cFilAnt := cBKFilial

Return
