#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"

/*
===================================================================================
Programa............: ATUCADBASE
Autor...............: Junior Carvalho
Data................: 06/10/2020
Descricao / Objetivo: Atualizar Cadastro de Clientes
====================================================================================
*/

User Function INDENTCAD()

	Local aMensagem := {}
	Local aBotoes   := {}
	Local bSair     := .T.
	Local oButton1
	Local oRadMenu1
	Local oSay1
	Local lRet := .T.
	Static oDlg
	DEFAULT __cUserId := '000390'
	Private cTitulo  := "Atualização de Cadastros Básicos"
	Private nEscolha := 1

	RpcSetType ( 3 )
	PREPARE ENVIRONMENT EMPRESA '02' FILIAL '01' MODULO "COM"
	__cUserId := '000390'
	iF !(__cUserId $ '000000|000390|000315')
		MsgStop("função bloqueada contate o ADM","ATENCAO")
		lRet := .F.
	endif

	IF lRet

		Aadd( aMensagem, OemToAnsi("Este programa tem como objetivo Atualizar os cadastros padrões através de arquivos textos "))
		Aadd( aMensagem, OemToAnsi("    "))
		Aadd( aMensagem, OemToAnsi("O arquivo texto deverá ser separado por |  "))
		Aadd( aMensagem, OemToAnsi("A primeira linha conterá os  nomes dos campos a serem Atualizados"))
		Aadd( aMensagem, OemToAnsi("    "))
		Aadd( aMensagem, OemToAnsi("    "))
		AAdd( aBotoes, { 19, .T., { || FechaBatch(), bSair     := .F. } } )
		AAdd( aBotoes, { 02, .T., { || FechaBatch(), bSair     := .T. } } )
		FormBatch( cTitulo, aMensagem, aBotoes, , 260,700  )
		IF !bSair

			DEFINE MSDIALOG oDlg TITLE "Atualização de Cadastros" FROM 000, 000  TO 250, 400 COLORS 0, 16777215 PIXEL

			@ 020, 006 RADIO oRadMenu1 VAR nEscolha ITEMS "Produtos","Fornecedor","Clientes" SIZE 159, 130 OF oDlg COLOR 0, 16777215 PIXEL
			@ 006, 006 SAY oSay1 PROMPT "Selecione o cadastro :" SIZE 091, 007 OF oDlg COLORS 0, 16777215 PIXEL
			oButton1 := TButton():New( 104, 141 ,'Atualizar', oDlg,{|| Processa( { || ImpSal_Exec() }, cTitulo , 'Importando...', .F. ),oDLG:end() } ,50, 011,,,.F.,.T.,.F.,,.F.,,,.F. )

			ACTIVATE MSDIALOG oDlg CENTERED

		ENDIF

	ENDIF


	RESET ENVIRONMENT

Return
	***********************************************************************************************************************
