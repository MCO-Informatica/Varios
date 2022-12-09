#INCLUDE "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCTSA017   บAutor  ณDavid de Oliveira   บ Data ณ  27/08/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณRealiza a leitura do arquivo VETEX   para inserir Pedido GARบฑฑ
ฑฑบ          ณCartao e Autorizacao                                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CTSA017(lJob)

Local oDlg											// Dialog para escolha da Lista
Local nOpc		:= 0								// 1 = Ok, 2 = Cancela
Local cFileIn	:= Space(256)
Local cFileOut	:= Space(256)
Local cDirIn	:= Space(256)
Local cDirOut	:= Space(256)
Local aDirIn	:= {}
Local nI		:= 0
Local cSaida	:= cFileOut
Local cAux		:= ""
Local nHandle	:= -1
Local lRet		:= .F.
Local cJobEmp 	:= Getjobprofstring("JOBEMP","01")
Local cJobFil 	:= Getjobprofstring("JOBFIL","02")
Local cInterval := Getjobprofstring("INTERVAL","60")

If Type("lJob") <> "L"
	lJob := .F.
Endif

If !lJob
	DEFINE MSDIALOG oDlg FROM  36,1 TO 160,550 TITLE "Importa็ใo Pedido do arquivo cart. Credito " PIXEL
	
	@ 10,10 SAY "Dir. Arq. de entrada" OF oDlg PIXEL
	@ 10,70 MSGET cDirIn SIZE 200,5 OF oDlg PIXEL
	
	@ 45,010 BUTTON "Directory"		SIZE 40,13 OF oDlg PIXEL ACTION CTS017GetDir(@aDirIn,@cDirIn,"I")
	@ 45,060 BUTTON "OK"		SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 1,oDlg:End())
	@ 45,230 BUTTON "Cancel"	SIZE 40,13 OF oDlg PIXEL ACTION (nOpc := 2,oDlg:End())
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If !nOpc == 1 
		Return(.F.)
	EndIf
