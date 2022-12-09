#INCLUDE "Protheus.ch"
#DEFINE ENTER chr(13)+chr(10)
/*
Funcao      : CargaXLS
Objetivos   : Função chamada para realizar a conversão de XLS para um array
Parâmetros  : cArqE    - Nome do arquivo XLS a ser carregado
cOrigemE - Local onde está o arquivo XLS
nLinTitE - Quantas linhas de cabeçalho que não serão integradas possui o arquivo
Autor       : Ricsrdo Cavalini
Data/Hora   : 05/02/2015
*/
*-------------------------*
User Function CargaXLS(cArqE,cOrigemE,nLinTitE,lTela)
*-------------------------*
Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 20
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro

Default lTela := .T.

Private cArq       := "" //If(ValType(cArqE)=="C",cArqE,"")
Private cArqMacro  := "XLS2DBF.XLA"
Private cTemp      := GetTempPath() //pega caminho do temp do client
Private cSystem    := Upper(GetSrvProfString("STARTPATH",""))//Pega o caminho do sistema
Private cOrigem    := If(ValType(cOrigemE)=="C",cOrigemE,"")
Private nLinTit    := If(ValType(nLinTitE)=="N",nLinTitE,0)
Private aArquivos  := {}
Private aRet       := {}
Private cFile      := ""

cArq       += Space(20-(Len(cArq)))
cOrigem    += Space(99-(Len(cOrigem)))

If lTela .Or. Empty(AllTrim(cArq)) .Or. Empty(AllTrim(cOrigem))
	
	Define MsDialog oDlg Title 'Integração de Excel - Cadastro Produto' From 7,10 To 20,50 OF oMainWnd
	
	@ nLin,nCol1  Say      'Arquivo :'                                Of oDlg Pixel
	@ nLin,nCol2  MsGet    oArq   Var cArq                 Size 60,09 Of oDlg Pixel
	nLin += 15
	@ nLin,nCol1  Say      'Caminho do arquivo :'                     Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1    MsGet    oOrigem Var CFILE         Size 130,09 Of oDlg Pixel
	@ nlin,ncol2+100 BUTTON '...' Size 09, 11 action(cFile := cGetFile('Arquivo *|*.*|Arquivo XLSX|*.XLSX','Retorna Diretorio',0,'C:\',.T.,GETF_LOCALHARD+GETF_RETDIRECTORY,.F.)) of oDlg Pixel
	
	nLin += 15
	@ nLin,nCol1  Say      'Nome da Macro :'                          Of oDlg Pixel
	nLin += 10
	@ nLin,nCol1  MsGet    oMacro  Var cArqMacro When .F. Size 130,09 Of oDlg Pixel
	
	Activate MsDialog oDlg On Init Enchoicebar(oDlg,bOk,bCancel) Centered
Else
	lOk := .T.
EndIf

If lOk
	CORIGEM := CFILE
	cMsg := validaCpos()
	If Empty(cMsg)
		aAdd(aArquivos, cArq)
		IntegraArq()
	Else
		MsgStop(cMSg)
		Return
	EndIf
EndIf
Return aRet

/*
Funcao      : IntegraArq
Objetivos   : Faz a chamada das rotinas referentes a integração
Autor       : Ricardo Cavalini
Data/Hora   : 05/02/2017
*/
*-------------------------*
Static Function IntegraArq()
*-------------------------*
Local lConv      := .F.
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),lConv := convArqs(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )

If lConv
	
	//carrega do xls no array
	ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
	ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,"Aguarde, carregando planilha..."+ENTER+"Pode demorar")
	
	// Gera SB1
	Processa( {|| u_Cargasb1(aRet) } ,"Aguarde, Importação em processo...")
	
	ConOut("Terminou carregamento do arquivo "+cArq+ " - "+Time())
EndIf

Return

/*
Funcao      : convArqs
Objetivos   : converte os arquivos .xls para .csv
Autor       : Ricardo Cavalini
Data/Hora   : 05/02/2017
*/
*-------------------------*
Static Function convArqs(aArqs)
*-------------------------*
Local oExcelApp
Local cNomeXLS  := ""
Local cFile     := ""
Local cExtensao := ""
Local i         := 1
Local j         := 1
Local aExtensao := {}

cOrigem := AllTrim(cOrigem)

//Verifica se o caminho termina com "\"
If !Right(cOrigem,1) $ "\"
	cOrigem := AllTrim(cOrigem)+"\"
EndIf


