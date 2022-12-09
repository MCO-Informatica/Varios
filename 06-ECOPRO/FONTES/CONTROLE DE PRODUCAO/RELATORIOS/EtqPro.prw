#include "protheus.ch"
#include "topconn.ch"
#include "rptdef.ch"
#include "FWPrintSetup.ch"

#DEFINE MARCA  		01
#DEFINE NUMERO		02
#DEFINE ITEM		03
#DEFINE SEQ     	04
#DEFINE PRODUTO  	05
#DEFINE LOCAL		06
#DEFINE QTD 		07
#DEFINE EMISSAO 	08
#DEFINE CODETQ   	09
#DEFINE PRODESC   	10

/*
Programa  - EtqPro
Autor     - Marcos Cesar 
Data      - 12/06/2021
Descrição - EmissÃ£o de Etiquetas para Controle de Produção
*/
User Function EtqPro(cNumOp,nQtdvias,cPasta)

//Local aPergAux := {}
Local lJob	:= (Select('SX6')==0)
Local cPerg	:= PadR("ETQCON",10)
Local aEtq  := {}

Default cNumOp := ""
Default nQtdvias:= 0
Default cPasta := GetNewPar( "MV_XPASETQ", "C:\ETIQUETAS PCP\")

Private oMarca  := LoadBitmap(GetResources(),"LBTIK")
Private oDesma	:= LoadBitmap(GetResources(),"LBNO")

Private oPen	:= TPen():New(0,5,CLR_BLACK)
Private oPrint

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( '01', '01' )
	EndIf

	if !empty(cNumOp)
		lJob := .t.
        //Pergunte(cPerg,.f.,@aPergAux)
        //mv_par01 := cPasta              //Pasta Impressão ?
        //mv_par02 := Stod("20000101")    //Emissao De      ?
        //mv_par03 := Stod("29991231")    //Emissao Ate     ?
        //mv_par04 := cNumOp              //OP De           ?
        //mv_par05 := cNumOp              //OP Ate          ?
        //mv_par06 := nQtdvias             //QTD vias        ?
        //__SaveParam(cPerg, aPergAux)    //Chama a rotina para salvar os parâmetros
		PopEqt(@aEtq,cNumOp)
	else
	    if fPrepara(cPerg,cPasta)
		   cPasta := mv_par01
		   nQtdvias := mv_par06
           if !ExistDir( substr(cPasta,1,len(cPasta)-1) )
		      if MakeDir( substr(cPasta,1,len(cPasta)-1) ) != 0
			     msginfo( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
			  endif
		   endif
		   Processa({|| aEtq := fPrcTela() })
		endif
	endif
	fFazImpr(aEtq,cPasta,nQtdvias,lJob)

Return .t.

Static function fFazImpr(aEtq,cPasta,nQtdvias,lJob)
Local cFilename         := 'EtqPro'+dtos(date())+replace(time(),':','')
Local lAdjustToLegacy   := .t.   //.F.
Local lDisableSetup     := .t.
Local nDevice           := IMP_PDF  //IMP_SPOOL
Local nResol            := 95

	If len(aEtq) > 0 .and. ( lJob .or. MsgYesNo("Confirma a Impressão das Etiquetas Geradas ?") )
		oPrint:= FWMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, , lDisableSetup)
		oPrint:SetResolution(nResol)
		oPrint:SetLandscape()   //paisagem
		//oPrint:SetPortrait()  //retrato
		//oPrint:SetPaperSize(DMPAPER_A4)
		oPrint:SetPaperSize(0,20,80)	//80 x 20
		oPrint:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
		oPrint:cPathPDF := alltrim(cPasta) // Caso seja utilizada impressÃ£o em IMP_PDF

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
			if !MsgYesNo("Pasta impressão default é "+cPasta+". Confirma Impressão na pasta informada no parâmetro ?")
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

		DEFINE MSDIALOG oTela TITLE "Controle de Produção Etiquetas - Total (" + AllTrim(Str(Len(aEtq),6))+') ' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

		@ 010, 005 LISTBOX oBrwEtq Fields HEADER '','Numero',"Item","Sequência","Produto","Local", "Qtd", "Emissão", "Cód.Etiqueta" SIZE 490, 210 OF oTela PIXEL ColSizes 50,50

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
			aEtq[oBrwEtq:nAt,ITEM],;
			aEtq[oBrwEtq:nAt,SEQ],;
			aEtq[oBrwEtq:nAt,PRODUTO],;
			aEtq[oBrwEtq:nAt,LOCAL],;
			TransForm(aEtq[oBrwEtq:nAt,QTD],'@E 999,999,999.99'),;
			aEtq[oBrwEtq:nAt,EMISSAO],;
			aEtq[oBrwEtq:nAt,CODETQ] ;
			} }
		oBrwEtq:Refresh()
            /*
            oBrwEtq:=fwBrowse():New()
            oBrwEtq:setOwner( oFolder1:aDialogs[1] )
            oBrwEtq:setDataArray()
            oBrwEtq:setArray( aColCaEx )
            oBrwEtq:disableConfig()
            oBrwEtq:disableReport()
            oBrwEtq:SetLocate() // Habilita a LocalizaÃ§Ã£o de registros
            //Create Mark Column
            oBrwEtq:AddMarkColumns(;
                {|| Iif(aColCaEx[oBrwEtq:nAt,01], "LBOK", "LBNO")},; //Code-Block image
                {|| SelectOne(oBrwEtq, aColCaEx, nOpc)},; //Code-Block Double Click
                {|| SelectAll(oBrwEtq, 01, aColCaEx, nOpc) }) //Code-Block Header Click
            oBrwEtq:addColumn({"Id"             , {||aColCaEx[oBrwEtq:nAt,02]}, "C", "@!"                     , 1,  02    ,  0  , .F. , , .F.,, "aColCaEx[oBrwEtq:nAt,02]",, .F., .T.,  , "IdCa"   })
            oBrwEtq:addColumn({"DescriÃ§Ã£o"      , {||aColCaEx[oBrwEtq:nAt,03]}, "C", "@!"                     , 1,  40    ,  0  , .F. , , .F.,, "aColCaEx[oBrwEtq:nAt,03]",, .F., .T.,  , "DescCa"  })
            oBrwEtq:addColumn({"Valor"          , {||aColCaEx[oBrwEtq:nAt,04]}, "N", "@E 99,999,999.99999"    , 1,  16    ,  5  , .T. , , .F.,, "aColCaEx[oBrwEtq:nAt,04]",, .F., .T.,  , "VlrCa"   })
            oBrwEtq:setEditCell( .T. , { || .T. } ) //activa edit and code block for validation
            //oBrwEtq:acolumns[2]:ledit     := .F.
            //oBrwEtq:acolumns[2]:cReadVar:= 'aColCaEx[oBrwEtq:nAt,2]'
            //oBrwEtq:setInsert(.T.)  // habilitar inserÃ§Ã£o
            //oBrwEtq:SetDelete(.T.)  // habilitar deleÃ§Ã£o
            //oBrwEtq:DelLine(.T.) // Para executar uma funÃ§Ã£o
            //oBrwEtq:LineOk(.T.)  // Para executar uma funÃ§Ã£o
            oBrwEtq:Activate(.T.)
            */

		ACTIVATE MSDIALOG oTela CENTERED

	Else
		MsgStop("Atenção Nenhuma etiqueta gerada !")
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

	Aadd(aPerg, {cPerg, "01", "Pasta Impressão ?", "Mv_ch1", "C", 70, 0, 0, "G", "", "mv_par01", "", "", "", ""})
	Aadd(aPerg, {cPerg, "02", "Emissao De      ?", "Mv_ch2", "D", 08, 0, 0, "G", "", "mv_par02", "", "", "", ""})
	Aadd(aPerg, {cPerg, "03", "Emissao Ate     ?", "Mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", ""})
	Aadd(aPerg, {cPerg, "04", "OP De           ?", "Mv_ch4", "C", 06, 0, 0, "G", "", "mv_par04", "", "", "", "SC2"})
	Aadd(aPerg, {cPerg, "05", "OP Ate          ?", "Mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "SC2"})
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

Static Function PopEqt(aEtq,cNumOp)

Local cSql  := ""
Local nReg  := 0
Local nTReg := 0

	cSql := "select * from "+RetSqlName("SC2")+" sc2 inner join "+RetSqlName("SB1")+" sb1 "
	cSql += "on b1_filial = '"+xFilial("SB1")+"' and b1_cod = c2_produto and sb1.d_e_l_e_t_ = ' ' and b1_tipo = 'PA' "
	cSql += "where c2_filial = '"+xFilial("SC2")+"' "
	if empty(cNumOp)
	   cSql += "and c2_num >=  '"+mv_par04+"' and c2_num <= '"+mv_par05+"' and c2_sequen = '001' "
	   cSql += "and c2_emissao >= '"+dtos(mv_par02)+"' and c2_emissao <= '"+dtos(mv_par03)+"' "
	else
	   cSql += "and c2_num = '"+cNumOp+"' and c2_sequen = '001' "
	endif
	cSql += "and sc2.d_e_l_e_t_ = ' '"
	TcQuery cSql New Alias "tsc2"

	TCSetField( 'tsc2', 'C2_EMISSAO', 'D', TamSX3('C2_EMISSAO')[01], TamSX3('C2_EMISSAO')[02] )

	Count To nTReg
	if nTReg > 0
		tsc2->(dbGoTop())

		ProcRegua(nTReg)
		While !tsc2->(Eof())
			nReg += 1
			IncProc("Localizando (" + AllTrim(Str(nReg,6))+") Controle de Produção...")

			AAdd(aEtq,  {	'2',;
				tsc2->c2_num,;
				tsc2->c2_item,;
				tsc2->c2_sequen,;
				tsc2->c2_produto,;
				tsc2->c2_local,;
				tsc2->c2_quant,;
				dtoc(tsc2->c2_emissao),;
				tsc2->c2_num+'.'+tsc2->c2_sequen+'.'+Month2Str(tsc2->c2_emissao)+Substr(Year2Str(tsc2->c2_emissao),3,2),;
				tsc2->b1_desc ;
				};
				)

			tsc2->(dbSkip())
		End
	endif
	tsc2->(dbCloseArea())

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
		msginfo("Nenhum Controle de Produção foi marcado!")
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
		IncProc("Processando Controle de produção " + aCols[nPos,NUMERO]+"...")
		aCols[nPos,MARCA] := '1'
	Next

Return .t.

Static Function DesMarcaTodas(aCols)
local nPos := 0

	ProcRegua(Len(aCols))
	For nPos := 1 To Len(aCols)
		IncProc("Processando Controle de produção " + aCols[nPos,NUMERO]+"...")
		aCols[nPos,MARCA]:="2"
	Next

Return .t.


Static Function ImpEtq(aEtq,nQtdvias)

//Local cLogo := 'c:\temp\ecopro.bmp'
Local cLogo := 'ecopro.bmp'
Local cCodEtq := ''
Local cObjEtq := ''
Local cDesc   := ''
Local n       := 0
Local nI      := 0
Local nEtq    := 0
Local ncol    := 0
Local ncoll   := 0
Local nLin    := 0
Local nLinl   := 0
Local nLinPag := 0
Local nRepEtq := 0

//Local oCouNew08		:= TFont():New("Courier New"	,08,08,,.F.,,,,.F.,.F.)
//Local oCouNew08N		:= TFont():New("Courier New"	,08,08,,.T.,,,,.F.,.F.)		// Negrito //oCouNew09N
Local oArial09N	:= TFont():New("Arial"	,09,09,,.T.,,,,.F.,.F.)		// Negrito
Local oArial10N	:= TFont():New("Arial"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
Local oArial12N	:= TFont():New("Arial"	,12,12,,.T.,,,,.F.,.F.)		// Negrito
Local oArial13N	:= TFont():New("Arial"	,13,13,,.T.,,,,.F.,.F.)		// Negrito

	ProcRegua(Len(aEtq))
	oPrint:StartPage()

	For n := 1 To Len(aEtq)

		IncProc("Aguarde Imprimindo Etiquetas...")

		cCodEtq := aEtq[n,PRODUTO]
		cDesc   := Upper(alltrim(aEtq[n,PRODESC]))
		nI := 1
		while nI <= 1

			if nEtq == 0
				ncol := 0
			elseif nEtq == 1
				//ncol :=  150	//Resolução 85
				ncol :=  165  //Resolução 95
			endif

			if nLinPag == 1 //8
				oPrint:EndPage()
				oPrint:StartPage()
				nLinPag := nLin := 0
			endif

			//Resolução 95
			oPrint:Say(nLin+06,48+ncol,cCodEtq,oArial12N)
			oPrint:SayAlign(nLin+08,16+ncol,cDesc,oArial10N,134/*LargPixel*/,30/*AlturaPixel*/, ,2,0)
 
			nEtq += 1
			if nEtq > 1
				nEtq := 0
				nLin += 380
				nLinPag += 1
				nI += 1
			endif

		end

		nRepEtq := (aEtq[n,QTD] * nQtdvias)
		cPart1  := substr(aEtq[n,CODETQ],1,6)
		cPart3  := substr(aEtq[n,CODETQ],12,4)
		nI := 1
		while nI <= nRepEtq

			cPart2  := strzero(nI,3)
			cObjEtq := cPart1+cPart2+cPart3
			cCodEtq := cPart1+"."+cPart2+"."+cPart3

			if nEtq == 0
				ncol := 0
				ncoll := 0
			elseif nEtq == 1
				//Resolução 85
				//ncol :=  150
				//ncoll := 11

				//Resolução 95
				ncol :=  165
				ncoll := 12.5
			endif

			if nLinPag == 1 //8
				oPrint:EndPage()
				oPrint:StartPage()
				nLinPag := nLin := nLinl := 0
			endif

			//Resolução 85
			//oPrint:SayBitmap(nLin+2, 30+ncol, cLogo , 80/*nWidth-largura*/, 08/*nHeigth-Altura*/)
			//oPrint:Say(nLin+13, 34+ncol, "NÚMERO DE SÉRIE", oArial09N)
			//oPrint:FwMsBar("CODE128",2.8+nLinl/*Topo*/,0.5+ncoll/*Esquerda*/,cObjEtq,oPrint,.f./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth-largura*/,0.40/*nHeigth-Altura*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/)
			//oPrint:Say(nLin+23, 30+ncol, cCodEtq          , oArial13N)

			//Resolução 95
			oPrint:SayBitmap(nLin, 40+ncol, cLogo , 80/*nWidth-largura*/, 08/*nHeigth-Altura*/)
			oPrint:Say(nLin+13, 46+ncol, "NÚMERO DE SÉRIE", oArial09N)
			oPrint:FwMsBar("CODE128",2.8+nLinl/*Topo*/,1.3+ncoll/*Esquerda*/,cObjEtq,oPrint,.f./*lCheck*/,/*Color*/,.T./*lHorz*/,0.017/*nWidth-largura*/,0.40/*nHeigth-Altura*/,.F./*lBanner*/,"Arial"/*cFont*/,NIL/*cMode*/,.F./*lPrint*/,1/*nPFWidth*/,1/*nPFHeigth*/,.F./*lCmtr2Pix*/)
			oPrint:Say(nLin+23, 40+ncol, cCodEtq          , oArial13N)

			nEtq += 1
			if nEtq > 1
				nEtq := 0
				nLin += 380
				nLinl += 8.60
				nLinPag += 1
				nI += 1
			endif

		end

	next

	//oPrint:EndPage()

Return
/*
Static Function GPixel(_nMm)	// ConversÃ£o de Pixels em Milimetros
Local _nRet := (_nMm/25.4)*300
Return(_nRet)
*/
