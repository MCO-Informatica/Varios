#include 'protheus.ch'
#include 'totvs.ch'

user function XEcho(cVal)
	local oDlg, oActiveX;
	
	oActiveX := TActiveX():New(,"ThReport.Number")
	
return oActiveX:Echo(cVal)

user function ThRpt(cReport)
	if AllTrim(cReport) == "" 
		Alert("Necesário informar o relatório a ser tirado")
		return
	endif
	
	RptDll(cReport)
	
	//CopiaArq("\SYSTEM\ThUtils.dll", "C:\TotvsCrystal")
	//WaitRun("rundll32.exe C:\TotvsCrystal\ThUtils.dll,ShowReport " + cReport + "," + cFil)
return

static Function CopiaArq(cArqOri, cArqDes)
	local aFileInfoServer := {}
	local aFileInfoClient := {}
	local cDataOri := ""
	local cDataDest := ""
	
	if (!TDir(cArqDes, .T., .F.))
		return .F.
	endif
	
	if (!file(cArqDes + "\ThUtils.dll"))
		if (!Copy(cArqOri, cArqDes, .T.))
			return .F.
		endif
	endif
	
	aFileInfoServer := directory(cArqOri)
	aFileInfoClient := directory(cArqDes)
	
	cDataOri := cValToChar(aFileInfoServer[1, 3]) + cValToChar(aFileInfoServer[1, 4])
	cDataDest := cValToChar(aFileInfoClient[1, 3]) + cValToChar(aFileInfoCliente[1, 4])
	
	if (cDataOri != cDataDest)
		if (!Copy(cArqOri, cArqDes, .T.))
			return .F.
		endif
	endif
return .T.

static function Copy(cArqOri, cArqDes, bBo)
	if !CPYS2T(cArqOri, cArqDes, bBo)
		MSGINFO("Arquivo " + cArqOri + " não foi copiado! ", "COPIAARQ")
		return .F.
	endif	
return .T.

static Function TDir( cPath, lDrive, lMSg )
	Local aDir
	Local lRet:=.T.
	Default lMSg := .T.
	
	If Empty(cPath)
		Return lRet
	EndIf
	
	lDrive := If(lDrive == Nil, .T., lDrive)

	cPath := Alltrim(cPath)
	If Subst(cPath,2,2) <> ":\" .AND. lDrive
		MsgInfo("Unidade de drive não especificada") //Unidade de drive nao especificada
		lRet:=.F.
	Else
		cPath := If(Right(cPath,1) == "\", Left(cPath,Len(cPath)-1), cPath)
		aDir  := Directory(cPath,"D")
		If Len(aDir) = 0
			If lMSg
				If MsgYesNo("Diretorio - " + cPath + " - nao encontrado, deseja cria-lo" ) //Diretorio  -  nao encontrado, deseja cria-lo
					If MakeDir(cPath) <> 0
						Help(" ", 1, "NOMAKEDIR")
						lRet := .F.
					EndIf
				EndIf
			Else
				If MakeDir(cPath) <> 0
					Help(" ", 1, "NOMAKEDIR")
					lRet := .F.
				EndIf
			EndIF
		EndIf
	EndIf
Return lRet

Static Function RptDll(cParam)

	//local nHandle := 0
	// local cRetDLL := 0
	//local cPath := ''
	local oGuiWindow
	local nGuiHandle	
	// Cria a dll e pega o handle delass
	//nHandle := ExecInDllOpen('thermoReport.dll')
	 
	// Faz chamada na dll para exibir o relatório (status - 1)
	// cRetDLL := ExeDLLRun2(nHandle, 1, cParam)
	//ExecInDLLRun(nHandle, 1, cParam)
	
	//MsgStop(nHandle)
	 
	//ExecInDLLClose(nHandle)
	
	//MsgStop('Conseguiu fechar - 2')
	
	//cPath := GetRemoteIniName()
	// Replace(cPath, "smartclient.ini", "")
	//cPath := GetClientDir()
	//cPath += "thermoReport.dll,ShowReport " + cParam
	
	//MsgStop(cPath)
	
	// Cria um dialog
	oGuiWindow := MsDialog:New(10, 10, 10, 10, "Teste")
	
	// Retorna um handle para o objeto
	nGuiHandle := oGuiWindow:hWHandle()
	
	MsgInfo(nGuiHandle)
	
	oGuiWindow:Activate(,,,.T.)
	
	WaitRun('guiclient.exe ' + cParam, 1) 
Return()