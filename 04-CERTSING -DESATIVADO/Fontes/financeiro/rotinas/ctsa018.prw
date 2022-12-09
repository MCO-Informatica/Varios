#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "tbiconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA018   บAutor  ณOpvs (David)        บ Data ณ  01/09/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a leitura do arquivo REDECARD DE MOVIMENTO DE CARTAOบฑฑ
ฑฑบ          ณE ATUALIZA PEDIDOS DE VENDA COM AS INFORMACOES DO CC        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTSA018()
Local oDlg		
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Local cSomLog	:= ""
Local cArqLog	:= "LOG_ERRO_"+Dtos(DdataBase)+StrTran(Substr(time(),1,5),":","_")+".txt"

DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Atulizacao Pedidos com Cart. Credito " PIXEL

@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL

@ 025,10 SAY "Somente LOG" OF oDlg PIXEL
@ 025,70 COMBOBOX oCbox var cSomLog ITEMS {"0=Nใo","1=Sim"} SIZE 40,5 OF oDlg PIXEL 

@ 45,010 BUTTON "File"		SIZE 40,13 OF oDlg PIXEL ACTION CTS018GetDir(@aDirIn,@cDirIn)
@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())

ACTIVATE MSDIALOG oDlg CENTERED

If !nOpc == 1 
	Return(.F.)
EndIf

If len(aDirIn) = 0 
	MsgAlert("Nใo Foram encontrados Arquivos para processamento!")
	Return(.F.)
EndIf

If !File(cDirIn+cArqLog)
	nHandlog := FCREATE(cDirIn+cArqLog,1)
EndIf
 
Proc2BarGauge({|| ProcA(cDirIn,aDirIn,cSomLog) },"Processamento de Arquivo TXT")

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma        ProcAบAutor  ณOpvs (David)        บ Data ณ  08/25/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ProcA(cDirIn,aDirIn,cSomLog)
Local nNumArq 	:= Len(aDirIn)
Local cTexto	:= ""

BarGauge1Set(nNumArq)

For nI:= 1 to len(aDirIn)

	cFileIn	:= cDirIn+aDirin[nI,1]
	cFileOut:= cFileIn
	
	CTS018GetFile(@cFileIn,@cFileOut)
	
	If !File(cFileOut)
		nHandle := FCREATE(cFileOut,1)
	Else
		While FERASE(cFileOut)==-1
		End
		nHandle := FCREATE(cFileOut,1)
	Endif
	
	IncProcG1("Proc. Arquivo "+cFileIn)
	ProcessMessage()

	// Esta funcao executa em blinde, pois serแ rodada pelo Schedule
	lRet := CTS018Proc(cFileIn, nHandle, nHandlog,cSomLog)  
		
	FClose(nHandle)
	
	If !lRet
		cTexto += cFileIn+"- Nใo foi prossํvel processar o arquivo. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Else
		cTexto += cFileIn+"- Arquivo processado com sucesso. Verifique log em "+cFileOut+CHR(13)+CHR(10)
	Endif
Next

cTexto := "Log do Processamento de Arquivos "+CHR(13)+CHR(10)+cTexto
__cFileLog := MemoWrite(Criatrab(,.f.)+".LOG",cTexto)
DEFINE FONT oFont NAME "Mono AS" SIZE 5,12   //6,15
DEFINE MSDIALOG oDlg TITLE "Processamento Concluํdo" From 3,0 to 340,417 PIXEL
@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL 
oMemo:bRClicked := {||AllwaysTrue()}
oMemo:oFont:=oFont

DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.T.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL 


ACTIVATE MSDIALOG oDlg CENTER

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS018GetFile(cFileIn, cFileOut)

Local cAux := ""

cFileIn := Lower(AllTrim(cFileIn))

If Upper(SubStr(cFileIn,Len(cFileIn)-2,3)) <> "RET"
	cFileIn  := Space(256)
	cFileOut := Space(256)
	Return(.F.)
Endif