//loop em todos arquivos que serão convertidos
For i := 1 To Len(aArqs)
	
	If !"." $ AllTrim(aArqs[i])
		//passa por aqui para verifica se a extensão do arquivo é .xls ou .xlsx
		aExtensao := Directory(cOrigem+AllTrim(aArqs[i])+".*")
		For j := 1 To Len(aExtensao)
			If "XLS" $ Upper(aExtensao[j][1])
				cExtensao := SubStr(aExtensao[j][1],Rat(".",aExtensao[j][1]),Len(aExtensao[j][1])+1-Rat(".",aExtensao[j][1]))
				Exit
			EndIf
		Next j
	EndIf
	//recebe o nome do arquivo corrente
	cNomeXLS := AllTrim(aArqs[i])
	cFile    := cOrigem+cNomeXLS+cExtensao
	
	If !File(cFile)
		MsgInfo("O arquivo "+cFile+" não foi encontrado!" ,"Arquivo")
		Return .F.
	EndIf
	
	//verifica se existe o arquivo na pasta temporaria e apaga
	If File(cTemp+cNomeXLS+cExtensao)
		fErase(cTemp+cNomeXLS+cExtensao)
	EndIf
	
	//Copia o arquivo XLS para o Temporario para ser executado
	If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.)
		MsgInfo("Problemas na copia do arquivo "+cFile+" para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
		Return .F.
	EndIf
	
	//apaga macro da pasta temporária se existir
	If File(cTemp+cArqMacro)
		fErase(cTemp+cArqMacro)
	EndIf
	
	//Copia o arquivo XLA para o Temporario para ser executado
	If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
		MsgInfo("Problemas na copia do arquivo "+cSystem+cArqMacro+"para"+cTemp+cArqMacro ,"AvCpyFile()")
		Return .F.
	EndIf
	
	//Exclui o arquivo antigo (se existir)
	If File(cTemp+SUBSTRING(cNomeXLS,1,RAT(".",cNomeXLS))+"csv")
		fErase(cTemp+SUBSTRING(cNomeXLS,1,RAT(".",cNomeXLS))+"csv")
	EndIf
	
	//Inicializa o objeto para executar a macro
	oExcelApp := MsExcel():New()
	//define qual o caminho da macro a ser executada
	oExcelApp:WorkBooks:Open(cTemp+cArqMacro)
	//executa a macro passando como parametro da macro o caminho e o nome do excel corrente
	oExcelApp:Run(cArqMacro+'!XLS2DBF',cTemp,cNomeXLS)
	//fecha a macro sem salvar
	oExcelApp:WorkBooks:Close('savechanges:=False')
	//sai do arquivo e destrói o objeto
	oExcelApp:Quit()
	oExcelApp:Destroy()
	
	//Exclui o Arquivo excel da temp
	fErase(cTemp+cNomeXLS+cExtensao)
	fErase(cTemp+cArqMacro) //Exclui a Macro no diretorio temporario
	//
Next i
//
Return .T.

/*
Funcao      : CargaDados
Objetivos   : carrega dados do csv no array pra retorno
Parâmetros  : cArq - nome do arquivo que será usado
Autor       : Ricardo Cavalini
Data/Hora   : 05/02/2017
*/
*-------------------------*
Static Function CargaArray(cArq)
*-------------------------*
Local cLinha  := ""
Local nLin    := 1
Local nTotLin := 0
Local aDados  := {}
Local cFile   := cTemp + SUBSTRING(cArq,1,RAT(".",cArq)) + "csv"
Local nHandle := 0


//abre o arquivo csv gerado na temp
nHandle := Ft_Fuse(cFile)
If nHandle == -1
	Return aDados
EndIf
Ft_FGoTop()
nLinTot := FT_FLastRec()-1
ProcRegua(nLinTot)
//Pula as linhas de cabeçalho
While nLinTit > 0 .AND. !Ft_FEof()
	Ft_FSkip()
	nLinTit--
EndDo

//percorre todas linhas do arquivo csv
While !Ft_FEof()
	//exibe a linha a ser lida
	IncProc("Carregando Linha "+AllTrim(Str(nLin))+" de "+AllTrim(Str(nLinTot)))
	nLin++
	//le a linha
	cLinha := Ft_FReadLn()
	//verifica se a linha está em branco, se estiver pula
	If Empty(AllTrim(StrTran(cLinha,';','')))
		Ft_FSkip()
		Loop
	EndIf
	//transforma as aspas duplas em aspas simples
	cLinha := StrTran(cLinha,'"',"'")
	cLinha := '{"'+cLinha+'"}'
	//adiciona o cLinha no array trocando o delimitador ; por , para ser reconhecido como elementos de um array
	cLinha := StrTran(cLinha,';','","')
	aAdd(aDados, &cLinha)
	
	//passa para a próxima linha
	FT_FSkip()
	//
End

//libera o arquivo CSV
FT_FUse()

//Exclui o arquivo csv
If File(cFile)
	FErase(cFile)
EndIf

Return aDados


/*
Funcao      : validaCpos
Objetivos   : faz a validação dos campos da tela de filtro
Autor       : Ricardo Cavalini
Data/Hora   : 05/02/2017
*/
*-------------------------*
Static Function validaCpos()
*-------------------------*
Local cMsg := ""

If Empty(cArq)
	cMsg += "Campo Arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cOrigem)
	cMsg += "Campo Caminho do arquivo deve ser preenchido!"+ENTER
EndIf

If Empty(cArqMacro)
	cMsg += "Campo Nome da Macro deve ser preenchido!"
EndIf

Return cMsg


user function Cargasb1(aRet)
_aProd  := aret
_nlinto := len(aret) - 1
_nlinat := 0
adados  := {}
_NLOGA  := 0


For _nlinat := 1 to len(aret)
	
	if ALLTRIM(aret[_nlinat,01]) <> "B1_COD"
		
		
		aRotAuto      := {}
		nOpc          := 3 // inclusao
		lMsHelpAuto := .t. // se .t. direciona as mensagens de help para o arq. de log
		lMsErroAuto := .f. //necessario a criacao, pois sera //atualizado quando houver

//B1_COD	    B1_PICM	    B1_IPI	    B1_POSIPI	B1_GRTRIB	B1_TIPICMS	
//B1_IMPIMPO	B1_PCOFE	B1_PPISE	B1_ALIQ1	B1_CEST	    B1_ALIQ3	
//B1_ALIQ4	B1_ALIQ5	B1_ALIQ6	B1_DIFERIM
		
		_COD	 := aret[_nlinat,01]
		_PICM	 := VAL(STRTRAN(aret[_nlinat,02],",","."))   
		_IPI	 := VAL(STRTRAN(aret[_nlinat,03],",","."))
		_NCM     :=  STRTRAN(aret[_nlinat,04],".","")
		_TRIB	 := aret[_nlinat,05]
		_TPICM	 := aret[_nlinat,06]
		_IMP	 := VAL(STRTRAN(aret[_nlinat,07],",","."))   
		_COF	 := VAL(STRTRAN(aret[_nlinat,08],",","."))
		_PIS     := VAL(STRTRAN(aret[_nlinat,09],",","."))   
		_AL1	 := VAL(STRTRAN(aret[_nlinat,10],",","."))
		_CEST	 :=  STRTRAN(aret[_nlinat,11],".","")
		_AL3	 := VAL(STRTRAN(aret[_nlinat,12],",","."))
		_AL4	 := VAL(STRTRAN(aret[_nlinat,13],",","."))   
		_AL5	 := VAL(STRTRAN(aret[_nlinat,14],",","."))
		_AL6     := VAL(STRTRAN(aret[_nlinat,15],",","."))   
		_DIF     := ALLTRIM(aret[_nlinat,16])

		// CADASTRO DE PRODUTO
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		IF DBSEEK(XFILIAL("SB1")+PAD(ALLTRIM(_COD),15))

           DBSELECTAREA("SB1")
           RECLOCK("SB1",.F.)
            //SB1->B1_COD      := _COD
            SB1->B1_PICM     := _PICM
            SB1->B1_IPI	     := _IPI
            SB1->B1_POSIPI	 := _NCM
            SB1->B1_GRTRIB	 := _TRIB
            SB1->B1_TIPICMS	 := _TPICM
			SB1->B1_IMPIMPO	 := _IMP
			SB1->B1_PCOFE	 := _COF
			SB1->B1_PPISE	 := _PIS
			SB1->B1_ALIQ1	 := _AL1
			SB1->B1_CEST	 := _CEST
			SB1->B1_ALIQ3	 := _AL3
			SB1->B1_ALIQ4	 := _AL4
			SB1->B1_ALIQ5	 := _AL5
			SB1->B1_ALIQ6	 := _AL6
			SB1->B1_DIFERIM  := _DIF
           MSUNLOCK("SB1") 
		ENDIF
	endif
Next _nlinat
MSGSTOP("Fim do processamento !!!")

Return .t.