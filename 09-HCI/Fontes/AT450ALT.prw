
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AT450ALT  ºAutor  ³Alexandre Circenis  º Data ³  02/26/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AT450ALT()
U_HCCpoOS()
Return    


User Function HCCPOOS()
Local aCampos := {"AB6_CODCLI","AB6_LOJA","AB6_CONPAG","AB6_GPI","AB6_GESTR","AB6_GOP"}
lOCAL nOpcx := 3 // Inclur
Local oDlg         
Local lOk := .F.
INCLUI := .T.

//+--------------------------------------------------------------+
//¦ Inicializa as Variaveis da Enchoice                          ¦
//+--------------------------------------------------------------+
DbSelectArea("SX3")
DbSetOrder(1)
DbSeek("AB6")                      
aEncho := {}
While ( !Eof() .And. SX3->X3_ARQUIVO == "AB6" )
	uCampo := SX3->X3_CAMPO 
	if Ascan(aCampos, Alltrim(uCampo) ) <> 0
		M->&(uCampo) := AB6->(FieldGet(FieldPos(uCampo)))
	EndIf
//	M->AB6_XPREOS := '1' // Incluindo uma Pre OS
	DbSelectArea("SX3")
	DbSkip()
EndDo

Aadd(aCampos,"NOUSER")

aSizeAut := MsAdvSize()	
		
aObjects := {} 
aAdd( aObjects, { 100,  100, .T., .t. } )
aInfo := { aSizeAut[ 1 ], aSizeAut[ 2 ], aSizeAut[ 3 ], aSizeAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjects ) 
		
//?????????????????????????????????????
//?Conta tela de entrada              ?
//?????????????????????????????????????

DEFINE MSDIALOG oDlg TITLE "Dados da Pre Os Faltantes" FROM aSizeAut[7],0 TO aSizeAut[6],aSizeAut[5] PIXEL 
		
	EnChoice( "AB6" ,AB6->(Recno()),nOpcx,,,,aCampos,aPosObj[1],,3,,,,,,.T.)
		
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},nOpcx,)
		

INCLUI := .F.
Return