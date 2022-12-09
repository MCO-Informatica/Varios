#Include "Protheus.ch"
#Include "FWPrintSetup.ch"
#Include "RptDef.ch"
#include "TopConn.ch"

#DEFINE MARCA  		01
#DEFINE NUMERO		02
#DEFINE ITEM		03
#DEFINE SEQ     	04
#DEFINE PRODUTO  	05
#DEFINE LOCAL		06
#DEFINE QTD 		07
#DEFINE PRI			08
#DEFINE PRF			09
#DEFINE EMISSAO 	10
#DEFINE DEMIS   	11
#DEFINE OBS		   	12
#DEFINE PRODESC   	13

/*
Programa  - FormPro
Autor     - Marcos Cesar 
Data      - 22/09/2021
Descrição - Emissão de Formulários de Controle de Produção
*/
User Function FormPro(cNumOp,cPasta)

	Local oForm		:= Nil
	Local cFilename     := 'Form'+dtos(date())+replace(time(),':','')
	Local nDevice       := IMP_PDF  //IMP_SPOOL
	Local lAdjustToLegacy:= .f.
	Local cPathInServer := "\spool\"
	Local lDisableSetup := .t.

	Local cPerg	:= PadR("FORMCON",10)
	Local aForm := {}

	Local lJob := (select("SX6") == 0)
	Local nI   := 0

	Default cNumOp := ""
	Default cPasta := "c:\temp\" 	//GetNewPar( "MV_XPASETQ", "C:\FORMULARIOS PCP\")

	If lJob
		RpcSetType( 3 )
		RpcSetEnv( '01', '0101')
		//if empty(cNumOp)
		//	cNumOp := "000201"	//Para testes
		//endif
	endif

	if !empty(cNumOp)
		PopForm(@aForm,cNumOp)
	else
		if fPrepara(cPerg,cPasta)
			cPasta := mv_par01
			if !ExistDir( substr(cPasta,1,len(cPasta)-1) )
				if MakeDir( substr(cPasta,1,len(cPasta)-1) ) != 0
					msginfo( "Não foi possível criar o diretório. Erro: " + cValToChar( FError() ) )
				endif
			endif
			Processa({|| aForm := fPrcTela() })
		endif
	endif
	If len(aForm) > 0 .and. (!empty(cNumOp) .or. MsgYesNo("Confirma a Impressão dos Formulários ?") )

		oForm:=FwMSPrinter():New(cFilename, nDevice, lAdjustToLegacy, cPathInServer, lDisableSetup,,,,.t./*lServer*/, /*lPDFAsPNG*/, /*lRaw*/, .t./*lViewPDF*/ )
		//oForm:SetResolution(nResol)
		//oForm:SetLandscape()	//paisagem
		oForm:SetPortrait()	//retrato
		oForm:SetPaperSize(DMPAPER_A4)
		//oForm:SetMargin(0,0,0,0) // nEsquerda, nSuperior, nDireita, nInferior
		oForm:cPathPDF := alltrim(cPasta)

		for nI := 1 to 2
			MsAguarde( {|| ImpForm(oForm,aForm,nI) },"Imprimindo Formulários...")
		next

		oForm:Preview() //Visualiza antes de imprimir
		FreeObj(oForm)
		oForm := Nil

	endif

Return .t.


