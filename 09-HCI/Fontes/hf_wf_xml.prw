#INCLUDE "XMLXFUN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH" 

#DEFINE MAXJOBNOAR 1   

Static __nConecta

User Function WF_XML01()

Local aRotina   	:= {}
Local aEntidades	:= {}
Local nX        	:= 0
Local nY        	:= 0
Local nW        	:= 0
Local nZ        	:= 0
Local nJobs     	:= 1

Local cHoraIni  	:= ""
Local cHoraFim  	:= ""
Local lOk       	:= .F.
Local lStartUp  	:= .T.
Local nStartUp  	:= 0

Local aParams       := {}  
Local cError        := ""  

Private cMsgModelo  	:= "[XML]"
Private cThreadID	:= "0"
Private nSleepJob 	:= 0

LoadParams(@aParams,@cError,.T.)
                                    
cEnable             := aParams[1][2]
aEntidades          := aParams[2][2]
nStartUp        	:= aParams[3][2]
cThreadID	     	:= aParams[4][2]
nSleepJob           := aParams[6][2]

/*
If cEnable == "0" 
	ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","")+" Job XML desabilitado...")
	For nZ := 0 To nSleepJob
		Sleep(1000)
		If KillApp()
			Exit
		EndIf
	Next nZ
	Return(nil)
EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Tratamento para Jobs                                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While !KillApp()
	cHoraIni   := "00:00:01"
	cHoraFim   := "23:59:59"
	aRotina    := {} 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica se a Rotina deve ser executada                            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	LoadParams(@aParams,@cError,.T.)
	                                    
	cEnable             := aParams[1][2]
	//aEntidades          := aParams[2][2]
	aEntidades  		:= LoadSm0( aParams[2][2] )
	nStartUp        	:= aParams[3][2]
	cThreadID	     	:= aParams[4][2]
	nSleepJob           := aParams[6][2]	
	
	cIdJobs   := aParams[5][2]
	aadd(aRotina,{"U_XMLWF01A",cIdJobs})     
	
	If cEnable <> "0" 		
		For nX := 1 To Len(aRotina)
			For nY := 1 To nJobs
				For nW := 1 To Len(aEntidades)
	//				StartJob(aRotina[nX][1],GetEnvServer(),.T.,aEntidades[nW],aRotina[nX][2])
					U_XMLWF01A(aEntidades[nW],aRotina[nX][2])
					If nX == 1 .And. lStartup
						Sleep(nStartUp)
					Else
						Sleep(1000)
					EndIf
				Next nW
			Next nY
		Next nX
	Else
		ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","")+" Job XML desabilitado...")
	EndIf
	lStartUp := .F.
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Espera                                                             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nZ := 0 To nSleepJob
		Sleep(1000)
		If KillApp()
			Exit
		EndIf
	Next nZ
	
	If KillApp()
		Exit
	EndIf
EndDo
Return(nil)

/*/
/*/
User Function XMLWF01A( cIdEnt, cIDJob )

//Local cIdEnt := "0101"
//Local cIDJob := "X"

Local lContinua   := .T.
Local lQuebra     := .F.
Local lSchema     := .F.
Local lFalhou     := .F.
Local lWS         := .F.
Local cTimeSPEDWF := Time()
Local cArqLck     := ""

Local cXML        := ""
Local cXmlCabMsg  := ""
Local cXmlDados   := ""
Local cXmlProt    := ""
Local cXmlLote    := ""
Local cModelo     := ""
Local nXmlSize    := 0
Local nCountMail  := 0
Local nAmbiente   := 0
Local nModalidade := 0
Local nMaxFor     := 0
Local cNfe        := ""
Local cIdLote     := ""
Local cErro       := "" 
Local cAviso      := ""
Local cCodSta     := ""
Local cMsgSta     := ""
Local cProtocolo  := ""
Local cAnexo      := ""
Local cAnexo2     := ""
Local cMailError  := ""
Local cTime       := ""
Local cTempoMedio := ""
Local nHandle     := 0
Local nHdlXml     := 0
Local nHdlXml2    := 0
Local nLote       := 0
Local nX          := 0
Local nY          := 0
Local nCount      := 0
Local nTotalCount := 0
Local nTimes      := 1
Local nMemory     := 1
Local nEspera     := 0
Local oWs
Local cEmailDest  :=""
Local cXmlRPS     := ""
Local cXmlErros   := ""
Local lIssNet     := .F.
Local lContrEnv   := .F.
Local cURLNFSe    := ""
Local cAssunto    := "" 
Local cExpModelo  := ""


Local lErroSch	  := .F. 
Local cEmp      := Substr(cIdEnt,1,2)
Local cFilEmp   := Substr(cIdEnt,3,len(cIdEnt)-2)	 
Local oProcess  := Nil
Local lEnd     := .F. 

Local aParams       := {}  
Local cError        := ""  
                 
Local cDir      := ""
Local cDirLog   := ""
Local cURL      := ""
Local cBar      := "" //Iif(lUnix,"/","\")
Private cDatahora  	:= 	""
Private cMsgModelo  	:= "[XML]"
Private cThreadID	:= "0"
Private nSleepJob 	:= 0
Private oProcess  := Nil
Private lEnd      := .F. 
Private lAuto     := .T.
Private cLogProc  := ""


LoadParams(@aParams,@cError,.T.)
                                    
cEnable             := aParams[1][2]
//aEntidades          := aParams[2][2]
nStartUp        	:= aParams[3][2]
cThreadID	     	:= aParams[4][2]
nSleepJob           := aParams[6][2]
cHF_WF              := aParams[7][2]

ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","")+" Carregando Parametros...")

If cEnable == "0" 
	ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","")+" Job XML desabilitado...")
	
	For nZ := 0 To nSleepJob
		Sleep(1000)
		If KillApp()
			Exit
		EndIf
	Next nZ
	Return(nil)
EndIf
RpcClearEnv()
RpcSetType(3)
//PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFilEmp MODULO "COM" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
IF .NOT. RpcSetEnv( cEmp, cFilEmp,,,"COM",,{ "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1" },.F.,.F.)
	If cHF_WF>="1"
		ConOut("[IMPXML] " + "JOB ("+cIdEnt+"): Não Foi Possível estabelecer conexão com a empresa.")
	EndIf
	DelClassIntf()
	RpcClearEnv()
	RESET ENVIRONMENT
EndIf
cBar     := Iif(IsSrvUnix(),"/","\")
cDir     := AllTrim(SuperGetMv("MV_X_PATHX"))                     
cDir 	 := StrTran(cDir,cBar+cBar,cBar)
cDirLog  := AllTrim(cDir+cBar+"Log"+cBar)                     
cDirLog	 := StrTran(cDirLog,cBar+cBar,cBar)
cURL     := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf

/*Cria arquivo de Lock dependendo do modelo a ser processado*/
cArqLck     := GetPathSemaforo()+"HFWFXML01"+cIdEnt+"_X"+".LCK"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Controle de execucao. Nao permite que o mesmo JOB seja inicializado mais³
//³de uma vez                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeDir(GetPathSemaforo())

