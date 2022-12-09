#include "protheus.ch"
#include "topconn.ch"
#include "rptdef.ch"
#include "FWPrintSetup.ch"

#DEFINE MARCA  				01
#DEFINE NUMERO				02
#DEFINE EMISSAO				03
#DEFINE CLIENTE     		04
#DEFINE TRANSPORTADORA  	05	
#DEFINE VOLUME			  	06	
#DEFINE NREDUZ			  	07	

User Function EtqFat()

//Local aPergAux := {}
	Local lJob	:= (Select('SX6')==0)
	Local cPerg	:= PadR("ETQFAT",10)
	Local aEtq  := {}

	Default cNumOp := ""
	Default nQtdvias:= 0
	Default cPasta := GetNewPar( "MV_XPASETQ", "C:\ETIQUETAS FAT\")

	Private oMarca  := LoadBitmap(GetResources(),"LBTIK")
	Private oDesma	:= LoadBitmap(GetResources(),"LBNO")

	Private oPen	:= TPen():New(0,5,CLR_BLACK)
	Private oPrint

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( '01', '01' )
	EndIf

	if fPrepara(cPerg,cPasta)
		cPasta := mv_par01
		nQtdvias := mv_par06
		if !ExistDir( substr(cPasta,1,len(cPasta)-1) )
			if MakeDir( substr(cPasta,1,len(cPasta)-1) ) != 0
				msginfo( "N„o foi possÌvel criar o diretÛrio. Erro: " + cValToChar( FError() ) )
			endif
		endif
		Processa({|| aEtq := fPrcTela() })
	endif

	fFazImpr(aEtq,cPasta,nQtdvias,lJob)

Return .t.

Static function fFazImpr(aEtq,cPasta,nQtdvias,lJob)

	Local cFilename         := 'EtqPro'+dtos(date())+replace(time(),':','')
	Local lAdjustToLegacy   := .t.   //.F.
	Local lDisableSetup     := .t.
	Local nDevice           := IMP_PDF  //IMP_SPOOL
	Local nResol            := 95

	If len(aEtq) > 0 .and. ( lJob .or. MsgYesNo("Confirma a Impress„o das Etiquetas Geradas ?") )
		oPrint:= FWMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, , lDisableSetup)
		oPrint:SetResolution(nResol)
		oPrint:SetLandscape()   //paisagem
		//oPrint:SetPortrait()  //retrato
		//oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetPaperSize(0,60,100)	//6x10
		oPrint:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF := alltrim(cPasta) // Caso seja utilizada impress√£o em IMP_PDF

		MsAguarde( {|| ImpEtq(aEtq,nQtdvias) },"Imprimindo Etiquetas...")

		oPrint:Preview() //Visualiza antes de imprimir
		FreeObj(oPrint)
		oPrint := Nil

	endif
Return

Static function fPrepara(cPerg,cPasta)

	Local lRet := .t.

	ValidaPerg(cPerg)
	If !Pergunte(cPerg,.t.)
		lRet := .f.
	else
		if substr(mv_par01,len(alltrim(mv_par01)),1) != '\'
			MsgStop("A barra \ deve ser colocada no final !")
			lRet := .f.
		elseif lower(mv_par01) != lower(cPasta)
			if !MsgYesNo("Pasta impress„o default È "+cPasta+". Confirma Impress„o na pasta informada no par‚metro ?")
				lRet := .f.
			endif
		endif
	Endif

Return lret


