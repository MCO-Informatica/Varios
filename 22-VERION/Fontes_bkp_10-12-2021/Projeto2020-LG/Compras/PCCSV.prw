#Include "Protheus.ch"
#DEFINE ENTER chr(13)+chr(10)

/*
Funcao      : PCCSV
Objetivos   : Função chamada para realizar a conversão de XLS para um array
Parâmetros  : cArqE    - Nome do arquivo XLS a ser carregado
cOrigemE - Local onde está o arquivo XLS
nLinTitE - Quantas linhas de cabeçalho que não serão integradas possui o arquivo
Autor       : Ricsrdo Cavalini
Data/Hora   : 17/10/2017
*/
User Function PCCSV(cArqE,cOrigemE,nLinTitE,lTela)
Local bOk        := {||lOk:=.T.,oDlg:End()}
Local bCancel    := {||lOk:=.F.,oDlg:End()}
Local lOk        := .F.
Local nLin       := 35
Local nCol1      := 15
Local nCol2      := nCol1+30
Local cMsg       := ""
Local oDlg
Local oArq
Local oOrigem
Local oMacro
Local  nn 		:= 1
Local  nV       := 1
lOCAL  nPerc    := 50
Local  cTes	    := '558'
private  ly1    := .T.
private  ly2    := .T.
private  ly3    := .T.
private  ly4    := .T.
private  cStu   := space(15) //

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
	
	Define MsDialog oDlg Title 'Integração de Excel' From 5,10 To 23,50 OF oMainWnd
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
	cMsg    := ValidaCpos()
	
	If Empty(cMsg)
		aAdd(aArquivos, cArq)
		IntegrZArq()
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
Static Function IntegrZArq()
*-------------------------*
Local lConv      := .F.
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Começou conversão do arquivo " + cArq + " - " + Time()),lConv := convArqZ(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )

If lConv
	
	//carrega do xls no array
	ConOut("Terminou conversão do arquivo " + cArq + " - "+Time())
	ConOut("Começou carregamento do arquivo " + cArq + " - "+Time())
	Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,"Aguarde, carregando planilha..." + ENTER + "Pode demorar")
	
	// Gera Sub
	Processa( {|| u_CargaSC7(aRet) } ,"Aguarde, Importação em processo...")
	
	ConOut("Terminou carregamento do arquivo " + cArq + " - " + Time())
EndIf
Return

/*
Funcao      : convArqs
Objetivos   : converte os arquivos .xls para .csv
Autor       : Ricardo Cavalini
Data/Hora   : 05/02/2017
*/
*-------------------------*
Static Function convArqZ(aArqs)
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
		MsgInfo("O arquivo " + cFile + " não foi encontrado!" ,"Arquivo")
		Return .F.
	EndIf
	
	//verifica se existe o arquivo na pasta temporaria e apaga
	If File(cTemp+cNomeXLS+cExtensao)
		fErase(cTemp+cNomeXLS+cExtensao)
	EndIf
	
	//Copia o arquivo XLS para o Temporario para ser executado
	If !AvCpyFile(cFile,cTemp+cNomeXLS+cExtensao,.F.)
		MsgInfo("Problemas na copia do arquivo " + cFile + " para "+cTemp+cNomeXLS+cExtensao ,"AvCpyFile()")
		Return .F.
	EndIf
	
	//apaga macro da pasta temporária se existir
	If File(cTemp+cArqMacro)
		fErase(cTemp+cArqMacro)
	EndIf
	
	//Copia o arquivo XLA para o Temporario para ser executado
	If !AvCpyFile(cSystem+cArqMacro,cTemp+cArqMacro,.F.)
		MsgInfo("Problemas na copia do arquivo " + cSystem + cArqMacro + "para" + cTemp + cArqMacro ,"AvCpyFile()")
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
Next i
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
End

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


// ALIMENTA ACOLS E HEADER COM OS DADOS DA PLANILHA
User Function CargaSC7(aRet)
_aProd  := aret
_nlinto := len(aret) - 1
_nlinat := 0
adados  := {}
_NLOGA  := 0
NN      := 1

If len(aCols) > 1 .or. alltrim(aCols[1][2]) <> ""
	alert("Atenção nao pode usar esta rotina para orçamentos com Itens lançados")
	Return
Endif

_nPosqt      := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_QUANT"})
_nPosPRC     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_PRECO"})
_nPosTOT     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_TOTAL"})
_nPospro     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_PRODUTO"})
_nPosEmissao := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_EMISSAO"})   
_nPosEnt     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_DATPRF"})   
_nPosLocal   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_LOCAL"})
_nPosUnid    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_UM"})   
_nPosDesc    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_DESCRI"})
_nPosNCM     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_X_NCM"})
_nPosSC      := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_NUMSC"})   
_nPosItemSC  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_ITEMSC"})
_nPosOBS     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_OBS"}) 
_nPosConCtb  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_CONTA"})
_nPosQtdSC   := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_QTDSOL"})
_nPosValIPI  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_VALIPI"})
_nPosBaseIPI := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_BASEIPI"})
_nPosCodUsr  := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_USER"})
_nPosUser    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="C7_VRUSER"})
N            := 1