Static Function ImpForm(oForm,aForm,nTipo)

	Local nQtdPag		:= 34	//+iif(ntipo==1,2,0)		//códigos por página
	Local nTFor			:= len(aForm)
	Local nFor          := 0
	Local nTpag			:= 0
	Local nPag			:= 0
	Local nLin			:= 0

	Local cNomeRel  := ""
	//Local cDatIni	:= ""
	//Local cDatEnt	:= ""
	//Local dDatIni
	//Local dDatEnt
	Local nQtdPro	:= 0
	//Local cObs		:= ""

	Local cPart1	:= ""
	Local cPart2	:= ""
	Local cPart3	:= ""
	Local cNumSer	:= ""

	Private nCol	:= 10
	Private oArial10  := TFont():New("Arial"	,10,10,,.F.,,,,.F.,.F.)		// Negrito
	Private oArial10N := TFont():New("Arial"	,10,10,,.T.,,,,.F.,.F.)		// Negrito
	Private oArial16N := TFont():New("Arial"	,16,16,,.T.,,,,.F.,.F.)		// Negrito
	Private oArial18N := TFont():New("Arial"	,18,18,,.T.,,,,.F.,.F.)		// Negrito
	//Private oPen	:= TPen():New(0,5,CLR_BLACK)

	if nTipo == 1
		cNomeRel := GetNewPar( "MV_XNOFOR1", "ORDEM DE PRODUÇÃO")
		//cFilename := 'FormOP'+dtos(date())+replace(time(),':','')

	else
		cNomeRel := GetNewPar( "MV_XNOFOR2", "CHECKLIST DE INSPEÇÃO")
		//cFilename := 'FormCI'+dtos(date())+replace(time(),':','')
	endif

	ProcRegua(nTFor)

	for nFor := 1 to nTFor

		IncProc("Aguarde Imprimindo Formulários...")

		oForm:StartPage()

		nQtdPro := aForm[nFor,QTD]
		cPart1  := aForm[nFor,NUMERO]
		cPart3  := Month2Str(aForm[nFor,DEMIS])+Substr(Year2Str(aForm[nFor,DEMIS]),3,2)

		if nQtdPro > nQtdPag
			nTpag := int(nQtdPro/nQtdPag)+1
		else
			nTpag := 1
		endif

		nPag := 1
		nLin := cabForm(aForm, oForm, cNomeRel, nFor, nPag, nTpag, nTipo)

		//Corpo
		nI := 1
		nQtdImp := 0
		nLin += 020
		while nI <= nQtdPro
			cPart2  := strzero(nI,3)
			cNumSer := cPart1+"."+cPart2+"."+cPart3
			nI+=1
			nQtdImp+=1

			if nQtdImp > nQtdPag
				nQtdImp := 1
				rodForm(oForm, nLin, nTipo)
				oForm:EndPage()
				oForm:StartPage()
				nPag += 1
				nLin := cabForm(aForm, oForm, cNomeRel, nFor, nPag, nTpag, nTipo)
				nLin += 20
			endif

			nLin += 015
			oForm:Box(nLin    ,nCol    ,nLin+015,nCol+095 )
			oForm:Say(nLin+010,ncol+017,cNumSer,oArial10N)
			if nTipo == 1
				oForm:Box(nLin    ,nCol+095,nLin+015,nCol+160 )
				oForm:Box(nLin    ,nCol+160,nLin+015,nCol+212 )
				oForm:Box(nLin    ,nCol+212,nLin+015,nCol+264 )
				oForm:Box(nLin    ,nCol+265,nLin+015,nCol+330 )
				oForm:Box(nLin    ,nCol+330,nLin+015,nCol+372 )
				oForm:Box(nLin    ,nCol+372,nLin+015,nCol+415 )
				oForm:Box(nLin    ,nCol+415,nLin+015,nCol+480 )
				oForm:Box(nLin    ,nCol+480,nLin+015,nCol+522 )
				oForm:Box(nLin    ,nCol+522,nLin+015,nCol+570 )
			else
				oForm:Box(nLin    ,nCol+095,nLin+015,nCol+130 )
				oForm:Box(nLin    ,nCol+130,nLin+015,nCol+165 )
				oForm:Box(nLin    ,nCol+165,nLin+015,nCol+200 )
				oForm:Box(nLin    ,nCol+200,nLin+015,nCol+235 )
				oForm:Box(nLin    ,nCol+235,nLin+015,nCol+270 )
				oForm:Box(nLin    ,nCol+270,nLin+015,nCol+305 )
				oForm:Box(nLin    ,nCol+305,nLin+015,nCol+340 )
				oForm:Box(nLin    ,nCol+340,nLin+015,nCol+395 )
				oForm:Box(nLin    ,nCol+395,nLin+015,nCol+460 )
				oForm:Box(nLin    ,nCol+460,nLin+015,nCol+570 )
			endif

		end

		while nQtdImp < nQtdPag
			nQtdImp+=1
			nLin += 015
			oForm:Box(nLin    ,nCol    ,nLin+015,nCol+095 )
			if nTipo == 1
				oForm:Box(nLin    ,nCol+095,nLin+015,nCol+160 )
				oForm:Box(nLin    ,nCol+160,nLin+015,nCol+212 )
				oForm:Box(nLin    ,nCol+212,nLin+015,nCol+264 )
				oForm:Box(nLin    ,nCol+265,nLin+015,nCol+330 )
				oForm:Box(nLin    ,nCol+330,nLin+015,nCol+372 )
				oForm:Box(nLin    ,nCol+372,nLin+015,nCol+415 )
				oForm:Box(nLin    ,nCol+415,nLin+015,nCol+480 )
				oForm:Box(nLin    ,nCol+480,nLin+015,nCol+522 )
				oForm:Box(nLin    ,nCol+522,nLin+015,nCol+570 )
			else
				oForm:Box(nLin    ,nCol+095,nLin+015,nCol+130 )
				oForm:Box(nLin    ,nCol+130,nLin+015,nCol+165 )
				oForm:Box(nLin    ,nCol+165,nLin+015,nCol+200 )
				oForm:Box(nLin    ,nCol+200,nLin+015,nCol+235 )
				oForm:Box(nLin    ,nCol+235,nLin+015,nCol+270 )
				oForm:Box(nLin    ,nCol+270,nLin+015,nCol+305 )
				oForm:Box(nLin    ,nCol+305,nLin+015,nCol+340 )
				oForm:Box(nLin    ,nCol+340,nLin+015,nCol+395 )
				oForm:Box(nLin    ,nCol+395,nLin+015,nCol+460 )
				oForm:Box(nLin    ,nCol+460,nLin+015,nCol+570 )
			endif
		end

		rodForm(oForm, nLin, nTipo)
		oForm:EndPage()

	next

