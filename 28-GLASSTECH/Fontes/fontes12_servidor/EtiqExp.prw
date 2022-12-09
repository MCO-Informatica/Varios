#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

#DEFINE IMP_SPOOL 2

#DEFINE VBOX       080
#DEFINE VSPACE     008
#DEFINE HSPACE     010
#DEFINE SAYVSPACE  008
#DEFINE SAYHSPACE  008
#DEFINE HMARGEM    030
#DEFINE VMARGEM    030
#DEFINE MAXITEM    022  // Máximo de produtos para a primeira página
#DEFINE MAXITEMP2  049  // Máximo de produtos para a pagina 2 em diante
#DEFINE MAXITEMP2F 069  // Máximo de produtos para a página 2 em diante quando a página não possui informações complementares
#DEFINE MAXITEMP3  025  // Máximo de produtos para a pagina 2 em diante (caso utilize a opção de impressao em verso) - Tratamento implementado para atender a legislacao que determina que a segunda pagina de ocupar 50%.
#DEFINE MAXITEMC   038  // Máxima de caracteres por linha de produtos/serviços
#DEFINE MAXMENLIN  080  // Máximo de caracteres por linha de dados adicionais
#DEFINE MAXMSG     013  // Máximo de dados adicionais por página
#DEFINE MAXVALORC  009  // Máximo de caracteres por linha de valores numéricos

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ImpEtiRom ³ Autor ³ Sérgio Santana        ³ Data ³29.03.2016³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Rdmake de para impressão das embalagens via Pedido/Ordens de³±±
±±³          ³separações                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³ Exclusivo     ³Thermoglass                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function EtiqExp()

Local oEtiq
Local oSetup
Local cFilePrint := 'Teste.pdf'
Local lExist     := .F.
Local lEnd       := .F.
Local nFlags     := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
Local cCaminho   := 'c:\spool\'

Private lMv_Logod     := If(GetNewPar("MV_LOGOD", "N" ) == "S", .T., .F.   )
Private nConsNeg := 0.4 // Constante para concertar o cálculo retornado pelo GetTextWidth para fontes em negrito.
Private nConsTex := 0.5 // Constante para concertar o cálculo retornado pelo GetTextWidth.

_cFilCB0 := xFilial( 'CB0' )
_cFilCB8 := xFilial( 'CB8' )
_cFilCB9 := xFilial( 'CB9' )

CB9->( dbSetOrder( 3 ) )

oSetup:=FWPrintSetup():New(nFlags, "EXPEDICAO")
oSetup:SetPropert(PD_PRINTTYPE , 6)//ou 1 verificar
oSetup:SetPropert(PD_ORIENTATION , 1)
oSetup:SetPropert(PD_DESTINATION , 1)
oSetup:SetPropert(PD_MARGIN , {60,60,60,60})
oSetup:SetPropert(PD_PAPERSIZE , 2)
oSetup:aOptions[PD_VALUETYPE] := cCaminho

oEtiq := FWMSPrinter():New(cFilePrint, IMP_SPOOL /*IMP_PDF*/, .F. ,cCaminho, .T., , , , , .F., ,.F. , )

oEtiq:SetResolution(78) //Tamanho estipulado para a Etiqueta embalagem
oEtiq:SetPortrait()
oEtiq:SetPaperSize(DMPAPER_A4)
oEtiq:SetMargin(60,60,60,60)
oEtiq:lServer := oSetup:GetProperty(PD_DESTINATION)==AMB_SERVER
// ----------------------------------------------
// Define saida de impressão
// ----------------------------------------------
If oSetup:GetProperty(PD_PRINTTYPE) == IMP_SPOOL
	oEtiq:nDevice := IMP_SPOOL
	// ----------------------------------------------
	// Salva impressora selecionada
	// ----------------------------------------------
	fwWriteProfString(GetPrinterSession(),"DEFAULT", oSetup:aOptions[PD_VALUETYPE], .T.)
	oEtiq:cPrinter := oSetup:aOptions[PD_VALUETYPE]

ElseIf oSetup:GetProperty(PD_PRINTTYPE) == IMP_PDF
	oEtiq:nDevice := IMP_PDF
	// ----------------------------------------------
	// Define para salvar o PDF
	// ----------------------------------------------
	oEtiq:cPathPDF := oSetup:aOptions[PD_VALUETYPE]
