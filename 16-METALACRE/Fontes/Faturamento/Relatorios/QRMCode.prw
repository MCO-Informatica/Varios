#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"                                                                                                         
#INCLUDE "RPTDEF.CH"  
#INCLUDE "FWPrintSetup.ch"

User Function QRMCode()
Local oPrinter        
Local cTexto := '000750799800021499123450881512346280003000019101'
oFont1 := TFont():New( "Arial",,9,.t.,.t.,,,,,.f. )

lAdjustToLegacy := .T. //.F.
lDisableSetup := .T.
oPrinter := FWMSPrinter():New('qrcode', IMP_PDF, lAdjustToLegacy, , lDisableSetup)
oPrinter:SetResolution(78)
oPrinter:SetPortrait()
oPrinter:SetPaperSize(DMPAPER_A4)
oPrinter:SetMargin(10,10,10,10) // nEsquerda, nSuperior, nDireita, nInferior
oPrinter:cPathPDF := "C:\TEMP\" // Caso seja utilizada impressão em IMP_PDF

oPrinter:Box(040,795,235,2300)
oPrinter:Say( 080, 800, "TESTE IMPRESSÃO CÓDIGO DE BARRAS 2D (DATAMATRIX)",oFont1,100 )
oPrinter:Say( 130, 800, '000750799800021499123450881512346280003000019101',oFont1,100 )
oPrinter:Say( 180, 800, 'PARA PRICE CONSULTORIA - TIAGUITO RSRSRSRSRSRSRS',oFont1,100 )
oPrinter:QRCode(100,100,cTexto, 020)
oPrinter:EndPage()
oPrinter:Preview()
FreeObj(oPrinter)
oPrinter := Nil
Return .t.                             