Return

Static function cabForm(aForm, oForm, cNomeRel, nFor, nPag, nTpag, nTipo)

	Local cNumForm  := GetNewPar( "MV_XNUMFOR", "RSGQ-26")
	Local cRevForm  := GetNewPar( "MV_XREVFOR", "01")
	Local cDRevForm := GetNewPar( "MV_XDREVFO", "20210729")

	Local cLogo	  := 'ecopro.bmp'
	Local oBrush1 := TBrush():New( , CLR_GRAY)

	Local cNumOp  := aForm[nFor,NUMERO]
	Local cCodPro := aForm[nFor,PRODUTO]
	Local cDesPro := Upper(alltrim(aForm[nFor,PRODESC]))

	Local cDatIni := aForm[nFor,PRI]
	Local dDatIni := CtoD(cDatIni)
	Local cDatEnt := aForm[nFor,PRF]
	Local dDatEnt := CtoD(cDatEnt)
	Local nQtdPro := aForm[nFor,QTD]
	Local cObs	  := aForm[nFor,OBS]

	Local nLin := 10

	oForm:SayBitmap(nLin+15, ncol, cLogo , 150/*nWidth-largura*/, 050/*nHeigth-Altura*/)

	oForm:Box(nLin    ,nCol+170,nLin+090,nCol+390 )
	oForm:Say(nLin+050,ncol+195,cNomeRel,oArial18N)

	oForm:Box(nLin    ,nCol+400,nLin+042,nCol+480 )
	oForm:Say(nLin+020,ncol+425,"NÚMERO",oArial10N)
	oForm:Say(nLin+030,ncol+425,cNumForm,oArial10N)

	oForm:Box(nLin+046,nCol+400,nLin+090,nCol+480 )
	oForm:Say(nLin+066,ncol+425,"REVISÃO",oArial10N)
	oForm:Say(nLin+076,ncol+440,cRevForm ,oArial10N)

	oForm:Box(nLin    ,nCol+490,nLin+042,nCol+570 )
	oForm:Say(nLin+020,ncol+515,"PÁGINA",oArial10N)
	oForm:Say(nLin+030,ncol+522,alltrim(str(nPag))+"/"+alltrim(str(nTpag)),oArial10N)

	oForm:Box(nLin+046,nCol+490,nLin+090,nCol+570 )
	oForm:Say(nLin+066,ncol+520,"DATA",oArial10N)
	oForm:Say(nLin+076,ncol+515,DtoC(StoD(cDRevForm)) ,oArial10N)

	//Linha 2
	nLin += 095
	oForm:Box(nLin    ,nCol    ,nLin+025,nCol+120 )
	oForm:Say(nLin+015,ncol+005,"NÚMERO OP:",oArial10N)
	oForm:Say(nLin+015,ncol+065,cNumOp      ,oArial10)

	oForm:Box(nLin    ,nCol+120,nLin+025,nCol+260 )
	oForm:Say(nLin+015,ncol+125,"CÓDIGO:"   ,oArial10N)
	oForm:Say(nLin+015,ncol+170,cCodPro     ,oArial10)

	oForm:Box(nLin    ,nCol+260,nLin+025,nCol+570 )
	oForm:Say(nLin+015,ncol+265,"DESCRIÇÃO:" ,oArial10N)
	oForm:Say(nLin+015,ncol+320,cDesPro     ,oArial10)

	if nTipo == 1
		nLin += 025
		oForm:Box(nLin    ,nCol    ,nLin+025,nCol+285 )
		oForm:Fillrect( { nLin ,nCol ,nLin+025 ,nCol+60 }, oBrush1, "-1")
		oForm:Say(nLin+015,ncol+005,"DATA INÍCIO:" ,oArial10N,,CLR_WHITE)
		oForm:Say(nLin+015,ncol+065,cDatIni+"  -  "+DiaSemana(dDatIni),oArial10)

		oForm:Box(nLin    ,nCol+285,nLin+025,nCol+570 )
		oForm:Fillrect( { nLin ,nCol+285,nLin+025,nCol+370 }, oBrush1, "-1")
		oForm:Say(nLin+015,ncol+290,"DATA DE ENTREGA:",oArial10N,,CLR_WHITE)
		oForm:Say(nLin+015,ncol+390,cDatEnt+"  -  "+DiaSemana(dDatEnt) ,oArial10)

		nLin += 030
		oForm:Box(nLin    ,nCol    ,nLin+010,nCol+095 )
		oForm:Say(nLin+008,ncol+020,"QUANTIDADE" ,oArial10N)
		oForm:Box(nLin    ,nCol+095,nLin+010,nCol+570 )
		oForm:Fillrect( { nLin,nCol+095,nLin+010,nCol+570 }, oBrush1, "-1")
		oForm:Say(nLin+008,ncol+290,"OBSERVAÇÃO" ,oArial10N,,CLR_WHITE)
		oForm:Box(nLin+010,nCol    ,nLin+030,nCol+095 )
		oForm:Fillrect( { nLin+010,nCol,nLin+030,nCol+095 }, oBrush1, "-1")
		oForm:Say(nLin+025,ncol+040,alltrim(str(nQtdPro)) ,oArial16N,,CLR_WHITE)
		oForm:Box(nLin+010,nCol+095,nLin+030,nCol+570 )
		//oForm:Say(nLin+022,ncol+100,cObs        ,oArial10N)
		if len(alltrim(cObs)) > 94
			oForm:SayAlign(nLin+010,ncol+100,alltrim(cObs),oArial10N,470/*LargPixel*/,28/*AlturaPixel*/, ,2,1)
		else
			oForm:SayAlign(nLin+014,ncol+100,alltrim(cObs),oArial10N,470/*LargPixel*/,28/*AlturaPixel*/, ,2,1)
		endif

		nLin += 035
		oForm:Box(nLin    ,nCol    ,nLin+010,nCol+570 )
		oForm:Fillrect( { nLin,nCol,nLin+010,nCol+570 }, oBrush1, "-1")
		oForm:Say(nLin+008,ncol+240,"PRODUÇÃO" ,oArial10N,,CLR_WHITE)
		oForm:Box(nLin+010,nCol    ,nLin+035,nCol+265 )
		oForm:Say(nLin+025,ncol+005,"DATA INÍCIO:" ,oArial10N)
		//oForm:Box(nLin+010,nCol+095,nLin+035,nCol+265 )
		oForm:Box(nLin+010,nCol+265,nLin+035,nCol+570 )
		oForm:Say(nLin+025,ncol+270,"DATA TÉRMINO:" ,oArial10N)
		//oForm:Box(nLin+010,nCol+360,nLin+035,nCol+570 )
		nLin += 040
		oForm:Box(nLin    ,nCol    ,nLin+010,nCol+570 )
		oForm:Fillrect( { nLin,nCol,nLin+010,nCol+570 }, oBrush1, "-1")
		oForm:Say(nLin+008,ncol+240,"PRODUTOS" ,oArial10N,,CLR_WHITE)

		oForm:Box(nLin+010,nCol    ,nLin+035,nCol+095 )
		oForm:Say(nLin+020,ncol+025,"NÚMERO DE" ,oArial10N)
		oForm:Say(nLin+030,ncol+035,"SÉRIE" ,oArial10N)

		oForm:Box(nLin+010,nCol+095,nLin+020,nCol+264 )
		oForm:Say(nLin+018,ncol+145,"TESTE HIDROSTÁTICO" ,oArial10N)
		oForm:Box(nLin+010,nCol+265,nLin+020,nCol+570 )
		oForm:Say(nLin+018,ncol+380,"RETRABALHO" ,oArial10N)

		oForm:Box(nLin+020,nCol+095,nLin+035,nCol+160 )
		oForm:Say(nLin+030,ncol+120,"Data" ,oArial10N)
		oForm:Box(nLin+020,nCol+160,nLin+035,nCol+212 )
		oForm:Say(nLin+030,ncol+175,"Resul." ,oArial10N)
		oForm:Box(nLin+020,nCol+212,nLin+035,nCol+264 )
		oForm:Say(nLin+030,ncol+225,"Resp." ,oArial10N)

		oForm:Box(nLin+020,nCol+265,nLin+035,nCol+330 )
		oForm:Say(nLin+030,ncol+288,"Data" ,oArial10N)
		oForm:Box(nLin+020,nCol+330,nLin+035,nCol+372 )
		oForm:Say(nLin+030,ncol+340,"Cód." ,oArial10N)
		oForm:Box(nLin+020,nCol+372,nLin+035,nCol+415 )
		oForm:Say(nLin+030,ncol+382,"Resp." ,oArial10N)

		oForm:Box(nLin+020,nCol+415,nLin+035,nCol+480 )
		oForm:Say(nLin+030,ncol+440,"Data" ,oArial10N)
		oForm:Box(nLin+020,nCol+480,nLin+035,nCol+522 )
		oForm:Say(nLin+030,ncol+495,"Cód." ,oArial10N)
		oForm:Box(nLin+020,nCol+522,nLin+035,nCol+570 )
		oForm:Say(nLin+030,ncol+534,"Resp.",oArial10N)
	else
		nLin += 025
		oForm:Box(nLin+010,nCol    ,nLin+035,nCol+095 )
		oForm:Say(nLin+020,ncol+025,"NÚMERO DE" ,oArial10N)
		oForm:Say(nLin+030,ncol+035,"SÉRIE" ,oArial10N)

		oForm:Box(nLin+010,nCol+095,nLin+020,nCol+570 )
		oForm:Say(nLin+018,ncol+280,"ITEM" ,oArial10N)

		oForm:Box(nLin+020,nCol+095,nLin+035,nCol+130 )
		oForm:Say(nLin+030,ncol+110,"1"     ,oArial10N)
		oForm:Box(nLin+020,nCol+130,nLin+035,nCol+165 )
		oForm:Say(nLin+030,ncol+145,"2"     ,oArial10N)
		oForm:Box(nLin+020,nCol+165,nLin+035,nCol+200 )
		oForm:Say(nLin+030,ncol+180,"3"     ,oArial10N)
		oForm:Box(nLin+020,nCol+200,nLin+035,nCol+235 )
		oForm:Say(nLin+030,ncol+215,"4"     ,oArial10N)
		oForm:Box(nLin+020,nCol+235,nLin+035,nCol+270 )
		oForm:Say(nLin+030,ncol+250,"5"     ,oArial10N)
		oForm:Box(nLin+020,nCol+270,nLin+035,nCol+305 )
		oForm:Say(nLin+030,ncol+285,"6"     ,oArial10N)
		oForm:Box(nLin+020,nCol+305,nLin+035,nCol+340 )
		oForm:Say(nLin+030,ncol+320,"7"     ,oArial10N)
		oForm:Box(nLin+020,nCol+340,nLin+035,nCol+395 )
		oForm:Say(nLin+030,ncol+355,"DATA"  ,oArial10N)
		oForm:Box(nLin+020,nCol+395,nLin+035,nCol+460 )
		oForm:Say(nLin+030,ncol+398,"RESPONSÁVEL",oArial10N)
		oForm:Box(nLin+020,nCol+460,nLin+035,nCol+570 )
		oForm:Say(nLin+030,ncol+485,"OBSERVAÇÃO",oArial10N)

	endif