For _nlinat := 1 to len(aret)
	
	if ALLTRIM(aret[_nlinat,01]) <> "PRODUTO"
		_CCODCSV := aret[_nlinat,01]
		_NQTDCSV := VAL(STRTRAN(aret[_nlinat,02],",","."))
		
		If nn > 1
			aCstu        := {}
			aadd(aCOLS,Array(Len(aHeader)+1))
			
			For nY := 1 To Len(aHeader)
				
				If ( AllTrim(aHeader[nY][2]) == 'C7_ITEM' )
					aCols[Len(aCols)][nY] := strzero(nn,4)
					M->C7_ITEM            := strzero(nn,4)
				Else
					If aHeader[nY,10] == "V"
						aCols[Len(aCols)][nY] := iif(Alltrim(aHeader[nY,2]) = "C7_ALI_WT","SC7",iif(Alltrim(aHeader[nY,2]) = "C7_REC_WT",0,CriaVar(Alltrim(aHeader[nY,2]))))
					Else
						aCols[Len(aCols)][nY] := ("SC7")->&(Alltrim(aHeader[nY,2]))
					EndIf
				EndIf
			Next nY
			
			N  := Len(aCols)
			aCOLS[N][Len(aHeader)+1] := .F.
		ENDIF         
		
		
		acols[n,_npospro]       := _CCODCSV
		M->C7_PRODUTO           := _CCODCSV
		A120TRIGGER("C7_PRODUTO")
		
		acols[n,_npospro]       := _CCODCSV
		M->C7_PRODUTO           := _CCODCSV
		A120TRIGGER("C7_PRODUTO")
		
		acols[N,_nposqt]        := _NQTDCSV
		M->C7_QUANT             := _NQTDCSV
		A120TRIGGER("C7_QUANT")
		
		acols[N,_nPosPRC ]      := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_VERCOM")
		M->C7_PRECO             := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_VERCOM")
		A120TRIGGER("C7_PRECO")
		
		acols[N,_nPosTOT]      := ( _NQTDCSV * POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_VERCOM"))
		M->C7_TOTAL            := ( _NQTDCSV * POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_VERCOM"))
		A120TRIGGER("C7_TOTAL")

		acols[N,_nPosLocal]     := "01"
		M->C7_LOCAL             := "01"
		
		acols[N,_nPosUnid ]     := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_UM")
		M->C7_UM                := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_UM")
		
		acols[N,_nPosEnt ]      := DDATABASE
		M->C7_DATPRF            := DDATABASE

		acols[N,_nPosDesc ]     := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_DESC")
		M->C7_DESCRI            := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_DESC")

		acols[N,_nPosNCM  ]     := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_POSIPI")
		M->C7_X_NCM             := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_POSIPI")

		acols[N,_nPosSC   ]     := Space(TAMSX3("C7_NUMSC")[1])
		M->C7_NUMSC             := Space(TAMSX3("C7_NUMSC")[1])

		acols[N,_nPosItemSC ]   := Space(TAMSX3("C7_ITEMSC")[1])
		M->C7_ITEMSC            := Space(TAMSX3("C7_ITEMSC")[1])

		acols[N,_nPosOBS ]      := Space(TAMSX3("C7_OBS")[1])
		M->C7_OBS               := Space(TAMSX3("C7_OBS")[1])

		acols[N,_nPosConCtb ]   := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_CONTA")
		M->C7_CONTA             := POSICIONE("SB1",1,XFILIAL("SB1")+M->C7_PRODUTO,"B1_CONTA")

		acols[N,_nPosQtdSC ]    := Space(TAMSX3("C7_QTDSOL")[1])
		M->C7_QTDSOL            := Space(TAMSX3("C7_QTDSOL")[1])

		acols[N,_nPosValIPI ]   := Space(TAMSX3("C7_VALIPI")[1])
		M->C7_VALIPI            := Space(TAMSX3("C7_VALIPI")[1])

		acols[N,_nPosBaseIPI ]  := Space(TAMSX3("C7_BASEIPI")[1])
		M->C7_BASEIPI           := Space(TAMSX3("C7_BASEIPI")[1])

		acols[N,_nPosCodUsr ]   := RetCodUsr()
		M->C7_USER              := RetCodUsr()

		acols[N,_nPosUser ]     := UsrRetName(RetCodUsr())
		M->C7_VRUSER            := UsrRetName(RetCodUsr())

        NN := NN + 1
	endif

NEXT _nlinat

GetDRefresh()
SYSREFRESH()

MSGSTOP("Fim do processamento !!!")
Return
