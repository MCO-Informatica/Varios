#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWIZARD.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "RPTDEF.CH"  
#INCLUDE "TBICONN.CH"  
#INCLUDE "AP5MAIL.CH"

Static __nHdlSMTP := 0

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³           ³ Autor ³Roberto Souza        ³ Data ³27/06/2011 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HFXML04()  
Local oDlg
Local nX	  := 0
Local aHead1  := {}
Local aHead2  := {}
Local aParams := {}
Local nstyle  := GD_UPDATE
Local cFileCfg:= "hfcfgxml001a.xml"
//Local cStyle  := "Q3Frame{ border-style:solid }"
Local aParJob := {}
Local nLin    := 0
Local nCol    := 0
Local i       := 0
Local j       := 0
Local y       := 1
Local aX      := {}
Local cCoord  := "040,003,005,027,047,045,026,350,568"
Local oSay1
Local oProcess := Nil
Local lDebugKey:= AllTrim(GetSrvProfString("HF_DEBUGKEY","0"))=="1"
Local lMailAdv := .T. // AllTrim(GetSrvProfString("HF_ENABLEIMAP","0"))=="1"
Local cURL     := "" 
Local cVerTSS  := "" 
Local cIdEnt   := ""
Private oXml
Private oGet1
Private aCols1 := {}                             
Private aCols2 := {}                             
Private VISUAL := .F.
Private INCLUI := .F.
Private ALTERA := .F.
Private DELETA := .F.
Private aPages := {"Configurações Job","E-mail/SMTP","Notificações","Gerais","Gerais(2)","Ferramentas"}
Private aPages := {"Configurações Job","E-mail/SMTP","E-mail/POP","Notificações","Gerais","Gerais(2)","Ferramentas","Avançado","Info"}
Private oFont01:= TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
Private oFont02:= TFont():New("Lucida Console",07,14,,.T.,,,,.T.,.F.)
Private oFont03:= TFont():New("Courier",07,14,,.T.,,,,.T.,.F.) 

Private nPageCfg := aScan(aPages,{|x| x == "Configurações Job"})
Private nPageSMTP:= aScan(aPages,{|x| x == "E-mail/SMTP"})
Private nPagePOP := aScan(aPages,{|x| x == "E-mail/POP"})
Private nPageNot := aScan(aPages,{|x| x == "Notificações"})
Private nPageGer := aScan(aPages,{|x| x == "Gerais"})
Private nPageGerII := aScan(aPages,{|x| x == "Gerais(2)"})
Private nPageTool:= aScan(aPages,{|x| x == "Ferramentas"})
Private nPageAdv := aScan(aPages,{|x| x == "Avançado"})
Private nPageInfo:= aScan(aPages,{|x| x == "Info"})
Private cENABLE,cENT,nWFDELAY,cTHREADID,cJOBS,nSLEEP,cCONSOLE                               
Private oENABLE,oENT,oWFDELAY,oTHREADID,oJOBS,oSLEEP,oCONSOLE                               
Private aCombo := {}
Private aCombo2 := {}
Private aCombo3 := {}
Private aCombo4 := {}
Private aCombo5 := {}
Private aCombo6 := {}   
Private aCombo7 := {}
Private aCombo8 := {}
Private aCombo9 := {}
Private aCombo10:= {}
Private aCombo11:= {}
Private aCombo12:= {}
Private aCombo13:= {}
Private aCombo14:= {}
Private aCombo15:= {}
Private aInfo := U_GetverIX()
Private aFilsEmp := {}

aAdd( aCombo, "0=Desabilitado" )
aAdd( aCombo, "1=Habilitado" )

aAdd( aCombo2, "S=Sim" )
aAdd( aCombo2, "N=Não" )
                        
aAdd( aCombo3, "0=Doc Original" )
aAdd( aCombo3, "6=6 Dígitos"    )             
aAdd( aCombo3, "9=9 Dígitos"    )
 
aAdd( aCombo4, "0=Sempre Perguntar")
aAdd( aCombo4, "1=Padrão(SA5/SA7)" )
aAdd( aCombo4, "2=Customizada(ZB5)")
aAdd( aCombo4, "3=Sem Amarração"   )
aAdd( aCombo4, "4=Por Pedido"      )

aAdd( aCombo5, "0=Não Utiliza"  )
aAdd( aCombo5, "1=SMTP"         )             
aAdd( aCombo5, "2=IMAP"         )

aAdd( aCombo6, "0=Não Utiliza"  )
aAdd( aCombo6, "1=POP"         )             
aAdd( aCombo6, "2=IMAP"         )

/*
aAdd( aCombo7, "0=Nenhuma ação")
aAdd( aCombo7, "1=Alterar Pré-Nota")             
aAdd( aCombo7, "2=Classificar NF")
aAdd( aCombo7, "3=Alterar Pré-Nota e Classificar NF")
aAdd( aCombo7, "4=Sempre Perguntar")                                                                              
*/

aAdd( aCombo7, "0=Nenhuma ação")
aAdd( aCombo7, "1=Classificar NF")
aAdd( aCombo7, "2=Sempre Perguntar")                                                                                                                                                                                                

aAdd( aCombo8, "1=Pré-Nota")
aAdd( aCombo8, "2=Rec Carga")                                                                                                                                                                                                
aAdd( aCombo8, "3=Pré-Nota + Rec Carga") 
aAdd( aCombo8, "4=Pré-Nota + Nt C.Frete") 
aAdd( aCombo8, "5=Rec Carga+ Nt C.Frete") 
aAdd( aCombo8, "6=Todos") 


aAdd( aCombo9, "S=Sim" )
aAdd( aCombo9, "N=Não" )
aAdd( aCombo9, "0=Remetente" )
aAdd( aCombo9, "1=Expedidor" )
aAdd( aCombo9, "2=Recebedor" )
aAdd( aCombo9, "3=Destinatario" )

aAdd( aCombo10, "S=Pedido Compra" )
aAdd( aCombo10, "N=Cad. Produto" )
aAdd( aCombo10, "A=Ambos" )

aAdd( aCombo11, "S=Sim" )
aAdd( aCombo11, "N=Não" )

aAdd( aCombo12, "1=Imp XML" )
aAdd( aCombo12, "2=TSS    " )

aAdd( aCombo13, "S=Sim" )
aAdd( aCombo13, "N=Não" )
aAdd( aCombo13, "Z=Zerar" )

aAdd( aCombo14, "1=Pré-Nota" )
aAdd( aCombo14, "2=Documento de Entrada" )

aAdd( aCombo15, "N=Não Manifestar" )
aAdd( aCombo15, "1=Confirmação da Operação" )
aAdd( aCombo15, "2=Ciência da Operação" )

If lDebugKey
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
	RpcSetType(3)
EndIf

//aFilsEmp := U_XGetFilS(SM0->M0_CGC)
lUsoOk    := U_HFXML00X("HF000001","101",SM0->M0_CGC)
nFormNfe  := Val(GetNewPar("XM_FORMNFE","6"))
cURL      := AllTrim(GetNewPar("XM_URL",""))
If Empty(cURL)
	cURL  := AllTrim(SuperGetMv("MV_SPEDURL"))
EndIf
cIdEnt    := U_GetIdEnt()

U_VerTSS(cUrl,@cVerTSS,.T.)
If !lUsoOk
	Return(.T.)
EndIf

RetSqlCond("SA2")
	MsgRun("Carregando definições...",,{|| CursorWait(),oXml:=U_LoadCfgX(1,,),Sleep(1000),CursorArrow()})
	DEFINE MSDIALOG oDlg TITLE "Configuracoes Importa XML" FROM 000,000 TO 430,800 PIXEL STYLE DS_MODALFRAME STATUS

	oPage := TFolder():New(002,002,aPages,{},oDlg,,,,.T.,.F.,350,210,)
    
	ShowLogo(aPages)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Definicoes Job                                                         ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    
	aDefs  := {}
	aParJob := GetJobInfo(1)                              
	If oXml == Nil
		Return	
	EndIf
	cENABLE  := PadR(oXml:_MAIN:_WFXML01:_ENABLE:_XTEXT:TEXT,25)
	cENT     := PadR(oXml:_MAIN:_WFXML01:_ENT:_XTEXT:TEXT,25)
	nWFDELAY := Val(oXml:_MAIN:_WFXML01:_WFDELAY:_XTEXT:TEXT)
	cTHREADID:= PadR(oXml:_MAIN:_WFXML01:_THREADID:_XTEXT:TEXT,25)
	nSLEEP   := Val(oXml:_MAIN:_WFXML01:_SLEEP:_XTEXT:TEXT)
	cConsole := PadR(oXml:_MAIN:_WFXML01:_CONSOLE:_XTEXT:TEXT,25)

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
	cJOBS    := PadR(cJOBS,25)

	nDiasRet  := Val(GetNewPar("XM_D_CANCEL","3"))
	cHrCons   := GetNewPar("XM_HR_CONS","22:00")
	
	Aadd(aDefs,{"ENABLE"  ,cENABLE   		,"Servico Habilitado" 					}) 
	Aadd(aDefs,{"ENT"     ,cENT  			,"Empresa/Filial principal do processo" }) 
	Aadd(aDefs,{"WFDELAY" ,nWFDELAY    		,"Atraso apos a primeira execucao"   	}) 
	Aadd(aDefs,{"THREADID",cTHREADID   		,"Indentificador de Thread [Debug]"   	}) 
	Aadd(aDefs,{"JOBS"    ,cJOBS   			,"Servico a ser processado" 			}) 
	Aadd(aDefs,{"SLEEP"   ,nSLEEP    		,"Tempo de espera"   					}) 
	Aadd(aDefs,{"CONSOLE" ,cConsole   		,"Informacoes dos processos no console" }) 
	
	nPosG1    := 000.50
	nPosG2    := 002.50
	nPosInc   := 002.125

	/*** Linha 1 ***/
	@ nPosG1,00.5 to nPosG2,020 OF oPage:aDialogs[nPageCfg]    
	@ 010  ,010 Say oXml:_MAIN:_WFXML01:_ENABLE:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 018  ,010 COMBOBOX oEnable VAR cEnable ITEMS aCombo SIZE 100,10 PIXEL OF oPage:aDialogs[nPageCfg] 

	@ nPosG1,20.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    
	@ 010  ,170 Say oXml:_MAIN:_WFXML01:_SLEEP:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 018  ,170 MSGet oSleep VAR nSleep SIZE 100,08 PICTURE "999999" PIXEL OF oPage:aDialogs[nPageCfg]                   

	/*** Linha 2 ***/
	nPosG1    += nPosInc
	nPosG2    += nPosInc

	@ nPosG1,00.5 to nPosG2,020 OF oPage:aDialogs[nPageCfg]    
	@ 040  ,010 Say oXml:_MAIN:_WFXML01:_ENT:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 048  ,010 MSGet oEnt VAR cEnt F3 "EMP" SIZE 100,08 OF oPage:aDialogs[nPageCfg] F3 "SM0" PIXEL

	@ nPosG1,20.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    
	@ 040  ,170 Say oXml:_MAIN:_WFXML01:_CONSOLE:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 048  ,170 COMBOBOX oConsole VAR cConsole ITEMS aCombo SIZE 100,10 PIXEL OF oPage:aDialogs[nPageCfg] 

	/*** Linha 3 ***/              
	nPosG1    += nPosInc
	nPosG2    += nPosInc

	@ nPosG1,00.5 to nPosG2,020 OF oPage:aDialogs[nPageCfg]    
	@ 070  ,010 Say oXml:_MAIN:_WFXML01:_WFDELAY:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 078  ,010 Get oWfdelay VAR nWfdelay SIZE 100,08  PICTURE "999999" PIXEL OF oPage:aDialogs[nPageCfg]                   

	@ nPosG1,20.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    
	@ 070  ,170 Say "Serviços [Jobs]" PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 078  ,170 Get oJobs VAR cJobs SIZE 100,08 PIXEL OF oPage:aDialogs[nPageCfg] READONLY                  
	@ 078  ,270 Button "..." Size 010,011 PIXEL OF oPage:aDialogs[nPageCfg] ACTION (cJobs:=U_GetJob(cJobs))
		


	/*** Linha 4 ***/
	nPosG1    += nPosInc
	nPosG2    += nPosInc

	@ nPosG1,00.5 to nPosG2,020 OF oPage:aDialogs[nPageCfg]    
	@ 100  ,010 Say oXml:_MAIN:_WFXML01:_THREADID:_XDESC:TEXT  PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 108  ,010 COMBOBOX oTHREADID VAR cTHREADID ITEMS aCombo SIZE 100,10 PIXEL OF oPage:aDialogs[nPageCfg] 
 
	@ nPosG1,20.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    
	@ 100  ,170 Say "Dias Consulta " PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 108  ,170 Get oDiasRet VAR nDiasRet SIZE 15,08  PICTURE "99" PIXEL OF oPage:aDialogs[nPageCfg] VALID  (nDiasRet >= 0 .And. nDiasRet <= 30)                 

	@ 100  ,230 Say "Hora Consulta" PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
	@ 108  ,230 Get oHrCons VAR cHrCons SIZE 40,08  PICTURE "@E 99:99" PIXEL OF oPage:aDialogs[nPageCfg]               

   	cTip := "Informe quantos dias o sistema deve retroagir para consultar " +CRLF
	cTip += "xml, verificando se houve cancelamento posterior ao recebimento "+CRLF
	cTip += "e processamento do XML. "+CRLF
	cTip += "O recomendado é 1 dia. "
	oDiasRet:cToolTip := cTip

   	cTip := "Hora programada de execução da consulta XML na SEFAZ."+CRLF
	cTip += "Preencher no formato HH:MM ."
	oHrCons:cToolTip := cTip

	@ nPosG1,20.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    

	/*** Linha 5 ***/
//	nPosG1    += nPosInc
//	nPosG2    += nPosInc

//	@ nPosG1,00.5 to nPosG2,020 OF oPage:aDialogs[nPageCfg]    
//	@ 130  ,010 Say "Serviços [Jobs]" PIXEL OF oPage:aDialogs[nPageCfg] COLOR CLR_BLUE FONT oFont01
//	@ 138  ,010 Get oJobs VAR cJobs SIZE 100,10 PIXEL OF oPage:aDialogs[nPageCfg]                   
	                 
	nPosG1    += nPosInc
	nPosG2    += nPosInc + 1

	@ nPosG1,00.5 to nPosG2,040 OF oPage:aDialogs[nPageCfg]    	
                           	
	@ 150,270 Button "Confirma" Size 045,015 PIXEL OF oPage:aDialogs[nPageCfg] ACTION ;
		MsgRun("Salvando definições...",,{|| CursorWait(),SetDefs(cENABLE,cENT,nWFDELAY,cTHREADID,cJOBS,nSLEEP,cConsole,nDiasRet,cHrCons),Sleep(1000),CursorArrow()})
		                                                

	lOnJob := (aParJob[1][3]=="INATIVO") 
	oBtJob := TButton():New(150,010,Iif(lOnJob,"Ativar Job .ini","Desativar Job .ini"),oPage:aDialogs[nPageCfg],;
				{|| Iif(lOnJob,GetJobInfo(2),GetJobInfo(3) ),;
				aParJob:=GetJobInfo(1),;
				lOnJob := (aParJob[1][3]=="INATIVO") ,;
				oBtJob:CCAPTION:=Iif(lOnJob,"Ativar Job .ini","Desativar Job .ini") ,;
				oBtJob:Refresh()  },;
				70,15,,oFont01,.F.,.T.,.F.,,.F.,,,.F.)   	
		     

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configuracoes E-mail SMTP                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                 
	oMailServer := Nil
	oLogin      := Nil
	oMailConta  := Nil
	oMailSenha  := Nil
	oSMTPAuth   := Nil
	oSSL        := Nil
	oTLS        := Nil   //aquuiiiiiii

	aSmtp       := U_XCfgMail(1,1,{})
	
	cMailServer := aSmtp[1] //Padr(GetNewPar("XM_SMTP",Space(40)),40)
	cLogin      := aSmtp[2] //Padr(GetNewPar("XM_LOGIN",Space(40)),40)
	cMailConta  := aSmtp[3] //Padr(GetNewPar("XM_ACCOUNT",Space(40)),40)
	cMailSenha  := aSmtp[4] //Padr(Decode64(GetNewPar("XM_PASS",Space(25))),25)
	lSMTPAuth   := aSmtp[5] //GetNewPar("XM_AUT",Space(1))=="S"
	lSSL        := aSmtp[6] //GetNewPar("XM_SSL",Space(1))=="S"                                     
	cProtocolE  := aSmtp[7] //GetNewPar("XM_PROTENV","0")
	cPortEnv    := aSmtp[8] //GetNewPar("XM_ENVPORT","0")
	lTLS        := aSmtp[9] //GetNewPar("XM_TLS",Space(1))=="S"                 //aquuiiiiii

	@ 00.5,00.5 to 012,043 OF oPage:aDialogs[nPageSMTP]
	
	If lMailAdv 

		@ 010,010 Say "Protocolo de Envio : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 018,010 COMBOBOX  oProtocolE VAR cProtocolE ITEMS aCombo5 SIZE 150,10 PIXEL OF oPage:aDialogs[nPageSMTP]

//		@ 010,010 Say "Servidor SMTP : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
//		@ 018,010 Get  oMailServer VAR cMailServer SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]
	
		@ 035,010 Say "Servidor de Envio: "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 043,010 Get  oMailServer VAR cMailServer SIZE 120,08 PIXEL OF oPage:aDialogs[nPageSMTP]

		@ 035,130 Say "Porta: "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 043,130 Get  oPortEnv VAR cPortEnv SIZE 30,08 PIXEL OF oPage:aDialogs[nPageSMTP]
	
		@ 060,010 Say "Login : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 068,010 Get oLogin VAR cLogin SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]             
	
		@ 085,010 Say "Conta de E-mail : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 093,010 Get oMailConta VAR cMailConta SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]                   
	
		@ 110,010 Say "Senha : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 118,010 Get oMailSenha VAR cMailSenha SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP] PASSWORD
	
		@ 135,010 Say "Servidor Requer Autenticação : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 134,140 CHECKBOX oSMTPAuth VAR lSMTPAuth PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]
	
		@ 145,010 Say "Usa Conexão Segura (SSL) : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 144,140 CHECKBOX oSSL VAR lSSL PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]

		@ 155,010 Say "Usa Conexão Segura (TLS) : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 154,140 CHECKBOX oTLS VAR lTLS PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]

	Else
		@ 010,010 Say "Servidor SMTP : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 018,010 Get  oMailServer VAR cMailServer SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]
	
		@ 040,010 Say "Login : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 048,010 Get oLogin VAR cLogin SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]             
	
		@ 070,010 Say "Conta de E-mail : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 078,010 Get oMailConta VAR cMailConta SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP]                   
	
		@ 100,010 Say "Senha : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 108,010 Get oMailSenha VAR cMailSenha SIZE 150,08 PIXEL OF oPage:aDialogs[nPageSMTP] PASSWORD
	
		@ 131,010 Say "Servidor Requer Autenticação : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 130,140 CHECKBOX oSMTPAuth VAR lSMTPAuth PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]
	
		@ 144,010 Say "Usa Conexão Segura (SSL) : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 144,140 CHECKBOX oSSL VAR lSSL PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]

		@ 155,010 Say "Usa Conexão Segura (TLS) : "  PIXEL OF oPage:aDialogs[nPageSMTP] COLOR CLR_BLUE FONT oFont01
		@ 154,140 CHECKBOX oTLS VAR lTLS PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPageSMTP]
	EndIf
	@ 150,250 Button "Testar" Size 040,015 PIXEL OF oPage:aDialogs[nPageSMTP] ACTION (TestMail(cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL,cProtocolE,cPortEnv))	     
	@ 150,300 Button "Salvar" Size 040,015 PIXEL OF oPage:aDialogs[nPageSMTP] ACTION (SetMail(1,2,cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL,cProtocolE,cPortEnv,lTLS))  //aquuii	     
         
                   

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configuracoes E-mail POP                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
                                 
	oServerPOP  := Nil
	oLoginPOP   := Nil
	oPOPConta   := Nil
	oPOPSenha   := Nil
	oPOPAuth    := Nil
	oPOPSSL     := Nil    
	
	aPop        := U_XCfgMail(2,1,{})

	cServerPOP  := aPop[1] //Padr(GetNewPar("XM_POPIMAP",Space(40)),40)
	cLoginPOP   := aPop[2] //""//Padr(GetNewPar("XM_LOGIN"  ,Space(40)),40)
	cPOPConta   := aPop[3] //Padr(GetNewPar("XM_POPACC" ,Space(40)),40)
	cPOPPass    := aPop[4] //Padr(Decode64(GetNewPar("XM_POPPASS",Space(25))),25)
	lPOPAuth    := aPop[5] //GetNewPar("XM_POPAUT",Space(1))=="S"
	lPOPSSL     := aPop[6] //GetNewPar("XM_POPSSL",Space(1))=="S"
	cProtocolR  := aPop[7] //GetNewPar("XM_PROTREC","0")
	cPortRec    := aPop[8] //GetNewPar("XM_RECPORT","0")                                     
	/* 
	AADD(aSx6,{"  ","XM_POPIMAP","C","Endereço POP/IMAP de Recebimento de XML Fornecedor"	,"","","","","","","","","","","","",""})
	AADD(aSx6,{"  ","XM_POPACC" ,"C","Conta de Email de Recebimento de XML Fornecedor."		,"","","","","","","","","","","","",""})
	AADD(aSx6,{"  ","XM_POPPASS","C","Senha da Conta de Recebimento de XML Fornecedor."		,"","","","","","","","","","","","",""})
	AADD(aSx6,{"  ","XM_POPAUT" ,"C","Informa se e-mail utiliza autenticação."				,"","","","","","","","","","","","",""})
	AADD(aSx6,{"  ","XM_POPSSL" ,"C","Informa se e-mail utiliza conexao segura."			,"","","","","","","","","","","","",""})
	*/
	@ 00.5,00.5 to 012,043 OF oPage:aDialogs[nPagePOP]
	
	If lMailAdv 
	
		@ 010,010 Say "Protocolo de Recebimento : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 018,010 COMBOBOX  oProtocolR VAR cProtocolR ITEMS aCombo6 SIZE 150,10 PIXEL OF oPage:aDialogs[nPagePOP]

		@ 035,010 Say "Servidor de Recebimento  : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 043,010 Get oServerPOP VAR cServerPOP SIZE 120,08 PIXEL OF oPage:aDialogs[nPagePOP]

		@ 035,130 Say "Porta: "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 043,130 Get  oPortRec VAR cPortRec SIZE 30,08 PIXEL OF oPage:aDialogs[nPagePOP] 
