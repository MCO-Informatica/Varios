#Include 'Protheus.ch'
#Include 'TopConn.ch'
#Include 'Ap5Mail.ch'
#Include 'TbiConn.ch'
#Include 'Parmtype.ch'

//-- Lib Certisign.
User Function CSXFUN(); Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³CSGAqLog   ºAutor: ³David Alves dos Santos ºData: ³19/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Funcao para gerar um arquivo de log na pasta system.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros:³aLogArq...: Vetor que armazenara as informacoes que serao     º±±
±±º           ³            gravados no arquivo de log na pasta system.       º±±
±±º           ³cNomeArq..: Nome do arquivo que sera gravado na pasta system. º±±
±±º           ³cTit......: Titulo que sera gravado dentro do arquivo log.    º±±
±±º           ³cSubTit...: Subtitulo que sera gravado dentro do arquivo log. º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSGAqLog( aLogArq, cNomeArq, cTit, cSubTit )
	
	Local nPar1   := ''
	Local nPar2   := ''
	Local aLog    := {}
	Local aHeader := {}
	Local aBody   := {}
	
	//-- Veriica o tipo das variaveis passadas por parametro.
	If ValType(aLogArq) == "A" .And. ValType(cNomeArq) == "C" .And. ValType(cTit) == "C" .And. ValType(cSubTit) == "C"
			
		// +---------------------------------------------------------------+
		// | A.....: Auditoria                                             |
		// | XX....: SC = Solicitacao de Compras - PC = Pedido de compras. |
		// | WF....: Workflow                                              |
		// | Data..: AAAA + MM + DD + HHMMSS                               |
		// +---------------------------------------------------------------+
		cArqIni := AllTrim(cNomeArq) + Dtos( MsDate() ) + StrTran( Time(), ':', '' ) + ".ini" 
	
		//-- Gera arquivo de log
		While .T.
			If File( cArqIni )
				Sleep(1000)
				nPar1   := Str( Year( dData ), 4, 0 ) + Month( dData, 2, 0 ) + Day( dData, 2, 0 )
				nPar2   := Int( Seconds() )
				cArqIni := AllTrim(cNomeArq) + Str( nPar1 + nPar2, 5, 0 ) + ".ini" 
			Else
				nHdl := FCreate( cArqIni )
				Exit
			EndIf
		EndDo
	
		AAdd( aLog, Replicate( '-', Len(cTit) ) )
		AAdd( aLog, cTit)
		AAdd( aLog, Replicate( '-', Len(cTit) ) )
		AAdd( aLog, cSubTit )
		//           99     999999    000000-XXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXXXXXXXXXXXXXXXXXXX
	
		/*
		| *** WORKFLOW DE LISTA DE PENDENCIA DE XXXXXXXXXXXXXXXX EM 12/12/12 AS 08:08:08 *** |
		123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901
		0        1         2         3         4         5         6         7         8         9         10        11
		*/
	
		For i := 1 To Len(aLogArq)
			aHeader := aLogArq[i,1]
			aBody   := aLogArq[i,2]
			AEval(aBody, { |e, index| AAdd(aLog, aHeader[5] + '     ' + PadR(aBody[index,1], 9) + ' ' + Upper( PadR(aHeader[3], 22, ' ')) + ' ' + PadR(aBody[index][2], 30) + '  ' + aHeader[2] + CRLF ) } )
		Next i
		
		AAdd( aLog, Replicate( '-', Len(cTit) ) )
		AEval( aLog, {|e| FWrite( nHdl, e + CRLF ) } )
		Sleep( 1000 )
		FClose( nHdl )
	Else
		ConOut("[ERRO-0001 | CSXFUN] - Erro ao gerar o arquivo de log, Verifique o tipo das variáveis passadas via parâmetro.")
	EndIf
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³CSWFTLog   ºAutor: ³David Alves dos Santos ºData: ³19/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Tela para selecionar arquivo log gerado pelo workflow.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSWFTLog()

	Local oDlg
	Local oBar
	Local oThb
	Local TLbx
	Local oPnlArq
	Local oPnlMaior
	Local oPnlButton
	Local bSair      := {|| oDlg:End() }
	Local oFnt       := TFont():New('Arial',,,,.F.,,,8,.T.,,,,,,,)
	Local oFntBox    := TFont():New( "Courier New",,-11)
	Local aDADOS     := {'Selecione um arquivo para visualizar seu conteúdo...'}
	Local nList      := 0
	Local cArq       := ''
	Local cExt       := "Auditoria WorkFlow| a*wf*.ini"

	DEFINE MSDIALOG oDlg TITLE 'Auditoria WorkFlow' FROM 0,0 TO 360,800 PIXEL
	
		oPnlArq := TPanel():New(0,0,,oDlg,,,,,,16,16,.F.,.F.)
		oPnlArq:Align := CONTROL_ALIGN_TOP
	
		@ 04,003 SAY 'Informe o arquivo' SIZE  65,07 PIXEL OF oPnlArq
		@ 03,050 MSGET cArq PICTURE '@!' SIZE 190,07 PIXEL OF oPnlArq
		@ 04,228 BUTTON '...'            SIZE  10,08 PIXEL OF oPnlArq ACTION cArq := cGetFile(cExt,'Selecione o arquivo',,'SERVIDOR\system',.T.,1)
		@ 03,250 BUTTON 'Abrir'          SIZE  40,10 PIXEL OF oPnlArq ACTION CSXAbrLog( cArq, @oTLbx, @aDADOS )
	
		oPnlMaior := TPanel():New(0,0,,oDlg,,,,,,13,0,.F.,.F.)
		oPnlMaior:Align := CONTROL_ALIGN_ALLCLIENT
		
		oPnlButton := TPanel():New(0,0,,oDlg,,,,,,13,13,.F.,.F.)
		oPnlButton:Align := CONTROL_ALIGN_BOTTOM
		
		oBar := TBar():New( oPnlButton, 10, 9, .T.,'BOTTOM')
		
		oThb := THButton():New( 1, 1, '&Sair', oBar, bSair , 20, 12, oFnt )
		oThb:Align := CONTROL_ALIGN_RIGHT
		
		oTLbx := TListBox():New(0,0,{|u| Iif(PCount()>0,nList:=u,nList)},{},100,46,,oPnlMaior,,,,.T.,,,oFntBox)
		oTLbx:Align := CONTROL_ALIGN_ALLCLIENT
		oTLbx:SetArray( aDADOS )
		oTLbx:SetFocus()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³CSXAbrLog  ºAutor: ³David Alves dos Santos ºData: ³19/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Funcao para ler arquivo log gerado pelo workflow.             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros:³cArq....: Nome do arquivo.                                    º±±
