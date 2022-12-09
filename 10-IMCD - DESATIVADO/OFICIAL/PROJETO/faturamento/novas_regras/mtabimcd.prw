#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

#define CRLF chr(13) + chr(10)

/*
===================================================================================
Programa............: mtabimcd
Autor...............: LUIZ OLIVEIRA
Data................: 13/02/2018
Descricao / Objetivo: Manutenção nas tabelas de preços IMCD
====================================================================================
*/

User Function mTabImcd()

Local aMensagem := {}
Local aBotoes   := {}
Local bSair     := .T.
Local oButton1
Local oRadMenu1
Local oSay1
Static oDlg

Private cTitulo  := "Manutenção de tabelas IMCD Brasil"
Private nEscolha := 1
Private oProcess

Aadd( aMensagem, OemToAnsi("Este programa tem como objetivo executar manutenção nas tabelas de preço IMCD"))
Aadd( aMensagem, OemToAnsi("    "))
Aadd( aMensagem, OemToAnsi("Em caso de Importação o arquivo deverá ser separado por ponto e virgulas(.CSV) e a primeira linha conterá os campos"))
Aadd( aMensagem, OemToAnsi("    "))
AAdd( aMensagem, OemToAnsi("Em caso de Atualização conforme SB1 sera atualizado o Valor e moeda de Custo B1_CUSTD e B1_MCUSTD na tabela de preço"))
AAdd( aBotoes, { 19, .T., { || FechaBatch(), bSair     := .F. } } )
AAdd( aBotoes, { 02, .T., { || FechaBatch(), bSair     := .T. } } )
FormBatch( cTitulo, aMensagem, aBotoes, , 260,700  )
IF !bSair
	
	
	DEFINE MSDIALOG oDlg TITLE "Manutenção das tabelas de PREÇO e MOEDA Imcd Brasil." FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL
	
	@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Atualizar Tabela - SB1","Atualizar Tabela - CSV","Importar Tabela NOVA","Alteração de Custo - Cadastro de Produto" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
	@ 006, 006 SAY oSay1 PROMPT "Selecione a opção desejada:" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
	oButton1 := TButton():New( 104, 141 ,'Iniciar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Executando...', .F. ),oDlg:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
ENDIF

Return()

***********************************************************************************************************************
Static Function ImpSal_Exec()
Local cArq	    := ""
Local cLinha    := ''
Local lPrim     := .T.
Local aCampos   := {}
Local aDados    := {}
Local nCampos   := 0
Local aExecAuto := {}
Local aTipoImp  := {}
Local cTipo     := ''
Local cTab      := ''
Local aMensagem :={}
Local aCab      := {}
Local aItem     := {}
Local nI        := 0
Local aSX3 	    :={}
Local nX        := 0
Private lMsErroAuto    := .F.

If nEscolha == 1
	Prc001()   // PROGRAMA DE ATUALIZAÇÃO DA TABELA CONFORME CADASTRO DE PRODUTO
	Return()
	
Elseif  nEscolha == 4
	AltProd_Exec()  //PROGRAMA PARA ATUALIZAÇÃO DO CADASTRO DE PRODUTO
	Return()
	
Else
	
	AAdd( aMensagem, OemToAnsi("Para atualizar tabela conforme cadastro de Produto - B1_CUSTD  | B1_MCUSTD "))
	AAdd( aMensagem, OemToAnsi("Para atualizar tabela de preços conforme arquivo .CSV"))
	AAdd( aMensagem, OemToAnsi("Para Importa tabela NOVA conforme arquivo .CSV"))
	AAdd( aMensagem, OemToAnsi("Para Atualizar Custo de Cadastro de Produto conforme arquivo .CSV"))
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
	
	IF !(cTIPO $('DA0'))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
		Return
	ENDIF
	
aSX3 := FWSX3Util():GetAllFields(cTIPO,.F. )

For nI := 1 To Len(aSX3)
	for nX := 1 to Len(aTipoImp)
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
	
	cTab := ''
	
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
	aItem := {}
	
	ProcRegua(Len(aDados))
	
	For nI:=1 to  Len(aDados)
		
		IncProc("Importando arquivo...")
		
		aExecAuto :={}
		For nCampos := 1 To Len(aCampos)
			
			IF SUBSTR(Upper(aCampos[nCampos]),1,3)=='DA1'
				If SUBSTR(Upper(aCampos[nCampos]),1,8)=='DA1_ITEM' .and. nEscolha == 2
					aAdd(aExecAuto ,{"LINPOS",aCampos[nCampos], aDados[nI,nCampos]})
					aAdd(aExecAuto ,{"AUTDELETA","N",Nil})
				ElseIF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
				ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
				ELSE
					aAdd(aExecAuto ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
				ENDIF
			EndIF
		Next nCampos
		
		For nCampos := 1 To Len(aCampos)
			IF SUBSTR(Upper(aCampos[nCampos]),1,3)='DA0'
				IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	VAL(aDados[nI,nCampos] )	,Nil})
				ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
					aAdd(aCab ,{Upper(aCampos[nCampos]),  CTOD(aDados[nI,nCampos] )	,Nil})
				ELSE
					aAdd(aCab ,{Upper(aCampos[nCampos]), 	aDados[nI,nCampos] 	,Nil})
				ENDIF
			EndIF
		Next nCampos
		aAdd(aItem,aExecAuto)
		
		
		IF nI == Len(aDados)
			lMsErroAuto := .F.
			Begin Transaction
			
			If nEscolha == 2
				MSExecAuto({|x,y,z| Omsa010(x,y,z)},aCab,aItem,4)    //alterar tabela
			ElseIf nEscolha == 3
				MSExecAuto({|x,y,z| Omsa010(x,y,z)},aCab,aItem,3)    //inclui tabela
			Endif
			
			If lMsErroAuto
				DisarmTransaction()
				MostraErro()
			EndIF
			
			End Transaction
			
		EndIF
		
		aCab      := {}
		
	Next nI
	