Else
//	Conout("Job CTSA017 - Begin Emp("+cJobEmp+"/"+cJobFil+")" )
//	Conout("Interval Check : "+cInterval)
	
	Rpcsettype(2)
	RpcSetEnv(cJobEmp,cJobFil)

	OpenGTEnv()
	cDirIn	:= GetNewPar("CC_DIRIN", "\\marte\Integracao\09-Financeira\Protheus\cc\in\")
	cDirOut	:= GetNewPar("CC_DIROUT", "\\marte\Integracao\09-Financeira\Protheus\cc\out\")
	aDirIn := Directory(cDirIn+"*.CSV")
EndIf

If len(aDirIn) = 0 
	If !lJob
		MsgAlert("Nใo Foram encontrados Arquivos para processamento!")
	Else
//		Conout("Nใo Foram encontrados Arquivos para processamento!"+DtoS(Date())+" "+time())
	EndIf
	Return(.F.)
EndIf

If !lJob
	Proc2BarGauge({|| u_ProcA(cDirIn,aDirIn,nil,.F.) },"Processamento de Arquivo TXT")
Else
	u_ProcA(cDirIn,aDirIn,cDirOut,.T.)
EndIf

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

User Function ProcA(cDirIn,aDirIn,cDirOut,lJob)
Local nNumArq 	:= Len(aDirIn)
Local cTexto	:= ""
Local cFileErr	:= ""

Default cDirOut	:= cDirIn

If !lJob
	BarGauge1Set(nNumArq)
EndIf

For nI:= 1 to len(aDirIn)

	cFileIn	:= cDirIn+aDirin[nI,1]
	cFileOut:= aDirin[nI,1]
	
	CTS017GetFile(@cFileIn,@cFileOut,cDirOut)
	
	If !File(cFileOut)
		nHandle := FCREATE(cFileOut,1)
	Else
		While FERASE(cFileOut)==-1
		End
		nHandle := FCREATE(cFileOut,1)
	Endif
	
	cFileErr	:= PadR(StrTran(cFileOut,".LOG",".ERR"),256)
	
	If !File(cFileErr)
		nHandleErr := FCREATE(cFileErr,1)
	Else
		While FERASE(cFileErr)==-1
		End
		nHandleErr := FCREATE(cFileErr,1)
	Endif	
	
	If !lJob
		IncProcG1("Proc. Arquivo "+cFileIn)
		ProcessMessage()
	EndIf

	// Esta funcao executa em blinde, pois serแ rodada pelo Schedule
	lRet := CTS017Proc(cFileIn, nHandle, nHandleErr,lJob)  
	
	FClose(nHandle)
	
	If cDirIn <> cDirOut
		__copyfile(cDirIn+aDirin[nI,1],cDirOut+aDirin[nI,1])	
		FERASE(cFileIn)
	EndIf

	If !lJob
		If !lRet
			cTexto += cFileIn+"- Nใo foi prossํvel processar o arquivo. Verifique log em "+cFileOut+CHR(13)+CHR(10)
		Else
			cTexto += cFileIn+"- Arquivo processado com sucesso. Verifique log em "+cFileOut+CHR(13)+CHR(10)
		Endif
	EndIf	
	
Next

If !lJob
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
Endif	


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
Static Function CTS017GetFile(cFileIn, cFileOut,cDirOut)

Local cAux := ""

cFileIn := Lower(AllTrim(cFileIn))

If Upper(SubStr(cFileIn,Len(cFileIn)-2,3)) <> "CSV"
	cFileIn  := Space(256)
	cFileOut := Space(256)
	Return(.F.)
Endif

cFileIn  := PadR(Upper(cFileIn),256)
cFileOut := cDirOut+PadR(StrTran(cFileOut,".CSV","_"+DtoS(Date())+"_"+StrTran(Substr(time(),1,5),":","")+".LOG"),256)

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
Static Function CTS017GetDir(aDirIn,cDirIn,cTipo)
Local cAux := ""

cDirIn := IIF(!Empty(cAux:=(cGetFile("\", "Diret๓rios", 1,"X:\" ,.F. , GETF_RETDIRECTORY+GETF_LOCALHARD ))),cAux,cDirIn)

If cTipo == "I"
	aDirIn := Directory(cDirIn+"*.CSV")
EndIf

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
Static Function CTS017Proc(cArquivo, nHandle, nHandleErr,lJob )

Local aCampos		:= {}
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
Local lRetProc		:= .T.

Default	cArquivo	:= ""

If !File(cArquivo)
	cMsgLog := cArquivo+";"+"Arquivo de entrada nใo localizado"+ CRLF
	FWrite(nHandle, cMsgLog )
	Return(.F.)
Endif

//Estrutura do Arquivo
Aadd( aCampos, {"PEDIDO"		,	"C", 07, 0} ) //01
Aadd( aCampos, {"CPF_CNPJ"		,	"C", 14, 0} ) //02
Aadd( aCampos, {"N_CARTAO"		,	"C", 16, 0} ) //03
Aadd( aCampos, {"TRANSACTION"	,	"C", 20, 0} ) //04
Aadd( aCampos, {"COD_AUT"		,	"C", 06, 0} ) //05
Aadd( aCampos, {"BANDEIRA"		,	"C", 17, 0} ) //06
Aadd( aCampos, {"PARCELAS"		,	"C", 02, 0} ) //07
Aadd( aCampos, {"VALOR_TOTAL"	,	"C", 17, 0} ) //08

FT_FUSE(cArquivo)

If FT_FEOF()
	FT_FUSE()
	cMsgLog := cArquivo+";"+"Arquivo invalido ou vazio..." + CRLF
	FWrite(nHandle, cMsgLog )
	Return(.F.)
Endif

If !lJob
	nTotRec := FT_FLASTREC()
	BarGauge2Set( nTotRec )
EndIf

FT_FGOTOP()

While !FT_FEOF()
	
	If !lJob
		IncprocG2( "Importando Registro "+AllTrim(Str(nRecAtu++))+" de "+AllTrim(Str(nTotRec)) )
		ProcessMessage()
	EndIf
	
	xBuff:=alltrim(FT_FREADLN())
	xBuff:=Iif(left(xBuff,Len(xBuff))==",", Rigth(xBuff,Len(xBuff)-1) , xBuff )
	
	If !Empty(xBuff)
		aLin 	:= StrTokArr(xBuff,",")
		
		If Len(aLin) <> Len(aCampos)
		   	cMsgLog := Alltrim(cArquivo)+";"+AllTrim(Strzero(nRecAtu,6))+";00;Estrututa da linha difere do Layout definido"+ CRLF
			FWrite(nHandle, cMsgLog  )
		   	FT_FSKIP()
			Loop					
		EndIf
	
		cPedGar := ALLTRIM(aLin[1])
		cCrtArq := ALLTRIM(aLin[3])
		cVlrArq := ALLTRIM(aLin[8])
		cVldArq := ALLTRIM(aLin[5])
		cBanArq := ALLTRIM(SubStr(aLin[6],3,len(aLin[6])))
		cParArq := ALLTRIM(aLin[7])
		cIDCC	:= ALLTRIM(aLin[4])
		cDatArq := ""
		 
		cVlrArq := iif(Right(cVlrArq,5)== ".0000",StrTran(cVlrArq,".",","),cVlrArq+",0000")
		
		If UPPER(ALLTRIM(SubStr(aLin[6],1,2))) = "C_"
			lRetProc := u_AtuCCPed("1",alltrim(cArquivo),cPedGar,cCrtArq,cVlrArq,cVldArq,cBanArq,cParArq,cDatArq,nHandle,0,nRecAtu,.T.,"","","",cIDCC)
			
			If !lRetProc
				FWrite(nHandleErr, xBuff+Chr(13)+Chr(10) )	
			EndIf	
		Else
			cMsgLog := cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";00;Linha Desconsiderada"+ CRLF
			FWrite(nHandle, cMsgLog  )
		EndIf
	Else
		cMsgLog :=  cArquivo+";"+AllTrim(Strzero(nRecAtu,6))+";01;Linha do arquivo em branco." + CRLF
		FWrite(nHandle, cMsgLog  )		
	EndIf
	FT_FSKIP()
Enddo

FT_FUSE()

Return(.T.)                          