#Include "Protheus.ch"
#Include "FileIO.ch"
#Include "TBICONN.CH"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCSGNRE02  บAutor  ณ Prox               บ Data ณ  24/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Gera็ใo dos tํtulos a pagar com origem o Arquivo บฑฑ
ฑฑบ          ณ de retorno disponibilizado pelo Site GNRE Online.          บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CSGnre02()

Local cArqRet       := ""
Local nOpcaoIni     := 0
Local aSays         := {}
Local aButtons      := {}
Local oDlgGnre02    := Nil

Private cPathLog    := "\GNRE_LOG"
Private aTituloSE2  := {}
Private lControlLog := .F.

AADD(aSays,OemToAnsi( "Importa็ใo do Arquivo de Retorno GNRE" ))
AADD(aSays,OemToAnsi( "Esta rotina tem como objetivo processar a importa็ใo do Arquivo"))
AADD(aSays,OemToAnsi( "de Contas a Pagar (Tํtulos GNRE) "))

AADD(aButtons, { 014,.T.,{|oDlgGnre02| cArqRet := cGetFile("Arquivos Texto|*.TXT|","GNRE - Selecione o arquivo que serแ importado",0,,.T.,GETF_LOCALHARD+GETF_NETWORKDRIVE) } } )
AADD(aButtons, { 001,.T.,{|oDlgGnre02| nOpcaoIni:=1,oDlgGnre02:oWnd:End() } } )
AADD(aButtons, { 002,.T.,{|oDlgGnre02| oDlgGnre02:oWnd:End() }} )

FormBatch( "Titulos - GNRE", aSays, aButtons,,240,425 )

If nOpcaoIni == 1    

	If File(cArqRet)
		//-->> Faz a leitura do arquivo de retorno
		Processa({|| LerArqRet(@cArqRet),"Aguarde ... Lendo arquivo...."})
		//-->> Executa a inclusใo dos tํtulos
		If Len(aTituloSE2) > 0

			Processa({|| GeraTitulo(@cArqRet), "Aguarde .... Gerando tํtulos !!!"})

		Else
	    	//-->> Nใo contem dados no arquivo
			MsgAlert("Arquivo nใo contem informa็๕es de GNRE, por favor, verificar !!!","Atencao")

		EndIf

	Else

		MsgAlert("Arquivo nใo Selecionado !!!","Atencao")

	EndIf

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLerArqRet บAutor  ณProx                บ Data ณ  24/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a leitura no Arquivo de Retorno e carrega no Array     บฑฑ
ฑฑบ          ณ utilizado na rotina automatica.                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LerArqRet(cArqRet)

Local cBuffer    := ""
Local nHandle    := FT_FUSE(cArqRet)
Local nProcRegua := 0
Local nLinhas    := 0
Local cTipo      := GetNewPar("MV_XTPOGNR","GNR")
Local cNaturez   := GetNewPar("MV_XNATGNR","SF420010")
Local cCodFor    := ""
Local cLojaFor   := ""
Local cUFGNRE    := ""
Local cDtEmis    := ""
Local cDtVencto  := ""
// Posiciona no inํcio do arquivo
FT_FGOTOP()
// Verifica a quantidade de registros no arquivo
nProcRegua := FT_FLASTREC()
// Posiciona no inํcio do arquivo
FT_FGOTOP()
ProcRegua(nProcRegua)

