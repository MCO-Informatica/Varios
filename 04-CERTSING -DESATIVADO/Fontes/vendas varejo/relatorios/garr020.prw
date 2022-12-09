#INCLUDE "PROTHEUS.CH"
#INCLUDE "FWPrintSetup.ch"
#INCLUDE "RPTDEF.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARR020   ºAutor  ³Microsiga           º Data ³  12/21/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Impressão espelho da nota de SERVIÇO					  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function GARR020(aProc, LinkNf)

Local oFont18N	:= TFont():New("Arial",18,18,,.T.,,,,.T.,.F.)
Local cRootPath	:= GetSrvProfString( "RootPath", "" )
Local cPath		:= GetNewPar("MV_PATHNF","\espelhonf\")
Local cPathLoc	:= GetNewPar("MV_PATHNFL","\\hera\Protheus_Data10$")
Local cCompart	:= GetNewPar("MV_COMPNF","http://192.168.16.30/espelhonf/") + DtoS(Date()) + "/"
Local cExtFile	:= ".pdf"
Local cFile		:= ""
Local cRandom	:= ""
Local nI		:= 0
Local oRps
Local aRet      := {}
Local nGARR020	:= GetNewPar("MV_GARR020",40)
Local nTempo	:= 0
Local nAttempt	:= 0

Local lAdjustToLegacy := .T.
Local lDisableSetup   := .T.
Local oSetup	:= Nil

Private cLinkNf := ''
Default LinkNf  := .F.

// Enibe a emissao da imagem quando for importacao
If !IsBlind() .AND. FunName() <> "MATC090" .AND. FunName() <> "CSGERNF"
	Aadd( aRet, .F. )
	Aadd( aRet, "000134" )
	Aadd( aRet, SC5->C5_XNPSITE)
	Aadd( aRet, "Proc. via Remote" )
	Return(aRet)
Endif

While !ExistDir(cPath + DtoS(Date()) + "\") .And. nAttempt < 10
	If MakeDir( cPath + DtoS(Date()) + "\", 1 ) != 0
		Sleep(60 * 1000)
	EndIf
	nAttempt++
EndDo

For nI := 1 To 5
	cRandom += Str(Randomize(0,10),1)
Next nI


// Posiciona no item da nota para identificar pedidogar 
SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )

If lSeekC6 .and. !Empty(SC6->C6_XIDPED)
	cFile := "s" + AllTrim(SC5->C5_XNPSITE)+ AllTrim(SC6->C6_XIDPED) + cRandom + cExtFile
else

	cFile := "s" + AllTrim(SC5->C5_XNPSITE)+ cRandom + cExtFile
EndIf

//oRps := FWMSPrinter():New( cFile, IMP_PDF, lAdjustToLegacy,/*cRootPath+cPath*/, lDisableSetup, , , , , , .F., )
  oRps := FWMSPrinter():New( cFile, IMP_PDF, lAdjustToLegacy,/*cRootPath+cPath*/,lDisableSetup, , oSetup, , ,.F. , .F.,.F. )
oRps:lServer := .T.                             
oRps:lInJob := .T.
oRps:SetPortrait()
oRps:SetPaperSize(1)
oRps:SetResolution(72) 

oRps:StartPage()  

If !aProc[1]
	oRps:Say(050,050,"Pedido -> "+aProc[3],oFont18N)
	oRps:Say(150,050,"Codigo do erro : "+aProc[2],oFont18N)
	SZ7->( DbSetOrder(1) )
	If SZ7->( Msseek( xFilial("SZ7")+aProc[2] ) )
		oRps:Say(250,050,SZ7->Z7_DESMEN,oFont18N)
	Endif
	oRps:EndPage()
	oRps:Preview()
	
	Freeobj(oRps)
	       
	// Aguarda 5s antes de realizar a copia do arquivo
	Sleep( 5000 )
	
	// Transfere arquivo .PDF para pasta de espelho de nota
	cFile := Alltrim(cFile)

	If __CopyFile( "\spool\" + cFile, cPath + cFile )
		sleep(5000)
		Ferase( "\spool\" + cFile )
		aRet := {}
		Aadd( aRet, .T. )
	Else
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000134" )
		Aadd( aRet, SC5->C5_XNPSITE)
		Aadd( aRet, "Falha na copia de " + AllTrim( cFile ) + " para " + AllTrim( cPath ) + " erro: " + AllTrim( Str( fError() ) )  ) 
	EndIf
	                   
	If aRet[1]
		// Transfere o arquivo PDF do espelho para a subpasta do respectivo dia.
		If File(cPath+cFile)
		    sleep(5000)
			If Frename(cPath+cFile, cPath+DtoS(Date())+"\"+cFile) == 0
				aRet := {}
				Aadd( aRet, .T. )
				Aadd( aRet, "000135" )
				Aadd( aRet, SC5->C5_XNPSITE)
				Aadd( aRet, cCompart+cFile)
			Else
				aRet := {}
				Aadd( aRet, .F. )
				Aadd( aRet, "000134" )
				Aadd( aRet, SC5->C5_XNPSITE)
				Aadd( aRet, "Falha na copia do arquivo " + AllTrim(cFile) + "para a pasta " + AllTrim(cPath+DtoS(Date())) + " erro: " + AllTrim( Str( fError() ) )  )
			EndIf	
		Else
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000134" )
			Aadd( aRet, SC5->C5_XNPSITE)
			Aadd( aRet, "Arquivo nao gerado" )
		Endif
	EndIf                

	// Grava na tabela SF2 o retorno do LOG para posterior reenvio caso seja solicitado.
	SF2->( RecLock("SF2",.F.) )
	SF2->F2_ARET :=	".F." + "," +;
					PadR("000120",06) + "," +;
					PadR(aRet[3],10) + "," +;
					AllTrim(aRet[4])
	SF2->( MsUnLock() )
	SF2->(DBCommit())

	Return(aRet)

Else

	aRet := {}

Endif

//Busca Link da Nota Fiscal para consulta.
If LinkNf 
	cLinkNf := U_ImpNfe(SF2->F2_DOC,SF2->F2_SERIE)
EndIf

RPSProc(@oRps)
oRps:Preview()
Freeobj(oRps)

cFile := Alltrim(cFile)

//faz tentativas para efetuar a copia ate o tempo de expiracao
Aadd( aRet, .F. )

While !aRet[1] .And. nTempo <= nGarr020
	nTempo += 5
	sleep(5000)
	// Transfere arquivo .PDF para pasta de espelho de nota
	If __CopyFile( "\spool\" + cFile, cPath + cFile )
		sleep(5000)
		Ferase( "\spool\" + cFile )
		aRet := {}
		Aadd( aRet, .T. )
	Else
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000134" )
		Aadd( aRet, SC5->C5_XNPSITE)
		Aadd( aRet, "Falha na copia de " + AllTrim( cFile ) + " para " + AllTrim( cPath ) + " erro: " + AllTrim( Str( fError() ) ) ) 
	EndIf
Enddo

If aRet[1]	

	// Se o arquivo jah existe no destino, apaga antes de mover.
	If File(cPath+DtoS(Date())+"\"+cFile,1)
		sleep(5000)
		Ferase(cPath+DtoS(Date())+"\"+cFile,1)
	Endif

	// Transfere o arquivo PDF do espelho para a subpasta do respectivo dia.
	If File(cPath+cFile)
        sleep(5000)
		If Frename(cPath+cFile,cPath+DtoS(Date())+"\"+cFile) == 0
			aRet := {}
			Aadd( aRet, .T. )
			Aadd( aRet, "000135" )
			Aadd( aRet, SC5->C5_XNPSITE )
			Aadd( aRet, cCompart+cFile)
		Else
			aRet := {}
			Aadd( aRet, .F. )
			Aadd( aRet, "000134" )
			Aadd( aRet, SC5->C5_XNPSITE)
			Aadd( aRet, "Falha na copia do arquivo " + AllTrim(cFile) + "para a pasta " + AllTrim(cPath+DtoS(Date())) + " erro: " + AllTrim( Str( fError() ) ) )
		EndIf	
	Else
		aRet := {}
		Aadd( aRet, .F. )
		Aadd( aRet, "000134" )
		Aadd( aRet, SC5->C5_XNPSITE )
		Aadd( aRet, "Arquivo " + AllTrim(cFile) + "nao encontrado em " + AllTrim(cPath) )
	Endif

EndIf

// Grava na tabela SF2 o retorno do LOG para posterior reenvio caso seja solicitado.
SF2->( RecLock("SF2",.F.) )
SF2->F2_ARET :=	IIF(aRet[1],".T.",".F.") + "," +;
				PadR(aRet[2],06) + "," +;
				PadR(aRet[3],10) + "," +;
				AllTrim(aRet[4])
SF2->( MsUnLock() )

//Caso a danfe tenha sido Gerada com Sucesso grava campo no pedido com link de acesso
If aRet[1]
	// Posiciona no item da nota para identificar tipo de danfe a ser impressa Venda ou entrega
	SC6->( DbSetOrder(4) )		// C6_FILIAL+C6_NOTA+C6_SERIE
	lSeekC6 := SC6->( MsSeek( xFilial("SC6")+SF2->(F2_DOC+F2_SERIE) ) )
	
	If lSeekC6 .and. SC6->C6_XOPER $ '51,61'
		RecLock("SC5", .F.)
			Replace SC5->C5_XNFSFW With aRet[4]
			Replace SC5->C5_XFLAGSF With Space(TamSX3("C5_XFLAGSF")[1])
			Replace SC5->C5_LINKNFS With cLinkNf
		SC5->(MsUnLock())
		
		While !SC6->(eOf()) .AND. SC6->(C6_FILIAL+C6_NOTA+C6_SERIE) == xFilial("SC6")+SF2->(F2_DOC+F2_SERIE)
			If SC6->C6_XOPER $ '51,61'
				RecLock("SC6", .F.)
					Replace SC6->C6_XNFSFW  With aRet[4]
					Replace SC6->C6_XFLAGSF With Space(TamSX3("C6_XFLAGSF")[1])
					Replace SC6->C6_LINKNFS With cLinkNf
				SC6->(MsUnLock())
			EndIf
			SC6->(DbSkip())
		End
	EndIf
	SC5->(DBCommit())
EndIf


Return(aRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³GARR020   ºAutor  ³Microsiga           º Data ³  12/21/09   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function RPSProc(oRps)

Local aAreaRPS		:= {}
Local aPrintServ	:= {}
Local aPrintObs		:= {}
Local aTMS			:= {}

Local cServ			:= ""
Local cDescrServ	:= ""
Local cCNPJCli		:= ""                            
Local cTime			:= "" 
Local cNfeServ		:= SuperGetMv("MV_NFESERV",.F.,"")
Local cLogo			:= ""
Local cServPonto	:= ""               
Local cObsPonto		:= ""
Local cAliasSF3		:= "SF3"
Local cCli			:= ""
Local cIMCli		:= ""
Local cEndCli		:= ""
Local cBairrCli		:= ""
Local cCepCli		:= ""
Local cMunCli		:= ""
Local cUFCli		:= ""
Local cEmailCli		:= ""
Local cCampos		:= ""

Local lIssMat		:= (cAliasSF3)->(FieldPos("F3_ISSMAT")) > 0
Local lDescrNFE		:= ExistBlock("MTDESCRNFE")
Local lObsNFE		:= ExistBlock("MTOBSNFE")
Local lCliNFE		:= ExistBlock("MTCLINFE")           

Local nValDed		:= 0
Local nCopias		:= 1
Local nLinIni		:= 225  // 50
Local nColIni		:= 225	// 50
Local nColFim		:= 2175 // 2350
Local nLinFim		:= 2975 // 3250
Local nX			:= 1
Local nY			:= 1
Local nLinha		:= 0

Local oFont10 	:= TFont():New("Courier New",10,10,,.F.,,,,.T.,.F.)	//Normal s/negrito
Local oFont10n	:= TFont():New("Courier New",10,10,,.T.,,,,.T.,.F.)	//Negrito
//Local oFont12n	:= TFont():New("Courier New",12,12,,.T.,,,,.T.,.F.)	//Negrito
Local oFont14n	:= TFont():New("Courier New",14,14,,.T.,,,,.T.,.F.)	//Negrito
                                               
#IFDEF TOP
	Local cQuery    := "" 
#ELSE 
	Local cChave    := ""
	Local cFiltro   := ""       
#ENDIF

dbSelectArea("SF3")
dbSetOrder(6)

#IFDEF TOP

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Campos que serao adicionados a query somente se existirem na base³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lIssMat
    	cCampos := " ,F3_ISSMAT "
	Endif
		     
	If Empty(cCampos)
		cCampos := "%%"
	Else       
		cCampos := "% " + cCampos + " %"
	Endif                              

    If TcSrvType()<>"AS/400"
    
		lQuery 		:= .T.
		cAliasSF3	:= GetNextAlias()    
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se imprime ou nao os documentos cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cQuery := "%%"
		
		BeginSql Alias cAliasSF3
			COLUMN F3_ENTRADA AS DATE
			COLUMN F3_EMISSAO AS DATE
			COLUMN F3_DTCANC AS DATE
			COLUMN F3_EMINFE AS DATE
			SELECT F3_FILIAL,F3_ENTRADA,F3_EMISSAO,F3_NFISCAL,F3_SERIE,F3_CLIEFOR,F3_PDV,
				F3_LOJA,F3_ALIQICM,F3_BASEICM,F3_VALCONT,F3_TIPO,F3_VALICM,F3_ISSSUB,F3_ESPECIE,
				F3_DTCANC,F3_CODISS,F3_OBSERV,F3_NFELETR,F3_EMINFE,F3_CODNFE,F3_CREDNFE
				%Exp:cCampos%
			
			FROM %table:SF3% SF3
				
			WHERE SF3.F3_FILIAL = %xFilial:SF3% AND 
				SF3.F3_CFO >= '5' AND 
				SF3.F3_ENTRADA >= %Exp:SF2->F2_EMISSAO% AND 
				SF3.F3_ENTRADA <= %Exp:SF2->F2_EMISSAO% AND 
				SF3.F3_TIPO = 'S' AND
				SF3.F3_CODISS <> %Exp:Space(TamSX3("F3_CODISS")[1])% AND
				SF3.F3_CLIEFOR >= %Exp:SF2->F2_CLIENTE% AND
				SF3.F3_CLIEFOR <= %Exp:SF2->F2_CLIENTE% AND
				SF3.F3_NFISCAL >= %Exp:SF2->F2_DOC% AND
				SF3.F3_NFISCAL <= %Exp:SF2->F2_DOC% AND
				%Exp:cQuery%
				SF3.%NotDel%                           
					
			ORDER BY SF3.F3_ENTRADA,SF3.F3_SERIE,SF3.F3_NFISCAL,SF3.F3_TIPO,SF3.F3_CLIEFOR,SF3.F3_LOJA
		EndSql
	
		dbSelectArea(cAliasSF3)
	Else

#ENDIF
		cArqInd	:=	CriaTrab(NIL,.F.)
		cChave	:=	"DTOS(F3_ENTRADA)+F3_SERIE+F3_NFISCAL+F3_TIPO+F3_CLIEFOR+F3_LOJA"
		cFiltro := "F3_FILIAL == '" + xFilial("SF3") + "' .And. "
		cFiltro += "F3_CFO >= '5" + SPACE(LEN(F3_CFO)-1) + "' .And. "	
		cFiltro += "DtOs(F3_ENTRADA) >= '" + Dtos(SF2->F2_EMISSAO) + "' .And. "
		cFiltro	+= "DtOs(F3_ENTRADA) <= '" + Dtos(SF2->F2_EMISSAO) + "' .And. "
		cFiltro	+= "F3_TIPO == 'S' .And. F3_CODISS <> '" + Space(Len(F3_CODISS)) + "' .And. "
		cFiltro	+= "F3_CLIEFOR >= '" + SF2->F2_CLIENTE + "' .And. F3_CLIEFOR <= '" + SF2->F2_CLIENTE + "' .And. "
		cFiltro	+= "F3_NFISCAL >= '" + SF2->F2_DOC + "' .And. F3_NFISCAL <= '" + SF2->F2_DOC + "'"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Verifica se imprime ou nao os documentos cancelados³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		#IFNDEF TOP
			DbSetIndex(cArqInd+OrdBagExt())
		#ENDIF                
		(cAliasSF3)->(dbGotop())

#IFDEF TOP
	Endif    
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Imprime os RPS gerados de acordo com o numero de copias selecionadas³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
While (cAliasSF3)->(!Eof())

	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Analisa Deducoes do ISS  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nValDed += (cAliasSF3)->F3_ISSSUB
	
	If lIssMat
		nValDed += (cAliasSF3)->F3_ISSMAT
	Endif                 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o SF2 para verificar o horario de emissao do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	SF2->(dbSetOrder(1))
	cTime := ""
	If SF2->(dbSeek(xFilial("SF2")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		cTime := Transform(SF2->F2_HORA,"@R 99:99")
		
		// NF Cupom nao sera processada
		If !Empty(SF2->F2_NFCUPOM)
			(cAliasSF3)->(dbSKip()) 
			Loop
		Endif
	Endif                            
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca a descricao do codigo de servicos³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cDescrServ := ""
	SX5->(dbSetOrder(1))
	If SX5->(dbSeek(xFilial("SX5")+"60"+(cAliasSF3)->F3_CODISS))
		cDescrServ := SX5->X5_DESCRI
	Endif  
	cCodServ := Alltrim((cAliasSF3)->F3_CODISS) + " - " + cDescrServ          

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Busca o pedido para discriminar os servicos prestados no documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cServ := ""
	If cNfeServ == "1"
		SC6->(dbSetOrder(4))
		SC5->(dbSetOrder(1))
		If SC6->(dbSeek(xFilial("SC6")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE))
			If SC5->(dbSeek(xFilial("SC5")+SC6->C6_NUM))
				cServ := SC5->C5_MENNOTA
			Endif
		Endif
	Endif
	If Empty(cServ)
		cServ := cDescrServ
	Endif         
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para compor a descricao a ser apresentada³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aAreaRPS	:= (cAliasSF3)->(GetArea())
	cServPonto	:= ""
	If lDescrNFE
		cServPonto := Execblock("MTDESCRNFE",.F.,.F.,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA}) 
	Endif       
	RestArea(aAreaRPS)      
	If !(Empty(cServPonto)) 
		cServ := cServPonto
	Endif                   
	aPrintServ	:= Mtr968Mont(cServ,13,999)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para complementar as observacoes a serem apresentadas³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cObserv 	:= Alltrim((cAliasSF3)->F3_OBSERV) + Iif(!Empty((cAliasSF3)->F3_OBSERV)," | ","") 
	cObserv 	+= Iif(!Empty((cAliasSF3)->F3_PDV) .And. Alltrim((cAliasSF3)->F3_ESPECIE) == "CF","Observações" + " | ","")
	aAreaRPS 	:= (cAliasSF3)->(GetArea())
	cObsPonto	:= ""
	If lObsNFE
		cObsPonto := Execblock("MTOBSNFE",.F.,.F.,{(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE,(cAliasSF3)->F3_CLIEFOR,(cAliasSF3)->F3_LOJA}) 
	Endif       
	RestArea(aAreaRPS)      
	cObserv 	:= cObserv + cObsPonto
	SC6->(dbSetOrder(4))
	SC5->(dbSetOrder(1))
	If SC6->(dbSeek(xFilial("SC6")+(cAliasSF3)->F3_NFISCAL+(cAliasSF3)->F3_SERIE))
		dbSelectArea("SF4")
		SF4->(dbSetOrder(1))
		If SF4->(DbSeek(xFilial("SF4")+SC6->C6_TES)) .AND. !Empty(SF4->F4_FORMULA) .AND. !AllTrim(Formula(SF4->F4_FORMULA)) $ cObserv 
			cObserv := Alltrim(cObserv)+" "+CRLF+AllTrim(Formula(SF4->F4_FORMULA))
		EnDIf
	Endif
	aPrintObs	:= Mtr968Mont(cObserv,11,675)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Verifica o cLiente/fornecedor do documento³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cCNPJCli := ""
	SA1->(dbSetOrder(1))
	If SA1->(dbSeek(xFilial("SA1")+(cAliasSF3)->F3_CLIEFOR+(cAliasSF3)->F3_LOJA))
		If RetPessoa(SA1->A1_CGC) == "F"
			cCNPJCli := Transform(SA1->A1_CGC,"@R 999.999.999-99")
		Else                                                      
			cCNPJCli := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
		Endif
		cCli		:= SA1->A1_NOME
		cIMCli		:= SA1->A1_INSCRM
		cEndCli		:= SA1->A1_END
		cBairrCli	:= SA1->A1_BAIRRO
		cCepCli		:= SA1->A1_CEP
		cMunCli		:= SA1->A1_MUN
		cUFCli		:= SA1->A1_EST
		cEmailCli	:= SA1->A1_EMAIL
	Else
		(cAliasSF3)->(dbSKip()) 
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Funcao que retorna o endereco do solicitante quando houver integracao com TMS³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If IntTms()
		aTMS := TMSInfSol((cAliasSF3)->F3_FILIAL,(cAliasSF3)->F3_NFISCAL,(cAliasSF3)->F3_SERIE)
		If Len(aTMS) > 0
			cCli		:= aTMS[04]
			If RetPessoa(Alltrim(aTMS[01])) == "F"
				cCNPJCli := Transform(Alltrim(aTMS[01]),"@R 999.999.999-99")
			Else                                                      
				cCNPJCli := Transform(Alltrim(aTMS[01]),"@R 99.999.999/9999-99")
			Endif
			cIMCli		:= aTMS[02]
			cEndCli		:= aTMS[05]
			cBairrCli	:= aTMS[06]
			cCepCli		:= aTMS[09]
			cMunCli		:= aTMS[07]
			cUFCli		:= aTMS[08]
			cEmailCli	:= aTMS[10]
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ponto de entrada para trocar o cliente a ser impresso.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lCliNFE
		aMTCliNfe := Execblock("MTCLINFE",.F.,.F.,{SF3->F3_NFISCAL,SF3->F3_SERIE,SF3->F3_CLIEFOR,SF3->F3_LOJA}) 
		// O ponto de entrada somente e utilizado caso retorne todas as informacoes necessarias
		If Len(aMTCliNfe) >= 12
			cCli		:= aMTCliNfe[01]
			cCNPJCli	:= aMTCliNfe[02]
			If RetPessoa(cCNPJCli) == "F"
				cCNPJCli := Transform(cCNPJCli,"@R 999.999.999-99")
			Else                                                      
				cCNPJCli := Transform(cCNPJCli,"@R 99.999.999/9999-99")
			Endif
			cIMCli		:= aMTCliNfe[03]
			cEndCli		:= aMTCliNfe[04]
			cBairrCli	:= aMTCliNfe[05]
			cCepCli		:= aMTCliNfe[06]
			cMunCli		:= aMTCliNfe[07]
			cUFCli		:= aMTCliNfe[08]
			cEmailCli	:= aMTCliNfe[09]
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Relatorio Grafico:                                                                                      ³
	//³* Todas as coordenadas sao em pixels	                                                                   ³
	//³* oRps:Line - (linha inicial, coluna inicial, linha final, coluna final)Imprime linha nas coordenadas ³
	//³* oRps:Say(Linha,Coluna,Valor,Picture,Objeto com a fonte escolhida)		                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	For nX := 1 to nCopias
	
		If !Empty(cLinkNf)
			oRps:Say(80,250,"Clique no link para visualizar a Nota Fiscal de Serviço ",oFont10n)
			oRps:Say(120,250,cLinkNf,oFont10,,CLR_RED,CLR_WHITE)
			oRps:Say(160,250,"Abaixo o recibo provisório de serviço. ",oFont10n)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Box no tamanho do RPS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Line(nLinIni,nColIni,nLinIni,nColFim)
		oRps:Line(nLinIni,nColIni,nLinFim,nColIni)		
		oRps:Line(nLinIni,nColFim,nLinFim,nColFim)
		oRps:Line(nLinFim,nColIni,nLinFim,nColFim)
			
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados da empresa emitente do documento³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cLogo := FisxLogo("1")
		oRps:SayBitmap(375,nColIni+10,cLogo,400,090) // o arquivo com o logo deve estar abaixo do rootpath (mp8\system)
		oRps:Line(nLinIni,1800,612,1800)
		oRps:Line(354,1800,354,nColFim)
		oRps:Line(483,1800,483,nColFim)
		oRps:Line(612,nColIni,612,nColFim)
		oRps:Say(260,730,PadC(Alltrim(SM0->M0_NOMECOM),40),oFont14n)
		oRps:Say(305,680,PadC(Alltrim(SM0->M0_ENDENT),50),oFont10)
		oRps:Say(355,680,PadC(Alltrim(Alltrim(SM0->M0_BAIRENT) + " - " + Transform(SM0->M0_CEPENT,"@R 99.999-999")),50),oFont10)
		oRps:Say(405,680,PadC(Alltrim(SM0->M0_CIDENT) + " - " + Alltrim(SM0->M0_ESTENT),50),oFont10)
		oRps:Say(455,680,PadC(Alltrim("Telefone:") + Alltrim(SM0->M0_TEL),50),oFont10)
		oRps:Say(505,680,PadC(Alltrim("C.N.P.J.:") + Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"),50),oFont10)
		oRps:Say(555,680,PadC(Alltrim("I.E.:") + Alltrim(SM0->M0_INSC),50),oFont10)
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Informacoes sobre a emissao do RPS³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Say(250,1830,PadC(Alltrim("Número/Série RPS"),15),oFont10n)
		oRps:Say(295,1830,PadC(Alltrim(Alltrim((cAliasSF3)->F3_NFISCAL) + Iif(!Empty((cAliasSF3)->F3_SERIE)," / " + Alltrim((cAliasSF3)->F3_SERIE),"")),15),oFont10)
		oRps:Say(375,1830,PadC(Alltrim("Data Emissão"),15),oFont10n)
		oRps:Say(420,1830,PadC((cAliasSF3)->F3_EMISSAO,15),oFont10)
		oRps:Say(510,1830,PadC(Alltrim("Hora Emissão"),15),oFont10n)
		oRps:Say(555,1830,PadC(Alltrim(cTime),15),oFont10)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Dados do destinatario³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Say(640,nColIni,PadC(Alltrim("DADOS DO DESTINATÁRIO"),75),oFont14n)
		oRps:Say(685,250,"Nome/Razão Social:",oFont10n)
		oRps:Say(745,250,"C.P.F./C.N.P.J.:",oFont10n)
		oRps:Say(805,250,"Inscrição Municipal:",oFont10n)
		oRps:Say(865,250,"Endereço:",oFont10n)
		oRps:Say(925,250,"CEP:",oFont10n)
		oRps:Say(985,250,"Município:",oFont10n)
		oRps:Say(985,1800,"UF:",oFont10n)
		oRps:Say(1045,250,"E-mail:",oFont10n)
		oRps:Say(685,750,Alltrim(cCli),oFont10)
		oRps:Say(745,750,Alltrim(cCNPJCli),oFont10)
		oRps:Say(805,750,Alltrim(cIMCli),oFont10)
		oRps:Say(865,750,Alltrim(cEndCli) + " - " + Alltrim(cBairrCli) ,oFont10)
		oRps:Say(925,750,Transform(cCepCli,"@R 99.999-999"),oFont10)
		oRps:Say(985,750,Alltrim(cMunCli),oFont10)
		oRps:Say(985,1900,Alltrim(cUFCli),oFont10)
		oRps:Say(1045,750,Alltrim(cEmailCli),oFont10)
		oRps:Line(1105,nColIni,1105,nColFim)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Discriminacao dos Servicos ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Say(1140,nColIni,PadC(Alltrim("DISCRIMINAÇÃO DOS SERVIÇOS"),75),oFont14n)
		nLinha	:= 1178
		For nY := 1 to Len(aPrintServ)
			If nY > 15 
				Exit
			Endif
			oRps:Say(nLinha,250,Alltrim(aPrintServ[nY]),oFont10)
			nLinha 	:= nLinha + 45 
		Next
		oRps:Line(1850,nColIni,1850,nColFim)     
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Valores da prestacao de servicos³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Say(1900,nColIni,PadC(Alltrim("VALOR TOTAL DA PRESTAÇÃO DE SERVIÇOS"),50),oFont14n)
		oRps:Say(1900,1700,"R$ " + Transform((cAliasSF3)->F3_VALCONT,"@E 999,999,999.99"),oFont10)
		oRps:Line(1950,nColIni,1950,nColFim)     
		oRps:Say(1980,250,Alltrim("Código do Serviço"),oFont10n)
		oRps:Say(2005,250,Alltrim(cCodServ),oFont10)
		oRps:Line(2050,nColIni,2050,nColFim)                       
		oRps:Line(2050,712,2150,712)
		oRps:Line(2050,1199,2150,1199)
		oRps:Line(2050,1686,2150,1686)
		oRps:Say(2080,250,Alltrim("Total deduções (R$)"),oFont10n)
		oRps:Say(2105,370,Transform(nValDed,"@E 999,999,999.99"),oFont10)
		oRps:Say(2080,737,Alltrim("Base de cálculo (R$)"),oFont10n)
		oRps:Say(2105,857,Transform((cAliasSF3)->F3_BASEICM,"@E 999,999,999.99"),oFont10)
		oRps:Say(2080,1224,Alltrim("Alíquota (%)"),oFont10n)
		oRps:Say(2105,1344,Transform((cAliasSF3)->F3_ALIQICM,"@E 999,999,999.99"),oFont10)
		oRps:Say(2080,1711,Alltrim("Valor do ISS (R$)"),oFont10n)
		oRps:Say(2105,1831,Transform((cAliasSF3)->F3_VALICM,"@E 999,999,999.99"),oFont10)
		oRps:Line(2150,nColIni,2150,nColFim)
		oRps:Say(2180,nColIni,PadC(Alltrim("INFORMAÇÕES SOBRE A NOTA FISCAL ELETRÔNICA"),75),oFont14n)
				
		If !Empty(cLinkNf)
			oRps:Say(2205,250,"Clique no link para consulta da NFe ",oFont10n)
			oRps:Say(2235,250,cLinkNf,oFont10,,CLR_RED,CLR_WHITE)
		EndIf
		
		oRps:Line(2250,nColIni,2250,nColFim)
		oRps:Line(2250,712,2350,712)
		oRps:Line(2250,1199,2350,1199)
		oRps:Line(2250,1686,2350,1686)
		
		oRps:Say(2280,250,Alltrim("Número"),oFont10n)
		oRps:Say(2305,370,Padl((cAliasSF3)->F3_NFELETR,14),oFont10)
		oRps:Say(2280,737,Alltrim("Emissão"),oFont10n)
		oRps:Say(2305,857,Padl(Transform(dToC((cAliasSF3)->F3_EMINFE),"@d"),14),oFont10)
		oRps:Say(2280,1224,Alltrim("Código Verificação"),oFont10n)
		oRps:Say(2305,1334,Padl(Transform((cAliasSF3)->F3_CODNFE,"@R !!!!-!!!!"),14),oFont10)
		oRps:Say(2280,1711,Alltrim("Crédito IPTU"),oFont10n)
		oRps:Say(2305,1831,Transform((cAliasSF3)->F3_CREDNFE,"@E 999,999,999.99"),oFont10)
		oRps:Line(2350,nColIni,2350,nColFim)                                                                     
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Outras Informacoes³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		oRps:Say(2390,nColIni,PadC(Alltrim("OUTRAS INFORMAÇÕES"),75),oFont14n)
		nLinha	:= 2423
		For nY := 1 to Len(aPrintObs)
			If nY > 11 
				Exit
			Endif
			oRps:Say(nLinha,250,Alltrim(aPrintObs[nY]),oFont10)
			nLinha 	:= nLinha + 50 
		Next
		oRps:Line(1850,nColIni,1850,nColFim)     
		
		If nCopias > 1 .And. nX < nCopias
			oRps:EndPage()
		Endif
		
	Next
	(cAliasSF3)->(dbSkip())   
	
	If !( (cAliasSF3)->(Eof()) )
		oRps:EndPage()
	Endif

Enddo                 

If ( (cAliasSF3)->(Eof()) )
	oRps:EndPage()
Endif

If !lQuery
	RetIndex("SF3")	
	dbClearFilter()	
	sleep(5000)
	Ferase(cArqInd+OrdBagExt())
Else
	dbSelectArea(cAliasSF3)
	dbCloseArea()
Endif

Return(.T.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MTR948Str ºAutor  ³                    º Data ³ 03/08/2006  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Montar o array com as strings a serem impressas na descr.   º±±
±±º          ³dos servicos e nas observacoes.                             º±±
±±º          ³Se foi uma quebra forcada pelo ponto de entrada, e          º±±
±±º          ³necessario manter a quebra. Caso contrario, montamos a linhaº±± 
±±º          ³de cada posicao do array a ser impressa com o maximo de     º±±
±±º          ³caracteres permitidos.                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºRetorno   ³Array com os campos da query                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros³cString: string completa a ser impressa                     º±±
±±º          ³nLinhas: maximo de linhas a serem impressas                 º±±
±±º          ³nTotStr: tamanho total da string em caracteres              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MATR968                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/ 
Static Function Mtr968Mont(cString,nLinhas,nTotStr)

Local aAux		:= {}
Local aPrint	:= {}

Local cMemo 	:= ""
Local cAux		:= ""

Local nX		:= 1
Local nY 		:= 1
Local nPosi		:= 1

cString := SubStr(cString,1,nTotStr)

For nY := 1 to Min(MlCount(cString,86),nLinhas)

	cMemo := MemoLine(cString,86,nY) 
			
	// Monta a string a ser impressa ate a quebra
	Do While .T.
		nPosi 	:= At("|",cMemo)
		If nPosi > 0
			Aadd(aAux,{SubStr(cMemo,1,nPosi-1),.T.})
			cMemo 	:= SubStr(cMemo,nPosi+1,Len(cMemo))
		Else    
			If !Empty(cMemo)
				Aadd(aAux,{cMemo,.F.})
			Endif
			Exit
		Endif	
	Enddo
Next            
		
For nY := 1 to Len(aAux)
	cMemo := ""
	If aAux[nY][02]   
		Aadd(aPrint,aAux[nY][01])
	Else
		cMemo += Alltrim(aAux[nY][01]) + Space(01)
		Do While !aAux[nY][02]
			nY += 1  
			If nY > Len(aAux)
				Exit
			Endif
			cMemo += Alltrim(aAux[nY][01]) + Space(01)
		Enddo
		For nX := 1 to Min(MlCount(cMemo,86),nLinhas)
			cAux := MemoLine(cMemo,86,nX) 
		   	Aadd(aPrint,cAux)
		Next
	Endif                            
Next   

Return(aPrint)