#Include "Protheus.ch"
#DEFINE ENTER chr(13)+chr(10)

/*
Funcao      : VRCSV
Objetivos   : Função chamada para realizar a conversão de XLS para um array
Parâmetros  : cArqE    - Nome do arquivo XLS a ser carregado
cOrigemE - Local onde está o arquivo XLS
nLinTitE - Quantas linhas de cabeçalho que não serão integradas possui o arquivo
Autor       : Ricsrdo Cavalini
Data/Hora   : 17/10/2017
*/
User Function VRCSV(cArqE,cOrigemE,nLinTitE,lTela)
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
private  ly1 := .T.
private  ly2 := .T.
private  ly3 := .T.
private  ly4 := .T.
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
	
	Define MsDialog oDlg Title 'Integração de Excel - Itens orcamento' From 5,10 To 23,50 OF oMainWnd
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
	cMsg    := validaCpos()
	If Empty(cMsg)
		aAdd(aArquivos, cArq)
		IntegrxArq()
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
Static Function IntegrxArq()
*-------------------------*
Local lConv      := .F.
//converte arquivos xls para csv copiando para a pasta temp
MsAguarde( {|| ConOut("Começou conversão do arquivo "+cArq+ " - "+Time()),lConv := convArqx(aArquivos) }, "Convertendo arquivos", "Convertendo arquivos" )

If lConv
	
	//carrega do xls no array
	ConOut("Terminou conversão do arquivo "+cArq+ " - "+Time())
	ConOut("Começou carregamento do arquivo "+cArq+ " - "+Time())
	Processa( {|| aRet:= CargaArray(AllTrim(cArq)) } ,"Aguarde, carregando planilha..."+ENTER+"Pode demorar")
	
	// Gera Sub
	Processa( {|| u_CargaSUB(aRet) } ,"Aguarde, Importação em processo...")
	
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
Static Function convArqX(aArqs)
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


// ALIMENTA ACOLS E HEADER COM OS DADOS DA PLANILHA
User Function CargaSUB(aRet)
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

_nPosqt      := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_QUANT"})
_nPospro     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_PRODUTO"})
_nPosoper    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_OPER"})
_nPostes     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_TES"})
_nPosdes     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRDESC"})
_nPosEmissao := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_EMISSAO"})
_nPosVun     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRUNIT"})
_nPosXvrc    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XVRCOMP"})
_nPosXmar    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XMARGEM"})
_nPosVLR     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VLRITEM"})
_nPosVLDC    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRVLRDE"})
_nPosDESX    := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_XDESCAD"})
_nPosSB2     := ascan(aHeader,{|_vAux|alltrim(_vAux[2])=="UB_VRSB2"})
N            := 1

For _nlinat := 1 to len(aret)
	                              
	if ALLTRIM(aret[_nlinat,01]) <> "PRODUTO"

		_CCODCSV := PADR(ALLTRIM(aret[_nlinat,01]),15)
		_NQTDCSV := VAL(STRTRAN(aret[_nlinat,02],",","."))   
	
	 If nn > 1	
		aCstu        := {}
		
		aadd(aCOLS,Array(Len(aHeader)+1))
		
		For nY := 1 To Len(aHeader)
			
			If ( AllTrim(aHeader[nY][2]) == 'UB_ITEM' )
				aCols[Len(aCols)][nY] := strzero(nn,2)
			Else
				If aHeader[nY,10] == "V"
					aCols[Len(aCols)][nY] := iif(Alltrim(aHeader[nY,2]) = "UB_ALI_WT","SUB",iif(Alltrim(aHeader[nY,2]) = "UB_REC_WT",0,CriaVar(Alltrim(aHeader[nY,2]))))
				Else
					aCols[Len(aCols)][nY] := ("SUB")->&(Alltrim(aHeader[nY,2]))
				EndIf
			EndIf
		Next nY
		
		N  := Len(aCols)   
		aCOLS[N][Len(aHeader)+1] := .F.
	 ENDIF	
	 