While !FT_FEOF()

	nLinhas++
	cBuffer := LeLinhaArq() //-->> Devido o arquivo ser maior que 1024 bytes.

	If !Empty(cBuffer)
		// No retorno esta o tratamento para transformar todas a letras em Maiuscula.
		cBuffer := Upper(cBuffer)
		//-->> Processo apenas registros com identificador 1 (Registro de Guia)
		If Left(cBuffer,01) == "1"
            //-->> Tratamento para buscar o Fornecedor Correto.
			cUFGNRE  := SubStr(cBuffer,007,002)
			cCodFor  := SubStr(GetNewPar("MV_RECST"+cUFGNRE,""),01,06)
			cLojaFor := SubStr(GetNewPar("MV_RECST"+cUFGNRE,""),08,02)
			//-->> Faz o acerto da Data para AAAAMMDD
			cDtEmis  := SubStr(cBuffer,897,004)+SubStr(cBuffer,895,002)+SubStr(cBuffer,893,002)
			cDtVencto:= SubStr(cBuffer,905,004)+SubStr(cBuffer,903,002)+SubStr(cBuffer,901,002)

			AADD(aTituloSE2,{{"E2_PREFIXO", "GNR"                            , Nil},;
			                 {"E2_NUM"    , SubStr(cBuffer,554,009)          , Nil},;
							 {"E2_TIPO"   , cTipo                            , Nil},;
							 {"E2_FORNECE", cCodFor                          , Nil},;
							 {"E2_LOJA"   , cLojaFor                         , Nil},;
							 {"E2_NATUREZ", cNaturez                         , Nil},;
							 {"E2_EMISSAO", dDataBase                        , Nil},;
							 {"E2_VENCTO" , SToD(cDtVencto)                  , Nil},;
							 {"E2_VENCREA", SToD(cDtVencto)                  , Nil},;
							 {"E2_VALOR"  , Val(SubStr(cBuffer,919,015))/100 , Nil},;
							 {"E2_XGNRE01", SubStr(cBuffer,009,006)          , Nil},;
							 {"E2_XUFGNRE", cUFGNRE                          , Nil},;
							 {"E2_CODBAR" , SubStr(cBuffer,1027,044)         , Nil};
							})

		EndIf

	EndIf
	
	FT_FSKIP(1)
	IncProc("Lendo Arquivo: " + cBuffer)
	
EndDo

FT_FUSE()
FClose(nHandle)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraTituloบAutor  ณ Prox               บ Data ณ  24/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Faz a execu็ใo da rotina automatica para gera็ใo dos       บฑฑ
ฑฑบ          ณ titulos e atualiza a Tabela de Guia (SF6).                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraTitulo(cArqRet)

Local nX         := 01
Local nY         := 01
Local nOpc       := 03 // Inclusao
Local aTitulo    := {}
Local lContProc  := .T.
Local aLogMsAuto := {}