Endif

ApMsgInfo("Processo realizado com sucesso!","SUCESSO")

Return()

//PROGRAMA PARA ATUALIZAÇÃO DA TABELA DE PREÇO
Static Function Prc001()

Local cQuery := ""
Local cEmpAnt 

cQuery := "  SELECT DA1_CODTAB, DA1_CODPRO,DA1_ITEM, DA1_MOEDA,DA1_CUSTD, B1_CUSTD, B1_COD,B1_MCUSTD "
cQuery += "  FROM "+RETSQLNAME('DA1')+" DA1 "
cQuery += "  INNER JOIN "+RETSQLNAME('SB1')+" SB1 "
cQuery += "  ON B1_COD = DA1_CODPRO "
cQuery += "  AND SB1.D_E_L_E_T_ <> '*' "
cQuery += "  WHERE DA1.D_E_L_E_T_ <> '*' "
IF cEmpAnt == "01"
	cQuery += "  AND DA1_CODTAB >= '100' "
ENDIF
cQuery += "  ORDER BY DA1_CODTAB,DA1_ITEM " 


If ( SELECT("TSZO1") ) > 0
	dbSelectArea("TSZO1")
	TSZO1->(dbCloseArea())
EndIf
TcQuery cQuery Alias TSZO1 new

While !(TSZO1->(EOF()))
	dbselectarea("DA1")
	dbsetorder(2)
	dbgotop()
	IF dbseek(xfilial("DA1")+ TSZO1->DA1_CODPRO + TSZO1->DA1_CODTAB + TSZO1->DA1_ITEM )
		RECLOCK("DA1",.F.)
		DA1->DA1_MOEDA := Val(TSZO1->B1_MCUSTD)
		DA1->DA1_CUSTD := TSZO1->B1_CUSTD
		if DA1->DA1_MIDEAL > 0
			DA1->DA1_PRCVEN := ROUND( TSZO1->B1_CUSTD / (1-( DA1->DA1_MIDEAL / 100)) ,TamSX3("DA1_PRCVEN")[2] )
		endif
		if DA1->DA1_MMIN > 0
			DA1->DA1_PRCMIN := ROUND( TSZO1->B1_CUSTD / (1-( DA1->DA1_MMIN / 100)) ,TamSX3("DA1_PRCMIN")[2] )
		endif
		MSUNLOCK()
	ENDIF
	TSZO1->(dbSkip())
	IncProc("Tabela -> "+TSZO1->DA1_CODTAB+" - Produto " + TSZO1->DA1_CODPRO )
Enddo

ApMsgInfo("Processo realizado com sucesso!","SUCESSO")

Return()


//ATUALIZAÇÃO DO CADASTRO DE PRODUTO
//-----------------------------------------------------------------------------------------------------------------------------------

Static Function AltProd_Exec()
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

AAdd( aMensagem, OemToAnsi("Para atualizar tabela conforme cadastro de Produto - B1_CUSTD  | B1_MCUSTD "))
AAdd( aMensagem, OemToAnsi("Para atualizar tabela de preços conforme arquivo .CSV"))
AAdd( aMensagem, OemToAnsi("Para Importa tabela NOVA conforme arquivo .CSV"))
AAdd( aMensagem, OemToAnsi("Para Atualizar Custo de Cadastro de Produto conforme arquivo .CSV"))
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

IF !(cTIPO $('B1'))
	MsgAlert('Não é possivel importar arquivo do tipo: '+cTipo+ '  !!')
	Return
ENDIF

dbSelectArea("SX3")
DbSetOrder(2)
For nI := 1 To Len(aTipoImp)
	IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .And. cTipo <> 'B1'
		MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
		Return
	ENDIF
	IF !SX3->(dbSeek(Alltrim(aTipoImp[nI])))
		MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
		Return
	ENDIF
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
	IncProc("Atualizando arquivo...")
	dbSelectArea("SB1")
	dbSetOrder(1)
	iF MsSeek(xFilial("SB1")+aDados[nI,1])
		IF nEscolha <> 8
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
				MSExecAuto({|x,y| MATA010(x,y)},aExecAuto,4) //alteração
			ENDIF
			
			If lMsErroAuto
				MsgAlert("Erro no Produto "+aDados[nI,1]+" , Verificar o cadastro do mesmo!","IMCD")
				DisarmTransaction()
				//MostraErro()
				cFilAnt := cBKFilial
				//Return
			EndIF
			End Transaction
		EndIF
		
	Endif
Next nI

msgAlert('Atualização realizada com sucesso !!')


FT_FUSE()

cFilAnt := cBKFilial

Return
