#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณNFDENG03 บAutor  ณOpvs (David)       บ Data ณ  13/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Rotina que gera PDF con Informa็ao de NFE Denegada         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function NFDENG03(aProc, cRandom)

	Local oDanfe
	Local cIdEnt	:= ""
	Local oFont12N	:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	Local cRootPath	:= GetSrvProfString("RootPath","")
	Local cPath		:= GetNewPar("MV_PATHNF","\espelhonf\")
	Local cPathLoc	:= GetNewPar("MV_PATHNFL","\\hera\Protheus_Data10$")
	Local cCompart	:= GetNewPar("MV_COMPNF","http://192.168.16.131/espelhonf/") + DtoS(Date()) + "/"

	Local cFile		:= ".pdf"
	

	Local nI		:= 0
	Local aRet      := {}
	Local aRetProc	:= {}
	Local aArea			:= GetArea()
	Local vServer := GetSrvInfo()[1]

	Default cRandom	:= ""
	
	// Enibe a emissao da imagem quando for importacao
	If !IsBlind() .AND. FunName() <> "SPEDNFE" .AND. FunName() <> "MATA410"
		Aadd( aRet, .F. )
		Aadd( aRet, "000134" )
		Aadd( aRet, iif(!empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE) )
		Aadd( aRet, "Validacao IsBlind" )
		Return(aRet)
	Endif
	

	MakeDir( cRootPath+cPath + DtoS(Date()) + "\", 1 )
	
	If Empty(cRandom)
		For nI := 1 To 6
			cRandom += Str(Randomize(0,10),1)
		Next nI
	Endif
	
	If Empty(SC5->C5_CHVBPAG)
		cFile := "d" + AllTrim(SC5->C5_XNPSITE) + cRandom + cFile
	Else
		cFile := "d" + AllTrim(SC5->C5_CHVBPAG) + cRandom + cFile
	EndIf
	
	oDanfe:= FWMSPrinter():New(cFile, IMP_PDF, .F. ,/*cRootPath+cPath*/,.T., , , , , , .F., )

	oDanfe:lServer := .T.                          
	oDanfe:lInJob  := .T.
	nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
	oSetup := FWPrintSetup():New(nFlags, "PAINEL")
  
	If !IsBlind()
		oSetup:SetPropert(PD_PRINTTYPE, 2)
		oSetup:SetPropert(PD_DESTINATION, 2)
	EndIf
	
	oDanfe:StartPage()
	oDanfe:Say(050,050,"INFORMATIVO: DENEGAวรO DO USO DA NOTA FISCAL (SP) CำDIGO "+SF2->F2_DOC,oFont12N)
	oDanfe:Say(100,050,"Pedido Site -> "+aProc[3],oFont12N)
	SZ7->( DbSetOrder(1) )
	If SZ7->( Msseek( xFilial("SZ7")+aProc[2] ) )
		oDanfe:Say(110,050,SZ7->Z7_DESMEN,oFont12N)
	Endif
	oDanfe:Say(150,050," ",oFont12N)
	oDanfe:Say(160,050,"A administra็ใo tributaria comunicou que a partir do dia 02/04/2012 a autoriza็ใo do uso de NF poderแ ser denegada ",oFont12N)
	oDanfe:Say(170,050,"devido a diverg๊ncia entre os dados do destinatแrio em contrapartida aos dados da base da SEFAZ de acordo",oFont12N)
	oDanfe:Say(180,050,"com as diretrizes da unidade federativa.",oFont12N)
	oDanfe:Say(190,050," ",oFont12N)
	oDanfe:Say(200,050,"A Secretaria da Fazendo do Estado de Sใo Paulo deu inicio a esta a็ใo em 02/04/2012 para as opera็๕es internas.",oFont12N)
	oDanfe:Say(210,050,"Para que nใo ocorra denega็ใo, o destinatแrio deverแ enquadrar-se nas situa็๕es: ATIVA; SUSPENSA e/ou BAIXADA",oFont12N) 
	oDanfe:Say(220,050,"no CADESP.",oFont12N)
	oDanfe:Say(230,050," ",oFont12N)
	oDanfe:Say(240,050,"Solicitamos realizarem a regulariza็ใo para que nas pr๓ximas aquisi็๕es nใo ocorra a denega็ใo das Notas Fiscais.",oFont12N)
	oDanfe:Say(250,050," ",oFont12N)
	oDanfe:Say(260,050,"Att.",oFont12N)
	oDanfe:Say(270,050,"CERTISIGN - A sua identidade na rede",oFont12N)
	
	oDanfe:EndPage()
	
	oDanfe:Preview()
	// Aguarda 10s apos gerar PDF
	Sleep(10000)
	
	Freeobj(oDanfe)
	
	//cFile := cFile+".rel"
	cFile := Alltrim(cFile)
	
	/*
	//impressao via JOB
	If IsBlind()
		File2Printer("\spool\"+cFile,"PDF")
		sleep(10000)
		Ferase(cRootPath+"\spool\"+cFile,1)
	EndIf
	
	// Transfere o arquivo PDF do espelho para a subpasta do respectivo dia.
	cFile := Alltrim(cFile)
	cFile := SubStr(cFile,1,Len(cFile)-3)+"pdf"
    */
	
	// Se o arquivo jah existe no destino, apaga antes de mover.
    
	If File(cRootPath+cPath+DtoS(Date())+"\"+cFile,1)
		sleep(5000)
		Ferase(cRootPath+cPath+DtoS(Date())+"\"+cFile,1)
	Endif

	//If _CopyFile("\spool\"+cFile,"\espelhonf\"+DtoS(Date())+"\"+cFile)
	//	Ferase(cRootPath+"\spool\"+cFile)
	//EndIf
	sleep(5000)
	If Frename("\spool\"+cFile,"\espelhonf\"+DtoS(Date())+"\"+cFile) == 0
	    // Apaga o arquivo .REL                        
		aRet := {}
		Aadd( aRet, .T. )
		Aadd( aRet, "000169" )
		Aadd( aRet, iif(!empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE) )
		Aadd( aRet, cCompart+cFile )
		
		// Grava na tabela SF2 o retorno do LOG para posterior reenvio caso seja solicitado.
		SF2->( RecLock("SF2",.F.) )
		SF2->F2_ARET :=	".F." + "," +;
						PadR("000169",06) + "," +;
						PadR(aRet[3],10) + "," +;
						AllTrim(aRet[4])
		SF2->( MsUnLock() )
		SF2->(DBCommit())
	    
		cFile := SubStr(cFile,1,Len(cFile)-3)+"rel"
		sleep(5000)
		Ferase(cRootPath+"\spool\"+cFile,1)

	Else
	
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "ER0003" )
		Aadd( aRet, iif(!empty(SC5->C5_CHVBPAG),SC5->C5_CHVBPAG,SC5->C5_XNPSITE) )
		Aadd( aRet, "Nao consegue mover o PDF para a pasta de data --> 04" )
	Endif
	
	
	//Caso a danfe tenha sido Gerada com Sucesso grava campo no pedido com link de acesso
	If aRet[1]
		// Posiciona no item da nota para identificar tipo de danfe a ser impressa Venda ou entrega
		SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
		lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
		
		If lSeekC6 .and. SC6->C6_XOPER == '52'
			RecLock("SC5", .F.)
				Replace SC5->C5_XNFHRD With aRet[4]
				Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
			SC5->(MsUnLock())
		EndIf
		
		If lSeekC6 .and. SC6->C6_XOPER == '53' 
			RecLock("SC5", .F.)
				Replace SC5->C5_XNFHRE With aRet[4]
				Replace SC5->C5_STENTR With "1"
				Replace SC5->C5_XFLAGEN With Space(TamSX3("C5_XFLAGEN")[1])
			SC5->(MsUnLock())	
		EndIf
		SC5->(DBCommit())
	EndIf

Return(aRet)