±±º           ³oTLbx...: Objeto tela.                                        º±±
±±º           ³aDADOS..: Dados que serao lidos.                              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function CSXAbrLog( cArq, oTLbx, aDADOS )
	
	If File( cArq )
		aDADOS := {}
		FT_FUSE( cArq )
		FT_FGOTOP()
		While .NOT. FT_FEOF()
			AAdd( aDADOS, FT_FREADLN() )
			FT_FSKIP()
		End
		FT_FUSE()
		oTLbx:SetArray( aDADOS )
		oTLbx:Refresh()
	Else
		MsgStop( 'Arquivo informado não localizado, verifique...', 'ERRO-0002 | CSXFUN' )
	EndIf
	
Return


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma:  ³CSModHtm   ºAutor: ³Leandro Nishihata      ºData: ³23/09/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao: ³Inclui os o corpo do html, dentro de um modelo padrao         º±±
±±º           ³(cabecalho e rodape).                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºParametros:³cBody..: Corpo do html.                                       º±±
±±º           ³cDir...: Diretorio.                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso:       ³Certisign - Certificadora Digital.                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function CSModHtm(cBody, cDir, lJob)

	Local cRet       := ""
	Local CMV_WSMOD2 := 'MV_WSMOD2' //-- Parametro que contem o html padrao.
	Local lRet       := .T.
	Local cSaveFile  := ""
	Local cPath      := ""
	Local cBarra     := Iif( IsSrvUnix(), '/', '\' ) 
	
	DEFAULT cDir     := cBarra + 'HTMLs' + cBarra
	DEFAULT lJob     := .F.
	
	//-- Verifica o parametro se existe e se ha conteudo.
	If .NOT. GetMv( CMV_WSMOD2, .T. )
		lRet := .F.
		If lJob
			Conout('Por favor, executar a rotina de update de dicionário de dados U_A460UpdA()', "ERRO-0003 | CSXFUN")
		Else
			MsgStop('Por favor, executar a rotina de update de dicionário de dados U_A460UpdA()', "ERRO-0003 | CSXFUN")
		EndIf
	Else
		CMV_WSMOD2 := GetMv( CMV_WSMOD2, .F. )
		If .NOT. File( CMV_WSMOD2 )
			lRet := .F.
			If lJob
				Conout('Não localizado o arquivo modelo HTML do parâmetro MV_WSMOD2.', "ERRO-0004 | CSXFUN")
			Else
				MsgStop('Não localizado o arquivo modelo HTML do parâmetro MV_WSMOD2.', "ERRO-0004 | CSXFUN")
			EndIf
		Endif
	Endif

	//-- Inclui e-mail no layout padrao (html modelo) 
	If lRet
		MakeDir( cDir )
		oHTML := TWFHTML():New( CMV_WSMOD2 )

		oHTML:ValByName( 'CABEC', cBody  )

		cSaveFile := CriaTrab( Nil , .F. ) + '.htm'
		cPath     := cDir + cSaveFile
		
		oHTML:SaveFile( cPath )

		If File( cPath )
			FT_FUSE( cPath )
			FT_FGOTOP()
			While .NOT. FT_FEOF()
				cRet += FT_FREADLN()
				FT_FSKIP()
			Endç
			FT_FUSE()
		EndIf
	EndIf
	
Return( cRet )

//+-------------+------------------------------------------------------------------+
//| Descrição:  | Alimenta o dicionario SX1 Protheus.                              | 
//+-------------+------------------------------------------------------------------+
//| Parametros: | aInX1Cabec   - Informar campos do SX1 que serão populados.       |
//|             | aInX1Perg    - Informar o conteudo que será gravado nos campos.  |
//|             | lForceAtuSx1 - Forçar atualização do SX1.                        |
//+--------------------------------------------------------------------------------+
User Function CSPutSX1( aInX1Cabec, aInX1Perg, lForceAtuSx1 )
	
	Local	aCabSX1  := {}
	Local	aStruSX1 := {}
	
	Local	lInclui  := .F. 
	
	Local	nPosGrp  := 0
	Local	nPosOrd  := 0
	Local	nPosAux  := 0
	Local	nTamGrp	 := 0
	Local	nTamOrd	 := 0
	Local	nA,nB
	
	Local 	cPerg	 := ""
	Local 	cOrdem	 := ""

	Default	lForceAtuSx1 := .F. 
	
	Aadd( aCabSX1 ,{"X1_GRUPO"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_ORDEM"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_PERGUNT" ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_PERSPA"  ,"C" ,"SX1->X1_PERGUNT" })
	Aadd( aCabSX1 ,{"X1_PERENG"  ,"C" ,"SX1->X1_PERGUNT" })
	Aadd( aCabSX1 ,{"X1_VARIAVL" ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_TIPO"    ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_TAMANHO" ,"N" ,0                 })
	Aadd( aCabSX1 ,{"X1_DECIMAL" ,"N" ,0                 })
	Aadd( aCabSX1 ,{"X1_PRESEL"  ,"N" ,0                 })
	Aadd( aCabSX1 ,{"X1_GSC"     ,"C" ,""                })	// G=1-Edit S=2-Text C=3-Combo R=4-Range F=5-File ( X1_DEF01=56 ) E=6-Expression K=7-Check
	Aadd( aCabSX1 ,{"X1_VALID"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_VAR01"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEF01"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEFSPA1" ,"C" ,"SX1->X1_DEF01"   })
	Aadd( aCabSX1 ,{"X1_DEFENG1" ,"C" ,"SX1->X1_DEF01"   })
	Aadd( aCabSX1 ,{"X1_CNT01"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_VAR02"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEF02"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEFSPA2" ,"C" ,"SX1->X1_DEF02"   })
	Aadd( aCabSX1 ,{"X1_DEFENG2" ,"C" ,"SX1->X1_DEF02"   })
	Aadd( aCabSX1 ,{"X1_CNT02"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_VAR03"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEF03"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEFSPA3" ,"C" ,"SX1->X1_DEF03"   })
	Aadd( aCabSX1 ,{"X1_DEFENG3" ,"C" ,"SX1->X1_DEF03"   })
	Aadd( aCabSX1 ,{"X1_CNT03"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_VAR04"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEF04"   ,"C" ,"SX1->X1_DEF04"   })
	Aadd( aCabSX1 ,{"X1_DEFSPA4" ,"C" ,"SX1->X1_DEF04"   })
	Aadd( aCabSX1 ,{"X1_DEFENG4" ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_CNT04"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_VAR05"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEF05"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_DEFSPA5" ,"C" ,"SX1->X1_DEF05"   })
	Aadd( aCabSX1 ,{"X1_DEFENG5" ,"C" ,"SX1->X1_DEF05"   })
	Aadd( aCabSX1 ,{"X1_CNT05"   ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_F3"      ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_PYME"    ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_GRPSXG"  ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_HELP"    ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_PICTURE" ,"C" ,""                })
	Aadd( aCabSX1 ,{"X1_IDFIL"   ,"C" ,""                })	
	
	DbSelectArea('SX1')
	SX1->(DbSetOrder(1))
	
	aStruX1 := SX1->(dbStruct())
	
	For nA:=1 to Len(aInX1Perg)
		nPosGrp := aScan(aInX1Cabec,{|x| x == "X1_GRUPO"}) 
		nPosOrd := aScan(aInX1Cabec,{|x| x == "X1_ORDEM"})
		
		//-- Pega o tamanho dos campos no SX1
		nTamGrp := aStruX1[aScan(aStruX1,{|x| AllTrim(x[1]) == "X1_GRUPO"})][3]
		nTamOrd := aStruX1[aScan(aStruX1,{|x| AllTrim(x[1]) == "X1_ORDEM"})][3]
		
		//-- Recupera o grupo e a ordem tratando os espaços
		cPerg	:= Padr(aInX1Perg[nA,nPosGrp],nTamGrp,Space(1)) 
		cOrdem	:= Padr(aInX1Perg[nA,nPosOrd],nTamOrd,Space(1))
		
		lInclui := !SX1->( DbSeek( cPerg + cOrdem ) )
		//-- Se não for Inclusão e não deva atualizar a SX1
		If !lInclui .And. !lForceAtuSx1
			//-- Não faz nada
		//-- Efetua gravação	
		ElseIf	RecLock('SX1',lInclui)
			//-- Efetua Loop pelas colunas 
			For nB := 1 To Len(aInX1Cabec)
				&("SX1->" + aInX1Cabec[nB]) := aInX1Perg[nA,nB]
			Next nB
			
			//-- Popula os registros com valor Default
			For nB := 1 To Len(aCabSX1)
				nPosAux := aScan(aInX1Cabec,{|x| x == aCabSX1[nB][1]})
				If nPosAux == 0 .And. !Empty(aCabSX1[nB,3])
					&("SX1->" + aCabSX1[nB,1]) := &(aCabSX1[nB,3])
				Endif 
			Next nB 
			SX1->(MsUnLock())
		Endif
	Next nA 
Return

//+-------------------------------------------------------------------+
//| Rotina | CSxACB | Autor | Rafael Beghini | Data | 03.05.2019 
//+-------------------------------------------------------------------+
//| Descr. | Rotina para importar arquivos para o Banco de conhecimento
//|		   | em lote (Mais de um arquivo por vez)
//+-------------------------------------------------------------------+
User Function CSxACB(cAliasA,nRECNO)

	Local oMemo	:= NIL
	Local cMsg	:= 'Rotina customizada para incluir mais de um documento por vez.'
	Local lRet	:= .T.

	Private cMemo		:= ''
	Private aFiles		:= {}
	Private aArquivos	:= {}
	Private cDirectory	:= "C:\"
	Private cMask		:= "*.*                  "
	Private _oDlg		:= NIL
	Private cAviso		:= ' '

	Default cAliasA	:= ''
	
	IF Empty( cAliasA )
		MsgAlert('Rotina sem definição, por favor verifique.','CSxACB - Conhecimento em lote')
		Return
	EndIF

	DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Banco de conhecimento - Certisign") FROM C(178),C(181) TO C(548),C(717) PIXEL
		@ C(004),C(005) Say	   OemtoAnsi(cMsg) 			Size C(200),C(008) COLOR CLR_BLACK 	PIXEL OF _oDlg
		@ C(015),C(005) Say	   OemtoAnsi(cAviso)		Size C(200),C(010) COLOR CLR_HRED 	PIXEL OF _oDlg
		@ C(025),C(005) Button OemtoAnsi("Selecionar ") Size C(037),C(012) PIXEL OF _oDlg ACTION( Processa({|| RunProc(1, cAliasA, nRECNO)}) )
		@ C(025),C(052) Button OemtoAnsi("Salvar") 		Size C(037),C(012) PIXEL OF _oDlg ACTION( Processa( {|| iIF( RunProc(2, cAliasA, nRECNO), _oDlg:End(), NIL) }, '','Anexando arquivo(s), aguarde...', .F. ) )
		@ C(025),C(230) Button OemtoAnsi("Sair") 		Size C(037),C(012) PIXEL OF _oDlg ACTION( lRet := .F.,_oDlg:End() )
		@ C(045),C(003) GET oMemo Var cMemo MEMO 		Size C(264),C(118) PIXEL OF _oDlg
	ACTIVATE MSDIALOG _oDlg CENTERED 

Return(lRet)

Static Function C(nTam)                                                         
	Local nHRes	:=	oMainWnd:nClientWidth	//Resolucao horizontal do monitor      
	Do Case                                                                         
		Case nHRes == 640	//Resolucao 640x480                                         
			nTam *= 0.8                                                                
		Case nHRes == 800	//Resolucao 800x600                                         
			nTam *= 1                                                                  
		OtherWise			//Resolucao 1024x768 e acima                                
			nTam *= 1.28                                                               
	EndCase                                                                         
Return Int(nTam)

Static Function RunProc( nTipo, cAliasA, nRECNO )

	Local aRetPar	:= {}
	Local aEntidade	:= {}
	Local aChave	:= {}
	Local cCodEnt	:= ''
	Local cEntidade	:= ''
	Local lAchou	:= .F.
	Local lRet		:= .T.
	
	IF nTipo == 1

		cDirectory := cGetFile(OemtoAnsi("Arquivos Transferências"),OemToAnsi("Selecione o Diretorio Origem"),0,,.F.,GETF_RETDIRECTORY+GETF_LOCALHARD,.F.)
		aFiles := Directory( cDirectory + Alltrim(cMask) )
		
		CursorWait()
		
		IF Len( aFiles ) > 0
			Procregua(Len( aFiles ))
			For nIxb := 1 To Len( aFiles )
				IncProc()
				AADD( aRetPar, {.F.,aFiles[ nIxb,1]} )
			Next
			aArquivos 	:= SelArq( aRetPar )
			cMemo		:= ""
			Procregua(Len( aArquivos ))
			For nIxb := 1 To Len(aArquivos)
				IncProc()
				cMemo += cDirectory + aArquivos[nIxb]+Chr(13)+Chr(10)
			Next
			IF Len( aArquivos )
				cAviso := 'Clique em salvar...'
			EndIF
		Else
			cMemo := "NÃO EXISTEM ARQUIVOS NA PASTA SELECIONADA"
		Endif	
		CursorArrow()
	Else
		IF Len( aArquivos ) > 0
			cEntidade := IIF(Len(cAliasA) == 3, cAliasA, Substr(cAliasA,0,3))

			dbSelectArea( cEntidade )
			MsGoto( nRECNO )

			aEntidade := MsRelation()

			nScan := AScan( aEntidade, { |x| x[1] == cAliasA } )

			If Empty( nScan ) 
				SX2->( dbSetOrder( 1 ) ) 
				If SX2->( dbSeek( cEntidade ) )  
					If !Empty( SX2->X2_UNICO )       
		   				cUnico   := SX2->X2_UNICO
						dbSelectArea( cEntidade )//Certeza que o alias informado estará na área de trabalho
						cCodEnt  := &cUnico 
						cCodDesc := Substr( AllTrim( cCodEnt ), TamSX3("A1_FILIAL")[1] + 1 ) 
						lAchou   := .T. 
					EndIf
				EndIf
			Else
				aChave   := aEntidade[ nScan, 2 ]
				cCodEnt  := MaBuildKey( cEntidade, aChave )	
				lAchou := .T.
			EndIF

			IF lAchou
				Procregua(Len( aArquivos ))
				For nIxb := 1 To Len( aArquivos )
					IncProc()
					Anexar( cDirectory + aArquivos[nIxb], cCodEnt, aArquivos[nIxb], cAliasA, .T. )
				Next
			Else
				MsgAlert('Não foi possível concluir o processo, verifique com Sistemas.','CSxACB')
			EndIF
		Else
			cMemo := "NENHUM ARQUIVO SELECIONADO"
			lRet  := .F.
		Endif
	Endif
Return( lRet )

Static Function SelArq( aTipos )
	LOCAL nX        := NIL
	LOCAL cCad      := OemToAnsi("Selecione o Arquivos")
	LOCAL cAlias    := Alias()
	LOCAL oOk       := LoadBitmap( GetResources(), "LBOK" )
	LOCAL oNo       := LoadBitmap( GetResources(), "LBNO" )
	LOCAL cVar      := "  "
	LOCAL nOpca     := NIL
	LOCAL aTipoBack :={}
	Local lTodos    := .T.
	Local aRetSel   := {}
	
	Private nTotSel   := 0
	Private lMarcados := .T.
	Private oLbx      := NIL
	Private oDlg      := NIL
	Private oBmp      := NIL
	Private oTexto    := NIL

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta array com os arquivos                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nTotSel := 0

	aTipoBack := aClone(aTipos)
	nOpca := 0
	lPrimeira := .T.

	DEFINE MSDIALOG oDlg TITLE cCad From 9,0 To 38,080 OF oMainWnd

		@0.5,0.5 TO 12.7, 38.0 LABEL cCad OF oDlg
		@2.3,003 Say OemToAnsi("  ")
		@1.0,1.5 LISTBOX oLbx VAR cVar Fields HEADER " ","ARQUIVOS" SIZE 285,160 ON DBLCLICK(aTipoBack:=TrocaSel(oLbx:nAt,aTipoBack),oLbx:Refresh()) NOSCROLL
		oLbx:SetArray(aTipoBack)
		oLbx:bLine := {||{if(aTipoBack[oLbx:nAt,1],oOk,oNo),aTipoBack[oLbx:nAt,2]}}
		@ 000,000 Bitmap oBmp Resname "PROJETOAP" Of oDlg Size 425,780 NoBorder When .F. Pixel
		cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
		@ 190,1.5 Say oTexto Var cTexto Of oDlg Pixel Size 65,80
		@ 200,1.5 Checkbox oChk Var lTodos Prompt "Marca/Desmarca Todos" Size 70, 10 Of oDlg Pixel On Click (aTipoBack := SeleAll(aTipoBack))
		oChk:oFont := oDlg:oFont
		oBmp:Refresh(.T.)
		nCol := 30
		
		DEFINE SBUTTON oBtn2 FROM 200,215  TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON oBtn3 FROM 200,260  TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED

	IF nOpca == 1
		aTipos := Aclone(aTipoBack)
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a string de tipos para filtrar o arquivo               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cTipos :=""
	For nX := 1 To Len(aTipos)
		If aTipos[nX,1]
			AADD(aRetSel, aTipos[nX,2] )
		End
	Next nX

	If Len( aRetSel ) == 0
		Aviso("Atenção","Nenhum arquivo foi selecionado para transferência..",{"Ok"},1,"Transferência")
	Endif

	DeleteObject(oOk)
	DeleteObject(oNo)

	dbSelectArea(cAlias)
Return aRetSel

Static Function SeleAll(aTipoBack)

	If lMarcados
		lMarcados := .F.
		nTotSel   := 0
		
		For nI := 1 to Len(aTipoBack)
			aTipoBack[nI,1] := .F.
		Next
	Else
		lMarcados := .T.
		nTotSel := 0
		
		For nI := 1 to Len(aTipoBack)
			aTipoBack[nI,1] := .T.
			nTotSel += 1
		Next
	EndIf

	cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
	oLbx:Refresh(.T.)
	oDlg:Refresh(.T.)
	oBmp:Refresh(.T.)
	oTexto:Refresh()
Return aTipoBack

Static Function TrocaSel(nIt,aTipoBack)

	IF ! aTipoBack[nIt,1]
		nTotSel += 1
	Else
		nTotSel -= 1
	Endif

	aTipoBack[nIt,1] := !aTipoBack[nIt,1]

	cTexto := "Total Selecionado: "+Alltrim(Transform(nTotSel,"@ 999999"))
	oLbx:Refresh(.T.)
	oDlg:Refresh(.T.)
	oBmp:Refresh(.T.)
	oTexto:Refresh()

Return aTipoBack

//--------------------------------------------------------------------------
// Rotina | Anexar | Autor | Rafael Beghini        | Data | 03.05.2019
//--------------------------------------------------------------------------
// Descr. | Rotina para anexar os arquivos conforme selecionados
//--------------------------------------------------------------------------
// Uso    | Certisign Certificadora Digital S.A. 
//--------------------------------------------------------------------------
Static Function Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
	Local lRet := .T.
	Local cFile := ''
	Local cExten := ''
	Local cObjeto := ''
	Local cACB_CODOBJ := ''
	
	// Função do padrão que copia o objeto para o diretório do banco de conhecimentos.
	If lFirst
		lRet := FT340CpyObj( cArquivo )
	Endif
	
	If lRet
		SplitPath( cArquivo,,,@cFile, @cExten )
		cObjeto := Left( Upper( cFile + cExten ),Len( cArquivo ) )
		
		cACB_CODOBJ := GetSXENum('ACB','ACB_CODOBJ')

		cDocumento := Ft340RmvAc( cDocumento )

		ACB->( RecLock( 'ACB', .T. ) )
		ACB->ACB_FILIAL	:= xFilial( 'ACB' )
		ACB->ACB_CODOBJ	:= cACB_CODOBJ
		ACB->ACB_OBJETO	:= Ft340RmvAc( cObjeto )
		ACB->ACB_DESCRI	:= cDocumento
		If FindFunction( 'MsMultDir' ) .And. MsMultDir()
			ACB->ACB_PATH	:= MsDocPath( .T. )
		Endif
		ACB->( MsUnLock() )
		ACB->( ConfirmSX8() )
		
		AC9->( RecLock( 'AC9', .T. ) )
		AC9->AC9_FILIAL	:= xFilial( 'AC9' )
		AC9->AC9_FILENT	:= xFilial( cEntidade )
		AC9->AC9_ENTIDA	:= cEntidade
		AC9->AC9_CODENT	:= cNUM_DOC
		AC9->AC9_CODOBJ	:= cACB_CODOBJ
		AC9->AC9_DTGER    := dDataBase
		AC9->( MsUnLock() )
		
		ACC->( RecLock( 'ACC', .T. ) )
		ACC->ACC_FILIAL := xFilial( 'ACC' )
		ACC->ACC_CODOBJ := cACB_CODOBJ
		ACC->ACC_KEYWRD := cNUM_DOC + ' ' + cDocumento
		ACC->( MsUnLock() )
	Else
		MsgAlert('Não foi possível anexar o documento no banco de conhecimento, problemas com o FT340CPYOBJ.','Inconsistência')
	Endif
Return(cObjeto)

//-- 
User Function CSReplica( cOrigem, cDestino, cCodigo, cNumDoc )
    Local aArea		:= {}
	Local cTRB		:= ' '	
	Local cArquivo	:= ' '
	Local cDocumento:= ' '
	Local cNUM_DOC	:= ' '
	Local cEntidade	:= ' '
	Local cCodEnt	:= ' '
	Local cFilEnt	:= xFilial(cOrigem)
    Local lFirst	:= .F.

	If .NOT. GetMv( 'MV_CSREPLI', .T. )
		CriarSX6( 'MV_CSREPLI', 'L', 'Controle para replicar documentos no Banco conhecimento - ROTINAS CSXFUN.prw', '.T.' )
	Endif

	IF cOrigem == 'SC7' .And. cDestino == 'SF1' .And. GetMv( 'MV_CSREPLI', .F. )
		dbSelectArea('SC7')
		dbSetOrder(1)
		IF dbSeek( xFilial('SC7') + cCodigo )
		
			While .NOT. SC7->( Eof() ) .And. SC7->C7_FILIAL == xFilial('SC7') .And. SC7->C7_NUM == cCodigo
				cCodEnt := SC7->( C7_FILIAL + C7_NUM + C7_ITEM )
				cTRB 	:= GetNextAlias()
				BeginSQL Alias cTRB
					SELECT 	ACB_OBJETO, 
							ACB_DESCRI 
					FROM %Table:AC9% AC9
						INNER JOIN %Table:ACB% ACB 
								ON ACB.%NOTDEL%
									AND ACB_FILIAL = AC9_FILIAL 
									AND ACB_CODOBJ = AC9_CODOBJ 
					WHERE AC9.%NOTDEL%
						AND AC9_FILIAL = %xFilial:AC9%
						AND AC9_FILENT = %Exp:cFilEnt%
						AND AC9_ENTIDA = %Exp:cOrigem%
						AND AC9_CODENT = %Exp:cCodEnt% 	
				EndSQL

				aArea := GetArea()
					While .NOT. (cTRB)->( EOF() )
						cArquivo	:= (cTRB)->ACB_OBJETO
						cDocumento 	:= rTrim( (cTRB)->ACB_DESCRI )
						cNUM_DOC	:= cNumDoc 	//-- Qual entidade está gravando
						cEntidade	:= cDestino	//-- Qual entidade está gravando
						lFirst		:= .F. 		//-- Não irá gravar, pois já existe. Apenas referenciar
				
						Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
						
						(cTRB)->( dbSkip() )
					End
					(cTRB)->( dbCloseArea() )
					FErase( cTRB + GetDBExtension() )
				RestArea( aArea )
				
				SC7->( dbSkip() )
			End
		EndIF
	ElseIF cOrigem == 'SC1' .And. cDestino == 'SC7' .And. GetMv( 'MV_CSREPLI', .F. )
		dbSelectArea('SC1')
		dbSetOrder(1)
		IF dbSeek( xFilial('SC1') + cCodigo )
			While .NOT. SC1->( Eof() ) .And. SC1->C1_FILIAL == xFilial('SC1') .And. SC1->C1_NUM == cCodigo
				cCodEnt := SC1->( C1_FILIAL + C1_NUM + C1_ITEM )
				cTRB 	:= GetNextAlias()
				BeginSQL Alias cTRB
					SELECT 	ACB_OBJETO, 
							ACB_DESCRI 
					FROM %Table:AC9% AC9
						INNER JOIN %Table:ACB% ACB 
								ON ACB.%NOTDEL%
									AND ACB_FILIAL = AC9_FILIAL 
									AND ACB_CODOBJ = AC9_CODOBJ 
					WHERE AC9.%NOTDEL%
						AND AC9_FILIAL = %xFilial:AC9%
						AND AC9_FILENT = %Exp:cFilEnt%
						AND AC9_ENTIDA = %Exp:cOrigem%
						AND AC9_CODENT = %Exp:cCodEnt% 	
				EndSQL

				aArea := GetArea()
					While .NOT. (cTRB)->( EOF() )
						cArquivo	:= (cTRB)->ACB_OBJETO
						cDocumento 	:= rTrim( (cTRB)->ACB_DESCRI )
						cNUM_DOC	:= cNumDoc 	//-- Qual entidade está gravando
						cEntidade	:= cDestino	//-- Qual entidade está gravando
						lFirst		:= .F. 		//-- Não irá gravar, pois já existe. Apenas referenciar
				
						Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
						
						(cTRB)->( dbSkip() )
					End
					(cTRB)->( dbCloseArea() )
					FErase( cTRB + GetDBExtension() )
				RestArea( aArea )
				
				SC1->( dbSkip() )
			End
		EndIF
	ElseIF cOrigem == 'CND' .And. cDestino == 'SC7' .And. GetMv( 'MV_CSREPLI', .F. )
		dbSelectArea('CND')
		dbSetOrder(1)
		IF dbSeek( xFilial('CND') + cCodigo )
			cCodEnt	:= xFilial('CND') + CND->(CND_CONTRA+CND_REVISA+CND_NUMMED)
			cTRB 	:= GetNextAlias()
			BeginSQL Alias cTRB
				SELECT 	ACB_OBJETO, 
						ACB_DESCRI 
				FROM %Table:AC9% AC9
					INNER JOIN %Table:ACB% ACB 
							ON ACB.%NOTDEL%
								AND ACB_FILIAL = AC9_FILIAL 
								AND ACB_CODOBJ = AC9_CODOBJ 
				WHERE AC9.%NOTDEL%
					AND AC9_FILIAL = %xFilial:AC9%
					AND AC9_FILENT = %Exp:cFilEnt%
					AND AC9_ENTIDA = %Exp:cOrigem%
					AND AC9_CODENT = %Exp:cCodEnt% 	
			EndSQL

			aArea := GetArea()
				While .NOT. (cTRB)->( EOF() )
					cArquivo	:= (cTRB)->ACB_OBJETO
					cDocumento 	:= rTrim( (cTRB)->ACB_DESCRI )
					cNUM_DOC	:= cNumDoc 	//-- Qual entidade está gravando
					cEntidade	:= cDestino	//-- Qual entidade está gravando
					lFirst		:= .F. 		//-- Não irá gravar, pois já existe. Apenas referenciar

					IF .NOT. 'CAPADESPESA' $ rTrim( cArquivo )
						Anexar( cArquivo, cNUM_DOC, cDocumento, cEntidade, lFirst )
					EndIF
					
					(cTRB)->( dbSkip() )
				End
				(cTRB)->( dbCloseArea() )
				FErase( cTRB + GetDBExtension() )
			RestArea( aArea )
		EndIF
	EndIF
Return