/*			
		@ 060,010 Say "Login : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 068,010 Get oLoginPOP VAR cLoginPOP SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]                  
	
		@ 085,010 Say "Conta de E-mail : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 093,010 Get oPOPConta VAR cPOPConta SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]                   
	
		@ 110,010 Say "Senha : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 118,010 Get oPOPPass VAR cPOPPass SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP] PASSWORD
	
		@ 135,010 Say "Servidor Requer Autenticação : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 134,140 CHECKBOX oPOPAuth VAR lPOPAuth PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]
	
		@ 150,010 Say "Usa Conexão Segura (SSL) : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 149,140 CHECKBOX oPOPSSL VAR lPOPSSL PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]
 */
 
		@ 060,010 Say "Login / Conta de E-mail : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 068,010 Get oPOPConta VAR cPOPConta SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]                   
	
		@ 085,010 Say "Senha : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 093,010 Get oPOPPass VAR cPOPPass SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP] PASSWORD
	
		@ 110,010 Say "Servidor Requer Autenticação : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 109,140 CHECKBOX oPOPAuth VAR lPOPAuth PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]
	
		@ 125,010 Say "Usa Conexão Segura (SSL) : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 124,140 CHECKBOX oPOPSSL VAR lPOPSSL PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]
		
	Else
		@ 010,010 Say "Servidor POP : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 018,010 Get oServerPOP VAR cServerPOP SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]
	
		@ 040,010 Say "Login : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 048,010 Get oLoginPOP VAR cLoginPOP SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]                  
	
		@ 070,010 Say "Conta de E-mail : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 078,010 Get oPOPConta VAR cPOPConta SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP]                   
	
		@ 100,010 Say "Senha : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 108,010 Get oPOPPass VAR cPOPPass SIZE 150,08 PIXEL OF oPage:aDialogs[nPagePOP] PASSWORD
	
		@ 131,010 Say "Servidor Requer Autenticação : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 130,140 CHECKBOX oPOPAuth VAR lPOPAuth PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]
	
		@ 146,010 Say "Usa Conexão Segura (SSL) : "  PIXEL OF oPage:aDialogs[nPagePOP] COLOR CLR_BLUE FONT oFont01
		@ 145,140 CHECKBOX oPOPSSL VAR lPOPSSL PROMPT "" SIZE 65,8 PIXEL OF oPage:aDialogs[nPagePOP]

	EndIf
//	@ 150,250 Button "Testar" Size 040,015 PIXEL OF oPage:aDialogs[nPagePOP] ACTION (TestMail(cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL))	     
	@ 150,300 Button "Salvar" Size 040,015 PIXEL OF oPage:aDialogs[nPagePOP] ACTION (SetMail(2,2,cServerPOP,cLoginPOP,cPOPConta,cPOPPass,lPOPAuth,lPOPSSL,cProtocolR,cPortRec))	     
         



	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configurações de notificacao                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//	oMail01, oMail02, oMail03, oMail04, oMail05
	cMail01 := Padr(GetNewPar("XM_MAIL01",Space(256)),256)
	cMail02 := Padr(GetNewPar("XM_MAIL02",Space(256)),256)
	cMail03 := Padr(GetNewPar("XM_MAIL03",Space(256)),256)
	cMail04 := Padr(GetNewPar("XM_MAIL04",Space(256)),256)
	cMail05 := Padr(GetNewPar("XM_MAIL05",Space(256)),256)					             
	
	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageNot]

	@ 010,010 Say "E-mail - Cancelamento de Nota: " PIXEL OF oPage:aDialogs[nPageNot] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oMail01 VAR cMail01 SIZE 150,08 PIXEL OF oPage:aDialogs[nPageNot]                   

	@ 040,010 Say "E-mail - Erros de importação: "  PIXEL OF oPage:aDialogs[nPageNot] COLOR CLR_BLUE FONT oFont01
	@ 048,010 Get oMail02 VAR cMail02 SIZE 150,08 PIXEL OF oPage:aDialogs[nPageNot] 

	@ 070,010 Say "E-Mail - Falha Geração Pré-Nota c/ Ped.Recorrente: "  PIXEL OF oPage:aDialogs[nPageNot] COLOR CLR_BLUE FONT oFont01
	@ 078,010 Get oMail03 VAR cMail03 SIZE 150,08 PIXEL OF oPage:aDialogs[nPageNot] 

/*
	@ 100,010 Say "E-Mail 4: "  PIXEL OF oPage:aDialogs[nPageNot] COLOR CLR_BLUE FONT oFont01
	@ 108,010 Get oMail04 VAR cMail04 SIZE 150,08 PIXEL OF oPage:aDialogs[nPageNot] 

	@ 130,010 Say "E-Mail 5: "  PIXEL OF oPage:aDialogs[nPageNot] COLOR CLR_BLUE FONT oFont01
	@ 138,010 Get oMail05 VAR cMail05 SIZE 150,08 PIXEL OF oPage:aDialogs[nPageNot] 		                                                                                                   
  
*/
	@ 150,300 Button "Salvar" Size 040,015 PIXEL OF oPage:aDialogs[nPageNot] ACTION (SetCfgMail(cMail01, cMail02, cMail03, cMail04, cMail05))	     


/*                                                                                   
	label1 := 'QLabel("&lt;h2&gt;Hello&lt;/h2&gt;")'
	label2 := 'QLabel("&lt;h2 style=\"color: #3000FF\"&gt;World...&lt;/h2&gt;")'                                       
	label3 := "Q3Frame{ border-style:solid }"
	
	oradio := Nil
	nradio := 1
	aRadio := {"Estilo 1","Estilo 2","Estilo 3"} 
	@ 30, 170 RADIO oRadio VAR nRadio ITEMS ;
		 aRadio[1],; 
		 aRadio[2],; 
		 aRadio[3]; 
		 SIZE 65,8 PIXEL OF ;
         oPage:aDialogs[nPageNot] ;
         ON CHANGE (SetCss( &("label"+AllTrim(Str(nRadio))) ))
*/

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configurações Gerais                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nOpcFile := GETF_RETDIRECTORY
	cPathx   := Padr(GetNewPar("MV_X_PATHX",Space(256)),256)
	cSubFil  := GetNewPar("XM_DIRFIL" ,"S")
	cSubCnpj := GetNewPar("XM_DIRCNPJ","S")
	cSubXML  := GetNewPar("XM_DIRMOD" ,"S")
	cMostra  := GetNewPar("MV_MOSTRAA","N")
	cFormNfe := GetNewPar("XM_FORMNFE","6")
	cFormCTe := GetNewPar("XM_FORMCTE","6")
	cForceCte:= GetNewPar("XM_FORCET3","N")
	cPedido  := GetNewPar("XM_PED_PRE","N")

	cCfDevol := Padr(GetNewPar("XM_CFDEVOL",Space(256)),256)
	cCfBenef := Padr(GetNewPar("XM_CFBENEF",Space(256)),256)
	cAmarra  := GetNewPar("XM_DE_PARA","0")

	cDayStat := PadR(GetNewPar("XM_D_STATUS","3"),3)
	cDayCanc := PadR(GetNewPar("XM_D_CANCEL","1"),3)

	cCfgPre  := GetNewPar("XM_CFGPRE","0")
	cTipPre  := GetNewPar("XM_TIP_PRE","1")
	cFilUsu  := GetNewPar("XM_FIL_USU","N")
	cUrlTss  := Padr(GetNewPar("XM_URL",Space(256)),256)
	cCteDet  := GetNewPar("XM_CTE_DET","N")
	cNfOri   := GetNewPar("XM_NFORI","N")
	cCSol    := GetNewPar("XM_CSOL","A")
	cCCNfOr  := GetNewPar("XM_CCNFOR","N")

	@ 00.5,00.5 To 012,043.5 OF oPage:aDialogs[nPageGer]
  //		@ 00.5,00.5 To 006,043 OF oPage:aDialogs[nPageGer]
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 1                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	@ 010,010 Say "Diretorio XML: " PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oPathX VAR cPathx SIZE 90,08 PIXEL OF oPage:aDialogs[nPageGer]                   
	@ 018,100 BUTTON "..."                      SIZE 010,11 PIXEL OF oPage:aDialogs[nPageGer] ACTION (cPathx:=AllTrim(cGetFile("*.*",,,,.T.,nOpcFile)),ValdGetDir(@cPathx))
  
	@ 010,120 Say "Formato Doc [NF-e]: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 018,120 COMBOBOX oFormNfe VAR cFormNfe ITEMS aCombo3 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 	
		
	@ 010,230 Say "Formato Doc [CT-e]: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 018,230 COMBOBOX oFormCte VAR cFormCte ITEMS aCombo3 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
  	//³ Linha 2                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	

	@ 032,010 Say "SubDiretorio por Tipo de XML: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 040,010 COMBOBOX oSubXML VAR cSubXML ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
	
	@ 032,120 Say "SubDiretorio por filial: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 040,120 COMBOBOX oSubFil VAR cSubFil ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 

	@ 032,230 Say "SubDiretorio por Emitente [CNPJ]: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 040,230 COMBOBOX oSubCNPJ VAR cSubCNPJ ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
     
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 3                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	@ 054,010 Say "Mostra consulta Sefaz: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 062,010 COMBOBOX oMostra VAR cMostra ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 

	@ 054,120 Say "Força Tomador CT-e: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 062,120 COMBOBOX oForceCte VAR cForceCte ITEMS aCombo9 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 

    cTip := "Informe se força a busca pelo papel do tomador do CT-e." +CRLF
	cTip += "A Tag <TOMA3> define o papel do tomador."+CRLF
	cTip += "Habilitar esta opção faz com que seja buscado nos outros elementos do CT-e "+CRLF
	cTip += "quando o Tomador indicado pela TAG não for a empresa."
	oForceCte:cToolTip := cTip

	@ 054,230 Say "Assume pedido na Pré-nota: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 062,230 COMBOBOX oPedido VAR cPedido ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
 
    cTip := "Na consulta de pedido por item <F6> na geração de Pré-nota assume os valores de Pedido." +CRLF
	cTip += "Caso esteja como não mantém os valores do XML."
	oPedido:cToolTip := cTip
                                 
 	     
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 4                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
	@ 076,010 Say "CFOP Devolução: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 084,010 Get oCfDevol VAR cCfDevol SIZE 100,08 PIXEL OF oPage:aDialogs[nPageGer]                    

    cTip := "Informe os CFOPs utilizados para entrada de devolução." +CRLF
	cTip += "Deve-se informar os códigos separados por ';'"+CRLF
	cTip += "Exemplo 5959;5949;6959;6949 ."
	oCfDevol:cToolTip := cTip

	@ 076,120 Say "CFOP Beneficiamento: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 084,120 Get oCfBenef VAR cCfBenef SIZE 100,08 PIXEL OF oPage:aDialogs[nPageGer]           

	cTip := "Informe os CFOPs utilizados para entrada de beneficiamento." +CRLF
	cTip += "Deve-se informar os códigos separados por ';'"+CRLF
	cTip += "Exemplo 5959;5949;6959;6949 ."
	oCfBenef:cToolTip := cTip

	@ 076,230 Say "Amarração de produtos: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 084,230 COMBOBOX oAmarra VAR cAmarra ITEMS aCombo4 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
 
	cTip := "Selecione o modo de amarração DE/PARA de produtos ." +CRLF
	cTip += "na geração de pré-nota de NF-e."
	oAmarra:cToolTip := cTip
	
 
 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 5                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
 	@ 098,010 Say "Dias p/ Ajuste de Status:"  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 106,010 Get oDayStat VAR cDayStat SIZE 100,08 PICTURE "999" PIXEL OF oPage:aDialogs[nPageGer]                    

   	cTip := "Informe quantos dias o sistema deve retroagir para verificar " +CRLF
	cTip += "os status dos xml quanto a geração e classificação de Pré-notas."+CRLF
	cTip += "Esta verificação é feita automaticamente ao utilizar a opção "+CRLF
	cTip += "'Baixar Xml' no menu padrão do Importa Xml."+CRLF	
	cTip += "Quanto menor o número de dias mais rápido a rotina é executada."	

	oDayStat:cToolTip := cTip
	

	@ 098,120 Say "Ação após inclusão de Pré-nota:"  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 106,120 COMBOBOX oCfgPre VAR cCfgPre ITEMS aCombo7 SIZE 100,08 PIXEL OF oPage:aDialogs[nPageGer]                    
   	cTip := "Informe a ação padrão a ser tomada após a inclusão com sucesso " +CRLF
	cTip += "da pré-nota de entrada à partir de Xml de fornecedor."+CRLF
	cTip += "As respectivas telas de edição irão aparecer assim que confirmar a inclusão. "
	
	oCfgPre:cToolTip := cTip


	@ 098,230 Say "Tipo de Pré-nota:"  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 106,230 COMBOBOX oTipPre VAR cTipPre ITEMS aCombo8 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer] 
 
	cTip := "Informe o Tipo de Pré-nota a ser gerada." +CRLF
	cTip += "1-Pré-nota 2-Aviso Recebto Carga 3-Ambos"+CRLF
	cTip += "4-Pré-nota + Nt Conhecimento Frete"+CRLF
	cTip += "5-Aviso Recbto Carga + Nt Conhec Frete"+CRLF
	cTip += "6-Todos."
	oTipPre:cToolTip := cTip


 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 6                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ	
 	@ 120,010 Say "Filtra Filial do Usuário:" PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 128,010 COMBOBOX oFilUsu VAR cFilUsu ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer]                    

   	cTip := "Filtrar XMLs da filial de acordo com o especificado no cadastro" +CRLF
	cTip += "de usuário. Administradores não filtra filial."

	oFilUsu:cToolTip := cTip


	@ 120,120 Say "URL TSS: "  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 128,120 Get oUrlTss VAR cUrlTss SIZE 100,08 PIXEL OF oPage:aDialogs[nPageGer]

	cTip := "Informe a URL do TSS que será utilizado para o importa XML." + CRLF
	cTip += "com a devida porta. Exemplo http://192.168.1.100:8081/" + CRLF
	cTip += "Caso fique em branco será utilizado o parametro MV_SPEDURL."
	oUrlTss:cToolTip := cTip 
	

 	@ 120,230 Say "Detalhar Itens(NF) no CT-e:" PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 128,230 COMBOBOX oCteDet VAR cCteDet ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer]                    

   	cTip := "Detalhar CT-e em itens as NFs que deram origem ao CT-e " +CRLF
	cTip += "conforme TAG <infNF> do remetente."
	oCteDet:cToolTip := cTip


 	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 7                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 142,010 Say "NF Entr. Origem L.Fiscais? (CT-e):"  PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 150,010 COMBOBOX oNfOri VAR cNfOri ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer]

   	cTip := "Se SIM Busca Notas Entrada p/ Origem nos Livros Fiscais (SF3)." +CRLF
	cTip += "Se NÃO Busca Notas Saida p/ Origem (SF2). Para detalhes CT-e." +CRLF
	cTip += "Obs: Ao Selecionar o tipo de pré-nota Nt Conhec Frete será " +CRLF
	cTip += "     assumido como SIM, pois a rotina padrão assim o exige."
	oNfOri:cToolTip := cTip

 	@ 142,120 Say "De onde amarra Centro Custo?:" PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 150,120 COMBOBOX oCSol VAR cCSol ITEMS aCombo10 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGer]
   	cTip := "Se S=Pedido: utiliza Centro de Custo do Pedido Compra através de F5 ou F6." +CRLF
	cTip += "Se N=C.Prod: utiliza Centro de Custo do Cadastro de Produto."+CRLF
	cTip += "Se A=Ambos: utiliza do Cad.Produto ao gerar a Pré-Nota e do Pedido"+CRLF
	cTip += "ao Seleciona-lo com as Teclas F5 ou F6."
	oCSol:cToolTip := cTip

 	@ 142,230 Say "(CTe) C.C. NF Origem?:" PIXEL OF oPage:aDialogs[nPageGer] COLOR CLR_BLUE FONT oFont01
	@ 150,230 COMBOBOX oCCNfOr VAR cCCNfOr ITEMS aCombo2 SIZE 50,10 PIXEL OF oPage:aDialogs[nPageGer]                    
   	cTip := "Para CTE amarrar centro de custo pela" +CRLF
	cTip += "NF de origem do CT-e"
	oCCNfOr:cToolTip := cTip

	@ 150,300 Button "Salvar" Size 040,015 PIXEL OF oPage:aDialogs[nPageGer] ACTION (SetCfgGer(cPathx, cSubFil, cSubCNPJ, cMostra,cFormNfe,cFormCTe,cSubxml,cForceCte,cPedido,cCfDevol,cCfBenef,cAmarra,cDayStat,cCfgPre,cTipPre,cFilUsu,cUrlTss,cCteDet,cNfOri,cCSol,cCCNfOr))
    
    //incluido configuraçoes aba Gerais 2 - Alexandro de Oliveira - 25/11/2014 
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configurações Gerais 2                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSerEmp    := Padr(GetNewPar("XM_SEREMP",Space(256)),256)
	_cSerXML   := GetNewPar("XM_SERXML","N")
	_cTravPrN  := GetNewPar("XM_PED_GBR","N")
	cRotCon    := GetNewPar("XM_ROT_CON","1")
	cConMod    := GetNewPar("XM_GRBMOD","N")
	cPedRec    := GetNewPar("XM_PEDREC","N")
	cRecDoc    := GetNewPar("XM_RECDOC","1")
	cTabRec    := Padr(GetNewPar("XM_TABREC",Space(3)),3)
	cXmlSef    := GetNewPar("XM_XMLSEF","N")
	cManPre    := GetNewPar("XM_MANPRE","N")
	cLogoDan   := GetNewPar("XM_LOGOD" ,"N")

	@ 00.5,00.5 To 012,043.5 OF oPage:aDialogs[nPageGerII]
   	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 1                                                  ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 010,010 Say "Série Por Empresa:" PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 018,010 Get oSerEmp VAR cSerEmp SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
   	cTip := "Série padrão para empresa para a importação do XML substituindo a" +CRLF
	cTip += "série que vem no XML. EX: SP todo XML será importado com série SP" +CRLF
	cTip += "a pré-nota será gravada também com esta série, e a série original" +CRLF
	cTip += "ficará gravada no campo a parte na tabela. Série Padrão p/ Filial" +CRLF
	cTip += "EX:SP=01,03;ES=02,05. Neste exemplo as filiais 01 e 03 terão suas" +CRLF
	cTip += "séries como SP e as filiais 02 e 05 terão suas séries ES, e a" +CRLF
	cTip += "filial 04 será importado com a Série Original." +CRLF
	cTip += "OBS: Para manter somente a Série Original do XML deixar VAZIO."
	oSerEmp:cToolTip := cTip
	
	@ 010,120 Say "Serie XML Vazia para 0: " PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01 
	@ 018,120 COMBOBOX  oSerXML VAR _cSerXML ITEMS aCombo13 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]                  
  	cTip := "SIM para importar a Série 0 como Vazia." +CRLF
	cTip += "NAO permanece a série 0." +CRLF
	cTip += "ZERAR para importar a Série vazia com o 0." +CRLF
	cTip += "OBS: Caso a série seja diferente de 0 permanece a série normal."
	oSerXML:cToolTip := cTip 

	@ 010,230 Say "Travar Pré-Nota: " PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01 
	@ 018,230 COMBOBOX  oTravPrN VAR _cTravPrN ITEMS aCombo11 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]                  
	cTip := "SIM - Quando valor total do XML for diferente do Lançado" +CRLF
	cTip += "na pré-nota, não deixará gravar o lançamento." +CRLF
	cTip += "NÂO - O usuário escolherá se grava a pré-nota ou não" +CRLF
	cTip += "quando o total for diferente."
	oTravPrN:cToolTip := cTip 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 2                                                ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 032,010 Say "Rotina Consulta Sefaz:" PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 040,010 COMBOBOX oRotCon VAR cRotCon ITEMS aCombo12 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
   	cTip := "1 - Consulta ao Sefaz Pela Rotina do importa XML" +CRLF
   	cTip += "2 - Consulta ao Sefaz Pela Rotina Padrão do TSS" +CRLF
   	cTip += "OBS: Na consulta pela rotina do importa, se a resposta" +CRLF
   	cTip += "for negativa, será feita uma consulta pelo TSS. " +CRLF
   	cTip += "A rotina do importa também esta no repositório do TSS," +CRLF
   	cTip += "então a Patch do TSS deverá ter sido aplicada."
	oRotCon:cToolTip := cTip 

	@ 032,120 Say "Consulta Todas Modalidades: " PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01 
	@ 040,120 COMBOBOX  oConMod VAR cConMod ITEMS aCombo11 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]                  
   	cTip := "SIM quando a resposta da consulta for negativa" +CRLF
	cTip += "será consultada em todas as modalidades pela " +CRLF
	cTip += "rotina do TSS."
	oConMod:cToolTip := cTip 

	@ 032,230 Say "Utiliza Pedido Recorrente: " PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01 
	@ 040,230 COMBOBOX oPedRec VAR cPedRec ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
	cTip := "Habilitará a Função de Pedido Recorrente," +CRLF
	cTip += "a qual a pré-nota será gerada automaticamente" +CRLF
	cTip += "ao importar o XML para o sistema, desde que o" +CRLF
	cTip += "fornecedor e produto tenham pedido amarrado e" +CRLF
	cTip += "com saldo."
	oPedRec:cToolTip := cTip

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 3                                                ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 	@ 054,010 Say "Tabela Pedido Recorrente:"  PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 062,010 Get oTabRec VAR cTabRec SIZE 100,08 PICTURE "!!!" PIXEL OF oPage:aDialogs[nPageGerII]                    
   	cTip := "Tabela de amarração do fornecedor" +CRLF
	cTip += "com o seu pedido recorrente."
	oTabRec:cToolTip := cTip

	@ 054,120 Say "Tipo Doc. Pedido Recorrente:" PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 062,120 COMBOBOX oRecDoc VAR cRecDoc ITEMS aCombo14 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
   	cTip := "Tipo de Documento a ser gerado por pedido Recorrente:" +CRLF
   	cTip += "1 - Pré-Nota;" +CRLF
   	cTip += "2 - Documento de Entrada (Classificado)."
	oRecDoc:cToolTip := cTip 

	@ 054,230 Say "Compara XML com a SEFAZ: " PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01 
	@ 062,230 COMBOBOX oXmlSef VAR cXmlSef ITEMS aCombo2 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
	cTip := "Habilitará a Função de Comparação do XML" +CRLF
	cTip += "baixado por e-mail com o XML da SEFAZ." +CRLF
	cTip += "As TAGs para comparar deverão ser informadas" +CRLF
	cTip += "no arquivo TagNfe.Cfg na pasta CFG dentro do" +CRLF
	cTip += "diretório definido no parâmetro MV_X_PATHX." +CRLF
	cTip += "EX: \Protheus_Data\xmlsource\Cfg\TagNfe.Cfg"
	oXmlSef:cToolTip := cTip

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Linha 4                                                ³
 	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 076,010 Say "Manifestação ao gerar pré-nota:" PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 084,010 COMBOBOX oManPre VAR cManPre ITEMS aCombo15 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
   	cTip := "Tipo de Manifestação ao gerar a pré-nota:" +CRLF
   	cTip += "N - Não Manifestar;" +CRLF
   	cTip += "1 - Confirmar Operação;" +CRLF
   	cTip += "2 - Ciência da Operação."
	oManPre:cToolTip := cTip 

	@ 076,120 Say "Emissão do Logo na Danfe:" PIXEL OF oPage:aDialogs[nPageGerII] COLOR CLR_BLUE FONT oFont01
	@ 084,120 COMBOBOX oLogoDan VAR cLogoDan ITEMS aCombo11 SIZE 100,10 PIXEL OF oPage:aDialogs[nPageGerII]
   	cTip := "Se na emissão da danfe aparece o logo:" +CRLF
   	cTip += "S - Sim aparece;" +CRLF
   	cTip += "N - Não aparece;" +CRLF
	oLogoDan:cToolTip := cTip 


	@ 150,300 Button "Salvar" Size 040,015 PIXEL OF oPage:aDialogs[nPageGerII] ACTION (SetCfgGerII(cSerEmp,_cSerXML,_cTravPrN,cRotCon,cConMod,cPedRec,cTabRec,cRecDoc,cXmlSef,cManPre,cLogoDan))
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Configurações Ferramentas                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageTool]
	@ 010,010 Button "Atualiza"+CRLF+"Status XML" Size 070,020 PIXEL OF oPage:aDialogs[nPageTool];
	 ACTION (Processa({|lEnd| U_UPStatXML(.F.,@lEnd,oProcess)} ,"Processando...","Atualizando Status...",.T.))

	@ 040,010 Button "Atualiza"+CRLF+"Fornecedor XML" Size 070,020 PIXEL OF oPage:aDialogs[nPageTool];
	 ACTION (Processa({|lEnd| U_UPForXML(.F.,@lEnd,oProcess)} ,"Processando...","Atualizando Dados...",.T.))

	@ 070,010 Button "Consulta XML"+CRLF+"Sefaz" Size 070,020 PIXEL OF oPage:aDialogs[nPageTool];
	 ACTION (Processa({|lEnd| U_UPConsXML(.F.,@lEnd,oProcess)} ,"Processando...","Consultando XML's...",.T.))

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Avançado                                                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 00.5,00.5 To 012  ,043 OF oPage:aDialogs[nPageAdv]
	@ 010,010 Button "Configuração"+CRLF+"'Baixar Xml'" Size 070,020 PIXEL OF oPage:aDialogs[nPageAdv];
	 ACTION U_UPCfgXML()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Info                                                                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	@ 00.5,00.5 To 012,043 OF oPage:aDialogs[nPageInfo]