Static Function ImpSal_Exec()
	Local cArq	    := ""
	Local cLinha    := ''
	Local aCampos   := {}
	Local aDados    := {}
	Local cBKFilial := cFilAnt
	Local nCampos   := 0
	Local aExecAuto := {}
	Local aTipoImp  := {}

	Local cTipo     := ''

	Local aMensagem :={}
	Local nI        := 0
	Local aSX3 	    :={}
	Local nX        := 0
	Local cFiltro	:= ""
	Private lMsErroAuto    := .F.
	Private aTabExclui     := { {'B1',{"SB1"}} ,{'A2',{"SA2"} },{'A1',{"SA1"} } }

	AAdd( aMensagem, OemToAnsi("Para Atualizar a tabela de Produto, o arquivo deverá conter campos da SB1"))
	AAdd( aMensagem, OemToAnsi("Para Atualizar a tabela de Fornecedor o arquivo deverá conter campos da SA2"))
	AAdd( aMensagem, OemToAnsi("Para Atualizar a tabela de Clientes, o arquivo deverá conter campos da SA1"))
	MsgAlert(aMensagem[nEscolha])

	cArq := 	cGetFile("*.CSV|*.CSV",  "Selecione o Arquivo" , 0, "SERVIDOR\", .F.,  GETF_LOCALHARD + GETF_NETWORKDRIVE ,.T.)

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf
	ofT			:= fT():New()
	//	FT_FUSE(cArq)
	//FT_FGOTOP()
	//cLinha    := FT_FREADLN()

	IF ( ofT:ft_fUse( cArq ) <= 0 )
		ofT:ft_fUse()
		BREAK
	EndIF
	cLinha 		:= ofT:ft_fReadLn()

	cLinha		:= StrTran(cLinha,'"', "" )
	aTipoImp 	:= Separa(cLinha,'|',.T.)
	cTipo		:= SUBSTR(aTipoImp[1],1,2)

	ofT:ft_fSkip()

	IF !(cTIPO $('B1 A1 A2 '))
		MsgAlert('Não é possivel importar a tabela: '+cTipo+ '  !!')
		Return
	ENDIF

	IF  (cTIPO=='B1'.And. nEscolha== 1)
		cFiltro := "B1_FILIAL|B1_FAM|B1_COD|B1_TIPO|B1_X_PRINC|B1_GRUPO|B1_NACION|B1_EMB|B1_DESC|B1_POSIPI|B1_USPRE"
		cFiltro += "|B1_UM|B1_LOCPAD|B1_LOTEMUL|B1_ESPECIF|B1_XINDENT|B1_PESO|B1_LOCALIZ"

	ELSEIF	(cTIPO=='A2'.And. nEscolha==2)

		cFiltro := "A2_FILIAL|A2_COD|A2_LOJA|A2_PESSOA|A2_NOME|A2_NREDUZ|A2_END|A2_TIPO|A2_EST|A2_COD_MUN|A2_MUN"
		cFiltro += "|A2_BAIRRO|A2_NATUREZ|A2_CEP|A2_DDI|A2_DDD|A2_TEL|A2_ENDCOB|A2_PAIS|A2_VEND|A2_CONTA|A2_COND"
		cFiltro += "|A2_RISCO|A2_EMAIL|A2_XINDENT|A2_INSCR|A2_CODPAIS|A2_PAIS"

	ELSEIF (cTIPO=='A1'.And. nEscolha==3)

		cFiltro := "A1_FILIAL|A1_COD|A1_LOJA|A1_PESSOA|A1_NOME|A1_NREDUZ|A1_END|A1_TIPO|A1_EST|A1_COD_MUN|A1_MUN"
		cFiltro += "|A1_BAIRRO|A1_NATUREZ|A1_CEP|A1_DDI|A1_DDD|A1_TEL|A1_ENDCOB|A1_PAIS|A1_VEND|A1_CONTA|A1_COND"
		cFiltro += "|A1_RISCO|A1_EMAIL|A1_XINDENT|A1_INSCR|A1_CODPAIS|A1_PAIS"

	ELSE
		MsgAlert('Escolha é diferente do Arquivo Texto '+cTipo+ '  !!')
		Return()
	ENDIF

	cNewTipo := "S"+cTipo

	aSX3 := FWSX3Util():GetAllFields(cNewTipo,.F. )

	For nI := 1 To Len(aSX3)
		for nX := 1 to Len(aTipoImp)
			//IF Alltrim(Upper(aTipoImp[nX])) $ cFiltro
				IF cTipo <> SUBSTR(aTipoImp[nX],1,2)
					MsgAlert('Todos os campos devem pertencer a mesma tabela !!')
					Return
				ENDIF
				if Ascan(aSx3, aTipoImp[nX]) == 0
					MsgAlert('Campo não encontrado na tabela :'+aTipoImp[nI]+' !!')
					Return
				Endif
			//ENDIF
		next nX
	Next nI

	While !( ofT:ft_fEof() )

		cLinha 		:= ofT:ft_fReadLn()
		cLinha := StrTran(cLinha,'"', "" )

		IncProc("Lendo arquivo texto...")
		IF !( ofT:ft_fRecno() == 1 )
			AADD(aDados,Separa(cLinha,"|",.T.))
		EndIf
		ofT:ft_fSkip()
	EndDo
	cErro := ""
	aCampos := aTipoImp
	ProcRegua(Len(aDados))
	For nI:=1 to  Len(aDados)
		IF nEscolha <> 8
			aExecAuto := {}
			IncProc("Importando arquivo...")
			For nCampos := 1 To Len(aCampos)
				if Alltrim(Upper(aCampos[nCampos])) $ cFiltro

					IF  SUBSTR(Upper(aCampos[nCampos]),4,6)=='FILIAL'
						IF !EMpty(aDados[nI,nCampos])
							cFilAnt := aDados[nI,nCampos]
						ENDIF
					Else
						IF  TamSx3(Upper(aCampos[nCampos]))[3] =='N'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), VAL(aDados[nI,nCampos] )	,Nil})
						ELSEIF TamSx3(Upper(aCampos[nCampos]))[3] =='D'
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]),  STOD(aDados[nI,nCampos] )	,Nil})
						ELSE
							aAdd(aExecAuto ,{Upper(aCampos[nCampos]), NoAcento(aDados[nI,nCampos]) 	,Nil})
						ENDIF

					ENDIF
				endif

			Next nCampos
			lMsErroAuto := .F.
			Begin Transaction
				IF cTipo == 'B1'       // Produto
					cCod := PADR(aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_COD" } ) ,2],15)

					nINDENT := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_XINDENT" } ) ,2]

					cCod := iif(trim(cCod) =='NOVO', nINDENT, cCod)

					dbSelectArea("SB1")

					DBOrderNickname("SB1XINDENT")
					iF !(MsSeek(nINDENT) )

						dbSetOrder(1)
						iF MsSeek(xFilial("SB1")+ cCod )
							Reclock("SB1",.F.)
							SB1->B1_XINDENT := nINDENT
							msUnlock()
						else
							CADSB1(cCod, aExecAuto)
						Endif
					Endif
				ELSEIF cTipo == 'A2'   // Fornecedor
					cCod := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_COD" } ) ,2]
					cCod += aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A2_LOJA" } ) ,2]
					dbSelectArea("SA2")
					dbSetOrder(1)
					iF MsSeek(xFilial("SA2")+ cCod )
						MSExecAuto({|x,y| MATA020(x,y)},aExecAuto,4)// 3 - INCLUI /  4 - Alteração
					ELSE
						CADSA2(cCod,aExecAuto)
					ENDIF

				ELSEIF cTipo == 'A1'   //Cliente

					cCod := PADR(aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_COD" } ) ,2],6)
					cCod += PADR(aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_LOJA" } ) ,2],2)
					nINDENT := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "A1_XINDENT" } ) ,2]
					cCod := iif(Empty(cCod)," ", cCod)

					dbSelectArea("SA1")

					DBOrderNickname("SA1XINDENT")
					iF !(MsSeek(nINDENT) .AND. nINDENT > 0)

						dbSetOrder(1)
						iF dbseek(xFilial("SA1")+ cCod,.t. )
							Reclock("SA1",.F.)
							SA1->A1_XINDENT := nINDENT
							msUnlock()
						else
							ajustaSA1(@aExecAuto)

							MSExecAuto({|x,y| MATA030(x,y)},aExecAuto,3) // 3 - INCLUI /  4 - Alteração
						Endif
					Endif

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


	ofT:ft_fUse()

	cFilAnt := cBKFilial