Endif

Private PixelX := oEtiq:nLogPixelX()
Private PixelY := oEtiq:nLogPixelY()

RptStatus({|lEnd| EtiqProc(@oEtiq,@lEnd,@lExist)},"Imprimindo etiqueta Expedição...")

If lExist
	oEtiq:Preview()//Visualiza antes de imprimir
Else
	Aviso("DANFE","Nenhuma NF-e a ser impressa nos parametros utilizados.",{"OK"},3)
EndIf
FreeObj(oEtiq)
oEtiq := Nil

Return(.T.)

Static Function EtiqProc(oEtiq,lEnd,lExist)

Local cLogo        := FisxLogo("1")
Local nWidth  := 0.050
Local nHeigth := 0.75
Local oPr

PRIVATE oFont10N   := TFontEx():New(oEtiq,"Times New Roman",08,08,.T.,.T.,.F.)// 1
PRIVATE oFont07N   := TFontEx():New(oEtiq,"Times New Roman",06,06,.T.,.T.,.F.)// 2
PRIVATE oFont07    := TFontEx():New(oEtiq,"Times New Roman",06,06,.F.,.T.,.F.)// 3
PRIVATE oFont08    := TFontEx():New(oEtiq,"Times New Roman",07,07,.F.,.T.,.F.)// 4
PRIVATE oFont08N   := TFontEx():New(oEtiq,"Times New Roman",06,06,.T.,.T.,.F.)// 5
PRIVATE oFont40N   := TFontEx():New(oEtiq,"Times New Roman",40,40,.T.,.T.,.F.)// 6
PRIVATE oFont09    := TFontEx():New(oEtiq,"Times New Roman",08,08,.F.,.T.,.F.)// 7
PRIVATE oFont10    := TFontEx():New(oEtiq,"Times New Roman",09,09,.T.,.T.,.F.)// 8
PRIVATE oFont11    := TFontEx():New(oEtiq,"Times New Roman",10,10,.F.,.T.,.F.)// 9
PRIVATE oFont12    := TFontEx():New(oEtiq,"Times New Roman",18,18,.T.,.T.,.F.)// 10
PRIVATE oFont11N   := TFontEx():New(oEtiq,"Times New Roman",10,10,.T.,.T.,.F.)// 11
PRIVATE oFont18N   := TFontEx():New(oEtiq,"Times New Roman",54,54,.T.,.T.,.F.)// 12 
PRIVATE oFONT12N   := TFontEx():New(oEtiq,"Times New Roman",20,20,.T.,.T.,.F.)// 12 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao do objeto grafico                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If oEtiq == Nil
	lPreview := .T.
	oEtiq 	:= FWMSPrinter():New("EXPEDICAO", IMP_SPOOL)
	oEtiq:SetPortrait()
	oEtiq:Setup()
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicializacao da pagina do objeto grafico                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oEtiq:StartPage()
nHPage := oEtiq:nHorzRes()
nHPage *= (300/PixelX)
nHPage -= HMARGEM
nVPage := oEtiq:nVertRes()
nVPage *= (300/PixelY)
nVPage -= VBOX

oEtiq:Box(000,000,055,601)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Logotipo                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lMv_Logod
	cGrpCompany	:= AllTrim(FWGrpCompany())
	cCodEmpGrp	:= AllTrim(FWCodEmp())
	cUnitGrp	:= AllTrim(FWUnitBusiness())
	cFilGrp		:= AllTrim(FWFilial())

	If !Empty(cUnitGrp)
		cDescLogo	:= cGrpCompany + cCodEmpGrp + cUnitGrp + cFilGrp
	Else
		cDescLogo	:= cEmpAnt + cFilAnt
	EndIf

	cLogoD := GetSrvProfString("Startpath","") + "DANFE" + cDescLogo + ".BMP"
	If !File(cLogoD)
		cLogoD	:= GetSrvProfString("Startpath","") + "DANFE" + cEmpAnt + ".BMP"
		If !File(cLogoD)
			lMv_Logod := .F.
		EndIf
	EndIf
EndIf

_cEtiq := ' '
_nLin  := 002