Return nLin


Static function rodForm(oForm, nLin, nTipo)

	if nTipo == 2
		nLin += 025
		oForm:Box(nLin    ,nCol    ,nLin+015,nCol+283 )
		oForm:Say(nLin+010,ncol+100,"LEGENDA RESERVATÓRIOS",oArial10N)

		oForm:Box(nLin+015,nCol    ,nLin+030,nCol+142 )
		oForm:Say(nLin+025,ncol+010,"1 – Acabamento Externo",oArial10N)
		oForm:Box(nLin+015,nCol+142,nLin+030,nCol+283 )
		oForm:Say(nLin+025,ncol+152,"5 – Tubos",oArial10N)
		oForm:Box(nLin+030,nCol    ,nLin+045,nCol+142 )
		oForm:Say(nLin+040,ncol+010,"2 – Etiquetas",oArial10N)
		oForm:Box(nLin+030,nCol+142,nLin+045,nCol+283 )
		oForm:Say(nLin+040,ncol+152,"6 – Pés",oArial10N)
		oForm:Box(nLin+045,nCol    ,nLin+060,nCol+142 )
		oForm:Say(nLin+055,ncol+010,"3  – Rebites",oArial10N)
		oForm:Box(nLin+045,nCol+142,nLin+060,nCol+283 )
		oForm:Say(nLin+055,ncol+152,"7 - Tipo do Inox (etiqueta)",oArial10N)
		oForm:Box(nLin+060,nCol    ,nLin+075,nCol+142 )
		oForm:Say(nLin+070,ncol+010,"4 – Elétrica (se aplicável)",oArial10N)
		oForm:Box(nLin+060,nCol+142,nLin+075,nCol+283 )

		oForm:Box(nLin    ,nCol+286,nLin+015,nCol+570 )
		oForm:Say(nLin+010,ncol+380,"LEGENDA COLETORES",oArial10N)

		oForm:Box(nLin+015,nCol+286,nLin+030,nCol+426 )
		oForm:Say(nLin+025,ncol+296,"1 – Acabamento Externo",oArial10N)
		oForm:Box(nLin+015,nCol+426,nLin+030,nCol+570 )
		oForm:Say(nLin+025,ncol+436,"3  – Rebites",oArial10N)
		oForm:Box(nLin+030,nCol+286,nLin+045,nCol+426 )
		oForm:Say(nLin+040,ncol+296,"2 – Etiquetas",oArial10N)
		oForm:Box(nLin+030,nCol+426,nLin+045,nCol+570 )
		oForm:Say(nLin+040,ncol+436,"4 – Vidros",oArial10N)
		oForm:Box(nLin+045,nCol+286,nLin+060,nCol+426 )
		oForm:Box(nLin+045,nCol+426,nLin+060,nCol+570 )
		oForm:Box(nLin+060,nCol+286,nLin+075,nCol+426 )
		oForm:Box(nLin+060,nCol+426,nLin+075,nCol+570 )

		nLin += 085
		oForm:Box(nLin    ,nCol    ,nLin+015,nCol+570 )
		oForm:Say(nLin+008,ncol+260,"Observação",oArial10N)
		oForm:Box(nLin+015,nCol    ,nLin+030,nCol+570 )
		oForm:Box(nLin+030,nCol    ,nLin+045,nCol+570 )

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