Return

STATIC FUNCTION CADSB1(cCod, aExecAuto)
	Local nX := 0
	lRet := .T.
	nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "B1_COD" } )

	iF MsSeek(xFilial("SB1")+ cCod )

	else
		Reclock("SB1",.T.)
		SB1->B1_COD := cCod
		SB1->B1_MSBLQL := '1'
		SB1->B1_X_PRL := 'INDENT'

		For nX:= 1 To Len(aExecAuto)
			if nX <> nPos
				if !Empty(aExecAuto[nX][2])

					cCampo  := "SB1->"+aExecAuto[nX][1]
					&cCampo := 	aExecAuto[nX][2]

				endif
			endif

		Next nX
		msUnlock()
	endif

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
	cString := StrTran( cString, ";", " " )
	cString := StrTran( cString, CRLF, " " )
Return cString



STATIC FUNCTION ajustaSA1(aExecAuto)
	Local nX := 0


	For nX:= 1 To Len(aExecAuto)

		if aExecAuto[nX,1] == 'A1_COD'
			aExecAuto[nX,2]  := GetSxeNum("SA1","A1_COD")
		elseif aExecAuto[nX,1] == 'A1_LOJA'
			aExecAuto[nX,2]  := 'ID'
		elseif aExecAuto[nX,1] == 'A1_NATUREZ'
			aExecAuto[nX,2]  := '111001'
		elseif aExecAuto[nX,1] == 'A1_DDI'
			aExecAuto[nX,2]  := '55'
		elseif aExecAuto[nX,1] =='A1_VEND'
			aExecAuto[nX,2]  := '000003'
		elseif aExecAuto[nX,1] == 'A1_CONTA'
			aExecAuto[nX,2]  := '113010001'
		elseif aExecAuto[nX,1] == 'A1_COND'
			aExecAuto[nX,2]  := '001'
		elseif aExecAuto[nX,1] == 'A1_TIPO'
			aExecAuto[nX,2]  := 'X'
		elseif aExecAuto[nX,1] == 'A1_BAIRRO'
			(aExecAuto[nX,2]) := iif(empty(aExecAuto[nX,2]),'INDEFINIDO',aExecAuto[nX,2])

		elseif aExecAuto[nX,1] == 'A1_DDD'
			(aExecAuto[nX,2]) := iif(empty(aExecAuto[nX,2]),'00',aExecAuto[nX,2])
		elseif aExecAuto[nX,1] == 'A1_CODPAIS'
			(aExecAuto[nX,2]) := '05738'

		elseif aExecAuto[nX,1] == 'A1_PAIS'
			(aExecAuto[nX,2]) := iif(empty(aExecAuto[nX,2]),'994',aExecAuto[nX,2])

		elseif aExecAuto[nX,1] == 'A1_INSCR'
			(aExecAuto[nX,2]) := iif(empty(aExecAuto[nX,2]),'ISENTO',aExecAuto[nX,2])
		endif

	next

aAdd(aExecAuto ,{"A1_XINTERC", "N" ,Nil})

RETURN()