cFileIn  := PadR(Upper(cFileIn),256)
cFileOut := PadR(StrTran(cFileIn,"RET","LOG"),256)

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA01   บAutor  ณMicrosiga           บ Data ณ  01/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS018GetDir(aDirIn,cDirIn)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

aDirIn := Directory(cDirIn+"*.RET")

Return(.T.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA011   บAutor  ณMicrosiga           บ Data ณ  12/10/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CTS018Proc(cArquivo, nHandle, nHandlog,cSomLog)

Local cArqTmp		:= ""
Local nI			:= 0
Local nRecAtu		:= 0
Local cPedGar		:= ""
Local dDatMov		:= CtoD("//")
Local nValCred		:= 0
Local nValDesc		:= 0
Local nTotSc6		:= 0
Local cSql			:= ""
Local cMsgLog		:= ""
Local cLogArq		:= ""
Local nTotRec		:= 0
Local cTitBx		:= ""
Local lLoop			:= .F. 
Local xBuff			:= ""
Local aLin			:= {}
Local bLin			:= {|cLin,cVar,nIni,nPos| cVar:= SubStr(cLin,nIni,nPos) }
Local cTipLin		:= ""
Local cCrtArq		:= ""
Local cVldArq		:= ""
Local cVlrArq		:= ""
Local cParArq		:= ""
Local cRv			:= ""
Local cPV			:= ""
Local cDatComp		:= ""
Local cCV			:= ""

Default	cArquivo	:= ""

//FWrite(nHandlog, "ERROS DO ARQUIVO  --> " + cArquivo + CRLF )

If !File(cArquivo)
	cMsgLog := alltrim(cArquivo)+";Arquivo de entrada nใo localizado" +CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

FT_FUSE(cArquivo)

If FT_FEOF()
	FT_FUSE()
	cMsgLog := alltrim(cArquivo)+";Arquivo invalido ou vazio..." + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
	Return(.F.)
Endif

If cSomLog = "1"
	cMsgLog := alltrim(cArquivo)+";*** ROTINA PROCESSADA APENAS PARA SIMPLES CONFERENCIA DE LOG. NENHUM DADO FOI ALTERADO ***"  + CRLF
	FWrite(nHandle, cMsgLog )
	FWrite(nHandlog, cMsgLog )
Endif

nTotRec := FT_FLASTREC()
BarGauge2Set( nTotRec )

FT_FGOTOP()

While !FT_FEOF()
	
	IncprocG2( "Processando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
	ProcessMessage()
	
	xBuff:=alltrim(FT_FREADLN())
	Eval(bLin,xBuff,@cTipLin,1,3) 
	
	If 	!Empty(xBuff) .and.;
		cTipLin $ '008,012'	

		Eval(bLin,xBuff,@cCrtArq,68 ,16)
		Eval(bLin,xBuff,@cVlrArq,38 ,15)
		Eval(bLin,xBuff,@cRv,13 ,9)
		Eval(bLin,xBuff,@cPv,4 ,9)
		Eval(bLin,xBuff,@cDatComp,22 ,8)		
		cBanArq := "RED"
		If cTipLin == '008' 
			Eval(bLin,xBuff,@cVldArq,127,6)			
			Eval(bLin,xBuff,@cCV,87,12)
			cParArq := "00"		
		EndIf                   
		If cTipLin == '012' 			
			Eval(bLin,xBuff,@cVldArq,129,6)
			Eval(bLin,xBuff,@cParArq,87 ,2)
			Eval(bLin,xBuff,@cCV,89,12)
		EndIf
		cCV := Right(cCV,9)
		u_AtuCCPed("2",cArquivo,nil,cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,nil,nHandle,nHandlog,nRecAtu,iif(cSomLog="1",.F.,.T.),cRv,cPv,cDatComp,"",cCV)
		
	ElseIf Empty(xBuff)
		cMsgLog :=  alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";01;Linha do arquivo em branco ou foi desconsiderada." + CRLF
		FWrite(nHandle, cMsgLog  )
		FWrite(nHandlog, cMsgLog )		
	EndIf
	FT_FSKIP()
Enddo

FT_FUSE()

Return(.T.)                          