Static Function fPrcTela()

	Local oTela, oBrwEtq, oBotaoE, oBotaoM, oBotaoD, oBotaoS
	Local aEtq := {}
	Local aSetq := {}

	PopEqt(@aEtq,)

	if len(aEtq) > 0

		DEFINE MSDIALOG oTela TITLE "Etiquetas ExpediÁ„o  - Total (" + AllTrim(Str(Len(aEtq),6))+') ' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

		@ 010, 005 LISTBOX oBrwEtq Fields HEADER '','Numero',"Emissao","Cliente","Transportadora" SIZE 490, 210 OF oTela PIXEL ColSizes 50,50

		@ 230, 005 BUTTON oBotaoE PROMPT "&Gerar Etiquetas"	ACTION MsAguarde( {|| (aSetq:=PrcEtq(oBrwEtq:aArray) ,Iif(len(aSetq)>0,oTela:End(),.t.))},"Gerando Etiquetas....") SIZE 060, 010 OF oTela PIXEL
		@ 230, 075 BUTTON oBotaoM PROMPT "&Marca Todas" 	ACTION MsAguarde( {|| (MarcaTodas(@oBrwEtq:aArray)   ,oBrwEtq:Refresh())                },"Marcando Etiquetas...") SIZE 060, 010 OF oTela PIXEL
		@ 230, 145 BUTTON oBotaoD PROMPT "&Desmarca Todas" 	ACTION MsAguarde( {|| (DesMarcaTodas(@oBrwEtq:aArray),oBrwEtq:Refresh())                },"Desmarcando Etiquetas") SIZE 060, 010 OF oTela PIXEL
		@ 230, 425 BUTTON oBotaoS PROMPT "&Sair" 			ACTION ( oTela:End(), aSetq := {} ) 	                                                                        SIZE 060, 010 OF oTela PIXEL

		//oTela:cCaption := "Notas Fiscais - Etiquetas Correios - Total Notas (" + AllTrim(Str(Len(aEtq),6))+') '

		oBrwEtq:SetArray(aEtq)
		oBrwEtq:nAt := 1
		oBrwEtq:bLDblClick := {|| ( dblClick(oBrwEtq:nAt,@oBrwEtq:aArray),oBrwEtq:Refresh() ) }
		oBrwEtq:bLine := {|| {	Iif(aEtq[oBrwEtq:nAt,MARCA]=='1',oMarca,oDesma),;
			aEtq[oBrwEtq:nAt,NUMERO],;
			aEtq[oBrwEtq:nAt,EMISSAO],;
			aEtq[oBrwEtq:nAt,CLIENTE],;
			aEtq[oBrwEtq:nAt,TRANSPORTADORA],;			
			aEtq[oBrwEtq:nAt,VOLUME],;			
			aEtq[oBrwEtq:nAt,NREDUZ],;
			} }
		oBrwEtq:Refresh()

		ACTIVATE MSDIALOG oTela CENTERED

	Else
		MsgStop("AtenÁ„o Nenhuma etiqueta gerada !")
	Endif

Return aSetq

//------------------------------------------------------------------------
// aPerg[n,01] := SX1->X1_GRUPO
// aPerg[n,02] := SX1->X1_ORDEM   
// aPerg[n,03] := SX1->X1_PERGUNT 
// aPerg[n,04] := SX1->X1_VARIAVL 
// aPerg[n,05] := SX1->X1_TIPO    
// aPerg[n,06] := SX1->X1_TAMANHO 
// aPerg[n,07] := SX1->X1_DECIMAL 
// aPerg[n,08] := SX1->X1_PRESEL  
// aPerg[n,09] := SX1->X1_GSC     
// aPerg[n,10] := SX1->X1_VALID   
// aPerg[n,11] := SX1->X1_VAR01   
// aPerg[n,12] := SX1->X1_DEF01   
// aPerg[n,13] := SX1->X1_DEF02   
// aPerg[n,14] := SX1->X1_DEF03
// aPerg[n,15] := SX1->X1_F3

