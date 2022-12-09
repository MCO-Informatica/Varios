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

User Function IMP_CLI2()    // U_IMP_SALDO()

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

		@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes","Saldos de Estoque","Saldo a Pagar","Saldo a Receber","Lotes de Estoque","Pedidos de Venda em Aberto" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
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
	Private aTabExclui     := { {'B1',{"SB1"}} ,;
	{'B9',{"SB2","SB9"} },;
	{'A2',{"SA2"} },;
	{'A1',{"SA1"} },;
	{'E2',{"SE2"} },;
	{'E1',{"SE1"} },;
	{'C5',{"SC5","SC6"} },;
	{'C6',{"SC5","SC6"} },;
	{'D5',{"SD5"} } }




	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Produto, o arquivo deverá conter campos da SB1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Fornecedor o arquivo deverá conter campos da SA2"))
	AAdd( aMensagem, OemToAnsi("Para alterar a tabela de Clientes, o arquivo deverá conter campos da SA1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo de Estoque, o arquivo deverá conter campos da SB9"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Pagar, o arquivo deverá conter campos da SE2"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Saldo a Receber, o arquivo deverá conter campos da SE1"))
	AAdd( aMensagem, OemToAnsi("Para importar a tabela de Lotes do Estoque, o arquivo deverá conter campos da SD5"))
	AAdd( aMensagem, OemToAnsi("Para importar a Pedidos de Venda o arquivo deverá conter registros das tabelas SC5 e SC6"+CRLF+;
	"Sendo que o primeiro deverá conter os campos da SC5 e depois da SC6"+CRLF+;
	"Obrigatoriamente deverá conter o campo C5_NUM"+CRLF+;
	"Quando mudar o C5_NUM será entendido que será um novo pedido de venda"))
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

	IF !(cTIPO $('B1 B9 A1 A2 E1 E2 D5 C5'))
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
	(cTIPO=='C5'.And. nEscolha<> 8) 
		MsgAlert('Escolha é diferente do Arquivo Texto'+cTipo+ '  !!') 
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
		iF MsSeek(xFilial("SA1")+aDados[nI,1]+aDados[nI,2])

			RECLOCK("SA1",.F.)
			SA1->A1_COD_MUN := aDados[nI,3]      //NOVO VALOR DE SALDO  
			MSUNLOCK()   

		Endif
	Next nI

	msgAlert('Arquivo importado com sucesso !!')


	FT_FUSE()            

	cFilAnt := cBKFilial

Return