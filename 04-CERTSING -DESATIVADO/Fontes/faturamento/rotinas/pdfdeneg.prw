#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณPDFDENEG  บAutor  ณOpvs (David)       บ Data ณ  13/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que gera PDF con Informa็ao de NFE Denegada         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function PDFDENEG(aProc, cRandom)

	Local oDanfe
	Local cIdEnt	:= ""
	Local oFont20N	:= TFont():New("Arial",20,20,,.T.,,,,.T.,.F.)
	Local cRootPath	:= GetSrvProfString("RootPath","")
	Local cPathEsp	:= GetNewPar("MV_PATHNF","\espelhonf\")
	Local cPath		:= cRootPath + cPathEsp
	Local cPathLoc	:= GetNewPar("MV_PATHNFL","D:\Totvs\Protheus10\espelhonf\")
	Local cCompart	:= GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/") + DtoS(Date()) + "/"
	Local cFile		:= ""
	Local nI		:= 0
	Local aRet      := {}
	Local aRetProc	:= {}
	Local aArea			:= GetArea()
	Local vServer   := GetSrvInfo()[1]
    Local nSleep    := GetNewPar("MV_XCPSLP", 5000 )
	
	Default cRandom	:= ""
	
	// Enibe a emissao da imagem quando for importacao
	If !IsBlind() .AND. FunName() <> "SPEDNFE" .AND. FunName() <> "MATA410"
		Aadd( aRet, .F. )
		Aadd( aRet, "000134" )
		Aadd( aRet, SC5->C5_CHVBPAG )
		Aadd( aRet, "Validacao IsBlind" )
		Return(aRet)
	Endif
	
	MakeDir( cPath + DtoS(Date()) + "\", 1 )
	
	If Empty(cRandom)
		For nI := 1 To 6
			cRandom += Str(Randomize(0,10),1)
		Next nI
	Endif
	
	If Empty(SC5->C5_CHVBPAG)
		cFile := "p" + AllTrim(SC5->C5_XNPSITE) + cRandom + cFile
	Else
		cFile := "p" + AllTrim(SC5->C5_CHVBPAG) + cRandom + cFile
	EndIf
	
	oDanfe 				:= FWMSPrinter():New(cFile,6,.F.,/*'\spool\'*/, .T.)//,.T.)
	oDanfe:lInJob   	:= .T.
	nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	oSetup := FWPrintSetup():New(nFlags, "PAINEL")
	If !IsBlind()
		oSetup:SetPropert(PD_PRINTTYPE, 2)
		oSetup:SetPropert(PD_DESTINATION, 2)
	
	EndIf
	
	oDanfe:StartPage()
	oDanfe:Say(050,050,"Pedido do GAR -> "+aProc[3],oFont20N)
	oDanfe:Say(150,050,"Codigo do erro : "+aProc[2],oFont20N)
	SZ7->( DbSetOrder(1) )
	If SZ7->( Msseek( xFilial("SZ7")+aProc[2] ) )
		oDanfe:Say(250,050,SZ7->Z7_DESMEN,oFont20N)
	Endif
	oDanfe:EndPage()
	
	oDanfe:Preview("PDF")
	
	Freeobj(oDanfe)
	
	cFile := cFile+".rel"
	
	aRet := {}
	Aadd( aRet, .T. )
	Aadd( aRet, "000096" )
	Aadd( aRet, SC5->C5_CHVBPAG )
	Aadd( aRet, "Espelho de NFE Denegada em PDF gerado" )
	
	// Grava na tabela SF2 o retorno do LOG para posterior reenvio caso seja solicitado.
	SF2->( RecLock("SF2",.F.) )
	SF2->F2_ARET :=	".F." + "," +;
					PadR("000168",06) + "," +;
					PadR(aRet[3],10) + "," +;
					AllTrim(aRet[4])
	SF2->( MsUnLock() )
	
	//impressao via JOB
	If IsBlind()
		File2Printer("\spool\"+cFile,"PDF")
		sleep(5000)
		Ferase("\spool\"+cFile,1)
	EndIf
	
	// Transfere o arquivo PDF do espelho para a subpasta do respectivo dia.
	cFile := Alltrim(cFile)
	cFile := SubStr(cFile,1,Len(cFile)-3)+"pdf"
	sleep(5000)
	If _CopyFile("\spool\"+cFile,"\espelhonf\"+cFile)
		sleep(5000)
		Ferase("\spool\"+cFile)
	EndIf
	
	// Se o arquivo jah existe no destino, apaga antes de mover.
	If File(cPath+DtoS(Date())+"\"+cFile,1)
		sleep(5000)
		Ferase(cPath+DtoS(Date())+"\"+cFile,1)
	Endif
	
	// Se o arquivo estah disponivel, entao move para a pasta do dia.
	If File(cPath+cFile,1)
		Frename(cPath+cFile,cPath+DtoS(Date())+"\"+cFile,1)
	Else
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "ER0003" )
		Aadd( aRet, SC5->C5_CHVBPAG )
		Aadd( aRet, "Nao consegue mover o PDF para a pasta de data --> 05" )
	Endif

Return(aRet)