While ! CB0->( Eof() )

    If CB0->CB0_CODETI <> _cEtiq
    
        _cEtiq := CB0->CB0_CODETI
	    
	    If lMv_Logod

	       oEtiq:SayBitmap(_nLin,005,cLogoD,095,052)

	    Else

	       oEtiq:SayBitmap(_nLin,005,cLogo,095,052)

	    End
	   
	    _nLin += 38 // 40
		
	    oEtiq:Say(_nLin,170, "E X P E D I Ç Ã O",oFont40N:oFont)

	    _nLin += 17 // 57
		
	    oEtiq:Box(_nLin,000,_nLin+45,601)

	    _nLin +=	7  // 64

	    oEtiq:Say(_nLin,002, "Pedido"  , oFont10:oFont)
	    oEtiq:Say(_nLin,350, "Romaneio", oFont10:oFont)
		
        CB9->( dbSeek( _cFilCB9 + CB0->CB0_CODPRO + CB0->CB0_CODETI, .F. ) )

	    _nLin += 28 // 092
	    oEtiq:Say(_nLin,062, CB0->CB0_PEDVEN, oFont18N:oFont)
	    oEtiq:Say(_nLin,420, CB9->CB9_ORDSEP, oFont18N:oFont)

		_nLin += 9 //  106
	    oEtiq:Box(_nLin,000,_nLin+30,601)
		
        _nLin += 7  // 113
	    oEtiq:Say(_nLin,002, "Cliente", oFont10:oFont)
	    oEtiq:Say(_nLin,400, "Cidade", oFont10:oFont)

        SC5->( dbSeek( _cFilSC5 + CB9->CB9_PEDIDO, .F. ) )
        SA1->( dbSeek( _cFilSA1 + SC5->C5_CLIENTE + SC5->C5_LOJA, .F. ) )
		
        _nLin += 17  // 130
	    oEtiq:Say(_nLin,002, SA1->A1_NOME, oFont12:oFont)
	    oEtiq:Say(_nLin,400, SA1->A1_MUN , oFont12:oFont)

        _nLin += 16  // 146
	    oEtiq:Box(_nLin,000,_nLin+30,601)
	   
	    _nLin += 9  // 153
	    oEtiq:Say(_nLin,002, "TRANSPORTADORA", oFont10:oFont)

	    _nLin += 17 // 170
	    oEtiq:Say(_nLin,002, "TRANSPORTADORA", oFont12:oFont)
	   
	End		

  	_nLin += 16 // 186
  	oEtiq:Box(_nLin,000,_nLin+30,601)
  	
  	_nLin += 7 // 193
	oEtiq:Say(_nLin,002, "Código"    , oFont10:oFont)
	oEtiq:Say(_nLin,400, "Quantidade", oFont10:oFont)
	
    _nLin += 17 // 210
	oEtiq:Say(_nLin,002, CB0->CB0_CODPRO, oFont12:oFont)
	oEtiq:Say(_nLin,550, CB0->CB0_QTDE  , oFont12N:oFont)
	
	CB0->( dbSkip() )
	
	If CB0->CB0_CODETI <> _cEtiq

       _nLin += 10  // 220
       oEtiq:Box(_nLin,000,_nLin+60,601)
       oEtiq:Box(_nLin,000,_nLin+60,101)
       oEtiq:Box(_nLin,501,_nLin+60,601)
	
	   _nLin += 40 //260
	   oEtiq:Code128C(_nLin,010,CB0->CB0_CODETI, 28 )
	
	   _nLin -= 25 // 235
	   oEtiq:Say(_nLin,130, "Caixa N°", oFont12:oFont)
	   _nLin += 5 // 240
	   oEtiq:Say(_nLin,510, DtoC( dDataBase )     , oFont12:oFont)
	   _nLin += 15 //265
	   oEtiq:Say(_nLin,510, Substr( Time(), 1, 5 ), oFont12:oFont)
	   _nLin += 5 // 270
	   oEtiq:Say(_nLin,025, CB0->CB0_CODETI, oFont10:oFont)
	   _nlin += 20 // 290

	   oEtiq:Say(_nLin,002, "Não nos responsabilizamos por alterações manuscritas", oFont10:oFont)
	   
	   _nLin += 10

	End

End	

lExist := .T.
lEnd   := .T.

Return( oEtiq, .T., .T. )