//		acols[nn,_npospro]      := _CCODCSV
//		acols[N,_nposqt]        := _NQTDCSV   
//		acols[N,_nPosSB2]       := POSICIONE("SB2",1,XFILIAL("SB2")+_CCODCSV+"01","B2_QATU")

		dbselectarea("SUB")
		M->UB_PRODUTO := _CCODCSV
			
		if  MAFISREF("IT_PRODUTO","TK273",M->UB_PRODUTO)  // TK273Calcula("UB_PRODUTO") .AND.
		else
			alert("erro no produto" + M->UB_PRODUTO)
			return
  	    endif
			
		acols[N,_nposqt]   := _NQTDCSV
		acols[N,_nposoper] := "01"  
//		acols[N,_nPosSB2]  := POSICIONE("SB2",1,XFILIAL("SB2")+_CCODCSV+"01","B2_QATU")
		acols[N,_nposoper] := "01"        
		acols[N,_nPosEmissao] := DDATABASE		

//	    ctes := MaTesInt(2,"01",M->UA_CLIENTE,M->UA_LOJA,"C",_CCODCSV,"UB_TES",M->UA_TIPOCLI)         
//	    acols[N,_nPosTES]  := ctes     
   
		nn := nn + 1
	ENDIF      
	
NEXT _nlinat
Tk273FRefresh()
//GetDRefresh()
//SYSREFRESH()

// PRRENCHIMENTO DOS CAMPOS DO ACOLS COM AS REGRAS FISCAIS
/*
nn          := 1
For _nlinat := 1 to len(aret)
	
	if ALLTRIM(aret[_nlinat,01]) <> "PRODUTO"

	   	_CCODCSV          := PADR(ALLTRIM(aret[_nlinat,01]),15)
	   	_NQTDCSV          := VAL(STRTRAN(aret[_nlinat,02],",","."))   
	   	N                 := nn
	   	acols[N,_npospro] := _CCODCSV
			
		dbselectarea("SUB")
		M->UB_PRODUTO := _CCODCSV
			
		if  MAFISREF("IT_PRODUTO","TK273",M->UB_PRODUTO)  // TK273Calcula("UB_PRODUTO") .AND.
		else
			alert("erro no produto" + M->UB_PRODUTO)
			return
  	    endif
			
		acols[N,_nposqt]   := _NQTDCSV
		acols[N,_nposoper] := "01"  
		acols[N,_nPosSB2]  := POSICIONE("SB2",1,XFILIAL("SB2")+_CCODCSV+"01","B2_QATU")
		nn := nn + 1
ENDIF
NEXT _nlinat

N     := 1                            
NPERC := 0
ctes  := ""
Tk273FRefresh()
GetDRefresh()
SYSREFRESH()
*/

For i := 1 to len(aCols)
		N                     := i
		nQTu                  := acols[N,_nposqt]                                                            
		acols[N,_nPosEmissao] := DDATABASE
		M->UB_PRODUTO         := acols[N,_npospro]                       
		_CCODCSV              := PADR(ALLTRIM(acols[N,_npospro]),15)
		
		If ExistTrigger('UB_PRODUTO')
			RunTrigger(2,N,nil,,'UB_PRODUTO')
		ENDIF
		
//		acols[N,_nPosSB2] := POSICIONE("SB2",1,XFILIAL("SB2")+acols[N,_npospro]+"01","B2_QATU")
//		M->UB_VRSB2       := acols[N,_nPosSB2]
		
//		acols[N,_nposdes] := nPerc
		acols[N,_nposqt]  := nQTu

//		If ExistTrigger('UB_VRSB2')
//			RunTrigger(2,N,nil,,'UB_VRSB2  ')
//		ENDIF
		
		If ExistTrigger('UB_VRDESC')
			RunTrigger(2,i,nil,,'UB_VRDESC ')
		ENDIF

		If ExistTrigger('UB_QUANT')
			RunTrigger(2,N,nil,,'UB_QUANT  ')
		ENDIF

//		If ExistTrigger('UB_OPER')
//			acols[N,_nposoper] := "01"  
			//RunTrigger(2,i,nil,,'UB_OPER')
//		ENDIF

//		If ExistTrigger('UB_TES')
//		    ctes := MaTesInt(2,"01",M->UA_CLIENTE,M->UA_LOJA,"C",_CCODCSV,"UB_TES",M->UA_TIPOCLI)         
//  		    acols[N,_nPosTES]  := ctes
//			RunTrigger(2,i,nil,,'UB_TES ')
//		ENDIF
next

N:= 1
GetDRefresh()
SYSREFRESH()

MSGSTOP("Fim do processamento !!!")
Return