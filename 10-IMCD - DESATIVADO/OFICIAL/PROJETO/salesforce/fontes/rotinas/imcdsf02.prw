#INCLUDE "Protheus.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} IMCDSF02
	Importar um arquivo csv para atualizar ou Incluir novos registro na Tabela ZA0 - Principal
	@type  User
	@author Junior Carvalho
	@since 06/01/2021
	@version 1.00
	@param 
	@return 
	@example - Arquivo CSV

	ZA0_CODPRI	,ZA0_NAME				,ZA0_OWNER		,ZA0_STREET	,ZA0_CITY	,ZA0_COUNTR	,ZA0_MSBLQL
	999999	    ,GLOBAL PRINCIPAL BRAZIL,Marco Arasaki	,			,			,			,2

	/*/

User Function IMCDSF02()

	Local nConfirm:= 0

	Local oDlg
	Local oSay1,oSay2,oSay3
	Local oGet1
	Local oBtnCon,oBtnCan
	Local cF3 := "DIR"

	Private cArq := SPACE(100)
	Private cTitulo  := "Importação de Cadastro - Principal"
	Private nEscolha := 1

	oDlg:= MSDialog():New( 0,0,200,350, cTitulo ,,,.F.,,,,,,.T.,,,.T. )

	oSay1:= TSay():New( 005,005,{||"Para atualizar o Cadastro do Principal,"},,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,015)
	oSay2:= TSay():New( 020,005,{||"O Cabeçalho do arquivo dever conter os campos abaixo:"},,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,015)
	oSay3:= TSay():New( 035,005,{||"ZA0_CODPRI, ZA0_NAME, ZA0_OWNER, ZA0_STREET, ZA0_CITY, ZA0_COUNTR, ZA0_MSBLQL"},,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,015)
	oSay4:= TSay():New( 055,005,{||"Selecione o Arquivo tipo CSV"},,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,180,010)
	oGet1:= TGet():New( 065,005,{ | u | If( PCount() == 0, cArq, cArq := alltrim(u) ) },oDlg,160,10,"@!", ,,,, .F.,, .T.,, .F., , .F., .F.,, .F., .F. ,cF3,cArq)
	oBtnCon:= TButton():New( 080,070,"Confirmar",oDlg,{|| nConfirm:= 1, oDlg:End()},035,012,,,,.T.,,"",,,,.F. )
	oBtnCan:= TButton():New( 080,110,"Cancelar" ,oDlg,{|| nConfirm:= 0, oDlg:End()},035,012,,,,.T.,,"",,,,.F. )
	oDlg:lCentered := .T.
	oDlg:Activate()

	if 	!Empty(cArq ) .and. nConfirm == 1
		Processa( {|| Exec_Arq() }, "Aguarde...", "Atualizando Registro..."+cTitulo,.F.)
	EndIF

Return()

	***********************************************************************************************************************
Static Function Exec_Arq()

	Local cLinha    := ''
	Local aCampos   := {}
	Local aDados    := {}
	Local cBKFilial := cFilAnt
	Local nCampos   := 0
	Local aExecAuto := {}
	Local aTipoImp  := {}
	Local cTipo     := ''
	Local nI        := 0
	local lContinua := .T.
	Private lMsErroAuto    := .F.

	If !File(cArq)
		MsgStop("O arquivo " +cArq + " não foi encontrado. A importação será abortada!","ATENCAO")
		Return
	EndIf

	FT_FUSE(cArq)
	FT_FGOTOP()
	cLinha    := FT_FREADLN()
	aTipoImp  := Separa(cLinha,";",.T.)
	cTipo     := SUBSTR(aTipoImp[1],1,3)

	IF !(cTIPO $('ZA0'))
		MsgAlert('Não é possivel importar arquivo do tipo: '+cTipo+ '  !!')
		Return
	ENDIF

	dbSelectArea("SX3")
	DbSetOrder(2)
	For nI := 1 To Len(aTipoImp)
		IF cTipo <> SUBSTR(aTipoImp[nI],1,2) .And. cTipo <> 'ZA0'
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
	FT_FSKIP()
	IncProc("Lendo arquivo texto...")
	IncProc("Validando Arquivo")
	While !FT_FEOF()
		cLinha := FT_FREADLN()

		AADD(aDados,Separa(cLinha,";",.T.))

		FT_FSKIP()
	EndDo

	nI := 1
	aCampos := aTipoImp

	ProcRegua(Len(aDados))

	IncProc("Atualizando Registros...")

	while  nI <= Len(aDados) .and. lContinua

		dbSelectArea("ZA0")
		dbSetOrder(1)
		iF !(MsSeek(xFilial("ZA0")+aDados[nI,2]))

			aExecAuto := {}
			For nCampos := 1 To Len(aCampos)
				IF  SUBSTR(Upper(aCampos[nCampos]),5,6)=='FILIAL'
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

				IF cTipo == 'ZA0'

					nPos :=  aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_CODPRI" } )

					if nPos > 0
						cCod := aExecAuto[nPos,2]
						cName := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_NAME" } ) ,2]
						cOwner := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_OWNER" } ) ,2]
						cBlq := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_MSBLQL" } ) ,2]
						cCity := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_CITY" } ) ,2]
						cStreet := aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_STREET" } ) ,2]
						cCountry:= aExecAuto[aScan( aExecAuto, { |x| AllTrim( x[1] ) == "ZA0_COUNTR" } ) ,2]

						dbSelectArea("ZA0")
						dbSetOrder(1)
						lRet := !(MsSeek(xFilial("ZA0")+ cCod ))

						Reclock("ZA0", lRet )

						ZA0->ZA0_CODPRI	:=   cCod
						ZA0->ZA0_NAME	:=   cName
						ZA0->ZA0_OWNER    := iif(empty(cOwner), " ", cOwner )
						ZA0->ZA0_MSBLQL   := iif(Alltrim(cBlq) =='Active', '2', '1')
						ZA0->ZA0_CITY     := iif(empty(cCity), " ", cCity )
						ZA0->ZA0_STREET   := iif(empty(cStreet), " ", cStreet )
						ZA0->ZA0_COUNTR   := iif(empty(cCountry), " ", cCountry )


						msUnlock()

					Endif
				Endif

				If lMsErroAuto
					DisarmTransaction()
					MostraErro()
					cFilAnt := cBKFilial
					lContinua := .F.
				EndIF
			End Transaction


		Endif
		nI++
	enddo

	msgAlert('Atualização realizada com sucesso !!')


	FT_FUSE()

	cFilAnt := cBKFilial

Return
