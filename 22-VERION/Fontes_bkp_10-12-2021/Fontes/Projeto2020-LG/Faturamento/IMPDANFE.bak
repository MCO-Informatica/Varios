#include "rwmake.ch"       
#include "protheus.ch"
#INCLUDE "AP5MAIL.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IMPDANFE   ºAutor  ³Fabio Reis          º Data ³  31/01/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ IMPREDANFE                                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Aumond                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IMPDANFE()

aArea	:= GetArea()
Private aLegenda := { 	{"BR_VERDE", 	"Aprovado" },;	 
						{"BR_VERMELHO", "Em Aprovacao"}}

						
Private cCadastro := "Impressao danfe"   
//Private 	cNumNF    := SF2->F2_DOC        
Private cIdent    := TMSGetIdEnt(.F.) //lUsaColab

private aFilBrw		:=	{'SF2','.t.'}
//Private aRotina := { {"Imprimir","SPEDDANFE" ,0,6} } 		             
Private aRotina := { {"Imprimir","U_fImpDANF(cIdent,SF2->F2_DOC)" ,0,6} } 		             

                    /*
					{"Pesquisar","AxPesqui"  ,0,1}  ,;
		             {"Visualizar","AxVisual" ,0,2}  ,;
					 {"Incluir",'U_AU99INC()' ,0,3}  ,;
					 {"Alterar",'U_AU99ALT()' ,0,4}  ,;
		             {"Excluir","U_AU99EXC"   ,0,5}  ,;//"U_AU99EXC()",0,5},;
		             {"Imprimir","u_AvalMP()" ,0,6}  ,;
		             {"Aprovar","u_AU99APR"     ,0,7}  ,;
		             {"Legenda","BrwLegenda('Legenda', 'Nota de Debíto', aLegenda)"   ,0,8} }
                     */

Private cString := "SF2"


dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,,)
RestArea(aArea)
Return(nil)    
                                               

//*********************
//* função fImpDanfe  *
//*********************


User Function fImpDanf(cIdent,cNumNF)

Local aIndArq   := {}
Local oDanfe
Local nHRes  := 0
Local nVRes  := 0
Local nDevice
Local cFilePrint := ""
Local oSetup
Local aDevice  := {}
Local cSession     := GetPrinterSession()
Local nRet := 0
Local lUsaColab	:= UsaColaboracao("1")

AADD(aDevice,"DISCO") // 1
AADD(aDevice,"SPOOL") // 2
AADD(aDevice,"EMAIL") // 3
AADD(aDevice,"EXCEL") // 4
AADD(aDevice,"HTML" ) // 5
AADD(aDevice,"PDF"  ) // 6

//cIdEnt := GetIdEnt(lUsaColab)         


cFilePrint := "DANFE_"+cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

nLocal       	:= If(fwGetProfString(cSession,"LOCAL","SERVER",.T.)=="SERVER",1,2 )
nOrientation 	:= If(fwGetProfString(cSession,"ORIENTATION","PORTRAIT",.T.)=="PORTRAIT",1,2)
cDevice     	:= If(Empty(fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.)),"PDF",fwGetProfString(cSession,"PRINTTYPE","SPOOL",.T.))
nPrintType      := aScan(aDevice,{|x| x == cDevice })

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Ajuste no pergunte NFSIGW                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//AjustaSX1()

//If IsReady(,,,lUsaColab)
dbSelectArea("SF2")
RetIndex("SF2")
dbClearFilter()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Obtem o codigo da entidade                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//	If nRet >= 20100824

lAdjustToLegacy := .F. // Inibe legado de resolução com a TMSPrinter
oDanfe := FWMSPrinter():New(cFilePrint, IMP_PDF, lAdjustToLegacy, /*cPathInServer*/, .T.)

// ----------------------------------------------
// Cria e exibe tela de Setup Customizavel
// OBS: Utilizar include "FWPrintSetup.ch"
// ----------------------------------------------
//nFlags := PD_ISTOTVSPRINTER+ PD_DISABLEORIENTATION + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
nFlags := PD_ISTOTVSPRINTER + PD_DISABLEPAPERSIZE + PD_DISABLEPREVIEW + PD_DISABLEMARGIN
If ( !oDanfe:lInJob )
	oSetup := FWPrintSetup():New(nFlags, "DANFE")
	// ----------------------------------------------
	// Define saida
	// ----------------------------------------------
	oSetup:SetPropert(PD_PRINTTYPE   , nPrintType)
	oSetup:SetPropert(PD_ORIENTATION , nOrientation)
	oSetup:SetPropert(PD_DESTINATION , nLocal)
	oSetup:SetPropert(PD_MARGIN      , {60,60,60,60})
	oSetup:SetPropert(PD_PAPERSIZE   , 2)
	
	If ExistBlock( "SPNFESETUP" )
		Execblock( "SPNFESETUP" , .F. , .F. , {oDanfe, oSetup} )
	Endif
EndIf

// ----------------------------------------------
// Pressionado botão OK na tela de Setup
// ----------------------------------------------
If oSetup:Activate() == PD_OK // PD_OK =1
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Salva os Parametros no Profile             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	fwWriteProfString( cSession, "LOCAL"      , If(oSetup:GetProperty(PD_DESTINATION)==1 ,"SERVER"    ,"CLIENT"    ), .T. )
	fwWriteProfString( cSession, "PRINTTYPE"  , If(oSetup:GetProperty(PD_PRINTTYPE)==2   ,"SPOOL"     ,"PDF"       ), .T. )
	fwWriteProfString( cSession, "ORIENTATION", If(oSetup:GetProperty(PD_ORIENTATION)==1 ,"PORTRAIT"  ,"LANDSCAPE" ), .T. )
	
	// Configura o objeto de impressão com o que foi configurado na interface.
	oDanfe:setCopies( val( oSetup:cQtdCopia ) )
	
	DbSelectArea("SX1")
	DbSetOrder(1)
	DbSeek("NFSIGW")
	While !Eof() .and. ALLTRIM(SX1->X1_GRUPO) == "NFSIGW"
		IF SX1->X1_ORDEM $ "01/02"
			RecLock("SX1",.F.)
			SX1->X1_CNT01 := cNumNF
			MsUnlock()
		Endif
		
		DbSelectArea("SX1")
		DbSkip()
	Enddo
	
	
	If oSetup:GetProperty(PD_ORIENTATION) == 1
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Danfe Retrato DANFEII.PRW                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		u_PrtNfeSef(cIdEnt,,,oDanfe, oSetup, cFilePrint)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Danfe Paisagem DANFEIII.PRW                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		u_DANFE_P1(cIdEnt,,,oDanfe, oSetup)
	EndIf
	
Else
	MsgInfo("Relatório cancelado pelo usuário.")
	//			Pergunte("NFSIGW",.F.)
	//			bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
	//			Eval(bFiltraBrw)
	Return
Endif
//	EndIf

//	Pergunte("NFSIGW",.F.)
//	bFiltraBrw := {|| FilBrowse(aFilBrw[1],@aIndArq,@aFilBrw[2])}
//	Eval(bFiltraBrw)
//EndIf
oDanfe := Nil
oSetup := Nil
Return()