//    aInfo := U_GetverIX()                           
    cProd := "Importa XML "
    dVencLic := Stod(Space(8))
 	lUsoOk := U_HFXML00X("HF000001","101",SM0->M0_CGC,@dVencLic)  
 	                                                                  
	@ 01.0, 01 To 004.5, 021 PROMPT "Importa XML " OF oPage:aDialogs[nPageInfo]
	@ 025,015 Say "Versão......:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 035,015 Say "Compilação..:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 045,015 Say "TSS Importa.:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03

	@ 025,065 Say aInfo[1][2] PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 035,065 Say aInfo[2][2] PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 045,065 Say aInfo[5][2] PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03

	@ 01.0, 21.5 To 004.5, 042 PROMPT "TSS - Totvs Services Sped " OF oPage:aDialogs[nPageInfo]
	@ 025,180 Say "URL.........:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 035,180 Say "Versão......:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 045,180 Say "Entidade....:" PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	
	@ 025,230 Say cURL PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 035,230 Say cVerTSS PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 045,230 Say cIdEnt PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03


	@ 04.8, 01 To 011.5, 042 PROMPT "Liberação " OF oPage:aDialogs[nPageInfo]
	@ 075,015 Say "Empresa......: " PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 085,015 Say "Cnpj.........: " PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03
	@ 095,015 Say "Vencimento...: " PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_BLUE FONT oFont03

	@ 075,065 Say SM0->M0_NOMECOM PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 085,065 Say SM0->M0_CGC PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03
	@ 095,065 Say Dtoc(dVencLic) PIXEL OF oPage:aDialogs[nPageInfo] COLOR CLR_RED FONT oFont03

	@ 012,355 Button "Sair" Size 040,015 PIXEL OF oDlg ACTION oDlg:End()
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT (nOpca := 0,.T.)


//RESET ENVIRONMENT                                     
Return                                              
      

Static Function ValdGetDir(cPathx)
Local lret := .T.
Local _lUnix := IsSrvUnix() /*Informa se Application Server está sendo executado em ambiente Unix®, Linux® ou Microsoft Windows®.*/

if .Not. upper("xmlsource") $ upper(cPathx)
	cPathx := StrTran(cPathx,"xmlsource","")