Static Function ValidaPerg(cPerg)

	Local aPerg := {}
	Local i := 0

	Aadd(aPerg, {cPerg, "01", "Pasta Impress„o ?", "Mv_ch1", "C", 70, 0, 0, "G", "", "mv_par01", "", "", "", ""})
	Aadd(aPerg, {cPerg, "02", "Emissao De      ?", "Mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02", "", "", "", ""})
	Aadd(aPerg, {cPerg, "03", "Emissao Ate     ?", "Mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", ""})
	Aadd(aPerg, {cPerg, "04", "NF De           ?", "Mv_ch4", "C", 06, 0, 0, "G", "", "mv_par04", "", "", "", "SC2"})
	Aadd(aPerg, {cPerg, "05", "NF Ate          ?", "Mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "SC2"})
	Aadd(aPerg, {cPerg, "06", "QTD vias        ?", "Mv_ch6", "N", 02, 0, 0, "G", "", "mv_par06", "", "", "", ""})

	DbSelectArea("SX1")
	DbSetOrder(1)

	For i := 1 To Len(aPerg)
		If !DbSeek(cPerg + aPerg[i,2],.t.)
			Reclock("SX1",.t.)
			SX1->X1_GRUPO   := aPerg[i,1]
			SX1->X1_ORDEM   := aPerg[i,2]
			SX1->X1_PERGUNT := aPerg[i,3]
			SX1->X1_VARIAVL := aPerg[i,4]
			SX1->X1_TIPO    := aPerg[i,5]
			SX1->X1_TAMANHO := aPerg[i,6]
			SX1->X1_DECIMAL := aPerg[i,7]
			SX1->X1_PRESEL  := aPerg[i,8]
			SX1->X1_GSC     := aPerg[i,9]
			SX1->X1_VALID   := aPerg[i,10]
			SX1->X1_VAR01   := aPerg[i,11]
			SX1->X1_DEF01   := aPerg[i,12]
			SX1->X1_DEF02   := aPerg[i,13]
			SX1->X1_DEF03   := aPerg[i,14]
			SX1->X1_F3      := aPerg[i,15]
		EndIf
		SX1->(MsUnlock())
	Next i

Return(.t.)

**************************************

Static Function PopEqt(aEtq,cNumOp)

**************************************

//POPULAR COM AS INFORMA«√O DO DOCUMENTO

	Local cSql  := ""
	Local nReg  := 0
	Local nTReg := 0

	cSql := "select A4_NOME , A1_NOME, F2_DOC, F2_emissao, F2_VOLUME1, A4_NREDUZ  from "+RetSqlName("SF2")+" SF2 inner join "+RetSqlName("SA1")+" SA1 "
	cSql += "on A1_FILIAL = '"+xFilial("SA1")+"' and A1_COD = F2_CLIENTE AND SA1.d_e_l_e_t_ = ' '  "
	cSql += "inner join "+RetSQLName("SA4")+" SA4 on A4_COD = F2_TRANSP AND SA4.d_e_l_e_t_ = ' ' "
	cSql += "where F2_filial = '"+xFilial("SF2")+"' "
	//cSql += "and c2_num >=  '"+mv_par04+"' and c2_num <= '"+mv_par05+"' /*and c2_sequen = '001'*/ "
	cSql += "and F2_DOC >=  '"+mv_par04+"' and F2_DOC <= '"+mv_par05+"' "
	cSql += "and F2_emissao >= '"+dtos(mv_par02)+"' and F2_emissao <= '"+dtos(mv_par03)+"' "
	cSql += "and sf2.d_e_l_e_t_ = ' '"
	TcQuery cSql New Alias "tsf2"

	TCSetField( 'tsf2', 'F2_emissao', 'D', TamSX3('F2_emissao')[01], TamSX3('F2_emissao')[02] )

	Count To nTReg
	if nTReg > 0
		tsf2->(dbGoTop())

		ProcRegua(nTReg)
		While !tsf2->(Eof())
			nReg += 1
			IncProc("Localizando Nota Fiscal...")

			AAdd(aEtq,  {	'2',;
				tsf2->F2_DOC,;
				tsf2->F2_emissao,;
				tsf2->A1_NOME,;
				tsf2->A4_NOME ,; 
				Iif(tsf2->F2_VOLUME1==0,1,tsf2->F2_VOLUME1),; 
				tsf2->A4_NREDUZ ,; 
				};
				)


			tsf2->(dbSkip())
		End
	endif
	tsf2->(dbCloseArea())

Return

Static Function PrcEtq(aEtq)

	Local nI   := 0
	Local aSetq := {}

	For nI := 1 To Len(aEtq)
		If aEtq[nI,MARCA]=='1'
			aadd( aSetq, aEtq[nI] )
		Endif
	Next
	if len(aSetq) == 0
		msginfo("Nenhum Controle de ProduÁ„o foi marcado!")
	endif

Return aSetq

Static Function dblClick(nPos,aCols)
	If aCols[nPos,MARCA]=="1"
		aCols[nPos,MARCA]:="2"
	ElseIf aCols[nPos,MARCA]=="2"
		aCols[nPos,MARCA]:="1"
	Endif
Return .t.

Static Function MarcaTodas(aCols)
	local nPos := 0

	ProcRegua(Len(aCols))
	For nPos := 1 To Len(aCols)
		IncProc("Processando Documento " + aCols[nPos,NUMERO]+"...")
		aCols[nPos,MARCA] := '1'
	Next

Return .t.

Static Function DesMarcaTodas(aCols)
	local nPos := 0

	ProcRegua(Len(aCols))
	For nPos := 1 To Len(aCols)
		IncProc("Processando Documento " + aCols[nPos,NUMERO]+"...")
		aCols[nPos,MARCA]:="2"
	Next

Return .t.
**************************************

Static Function ImpEtq(aEtq,nQtdvias)

**************************************

	Local cLogo		:= 'ecopro.bmp'
	Local cNumNF	:= ''
	Local cTransp	:= ''	
	Local cObjEtq	:= ''
	Local cCliente	:= ''
	Local n			:= 0
	Local nI		:= 0
	Local nEtq		:= 0
	Local ncol		:= 0
	Local ncoll		:= 0
	Local nLin		:= 0
	Local nLinl		:= 0
	Local nLinPag	:= 0
	Local nRepEtq	:= 0
	Local cCGCPict	:= PesqPict("SA1","A1_CGC")
	Local cCGCECO	:= Alltrim(SM0->M0_CGC)
	Local oBrush1	:= TBrush():New( , CLR_BLACK)
	Local oBrush2	:= TBrush():New( , CLR_GRAY)
	Local cNomeC	:= Alltrim(SM0->M0_NOMECOM)
	Local oArial09N	:= TFont():New("Arial"	,09,09,,.T.,,,,.F.,.F.)		// Negrito
	Local oArial10N	:= TFont():New("Arial"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
	Local oArial15N	:= TFont():New("Arial"	,15,15,,.T.,,,,.F.,.F.)		// Negrito
	Local oArial25N	:= TFont():New("Arial"	,25,25,,.T.,,,,.F.,.F.)		// Negrito

	ProcRegua(Len(aEtq))
	oPrint:StartPage()

	For n := 1 To Len(aEtq)

		IncProc("Aguarde Imprimindo Etiquetas...")

		cNumNF		:= aEtq[n,NUMERO]
		cTransp		:= aEtq[n,TRANSPORTADORA]
		cCliente	:= Upper(alltrim(aEtq[n,CLIENTE]))

		nRepEtq := (aEtq[n,VOLUME] * nQtdvias)
		cPart1  := STRZERO(aEtq[n,VOLUME],2)
		//cPart3  := substr(aEtq[n,CODETQ],12,4)
		nI := 1
		while nI <= nRepEtq

 			cPart2  := strzero(nI,2)
			cObjEtq := cPart2+cPart1
			cVolume := cPart2+"/"+cPart1
			if nEtq == 0
				ncol := 0
				ncoll := 0
			elseif nEtq == 1
				//ResoluÁ„o 85
				//ncol :=  150
				//ncoll := 11

				//ResoluÁ„o 95
				//ncol :=  165
				ncol :=  105
				ncoll := 12.5
			endif

			if nLinPag == 1 //8
				oPrint:EndPage()
				oPrint:StartPage()
				nLinPag := nLin := nLinl := 0
			endif

			//oPrint:Box(nLin-52,nCol,nLin+215,nCol+504 )
			oPrint:Fillrect( { nLin-50 ,nCol ,nLin+003 ,nCol+504 }, oBrush1, "-1")			
			oPrint:Say(nLin-10 ,070+ncol,SUBSTR(cTransp,1,18),oArial25N,,CLR_WHITE,,2)		

			//oPrint:Say(nLin+040,020+ncol,cCliente,oArial25N)
			oPrint:SayAlign(nLin+040,020+ncol,alltrim(cCliente),oArial25N,470/*LargPixel*/,28/*AlturaPixel*/, ,2,1)

			oPrint:Box(nLin+120,nCol,nLin+150,nCol+504 )
			oPrint:Say(nLin+138,040+ncol,"NOTA FISCAL",oArial15N)

			oPrint:Box(nLin+120,340+nCol,nLin+190,nCol+504 )
			oPrint:Fillrect( { nLin+120 ,340+nCol ,nLin+190 ,nCol+504 }, oBrush1, "-1")		
			oPrint:Say(nLin+138,380+ncol,"VOLUMES",oArial15N,,CLR_WHITE,,2)	
			oPrint:Say(nLin+180,390+ncol,cVolume,oArial25N,,CLR_WHITE,,2)	

			oPrint:Say(nLin+180,040+ncol,cNumNF,oArial25N)						
			oPrint:Box(nLin+190,nCol,nLin+190,nCol+504 )
			oPrint:Say(nLin+210,010+ncol,cNomeC+ " - ",oArial10N)
			//oPrint:Box(nLin+100,340+nCol,nLin+100,nCol+504 )
			oPrint:Say(nLin+210,375+ncol,Transform(cCGCECO,cCGCPict),oArial10N)



			//oPrint:Say( 0600, 0320, TransForm(AllTrim(cCNPJ),cCGCPict),oArial10N,100 )

			//oPrint:Fillrect( { nLin+140 ,nCol+202 ,nLin+215 ,nCol+504 }, oBrush2, "-1")								

			//oPrint:Say(nLin+13, 46+ncol, "Volumes", oArial09N)
			//oPrint:Say(nLin+23, 40+ncol, cVolume          , oArial15N)

			//nEtq += 1
			//if nEtq > 1
				nEtq := 0
				nLin += 380
				nLinl += 8.60
				nLinPag += 1
				nI += 1
			//endif

		end

	next

	//oPrint:EndPage()

Return
/*
Static Function GPixel(_nMm)	// Convers√£o de Pixels em Milimetros
Local _nRet := (_nMm/25.4)*300
Return(_nRet)
*/