Private cArqRetorno    := Upper(SubStr(cArqRet,RAT("\",cArqRet)+01,Len(AllTrim(cArqRet))))
Private cArqRetLog     := cPathLog+"\"+SubStr(cArqRetorno,01,RAT(".",cArqRetorno)-01)+DToS(Date())+cValToChar(Int((Seconds())))+".LOG"
Private lMsErroAuto    := .F.
Private lMsHelpAuto    := .T.
Private lAutoErrNoFile := .T.
//-->> Tabelas utilizadas no processo de atualiza็ใo da Guia
DbSelectArea("SA2")
DbSetOrder(01) //-->> A2_FILIAL, A2_COD, A2_LOJA

DbSelectArea("SF6")
//SF6->(DbSetOrder(01)) //-->> F6_FILIAL, F6_EST, F6_NUMERO
//-->> Prox - 20160510
SF6->(DbOrderNickName("GNRE")) //-->> F6_FILIAL, F6_EST, F6_DOC
//-->> Faz o Loop nos tํtulos carregados para executar a rotina automแtica
For nX := 01 To Len(aTituloSE2)

	lContProc := .T.
	aTitulo   := aTituloSE2[nX]
	//-->> Valid็๕es antes do ExecAuto, definido processado anteriormente, Campos F6_XPROCES e F6_XARQNGR
	//-->> Acha o Fornecedor para verifcar o estado que foi gerado
	If SA2->(DbSeek(xFilial("SA2")+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_FORNECE"}),02]+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_LOJA"}),02]))
		//-->> Verifica Flag's na SF6
		If SF6->(DbSeek(xFilial("SF6")+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_XUFGNRE"}),02]+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_NUM"}),02]))

			If AllTrim(SF6->F6_XARQGNR) == cArqRetorno .And. SF6->F6_XPROCES == "1"
				//-->> Entrou pois foi processado anteriormente.
				//-->> Gravar Log de registro processado anteriormente.
				lContProc  := .F.
				LogControl("Titulo Duplicado : "+AllTrim(SF6->F6_NUMERO)+" UF: "+ SF6->F6_EST)

			EndIf

		Else
			//-->> Gravar Log de Guia nao encontrada.
			lContProc  := .F.
			LogControl("Guia nao Encontrada : "+AllTrim(aTitulo[aScan(aTitulo,{|x| x[1] == "E2_NUM"}),02])+" UF: "+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_XUFGNRE"}),02])

		EndIf

	Else
		//-->> Gravar Log de Fornecedor nao encontrado.
		lContProc  := .F.
		LogControl("Fornecedor nao encontrado : "+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_FORNECE"}),02]+aTitulo[aScan(aTitulo,{|x| x[1] == "E2_LOJA"}),02])

	EndIf

	If lContProc

		Begin Transaction

			MSExecAuto({|x,y,z| FINA050(x,y,z)},aTitulo,,nOpc)    

			If lMsErroAuto

				aLogMsAuto := GetAutoGRLog()
				For nY := 01 To Len(aLogMsAuto)

					LogControl(aLogMsAuto[nY])

				Next
				DisarmTransaction()

			Else

				RecLock("SF6",.F.)

					SF6->F6_XPROCES := "1"
					SF6->F6_XARQGNR := cArqRetorno
					SF6->F6_XFORNEC := SE2->E2_FORNECE
					SF6->F6_XLOJA   := SE2->E2_LOJA

				SF6->(MsUnLock())

			EndIf
		
		End Transaction

	EndIf

Next
//-->> Caso ocorreu erro no processamento gravo o arquivo de log
If lControlLog

	MsgAlert("Por favor, verificar LOG - Erros encontrados no processo de Importa็ใo !! ","Atencao - Erros Encontrados")
	RelGnre02()

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLogControlบAutor  ณ Prox               บ Data ณ  24/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina de Controle de Logs.                                บฑฑ
ฑฑบ          ณ Cria e edita o arquivo, caso ocorreu erro no processamento.บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LogControl(cTextoLog)

Local nCriaDir   := MakeDir(cPathLog)
Local lRetArq    := .F.
Local nHandleLog

lControlLog := .T.

If !File(cArqRetLog)

	If (nHandleLog := MSFCreate(cArqRetLog,0)) <> -01

		lRetArq := .T.

	EndIf

ElseIf (nHandleLog := FOpen(cArqRetLog,2)) <> -01

	FSeek(nHandleLog,0,2)
	lRetArq := .T.

EndIf

If lRetArq

	FWrite(nHandleLog,cTextoLog+CHR(13)+CHR(10))
	FClose(nHandleLog)

Else

	MsgAlert("Nao foi possivel criar o arquivo de LOG, erro:"+cValToChar(FErro()),"Atencao")

EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณLeLinhaArqบAutor  ณ Prox               บ Data ณ  24/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLeitura da linha do arquivo de retorno.                     บฑฑ
ฑฑบ          ณTratamento para linhas com tamanho superior a 1024 Bytes.   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function LeLinhaArq()

Local cLinha := ""

If Len(FT_FREADLN()) < 1023

	cLinha	:= FT_FREADLN()

Else

	While .T.
		//-->> Verifica se ้ final da linha.
		If ( Len(FT_FREADLN()) < 1023 )

			cLinha += FT_FREADLN()
			Exit

		Else

			cLinha += FT_FREADLN()
			FT_FSKIP()

		EndIf

	EndDo

EndIf

Return(cLinha)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ RelGnre02บAutor  ณ Prox               บ Data ณ  08/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do relatorio do LOG.                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function RelGnre02()

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณReportDef บAutor  ณ Prox               บ Data ณ  08/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ CertiSign                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportDef()

oReport := TReport():New(cArqRetorno,"LOG Importa็ใo","",{|oReport| ReportPrint(oReport)},"LOG Importa็ใo")
oReport:SetPortrait()
oReport:HideParamPage()
oReport:SetDevice(1)
oReport:SetEnvironment(2)

oSection1:= TRSection():New(oReport,"LOG Importacao")

TRCell():New(oSection1,"cLinhaArq",,"Detalhes",,500,,{|| cLinhaArq })

Return oReport

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGSGNRE02  บAutor  ณMicrosiga           บ Data ณ  09/08/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ReportPrint(oReport)

Local oSection   := oReport:Section(1)
Local nTotLinhas := 0
Local nHandleRel := FT_FUSE(cArqRetLog)

If nHandleRel <> -01

	nTotLinhas := FT_FLastRec()
	FT_FGoTop()
	oReport:SetMeter(nTotLinhas)
	oSection:Init()

	While !FT_FEOF()

		oReport:IncMeter()
		cLinhaArq := FT_FReadLn()
		oSection:PrintLine()
	
		If oReport:Cancel()

			Exit

		EndIf
        
		FT_FSKIP()

	EndDo
	
	FT_FUSE()	

EndIf

Return