/*
If File(cArqLck)
   	If (nHandle := FOpen(cArqLck,16)) < 0
		lContinua := .F.
	EndIf
Else
	If ( nHandle := FCreate(cArqLck)) < 0
		lContinua := .F.
	EndIf
EndIf
*/
If lContinua
  
 	While (nTimes <= MAXJOBNOAR .And. nMemory <= MAXJOBNOAR) .And. !KillApp() .And. nTotalCount<=100
		cLogProc := ""
		cDatahora  	:= 	dTos(date()) +"-"+ Substr(Time(),1,2) + "-" + Substr(Time(),4,2)
		Conout(1,"WF Integracao XML - Emp: "+cIdEnt+" - Job: X - Times: "+StrZero(nTimes,2)+" - Total: "+StrZero(nTotalCount,3))
		
		If cHF_WF>="1"
			ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "JOB ("+cIdEnt+"): X Times: "+AllTrim(Str(nTimes,10))+" Memory: "+AllTrim(Str(nMemory,10))+ " Time: "+cTimeSPEDWF)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 1                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "1" $ cIDJob .Or. "X" $ cIDJob
  			nCount := 0
			cTime  := Time()

			U_AutoXml1(1,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "Verificando e-mails ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf		
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 6 => Posto Antes do 2 para se baixar ja fazer a importação          ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "6" $ cIDJob .Or. "X" $ cIDJob
			nCount := 0
			cTime  := Time()	

			U_AutoXml1(6,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "Download XML ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf		
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 2                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "2" $ cIDJob .Or. "X" $ cIDJob
			nCount := 0
			cTime  := Time()

			U_AutoXml1(2,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "Processando XMLs ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 3                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "3" $ cIDJob .Or. "X" $ cIDJob
			nCount := 0
			cTime  := Time()	

			U_AutoXml1(3,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "Status XMLs ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf		
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 4                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "4" $ cIDJob .Or. "X" $ cIDJob
			nCount := 0
			cTime  := Time()	

			cDtCons := GetNewPar("XM_DT_CONS","20120101")
			cHrCons := GetNewPar("XM_HR_CONS","22:00")
			
			If cDtCons <= Dtos(dDataBase) .And. Time() >= cHrCons
				U_AutoXml1(4,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)
				PutMv("XM_DT_CONS",dTos(dDataBase))
			EndIf            

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "Consulta XMLs ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf		
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 5                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If "5" $ cIDJob .Or. "X" $ cIDJob
			nCount := 0
			cTime  := Time()	

			U_AutoXml1(5,lAuto,@lEnd,oProcess,@cLogProc,@nCount,cUrl)

			If cHF_WF=="1" .Or. (cHF_WF=="2" .And. nCount>0 )
				ConOut(cMsgModelo + IIF(cThreadID=="1","[ThreadID:"+AllTrim(Str(ThreadID(),10))+"] ","") + "E-mails de Notificações ("+cIdEnt+"-"+cTime+" a "+Time()+"): "+AllTrim(Str(nCount,10)))
			EndIf		
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Job 6                                                                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		//Colocado Antes do 2


		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Rotina de espera de processamento - importante para o consumo da CPU    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbCommit()
		cTimeSPEDWF := Time()
		DelClassIntf()

		If !ExistDir(cDirLog)
			Makedir(cDirLog)
		EndIf		
		MemoWrite(cDirLog+"XML-"+cDataHora+".log",cLogProc)

		nMaxFor := IIf(nTimes==0,10,IIf(nTimes==1,nSleepJob,nSleepJob*2))
		If nTimes <> 0
			Conout(1,"WF Integracao XML - Emp: "+cIdEnt+" - Job: X - Sleeping...("+StrZero(nMaxFor,3)+")")
		EndIf
		For nY := 1 To nMaxFor
  				Sleep(1000)
			If KillApp()
				Exit
			EndIf
		Next nY                                   
		nTimes++
		nMemory++

	EndDo

EndIf

RstMvBuff()
DelClassIntf()
RpcClearEnv()
RESET ENVIRONMENT

Return(.T.)




Static Function LoadParams(aParams,cError,lDefault)
Local lRet       := .T.          
Local cRootPath  := GetSrvProfString("ROOTPATH","")
Local cStartPath := GetSrvProfString("STARTPATH","")
Local cFileCfg   := "hfcfgxml001a.xml"
Local aInfo      := {}
Local aDados     := {}
Local cLinha     := ""           
Local lBreak     := .F.
Local cEnv       := GetEnvServer()            
Private oXml

Default lDefault := .F.
                 
If File(cFileCfg)

	oXml := U_LoadCfgX(1,cFileCfg,)

	If oXml == Nil
		Return	
	EndIf
	cENABLE  := AllTrim(oXml:_MAIN:_WFXML01:_ENABLE:_XTEXT:TEXT)
	cENT     := AllTrim(oXml:_MAIN:_WFXML01:_ENT:_XTEXT:TEXT)
	nWFDELAY := Val(oXml:_MAIN:_WFXML01:_WFDELAY:_XTEXT:TEXT)
	cTHREADID:= AllTrim(oXml:_MAIN:_WFXML01:_THREADID:_XTEXT:TEXT)
	nSLEEP   := Val(oXml:_MAIN:_WFXML01:_SLEEP:_XTEXT:TEXT)
	cConsole := AllTrim(oXml:_MAIN:_WFXML01:_CONSOLE:_XTEXT:TEXT)

    If ValType(oXml:_MAIN:_WFXML01:_JOBS:_JOB)=="A"
		aJobs    := oXml:_MAIN:_WFXML01:_JOBS:_JOB    
	Else
		aJobs    := {oXml:_MAIN:_WFXML01:_JOBS:_JOB}	
	EndIf

	cJOBS    := ""
	For Nx:=1 To Len(aJobs)
		cJOBS    += aJobs[Nx]:_XTEXT:TEXT
		If Nx < Len(aJobs)
			cJOBS    += ","
		EndIf				
	Next	
	
	Aadd(aDados,{"ENABLE"  ,cENABLE   		,"Servico Habilitado" 					}) 
	Aadd(aDados,{"ENT"     ,{cENT}  		,"Empresa/Filial principal do processo" }) 
	Aadd(aDados,{"WFDELAY" ,nWFDELAY   		,"Atraso apos a primeira execucao"   	}) 
	Aadd(aDados,{"THREADID",cTHREADID  		,"Indentificador de Thread [Debug]"   	}) 
	Aadd(aDados,{"JOBS"    ,cJOBS   		,"Servico a ser processado" 			}) 
	Aadd(aDados,{"SLEEP"   ,nSLEEP    		,"Tempo de espera"   					}) 
	Aadd(aDados,{"CONSOLE" ,cConsole   		,"Informacoes dos processos no console" }) 

Else	

	Aadd(aDados,{"ENABLE"  ,"1"		   		,"Servico Habilitado" 					}) 
	Aadd(aDados,{"ENT"     ,{"99"}  		,"Empresa/Filial principal do processo" }) 
	Aadd(aDados,{"WFDELAY" ,10 		   		,"Atraso apos a primeira execucao"   	}) 
	Aadd(aDados,{"THREADID","1"		   		,"Indentificador de Thread [Debug]"   	}) 
	Aadd(aDados,{"JOBS"    ,"X"		   		,"Servico a ser processado" 			}) 
	Aadd(aDados,{"SLEEP"   ,600	    		,"Tempo de espera"   					}) 
	Aadd(aDados,{"CONSOLE" ,"1"		   		,"Informacoes dos processos no console" }) 

EndIf                      

aParams := aDados

Return(lRet)           



Static Function LoadSm0( aENT )
Local aRet := {} //aENT
Local aSm0 := {}
Local aSm2 := {}
Local cEmp := ""
Local cFil := ""
Local nI   := 0
aRet := aClone( aENT )
If Len( aENT ) >= 1

	cEmp := Substr(aENT[1],1,2)
	cFil := Substr(aENT[1],3,len(aENT[1])-2)  //4-2 = 2

	ConOut("Abrindo empresa "+cEmp+" para executar FWLoadSM0(). ")

	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO "COM" TABLES "SA1"

	aSm0 := FWLoadSM0()
	if Len( aSm0 ) > 0

		aRet := {}
		For nI := 1 To Len( aSm0 )
			if empty( aRet ) .or. aScan( aSm2, aSm0[nI][1] ) == 0
				aadd( aRet, aSm0[nI][1]+aSm0[nI][2] )
				aadd( aSm2, aSm0[nI][1] )
			endif
		Next nI

	EndIf

	DelClassIntf()
	RpcClearEnv()
	RESET ENVIRONMENT
	
EndIf

Return( aRet )


Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_WF_XML01()
        U_XMLWF01A()
	EndIF
Return(lRecursa)