Static Function fPrcTela()

	Local oTela, oBrwEtq, oBotaoE, oBotaoM, oBotaoD, oBotaoS

	Local oMarca := LoadBitmap(GetResources(),"LBTIK")
	Local oDesma := LoadBitmap(GetResources(),"LBNO")

	Local aForm := {}
	Local aSform := {}

	PopForm(@aForm,)

	if len(aForm) > 0

		DEFINE MSDIALOG oTela TITLE "Controle de Produção Etiquetas - Total (" + AllTrim(Str(Len(aForm),6))+') ' FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

		@ 010, 005 LISTBOX oBrwEtq Fields HEADER '','Numero',"Item","Sequência","Produto","Local", "Qtd", "Emissão", "Cód.Etiqueta" SIZE 490, 210 OF oTela PIXEL ColSizes 50,50

		@ 230, 005 BUTTON oBotaoE PROMPT "&Gerar Formulários"	ACTION MsAguarde( {|| (aSform:=PrcEtq(oBrwEtq:aArray) ,Iif(len(aSform)>0,oTela:End(),.t.))},"Gerando Etiquetas....") 	SIZE 060, 010 OF oTela PIXEL
		@ 230, 075 BUTTON oBotaoM PROMPT "&Marca Todas" 		ACTION MsAguarde( {|| (MarcaTodas(@oBrwEtq:aArray)   ,oBrwEtq:Refresh())                },"Marcando Etiquetas...") 	SIZE 060, 010 OF oTela PIXEL
		@ 230, 145 BUTTON oBotaoD PROMPT "&Desmarca Todas" 		ACTION MsAguarde( {|| (DesMarcaTodas(@oBrwEtq:aArray),oBrwEtq:Refresh())                },"Desmarcando Etiquetas") 	SIZE 060, 010 OF oTela PIXEL
		@ 230, 425 BUTTON oBotaoS PROMPT "&Sair" 				ACTION ( oTela:End(), aSform := {} ) 	                                                                        	SIZE 060, 010 OF oTela PIXEL

		oBrwEtq:SetArray(aForm)
		oBrwEtq:nAt := 1
		oBrwEtq:bLDblClick := {|| ( dblClick(oBrwEtq:nAt,@oBrwEtq:aArray),oBrwEtq:Refresh() ) }
		oBrwEtq:bLine := {|| {	Iif(aForm[oBrwEtq:nAt,MARCA]=='1',oMarca,oDesma),;
			aForm[oBrwEtq:nAt,NUMERO],;
			aForm[oBrwEtq:nAt,ITEM],;
			aForm[oBrwEtq:nAt,SEQ],;
			aForm[oBrwEtq:nAt,PRODUTO],;
			aForm[oBrwEtq:nAt,LOCAL],;
			TransForm(aForm[oBrwEtq:nAt,QTD],'@E 999,999,999.99'),;
			aForm[oBrwEtq:nAt,EMISSAO];
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
		MsgStop("Atenção Nenhum formulário gerado !")
	Endif

Return aSform


Static Function PopForm(aForm,cNumOp)

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
	TCSetField( 'tsc2', 'C2_DATPRI' , 'D', TamSX3('C2_DATPRI')[01], TamSX3('C2_DATPRI')[02] )
	TCSetField( 'tsc2', 'C2_DATPRF' , 'D', TamSX3('C2_DATPRF')[01], TamSX3('C2_DATPRF')[02] )

	Count To nTReg
	if nTReg > 0
		tsc2->(dbGoTop())

		ProcRegua(nTReg)
		While !tsc2->(Eof())
			nReg += 1
			IncProc("Localizando (" + AllTrim(Str(nReg,6))+") Controle de Produção...")

			AAdd(aForm,  {	'2',;
				tsc2->c2_num,;
				tsc2->c2_item,;
				tsc2->c2_sequen,;
				tsc2->c2_produto,;
				tsc2->c2_local,;
				tsc2->c2_quant,;
				dtoc(tsc2->c2_datpri),;
				dtoc(tsc2->c2_datprf),;
				dtoc(tsc2->c2_emissao),;
				tsc2->c2_emissao,;
				tsc2->c2_obs,;
				tsc2->b1_desc ;
				};
				)

			tsc2->(dbSkip())
		End
	endif
	tsc2->(dbCloseArea())

Return


Static Function PrcEtq(aForm)

	Local nI   := 0
	Local aSform := {}

	For nI := 1 To Len(aForm)
		If aForm[nI,MARCA]=='1'
			aadd( aSform, aForm[nI] )
		Endif
	Next
	if len(aSform) == 0
		msginfo("Nenhum Controle de Produção foi marcado!")
	endif

Return aSform


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