EndIf
if empty(cPathx)
    if _lUnix 
    	cPathx:= cPathx+"\xmlsource\"
		cPathx := StrTran(cPathx,"\","/")
	else 
		cPathx:= cPathx+"\xmlsource\"
		cPathx := "\"+cPathx+"\"
		cPathx := StrTran(cPathx,"\\\\","\")
		cPathx := StrTran(cPathx,"\\\","\")
		cPathx := StrTran(cPathx,"\\","\")
	endif	 
endif

Return(lRet)



Static Function SetDefs(cENABLE,cENT,nWFDELAY,cTHREADID,cJOBS,nSLEEP,cConsole,nDiasRet,cHrCons)
Local aDefs   := {}
Local Nx      := 0
Local cFileX  := "hfcfgxml001a.xml"
Local cXmlCfg := ""

	Aadd(aDefs,{"ENABLE"  ,cENABLE   		,"Servico Habilitado"                     }) 
	Aadd(aDefs,{"ENT"     ,cENT  			,"Empresa/Filial principal do processo"   }) 
	Aadd(aDefs,{"WFDELAY" ,nWFDELAY    		,"Atraso apos a primeira execucao"   }) 
	Aadd(aDefs,{"THREADID",cTHREADID   		,"Indentificador de Thread [Debug]"   }) 
	Aadd(aDefs,{"JOBS"    ,Separa(cJobs,","),"Servico a ser processado"   }) 
	Aadd(aDefs,{"SLEEP"   ,nSLEEP    		,"Tempo de espera"   }) 
	Aadd(aDefs,{"CONSOLE" ,cConsole   		,"Informacoes dos processos no console"   }) 
	
	cXmlCfg := U_LoadCfgX(2,cFileX,aDefs)
	If !Empty(cXmlCfg)
    	MemoWrite(cFileX,cXmlCfg)
	EndIf
 	/********************************/
	cDayCanc:= StrZero(nDiasRet,2)
	If !PutMv("XM_D_CANCEL", cDayCanc ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_D_CANCEL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Dias a retroceder para consultar XML na SEFAZ."
		MsUnLock()
		PutMv("XM_D_CANCEL", cDayCanc ) 
	EndIf

	If !PutMv("XM_HR_CONS", cHrCons ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_HR_CONS"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Hora programada de execução da consulta XML na SEFAZ.
		MsUnLock()
		PutMv("XM_HR_CONS", cHrCons ) 
	EndIf
		
Return


Static Function SetMail(nTipo,nOpc,cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL,cProtocol,cPort,lTLS)  //aquii
Local aRet := {}
Local cError := ""
Local nret   := 0 
Local cret   := ""
aRet :=U_XCfgMail(nTipo,nOpc,{cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL,cProtocol,cPort,lTLS})  //aquuii

If nOpc == 2 .And. nRet == 0
	MsgInfo("Configurações de E-mail atualizadas com sucesso!")
EndIf
Return
      

Static Function SetCfgMail(cMail01, cMail02, cMail03, cMail04, cMail05)
Local Nx := 0

For Nx:=1 to 5
	

	If !PutMv("XM_MAIL" + StrZero(Nx,2), &("cMail"+ StrZero(Nx,2)) )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := cFilAnt
		SX6->X6_VAR     := "XM_MAIL" + StrZero(Nx,2)
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "E-mail para notificaçao de eventos."
		MsUnLock()
		PutMv("XM_MAIL" + StrZero(Nx,2), &("cMail"+ StrZero(Nx,2)) )
	EndIf

Next

MsgInfo("Configurações de E-mail atualizadas com sucesso!")

Return


Static Function SetCfgGer(cPathx, cSubFil, cSubCNPJ, cMostra,cFormNfe,cFormCTe,cSubXml,cForceCte,cPedido,cCfDevol,cCfBenef,cAmarra,cDayStat,cCfgPre,cTipPre,cFilUsu,cUrlTss,cCteDet,cNfOri,cCSol,cCCNfOr)
Local Nx := 0
Local cError     := ""


	If !PutMv("MV_X_PATHX", cPathx ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "MV_X_PATHX"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Diretorio Raiz dos XMLs importados."  
		MsUnLock()
		PutMv("MV_X_PATHX", cPathx ) 
	EndIf
	/********************************/
	If !PutMv("XM_DIRFIL", cSubFil ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_DIRFIL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Informa se cria diretorio por Filial do cliente." 
		MsUnLock()
		PutMv("XM_DIRFIL", cSubFil ) 
	EndIf
	
	/********************************/
	If !PutMv("XM_DIRCNPJ", cSubCnpj ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_DIRCNPJ"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Informa se cria diretorio por CNPJ do emitente." 
		MsUnLock()
		PutMv("XM_DIRCNPJ", cSubCnpj ) 
	EndIf
	/********************************/
	If !PutMv("XM_DIRMOD", cSubXml ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_DIRMOD"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Informa se cria diretorio por modelo de XML."
		MsUnLock()
		PutMv("XM_DIRMOD", cSubXml ) 
	EndIf
	/********************************/
	If !PutMv("MV_MOSTRAA", cMostra ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "MV_MOSTRAA"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Mostra todas Consultas junto a Sefaz S ou N."
		MsUnLock()
		PutMv("MV_MOSTRAA", cMostra ) 
	EndIf

	/********************************/
	If !PutMv("XM_FORMNFE", cFormNfe ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_FORMNFE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Formato do campo Documento/Nota fiscal para NF-e." 
		MsUnLock()
		PutMv("XM_FORMNFE", cFormNfe ) 
	EndIf
	     
	/********************************/
	If !PutMv("XM_FORMCTE", cFormCTe ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_FORMCTE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Formato do campo Documento/Nota fiscal para CT-e." 
		MsUnLock()
		PutMv("XM_FORMCTE", cFormCTe ) 
	EndIf	

	/********************************/
	If !PutMv("XM_FORCET3", cForceCte ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_FORCET3"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Informa se força a busca pelo tomador do CT-e." 
		MsUnLock()
		PutMv("XM_FORCET3", cForceCte ) 
	EndIf	 
	/********************************/
	If !PutMv("XM_PED_PRE", cPedido ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_PED_PRE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Informa se assume valores do pedido na Pre-nota."
		MsUnLock()
		PutMv("XM_PED_PRE", cPedido ) 
	EndIf
	/********************************/
	If !PutMv("XM_CFDEVOL", cCfDevol ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CFDEVOL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Cfops de devolução em entradas de NF-e."
		MsUnLock()
		PutMv("XM_CFDEVOL", cCfDevol ) 
	EndIf
 
	/********************************/
	If !PutMv("XM_CFBENEF", cCfBenef ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CFBENEF"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Cfops de beneficiamento em entradas de NF-e."
		MsUnLock()
		PutMv("XM_CFBENEF", cCfBenef ) 
	EndIf

 
	/********************************/
	If !PutMv("XM_DE_PARA", cAmarra ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_DE_PARA"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Tipo de seleção de amarração de produto."
		MsUnLock()
		PutMv("XM_DE_PARA", cAmarra ) 
	EndIf
	

	/********************************/
	If !PutMv("XM_D_STATUS", cDayStat ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_D_STATUS"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Dias a retroceder para verificar Status XML." 
		MsUnLock()
		PutMv("XM_D_STATUS", cDayStat ) 
	EndIf

	/********************************/
	If !PutMv("XM_CFGPRE", cCfgPre ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CFGPRE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Define a ação após a geração de pré-nota"
		MsUnLock()
		PutMv("XM_CFGPRE", cCfgPre ) 
	EndIf	

	/********************************/
	If !PutMv("XM_TIP_PRE", cTipPre ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_TIP_PRE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Tipo de pré-nota"
		MsUnLock()
		PutMv("XM_TIP_PRE", cTipPre ) 
	EndIf	

	/********************************/
	If !PutMv("XM_FIL_USU", cFilUsu ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_FIL_USU"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Filtra Filial por Usuário"
		MsUnLock()
		PutMv("XM_FIL_USU", cFilUsu ) 
	EndIf	

	/********************************/
	If !PutMv("XM_URL", cUrlTss )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_URL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "URL do TSS a qual será utilizado pelo importa."
		MsUnLock()
		PutMv("XM_URL", cUrlTss ) 
	EndIf	

	/********************************/
	If !PutMv("XM_CTE_DET", cCteDet )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CTE_DET"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Detalha Notas Fiscias nos itens de CTE."
		MsUnLock()
		PutMv("XM_CTE_DET", cCteDet ) 
	EndIf	

	/********************************/
	If !PutMv("XM_NFORI", cNfOri )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_NFORI"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Amarra NF Origem pelo Livro Fiscal(Entradas)?"
		SX6->X6_DESC1   := "S - Livro Fiscal(SF3); N - NF Saida(SF2)."
		MsUnLock()
		PutMv("XM_NFORI", cNfOri ) 
	EndIf	

	/********************************/
	If !PutMv("XM_CSOL", cCSol )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CSOL"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Amarra C.Custo de Qual Cadastro?"
		SX6->X6_DESC1   := "S - Ped.Compra; N - Cad.Produto; A-Ambos."
		MsUnLock()
		PutMv("XM_CSOL", cCSol ) 
	EndIf

	/********************************/
	If !PutMv("XM_CCNFOR", cCCNfOr )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_CCNFOR"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "C.Custo da NF Origem para CTE?"
		SX6->X6_DESC1   := ""
		MsUnLock()
		PutMv("XM_CCNFOR", cCCNfOr )
	EndIf


/*
AADD(aSx6,{"  ","XM_D_STATUS"  ,"C","Dias a retroceder para verificar Status XML."      ,"","","","","","","","","30","30","30","",""})
AADD(aSx6,{"  ","XM_D_CANCEL"  ,"C","Dias a retroceder para consultar XML na SEFAZ."    ,"","","","","","","","","7","7","7","",""})
*/			

	
Makedir(cPathx)
MsgInfo("Configurações gerais atualizadas com sucesso!")
Return

//incluido para aba Gerais 2 - Alexandro de Oliveira - 25/11/2014
Static Function SetCfgGerII(cSerEmp,_cSerXML,_cTravPrN,cRotCon,cConMod,cPedRec,cTabRec,cRecDoc,cXmlSef,cManPre,cLogoDan)
Local Nx := 0
Local cError     := ""

	/********************************/
	If !PutMv("XM_SEREMP", cSerEmp )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_SEREMP"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "SERIE POR EMPRESA"
		SX6->X6_DESC1   := "EX: SP=01,02;ES=10,11"
		SX6->X6_DESC2   := "VAZIO Mantem Série do XML"
		MsUnLock()
		PutMv("XM_SEREMP", cSerEmp ) 
	EndIf	


	/********************************/
	If !PutMv("XM_SERXML", _cSerXML )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_SERXML"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "SERIE DO XML VAZIA QUANDO 0"
		SX6->X6_DESC1   := "EX: S=SIM EM BRANCO; N=NAO COM VALOR 0"
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_SERXML", _cSerXML ) 
	EndIf

	/********************************/
	If !PutMv("XM_PED_GBR", _cTravPrN )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_PED_GBR"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "TRAVA A PRE-NOTA"
		SX6->X6_DESC1   := "EX: S=SIM TRAVA A PRE NOTA; N=NAO APENAS PERGUNTA SE CONTINUA"
		SX6->X6_DESC2   := "  "
		MsUnLock()
		PutMv("XM_PED_GBR", _cTravPrN ) 
	EndIf
	
	/********************************/
	If !PutMv("XM_ROT_CON", cRotCon )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_ROT_CON"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "ROTINA DE CONSULTA AO SEFAZ"
		SX6->X6_DESC1   := "1=Importa XML, 2=TSS"
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_ROT_CON", cRotCon )
	EndIf

	/********************************/
	If !PutMv("XM_GRBMOD", cConMod )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_GRBMOD"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "CONSULTA TODAS MODALIDADES"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_GRBMOD", cConMod )
	EndIf

	/********************************/
	If !PutMv("XM_PEDREC", cPedRec )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_PEDREC"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Utiliza Pedido Recorrente"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_PEDREC", cPedRec )
	EndIf

	/********************************/
	If !PutMv("XM_TABREC", cTabRec )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_TABREC"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Tabela de Fonrecedores com Pedido Recorrente"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_TABREC", cTabRec )
	EndIf

	/********************************/
	If !PutMv("XM_RECDOC", cRecDoc )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_RECDOC"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Tipo de documento a gerar por pedido recorrente"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_RECDOC", cRecDoc )
	EndIf

	/********************************/
	If !PutMv("XM_XMLSEF", cXmlSef )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_XMLSEF"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Comparar TAGs do XML com a SEFAZ"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_XMLSEF", cXmlSef )
	EndIf

	/********************************/
	If !PutMv("XM_MANPRE", cManPre )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_MANPRE"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Manifestar após gerar a pré-nota"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_MANPRE", cManPre )
	EndIf

	/********************************/
	If !PutMv("XM_LOGOD", cLogoDan )
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_LOGOD"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Emissão do Logo"
		SX6->X6_DESC1   := ""
		SX6->X6_DESC2   := ""
		MsUnLock()
		PutMv("XM_LOGOD", cLogoDan )
	EndIf

MsgInfo("Configurações gerais(2) atualizadas com sucesso!")
Return



Static Function TestMail(cMailServer,cLogin,cMailConta,cMailSenha,lSMTPAuth,lSSL,cProtocolE,cPortEnv)
Local Nx := 0
Local aDadosMail :={}
Local oDlg     := NIL
Local cMask    := "Todos os arquivos (*.*) |*.*|"
Local oMsg

Private cTitulo  := "Criar e-mail"
Private cServer  := cMailServer
Private cEmail   := cMailConta
Private cPass    := cMailSenha

Private cDe      := cMailConta
Private cPara    := Padr(cMailConta,200) // Space(200)
Private cCc      := Space(200)
Private cAssunto := "Teste de Configuração Importa XML" // Space(200)
Private cAnexo   := Space(200)
Private cMsg     := ""
                      
If Empty(cServer) .And. Empty(cEmail) .And. Empty(cPass)
   MsgAlert("Não foi definido os parâmetros do server do Protheus para envio de e-mail",cTitulo)
   Return
Endif
cMsg := "Este é um e-mail de teste de configuração de SMTP do importa XML."+CRLF
cMsg += "Data : "+Dtoc(dDataBase)+CRLF 
cMsg += "Hora : "+Time()+CRLF      
cMsg += "Usuario : "+Substr(cUsuario,7,15)+CRLF                                             

DEFINE MSDIALOG oDlg TITLE cTitulo FROM 0,0 TO 350,570 OF oDlg PIXEL

@  3,3 SAY "De"   SIZE 30,7 PIXEL OF oDlg
@ 15,3 SAY "Para" SIZE 30,7 PIXEL OF oDlg
@ 27,3 SAY "Cc"       SIZE 30,7 PIXEL OF oDlg
@ 39,3 SAY "Assunto"  SIZE 30,7 PIXEL OF oDlg
@ 51,3 SAY "Anexo"    SIZE 30,7 PIXEL OF oDlg
@ 63,3 SAY "Mensagem" SIZE 30,7 PIXEL OF oDlg

@  2, 35 MSGET cDe      PICTURE "@" SIZE 248, 7 PIXEL OF oDlg READONLY
@ 14, 35 MSGET cPara    PICTURE "@" SIZE 248, 7 PIXEL OF oDlg
@ 26, 35 MSGET cCc      PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
@ 38, 35 MSGET cAssunto PICTURE "@" SIZE 248, 8 PIXEL OF oDlg
@ 50, 35 MSGET cAnexo   PICTURE "@" SIZE 233, 8 PIXEL OF oDlg When .F.
//@ 49,269 BUTTON "..." SIZE 13,11 PIXEL OF oDlg ACTION cAnexo:=AllTrim(cGetFile(cMask,"Inserir anexo"))
@ 62, 35 GET oMsg VAR cMsg MEMO SIZE 248,93 PIXEL OF oDlg 

@ 160,210 BUTTON "&Enviar"    SIZE 36,13 PIXEL ACTION (lOpc:=Validar(),Iif(lOpc,Eval({||SendMail(cDe,cPara,cCc,cAssunto,cAnexo,cMsg),oDlg:End()}),NIL))
@ 160,248 BUTTON "&Abandonar" SIZE 36,13 PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

Return






Static Function SendMail(cDe,cPara,cCc,cAssunto,cAnexo,cMsg)
Local nret   := 0
Local cError := "" 
Local cRet   := ""
  
    aTo := Separa(cPara,";")
//    MsgRun("Testanto envio...","E-mail / SMTP",{|| nRet:= 	U_HX_MAIL(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cPara,cCc) })                              
    MsgRun("Testanto envio...","E-mail / SMTP",{|| nRet:= 	U_MAILSEND(aTo,cAssunto,cMsg,@cError,cAnexo,cAnexo,cPara,cCc) })  
    
	If nRet == 0 .And. Empty(cError)
		U_MyAviso("Aviso","E-mail enviado com sucesso!",{"OK"})
	Else
		cError += U_MailErro(nRet)                  
		U_MyAviso("Aviso",cError,{"OK"},3)
	EndIf


Return(nret)
           


Static Function Validar()
Local lRet := .T.
If Empty(cDe)
   MsgInfo("Campo 'De' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif
If Empty(cPara) .And. lRet
   MsgInfo("Campo 'Para' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif
If Empty(cAssunto) .And. lRet
   MsgInfo("Campo 'Assunto' preenchimento obrigatório",cTitulo)
   lRet:=.F.
Endif

If lRet
   cDe      := AllTrim(cDe)
   cPara    := AllTrim(cPara)
   cCC      := AllTrim(cCC)
   cAssunto := AllTrim(cAssunto)
   cAnexo   := AllTrim(cAnexo)
Endif

RETURN(lRet)


Static Function ShowLogo(aPages)
Local Nx := 0
Local nLogo := 2
For Nx := 1 to Len(aPages)                               

    If nLogo == 1
        
		oBmp1          := TBITMAP():Create(oPage:aDialogs[Nx])
		oBmp1:cName    := "oBmp1"
		oBmp1:nWidth   := 50
		oBmp1:nHeight  := 50
		oBmp1:cBmpFile := "HFCONSULT.JPG"
		oBmp1:lStretch := .T.   
		oBmp1:nTop     := 342                     
		oBmp1:nLeft    := 002                     
		
		@ 175,030 Say "By HF Consulting"   PIXEL OF oPage:aDialogs[Nx] COLOR CLR_BLACK FONT oFont01
		@ 185,030 Say "Telefone : (11) 5524-5124 "  PIXEL OF oPage:aDialogs[Nx] COLOR CLR_BLACK FONT oFont01
		
		oTHButton := THButton():New(178,130,"E-mail : comercial@hfbr.com.br",oPage:aDialogs[Nx],;
		                 {||ShellExecute("open","mailto:comercial@hfbr.com.br","","",3)},120,20,oFont01,"Contato")
	ElseIf nLogo == 2
		oBmp1          := TBITMAP():Create(oPage:aDialogs[Nx])
		oBmp1:cName    := "oBmp1"
		oBmp1:nWidth   := 170
		oBmp1:nHeight  := 50
		oBmp1:cBmpFile := "HFCONSULT2.JPG"
		oBmp1:lStretch := .T.   
		oBmp1:nTop     := 342                     
		oBmp1:nLeft    := 010                     
		
		@ 175,140 Say "Telefone : (11) 5524-5124 "  PIXEL OF oPage:aDialogs[Nx] COLOR CLR_BLACK FONT oFont01
		
		oTHButton := THButton():New(178,130,"E-mail : comercial@hfbr.com.br",oPage:aDialogs[Nx],;
		                 {||ShellExecute("open","mailto:comercial@hfbr.com.br","","",3)},120,20,oFont01,"Contato")
	
	EndIf
Next
Return()
      
    


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Microsiga           º Data ³  26/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Cria as perguntas do programa no dicionario de perguntas    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function GetJobInfo(nTipo)
Local cConteudo := ""
Local cSepara   := ""
Local aParams   := {}
Default nTipo   := 1

cConteudo:= GetPvProfString('ONSTART','JOBS',"",GetAdv97())

If !Empty(cConteudo)
	cSepara :=","
EndIf

If nTipo == 2
	If "IMP_XML" $ cConteudo
		WritePProString("IMP_XML",'MAIN','U_WF_XML01',GetAdv97())
		WritePProString("IMP_XML",'ENVIRONMENT',GetEnvServer(),GetAdv97())
    Else
		WritePProString('ONSTART','JOBS',cConteudo+cSepara+"IMP_XML",GetAdv97())
		WritePProString("IMP_XML",'MAIN','U_WF_XML01',GetAdv97())
		WritePProString("IMP_XML",'ENVIRONMENT',GetEnvServer(),GetAdv97())
	EndIf		

ElseIf nTipo == 3

	WritePProString('ONSTART','JOBS',StrTran(cConteudo,"IMP_XML",""),GetAdv97())

EndIf

Aadd(aParams,{'ONSTART' ,cConteudo,Iif("IMP_XML" $ cConteudo,"ATIVO","INATIVO")})

Return(aParams)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ HX_MAIL  ³ Autor ³ Roberto Souza         ³ Data ³27/06/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que envia e-mail                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ HX_MAIL(aTo,cSubject,cMsg,cError,cAnexo,cAnexo2,cEmailDest)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±³          ³ ExpA1 = aTo                                                ³±±
±±³          ³ ExpC2 = Subject                                            ³±±
±±³          ³ ExpC3 = Mensagem a ser enviada                             ³±±
±±³          ³ ExpC4 = Mensagem de erro retornada                    (OPC)³±±
±±³          ³ ExpC5 = Arquivo para anexar a mensagem                (OPC)³±±
±±³          ³ ExpC6 = Arquivo para anexar a mensagem                (OPC)³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function HX_MAIL(aTo,cSubject,cMensagem,cError,cAnexo,cAnexo2,cEmailDest,cCCdest,cBCCdest)

Local aSMTP       := U_XCfgMail(1,1,{})
Local cMailServer := AllTrim(aSMTP[1]) //GetNewPar("XM_SMTP",Space(100))
Local cLogin      := AllTrim(aSMTP[2]) //GetNewPar("XM_LOGIN",Space(100))
Local cMailConta  := AllTrim(aSMTP[3]) //GetNewPar("XM_ACCOUNT",Space(100))
Local cMailSenha  := AllTrim(aSMTP[4]) //Decode64(GetNewPar("XM_PASS",Space(100)))
Local lSMTPAuth   := aSMTP[5] //GetNewPar("XM_AUT",Space(100))=="S"
Local lSSL        := aSMTP[6] //GetNewPar("XM_SSL",Space(100))=="S"
Local cThreadID   := "1"
Local lOk         := .F.
Local lSendOk     := .F.
Local nX          := 0 
Local oServer
Local oMessage
Local nRet        := 0
Local nNumMsg 	  := 0
Local nTam   	  := 0
Local nI     	  := 0
Local nModel      := Val(GetSrvProfString("HF_MODOMAIL","1"))

Default cSubject  := "Mensagem de Teste"
//Default cMensagem := "Este é um email enviado automaticamente pelo Gerenciador de Contas do Protheus durante o teste das configurações da sua conta SMTP."
Default aTo       := {cMailConta}
Default cError    := ""
Default cEmailDest:= ""
Default cCCdest   := ""
Default cBCCdest  := ""

cMsgCfg := ""
cMsgCfg += '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
cMsgCfg += '<html xmlns="http://www.w3.org/1999/xhtml">
cMsgCfg += '<head>
cMsgCfg += '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
cMsgCfg += '<title>Importa XML</title>
cMsgCfg += '  <style type="text/css"> 
cMsgCfg += '	<!-- 
cMsgCfg += '	body {background-color: rgb(37, 64, 97);} 
cMsgCfg += '	.style1 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;} 
cMsgCfg += '	.style2 {font-family: Segoe UI,Verdana, Arial;font-size: 12pt;color: rgb(255,0,0)} 
cMsgCfg += '	.style3 {font-family: Segoe UI,Verdana, Arial;font-size: 10pt;color: rgb(37,64,97)} 
cMsgCfg += '	.style4 {font-size: 8pt; color: rgb(37,64,97); font-family: Segoe UI,Verdana, Arial;} 
cMsgCfg += '	.style5 {font-size: 10pt} 
cMsgCfg += '	--> 
cMsgCfg += '  </style>
cMsgCfg += '</head>
cMsgCfg += '<body>
cMsgCfg += '<table style="background-color: rgb(240, 240, 240); width: 800px; text-align: left; margin-left: auto; margin-right: auto;" id="total" border="0" cellpadding="12">
cMsgCfg += '  <tbody>
cMsgCfg += '    <tr>
cMsgCfg += '      <td colspan="2">
cMsgCfg += '    <Center>
cMsgCfg += '      <img src="http://extranet.helpfacil.com.br/images/cabecalho.jpg">
cMsgCfg += '      </Center>
cMsgCfg += '      <p class="style1">Este é um email enviado automaticamente pelo Gerenciador de Contas do Protheus durante o teste das configurações da sua conta  de envio de notificações do Importa XML.</p>
cMsgCfg += '      </td>
cMsgCfg += '    </tr>
cMsgCfg += '  </tbody>
cMsgCfg += '</table>
cMsgCfg += '<p class="style1">&nbsp;</p>
cMsgCfg += '</body>
cMsgCfg += '</html>
Default cMensagem := cMsgCfg

If !Empty(cMailServer) .And. !Empty(cMailConta) .And. !Empty(cMailSenha) .And. !Empty(cLogin)

	If nModel == 2	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Cria o objeto d e e-mail                                                         |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oServer := TMailManager():New()  
		
		oServer:SetUseSSL(lSSL) 
		If lSMTPAuth
		//	MailAuth(cLogin,cMailSenha)
        EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Inicia o objeto d e e-mail                                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	    oServer:Init("", AllTrim(cMailServer), AllTrim(cMailConta), AllTrim(cMailSenha) )

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Timeout de espera                                                                |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:SetSmtpTimeOut( 30 )
		If nRet <> 0
			Return(nRet)
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Conecta ao servidor de SMTP                                                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:SmtpConnect()
		If nRet != 0
			Return(nRet)
		EndIf
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Cria o Objeto da mensagem                                                        |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMessage := TMailMessage():New()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Limpa o Objeto da mensagem                                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMessage:Clear()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Atribui o Objeto da mensagem                                                     |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oMessage:cFrom 		:= "Importa XML"
		oMessage:cTo 		:= cEmailDest
		oMessage:cCc 		:= cCCdest
		oMessage:cBcc 		:= cBCCdest
		oMessage:cSubject 	:= cSubject
		oMessage:cBody 		:= cMensagem
	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Processa os anexos                                                               |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(cAnexo)
			nRet := oMessage:AttachFile(cAnexo)
			If nRet != 0
				Return(nRet)
			Else
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cAnexo)
			EndIf
		EndIf
		If !Empty(cAnexo2)
			nRet := oMessage:AttachFile(cAnexo2)
			If nRet != 0
				Return(nRet)
			Else
				oMessage:AddAtthTag( 'Content-Disposition: attachment; filename='+cAnexo2)				
			EndIf
		EndIf
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Envia o E-mail                                                                   |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oMessage:Send( oServer )
		If nRet != 0
			Return(nRet)
		EndIf
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Envia o E-mail                                                                   |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		nRet := oServer:SmtpDisconnect()
		If nRet != 0
			Return(nRet)
		EndIf

     Else
	                                                                                                                     
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Conecta ao servidor de SMTP                                                      |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If __nHdlSMTP == 0
			If lSSL
				CONNECT SMTP SERVER cMailServer ACCOUNT cLogin PASSWORD cMailSenha RESULT lOk
			Else
				CONNECT SMTP SERVER cMailServer ACCOUNT cLogin PASSWORD cMailSenha RESULT lOk
			EndIf
			If lOk
				__nHdlSMTP := 1
			Else
				__nHdlSMTP := 0
			EndIf	
		Else 
			lSMTPAuth := .F.
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//| Verifica se há necessidade de autenticacao                                       |
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If __nHdlSMTP <> 0
			If ( lSMTPAuth )
				lOk := MailAuth(cLogin,cMailSenha)
			Else
				lOk := .T.
			EndIf
			If lOk
				__nHdlSMTP := 1
			Else
				GET MAIL ERROR cError
				ConOut(IIF(cThreadID=="1",'ThreadID='+AllTrim(Str(ThreadID(),15)),"")+" - Log SMTP: " + cError)
				MailFree()
			EndIf	
		EndIf
		If __nHdlSMTP <> 0
			For nX := 1 To Len(aTo)
				If !("@" $ aTo[nX])                                        
					cSubject += " - email de destino inválido ("+aTo[nX]+")"
					aTo[nX]  := cMailConta
				EndIf		
				If !Empty(cAnexo2)
					SEND MAIL FROM cMailConta to AllTrim(aTo[nX]) SUBJECT cSubject BODY cMensagem ATTACHMENT cAnexo,cAnexo2 RESULT lSendOk
				ElseIf !Empty(cAnexo)
					SEND MAIL FROM cMailConta to AllTrim(aTo[nX]) SUBJECT cSubject BODY cMensagem ATTACHMENT cAnexo RESULT lSendOk
				Else
					SEND MAIL FROM cMailConta to AllTrim(aTo[nX]) SUBJECT cSubject BODY cMensagem RESULT lSendOk
				EndIf
				If !lSendOk
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Erro no Envio do e-maIil                                                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cEmailDest := aTo[nX]
					GET MAIL ERROR cError
					ConOut(IIF(cThreadID=="1",'ThreadID='+AllTrim(Str(ThreadID(),15)),"")+" - Log SMTP: " + cError)
					MailFree()
					Exit
				EndIf
			Next nX
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Erro na conexao com o SMTP Server ou na autenticacao da conta          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If Empty(cError)
				GET MAIL ERROR cError
				ConOut(IIF(cThreadID=="1",'ThreadID='+AllTrim(Str(ThreadID(),15)),"")+" - Log SMTP: " + cError)
			EndIf
		EndIf
	EndIf
EndIf	
Return(__nHdlSMTP)   





/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MailFree   ³ Autor ³Roberto Souza          ³ Data ³27/06/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina que desconecta o servidor de email                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ MailFree                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ GENERICO                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MailFree()

If __nHdlSMTP == 1
	DISCONNECT SMTP SERVER
	__nHdlSMTP := 0
EndIf
Return


User Function LoadCfgX(nTipo,cFileX,aDefs)

Local lRet     := .T.
Local uRet     := Nil
Local Nx       := 0
Local NY       := 0
Local cError   := ""
Local cWarning := ""
Local cXml     := ""
Local cJobs    := ""
Local nJobs    := 0
Local nAt1     := nAt2 := nAt3 := nAt4 := 0
Local lLoadDef := .F.
Private oXmlCfg                 
Private aJobs  := ""
Private aDados := {}
Default nTipo  := 1
Default cFileX := "hfcfgxml001a.xml"
Default aDefs  := {}

    
If nTipo == 1 // Carrega  
	If File(cFileX)
		
		cXml := MemoRead(cFileX)    
		oXmlCfg := XmlParser( cXml, "_", @cError, @cWarning )  
		
		If Empty(cError) .And. Empty(cWarning) 
			If Type("oXmlCfg:_MAIN:_WFXML01:_JOBS:_JOB") == "A"
				aJobs := oXmlCfg:_MAIN:_WFXML01:_JOBS:_JOB
			Else
				aJobs := {oXmlCfg:_MAIN:_WFXML01:_JOBS}	
			EndIf
			nJobs := Len(aJobs)
			For Nx := 1 to nJobs
				cJobs += aJobs[Nx]:TEXT
				If Nx <  nJobs
				 	cJobs += ","
				EndIf
			Next
			uRet:=oXmlCfg
		Else
			lLoadDef := .T.				
		EndIf
		oXmlCfg:= Nil
	Else
		lLoadDef := .T.
	EndIf
	
ElseIf nTipo == 2  //Salva 
	cXml    := MemoRead(cFileX)
	aDados  := aDefs
    cXmlEnd := ""


	cXmlEnd += '<?xml version = "1.0" encoding = "UTF-8"?>'
	cXmlEnd += '<Main>'
	cXmlEnd += '<wfxml01 version="1.00">'
	            
	For Nx := 1 To Len(aDados)
		cTag   := Lower(aDados[Nx][1])
	    cTipo  := ValType(aDados[Nx][2])
		cDesc  := aDados[Nx][3]
		uText  := aDados[Nx][2]               
		cSubTag:= Left(cTag,Len(cTag)-1) 
        
		If cTipo <> "A"
			cXmlEnd += '<'+cTag+'>'
			cXmlEnd += xTag("xDesc","C"  ,cDesc, cSubTag)
			cXmlEnd += xTag("xType","C"  ,cTipo, cSubTag)
			cXmlEnd += xTag("xText",cTipo,uText, cSubTag)	                                              
			cXmlEnd += '</'+cTag+'>'
		Else
			aProc := uText 
			cXmlEnd += '<'+cTag+'>'
            For Ny:=1 to Len(aProc) 
				cXmlEnd += '<'+cSubTag+'>'				
				cXmlEnd += xTag("xDesc","C"  ,cDesc, cSubTag)
				cXmlEnd += xTag("xType","C"  ,ValType(aProc[Ny]), cSubTag)
				cXmlEnd += xTag("xText",ValType(aProc[Ny]),aProc[Ny], cSubTag)	                                              
				cXmlEnd += '</'+cSubTag+'>'
    		Next
			cXmlEnd += '</'+cTag+'>'
		
		EndIf
	Next

	cXmlEnd += '</wfxml01>'
	cXmlEnd += '</Main>'
	uRet    := cXmlEnd
EndIf
    
If lLoadDef .Or. nTipo == 3
	uRet := '<?xml version = "1.0" encoding = "UTF-8"?><Main><wfxml01 version="1.00"><enable><xDesc>Servico Habilitado</xDesc><xType>C</xType><xText>1</xText></enable><ent><xDesc>Empresa/Filial principal do processo</xDesc><xType>C</xType><xText>9901</xText></ent><wfdelay><xDesc>Atraso apos a primeira execucao</xDesc><xType>N</xType><xText>5</xText></wfdelay><threadid><xDesc>Indentificador de Thread [Debug]</xDesc><xType>C</xType><xText>1</xText></threadid><jobs><job><xDesc>Servico a ser processado</xDesc><xType>C</xType><xText>1</xText></job><job><xDesc>Servico a ser processado</xDesc><xType>C</xType><xText>2</xText></job><job><xDesc>Servico a ser processado</xDesc><xType>C</xType><xText>3</xText></job><job><xDesc>Servico a ser processado</xDesc><xType>C</xType><xText>4</xText></job><job><xDesc>Servico a ser processado</xDesc><xType>C</xType><xText>5</xText></job></jobs><sleep><xDesc>Tempo de espera</xDesc><xType>N</xType><xText>600</xText></sleep><console><xDesc>Informacoes dos processos no console</xDesc><xType>C</xType><xText>1</xText></console></wfxml01></Main>'
	uRet := XmlParser( uRet, "_", @cError, @cWarning )  
EndIf


If nTipo==1 .And. uRet == Nil
	nAviso := 0
	nAviso := Aviso("Atencao","O Arquivo de configuração é inválido."+CRLF+"Deseja Carregar as configurações padrão?",{"Sim","Não"},3)
	If nAviso == 1
		MsgInfo("Carregamento Finalizado.")				
		//Desenvolver
	Else
		MsgInfo("Carregamento Abortado.")	
	EndIf
EndIf

Return(uRet)         
        



Static Function xTag(cTag,cTipo,uText,SubTag)
Local cRetorno := ""                                                       
cRetorno += '<'+cTag+'>'
If cTipo=="C"
	cRetorno += AllTrim(uText)
ElseIf cTipo=="N"
	cRetorno += AllTrim(Str(uText))
ElseIf cTipo=="A"

EndIf
cRetorno += '</'+cTag+'>'
Return(cRetorno)


User Function GetJob(cJobs)
Local cRet := ""
Local aJobs:= {}
Local Nx   := 1
Local oDlg                                                        
Local oChkOnX, oChkOn1, oChkOn2, oChkOn3, oChkOn4, oChkOn5, oChkOn6
Local lChkOnX  :=  ("X" $ cJobs)
Local lChkOn1  :=  ("1" $ cJobs)
Local lChkOn2  :=  ("2" $ cJobs)
Local lChkOn3  :=  ("3" $ cJobs)
Local lChkOn4  :=  ("4" $ cJobs)
Local lChkOn5  :=  ("5" $ cJobs)
Local lChkOn6  :=  ("6" $ cJobs)
Local nOpc     := 0
Private oFont01:= TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
                                                                  
DEFINE MSDIALOG oDlg TITLE "Selecao de Servicos [Jobs]" FROM 000,000 TO 300,400 PIXEL STYLE DS_MODALFRAME STATUS

@ 00.5,00.5 to 009,024.5 OF oDlg   

@ 010 ,010 SAY "Selecione os jobs a serem executados:" PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
@ 020 ,010 CHECKBOX oChkOnX VAR lChkOnX PROMPT "X-Todos"            SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01//;
//         ON CHANGE(Iif( lChkOnX ,(oChkOn1:LREADONLY:=.T.,lChkOn2:LREADONLY:=.T.,lChkOn3:LREADONLY:=.T.),;

@ 035 ,010 CHECKBOX oChkOn1 VAR lChkOn1 PROMPT "1-Verificar E-mail" SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn1,lChkOnX:=.F.,Nil))

@ 050 ,010 CHECKBOX oChkOn2 VAR lChkOn2 PROMPT "2-Validar Xml"      SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn2,lChkOnX:=.F.,Nil))

@ 065 ,010 CHECKBOX oChkOn3 VAR lChkOn3 PROMPT "3-Checar Pré-Nota"  SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

@ 080 ,010 CHECKBOX oChkOn4 VAR lChkOn4 PROMPT "4-Consulta de xmls"  SIZE 95,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01 
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

@ 095 ,010 CHECKBOX oChkOn5 VAR lChkOn5 PROMPT "5-Notificações por E-mail"  SIZE 95,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

@ 110 ,010 CHECKBOX oChkOn6 VAR lChkOn6 PROMPT "6-Download XML SEFAZ"  SIZE 95,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

oChkOnX:cToolTip := "Todas as rotinas disponíveis."
oChkOn1:cToolTip := "Verificar E-mail e salvar arquivos no diretório indicado."
oChkOn2:cToolTip := "Validar Xml quanto a estrutura e consulta junto a SEFAZ."
oChkOn3:cToolTip := "Checar Pré-Nota e sincronizar os Status." 
oChkOn4:cToolTip := "Consulta os Xmls já recebidos previamente, de acordo com os parametros configurados."+CRLF+"Atenção."+CRLF+"Esta opção somente pode ser habilitada para o Job de execução automática.[Configurações Job]"
oChkOn5:cToolTip := "Enviar e-mails de notificação de erros e cancelamentos."
oChkOn6:cToolTip := "Download XML SEFAZ, de acordo com Nota Tecnica 2012_002. Esta sujeito as regras da nota técnica."+CRLF+"Atenção."+CRLF+"Se a chave não estiver manifestada será manifestada com confirmação da Operação somente XML de dois dias ou mais atras."


@ 130 ,110 Button "Cancela" Size 040,015 PIXEL OF oDlg ACTION oDlg:End()                                                        
@ 130 ,155 Button "OK" Size 040,015 PIXEL OF oDlg ACTION (nOpc:=1,oDlg:End())                                                        

ACTIVATE MSDIALOG oDlg CENTERED 

If nOpc ==1
	If lChkOnX
		cRet := "X"
	Else
		cRet := ""
		If lChkOn1
			cRet += Iif(!Empty(cRet),",","" )+"1"
		EndIf
		If lChkOn2
			cRet += Iif(!Empty(cRet),",","" )+"2"
		EndIf
		If lChkOn3
			cRet += Iif(!Empty(cRet),",","" )+"3"
		EndIf
		If lChkOn4
			cRet += Iif(!Empty(cRet),",","" )+"4"
		EndIf
		If lChkOn5
			cRet += Iif(!Empty(cRet),",","" )+"5"
		EndIf							
		If lChkOn6
			cRet += Iif(!Empty(cRet),",","" )+"6"
		EndIf							
	EndIf	

Else
	cRet := cJobs      
Endif
Return(cRet)


User Function MailErro(nErro)
Local aErro := {}
Local nCod  := 0
Local xRet  := "" 
Default nErro := 999  

//aadd(aErro,{ 0,"Operation completed successfully.","SUCCESS "})
aadd(aErro,{ 1,"Operation failed.","ERROR "})
//aadd(aErro,{ ,"","// Connection errors"})
aadd(aErro,{ 2,"The connection failed.","CONNECT_FAILED "})
aadd(aErro,{ 3,"The connection was rejected.","CONNECT_REJECTED "})
aadd(aErro,{ 4,"The connection was terminated.","CONNECT_TERMINATED "})
aadd(aErro,{ 5,"The connection timed-out.","CONNECT_TIMEOUT "})
aadd(aErro,{ 6,"There was no connection.","NOCONNECTION "})
aadd(aErro,{ 7,"Name lookup failed.","NAME_LOOKUP_FAILED "})
aadd(aErro,{ 8,"Data port could not be opened.","DATAPORT_FAILED "})
aadd(aErro,{ 9,"Accept failed.","ACCEPT_FAILED "})
//aadd(aErro,{ ,"","// Server errors "})
aadd(aErro,{ 10,"The request was denied by the server.","SVR_REQUEST_DENIED "})
aadd(aErro,{ 11,"The request is not supported by the server.","SVR_NOT_SUPPORTED "})
aadd(aErro,{ 12,"There was no response from the server.","SVR_NO_RESPONSE "})
aadd(aErro,{ 13,"Permission denied by the server.","SVR_ACCESS_DENIED "})
aadd(aErro,{ 14,"The Server failed to connect on the data port.","SVR_DATA_CONNECT_FAILED "})
//aadd(aErro,{ ,"","// Socket errors"})
aadd(aErro,{ 15,"The socket is not opened.","SOCK_NOT_OPEN "})
aadd(aErro,{ 16,"The socket is already opened or in use.","SOCK_ALREADY_OPEN "})
aadd(aErro,{ 17,"The socket creation failed.","SOCK_CREATE_FAILED "})
aadd(aErro,{ 18,"The socket binding to local port failed.","SOCK_BIND_FAILED "})
aadd(aErro,{ 19,"The socket connection failed.","SOCK_CONNECT_FAILED "})
aadd(aErro,{ 20,"A timeout occurred.","SOCK_TIMEOUT "})
aadd(aErro,{ 21,"A receive socket error occurred.","SOCK_RECEIVE_ERROR "})
aadd(aErro,{ 22,"Winsock send command failed.","SOCK_SEND_ERROR "})
aadd(aErro,{ 23,"The listen process failed.","SOCK_LISTEN_ERROR "})
aadd(aErro,{ 24,"A client socket closure  caused a failure.","CLIENT_RESET "})
aadd(aErro,{ 25,"A server socket closure caused failure.","SERVER_RESET "})
//aadd(aErro,{ ,"","// File errors"})
aadd(aErro,{ 26,"An error occurred as a result of an invalid file type.","FILE_TYPE_ERROR "})
aadd(aErro,{ 27,"An error occurred as a result of not being able to open a file.","FILE_OPEN_ERROR "})
aadd(aErro,{ 28,"An error occurred as a result of not being able to create a file.","FILE_CREATE_ERROR "})
aadd(aErro,{ 29,"A file read error occurred.","FILE_READ_ERROR "})
aadd(aErro,{ 30,"A file write error occurred.","FILE_WRITE_ERROR "})
aadd(aErro,{ 31,"Error trying to close file.","FILE_CLOSE_ERROR "})
aadd(aErro,{ 32,"There was no output file name provided, and no output file name was included with the attachment.","FILE_ERROR "})
aadd(aErro,{ 33,"File format error.","FILE_FORMAT_ERROR "})
aadd(aErro,{ 34,"Get temporary file name failed.","FILE_TMP_NAME_FAILED "})
//aadd(aErro,{ ,"","// Buffer errors"})
aadd(aErro,{ 35,"An error resulted due to the buffer being too short.","BUFFER_TOO_SHORT "})
aadd(aErro,{ 36,"An error resulted due to a NULL buffer","NULL_PARAM "})
//aadd(aErro,{ ,"","// Response errors"})
aadd(aErro,{ 37,"An error occurred as a result of an invalid or negative response.","INVALID_RESPONSE "})
aadd(aErro,{ 38,"There was no response.","NO_RESPONSE "})
//aadd(aErro,{ ,"","// Index errors"})
aadd(aErro,{ 39,"The index value was out of range.","INDEX_OUTOFRANGE "})
//aadd(aErro,{ ,"","// User validation errors"})
aadd(aErro,{ 40,"The user name was invalid.","USER_ERROR "})
aadd(aErro,{ 41,"The password was invalid.","PASSWORD_ERROR "})
//aadd(aErro,{ ,"","// Message errors "})
aadd(aErro,{ 42,"This is a malformed message.","INVALID_MESSAGE "})
aadd(aErro,{ 43,"Invalid format.","INVALID_FORMAT "})
aadd(aErro,{ 44,"Not a MIME file.","FILE_NOT_MIME "})
//aadd(aErro,{ ,"","// URL errors"})
aadd(aErro,{ 45,"A bad URL was given.","BAD_URL "})
//aadd(aErro,{ ,"","// Command errors"})
aadd(aErro,{ 46 ,"An invalid command.","INVALID_COMMAND "})
aadd(aErro,{ 47,"MAIL command failed.","MAIL_FAILED "})
aadd(aErro,{ 48,"The RETR command failed.","RETR_FAILED "})
aadd(aErro,{ 49,"The PORT command failed.","PORT_FAILED "})
aadd(aErro,{ 50,"The LIST command failed.","LIST_FAILED "})
aadd(aErro,{ 51,"The STOR command failed.","STOR_FAILED "})
aadd(aErro,{ 52,"The DATA command failed.","DATA_FAILED "})
aadd(aErro,{ 53,"The USER command failed.","USER_FAILED "})
aadd(aErro,{ 54,"The HELLO command failed.","HELLO_FAILED "})
aadd(aErro,{ 55,"The PASS command failed.","PASS_FAILED "})
aadd(aErro,{ 56,"The STAT command failed.","STAT_FAILED "})
aadd(aErro,{ 57,"The TOP command failed.","TOP_FAILED "})
aadd(aErro,{ 58,"The UIDL command failed.","UIDL_FAILED "})
aadd(aErro,{ 59,"The DELE command failed.","DELE_FAILED "})
aadd(aErro,{ 60,"The RSET command failed.","RSET_FAILED "})
aadd(aErro,{ 61,"The XOVER command failed.","XOVER_FAILED "})
aadd(aErro,{ 62,"The USER command was not accepted.","USER_NA "})
aadd(aErro,{ 63,"The PASS command was not accepted.","PASS_NA "})
aadd(aErro,{ 64,"The ACCT command was not accepted.","ACCT_NA "})
aadd(aErro,{ 65,"The RNFR command not accepted.","RNFR_NA "})
aadd(aErro,{ 66,"The RNTO command not accepted.","RNTO_NA "})
aadd(aErro,{ 67,"The RCPT command failed. The specified account does not exsist.","RCPT_FAILED "})
aadd(aErro,{ 68,"Bad article, posting rejected by server","NNTP_BAD_ARTICLE "})
aadd(aErro,{ 69,"Posting is not allowed.","NNTP_NOPOSTING "})
aadd(aErro,{ 70,"Posting rejected by server","NNTP_POST_FAILED "})
aadd(aErro,{ 71,"AUTHINFO USER command failed.","NNTP_AUTHINFO_USER_FAILED "})
aadd(aErro,{ 72,"AUTHINFO PASS command failed.","NNTP_AUTHINFO_PASS_FAILED "})
aadd(aErro,{ 73,"The XOVER command failed.","XOVER_COMMAND_FAILED "})
//aadd(aErro,{ ,"","// Message errors"})
aadd(aErro,{ 74,"Can","MSG_OPEN_FAILED "})
aadd(aErro,{ 75,"Close message data source failed.","MSG_CLOSE_FAILED "})
aadd(aErro,{ 76,"Failed to read a line from the message data source.","MSG_READ_LINE_FAILED "})
aadd(aErro,{ 77,"Failed to write a line to the message data source.","MSG_WRITE_LINE_FAILED "})
aadd(aErro,{ 78,"There is no any attachments in the message data source.","MSG_NO_ATTACHMENTS "})
aadd(aErro,{ 79,"Message body exceeds maximum length.","MSG_BODY_TOO_BIG "})
aadd(aErro,{ 80,"Failed to add attachment to the message.","MSG_ATTACHMENT_ADD_FAILED "})
//aadd(aErro,{ ,"","// Data source errors"})
aadd(aErro,{ 81,"Failed to open data source.","DS_OPEN_FAILED "})
aadd(aErro,{ 82,"Failed to close data source.","DS_CLOSE_FAILED "})
aadd(aErro,{ 83,"Failed to write to the data source.","DS_WRITE_FAILED "})
//aadd(aErro,{ ,"","// Encoding errors"})
aadd(aErro,{ 84,"Invalid character in the stream.","ENCODING_INVALID_CHAR "})
aadd(aErro,{ 85,"Too many characters on one line.","ENCODING_LINE_TOO_LONG "})
//aadd(aErro,{ ,"","// IMAP4 errors"})
aadd(aErro,{ 86,"Server login failed. Username or password invalid.","LOGIN_FAILED "})
aadd(aErro,{ 87,"NOOP command failed.","NOOP_FAILED "})
aadd(aErro,{ 88,"Command unknown or arguments invalid.","UNKNOWN_COMMAND "})
aadd(aErro,{ 89,"Unknown response.","UNKNOWN_RESPONSE "})
aadd(aErro,{ 90,"You must login first.","AUTH_OR_SELECTED_STATE_REQUIRED "})
aadd(aErro,{ 91,"You must select the mailbox first.","SELECTED_STATE_REQUIRED "})
//aadd(aErro,{ ,"","//RAS Errors"})
aadd(aErro,{ 92,"Unable to load the required RAS DLLs","RAS_LOAD_ERROR "})
aadd(aErro,{ 93,"An error occurred during the dialing process","RAS_DIAL_ERROR "})
aadd(aErro,{ 94,"An error occurred when attempting to dial","RAS_DIALINIT_ERROR "})
aadd(aErro,{ 95,"An invalid RAS handle was given","RAS_HANDLE_ERROR "})
aadd(aErro,{ 96,"An error occurred when performing a RAS enumeration","RAS_ENUM_ERROR "})
aadd(aErro,{ 97,"An invalid or non-existant RAS entry name was given","RAS_ENTRYNAME_ERROR "})
//aadd(aErro,{ ,"","// Unclassified errors"})
aadd(aErro,{ 98,"Aborted by user.","ABORTED "})
aadd(aErro,{ 99,"A bad hostname format.","BAD_HOSTNAME "})
aadd(aErro,{ 100,"The address is not valid.","INVALID_ADDRESS "})
aadd(aErro,{ 101,"The address format is not valid.","INVALID_ADDRESS_FORMAT "})
aadd(aErro,{ 102,"User terminated the process.","USER_TERMINATED "})
aadd(aErro,{ 103,"The authorized name server was not found.","ANS_NOT_FOUND "})
aadd(aErro,{ 104,"Failed to set the server name.","SERVER_SET_NAME_FAILED "})
aadd(aErro,{ 105,"Parameter too long.","PARAMETER_TOO_LONG "})
aadd(aErro,{ 106,"Invalid value of the parameter.","PARAMETER_INVALID_VALUE "})
aadd(aErro,{ 107,"Get temorary filename failed.","TEMP_FILENAME_FAILED "})
aadd(aErro,{ 108,"Out of memory.","OUT_OF_MEMORY "})
aadd(aErro,{ 109,"Update of group information failed.","GROUP_INFO_UPDATE_FAILED "})
aadd(aErro,{ 110,"No selected news group.","GROUP_NOT_SELECTED "})
aadd(aErro,{ 111 ,"Internal error.","INTERNAL_ERROR "})
aadd(aErro,{ 112,"Already in use.","ALREADY_IN_USE "})
aadd(aErro,{ 113,"No current message set.","NO_CURRENT_MSG_SET "})
aadd(aErro,{ 114,"The Quote Command was empty","QUOTE_LINE_IS_EMPTY "})
aadd(aErro,{ 115,"The REST command is not supported by the server","REST_COMMAND_NOT_SUPPORTED "})
aadd(aErro,{ 116,"Failed to load system information.","SYSTEM_INFO_LOAD_FAILED "})
aadd(aErro,{ 117,"Failed to load user information.","USER_INFO_LOAD_FAILED "})
aadd(aErro,{ 118,"with this name is alredy existing.","USER_NAME_ALREDY_EXIST "})
aadd(aErro,{ 119,"with this name is alredy existing.","MAILBOX_NAME_ALREDY_EXIST "})
aadd(aErro,{ 120,"Authentication failed.","AUTH_FAILED "})
aadd(aErro,{ 121,"Server not capable to do authentication (Extended SMTP needed).","AUTH_SERVER_NOT_CAPABLE "})
aadd(aErro,{ 122,"Authentication method is not supported, only LOGIN and NTLM are supported","AUTH_METHOD_NOT_SUPPORTED "})

nCod := aScan(aErro,{|x| x[1] == nErro})

If nCod <> 0
	xRet := aErro[nCod][2]
Else
	xRet := "Erro indeterminado.Entre em contato com o suporte/desenvolvimento."
EndIf 
	
Return(xRet)                 
         




User Function ShowPN()
 	RpcSetType(3)
	PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "FAT" TABLES "SF1","SF2","SD1","SD2","SF4","SB5","SF3","SB1"
//	u_AAABBB("N","N",.T.)
aCols1 := {}
cErro := ""
cWarn := ""
AcABEC := {} 
cCnpj := "00000000000000" 
aadd(aCabec,{"F1_TIPO"   ,"D"}) // normal
aadd(aCabec,{"F1_FORMUL" ,"N"})
aadd(aCabec,{"F1_DOC"    ,"000000001"})
aadd(aCabec,{"F1_SERIE"  ,"1  "})
aadd(aCabec,{"F1_EMISSAO",DdATAbASE})
aadd(aCabec,{"F1_FORNECE","000999"})
aadd(aCabec,{"F1_LOJA"   ,"01"})
aadd(aCabec,{"F1_ESPECIE","CTE"})
aadd(aCabec,{"F1_CHVNFE" ,Space(44)}) 

/*
	Aadd(aCols1,{Padr("FPROD001",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),1,500,500,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD002",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),3,300,900,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD002",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),3,300,900,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD003",15),"Desc Produto",Padr(""          ,15),Replicate(" ",30),5,700,3500,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD004",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),6,800,4800,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD005",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),7,200,1400,Space(6),Space(3),.F.})	
	Aadd(aCols1,{Padr("FPROD006",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),8,400,3200,Space(6),Space(3),.F.})	

*/
	Aadd(aCols1,{"0001",Padr("FPROD001",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),1,500,500,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0002",Padr("FPROD002",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),3,300,900,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0003",Padr("FPROD002",15),"Desc Produto",Padr("3050110008",15),Replicate("-",30),3,300,900,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0004",Padr("FPROD003",15),"Desc Produto",Padr("3050110008",15),Replicate(" ",30),5,700,3500,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0005",Padr("FPROD004",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),6,800,4800,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0006",Padr("FPROD005",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),7,200,1400,"12345679123","000001","001",.F.})	
	Aadd(aCols1,{"0007",Padr("FPROD006",15),"Desc Produto",Padr("3050110009",15),Replicate("-",30),525852,8858585.400,388858200,"12345679123","000001","001",.F.})	
    
    cXml := Memoread("nfe.xml")
    oXml := XmlParser( cXml, "_", @cErro, @cWarn )  
	U_VisNota("55",cCnpj,oXml,aCols1,@aCabec,@aCols1)
Return
                               


//"N=Normal;D=Devolucao;B=Beneficiamento;C=Complemento Preco/Frete;I=Comp. ICMS;P=Comp. IPI"

User Function VisNota(cModelo,cCnpjXml, oXml, aCols1, aHead, aItens )
Local lRet       := .F.
Local aObjetos   := Array(10)
Local aCombo1    := {	"N=Normal",;	
						"D=Devolucao",;	
						"B=Beneficiamento",;	
						"I=Compl.  ICMS",;	
						"P=Compl.  IPI",;	
						"C=Compl. Preco/Frete"}
Local aCombo1A    := {	"Normal",;	
						"Devolucao",;	
						"Beneficiamento",;	
						"Compl.  ICMS",;	
						"Compl.  IPI",;	
						"Compl. Preco/Frete"}						
						
Local aCombo2       := {"Nao","Sim"}
Local nstyle        := GD_UPDATE 
Local lRodape       := .T. 
Local nTamProd      := TAMSX3("B1_COD")[1] 
Local bSavKeyF6		:= SetKey(VK_F6,Nil)
Private lPreNota 	:= .F.
Private lPedido 	:= AllTrim(GetNewPar("XM_PED_PRE","N")) == "S"  
Private lPCNFE     	:= GetNewPar("MV_PCNFE",.F.)
Private cUfOrig		:= Space(2)//Posicione("SA2",1,xFilial("SA2")+aHead[06][02]+aHead[07][02],"A2_EST")
Private cTipo		:= AllTrim(aHead[01][02])
Private cFormul		:= aHead[02][02]
Private cNFiscal	:= aHead[03][02]
Private cSerie		:= aHead[04][02]
Private dDEmissao	:= aHead[05][02]
Private cA100For	:= aHead[06][02]
Private cLoja		:= aHead[07][02]
Private cEspecie	:= aHead[08][02]
Private cNome       := Space(30) 
Private cCnpjFor   	:= cCnpjXml
Private cCnpj   	:= cCnpjXml
Private cCondicao	:= ""
Private cForAntNFE	:= ""
Private n			:= 1
Private aCols		:= {}
Private aHeader		:= {} 
Private lVisual     := .T. 
Private aButtons    := {}
Private aPosObj     := {}
Private bChange     := {|| U_XmlFLDOK(oGet2)}
Private bPedido     := {|| U_F6ItemPC( .F. ,NIL,NIL,.F.,.F.,aHeader,@aCols,,oGet2),aBackColsSDE:=ACLONE(aCols),oGet2}
Private bChange     := {|| U_RefGetF(oGet2) }
Private aColSIzes   := {20,20,20,20,20,20,20}//{30,60,30,60,30,40,40}
Private aHead1      := {}      
Private nI
Private oDlg
Private nUsado      := 0
Private lRefresh    := .T.  
Private aFields     := {}   
Private aComp       := {}
Private aGets       := {} 
Private nVar        := {}
Private cTextGet    := "" 
Private aColsSDE    := {}
Private lWhen       := .F.
Private lEditCab    := .F.  
Private cSayForn    := IIf(cTipo$"DB",RetTitle("F2_CLIENTE"),RetTitle("F1_FORNECE"))
Private nCabMod     := 2 
                       

Private aRotina := {{"Pesquisar", "AxPesqui", 0, 1},;
                    {"Visualizar", "AxVisual", 0, 2},;
                    {"Incluir", "AxInclui", 0, 3},;
                    {"Alterar", "AxAltera", 0, 4},;
                    {"Excluir", "AxDeleta", 0, 5}}



		
Aadd(aFields,{'D1_ITEM'})
Aadd(aFields,{'D1_COD'})
Aadd(aFields,{'D1_QUANT'})
Aadd(aFields,{'D1_VUNIT'})
Aadd(aFields,{'D1_TOTAL'})   
Aadd(aFields,{'D1_CC' })

If lPedido .Or. lPCNFE
	Aadd(aFields,{'D1_PEDIDO'}) 
	Aadd(aFields,{'D1_ITEMPC'})
	SetKey( VK_F6 , bPedido )
//	aAdd(aButtons, {'PEDIDO',{|| U_F6ItemPC(oGet2)},OemToAnsi("Selecionar Pedido de Compra ( por item )"+" - <F6> "),"222"} ) //
//	aAdd(aButtons, {'PEDIDO',{||A103ForF4( NIL, NIL, .F., .F., aHeader, @aCols,aHeader, aCols),aBackColsSDE:=ACLONE(aCols)},OemToAnsi("Selecionar Pedido de Compra"+" - <F5> "),"111"} ) //
	aAdd(aButtons, {'PEDIDO', bPedido ,OemToAnsi("Selecionar Pedido de Compra ( por item )"+" - <F6> "),"Item Ped."} ) //

EndIf    

aFieldEdit:= {"D1_COD","D1_CC","D1_PEDIDO","D1_ITEMPC"}  

DbSelectArea("SX3")
DbSetOrder(2)              



If cModelo == "57"
    aComp := Iif(Type("oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP") <> "U" ,oXml:_CTEPROC:_CTE:_INFCTE:_VPREST:_COMP,{})
    aComp := Iif(Type("aComp")== "A",aComp,{aComp})      
	lWhen := .F.
Else
    aComp := {}
    lWhen := .T.                                          
	lRodape := .F.
EndIf                          

For NI := 1 to Len(aFields) 
	If DbSeek(aFields[NI][1]) 
	       Aadd(aHead1,{Trim(X3Titulo()),;
                      SX3->X3_CAMPO,;
                      SX3->X3_PICTURE,;
                      SX3->X3_TAMANHO,;
                      SX3->X3_DECIMAL,;
                      "",;
                      "",;
                      SX3->X3_TIPO,;
                      SX3->X3_F3,;
                      "" })	
   		//___________________________________________________________________//
   		//
   		//   Adiciona os campos que não estão no dicionário na ordem correta
   		//___________________________________________________________________//
   		If  AllTrim(SX3->X3_CAMPO) == "D1_ITEM"
	   		Aadd(aHead1,{"Prod Xml","D1_PRODFOR","@!",nTamProd,0,"","","C",,"" })	
			Aadd(aHead1,{"Desc Xml","D1_PFORDES","@!",30,0,"","","C",,"" })	 
    	EndIf
		If  AllTrim(SX3->X3_CAMPO) == "D1_COD"
			aHead1[NI][8] := "SB1ZB5"
			Aadd(aHead1,{"Descrição","D1_DESCRIC","@!",30,0,"","","C",,"" })
		EndIf
	EndIf
Next

aHeader := aClone(aHead1)  
aCols := aClone(aCols1)  
			               
			   
If cTipo $ "D|B"
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+cA100For+cLoja) 
Else
	DbSelectArea("SA2")
	DbSetOrder(1)
	DbSeek(xFilial("SA2")+cA100For+cLoja) 
EndIf		   
			   
DEFINE MSDIALOG oDlg TITLE OemToAnsi("Documento de Entrada") FROM 0,0 TO 550,1100  PIXEL STYLE DS_MODALFRAME STATUS

	If nCabMod == 1
		@ 15,05 TO 70,545 LABEL "" OF oDlg PIXEL
		//Linha 1
		@ 20,015 SAY RetTitle("F1_TIPO") SIZE 35,09 OF oDlg PIXEL 
		@ 27,015 MSCOMBOBOX aObjetos[1] VAR cTipo ITEMS aCombo1 SIZE 50,90 OF oDlg PIXEL WHEN lWhen ON CHANGE SetF3But(cTipo,oForSa1,oForSa2,.T.)
		
		@ 20,115 SAY RetTitle("F1_FORMUL") SIZE 52,09 Of oDlg PIXEL 
		@ 27,115 MSCOMBOBOX aObjetos[2] VAR cFormul ITEMS aCombo2 SIZE 25,50 ;
			OF oDlg PIXEL   WHEN .F.                          
			
		@ 20,215 SAY RetTitle("F1_SERIE") SIZE 23,09 Of oDlg PIXEL
		@ 27,215 MSGET aObjetos[4] VAR cSerie  PICTURE PesqPict("SF1","F1_SERIE") ;
		    SIZE 18,09 OF oDlg PIXEL WHEN .F.
		
		@ 20,315 SAY RetTitle("F1_DOC") SIZE 45,09 Of oDlg PIXEL
		@ 27,315 MSGET aObjetos[3] VAR cNFiscal PICTURE PesqPict("SF1","F1_DOC") ;
			SIZE 34,09 OF oDlg PIXEL WHEN .F.
		
		//Linha 2	
		@ 45,015 SAY RetTitle("F1_EMISSAO") OF oDlg PIXEL SIZE 35,09
		@ 52,015 MSGET aObjetos[5] VAR dDEmissao PICTURE PesqPict("SF1","F1_EMISSAO") OF oDlg PIXEL SIZE 45 ,9 HASBUTTON WHEN .F.
		
		@ 45,115 SAY aObjetos[6] VAR cSayForn Of oDlg PIXEL SIZE 43,09
		
		//@ 52,115 MSGET aObjetos[7] VAR cA100For PICTURE PesqPict("SF1","F1_FORNECE") F3 RetF3(cTipo,IIf(cTipo$"DB","F2_CLIENTE","F1_FORNECE"));
		//	OF oDlg PIXEL SIZE 45,09 HASBUTTON  WHEN lWhen
			
		
		@ 52,115 MSGET oForSa1 VAR cA100For PICTURE PesqPict("SF2","F2_CLIENTE") F3 "SA1PRN";//RetF3("F2_CLIENTE");
			OF oDlg PIXEL SIZE 45,09 HASBUTTON Valid (existcpo("SA1",cA100For,,,,.F.)) WHEN lWhen
		
		@ 52,115 MSGET oForSa2 VAR cA100For PICTURE PesqPict("SF1","F1_FORNECE") F3 "SA2PRN";//RetF3("F1_FORNECE");
			OF oDlg PIXEL SIZE 45,09 HASBUTTON Valid (existcpo("SA2",cA100For,,,,.F.)) WHEN lWhen
			
		
		@ 45,215 SAY aObjetos[6] VAR "Loja" Of oDlg PIXEL SIZE 43,09	
		@ 52,215 MSGET aObjetos[8] VAR cLoja PICTURE PesqPict("SF1","F1_LOJA") ;
			F3 RetF3("F1_LOJA") OF oDlg PIXEL SIZE 15,09 HASBUTTON WHEN lWhen
		
		
		@ 45,315 SAY RetTitle("F1_ESPECIE") Of oDlg PIXEL SIZE 63,09
		@ 52,315 MSGET aObjetos[9] VAR cEspecie PICTURE PesqPict("SF1","F1_ESPECIE") ;
				OF oDlg PIXEL SIZE 30,09 HASBUTTON WHEN lWhen
		
		@ 45,415 SAY OemToAnsi("UF.Origem") Of oDlg PIXEL SIZE 63 ,9 // 
		@ 52,415 MSGET cUfOrig PICTURE "@!" F3 "12"  OF oDlg PIXEL SIZE 20,9 HASBUTTON WHEN lWhen
		
	Else

		@ 15,05 TO 70,545 LABEL "" OF oDlg PIXEL
		//Linha 1
		@ 20,015 SAY RetTitle("F1_TIPO") SIZE 35,09 OF oDlg PIXEL 
		@ 27,015 MSCOMBOBOX aObjetos[1] VAR cTipo ITEMS aCombo1 SIZE 50,90 OF oDlg PIXEL WHEN lWhen ON CHANGE SetF3But(cTipo,oForSa1,oForSa2,.T.,oForNome)
		
		@ 20,095 SAY RetTitle("F1_FORMUL") SIZE 52,09 Of oDlg PIXEL 
		@ 27,095 MSCOMBOBOX aObjetos[2] VAR cFormul ITEMS aCombo2 SIZE 25,50 ;
			OF oDlg PIXEL   WHEN .F.                          
			
		@ 20,175 SAY RetTitle("F1_SERIE") SIZE 23,09 Of oDlg PIXEL
		@ 27,175 MSGET aObjetos[4] VAR cSerie  PICTURE PesqPict("SF1","F1_SERIE") ;
		    SIZE 18,09 OF oDlg PIXEL WHEN .F.
		
		@ 20,255 SAY RetTitle("F1_DOC") SIZE 45,09 Of oDlg PIXEL
		@ 27,255 MSGET aObjetos[3] VAR cNFiscal PICTURE PesqPict("SF1","F1_DOC") ;
			SIZE 34,09 OF oDlg PIXEL WHEN .F.
		
		@ 20,335 SAY RetTitle("F1_EMISSAO") OF oDlg PIXEL SIZE 35,09
		@ 27,335 MSGET aObjetos[5] VAR dDEmissao PICTURE PesqPict("SF1","F1_EMISSAO") OF oDlg PIXEL SIZE 45 ,9 HASBUTTON WHEN .F.

		@ 20,485 SAY RetTitle("F1_ESPECIE") Of oDlg PIXEL SIZE 63,09
		@ 27,485 MSGET aObjetos[9] VAR cEspecie PICTURE PesqPict("SF1","F1_ESPECIE") ;
				OF oDlg PIXEL SIZE 30,09 HASBUTTON WHEN .F.


		
		@ 45,015 SAY aObjetos[6] VAR cSayForn Of oDlg PIXEL SIZE 43,09
		@ 52,015 MSGET oForSa1 VAR cA100For PICTURE PesqPict("SF2","F2_CLIENTE") F3 "SA1PRN";//RetF3("F2_CLIENTE");
			OF oDlg PIXEL SIZE 45,09 HASBUTTON VALID U_FillCab("SA1")//Valid (existcpo("SA1",cA100For,,,,.F.)) WHEN lWhen
		
		@ 52,015 MSGET oForSa2 VAR cA100For PICTURE PesqPict("SF1","F1_FORNECE") F3 "SA2PRN";//RetF3("F1_FORNECE");
			OF oDlg PIXEL SIZE 45,09 HASBUTTON VALID U_FillCab("SA2")//Valid (existcpo("SA2",cA100For,,,,.F.)) WHEN lWhen
			
		
		@ 45,095 SAY aObjetos[6] VAR "Loja" Of oDlg PIXEL SIZE 43,09	
		@ 52,095 MSGET aObjetos[8] VAR cLoja PICTURE PesqPict("SF1","F1_LOJA") ;
			F3 RetF3("F1_LOJA") OF oDlg PIXEL SIZE 15,09 HASBUTTON WHEN lWhen
		
		@ 45,175 SAY OemToAnsi("Nome") Of oDlg PIXEL SIZE 63 ,9 // 
		@ 52,175 MSGET oForNome VAR cNome PICTURE "@!" OF oDlg PIXEL SIZE 120,9 HASBUTTON READONLY

		@ 45,335 SAY OemToAnsi("CNPJ") Of oDlg PIXEL SIZE 63 ,9 // 
		@ 52,335 MSGET oCnpj VAR cCnpjFor PICTURE "@R 99.999.999/9999-99" OF oDlg PIXEL SIZE 80,9 HASBUTTON READONLY

		
		@ 45,485 SAY OemToAnsi("UF.Origem") Of oDlg PIXEL SIZE 63 ,9 // 
		@ 52,485 MSGET cUfOrig PICTURE "@!" F3 "12"  OF oDlg PIXEL SIZE 20,9 HASBUTTON READONLY


	
	EndIf

	SetF3But(cTipo,oForSa1,oForSa2,.F.,oForNome)	
//	@ 72,05 BUTTON oButRefresh PROMPT "Refresh" SIZE 045,015 ACTION  (U_RefGetF(oGet2)) OF oDlg PIXEL  
    
	If lROdape
		nBotomGet := 180
	Else
		nBotomGet := 230
	EndIf    

	oGet2 := MsNewGetDados():New(075,005,nBotomGet,545,nStyle,"U_RefGetF(oGet2)","U_XmlTOK(oGet2)",,aFieldEdit,,Len(aCols),"U_XmlFLDOK(oGet2)",,,oDlg,aHeader,aCols,bChange,)
	oGet2:SetArray( aCols ) 
//	oGet2 := MsGetDados():New(90, 05, 220, 495, 4, "U_XmlLINOK", "U_XmlTOK", "", .F., aFieldEdit, , .F., Len(aCols), "U_XmlFLDOK(oGet2)", "U_XmlDELOK", , "", oDlg)
//	oGet2:SetArray( aCols )   
	For nx := 1 to Min(Len(oGet2:OBROWSE:ACOLSIZES),Len(aColSizes) )
		oGet2:OBROWSE:ACOLSIZES[nx] := aColSizes[nx]
	Next
//	oGet2:forceRefresh()
	oGet2:OnChange()

	If lROdape
		XmlRodape(oDlg,cModelo,oXml,aComp)
	EndIf


ACTIVATE MSDIALOG oDlg CENTERED ;
	ON INIT EnchoiceBar(oDlg,{|| Iif(U_XMLOkCab(@aHead,oGet2),(nOpca:=1,lRet:=U_XmlSetNF(nOpca,oGet2,@aHead,@aItens)),.F.)      },;
							{|| nOpca:=2,oDlg:End()};
							,,aButtons)


SetKey(VK_F6,bSavKeyF6)
Return(lRet)

User Function XMLOkCab(aHead,oGet2)
Local lRet      := .T.           
Local cMsgErro  := ""

If cCnpjFor  <> cCnpj
	cMsgErro += "O CNPJ do Emissor do XML é diferente do Fornecedor/Cliente selecionado."+CRLF		   
EndIf

If Empty(cA100For)  .Or. Empty(cLoja)
	cMsgErro += "O código/loja do emissor do xml é obrigatorio."+CRLF		   
EndIf           

If cTipo $ "D|B"
	DbSelectArea("SA1")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA1")+cA100For+cLoja) 
		cMsgErro += "Código/loja do emissor do xml não encontrado."+CRLF
	Else
		If SA1->A1_CGC <> cCnpj
			cMsgErro += "O CNPJ do Emissor do XML é diferente do Fornecedor/Cliente selecionado."+CRLF			
		EndIf	
	EndIf
Else
	DbSelectArea("SA2")
	DbSetOrder(1)
	If !DbSeek(xFilial("SA2")+cA100For+cLoja) 
		cMsgErro += "Código/loja do emissor do xml não encontrado."+CRLF
	Else
		If SA2->A2_CGC <> cCnpj
			cMsgErro += "O CNPJ do Emissor do XML é diferente do Fornecedor/Cliente selecionado."+CRLF			
		EndIf	
	EndIf		
EndIf



If Empty(cMsgErro)
	aHead[01][02] := cTipo	
	aHead[02][02] := Substr(cFormul,1,1)	
	aHead[03][02] := cNFiscal	
	aHead[04][02] := cSerie		
	aHead[05][02] := dDEmissao	
	aHead[06][02] := cA100For	
	aHead[07][02] := cLoja		
	aHead[08][02] := cEspecie
Else
	U_MyAviso("Atenção",cMsgErro,{"OK"},3)              
	lRet := .F.
EndIf	
Return(lRet)

                     
User Function FillCab(cTab)
Local lret := .T.

If cTipo $ "D|B"
	cLoja    := SA1->A1_LOJA
	cNome    := SA1->A1_NOME  
//	cCnpjFor := SA1->A1_CGC
	cUfOrig  := SA1->A1_EST
Else //If cTab == "SA2" 
	cLoja    := SA2->A2_LOJA
	cNome    := SA2->A2_NOME  
//	cCnpjFor := SA2->A2_CGC
	cUfOrig  := SA2->A2_EST
EndIf

Return(lret)  
  
  
Static Function SetF3But(cTipo,oForSa1,oForSa2,lEmpty,oForNome)
Default lEmpty := .T.      
	If cTipo $ "D|B"
		oForSa2:Hide() 
		oForSa1:Show()
		cSayForn    := RetTitle("F2_CLIENTE")
		cNome       := SA1->A1_NOME
		cUfOrig     := SA1->A1_EST
	Else
		oForSa1:Hide() 
		oForSa2:Show()		    
		cSayForn    := RetTitle("F1_FORNECE")
		cNome       := SA2->A2_NOME			
		cUfOrig     := SA2->A2_EST
	EndIf


If lEmpty
	cA100For	:= Space(6)
	cLoja		:= Space(2)
	cNome       := Space(30) 
	cUfOrig     := Space(2)
//
EndIf
Return
            




User Function XmlSetNF(nOpca,oGet2,aHead,aCols1,oXml)               
Local Ny       := 0
Local nLinhas  := Len(oGet2:ACOLS) 
Local cMsgErro := "" 
Local lRet     := .T.
Local nPosProd := aScan(oGet2:AHEADER,{|x,y| AllTrim(x[2]) ==  "D1_COD" })
Local nPosCC   := aScan(oGet2:AHEADER,{|x,y| AllTrim(x[2]) ==  "D1_CC" })
Local nPosPed  := aScan(oGet2:AHEADER,{|x,y| AllTrim(x[2]) ==  "D1_PEDIDO" })
Local nPosItPc := aScan(oGet2:AHEADER,{|x,y| AllTrim(x[2]) ==  "D1_ITEMPC" })
Local aItemProc:= {}  
Local aItensFim:= {}
Local cTesPcNf := GetNewPar("MV_TESPCNF","") // Tes que nao necessita de pedido de compra amarrado
If nOpca == 1
	//aRetHead := aClone(aHead)
	For Ny := 1 to nLinhas
		If EmpTy(oGet2:ACOLS[Ny][04])
			cMsgErro += oGet2:ACOLS[Ny][01] + CRLF
			lRet := .F.
		Else	
			aCols1[Ny][01][2] := oGet2:ACOLS[Ny][04] // Codigo do Produto
			aCols1[Ny][05][2] := oGet2:ACOLS[Ny][09] // CC
			aCols1[Ny][06][2] := oGet2:ACOLS[Ny][10] // Pedido
			aCols1[Ny][07][2] := oGet2:ACOLS[Ny][11] // Item do Pedido			
            
            aItemProc:= aClone(aCols1[Ny]) 
            aSize(aItemProc,4)
            If  !Empty(aCols1[Ny][05][2])
            	aadd(aItemProc,aCols1[Ny][05])
            EndIf
 
			If nPosPed > 0
	            If  !Empty(aCols1[Ny][06][2]) .And. !Empty(aCols1[Ny][07][2])
	            	aadd(aItemProc,aCols1[Ny][06])
	            	aadd(aItemProc,aCols1[Ny][07])            	
	    		Else	
//					If !Empty(cTesPcNf) .And. (Posicione("SB1",1,xFilial("SB1")+oGet2:ACOLS[Ny][nPosProd],"B1_TE") $ AllTrim(cTesPcNf))
//		            	aadd(aItemProc,Space(6))
//		            	aadd(aItemProc,Space(2))   
//					Endif 
	            	
	            EndIf
   			EndIf
   			aadd(aItensFim,aItemProc)
   		EndIf
    Next
	
	If !lRet                           
		cMsgErro := "Preencha o(s) item(ns):"+CRLF+cMsgErro     
		U_MyAviso("Atenção",cMsgErro,{"OK"},3)
	
	Else
		aCols1 := aClone(aItensFim)
		oDlg:End()	
	EndIf
		

Else

	U_MyAviso("Atenção","Operação cancelada pelo usuário",{"OK"})

EndIf

Return(lRet)                                                                         
 
User FUnction XmlLINOK   
Local lRet := .T. 
Return(lRet)     


User FUnction XmlTOK(oGet2)
Local lRet    := .T. 
Local nw      := 0
Local nLinhas := Len(oGet2:ACOLS) 
Local cMsgErro:= ""  

For Nw := 1 To nLinhas
	If EmpTy(oGet2:ACOLS[Nw][04])
		cMsgErro += StrZero(Nw,4)+ " "
		lRet := .F.
	EndIf	
Next
If !lRet
	cMsgErro := "Preencha o(s) item(ns):"+CRLF+cMsgErro     
	U_MyAviso("Atenção",cMsgErro,{"OK"},3)
EndIf


oGet2:Refresh(.F.)


Return(lRet)


User FUnction XmlFLDOK(oGet2)
Local lRet := .T. 
Local nAt  := oGet2:nAt
 
If oGet2:OBROWSE:NCOLPOS == 4 
	oGet2:ACOLS[nAt][05] := Posicione("SB1",1,xFilial("SB1")+oGet2:ACOLS[oGet2:nAt][04],"B1_DESC")
//	ACOLS[nAt][05] := Posicione("SB1",1,xFilial("SB1")+oGet2:ACOLS[oGet2:nAt][04],"B1_DESC")
	oGet2:Refresh(.F.)
//	oGet2:ForceRefresh()
EndIf		

Return(lRet)
                          		
User FUnction XmlDELOK
Local lRet := .T.
Return(lRet)
             

User Function RefGetF(oGet2)
Local lRet := .T.
Local nw := 0
Local nLinhas := Len(oGet2:ACOLS)   


For Nw := 1 To nLinhas
	oGet2:ACOLS[Nw][05] := Posicione("SB1",1,xFilial("SB1")+oGet2:ACOLS[Nw][04],"B1_DESC")
Next

oGet2:Refresh(.F.)
Return(lRet)


Static Function XmlRodape(oDlg,cModelo,oXml,aComp)
Local oPage
Local aPages := {}        
Local Nx     := 0 
Local aGets  := {}
Private aPages := { "Componentes do Valor","Info"}  
Private nPageXml := aScan(aPages,{|x| x ==  "Componentes do Valor" })
Private nPageInfo:= aScan(aPages,{|x| x == "Info"})
Private oFont01:= TFont():New("Arial",07,12,,.T.,,,,.T.,.F.)        
Private oGet1,oGet2,oGet3,oGet4,oGet5,oGet6,oGet7,oGet8,oGet9,oGet10,oGet11,oGet12,oGet13
Private cTit1,cTit2,cTit3,cTit4,cTit5,cTit6,cTit7,cTit8,cTit9,cTit10,cTit11,cTit12,cTit13
Private nGet1:=nGet2:=nGet3:=nGet4:=nGet5:=nGet6:=nGet7:=nGet8:=nGet9:=nGet10:=nGet11:=nGet12:=nGet13:=0        
                  
If cModelo == "55"                             
	aPages := { "Componentes do Valor","Info"}  
	nPageXml := aScan(aPages,{|x| x ==  "Componentes do Valor" })
	nPageInfo:= aScan(aPages,{|x| x == "Info"})
	nComp := Len(aComp)
	nPosG1    := 000.50
	nPosG2    := 002.50
	nPosInc   := 002.125
	
	oPage := TFolder():New(182,005,aPages,{},oDlg,,,,.T.,.F.,540,079,)
	
	@ 00.2,00.5 to 4.6,067 OF oPage:aDialogs[nPageXml] 

	nCC1  := 005
	nCC2  := 010       
	nColCC:= 140
	nDist := 6
	nSalt := 020 

	//Coluna 1
	If Type("aComp[1]:_XNOME:TEXT") <> "U" .And. Type("aComp[1]:_VCOMP:TEXT") <> "U"
		@ nCC1    	  ,nCC2 Say aComp[1]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet1 VAR Val(aComp[1]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen          	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[2]:_XNOME:TEXT") <> "U" .And. Type("aComp[2]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[2]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet2 VAR Val(aComp[2]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen         	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[3]:_XNOME:TEXT") <> "U" .And. Type("aComp[3]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[3]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet3 VAR Val(aComp[3]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
  	 
		nCC1  := 005
		nCC2  += nColCC       
	



ElseIf cModelo == "57"
	lWhen := .F.
	aPages := { "Componentes do Valor","Info"}  
	nPageXml := aScan(aPages,{|x| x ==  "Componentes do Valor" })
	nPageInfo:= aScan(aPages,{|x| x == "Info"})
	nComp := Len(aComp)

	nPosG1    := 000.50
	nPosG2    := 002.50
	nPosInc   := 002.125
	
	oPage := TFolder():New(182,005,aPages,{},oDlg,,,,.T.,.F.,540,079,)
	
	@ 00.2,00.5 to 4.6,067 OF oPage:aDialogs[nPageXml] 
	
	nCC1  := 005
	nCC2  := 010       
	nColCC:= 140
	nDist := 6
	nSalt := 020 

	//Coluna 1
	If Type("aComp[1]:_XNOME:TEXT") <> "U" .And. Type("aComp[1]:_VCOMP:TEXT") <> "U"
		@ nCC1    	  ,nCC2 Say aComp[1]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet1 VAR Val(aComp[1]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen          	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[2]:_XNOME:TEXT") <> "U" .And. Type("aComp[2]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[2]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet2 VAR Val(aComp[2]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen         	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[3]:_XNOME:TEXT") <> "U" .And. Type("aComp[3]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[3]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet3 VAR Val(aComp[3]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
  	 
		nCC1  := 005
		nCC2  += nColCC       
	
		//Coluna 2
  
   	If Type("aComp[4]:_XNOME:TEXT") <> "U" .And. Type("aComp[4]:_VCOMP:TEXT") <> "U"	
		@ nCC1    	  ,nCC2 Say aComp[4]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet4 VAR Val(aComp[4]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[5]:_XNOME:TEXT") <> "U" .And. Type("aComp[5]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[5]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet5 VAR Val(aComp[5]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[6]:_XNOME:TEXT") <> "U" .And. Type("aComp[6]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[6]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet6 VAR Val(aComp[6]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen          	    
		nCC1  += nSalt
    EndIf
	   
		nCC1  := 005
		nCC2  += nColCC       
	
		//Coluna 3 
 
  	If Type("aComp[7]:_XNOME:TEXT") <> "U" .And. Type("aComp[7]:_VCOMP:TEXT") <> "U"	
		@ nCC1    	  ,nCC2 Say aComp[7]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet7 VAR Val(aComp[7]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[8]:_XNOME:TEXT") <> "U" .And. Type("aComp[8]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[8]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet8 VAR Val(aComp[8]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[9]:_XNOME:TEXT") <> "U" .And. Type("aComp[9]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[9]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet9 VAR Val(aComp[9]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
 
 		nCC1  := 005
		nCC2  += nColCC       
	
		//Coluna 4
 
  	If Type("aComp[10]:_XNOME:TEXT") <> "U" .And. Type("aComp[10]:_VCOMP:TEXT") <> "U"	
		@ nCC1    	  ,nCC2 Say aComp[10]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet10 VAR Val(aComp[10]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen          	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[11]:_XNOME:TEXT") <> "U" .And. Type("aComp[11]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[11]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet11 VAR Val(aComp[11]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
   	If Type("aComp[12]:_XNOME:TEXT") <> "U" .And. Type("aComp[12]:_VCOMP:TEXT") <> "U"
		@ nCC1        ,nCC2 Say aComp[12]:_XNOME:TEXT  PIXEL OF oPage:aDialogs[nPageXml] COLOR CLR_BLUE FONT oFont01
		@ nCC1+nDist  ,nCC2 MSGet oGet12 VAR Val(aComp[12]:_VCOMP:TEXT) SIZE 60,08 PICTURE "@E 999,999.99" PIXEL OF oPage:aDialogs[nPageXml] WHEN lWhen           	    
		nCC1  += nSalt
    EndIf
Else

EndIf
		
Return()




User Function XMLF6ItemPC2(oGet2)
Local lRet    := .T. 
Local Nx      := 0
Local aFields := {"C7_NUM","C7_ITEM","C7_PRODUTO","C7_QUANT"}      
Local aCab    := {}
Local aCampos := {} 
Local aTamCab := {} 
Local aPedido := {}
Local nPosPRD := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD := aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local cVar	  := aCols[n][nPosPrd]
Local oPanel , oDlg
Local nSavQual:= 0  
Local bClickF6 := {|| BblClkPC(oGet2,oQual,nPosPDD,nPosITM), oDlg:End() }
Local aButPed		:= { {'PESQUISA',{||A103VisuPC(aPedido[oQual:nAt][2])},"Visualiza Pedido","Visualiza Pedido"},; //
	{'pesquisa',{||A103PesqP(aCab,aCampos,aPedido,oQual)},"Pesquisar"} } //
//MsgAlert("Pedido") 
aadd(aPedido,{"012358","01",Padr("FRETE",15),  12} )
aadd(aPedido,{"775858","03",Padr("FRETE",15),  01} )
aadd(aPedido,{"222222","05",Padr("FRETE",15),  14} )
aadd(aPedido,{"099999","05",Padr("FRETE",15), 100} ) 

DbSelectArea("SX3")
DbSetOrder(2)

For Nx := 1 To Len(aFields)

	DbSeek(aFields[Nx])
	AAdd(aCab,x3Titulo())
	Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
	aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
Next
                   

	DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item ) - <F6> ") Of oDlg PIXEL //"Selecionar Pedido de Compra ( por item )"

	    
	DbSelectArea("SX3")
 	DbSetOrder(2)								
	
	For nX := 1 to Len(aCab)
    	If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
			If SX3->(MsSeek(aCab[nX]))				
        		aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
        	EndIf
   		EndIf
	Next
	


	@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
	oPanel:Align := CONTROL_ALIGN_TOP

	oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
	oQual:SetArray(aPedido)
	oQual:bLine := { || aPedido[oQual:nAT] }
	oQual:BLDBLCLICK := bClickF6 
	oQual:nFreeze := 1 

	oQual:Align := CONTROL_ALIGN_ALLCLIENT

	If !Empty(cVar)
		@ 6  ,4   SAY OemToAnsi("Produto") Of oPanel PIXEL SIZE 47 ,9 //"Produto"
		@ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9
	Else
		@ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra") Of oPanel PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
	EndIf

	ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bClickF6,{||oDlg:End()},,aButPed)
Conout("Pedido")
Return      






Static Function BblClkPC(oGet2,oQual,nPosPDD,nPosITM) 
Local nPc := oQual:nAT 
Local nIt := oGet2:NAT
 
oGet2:ACOLS[nIt][nPosPDD] := oQual:AARRAY[nPc][1]
oGet2:ACOLS[nIt][nPosITM] := oQual:AARRAY[nPc][3] 

oGet2:Refresh(.F.)
   
Return




/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  F6ItemPC ³ Autor ³Roberto Souza        ³ Data ³27/06/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Retorna a especie padrao de acordo com o modelo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function F6ItemPC(lUsaFiscal,aPedido,oGetDAtu,lNfMedic,lConsMedic,aHeadSDE,aColsSDE,aGets,oGet2)

Local cSeek			:= ""
Local nOpca			:= 0
Local aArea			:= GetArea()
Local aAreaSA2		:= SA2->(GetArea())
Local aAreaSC7		:= SC7->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aRateio       := {0,0,0}
Local aNew			:= {}
Local aTamCab		:= {}
Local lGspInUseM	:= If(Type('lGspInUse')=='L', lGspInUse, .F.)
Local aButtons		:= { {'PESQUISA',{||A103VisuPC(aArrSldo[oQual:nAt][2])},"Visualiza Pedido","Visualiza Pedido"},; //"Visualiza Pedido"
	{'pesquisa',{||A103PesqP(aCab,aCampos,aArrayF4,oQual)},"Pesquisar"} } //"Pesquisar"
Local aEstruSC7		:= SC7->( dbStruct() )
Local bSavSetKey	:= SetKey(VK_F4,Nil)
Local bSavKeyF5		:= SetKey(VK_F5,Nil)
Local bSavKeyF6		:= SetKey(VK_F6,Nil)
Local bSavKeyF7		:= SetKey(VK_F7,Nil)
Local bSavKeyF8		:= SetKey(VK_F8,Nil)
Local bSavKeyF9		:= SetKey(VK_F9,Nil)
Local bSavKeyF10	:= SetKey(VK_F10,Nil)
Local bSavKeyF11	:= SetKey(VK_F11,Nil)
Local nFreeQt		:= 0
Local nPosPRD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_COD" })
Local nPosPDD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_PEDIDO" })
Local nPosITM		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_ITEMPC" })
Local nPosQTD		:= aScan(aHeader,{|x| Alltrim(x[2]) == "D1_QUANT" })
Local nPosTes       := aScan(aHeader,{|x| AllTrim(x[2])=="D1_TES"})
Local nLinACols     := N
Local cVar			:= oGet2:ACOLS[oGet2:NAT][4] //aCols[n][nPosPrd] 
Local cQuery		:= ""
Local cAliasSC7		:= "SC7"
Local cCpoObri		:= ""
Local nSavQual
Local nPed			:= 0
Local nX			:= 0
Local nAuxCNT		:= 0
Local lMt103Vpc		:= ExistBlock("MT103VPC")
Local lMt100C7D		:= ExistBlock("MT100C7D")
Local lMt100C7C		:= ExistBlock("MT100C7C")
Local lMt103Sel		:= ExistBlock("MT103SEL")
Local nMT103Sel     := 0
Local nSelOk        := 1
Local lRet103Vpc	:= .T.
Local lContinua		:= .T.
Local lQuery		:= .F.
Local oQual
Local oDlg
Local oPanel
Local aUsButtons  := {}
Local bClickF6 := {|| BblClkPC(oGet2,oQual,nPosPDD,nPosITM), nSavQual:=oQual:nAT,nOpca:=1,oDlg:End() }

PRIVATE aCab	   := {}
PRIVATE aCampos	   := {}
PRIVATE aArrSldo   := {}
PRIVATE aArrayF4   := {} 
PRIVATE lConsLoja  := .F.

DEFAULT lUsaFiscal := .T.
DEFAULT aPedido	   := {}
DEFAULT lNfMedic   := .F.
DEFAULT lConsMedic := .F.
DEFAULT aHeadSDE   := {}
DEFAULT aColsSDE   := {}
DEFAULT aGets      := {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf  

If Empty(cVar)
	U_MyAviso("Atenção","Selecione o produto antes.",{"OK"},2)
	lContinua:= .F.
EndIf
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Adiciona botoes do usuario na EnchoiceBar                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ExistBlock( "MTIPCBUT" )
	If ValType( aUsButtons := ExecBlock( "MTIPCBUT", .F., .F. ) ) == "A"
		AEval( aUsButtons, { |x| AAdd( aButtons, x ) } )
	EndIf
EndIf

If lContinua

	If MaFisFound('NF') .Or. !lUsaFiscal
		If cTipo == 'N'
			#IFDEF TOP
				DbSelectArea("SC7")
				If TcSrvType() <> "AS/400"

					If Empty(cVar)
						DbSetOrder(9)
					Else
						DbSetOrder(6)
					EndIf

					lQuery    := .T.
					cAliasSC7 := "QRYSC7"

					cQuery	  := "SELECT "
					For nAuxCNT := 1 To Len( aEstruSC7 )
						If nAuxCNT > 1
							cQuery += ", "
						EndIf
						cQuery += aEstruSC7[ nAuxCNT, 1 ]
					Next
					cQuery += ", R_E_C_N_O_ RECSC7 FROM "
					cQuery += RetSqlName("SC7") + " SC7 "
					cQuery += "WHERE "
					cQuery += "C7_FILENT = '"+xFilEnt(xFilial("SC7"))+"' AND "

					If HasTemplate( "DRO" ) .AND. FunName() == "MATA103" .AND. MV_PAR15 == 1
						cQuery += "C7_FORNECE IN ( " + T_DrogForn( cA100For ) + " ) AND "
					Else
					If Empty(cVar)
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
						Endif	
					Else
						If lConsLoja
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_LOJA = '"+cLoja+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Else
							cQuery += "C7_FORNECE = '"+cA100For+"' AND "
							cQuery += "C7_PRODUTO = '"+cVar+"' AND "
						Endif
					Endif
					EndIf

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os pedidos de compras de acordo com os contratos             ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If lConsMedic
						If lNfMedic
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos oriundos de medicoes                         ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA<>'"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO<>'" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						Else
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Traz apenas os pedidos que nao possuem medicoes                     ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							cQuery += "C7_CONTRA='"  + Space( Len( SC7->C7_CONTRA ) )  + "' AND "
							cQuery += "C7_MEDICAO='" + Space( Len( SC7->C7_MEDICAO ) ) + "' AND "		    		
						EndIf
					EndIf 					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados e Previstos.                ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					cQuery += "C7_TPOP <> 'P' AND "
					If SuperGetMV("MV_RESTNFE") == "S"
						cQuery += "C7_CONAPRO <> 'B' AND "
					EndIf					
					cQuery += "SC7.C7_ENCER='"+Space(Len(SC7->C7_ENCER))+"' AND "					
					cQuery += "SC7.C7_RESIDUO='"+Space(Len(SC7->C7_RESIDUO))+"' AND "					

					cQuery += "SC7.D_E_L_E_T_ = ' '"
					cQuery += "ORDER BY "+SqlOrder(SC7->(IndexKey()))	

//					cQuery := ChangeQuery(cQuery)

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasSC7,.T.,.T.)
					For nX := 1 To Len(aEstruSC7)
						If aEstruSC7[nX,2]<>"C"
							TcSetField(cAliasSC7,aEstruSC7[nX,1],aEstruSC7[nX,2],aEstruSC7[nX,3],aEstruSC7[nX,4])
						EndIf
					Next nX										
				Else
			#ENDIF			
				If Empty(cVar)
					DbSelectArea("SC7")
					DbSetOrder(9)
					If lConsLoja
						cCond := "C7_FILENT+C7_FORNECE+C7_LOJA"
						cSeek := cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_FORNECE"
						cSeek := cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				Else
					DbSelectArea("SC7")
					DbSetOrder(6)
					If lConsLoja
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE+C7_LOJA"
						cSeek := cVar+cA100For+cLoja
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					Else
						cCond := "C7_FILENT+C7_PRODUTO+C7_FORNECE"
						cSeek := cVar+cA100For
						MsSeek(xFilEnt(xFilial("SC7"))+cSeek)
					EndIf
				EndIf
				#IFDEF TOP
				EndIf
				#ENDIF

			If Empty(cVar)
				cCpoObri := "C7_LOJA|C7_PRODUTO|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Else
				cCpoObri := "C7_LOJA|C7_QUANT|C7_DESCRI|C7_TIPO|C7_LOCAL|C7_OBS"
			Endif				

			If (cAliasSC7)->(!Eof())

				DbSelectArea("SX3")
				DbSetOrder(2)

				If lNfMedic .And. lConsMedic

					MsSeek("C7_MEDICAO")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_CONTRA")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

					MsSeek("C7_PLANILH")

					AAdd(aCab,x3Titulo())
					Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
					aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				EndIf 			

				MsSeek("C7_NUM")

				AAdd(aCab,x3Titulo())
				Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
				aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))

				DbSelectArea("SX3")
				DbSetOrder(1)
				MsSeek("SC7")
				While !Eof() .And. SX3->X3_ARQUIVO == "SC7"
					IF ( SX3->X3_BROWSE=="S".And.X3Uso(SX3->X3_USADO).And. AllTrim(SX3->X3_CAMPO)<>"C7_PRODUTO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_NUM" .And.;
							If( lConsMedic .And. lNfMedic, AllTrim(SX3->X3_CAMPO)<>"C7_MEDICAO" .And. AllTrim(SX3->X3_CAMPO)<>"C7_CONTRA" .And. AllTrim(SX3->X3_CAMPO)<>"C7_PLANILH", .T. )).Or.;
							(AllTrim(SX3->X3_CAMPO) $ cCpoObri)
						AAdd(aCab,x3Titulo())
						Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
						aadd(aTamCab,CalcFieldSize(SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_PICTURE,X3Titulo()))
					EndIf
					dbSkip()		
				Enddo					

				DbSelectArea(cAliasSC7)
				Do While If(lQuery, ;
						(cAliasSC7)->(!Eof()), ;
						(cAliasSC7)->(!Eof()) .And. xFilEnt(cFilial)+cSeek == &(cCond))

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Filtra os Pedidos Bloqueados, Previstos e Eliminados por residuo   ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If !lQuery
						If (SuperGetMV("MV_RESTNFE") == "S" .And. (cAliasSC7)->C7_CONAPRO == "B") .Or. ;
								(cAliasSC7)->C7_TPOP == "P" .Or. !Empty((cAliasSC7)->C7_RESIDUO)
							dbSkip()
							Loop
						EndIf
					Endif

					nFreeQT := 0

					nPed    := aScan(aPedido,{|x| x[1] = (cAliasSC7)->C7_NUM+(cAliasSC7)->C7_ITEM})

					nFreeQT -= If(nPed>0,aPedido[nPed,2],0)

					For nAuxCNT := 1 To Len( aCols )
						If (nAuxCNT # n) .And. ;
							(aCols[ nAuxCNT,nPosPRD ] == (cAliasSC7)->C7_PRODUTO) .And. ;
							(aCols[ nAuxCNT,nPosPDD ] == (cAliasSC7)->C7_NUM) .And. ;
							(aCols[ nAuxCNT,nPosITM ] == (cAliasSC7)->C7_ITEM) .And. ;
							!ATail( aCols[ nAuxCNT ] )
							nFreeQT += aCols[ nAuxCNT,nPosQTD ]
						EndIf
					Next
					
					lRet103Vpc := .T.

					If lMt103Vpc
						If lQuery
							('SC7')->(dbGoto((cAliasSC7)->RECSC7))
						EndIf															
						lRet103Vpc := Execblock("MT103VPC",.F.,.F.)
					Endif

					If lRet103Vpc
						If ((nFreeQT := ((cAliasSC7)->C7_QUANT-(cAliasSC7)->C7_QUJE-(cAliasSC7)->C7_QTDACLA-nFreeQT)) > 0)
							Aadd(aArrayF4,Array(Len(aCampos)))							

							SB1->(DbSetOrder(1))
							SB1->(MsSeek(xFilial("SB1")+(cAliasSC7)->C7_PRODUTO))							
							For nX := 1 to Len(aCampos)

								If aCampos[nX][3] != "V"
									If aCampos[nX][2] == "N"
										If Alltrim(aCampos[nX][1]) == "C7_QUANT"
											aArrayF4[Len(aArrayF4)][nX] :=Transform(nFreeQt,PesqPict("SC7",aCampos[nX][1]))
										ElseIf Alltrim(aCampos[nX][1]) == "C7_QTSEGUM"
											aArrayF4[Len(aArrayF4)][nX] :=Transform(ConvUm(SB1->B1_COD,nFreeQt,nFreeQt,2),PesqPict("SC7",aCampos[nX][1]))
										Else
											aArrayF4[Len(aArrayF4)][nX] := Transform((cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1]))),PesqPict("SC7",aCampos[nX][1]))
										Endif											
									Else
										aArrayF4[Len(aArrayF4)][nX] := (cAliasSC7)->(FieldGet(FieldPos(aCampos[nX][1])))								
									Endif	
								Else
									aArrayF4[Len(aArrayF4)][nX] := CriaVar(aCampos[nX][1],.T.)
									If Alltrim(aCampos[nX][1]) == "C7_CODGRP"
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_GRUPO                            									
									EndIf
									If Alltrim(aCampos[nX][1]) == "C7_CODITE"
										aArrayF4[Len(aArrayF4)][nX] := SB1->B1_CODITE
									EndIf
								Endif

							Next

							aAdd(aArrSldo, {nFreeQT, IIF(lQuery,(cAliasSC7)->RECSC7,(cAliasSC7)->(RecNo()))})

							If lMT100C7D
								If lQuery
									('SC7')->(dbGoto((cAliasSC7)->RECSC7))
								EndIf									
								aNew := ExecBlock("MT100C7D", .f., .f., aArrayF4[Len(aArrayF4)])
								If ValType(aNew) = "A"
									aArrayF4[Len(aArrayF4)] := aNew
								EndIf
							EndIf
						EndIf
					Endif
					(cAliasSC7)->(dbSkip())
				EndDo

				If ExistBlock("MT100C7L")
					ExecBlock("MT100C7L", .F., .F., { aArrayF4, aArrSldo })
				EndIf

				If !Empty(aArrayF4)

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Monta dinamicamente o bline do CodeBlock                 ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					DEFINE MSDIALOG oDlg FROM 30,20  TO 265,521 TITLE OemToAnsi("Selecionar Pedido de Compra ( por item )"+" - <F6> ") Of oMainWnd PIXEL //"Selecionar Pedido de Compra ( por item )"

					If lMT100C7C
						aNew := ExecBlock("MT100C7C", .f., .f., aCab)
						If ValType(aNew) == "A"
							aCab := aNew      
							    
							DbSelectArea("SX3")
			 				DbSetOrder(2)								
							
							For nX := 1 to Len(aCab)
						    	If aScan(aCampos,{|x| x[1]= aCab[nX]})==0
        						 If SX3->(MsSeek(aCab[nX]))				
        						 		Aadd(aCampos,{SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_CONTEXT,SX3->X3_PICTURE})
        						 EndIf
   								EndIf
							Next nX
							
							
						EndIf
					EndIf

					@ 12,0 MSPANEL oPanel PROMPT "" SIZE 100,19 OF oDlg CENTERED LOWERED //"Botoes"
					oPanel:Align := CONTROL_ALIGN_TOP

					oQual := TWBrowse():New( 29,4,243,85,,aCab,aTamCab,oDlg,,,,,,,,,,,,.F.,,.T.,,.F.,,,)
					oQual:SetArray(aArrayF4)
					oQual:bLine := { || aArrayF4[oQual:nAT] }
					oQual:BLDBLCLICK := bClickF6
					OQual:nFreeze := 1 

					oQual:Align := CONTROL_ALIGN_ALLCLIENT

					If !Empty(cVar)
						@ 6  ,4   SAY OemToAnsi("Produto") Of oPanel PIXEL SIZE 47 ,9 //"Produto"
						@ 4  ,30  MSGET cVar PICTURE PesqPict('SB1','B1_COD') When .F. Of oPanel PIXEL SIZE 80,9
					Else
						@ 6  ,4   SAY OemToAnsi("Selecione o Pedido de Compra") Of oPanel PIXEL SIZE 120 ,9 //"Selecione o Pedido de Compra"
					EndIf

					ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,bClickF6,{||oDlg:End()},,aButtons)
					
				  	If lMt103Sel .And. !Empty(nSavQual)		
				   		nOpca := If(ValType(nMT103Sel:=ExecBlock("MT103SEL",.F.,.F.,{aArrSldo[nSavQual][2]}))=='N',nMT103Sel,nOpca)
				   	Endif     
					If nOpca == 1
						DbSelectArea("SC7")
						MsGoto(aArrSldo[nSavQual][2])
						
   				        // Verifica se o Produto existe Cadastrado na Filial de Entrada
					    DbSelectArea("SB1")
						DbSetOrder(1)
						MsSeek(xFilial("SB1")+SC7->C7_PRODUTO)
						If !Eof()
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Qdo digitado o produto no aCols para buscar o PC via F6 e carregado uma TES vinda do  ³
							//³ SB1 se esta for igual a TES digitada no PC o recalculo dos impostos nao e acionado    ³
							//³ na matxfis,para forcar o recalculo o TES do aCols e limpa neste ponto.                ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If lUsaFiscal
								aCols[nLinACols][nPosTes] := CriaVar(aHeader[nPosTes][2]) 
								MaFisAlt("IT_TES",aCols[nLinACols][nPosTes],nLinACols)
                            EndIf
/*                            
							If	!ATail( aCols[ n ] )
								NfePC2Acol(aArrSldo[nSavQual][2],n,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)
		        				Else
								NfePC2Acol(aArrSldo[nSavQual][2],n+1,aArrSldo[nSavQual][1],,,@aRateio,aHeadSDE,@aColsSDE)        				
		        				EndIf
*/							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ Impede que o item do PC seja deletado pela getdados da NFE na movimentacao das setas. ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
							If ValType( oGetDAtu ) == "O"
								oGetDAtu:lNewLine := .F.
							Else
								If Type( "oGetDados" ) == "O"
									oGetDados:lNewLine:=.F.
								EndIf
							EndIf
						Else
  						   Aviso("A103ItemPC","O Produto selecionado do Pedido de compra, não possui cadastro na Filial de Entrada da Nota Fiscal. Favor efetuar cadastro !",{"Ok"})
						EndIf
					EndIf
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Rateio do valores de Frete/Seguro/Despesa do PC            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
/*
					If lUsaFiscal
						Eval(bRefresh)
					Else
						aGets[07] += aRateio[1]
						aGets[05]+= aRateio[2]
						aGets[04]  += aRateio[3]
					EndIf
*/
				Else
					U_MyAviso("Aviso","Item sem pedidos disponíveis para este fornecedor.",{"OK"})
//					Help(" ",1,"A103F4")
				EndIf
			Else
				U_MyAviso("Aviso","Item sem pedidos disponíveis para este fornecedor.",{"OK"})
//				Help(" ",1,"A103F4")

			EndIf
		Else
			U_MyAviso("Aviso","Consulta habilitada apenas para notas do tipo N=Normal.",{"OK"})
		EndIf
	Else
		Help('   ',1,'A103CAB')
	EndIf

Endif

If lQuery
	DbSelectArea(cAliasSC7)
	dbCloseArea()
	DbSelectArea("SC7")
Endif	

SetKey(VK_F4,bSavSetKey)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
RestArea(aAreaSA2)
RestArea(aAreaSC7)
RestArea(aAreaSB1)
RestArea(aArea)
Return() 
                  

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  RetF3    ³ Autor ³Roberto Souza        ³ Data ³27/06/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Pesquisa de GET usando F3                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RetF3(cCampo,cDefault)
Local aArea	:= GetArea()
Local cF3 	:= ""
Local cSavRec
//cCampo := IIf(cTipo$"DB","F2_CLIENTE","F1_FORNECE")
cDefault 	:= IIF(cDefault==Nil,"",cDefault)

dbSelectArea("SX3")
cSavRec	:= RecNo()
dbSetOrder(2)
If dbSeek(cCampo)
	If !Empty(X3_F3)
		cF3 := X3_F3
	Else
		cF3 := cDefault
	EndIf
EndIf
dbSetOrder(1)
dbGoto(cSavRec)
RestArea(aArea)

Return(cF3)     
           
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  SpecXml  ³ Autor ³Roberto Souza        ³ Data ³27/06/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Retorna a especie padrao de acordo com o modelo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SpecXml(cModelo, cDefault)
Local cRet := ""
Default cModelo := "55"
Default cDefault := "SPED"
If cModelo == "55"
	cRet := "SPED"                     
ElseIf cModelo == "57"
	cRet := "CTE" 
Else 
	cRet := cDefault
EndIf	         

Return(cRet)



/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³  XChkXml  ³ Autor ³Roberto Souza        ³ Data ³30/08/2012 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³  Retorna a especie padrao de acordo com o modelo           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function XChkXml()
Local lRet := .T.           
Local aArea     := GetArea()
Local cQry      := ""
Local cWhere    := ""
Local cAliasZBZ := GetNextAlias()
Local nOk       := 0
Local nNo       := 0 
Private lSharedA1:= U_IsShared("SA1")
Private lSharedA2:= U_IsShared("SA2")
Private dDtProc := dDatabase - 90   // Parametrizar
Default cLogProc:= ""
Default lAuto   := .F.     
Default oProcess:= Nil
Default lEnd    := .F. 
Default nCount  := 0

ProcRegua(0)

    cLogProc +="### Atualizando Status Xml. ###"+CRLF
				               
	cWhere := "%( (ZBZ.ZBZ_PRENF NOT IN ('F') AND ZBZ.ZBZ_DTRECB >='" +Dtos(dDtProc)+"') )%"			
	cCampos	:=	"%,ZBZ_CODFOR,ZBZ_LOJFOR%"
	
	BeginSql Alias cAliasZBZ
	
	SELECT	ZBZ_FILIAL, ZBZ_NOTA, ZBZ_SERIE, ZBZ_DTNFE, ZBZ_PRENF, ZBZ_CNPJ, ZBZ_FORNEC, ZBZ_CNPJD, ZBZ_CLIENT,ZBZ_CHAVE,ZBZ_TPDOC, ZBZ.R_E_C_N_O_ 
			%Exp:cCampos%
			FROM %Table:ZBZ% ZBZ
			WHERE ZBZ.%notdel%
    		AND %Exp:cWhere%
	EndSql           
	
	DbSelectArea("SF1")
    DbSetOrder(1)
    DbGoTop()
	DbSelectArea(cAliasZBZ)   
	
	
	While !(cAliasZBZ)->(Eof())    
    
 

		DbSelectArea("ZBZ")
		DbGoTo((cAliasZBZ)->R_E_C_N_O_)
		
		Upd001()
		Upd002()   
		
		IncProc("Processando "+(cAliasZBZ)->ZBZ_SERIE+"/"+Padr(cNotaSeek,9))
		(cAliasZBZ)->(DbSkip())    	
	EndDo             

Return(lRet)

 


User Function UPCfgXML()
Local cRet := ""
Local aJobs:= {}
Local Nx   := 1
Local oDlg                                                        
Local oChkOnX, oChkOn1, oChkOn2, oChkOn3, oChkOn4, oChkOn5
Local cRotImp  := GetNewPar("XM_ROTINAS","1,2,3")
Local lChkOnX  :=  ("X" $ cRotImp)
Local lChkOn1  :=  ("1" $ cRotImp)
Local lChkOn2  :=  ("2" $ cRotImp)
Local lChkOn3  :=  ("3" $ cRotImp)
Local lChkOn4  :=  ("4" $ cRotImp)
Local lChkOn5  :=  ("5" $ cRotImp)
Local nOpc     := 0
Private oFont01:= TFont():New("Arial",07,14,,.T.,,,,.T.,.F.)
//
// A Consulta de xml (4) é desabilitada por default para evitar lentidão	 
//
                                                                  
DEFINE MSDIALOG oDlg TITLE "Selecao de Rotinas" FROM 000,000 TO 300,400 PIXEL STYLE DS_MODALFRAME STATUS

@ 00.5,00.5 to 009,024.5 OF oDlg   

@ 010 ,010 SAY "Selecione as rotinas a serem executadas:" PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
@ 030 ,010 CHECKBOX oChkOnX VAR lChkOnX PROMPT "X-Todos"            SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01//;
//         ON CHANGE(Iif( lChkOnX ,(oChkOn1:LREADONLY:=.T.,lChkOn2:LREADONLY:=.T.,lChkOn3:LREADONLY:=.T.),;
//         			             (oChkOn1:LREADONLY:=.F.,lChkOn2:LREADONLY:=.F.,lChkOn3:LREADONLY:=.F.))    )

@ 045 ,010 CHECKBOX oChkOn1 VAR lChkOn1 PROMPT "1-Verificar E-mail" SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn1,lChkOnX:=.F.,Nil))

@ 060 ,010 CHECKBOX oChkOn2 VAR lChkOn2 PROMPT "2-Validar Xml"      SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn2,lChkOnX:=.F.,Nil))

@ 075 ,010 CHECKBOX oChkOn3 VAR lChkOn3 PROMPT "3-Checar Pré-Nota"  SIZE 65,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

@ 090 ,010 CHECKBOX oChkOn4 VAR lChkOn4 PROMPT "4-Consulta de xmls"  SIZE 95,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01 WHEN .F.
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

@ 105 ,010 CHECKBOX oChkOn5 VAR lChkOn5 PROMPT "5-Notificações por E-mail"  SIZE 95,8 PIXEL OF oDlg COLOR CLR_BLUE FONT oFont01
//         ON CHANGE(Iif(!lChkOn3,lChkOnX:=.F.,Nil))

oChkOnX:cToolTip := "Todas as rotinas disponíveis."
oChkOn1:cToolTip := "Verificar E-mail e salvar arquivos no diretório indicado."
oChkOn2:cToolTip := "Validar Xml quanto a estrutura e consulta junto a SEFAZ."
oChkOn3:cToolTip := "Checar Pré-Nota e sincronizar os Status." 
oChkOn4:cToolTip := "Consulta os Xmls já recebidos previamente, de acordo com os parametros configurados."+CRLF+"Atenção."+CRLF+"Esta opção somente pode ser habilitada para o Job de execução automática.[Configurações Job]"
oChkOn5:cToolTip := "Enviar e-mails de notificação de erros e cancelamentos."

@ 130 ,110 Button "Cancelar" Size 040,015 PIXEL OF oDlg ACTION oDlg:End()                                                        
@ 130 ,155 Button "Salvar" Size 040,015 PIXEL OF oDlg ACTION (nOpc:=1,oDlg:End())                                                        

ACTIVATE MSDIALOG oDlg CENTERED 

If nOpc ==1
	If lChkOnX
		cRet := "X"
	Else
		cRet := ""
		If lChkOn1
			cRet += Iif(!Empty(cRet),",","" )+"1"
		EndIf
		If lChkOn2
			cRet += Iif(!Empty(cRet),",","" )+"2"
		EndIf
		If lChkOn3
			cRet += Iif(!Empty(cRet),",","" )+"3"
		EndIf
		If lChkOn4
			cRet += Iif(!Empty(cRet),",","" )+"4"
		EndIf
		If lChkOn5
			cRet += Iif(!Empty(cRet),",","" )+"5"
		EndIf							
	EndIf	

	/********************************/
	If !PutMv("XM_ROTINAS", cRet ) 
		RecLock("SX6",.T.)
		SX6->X6_FIL     := xFilial("SX6")
		SX6->X6_VAR     := "XM_ROTINAS"
		SX6->X6_TIPO    := "C"
		SX6->X6_DESCRIC := "Rotinas a serem executadas pelo botão 'Baixar XML'."
		MsUnLock()
		PutMv("XM_ROTINAS", cRet ) 
	EndIf

Else
	cRet := cRotImp      
Endif


Return



Static Function __Dummy(lRecursa) //warning W0010 Static Function <?> never called
    lRecursa := .F.
    IF (lRecursa)
        __Dummy(.F.)
        U_XMLLINOK()
        U_XMLOKCAB()
        U_F6ITEMPC()
        U_XMLF6ITEMPC2()
        U_SHOWPN()
        U_GETJOB()
        U_FILLCAB()
        U_HFXML04()
        U_LOADCFGX()
        U_REFGETF()
        U_MAILERRO()
        U_HF_MAIL()
        U_XMLDELOK()
        U_XMLFLDOK()
        U_XMLTOK()
        U_XMLSETNF()
        U_SPECXML()
        U_UPCFGXML()
        U_VISNOTA()
        U_XCHKXML()
	EndIF
Return(lRecursa)